Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E4511BE5A
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 21:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfLKUsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 15:48:31 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:44651 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfLKUsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 15:48:31 -0500
Received: by mail-ua1-f73.google.com with SMTP id 108so6561341uad.11
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 12:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jlDyQ8V1A4E8vFOmfZoIbJ2QXkEwRCCLJLwBmOJe29A=;
        b=jjExR/ypQVqELVfmZroUTsrHDq+Kyle0r7cM6GRFHucL2QDpMuZu3CdhmxcEj1+Ggx
         T8So24lxdlDrhk+RuF27Un0DG77dq2CZ9HeYsLpV5QlMy2HtKC55VRqIb8qE+dHH0ITg
         GSleJ9N1oeFDK3s2487N+mFccVTnmHlEbx7WcAxgELvTZjNngusHfdOSkg/QcdlZ1riq
         qSeHd362e8Pu/ZhX+hsgtZ0jZ0iw8suFK6xgpZ2TVTpBplBECiph61eND0JBp2AbBmpq
         y8snT3db8QYHtMiqkIYkCXFjwa9j8jV//DXickQMzbWZWaBg5Lf9mVwD5Hf2mz9W0kIa
         v82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jlDyQ8V1A4E8vFOmfZoIbJ2QXkEwRCCLJLwBmOJe29A=;
        b=A4AGGhEdp/zJcDMISk/9bpeOmwmGFnLlJBBNtOe7tTKZE7zdThqS2Js3ga96wgOc53
         GmvTnCXMPtYlfm6Kwy7QrUbh8xAozfHCUXJd6TmTnpgTK6wWVp/gzBZPX+AjP9l9TRAP
         0Z29OZp+9yTnU6nevArwPV7uxR2s4I2SIEhxKLPWaoWenLKDokdypPjgH+Qs2RhoKwFa
         AsGmHqirfgHUgkr2n8rQO7k/9kBRUhnEUlWZaoTtgl9tQYSPsOAfO0r16Gc5etAfamKk
         /Spwl8niaVEjIaKjoK1UayIoBfkyMnCJoA3uWBTKJXz1yxV3Jq6l/uFCELfoKWaJgYsS
         frBA==
X-Gm-Message-State: APjAAAVo8GqES2VxfQn1Kzn1djoJiFmSDB8PAWSkP8/4XG+6yv7NVedM
        rvZ1yObrxcJirJxJW8H0cBRncuCJ6/yr
X-Google-Smtp-Source: APXvYqyq+7rLt1Mbo63AO66IU/V2FHwB6iU0oZSlIduHJY1TtnmF475NNmuDKCUH1XyAbf89tAosu/+ebq+e
X-Received: by 2002:a1f:ac57:: with SMTP id v84mr5636546vke.90.1576097310120;
 Wed, 11 Dec 2019 12:48:30 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:42 -0800
In-Reply-To: <20191211204753.242298-1-pomonis@google.com>
Message-Id: <20191211204753.242298-3-pomonis@google.com>
Mime-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 02/13] KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data()
 from Spectre-v1/L1TF attacks
From:   Marios Pomonis <pomonis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        Marios Pomonis <pomonis@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes Spectre-v1/L1TF vulnerabilities in kvm_hv_msr_get_crash_data()
and kvm_hv_msr_set_crash_data().
These functions contain index computations that use the
(attacker-controlled) MSR number.

Fixes: commit e7d9513b60e8 ("kvm/x86: added hyper-v crash msrs into kvm hyperv context")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/hyperv.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 23ff65504d7e..26408434b9bc 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -809,11 +809,12 @@ static int kvm_hv_msr_get_crash_data(struct kvm_vcpu *vcpu,
 				     u32 index, u64 *pdata)
 {
 	struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
+	size_t size = ARRAY_SIZE(hv->hv_crash_param);
 
-	if (WARN_ON_ONCE(index >= ARRAY_SIZE(hv->hv_crash_param)))
+	if (WARN_ON_ONCE(index >= size))
 		return -EINVAL;
 
-	*pdata = hv->hv_crash_param[index];
+	*pdata = hv->hv_crash_param[array_index_nospec(index, size)];
 	return 0;
 }
 
@@ -852,11 +853,12 @@ static int kvm_hv_msr_set_crash_data(struct kvm_vcpu *vcpu,
 				     u32 index, u64 data)
 {
 	struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
+	size_t size = ARRAY_SIZE(hv->hv_crash_param);
 
-	if (WARN_ON_ONCE(index >= ARRAY_SIZE(hv->hv_crash_param)))
+	if (WARN_ON_ONCE(index >= size))
 		return -EINVAL;
 
-	hv->hv_crash_param[index] = data;
+	hv->hv_crash_param[array_index_nospec(index, size)] = data;
 	return 0;
 }
 
-- 
2.24.0.525.g8f36a354ae-goog

