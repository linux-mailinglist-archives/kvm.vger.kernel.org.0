Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4FF496FBC
	for <lists+kvm@lfdr.de>; Sun, 23 Jan 2022 05:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbiAWEhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 23:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbiAWEhy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jan 2022 23:37:54 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9DCC06173B;
        Sat, 22 Jan 2022 20:37:54 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id e16so2615060pgn.4;
        Sat, 22 Jan 2022 20:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Z7WC5NjZUKpTj1BBeWz8gN9vQw+7O/2G5yuYAPcm9OY=;
        b=cjoN6JRc7jkX5/oY20bfCxyYg9ldOXK51Xr6FU8WcHdaqR0TVADpQOA7ilUXj5Y544
         L8hM5v7w2hbkvOmA5BlZN5+7w7yk/K/ohXW9wimgCpC4sPLASoZJvRlIOArsRHM4M0rO
         h9BLCGcPMasCiCix56sWL3PDxAgN8UH7vTglSZrZUTRXJ296NHxTgShyLhDM4v5P6R7u
         qUbLTLscpW5aLUVrFMx6Dzzmx5pTBoK9pLvBXZZbpoz4xeeXee2rWCeSQqcr08bSFPD1
         y5nhNHhR4Vux196dvHGC+w8c+D9c8NF61Hk3x7D1wW6eO3PDsKIS6LYb/Noz5WyJJbxo
         X2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Z7WC5NjZUKpTj1BBeWz8gN9vQw+7O/2G5yuYAPcm9OY=;
        b=nXGypYbIFzlnq5oT+iMvnd9KDWOZGZBJUx8SSRyHaPoQ+V3oPhQ5WtpCURS+0lEKc0
         9SxjlgjbOMwFGYQAvo/kwSrQUhASg6cW9XctgmhO5WhmqOpOg2sfigEchsncyILOIA4K
         pwEoLE3fiwRppxMc0Tk9/lVvyV+o9PdgYNhAB37wsmp6IKcWJelCsbrVEe9XudZ5fbBZ
         dyRNtLYbHXmyzDmnBw3rvW3zk7G4OBuT0iUQ6HitQqqzytUtmMB/ZswIYRbAgiGrk7Xp
         uNvXrZ3WOMPO3bDZ+sVgd+82qPTAvigCyUj8J2EXJDFKhV8RybN+C2u2l1ANUmK1EmX0
         riNQ==
X-Gm-Message-State: AOAM531t31E2qloIhR2re77/ZVp47520byZfqMdABbMAmSnQIdihOrIP
        AlMGcZOb0RMPjeu4Dcps1K/yDuLz/fM4Zw==
X-Google-Smtp-Source: ABdhPJx9SSyf7IKXWm4ICLTwrhwMxO1MhjZc94gQitLaOOLnGOknKKo2lwgYsU6/hXGxVWN28J/izw==
X-Received: by 2002:a65:6a0f:: with SMTP id m15mr7903559pgu.391.1642912674183;
        Sat, 22 Jan 2022 20:37:54 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g2sm516447pfv.11.2022.01.22.20.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jan 2022 20:37:53 -0800 (PST)
Message-ID: <dc8c75a6-a39f-be1d-6cf3-024b88bdf5fe@gmail.com>
Date:   Sun, 23 Jan 2022 12:37:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: [PATCH v3] KVM: x86: Sync the states size with the XCR0/IA32_XSS at,
 any time
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20220117082631.86143-1-likexu@tencent.com>
 <f9edf9b5-0f84-a424-f8e9-73cad901d993@redhat.com>
 <eacf3f83-96f5-301e-de54-8a0f6c8f9fe5@gmail.com>
 <YerUQa+SN/xWMhvB@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <YerUQa+SN/xWMhvB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

XCR0 is reset to 1 by RESET but not INIT and IA32_XSS is zeroed by
both RESET and INIT. The kvm_set_msr_common()'s handling of MSR_IA32_XSS
also needs to update kvm_update_cpuid_runtime(). In the above cases, the
size in bytes of the XSAVE area containing all states enabled by XCR0 or
(XCRO | IA32_XSS) needs to be updated.

For simplicity and consistency, existing helpers are used to write values
and call kvm_update_cpuid_runtime(), and it's not exactly a fast path.

Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
Signed-off-by: Like Xu <likexu@tencent.com>
---
v2 -> v3 Changelog:
- Apply s/legacy/existing in the commit message; (Sean)
- Invoke kvm_update_cpuid_runtime() for MSR_IA32_XSS; (Sean)

  arch/x86/kvm/x86.c | 5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55518b7d3b96..4b509b26d9ab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3535,6 +3535,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct 
msr_data *msr_info)
  		if (data & ~supported_xss)
  			return 1;
  		vcpu->arch.ia32_xss = data;
+		kvm_update_cpuid_runtime(vcpu);
  		break;
  	case MSR_SMI_COUNT:
  		if (!msr_info->host_initiated)
@@ -11256,7 +11257,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)

  		vcpu->arch.msr_misc_features_enables = 0;

-		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
+		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
  	}

  	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
@@ -11273,7 +11274,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
  	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
  	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);

-	vcpu->arch.ia32_xss = 0;
+	__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);

  	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);

-- 
2.33.1


