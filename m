Return-Path: <kvm+bounces-66178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E793CC878B
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 16:35:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 289E53031E81
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 15:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3183644C0;
	Wed, 17 Dec 2025 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gSynCtPL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AD535C19B
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 14:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765982290; cv=none; b=DbPgrbJZtm4GoltYpH1ALdb3ZmJ/mAc2eueZ2FB1Gyxqh8mXSOQegC+0DIDBOxuJP4Vq20GV1KBOuGJ2wuj4XWRlsr8K9V83E4d/gAR9OqK0bmuahUf2kHCNEXnmUs1eeyuWEZZfL9JfprFBs66nzTBMp337geKmoSYjKP5IoAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765982290; c=relaxed/simple;
	bh=cBlbMBOqiao3hmgU4VDu7RiTtLjwDWZEgH2gn+4jAFo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qhvlk7A36nQ0JW7UBd4EvCib2Y7zppnvH87jXFV7IrfhGYtIRkYF3BCaUuSjRablN+frnZm8xqDwQCB8CJtVTFQEEs2+UxX63I/WloNRvurc7l/1NJC2RSUBAgXyx2XpY/kAcjFQ/0z/iwDNpky6tWsoCtKFIp079SSWChAoJBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gSynCtPL; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab459c051so14522552a91.0
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 06:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765982288; x=1766587088; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+wqFRGzMbAQleARlsynIzR59u7ACbd775POepAtx9QI=;
        b=gSynCtPLdVIqe/kfY/fsSIy6hnGNqHz/jztu24jBTqZ151UiR7jyk5cJk7lN+I7Ovt
         nN0gLQlti/EMWE0R6dcnaRFNroF4ZizXYnkYQ8mIypqbeyss2ebwHllvV8xTkXaKKrQl
         /pxENFv0NdhY0bREGVa24Q+TEX56WYnKpZUEoiFsxfmkf+LqU5JqOm/Jrr6SAJVqpH2a
         oxVJ/g6b+mTtcJktxwwXBLKQPDt4t5tswW9UXmaJTQDFqxMLS0EIYhieZFkWMNKhCLKD
         s++FuJ7axS6bSAN7D+x7frjIOm/oh57liL54gPu6zXKAQG1ND9nmwEQAWHb2OomqCNX4
         H+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765982288; x=1766587088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+wqFRGzMbAQleARlsynIzR59u7ACbd775POepAtx9QI=;
        b=IQrNswyxY6WBlSosGiJ44glJQKtzolEMx7VooRu1SZ1L6I0Cp/t/QKsoKQ2bz46e0l
         iS6JypyFP/OFCh42tutSo+NL3j3khm5nfvzdCa2nGYU5brN88ztKU9oCdZiDaCdcoNoF
         SSUuHDF0BuQpy3J/kQVGS+OLbJ8TisdcMqk90Q+MRArnLWZ01hCAzAyK9C2+Qrr+ygv+
         KpD5oDdvnkeep90uo8ExYUHcq68CewJUAkfMCWLi4bb71h4WjH4vYXCjVdznRSys/+tn
         LjvhGUshHiIFXuttV1u9UwZYuCycE/JuBkyomCcUAzod6pcerZ2JCZ5xdCr7jcNomVX6
         oOCQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4o0tmLaDNYUMOPaURYG1g6jaRBGaR+Ln7uxPD5ZXkE0IBsWCsYtI/Istc+AERi+40K5U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkIPa0wd/EQFQ8Hu2lVj0xlC8Lw9o6UEoia2DkwCvow7VlvtsE
	+mYOreHFRTUc8Ot9O6WOKankkdVMl8BYdTW5ZJI2WOLhxcBNVldX10804Kwh7vZCM1TgkkQl5xc
	h8whxzA==
X-Google-Smtp-Source: AGHT+IFgoiSRhCa2DGqzmwKewI52pPql69AlIaj8ohvOK+OVLpF3ooUoJXmlDlOgZajNtUgMUInbNQ5aMKk=
X-Received: from pjbnc15.prod.google.com ([2002:a17:90b:37cf:b0:340:631a:67fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc6:b0:34a:b8e0:dd59
 with SMTP id 98e67ed59e1d1-34abd6e0451mr17003159a91.15.1765982288210; Wed, 17
 Dec 2025 06:38:08 -0800 (PST)
Date: Wed, 17 Dec 2025 06:38:06 -0800
In-Reply-To: <aUJqoJMVoGebFqv4@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251216012918.1707681-1-seanjc@google.com> <aUJqoJMVoGebFqv4@intel.com>
Message-ID: <aULATi4uMa-5z08k@google.com>
Subject: Re: [PATCH] KVM: nVMX: Disallow access to vmcs12 fields that aren't
 supported by "hardware"
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 17, 2025, Chao Gao wrote:
> >+static __init bool cpu_has_vmcs12_field(unsigned int idx)
> >+{
> >+	switch (VMCS12_IDX_TO_ENC(idx)) {
> >+	case VIRTUAL_PROCESSOR_ID: return cpu_has_vmx_vpid();
> >+	case POSTED_INTR_NV: return cpu_has_vmx_posted_intr();
> >+	VMCS12_CASE64(TSC_MULTIPLIER): return cpu_has_vmx_tsc_scaling();
> >+	VMCS12_CASE64(VIRTUAL_APIC_PAGE_ADDR): return cpu_has_vmx_tpr_shadow();
> >+	VMCS12_CASE64(APIC_ACCESS_ADDR): return cpu_has_vmx_virtualize_apic_accesses();
> >+	VMCS12_CASE64(POSTED_INTR_DESC_ADDR): return cpu_has_vmx_posted_intr();
> >+	VMCS12_CASE64(VM_FUNCTION_CONTROL): return cpu_has_vmx_vmfunc();
> >+	VMCS12_CASE64(EPT_POINTER): return cpu_has_vmx_ept();
> >+	VMCS12_CASE64(EPTP_LIST_ADDRESS): return cpu_has_vmx_vmfunc();
> >+	VMCS12_CASE64(XSS_EXIT_BITMAP): return cpu_has_vmx_xsaves();
> >+	VMCS12_CASE64(ENCLS_EXITING_BITMAP): return cpu_has_vmx_encls_vmexit();
> >+	VMCS12_CASE64(GUEST_IA32_PERF_GLOBAL_CTRL): return cpu_has_load_perf_global_ctrl();
> >+	VMCS12_CASE64(HOST_IA32_PERF_GLOBAL_CTRL): return cpu_has_load_perf_global_ctrl();
> >+	case TPR_THRESHOLD: return cpu_has_vmx_tpr_shadow();
> >+	case SECONDARY_VM_EXEC_CONTROL: return cpu_has_secondary_exec_ctrls();
> >+	case GUEST_S_CET: return cpu_has_load_cet_ctrl();
> >+	case GUEST_SSP: return cpu_has_load_cet_ctrl();
> >+	case GUEST_INTR_SSP_TABLE: return cpu_has_load_cet_ctrl();
> >+	case HOST_S_CET: return cpu_has_load_cet_ctrl();
> >+	case HOST_SSP: return cpu_has_load_cet_ctrl();
> >+	case HOST_INTR_SSP_TABLE: return cpu_has_load_cet_ctrl();
> 
> Most fields here are not shadowed, e.g., CET-related fields. So, the plan is
> that new fields should be added here regardless of whether they are shadowed or
> not, right?

Yep.  It'll be mildly annoying to keep up-to-date, but I hopefully having an
"unconditional" rule will be less confusing than limiting the checks to fields
that are allowed to hit the shadow VMCS.

> And GUEST_INTR_STATUS is missing here. It depends on APICv and is handled
> explicitly in init_vmcs_shadow_fields().

Gah, I had that one on my todo list, but got sidetracked for a week and completely
forgot about it.

Thank you!

