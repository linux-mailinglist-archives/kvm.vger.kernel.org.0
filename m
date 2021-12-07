Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A22B46C727
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 23:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242146AbhLGWNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 17:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242123AbhLGWNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 17:13:13 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81ECDC061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 14:09:42 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id n19-20020a056a0007d300b004acbc929796so373864pfu.18
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 14:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=LLX3U7mn58e613uUDC2pnGcOVbMh7hOH4J4J3lUPvDA=;
        b=X/v9iuxguJ0gslCcBYYHV5+6guNvSMM9qc3Nnk0gQGJfA0JCwWgJ2KO3RZMUqiPq/U
         Ya0nim4PFV2cJoOGlCdNXk2c5F4LiG2ie9EmehAYYywgGLwHmrHzjvvfcbgS/F5XHJM1
         Nto3w+PRVUqT5Shiz/3oWVoWzGO/s966w93AFj0Lp+PFzTdQXIM5B6oMioqGygH4UCdO
         zLhOm/7deP+C8XsdjveswEV5Q6GVUHH+YTIRBpU7XlUeL+WkTSUaQHACzZWbgpQNUtTp
         oq+bqS4wds/+hMpcbcyt5oBzE/DeLi7LvVNw3wKPzH5mXIz7adRoLkilNcOiLlI5RcrC
         0qjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=LLX3U7mn58e613uUDC2pnGcOVbMh7hOH4J4J3lUPvDA=;
        b=qZ+PVS2oZZfz0BaVxi8c05zgmc01YVyaWq8rXRH1k6Tfsv3ugerG/+w7tNdf/h+0Jc
         HqXZgDnI2TE+vQIGfAXVMeveMP7Mv8VEhatSw2kJfD26Jd10GXEsd/yc54zj76DA5wtT
         54b8tmioaPkuF69DJ0epHjfFhWq5G3y13hrz5Q/a0c02Du6fmrcYiKFHspF7gB86VXLW
         crd813tkEbDbLDXFzxAoDmdfmnDWNzOBGOoPiEzljMtlr1Xeo30dA1Qc20QI4Pf48zjt
         viAWkFW9bw/jnnykka2REuaktJxKgUg/eSxxVIPDgdupmnx63PBCOrDSpffL90M0g9Oc
         871Q==
X-Gm-Message-State: AOAM5306HOlqyiGCC+G6uTvJ5aUcJdlys4u1tTlHQpCf2kcMJN9wFSUf
        eoBxRvbCbND40n9+aU9QFLa/IjmGm3Y=
X-Google-Smtp-Source: ABdhPJwCfyK/gnJBKpT9rlWfbFbYvRE1/0RiMXGIbXcLt3rF69pNTU9V1/jyqVwVV9vzkAJvoHmF/PGUsBc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr251632pjb.0.1638914981457; Tue, 07 Dec 2021 14:09:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Dec 2021 22:09:21 +0000
In-Reply-To: <20211207220926.718794-1-seanjc@google.com>
Message-Id: <20211207220926.718794-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211207220926.718794-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 3/8] KVM: x86: Refactor kvm_hv_flush_tlb() to reduce indentation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ajay Garg <ajaygargnsit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the "extended" path of kvm_hv_flush_tlb() to reduce the nesting
depth for the non-fast sparse path, and to make the code more similar to
the extended path in kvm_hv_send_ipi().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index d8a7b63f676f..9bc856370a2d 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1815,31 +1815,33 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 		if (hc->var_cnt != bitmap_weight((unsigned long *)&valid_bank_mask, 64))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
-		if (!hc->var_cnt && !all_cpus)
+		if (all_cpus)
+			goto do_flush;
+
+		if (!hc->var_cnt)
 			goto ret_success;
 
-		if (!all_cpus) {
-			if (hc->fast) {
-				if (hc->var_cnt > HV_HYPERCALL_MAX_XMM_REGISTERS - 1)
-					return HV_STATUS_INVALID_HYPERCALL_INPUT;
-				for (i = 0; i < hc->var_cnt; i += 2) {
-					sparse_banks[i] = sse128_lo(hc->xmm[i / 2 + 1]);
-					sparse_banks[i + 1] = sse128_hi(hc->xmm[i / 2 + 1]);
-				}
-			} else {
-				if (hc->var_cnt > 64)
-					return HV_STATUS_INVALID_HYPERCALL_INPUT;
-
-				gpa = hc->ingpa + offsetof(struct hv_tlb_flush_ex,
-							   hv_vp_set.bank_contents);
-				if (unlikely(kvm_read_guest(kvm, gpa, sparse_banks,
-							    hc->var_cnt *
-							    sizeof(sparse_banks[0]))))
-					return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (hc->fast) {
+			if (hc->var_cnt > HV_HYPERCALL_MAX_XMM_REGISTERS - 1)
+				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+			for (i = 0; i < hc->var_cnt; i += 2) {
+				sparse_banks[i] = sse128_lo(hc->xmm[i / 2 + 1]);
+				sparse_banks[i + 1] = sse128_hi(hc->xmm[i / 2 + 1]);
 			}
+			goto do_flush;
 		}
+
+		if (hc->var_cnt > 64)
+			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+
+		gpa = hc->ingpa + offsetof(struct hv_tlb_flush_ex,
+					   hv_vp_set.bank_contents);
+		if (unlikely(kvm_read_guest(kvm, gpa, sparse_banks,
+					    hc->var_cnt * sizeof(sparse_banks[0]))))
+			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 	}
 
+do_flush:
 	/*
 	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
 	 * analyze it here, flush TLB regardless of the specified address space.
-- 
2.34.1.400.ga245620fadb-goog

