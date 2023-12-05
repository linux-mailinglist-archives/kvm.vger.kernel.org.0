Return-Path: <kvm+bounces-3475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0D44804EC6
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB9971C20D52
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 09:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0614B5C6;
	Tue,  5 Dec 2023 09:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PQ01vPfZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5251A2
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 01:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701770022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LXBzOhyUVUCPThPCdSFCYEKRLtKLuc2WijKLedKWSC8=;
	b=PQ01vPfZi1Bqk0MSKNp3KnvcePN3QRRHYOhy/nkWgHkUmaqtd7FX3hccYgPcG5uFzLiT5D
	t7o/8q+g9Ll0RPjIMVIUnt8RUe8uRMVCo7BzaxpEcArLA4bAiX27za9HsX5UiRrwXWwLjz
	KrtYEJqT2XL36PFD3W2KHefxDU7ZkF8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-nrcS9gqGPT-vW4JBD7Apjg-1; Tue, 05 Dec 2023 04:53:40 -0500
X-MC-Unique: nrcS9gqGPT-vW4JBD7Apjg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-332e2f70092so5028918f8f.0
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 01:53:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701770020; x=1702374820;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LXBzOhyUVUCPThPCdSFCYEKRLtKLuc2WijKLedKWSC8=;
        b=GwaQm7Z2KCBZZmJG+40v/w5GpuhM4CbFEdqqwT8AovfJAj6ppMsOjHuFumPD5rEglf
         y4L1CZttJS7Y5XOJKn/HfAJF5/pjgkUWE236T1BhB+2Rlw8p3SzK5nW7PT8IGldEPskQ
         +rq3IOh0diNfuHQZP7F9CLXrStU6Z7fNIuQDzSSRZYy28CcW9xrlB3IEuFI7cvyEnvWt
         ilCHvqX548TZp9aDHYp/Uqs9NSmdCErmcceRRDHPrHeByPs9XA82dnAUa6wKA8afE49d
         JHNnvbHl1KpsqbmUCZAwPbiH3VSsYC4R6+QSFAss+X39/AuBLHCkMxAJevSzWjCqV1mP
         MLcQ==
X-Gm-Message-State: AOJu0YwPjiOFVBKs9z7urOSWuERlWgBcSqtZKFfS2d1gmowqNNjlWO/T
	LW0Bm/UxGuDSJI/+xBbB2bDs8zNa66cGxq0NaSOYfF+26drxg99EDx3xmf+06LQN86QUIsaRAox
	0GeW3m/vSRKbr
X-Received: by 2002:adf:f74c:0:b0:333:2fd2:51e4 with SMTP id z12-20020adff74c000000b003332fd251e4mr4457127wrp.93.1701770019877;
        Tue, 05 Dec 2023 01:53:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEixdNSaQ7CenecOMM1PrlBZjkQmBN5BHbBoCkjJBIP8DQ4eFOT4s28S8Fz/YVErpQfmGl7pw==
X-Received: by 2002:adf:f74c:0:b0:333:2fd2:51e4 with SMTP id z12-20020adff74c000000b003332fd251e4mr4457112wrp.93.1701770019524;
        Tue, 05 Dec 2023 01:53:39 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id v15-20020a5d4a4f000000b0033328f47c83sm13128821wrs.2.2023.12.05.01.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 01:53:39 -0800 (PST)
Message-ID: <ca7c3071f17be6fa1f29f2d62cd53a66c97ea289.camel@redhat.com>
Subject: Re: [PATCH v7 03/26] x86/fpu/xstate: Add CET supervisor mode state
 support
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 dave.hansen@intel.com,  pbonzini@redhat.com, seanjc@google.com,
 peterz@infradead.org, chao.gao@intel.com,  rick.p.edgecombe@intel.com,
 john.allen@amd.com
Date: Tue, 05 Dec 2023 11:53:37 +0200
In-Reply-To: <ba6dc90a-64a7-4124-a9b9-c600f3bdbd19@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-4-weijiang.yang@intel.com>
	 <13aaf1272737737c29ab1de22438695637944d24.camel@redhat.com>
	 <ba6dc90a-64a7-4124-a9b9-c600f3bdbd19@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-12-01 at 15:01 +0800, Yang, Weijiang wrote:
> On 12/1/2023 1:27 AM, Maxim Levitsky wrote:
> > On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> > > Add supervisor mode state support within FPU xstate management framework.
> > > Although supervisor shadow stack is not enabled/used today in kernel,KVM
> > > requires the support because when KVM advertises shadow stack feature to
> > > guest, architecturally it claims the support for both user and supervisor
> > > modes for guest OSes(Linux or non-Linux).
> > > 
> > > CET supervisor states not only includes PL{0,1,2}_SSP but also IA32_S_CET
> > > MSR, but the latter is not xsave-managed. In virtualization world, guest
> > > IA32_S_CET is saved/stored into/from VM control structure. With supervisor
> > > xstate support, guest supervisor mode shadow stack state can be properly
> > > saved/restored when 1) guest/host FPU context is swapped 2) vCPU
> > > thread is sched out/in.
> > > 
> > > The alternative is to enable it in KVM domain, but KVM maintainers NAKed
> > > the solution. The external discussion can be found at [*], it ended up
> > > with adding the support in kernel instead of KVM domain.
> > > 
> > > Note, in KVM case, guest CET supervisor state i.e., IA32_PL{0,1,2}_MSRs,
> > > are preserved after VM-Exit until host/guest fpstates are swapped, but
> > > since host supervisor shadow stack is disabled, the preserved MSRs won't
> > > hurt host.
> > > 
> > > [*]: https://lore.kernel.org/all/806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com/
> > > 
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > ---
> > >   arch/x86/include/asm/fpu/types.h  | 14 ++++++++++++--
> > >   arch/x86/include/asm/fpu/xstate.h |  6 +++---
> > >   arch/x86/kernel/fpu/xstate.c      |  6 +++++-
> > >   3 files changed, 20 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
> > > index eb810074f1e7..c6fd13a17205 100644
> > > --- a/arch/x86/include/asm/fpu/types.h
> > > +++ b/arch/x86/include/asm/fpu/types.h
> > > @@ -116,7 +116,7 @@ enum xfeature {
> > >   	XFEATURE_PKRU,
> > >   	XFEATURE_PASID,
> > >   	XFEATURE_CET_USER,
> > > -	XFEATURE_CET_KERNEL_UNUSED,
> > > +	XFEATURE_CET_KERNEL,
> > >   	XFEATURE_RSRVD_COMP_13,
> > >   	XFEATURE_RSRVD_COMP_14,
> > >   	XFEATURE_LBR,
> > > @@ -139,7 +139,7 @@ enum xfeature {
> > >   #define XFEATURE_MASK_PKRU		(1 << XFEATURE_PKRU)
> > >   #define XFEATURE_MASK_PASID		(1 << XFEATURE_PASID)
> > >   #define XFEATURE_MASK_CET_USER		(1 << XFEATURE_CET_USER)
> > > -#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL_UNUSED)
> > > +#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL)
> > >   #define XFEATURE_MASK_LBR		(1 << XFEATURE_LBR)
> > >   #define XFEATURE_MASK_XTILE_CFG		(1 << XFEATURE_XTILE_CFG)
> > >   #define XFEATURE_MASK_XTILE_DATA	(1 << XFEATURE_XTILE_DATA)
> > > @@ -264,6 +264,16 @@ struct cet_user_state {
> > >   	u64 user_ssp;
> > >   };
> > >   
> > > +/*
> > > + * State component 12 is Control-flow Enforcement supervisor states
> > > + */
> > > +struct cet_supervisor_state {
> > > +	/* supervisor ssp pointers  */
> > > +	u64 pl0_ssp;
> > > +	u64 pl1_ssp;
> > > +	u64 pl2_ssp;
> > > +};
> > > +
> > >   /*
> > >    * State component 15: Architectural LBR configuration state.
> > >    * The size of Arch LBR state depends on the number of LBRs (lbr_depth).
> > > diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
> > > index d4427b88ee12..3b4a038d3c57 100644
> > > --- a/arch/x86/include/asm/fpu/xstate.h
> > > +++ b/arch/x86/include/asm/fpu/xstate.h
> > > @@ -51,7 +51,8 @@
> > >   
> > >   /* All currently supported supervisor features */
> > >   #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
> > > -					    XFEATURE_MASK_CET_USER)
> > > +					    XFEATURE_MASK_CET_USER | \
> > > +					    XFEATURE_MASK_CET_KERNEL)
> > >   
> > >   /*
> > >    * A supervisor state component may not always contain valuable information,
> > > @@ -78,8 +79,7 @@
> > >    * Unsupported supervisor features. When a supervisor feature in this mask is
> > >    * supported in the future, move it to the supported supervisor feature mask.
> > >    */
> > > -#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT | \
> > > -					      XFEATURE_MASK_CET_KERNEL)
> > > +#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT)
> > >   
> > >   /* All supervisor states including supported and unsupported states. */
> > >   #define XFEATURE_MASK_SUPERVISOR_ALL (XFEATURE_MASK_SUPERVISOR_SUPPORTED | \
> > > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > > index 6e50a4251e2b..b57d909facca 100644
> > > --- a/arch/x86/kernel/fpu/xstate.c
> > > +++ b/arch/x86/kernel/fpu/xstate.c
> > > @@ -51,7 +51,7 @@ static const char *xfeature_names[] =
> > >   	"Protection Keys User registers",
> > >   	"PASID state",
> > >   	"Control-flow User registers",
> > > -	"Control-flow Kernel registers (unused)",
> > > +	"Control-flow Kernel registers",
> > >   	"unknown xstate feature",
> > >   	"unknown xstate feature",
> > >   	"unknown xstate feature",
> > > @@ -73,6 +73,7 @@ static unsigned short xsave_cpuid_features[] __initdata = {
> > >   	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
> > >   	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
> > >   	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
> > > +	[XFEATURE_CET_KERNEL]			= X86_FEATURE_SHSTK,
> > >   	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
> > >   	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
> > >   };
> > > @@ -277,6 +278,7 @@ static void __init print_xstate_features(void)
> > >   	print_xstate_feature(XFEATURE_MASK_PKRU);
> > >   	print_xstate_feature(XFEATURE_MASK_PASID);
> > >   	print_xstate_feature(XFEATURE_MASK_CET_USER);
> > > +	print_xstate_feature(XFEATURE_MASK_CET_KERNEL);
> > >   	print_xstate_feature(XFEATURE_MASK_XTILE_CFG);
> > >   	print_xstate_feature(XFEATURE_MASK_XTILE_DATA);
> > >   }
> > > @@ -346,6 +348,7 @@ static __init void os_xrstor_booting(struct xregs_state *xstate)
> > >   	 XFEATURE_MASK_BNDCSR |			\
> > >   	 XFEATURE_MASK_PASID |			\
> > >   	 XFEATURE_MASK_CET_USER |		\
> > > +	 XFEATURE_MASK_CET_KERNEL |		\
> > >   	 XFEATURE_MASK_XTILE)
> > >   
> > >   /*
> > > @@ -546,6 +549,7 @@ static bool __init check_xstate_against_struct(int nr)
> > >   	case XFEATURE_PASID:	  return XCHECK_SZ(sz, nr, struct ia32_pasid_state);
> > >   	case XFEATURE_XTILE_CFG:  return XCHECK_SZ(sz, nr, struct xtile_cfg);
> > >   	case XFEATURE_CET_USER:	  return XCHECK_SZ(sz, nr, struct cet_user_state);
> > > +	case XFEATURE_CET_KERNEL: return XCHECK_SZ(sz, nr, struct cet_supervisor_state);
> > >   	case XFEATURE_XTILE_DATA: check_xtile_data_against_struct(sz); return true;
> > >   	default:
> > >   		XSTATE_WARN_ON(1, "No structure for xstate: %d\n", nr);
> > Any reason why my reviewed-by was not added to this patch?
> 
> My apology again! I missed the Reviewed-by tag for this patch!
> 
> Appreciated for your careful review for this series!

Thank you very much!

Best regards,
	Maxim Levitsky

> 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
> > 





