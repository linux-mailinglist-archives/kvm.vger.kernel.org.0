Return-Path: <kvm+bounces-32663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3EA9DB0DA
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A014D282313
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33EB3154BF0;
	Thu, 28 Nov 2024 01:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4NkAnmkY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8171509BF
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757695; cv=none; b=Z9Wb0yhPg9/pTrb0v7plc3U7ydeD+auzAIfe3cUcDsvwJHLCJlAH3AFzBbeHV8MNil/d4fW12qXpe+F3fskQxGTyLFkid9ESyfxIIW3bgH/DgaLdf3hQ0k37EgaX+SaK/e1459XGPjpMUInW+Jjlu11AzQO55GJeNXqg4OOU6LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757695; c=relaxed/simple;
	bh=H6TgfpwEYnmKjksfoxthDptm8C+FoPabrsagLKg9WI4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L4ZisZazfxkQyRzsBc1DFj1Jf0TPdUw/h6hTkEARkhMWU4WnwO0i2m6OS0rPwRFkq4GIzLAhdJo6sEYD3ZUdn4t9i0nyF9fW+UTM46TgHqwKdmuuHNcefgQHDGuY8fItXa6+YhklUDGco84Dt+JuwlCPlhcgAy7AknlwCyCds1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4NkAnmkY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-724f6189a4aso438604b3a.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757693; x=1733362493; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BuRB4e+BKWYqUslKZtGLdpJClrWdnWQipKEdNA7FnVs=;
        b=4NkAnmkYCt7CUsa5AQP4QfLztlobNsS6EoqEVEL9nwBSULLFwQPIeTRqzkYgznE93W
         yChG0T8U6Fk9tFkClsDni/lljHlzAlG10oGxopSAiHxlmEQ9kudBvnG+vKMJEBRybwRN
         0y67J+MqNPN9BJgp/TrdjHFcSJDmg/3+VRtYuMPAGfDmRYOrPXyuEkkpGobOptW8Yiue
         xwreUkKHXyksOOUHMcoMU0tjYFlQ8k1owSOc2o2WPBII2URPjs67i0cdokSJiYbKo1tW
         DbyQsCltlx0TQln8kDXczVblTQ8LLidpuOV3bbpGYOxxhaHU1TV/xzEp8+InSX0X86LF
         UQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757693; x=1733362493;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BuRB4e+BKWYqUslKZtGLdpJClrWdnWQipKEdNA7FnVs=;
        b=JhgHJtNYNIfUk4Di/fkMMRclq4wcAELauJzkeFbi4Ta3Vhe5Kxp3ezqcYj0UwTCGXQ
         W9IR1RwmK9w/biFjj6PN1khBV867Lf7TFw/Um5pG/qEYO7FNptACb4DCd6N8lWEpys3K
         fKG8osbR6B7XBdzoDSx3Hnns8Cl2ODxw7lT0Nqh1mWPSyeGJU5LcO+yGNVuEoKzKPwrn
         lAxrj77xiJM4Gln9EepZhlQ7c0Q7gqswM6GTLkZAPDqVsC1SPnngSq+LBzCGT8fX+nTj
         GkyI74uf4NkijiQ4cDURpj2l39tzVBdFRexIHL2Wkp4ZYnzouoUAAX/2qjsWVnYlpggM
         i4Tg==
X-Gm-Message-State: AOJu0YwRCa9uZo1Y3eWY/Vcgck0lQCP8ezJBnZmqzvC7J4Ge3XWLNIAN
	GMq6OXccEDNKWsCd/bMeW6rzaNThUJfZRQgyrpdmt4H9x6HevbFbcL86iCFoap9JuxObNuAYMOr
	Kgg==
X-Google-Smtp-Source: AGHT+IFqVKIMc2zms0SLeFnndp4IUez32dpv4m6eZYt8umTpWMW5ImU5nw07yWuaWXpp5oat3E/hS7dsII8=
X-Received: from pfbjc41.prod.google.com ([2002:a05:6a00:6ca9:b0:724:eb96:cf5c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d20:b0:71d:f4ef:6b3a
 with SMTP id d2e1a72fcca58-7253013e407mr7248277b3a.21.1732757693288; Wed, 27
 Nov 2024 17:34:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:39 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-13-seanjc@google.com>
Subject: [PATCH v3 12/57] KVM: x86: Drop now-redundant MAXPHYADDR and GPA rsvd
 bits from vCPU creation
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Drop the manual initialization of maxphyaddr and reserved_gpa_bits during
vCPU creation now that kvm_arch_vcpu_create() unconditionally invokes
kvm_vcpu_after_set_cpuid(), which handles all such CPUID caching.

None of the helpers between the existing code in kvm_arch_vcpu_create()
and the call to kvm_vcpu_after_set_cpuid() consume maxphyaddr or
reserved_gpa_bits (though auditing vmx_vcpu_create() and svm_vcpu_create()
isn't exactly easy).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5c6ade1f976e..d6a182d94c6f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12258,9 +12258,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		goto free_emulate_ctxt;
 	}
 
-	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
-
 	kvm_async_pf_hash_reset(vcpu);
 
 	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS)) {
-- 
2.47.0.338.g60cca15819-goog


