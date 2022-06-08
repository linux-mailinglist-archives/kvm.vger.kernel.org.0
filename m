Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DF5542D7E
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 12:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbiFHKYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 06:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237369AbiFHKYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 06:24:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FC5BAE7B
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 03:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654683269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7fZ7puPZpMBdW0QRh/AoLSh/CTVqI79nWjIG/nQXq24=;
        b=T0MrUZzoiNhAEQR0g/mMeJHfYpUUuu0I04VKxjSWe/0Vwj7pi39h9tY18oFxa8gSxJ2awz
        /zocbRknJjCc0gIdGg4sGGtAnhfMfS7c7q32MoE2LWVByNKL2PCFGS8H+B1UryQXTld8VV
        zgBBPqps9mlsb7pkNohsxHx+z7GUAqU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-rHi4lKVoONyeemPiAAYtGA-1; Wed, 08 Jun 2022 06:14:28 -0400
X-MC-Unique: rHi4lKVoONyeemPiAAYtGA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07AA7801756;
        Wed,  8 Jun 2022 10:14:28 +0000 (UTC)
Received: from localhost (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2692400F3FF;
        Wed,  8 Jun 2022 10:14:27 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Haibo Xu <haibo.xu@linaro.org>
Cc:     Andrew Jones <drjones@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] arm: enable MTE for QEMU + kvm
In-Reply-To: <20220512131146.78457-1-cohuck@redhat.com>
Organization: Red Hat GmbH
References: <20220512131146.78457-1-cohuck@redhat.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Wed, 08 Jun 2022 12:14:26 +0200
Message-ID: <87zgina2d9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

...so it seems there was a series some time ago related to MTE +
migration, which my initial search somehow managed to avoid.

https://lore.kernel.org/all/CAJc+Z1FZxSYB_zJit4+0uTR-88VqQL+-01XNMSEfua-dXDy6Wg@mail.gmail.com/
talks about some kernel changes needed in order to support postcopy; has
there been any update, as my search fu might be failing me again?

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

