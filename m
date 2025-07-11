Return-Path: <kvm+bounces-52156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 415C8B01CED
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:07:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D91DD1894E44
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF392D12F6;
	Fri, 11 Jul 2025 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yR//a0dO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652CD28A73A
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239120; cv=none; b=OIAyl44787cpmgSbNBPTamvvdtjGXk7u90TT/6zdDMBlXZuZHLmbHJSWdFa6wK5XNPl0TE+Zi9hjMI4EEMGRp3xY0jLcyvub/Akh1gyV9CoAElJAh7O1BVbvfXqDkg8dcWePEMbnf4a0+E+gJwHGCL74TND+N8ogoRoT5cjNIzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239120; c=relaxed/simple;
	bh=MYqm8zjNLzsWhNoaJgWBTk1kmSsMxa8+rFquDwiG00g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=joZMkRr7X0TvCm1giryYth6FcyQMqzOsA7AGLlRF67oZ2k9mca60vc20KJ6I9DTY4GXZWemvVFvMViElQeQ2ghSX1oO0hi+d7DBgLPWE7WMB9UL0gdWdJ0/03vAuwadunscAviBllIvCO9UfSTb7A1PwbHpeunl3b3EEYSdmodo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yR//a0dO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31218e2d5b0so3836326a91.2
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 06:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752239119; x=1752843919; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QwYyJ5ZlztEdQTVfkhA2cf/LaOoL8V2/Ke015HjaX6w=;
        b=yR//a0dOl/iJQvQTOM7lIwFR5LZHSUTApyLD2M2ZCg2YYxS7zPhFeWDwbLotEUlYsc
         cKbIpfm2hBPfjfttZymN1tFJkv74H+v+npJB7z0Fp4cwRwLPo/Vryqbj+JxicQVO0a7E
         piGceRvGhvL+YtUHDYQjumHQYUZQrx+PmFN2Ba6fGJgBC47BBI0rdcvv+sSOqWKT4OKV
         zfwN18cNRwqLMGL1yci228kMwn8SkHOkZH+tyOBhrUT9ZTr7/dunNoOAwQjBQZ++m3FJ
         LVVQqo3YdvIOZVjRQKbYlDYHYCqlMJ1cmuprq918P4v59IhBaAVL4JJYJrmsUkwRin+I
         mdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752239119; x=1752843919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QwYyJ5ZlztEdQTVfkhA2cf/LaOoL8V2/Ke015HjaX6w=;
        b=mpgR33I+paGTShtpNuUzGHMCGsyh/0SsIptwsMVuyTUqJPt64c+H6lNs4bC4OQGdA6
         d4CjSiPpv082oS386Q6IPfJR+1JUSwuj06KXWNkFEPn+1MF++WWzxAfqseOkpwe2UYhm
         UlQVOYHwkQK8+TYfIyQ+oY6UBbyy5206r6rDA40VWitDdEwYDVyndIub+JUFI68EpLQC
         O8yDhXxsyHTdQyhqExpIFjf/eqDbhzklc0YuSfeEvNY5FPUw4Df5gypVojMlRL5HBbCT
         JATfSNkH3FVRl+9pQ1j6GGtgE5m1m69ku0S/JuAyGUZkAZgYDultCE2AN/B+Kw5W4Sm0
         xwXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcEOk2pLPTwnlezGeSJtZYOHlXLDcXPrw5oDWq/zNNBF3JvG+sucY+kNl34/ASDEOPkPM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCcdJ88CIeLT404n2ICXKXDGZa5LX778CN5/p6IfrIOk4BBVOk
	bEaIzHb7cQodzCb0B97lNasEr6YswWToT4+43/tXeTllmCt7aF42RBQi/Gdeezb8XhICwW0vh7c
	7lQjp+w==
X-Google-Smtp-Source: AGHT+IG/T/kETPzuUaDbQ/UeYIqSlIMYxr5rtfRan0dpxKkBR1ENcgjw540k090RWXQo7plxJAgD4CmFahw=
X-Received: from pjtq14.prod.google.com ([2002:a17:90a:c10e:b0:313:2213:1f54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:f944:b0:312:1c83:58f7
 with SMTP id 98e67ed59e1d1-31c4c96f436mr5438921a91.0.1752239118743; Fri, 11
 Jul 2025 06:05:18 -0700 (PDT)
Date: Fri, 11 Jul 2025 06:05:10 -0700
In-Reply-To: <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com> <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
Message-ID: <aHEMBuVieGioMVaT@google.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, tony.lindgren@linux.intel.com, 
	binbin.wu@linux.intel.com, isaku.yamahata@intel.com, 
	linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 11, 2025, Xiaoyao Li wrote:
> On 6/26/2025 11:58 PM, Sean Christopherson wrote:
> > On Wed, Jun 25, 2025, Sean Christopherson wrote:
> > > On Wed, 11 Jun 2025 12:51:57 +0300, Adrian Hunter wrote:
> > > > Changes in V4:
> > > > 
> > > > 	Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
> > > > 	Use KVM_BUG_ON() instead of WARN_ON().
> > > > 	Correct kvm_trylock_all_vcpus() return value.
> > > > 
> > > > Changes in V3:
> > > > 	Refer:
> > > >              https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
> > > > 
> > > > [...]
> > > 
> > > Applied to kvm-x86 vmx, thanks!
> > > 
> > > [1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
> > >        https://github.com/kvm-x86/linux/commit/111a7311a016
> > 
> > Fixed up to address a docs goof[*], new hash:
> > 
> >        https://github.com/kvm-x86/linux/commit/e4775f57ad51
> > 
> > [*] https://lore.kernel.org/all/20250626171004.7a1a024b@canb.auug.org.au
> 
> Hi Sean,
> 
> I think it's targeted for v6.17, right?
> 
> If so, do we need the enumeration for the new TDX ioctl? Yes, the userspace
> could always try and ignore the failure. But since the ship has not sailed,
> I would like to report it and hear your opinion.

Bugger, you're right.  It's sitting at the top of 'kvm-x86 vmx', so it should be
easy enough to tack on a capability.

This?

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f0d961436d0f..dcb879897cab 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -9147,6 +9147,13 @@ KVM exits with the register state of either the L1 or L2 guest
 depending on which executed at the time of an exit. Userspace must
 take care to differentiate between these cases.
 
+8.46 KVM_CAP_TDX_TERMINATE_VM
+-----------------------------
+
+:Architectures: x86
+
+This capability indicates that KVM supports the KVM_TDX_TERMINATE_VM sub-ioctl.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b58a74c1722d..e437a50429d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4823,6 +4823,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
        case KVM_CAP_READONLY_MEM:
                r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
                break;
+       case KVM_CAP_TDX_TERMINATE_VM:
+               r = !!(kvm_caps.supported_vm_types & BIT(KVM_X86_TDX_VM));
+               break;
        default:
                break;
        }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7a4c35ff03fe..54293df4a342 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -960,6 +960,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_TDX_TERMINATE_VM 243
 
 struct kvm_irq_routing_irqchip {
        __u32 irqchip;

