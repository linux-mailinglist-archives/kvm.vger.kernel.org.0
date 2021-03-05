Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81CC32DEE8
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhCEBLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhCEBLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:37 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27466C061756
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:37 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id l3so652553ybf.17
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VvZxbsS7usA2XSAkfRC0sbz46vD+BnH1u7vFisa6mO0=;
        b=nMfaIQkshHHKWY0t0z5Ecf0LwmQDb3vkLOcg63u2GoT2PIEretoYxOXCZf+9FF7GlZ
         7kTHcuZcVSW2Z4KberUEU3h23143dvkVliNEiDyWM7WPVSnsL13dD5VdqR0vZ/ETa5O4
         q58pcSLGtOmPvm3GHVQm1A+riTm4dGRm7Tmx2ubupST/1OVPnlUpZNWEn6bFX5LL50/1
         Ops1kjitD+ibIpCNvgQ19rSDstyn8vOF8SINmUh+Vx9d8wMBMcKiYx8nvXgIBh3twMSe
         AHQNrus4nuyAEFXFsNP8vb61fRTS1ezF187ezh+bekDkDgPys57rMH1JgyxDpHe6FblT
         NIZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VvZxbsS7usA2XSAkfRC0sbz46vD+BnH1u7vFisa6mO0=;
        b=sY5oIxysgeOxzYwgeyPw0bLRU6Uz3edGotpzGPV/u+9KHfLvgDWAVg8YpgNIsGekgI
         3S2Fk7gjYAJfHpYanzuyJa9mFRPsEU6T5cQX/j8j2wOr4BxhortB4DyBWD0MfUhiaecu
         8rAaHIISLY+2gMpnEOcDvd3UVFqVkkJSypDXYvON+MjzdInfTr5KkCuZm/RqtCxrp/U+
         YEN+qm4WQRbwVEicubPb/dvlIWrZnh9rn746BoAb9ulzAMjmt8lHBLGGPPpk7pC44pWa
         oTvIlbVeTv37W6i/GiJ+06qAh5IXLyukutfzDHIUA2hE4loDl4MaEEyCKScrDqyHl3W1
         /KvA==
X-Gm-Message-State: AOAM531vk5OKeiO72f05f68JgBZf9FwkQctrgZhMFTck4/5MgW79nK9a
        ItOB1cdFhBloZjZM8hTkn12dDWqiTtI=
X-Google-Smtp-Source: ABdhPJykw1/ckd3FliB/mVuq8j3h7IPXNCBb73BP/3oSB+2xOvmPUxIAHC/BgV4nProD+JMarALm7rCuAsc=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:7645:: with SMTP id r66mr10406291ybc.331.1614906696451;
 Thu, 04 Mar 2021 17:11:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:57 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 13/17] KVM: nVMX: Defer the MMU reload to the normal path
 on an EPTP switch
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Defer reloading the MMU after a EPTP successful EPTP switch.  The VMFUNC
instruction itself is executed in the previous EPTP context, any side
effects, e.g. updating RIP, should occur in the old context.  Practically
speaking, this bug is benign as VMX doesn't touch the MMU when skipping
an emulated instruction, nor does queuing a single-step #DB.  No other
post-switch side effects exist.

Fixes: 41ab93727467 ("KVM: nVMX: Emulate EPTP switching for the L1 hypervisor")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fdd80dd8e781..81f609886c8b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5473,16 +5473,11 @@ static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 		if (!nested_vmx_check_eptp(vcpu, new_eptp))
 			return 1;
 
-		kvm_mmu_unload(vcpu);
 		mmu->ept_ad = accessed_dirty;
 		mmu->mmu_role.base.ad_disabled = !accessed_dirty;
 		vmcs12->ept_pointer = new_eptp;
-		/*
-		 * TODO: Check what's the correct approach in case
-		 * mmu reload fails. Currently, we just let the next
-		 * reload potentially fail
-		 */
-		kvm_mmu_reload(vcpu);
+
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 	}
 
 	return 0;
-- 
2.30.1.766.gb4fecdf3b7-goog

