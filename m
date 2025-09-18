Return-Path: <kvm+bounces-58040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2786DB865EE
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 20:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 803201CC0CF8
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66CF42BEC41;
	Thu, 18 Sep 2025 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kB6oDm10"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314C0291C07
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 18:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758218726; cv=none; b=D6lx4G9QqvgA8fH9ShQXp2AzvPuwnvZLTMEOg8LhB+C4VKCn3bvM8CSOEeq+yu0clODeKEq2P3JkKvio4dxxhFxLAG8YNJA6PTylsTjpRiZEoi8bXz8kp1Ep2GDUCU13/eg1gm6lD1Z0nB7d0X/YZmIlvao3cNcdA+e2+4OloHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758218726; c=relaxed/simple;
	bh=C9lclqO6tgNXX87BkKR84qSe/JvjzZzxbw+fHgRwFi0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H/8vUAgUG+KNEObd1Pk1mFeCTZ9Tj0wF7weg8HkW0ReIWlOofUhAbl2G3w4zNqLBFB2bQQuwcKEEmUz/+kN9G2qVsfTzGZckcD8YXc+R5eU/7SFM07IEr5a4eDg4ikwa5BhgH05c+vdoTgBuhd8bXAX1RB50WS2ujOTTWrfSBhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kB6oDm10; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-324e41e946eso1975136a91.0
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 11:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758218724; x=1758823524; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sRTmPNKU6v/1+UFt0kyp6DGr/58mo24d1Go0VmSLn5A=;
        b=kB6oDm10ibaD56I6dBhC0IGqqgDCXJjM9ZY9YRRJGZnwTS3o9wSE513tgDbT/Z343E
         8IFmA/jSmFXbQA5fZPCFOSy89AqnO0s2h3pJ7JuYVxLLIH12djjDjD3ZuaMeNrS+We78
         1WouB3Jo+Rm+9Mz675lnz3hgP+nI0xVD2+/+eWF+BKEMjyAHjyO5yvj2lBfIZuvvcs6V
         WdlbqURUoSYZOA3rk5UKhQcGaicLJF2g6H00gfwGB9nXYwZfr1p+/wCbxETg9qdvNcEX
         H1H5MwLm3kxzVZtAqnth5eiR7RIRhkP0PJKqM51lOl+/Q2IkcLr2XGazRKgBP/Kyexy6
         E/Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758218724; x=1758823524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sRTmPNKU6v/1+UFt0kyp6DGr/58mo24d1Go0VmSLn5A=;
        b=XJg4X8qLFIba8QXx4c4Qv83GgWb8yuFR7x6NW27OTmF4L00kFyd8NNqh8mbcG3ACVi
         xH/6FzBHE1HYtNc9s769TNYrsTtCSiashB7V1VuK2Wpe1MaqNFGvGwb/3Gxptim+kh15
         I5RmyXhI5naqDftyTXyr4R7WVlJrAw0H7xIa5wfLpSHTgvFsBbOKD/zbztYi3KaFxi1J
         tkXVC1R8wXtv212x5oX/eC7rDCaO4ViQLfWJ7BYiKRE9NVpDAk2GYIzWNiRvUVmQUg1v
         mbNTkgwhGtgZkHIVC6kJ1LGRJC/ymPr8H475VEACIe2SALJqhUB2EX5xKJ/4wRadJc4h
         tcZA==
X-Forwarded-Encrypted: i=1; AJvYcCVuoUEwo9KZ1VjJxk4exnKqEzVAFU6qCagokzt/74wcHfRk/MeE45NBOttGbphfrAUPK3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQYE73PQf5C7bPXvN8sXhh4DdeqxjRn/USyvOBUHKTPjoUpdaD
	wf0vFPdDl8Zp11SqvoATp2jrat6dlE7B+2gSqrzncG+qHVoMpmHKNJZXplomCkQbdwlGo4KyfuN
	74VOJPA==
X-Google-Smtp-Source: AGHT+IG8BhyIO0XRQSnnf17kMbBiavmBffWKE92Xd/30IMC4yGXIT9j1kFk0ZAJ0NwEr+YARBHNZLAHWZr0=
X-Received: from pjbso12.prod.google.com ([2002:a17:90b:1f8c:b0:32b:5548:d659])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d60c:b0:32e:7bbc:bf13
 with SMTP id 98e67ed59e1d1-3309838d043mr322294a91.34.1758218724554; Thu, 18
 Sep 2025 11:05:24 -0700 (PDT)
Date: Thu, 18 Sep 2025 11:05:23 -0700
In-Reply-To: <26947f1a-2162-4083-b39f-c360d6046877@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-22-seanjc@google.com>
 <26947f1a-2162-4083-b39f-c360d6046877@zytor.com>
Message-ID: <aMxJ4zQkTFPD0xkq@google.com>
Subject: Re: [PATCH v15 21/41] KVM: nVMX: Prepare for enabling CET support for
 nested guest
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 17, 2025, Xin Li wrote:
> On 9/12/2025 4:22 PM, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> > index 56fd150a6f24..4ad6b16525b9 100644
> > --- a/arch/x86/kvm/vmx/vmcs12.h
> > +++ b/arch/x86/kvm/vmx/vmcs12.h
> > @@ -117,7 +117,13 @@ struct __packed vmcs12 {
> >   	natural_width host_ia32_sysenter_eip;
> >   	natural_width host_rsp;
> >   	natural_width host_rip;
> > -	natural_width paddingl[8]; /* room for future expansion */
> > +	natural_width host_s_cet;
> > +	natural_width host_ssp;
> > +	natural_width host_ssp_tbl;
> > +	natural_width guest_s_cet;
> > +	natural_width guest_ssp;
> > +	natural_width guest_ssp_tbl;
> > +	natural_width paddingl[2]; /* room for future expansion */
> >   	u32 pin_based_vm_exec_control;
> >   	u32 cpu_based_vm_exec_control;
> >   	u32 exception_bitmap;
> > @@ -294,6 +300,12 @@ static inline void vmx_check_vmcs12_offsets(void)
> >   	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
> >   	CHECK_OFFSET(host_rsp, 664);
> >   	CHECK_OFFSET(host_rip, 672);
> > +	CHECK_OFFSET(host_s_cet, 680);
> > +	CHECK_OFFSET(host_ssp, 688);
> > +	CHECK_OFFSET(host_ssp_tbl, 696);
> > +	CHECK_OFFSET(guest_s_cet, 704);
> > +	CHECK_OFFSET(guest_ssp, 712);
> > +	CHECK_OFFSET(guest_ssp_tbl, 720);
> >   	CHECK_OFFSET(pin_based_vm_exec_control, 744);
> >   	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
> >   	CHECK_OFFSET(exception_bitmap, 752);
> 
> 
> This patch modifies struct vms12 without updating the corresponding vmcs12
> definition in Documentation/virt/kvm/x86/nested-vmx.rst.  However,
> duplicating the definition within the same source tree seems unnecessary
> and prone to inconsistencies.  E.g., the following fields are missing in
> Documentation/virt/kvm/x86/nested-vmx.rst:
> 
> 	...
> 	u64 posted_intr_desc_addr;
> 	...
> 	u64 eoi_exit_bitmap0;
> 	u64 eoi_exit_bitmap1;
> 	u64 eoi_exit_bitmap2;
> 	u64 eoi_exit_bitmap3;
> 	u64 xss_exit_bitmap;
> 	...
> 
> What's more, the 64-bit padding fields are completely messed up; we have
> used 9 u64 after host_ia32_efer:
> 
>         u64 host_ia32_perf_global_ctrl;
>         u64 vmread_bitmap;
>         u64 vmwrite_bitmap;
>         u64 vm_function_control;
>         u64 eptp_list_address;
>         u64 pml_address;
>         u64 encls_exiting_bitmap;
>         u64 tsc_multiplier;
>         u64 padding64[1]; /* room for future expansion */
> 
> 
> But it's 8 u64 after host_ia32_efer in the documentation:
> 
> 	u64 padding64[8]; /* room for future expansion */
> 
> 
> We probably should remove it from Documentation/virt/kvm/x86/nested-vmx.rst
> and instead add a reference to arch/x86/kvm/vmx/vmcs12.h.

Yeah, the paragraph above is also stale, see commit cb9fb5fc12ef ("KVM: nVMX:
Update VMCS12_REVISION comment to state it should never change") (I forgot that
Documentation/virt/kvm/x86/nested-vmx.rst existed).

  For convenience, we repeat the content of struct vmcs12 here. If the internals
  of this structure changes, this can break live migration across KVM versions.
  VMCS12_REVISION (from vmx.c) should be changed if struct vmcs12 or its inner
  struct shadow_vmcs is ever changed.

