Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8A733D223
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhCPKq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236835AbhCPKqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 06:46:00 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837CEC06174A
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 03:45:59 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t9so7163336wrn.11
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 03:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zsdz2h8hf8Y/24lVeadYaeeQAMOF3TALsCOQcWpVAJk=;
        b=SJTMsl6KBrovYMSkF7DcCJIHr0K+jwCLFtt5KCAHC4SmzQZMxaKdsw4YmOZ6G8gQ/i
         F54HseY7kRTu5nSHt0RbnDBuMDiPhg324fyoJelGspMcblDCPxRPcTQ4ar6eoV9mVIlm
         qTFoHlBhuBgya022zZGChk+AuO5qVI1rZReb5GhTu3+QsezemBJqLbqN/HibJ/uMoxSm
         SIyx1yXH6rEgYgr8M6/PhZ58ySzz4360Vx59ApLJ2L/Ko3guwywAckBrVjdDgstbNPKR
         Dj0+wLofArhDqFekakXYvgpiOLeiZbsKcI5aY7IlY7hCv43TEs3oaYM2NnUEc2U1306r
         dEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zsdz2h8hf8Y/24lVeadYaeeQAMOF3TALsCOQcWpVAJk=;
        b=oU/nIxrwOHCzjc9X76i5QFeWQRZS3J7ONiYLWe4mxcDv10firtfKa9z6vehWQuHgsN
         /IROWTAqN50wPt6dXGEWZHy2FiaeXB2gDQBLgrlfb385N5iK/myMSZPfF4/lBSgh/Z7l
         YFb+2BROQKP4Z+852oOszoVdqot6JXsvBtpDgR1nF1a710ShbwpqNlmg+S4nHR4zPhhi
         Jcq4R1sWFgJ5pa8hVTiLTv3jKOEWjwxkMb3AYXlPlV+Cf2+b4nA5yEUZCcUC6sJ8jsm4
         EWddxQrvqulGWfurDpRGmPCLsuMdoJlB2JTbSxZzpaMlmT3LuUw4yL1DDAYPAFDIsYvG
         2gAw==
X-Gm-Message-State: AOAM533S/5VVOv2R91d46j9X0bLJkGHrUfupDD6M8UTZlCqHGVS2EbtP
        cjPE/FpV0ApMS6I/iE8i2W+2E5KNzYKXRw==
X-Google-Smtp-Source: ABdhPJzzT1u4K5ULsw5LvTSW/vhY00CzqQZU1WwxkZhBult5lmWWoNSeYotgmhqJqS602sEukhDbsw==
X-Received: by 2002:adf:a418:: with SMTP id d24mr4111334wra.187.1615891558225;
        Tue, 16 Mar 2021 03:45:58 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com. [35.233.69.230])
        by smtp.gmail.com with ESMTPSA id j203sm2868593wmj.40.2021.03.16.03.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 03:45:58 -0700 (PDT)
Date:   Tue, 16 Mar 2021 10:45:55 +0000
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 08/10] KVM: arm64: Add a nVHE-specific SVE VQ reset
 hypercall
Message-ID: <YFCMY2TDl4/6++PJ@google.com>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-9-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-9-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday 16 Mar 2021 at 10:13:10 (+0000), Marc Zyngier wrote:
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c4afe3d3397f..9108ccc80653 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -593,7 +593,9 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  void kvm_arm_halt_guest(struct kvm *kvm);
>  void kvm_arm_resume_guest(struct kvm *kvm);
>  
> -#define kvm_call_hyp_nvhe(f, ...)						\
> +static inline void __kvm_reset_sve_vq(void) {}

Why is this one needed? With an explicit call to kvm_call_hyp_nvhe() you
shouldn't need to provide a VHE implementation I think.

Thanks,
Quentin
