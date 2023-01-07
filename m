Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A6B660B4B
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 02:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjAGBKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 20:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbjAGBKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 20:10:40 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D0487911
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 17:10:39 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id u3-20020a056a00124300b0056d4ab0c7cbso1572014pfi.7
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 17:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+sdXtFu+Ne3/WqpqEnArTMb7tiJlTapUtXGWnwQLJeo=;
        b=Dao593ybK4BhM9ugXpstOjEs5v583sZb8+BgJepbDvrWqkRo6q7j78424EyvLNflPs
         GWtEtnNohaHHlF0ers8XK9vuzUbSnj15p03ppfuAa54LPyxEaT0o2ynjA0rY6YCPjIiE
         8twEnekmaSgGs2lwuEnp18lnjFuVfF5VbuWhSgsZbtxUkzj+2LVZWaU1q9HhQZ9tOJhO
         7Nd0/RU6TDOSpxzURBVNS//JdLu25fpTl4ixMNp+fdmoX+1U6fKXZvSILEon0uUj2jNv
         3Pqtz4C6bPAOQIPvZRcWPXJVNzqEarxHYKg+QD+oBdjKm7/NZ+vHe6xa64dmWG+C9f43
         xA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+sdXtFu+Ne3/WqpqEnArTMb7tiJlTapUtXGWnwQLJeo=;
        b=ugWRGySxxVikH1i0aK8d6mvBdJg4TEZQXSpJdKWHEWzXH0a8Q5L+pjpDTDSrV0tGMW
         6g8hIL2tR+HUxi3IsgzqOgFj/PAWFD4pF1bBPBjn94TRddCOnquJyjFrvtsCmsrCt+by
         v4xXhlTkGZ1mlfUjND9ssuTDYYHwxexmEOadcstHCuopEmQd6ox/vTdG4zF3G52bpx7P
         LdyN2rt2MNuO4d3woiIbdSx672T7WdSAVgTtLuCrnk+VtWnACcOeW9eBSZs95NAUnNAk
         J28kdTY/IBiyNK1CzanhWXTgFL27qlFSALxFjxsA5ZYbphcvQpz8FMwBM5F18tEUayHI
         O7pQ==
X-Gm-Message-State: AFqh2kokQ3jcGO1IBQhuTFSyTIwrM6HCzKMAXcnxMy/xMrskZi6GU3Ic
        pZ3RWAZtToQLm3LfGoa/iZhBdXviDWg=
X-Google-Smtp-Source: AMrXdXtUuYt8ynJTKKgyA+8U/+E5ogfG+aPZAZ/zuiRddeXrDWmFg53mf+udNOHZqM/nEfIZKVRBivJhwlg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:b381:b0:225:d307:95ce with SMTP id
 e1-20020a17090ab38100b00225d30795cemr3346327pjr.136.1673053838772; Fri, 06
 Jan 2023 17:10:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  7 Jan 2023 01:10:25 +0000
In-Reply-To: <20230107011025.565472-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230107011025.565472-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230107011025.565472-7-seanjc@google.com>
Subject: [PATCH 6/6] KVM: VMX: Intercept reads to invalid and write-only
 x2APIC registers
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Orr <marcorr@google.com>, Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intercept reads to invalid (non-existent) and write-only x2APIC registers
when configuring VMX's MSR bitmaps for x2APIC+APICv.  When APICv is fully
enabled, Intel hardware doesn't validate the registers on RDMSR and
instead blindly retrieves data from the vAPIC page, i.e. it's software's
responsibility to intercept reads to non-existent and write-only MSRs.

Fixes: 8d14695f9542 ("x86, apicv: add virtual x2apic support")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 82c61c16f8f5..1be2bc7185be 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4031,7 +4031,7 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
 	u64 *msr_bitmap = (u64 *)vmx->vmcs01.msr_bitmap;
 	u8 mode;
 
-	if (!cpu_has_vmx_msr_bitmap())
+	if (!cpu_has_vmx_msr_bitmap() || WARN_ON_ONCE(!lapic_in_kernel(vcpu)))
 		return;
 
 	if (cpu_has_secondary_exec_ctrls() &&
@@ -4053,11 +4053,11 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
 	 * Reset the bitmap for MSRs 0x800 - 0x83f.  Leave AMD's uber-extended
 	 * registers (0x840 and above) intercepted, KVM doesn't support them.
 	 * Intercept all writes by default and poke holes as needed.  Pass
-	 * through all reads by default in x2APIC+APICv mode, as all registers
-	 * except the current timer count are passed through for read.
+	 * through reads for all valid registers by default in x2APIC+APICv
+	 * mode, only the current timer count needs on-demand emulation by KVM.
 	 */
 	if (mode & MSR_BITMAP_MODE_X2APIC_APICV)
-		msr_bitmap[read_idx] = 0;
+		msr_bitmap[read_idx] = ~kvm_lapic_readable_reg_mask(vcpu->arch.apic);
 	else
 		msr_bitmap[read_idx] = ~0ull;
 	msr_bitmap[write_idx] = ~0ull;
-- 
2.39.0.314.g84b9a713c41-goog

