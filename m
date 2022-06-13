Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3836549C60
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 20:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345190AbiFMS5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 14:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345282AbiFMS4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 14:56:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3661AFF58D
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655136162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ZN1SruJXh6GSm3tIf4Etj3mJf1Qp5u8MmFUMs27FWo=;
        b=ICfLoUGFAQxN+iB8KDKKJYmZ1gKkUxi1u9Utxk2mq2lM35Pw4FnxGeqcLYoJ+bwmjiPFEe
        kfIh8EoXSlqP78cOIJlmGfSLd93/N4GYC5tl7IgA5DHYSI+FgElHgxkyVMMozBRT92zYm5
        WxEe1JfJ4T4jBz0DxiXLayfrJekmHvQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-NTZBAbvNO4OVmWE81gHcEA-1; Mon, 13 Jun 2022 12:02:41 -0400
X-MC-Unique: NTZBAbvNO4OVmWE81gHcEA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4014B2919EA9;
        Mon, 13 Jun 2022 16:02:40 +0000 (UTC)
Received: from localhost (unknown [10.39.194.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E9D442026D2D;
        Mon, 13 Jun 2022 16:02:39 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Auger <eauger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] arm: enable MTE for QEMU + kvm
In-Reply-To: <4bb7b5e4-ceb4-d2d8-e03a-f7059e5158d6@redhat.com>
Organization: Red Hat GmbH
References: <20220512131146.78457-1-cohuck@redhat.com>
 <4bb7b5e4-ceb4-d2d8-e03a-f7059e5158d6@redhat.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Mon, 13 Jun 2022 18:02:38 +0200
Message-ID: <87a6agsg9t.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 10 2022, Eric Auger <eauger@redhat.com> wrote:

> Hi Connie,
>
> On 5/12/22 15:11, Cornelia Huck wrote:
>> This series enables MTE for kvm guests, if the kernel supports it.
>> Lightly tested while running under the simulator (the arm64/mte/
>> kselftests pass... if you wait patiently :)
>> 
>> A new cpu property "mte" (defaulting to on if possible) is introduced;
>> for tcg, you still need to enable mte at the machine as well.
> isn't the property set to off by default when kvm is enabled (because of
> the migration blocker).

Oh, I had changed that around several times, and it seems I ended up
being confused when I wrote this cover letter... I wonder what the best
state would be (assuming that I don't manage to implement it soonish,
but it seems we still would need kernel changes as by the discussion in
that other patch series.)

>
> Eric
>> 
>> I've hacked up some very basic qtests; not entirely sure if I'm going
>> about it the right way.
>> 
>> Some things to look out for:
>> - Migration is not (yet) supported. I added a migration blocker if we
>>   enable mte in the kvm case. AFAIK, there isn't any hardware available
>>   yet that allows mte + kvm to be used (I think the latest Gravitons
>>   implement mte, but no bare metal instances seem to be available), so
>>   that should not have any impact on real world usage.
>> - I'm not at all sure about the interaction between the virt machine 'mte'
>>   prop and the cpu 'mte' prop. To keep things working with tcg as before,
>>   a not-specified mte for the cpu should simply give us a guest without
>>   mte if it wasn't specified for the machine. However, mte on the cpu
>>   without mte on the machine should probably generate an error, but I'm not
>>   sure how to detect that without breaking the silent downgrade to preserve
>>   existing behaviour.
>> - As I'm still new to arm, please don't assume that I know what I'm doing :)
>> 
>> 
>> Cornelia Huck (2):
>>   arm/kvm: enable MTE if available
>>   qtests/arm: add some mte tests
>> 
>>  target/arm/cpu.c               | 18 +++-----
>>  target/arm/cpu.h               |  4 ++
>>  target/arm/cpu64.c             | 78 ++++++++++++++++++++++++++++++++++
>>  target/arm/kvm64.c             |  5 +++
>>  target/arm/kvm_arm.h           | 12 ++++++
>>  target/arm/monitor.c           |  1 +
>>  tests/qtest/arm-cpu-features.c | 31 ++++++++++++++
>>  7 files changed, 137 insertions(+), 12 deletions(-)
>> 

