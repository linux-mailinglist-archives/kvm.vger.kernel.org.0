Return-Path: <kvm+bounces-13403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF916895F54
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 00:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E8F5B22D16
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 22:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD2A15E80F;
	Tue,  2 Apr 2024 22:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yMy6OuHc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FBC15AAA7
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 22:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712095606; cv=none; b=NoKt9G7PShKbV4LWKwuEXORhywo6waOMsjiCmngSHhOoSouuT3wDykv2NrkpRTnjL4aQ4iTcPxauGWSaPBhP5TkO+TzTTFZ1L7lSfKJoq3ET0kQN28wkKg4qpeSS2KlNIag/amFspbf2VhW18CGUuTESfKqyNxvgcv4KgDKcvGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712095606; c=relaxed/simple;
	bh=gc67t4TQZdhFsLXrfYpX3irGFaSP2P1z4uhMPfeyJJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KkfGlTECm5ubbIF7zpq259legoQdnTRiNSlTorgJDcW9rDUa7KmnV7xXbs5NBPti8THHw+jXYjcbMyTv87zF3bhJFitxClVx0qIO7ExHdMjPRaO/20gOeIq52Kqb8sY3gAqm9WlXiHYWSF/vlf8II0F+oqYN3fOntGc7rxF/WAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yMy6OuHc; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dccc49ef73eso8052727276.2
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 15:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712095603; x=1712700403; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LbzcEkoH2vtS5gyXSIOr3X9yBMy7dAbhnmUeGdXluDE=;
        b=yMy6OuHcrwCzUuWaSekIWU/G1xfADTs8bZuMq4VApsDp4a/4BysPX/VVIwVSRJqivc
         8YZH8pOSBYnQC8WL8HpfYqSKB3ffkB199R3eV+hj/V28se6+gvgk6PFeJNH+dn0GZcWU
         Bvzq1KrLtgglROEcUzanw2Zw0b4b6PnoLkvCG9qvYytIuw4TMmzmR8Fhl8DkJZcYr4F0
         Wl2Ue/E+1Jq67kOkalrBOjhoX+M3VWSGpfe78XxgdJuNxKU8kjWO++QuKabRe82kNC3E
         /e1dr1lGoofCL4BHX6L47sCWjH0NBd1GIVuDr6fSF/P5EuglvfUA1pM+HCVW9k2iy8rM
         L0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712095603; x=1712700403;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LbzcEkoH2vtS5gyXSIOr3X9yBMy7dAbhnmUeGdXluDE=;
        b=Oy0vDbAa5Nh69QRMaE/PYoMztZssw6c3XaDSswTfEb2J0SEpjGn5RZjCcJLAn6wOjP
         wr38i/CggSmJ5hH/qLLw5qYpN59UWeugn0VqSfhvaodzMHkF45XKuYEtz6zh07+m2pks
         p+mG25ifD/0aVI216GZdNuU8mtc/oN5xltsOJpPGHoxatOHnUC4Ibg6zPc5Jmfkf8Zd3
         5cNSlxKv3wTCxhoyeDdt50jCJIFi4ZDbE4oKVMmn9jueH0sJ+2Btl63O7kDk7ZfS3vPy
         3thfZ6SiTpbixmmYxOzMQTn9xyVXatyla/Lsp6HdX8xUouHBR31FOf3tSrLWPfMp+cYZ
         Pb7g==
X-Forwarded-Encrypted: i=1; AJvYcCUhT7TGeLQh5D5OEVWW7Nba19DpLZ2yyCOAwpzqbHaQ5Z+lP8kEZmtCpxOk6WPfH/H1V6I6GfXFVGq7W724A3x7pOuE
X-Gm-Message-State: AOJu0YxJ3WrB/jlAjkLWg9hSWgtHxIC0aZIojodpznBo0gfW9ntzNeBl
	Pmp6lzzAtZ260bSa/jvy0hZTEyiFbQWxEJ3S7svoN6JfGvbiwGz3oPFm9faJNkgxj5Rz0r4l55H
	2Xw==
X-Google-Smtp-Source: AGHT+IErw3oJaU9VeTKiQJeJdv90U2YEVLX/zdD+RuNVUMd125M6qwXoPy2Jo10L4HeVxq+yacNv1PV2bl0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2309:b0:dbe:a0c2:df25 with SMTP id
 do9-20020a056902230900b00dbea0c2df25mr1151159ybb.8.1712095603556; Tue, 02 Apr
 2024 15:06:43 -0700 (PDT)
Date: Tue, 2 Apr 2024 15:06:42 -0700
In-Reply-To: <1e063b73-0f9a-4956-9634-2552e6e63ee1@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com> <20240309012725.1409949-9-seanjc@google.com>
 <ZfRtSKcXTI/lAQxE@intel.com> <ZfSLRrf1CtJEGZw2@google.com> <1e063b73-0f9a-4956-9634-2552e6e63ee1@intel.com>
Message-ID: <ZgyBckwbrijACeB1@google.com>
Subject: Re: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate mask
 in its accessor
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 01, 2024, Xiaoyao Li wrote:
> On 3/16/2024 1:54 AM, Sean Christopherson wrote:
> > On Fri, Mar 15, 2024, Zhao Liu wrote:
> > > On Fri, Mar 08, 2024 at 05:27:24PM -0800, Sean Christopherson wrote:
> > > > Use vmx_misc_preemption_timer_rate() to get the rate in hardware_setup(),
> > > > and open code the rate's bitmask in vmx_misc_preemption_timer_rate() so
> > > > that the function looks like all the helpers that grab values from
> > > > VMX_BASIC and VMX_MISC MSR values.
> > 
> > ...
> > 
> > > > -#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
> > > >   #define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
> > > >   #define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
> > > >   #define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
> > > > @@ -162,7 +161,7 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
> > > >   static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
> > > >   {
> > > > -	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
> > > > +	return vmx_misc & GENMASK_ULL(4, 0);
> > > >   }
> > > 
> > > I feel keeping VMX_MISC_PREEMPTION_TIMER_RATE_MASK is clearer than
> > > GENMASK_ULL(4, 0), and the former improves code readability.
> > > 
> > > May not need to drop VMX_MISC_PREEMPTION_TIMER_RATE_MASK?
> > 
> > I don't necessarily disagree, but in this case I value consistency over one
> > individual case.  As called out in the changelog, the motivation is to make
> > vmx_misc_preemption_timer_rate() look like all the surrounding helpers.
> > 
> > _If_ we want to preserve the mask, then we should add #defines for vmx_misc_cr3_count(),
> > vmx_misc_max_msr(), etc.
> > 
> > I don't have a super strong preference, though I think my vote would be to not
> > add the masks and go with this patch.  These helpers are intended to be the _only_
> > way to access the fields, i.e. they effectively _are_ the mask macros, just in
> > function form.
> > 
> 
> +1.
> 
> However, it seems different for vmx_basic_vmcs_mem_type() in patch 5, that I
> just recommended to define the MASK.
> 
> Because we already have
> 
> 	#define VMX_BASIC_MEM_TYPE_SHIFT	50
> 
> and it has been used in vmx/nested.c,
> 
> static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
> {
> 	return (vmx_basic & GENMASK_ULL(53, 50)) >>
> 		VMX_BASIC_MEM_TYPE_SHIFT;
> }
> 
> looks not intuitive than original patch.

Yeah, agreed, that's taking the worst of both worlds.  I'll update patch 5 to drop
VMX_BASIC_MEM_TYPE_SHIFT when effectively "moving" it into vmx_basic_vmcs_mem_type().

Thanks!

