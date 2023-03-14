Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6743E6B91B8
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 12:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjCNLfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 07:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjCNLfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 07:35:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AFF126FA
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 04:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678793667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kkLCoUCMpqcOHFaJffF6f0n5G6YobYmpdJv/U4OkHBM=;
        b=Rq69e8VPCEUqdPl0hlSrQOR6y/VvOjhH4fgF6E8xjRVi1eulKM/PuA1SiSA1pUnNUAH5rn
        Jk+Npv/KpGtVyyKnQP7eZGsRJ5hAxVoIvrzmGfq8i/GPl7u2eOqi2++mBZ7RmGEb8+I8MW
        hWT3VijMwwjHO4nLgNZGvAeArjtE4lA=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-qsV9PNzMMCaTFml4eP2s8w-1; Tue, 14 Mar 2023 07:34:26 -0400
X-MC-Unique: qsV9PNzMMCaTFml4eP2s8w-1
Received: by mail-vs1-f70.google.com with SMTP id p13-20020a056102274d00b004215e04e139so4756536vsu.5
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 04:34:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678793666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kkLCoUCMpqcOHFaJffF6f0n5G6YobYmpdJv/U4OkHBM=;
        b=CchNYWl1t8xFTxRu0jEJ23tvpZipBE1z60YM1lloGyhdD2GGbqX4fKLhLzPYRLKPUn
         LeieJbICwYZV86GHh8mtl6t9YOp0OOV4KP2x/xqHS1r7ZmPZRv+QNKrH6h7tmbJfP3ce
         zKzW6Ix/nuToKjonnF4DxbbTwG+kca2NwKOQC59JJ2FVr1ibekyRXEfMZyZ/i8cO5Ltk
         L759jSlZNLaPPlecI9qOdZl547u1lR8uEy1euF0dVXGVCAWbH/2ov02FVMbYVsDJ5CcN
         y9c2uQgAY7deVJGjqJsrlhJpPIXTmtqg44MhyzN5c43y36jFKrKks4ksg+3DcG4+O/9T
         N+Fw==
X-Gm-Message-State: AO0yUKWHCPWJsooT1750T+7o1lOvU2xK+ZE3bcyrKA4nRFTFq0KWmIfq
        qegdLeGCrw2poMWG2xAbTb3eVu8oqFl7geVeAKlHkf2xK4RXdk1+0W25JEhsYUlDlfjwKheJgwH
        lpLwgRhxeIhTt5Byxfhl+evvrS4sM
X-Received: by 2002:a05:6102:15a:b0:425:b211:3671 with SMTP id a26-20020a056102015a00b00425b2113671mr427737vsr.1.1678793665923;
        Tue, 14 Mar 2023 04:34:25 -0700 (PDT)
X-Google-Smtp-Source: AK7set/w+sR9/GMNzZjM3wzMEhNKJTIhp0f9AHhm3KvhR7TM8JlTerQD5v60MTqgl5o4P2QZ8Cnr8/3wR0nh/OO0yi8=
X-Received: by 2002:a05:6102:15a:b0:425:b211:3671 with SMTP id
 a26-20020a056102015a00b00425b2113671mr427724vsr.1.1678793665678; Tue, 14 Mar
 2023 04:34:25 -0700 (PDT)
MIME-Version: 1.0
References: <ZAz1duOOOTu+5LW5@thinky-boi>
In-Reply-To: <ZAz1duOOOTu+5LW5@thinky-boi>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 14 Mar 2023 12:34:14 +0100
Message-ID: <CABgObfY1sL8JMUwf1JeJrmSncKo7OoCZe2sGh8m=XxH1h7Kp5g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.3, part #1
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     maz@kernel.org, reijiw@google.com, joey.gouly@arm.com,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pulled, thanks!

Paolo

On Sat, Mar 11, 2023 at 10:41=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
>
> Hi Paolo,
>
> First shot at sending a pull request to you, please let me know if anythi=
ng
> is screwed up :)
>
> A single, important fix for guest timers addressing a bug from the nested
> virtualization prefix that went in 6.3.
>
> Please pull,
>
> --
> Oliver
>
> The following changes since commit fe15c26ee26efa11741a7b632e9f23b01aca4c=
c6:
>
>   Linux 6.3-rc1 (2023-03-05 14:52:03 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.3-1
>
> for you to fetch changes up to 47053904e18282af4525a02e3e0f519f014fc7f9:
>
>   KVM: arm64: timers: Convert per-vcpu virtual offset to a global value (=
2023-03-11 02:00:40 -0800)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.3, part #1
>
> A single patch to address a rather annoying bug w.r.t. guest timer
> offsetting. Effectively the synchronization of timer offsets between
> vCPUs was broken, leading to inconsistent timer reads within the VM.
>
> ----------------------------------------------------------------
> Marc Zyngier (1):
>       KVM: arm64: timers: Convert per-vcpu virtual offset to a global val=
ue
>
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kvm/arch_timer.c       | 45 +++++++++------------------------=
------
>  arch/arm64/kvm/hypercalls.c       |  2 +-
>  include/kvm/arm_arch_timer.h      | 15 +++++++++++++
>  4 files changed, 29 insertions(+), 36 deletions(-)
>

