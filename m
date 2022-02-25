Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487394C47E3
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241663AbiBYOua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiBYOu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:50:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F69B2028BE
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 06:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645800594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oG46p9ApnGlILl1ZLvkfxhnD10O2+FDP9Z7Tm2fwr+c=;
        b=Q4FannQMidh+cKStF5mM7UjA0ru81slTT9xfeYeW91GYut47wLCpMAoLj1KSUWLCoYuGui
        imRHQWoFvv7g+bmt7ILnLHzqu4jYU0bKIepF7D45Kto85la9TYHHjLcwhdb+pfOuK3UEqb
        L5wERKOD7za39oi4iIMz1OTdRcD95vY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-n77N9v51N0e1eqqG2AgQFA-1; Fri, 25 Feb 2022 09:49:53 -0500
X-MC-Unique: n77N9v51N0e1eqqG2AgQFA-1
Received: by mail-wm1-f70.google.com with SMTP id i20-20020a05600c051400b00380d5eb51a7so1423520wmc.3
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 06:49:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oG46p9ApnGlILl1ZLvkfxhnD10O2+FDP9Z7Tm2fwr+c=;
        b=uduve2VOUSKonYYV221aTz9L1sB1x9ULdJO94aGag/hXl4ptfBsjkF5giEA7V92/fc
         6JNyjhphnrh1z4VipnLMC9/xD6vdI4J+rUrlSx8lE7tFdWtEsVGqK2Tjb0sHVR+QniuI
         cvroHQRECHzUXUOtdzYt0KhmM8W8QamVY0iFgcD1Q1FSMa0z4sf8mH9Z7EJNCoAK/8Xe
         q0+LpBeTOuXRam4obl/MhdTUJOhmuDam2FSZFCvJVXoYoLonRmRunh3ZNfLGeCBGtMC4
         zC8ngto1tlG002dZXX8JD5mabeHqCYTCj2PwNHDQRO/TIz85bGglz0HVAqhYcScOegYb
         UKMQ==
X-Gm-Message-State: AOAM530Z9DZKGFfmd84DbSiWE5SAPmvKzmCmBvhjWSiIoD2jRsVXdSsJ
        J8IjBLxj1UF/u0tNv5n8BAuQBY1NFJJSL3Ju8YijW4FVCkAj0t1ZzyqBltLs7RxMAESwcVv8Hpk
        4059QqRv8hUuh
X-Received: by 2002:a05:6000:3c6:b0:1e4:a380:bb53 with SMTP id b6-20020a05600003c600b001e4a380bb53mr6213162wrg.559.1645800591921;
        Fri, 25 Feb 2022 06:49:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPvZpYeV1cMChykbmMIlrqZ62jXUzNXFVvdiNhkV7FTQ/vQZtP351aVYLRANF8AJomAWs86Q==
X-Received: by 2002:a05:6000:3c6:b0:1e4:a380:bb53 with SMTP id b6-20020a05600003c600b001e4a380bb53mr6213154wrg.559.1645800591650;
        Fri, 25 Feb 2022 06:49:51 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id l26-20020a05600c1d1a00b00380def7d3desm2672667wms.17.2022.02.25.06.49.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 06:49:51 -0800 (PST)
Message-ID: <b03f6e27-bd55-e06b-af8d-a4e6bdf5d778@redhat.com>
Date:   Fri, 25 Feb 2022 15:49:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.17, take #4
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
References: <20220225131302.107215-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220225131302.107215-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/22 14:13, Marc Zyngier wrote:
> Hi Paolo,
> 
> Only a couple of fixes this time around: one for the long standing
> PSCI CPU_SUSPEND issue, and a selftest fix for systems that don't have
> a GICv3.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 5bfa685e62e9ba93c303a9a8db646c7228b9b570:
> 
>    KVM: arm64: vgic: Read HW interrupt pending state from the HW (2022-02-11 11:01:12 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-4
> 
> for you to fetch changes up to 456f89e0928ab938122a40e9f094a6524cc158b4:
> 
>    KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3 (2022-02-25 13:02:28 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.17, take #4
> 
> - Correctly synchronise PMR and co on PSCI CPU_SUSPEND
> 
> - Skip tests that depend on GICv3 when the HW isn't available
> 
> ----------------------------------------------------------------
> Mark Brown (1):
>        KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3
> 
> Oliver Upton (1):
>        KVM: arm64: Don't miss pending interrupts for suspended vCPU
> 
>   arch/arm64/kvm/psci.c                            | 3 +--
>   tools/testing/selftests/kvm/aarch64/arch_timer.c | 7 ++++++-
>   tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 4 ++++
>   tools/testing/selftests/kvm/lib/aarch64/vgic.c   | 4 +++-
>   4 files changed, 14 insertions(+), 4 deletions(-)
> 

Pulled, thanks.

Paolo

