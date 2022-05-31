Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81D3538DBA
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 11:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245255AbiEaJ3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 05:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245301AbiEaJ3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 05:29:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3A7B985A9
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 02:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653989346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/KsrAlA+cUzyY84FVZIvJ6NG3hfTuJ4yXZoPL+B3/xg=;
        b=FImTBorSvsowGD8lkkt7N8Ii1BG9+5LNIAROA9PDMfIUY9rT6LMX9OD4n/uDUbPPpiYjsK
        TCM3gDGjyvmtVLtm6vaWlLeAtHla1L6hHrBbf4PC/+jVpfq0pcezFB1XxnZCTe8ytZlbu0
        Q+bn79qRaQitBDBOinyk5u6dFu0GJPs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-uqqkWcxkPGCZX_7_NZKlZQ-1; Tue, 31 May 2022 05:29:05 -0400
X-MC-Unique: uqqkWcxkPGCZX_7_NZKlZQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 388A1811E7A;
        Tue, 31 May 2022 09:29:04 +0000 (UTC)
Received: from localhost (dhcp-192-194.str.redhat.com [10.33.192.194])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F40672166B2B;
        Tue, 31 May 2022 09:29:03 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] arm: enable MTE for QEMU + kvm
In-Reply-To: <20220512131146.78457-1-cohuck@redhat.com>
Organization: Red Hat GmbH
References: <20220512131146.78457-1-cohuck@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 31 May 2022 11:29:02 +0200
Message-ID: <871qwacaox.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Friendly ping :)

On Thu, May 12 2022, Cornelia Huck <cohuck@redhat.com> wrote:

> This series enables MTE for kvm guests, if the kernel supports it.
> Lightly tested while running under the simulator (the arm64/mte/
> kselftests pass... if you wait patiently :)
>
> A new cpu property "mte" (defaulting to on if possible) is introduced;
> for tcg, you still need to enable mte at the machine as well.
>
> I've hacked up some very basic qtests; not entirely sure if I'm going
> about it the right way.
>
> Some things to look out for:
> - Migration is not (yet) supported. I added a migration blocker if we
>   enable mte in the kvm case. AFAIK, there isn't any hardware available
>   yet that allows mte + kvm to be used (I think the latest Gravitons
>   implement mte, but no bare metal instances seem to be available), so
>   that should not have any impact on real world usage.
> - I'm not at all sure about the interaction between the virt machine 'mte'
>   prop and the cpu 'mte' prop. To keep things working with tcg as before,
>   a not-specified mte for the cpu should simply give us a guest without
>   mte if it wasn't specified for the machine. However, mte on the cpu
>   without mte on the machine should probably generate an error, but I'm not
>   sure how to detect that without breaking the silent downgrade to preserve
>   existing behaviour.
> - As I'm still new to arm, please don't assume that I know what I'm doing :)
>
>
> Cornelia Huck (2):
>   arm/kvm: enable MTE if available
>   qtests/arm: add some mte tests
>
>  target/arm/cpu.c               | 18 +++-----
>  target/arm/cpu.h               |  4 ++
>  target/arm/cpu64.c             | 78 ++++++++++++++++++++++++++++++++++
>  target/arm/kvm64.c             |  5 +++
>  target/arm/kvm_arm.h           | 12 ++++++
>  target/arm/monitor.c           |  1 +
>  tests/qtest/arm-cpu-features.c | 31 ++++++++++++++
>  7 files changed, 137 insertions(+), 12 deletions(-)
>
> -- 
> 2.34.3

