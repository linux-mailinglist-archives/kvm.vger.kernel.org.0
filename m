Return-Path: <kvm+bounces-15364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B12C8AB5C2
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 21:53:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2205C1F226DB
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 19:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAD113C9C8;
	Fri, 19 Apr 2024 19:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y7mZVB6F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308BA13C3F2
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 19:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713556403; cv=none; b=eYtH4ndDCtGly9bGcc8S4mRq9j/cua0n5Jf77HtjzCiVSuFcY/NjZHkqbXBmUH53b9rpA3krD8SVA/BUYv+RWxXuCLe7r7gceniAsYgkhVdpn5w1OsfoNIXg8P2Q8CPolMtGuiursSkIanrESbSBCYtwYy6V3ymJrxOmUoIW8rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713556403; c=relaxed/simple;
	bh=9OWcSt3yVGiW4uguyXv0diQ+gU+gxGZ9VFWWTIFQCPU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dmx3gn+8ldI17zVdPaAdoAYyOEic0bPK5bH1Ht+JEG3qJgdrGdCeF7rvo8crdfFJ64lgD6KGrkfmOtQPVZGmhyqKDEi+JCWlDtlvifrtYmnFNr0kh2zwX0DCUDKscXn0EliHZNddetU6dz4XtXe7zQEXCpLg+KMv/y/IIOIXsVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y7mZVB6F; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e2a5cb5455so29840335ad.2
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713556401; x=1714161201; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RyXlje7tlmjC6LDfIbraTHbtAwfnUO3tmVw5L5e0voM=;
        b=Y7mZVB6FPvjGsa9VTdOiDkZo3S3mKIftvRz0/AfLat6tQl8GHABy2cmdzGOit77Lbg
         BMZ1/dfgXFPdPqlon9F9LITz3us0D0ysnMpdtnaSlL8u3VJyXqSuhDuhjD7lNLY9VXF4
         72HE/DPk30KpeG1fUY3Vjtir8D0Kc/vp9wddmj/KYFLW93hqT+LezJTypTNKsUAheHzB
         HPX4WfsBu4BFlpQuxkRZop/0KBdSbTiG5e4r5icBlIT+IPMnfiwI7O6Np0pmioTLnNG+
         KOVGGArBEFxSR+f6Ht8qxrMR3JnZhCp14jS76cvc+OIEcLjAFCyIhxBR6qGs9dBPuEeJ
         SNTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713556401; x=1714161201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RyXlje7tlmjC6LDfIbraTHbtAwfnUO3tmVw5L5e0voM=;
        b=Ewo6UFjL2+OP7J5ShRDu8JGzLHf8WdKbvQVdz2lwhSnNlO2a583Hdi6wUmlNAZNP1N
         kedXGB6ukl36GEjWxb7KrpylRijpNcPszhqKzHwXND/HrpXLaWh/4dt+j5Nr1LAwZqn4
         adMZ8Nd03i2nNvF0fOHbxjBES2RB6Fgc/wfU2QWWcB3Yx983xMNBW6Y7QBQnI2libIQ0
         I92+A0MmmOBVfFuSZ9A5JC3Vdvvreva3KflyCK8z3nHqg/ZzGPToeoX/gh3woxIakkvT
         781SW+9uLWvWb5XeWFDrcpj11AE3xkA/fYEw5xehgaq2daxu7RfLpzr/57uTE6AYvao8
         4LKg==
X-Forwarded-Encrypted: i=1; AJvYcCWMaJ4kYqRaygtnUpHVELsNoo5n12RkazGF5baXlIfjRMoVeEaeirgAvwmnahpaIkNdR+TfLemlQqBpYD79MdS2Kj/C
X-Gm-Message-State: AOJu0YzaY536tsdyvlnhgCCVRlBhiJIv+3Op9cKZRLLjNkv/0niTQYus
	APS6OEMBKV+iMTpqr+PlwyRPJlaA3WtwMT6Bhk242X/rq9JUSRCMK25vSjteSblRzphCznxpbDV
	dcA==
X-Google-Smtp-Source: AGHT+IE7Tx4wWL7LXm8ank13gSpeI651363AT50rpGcBKQD9CVQX/vTBwgCbg58Oz/RmKRPHnsgc6TCln1o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea06:b0:1e8:6d8b:5fee with SMTP id
 s6-20020a170902ea0600b001e86d8b5feemr273152plg.5.1713556401455; Fri, 19 Apr
 2024 12:53:21 -0700 (PDT)
Date: Fri, 19 Apr 2024 12:53:19 -0700
In-Reply-To: <7otbchwoxaaqxoxjfqmifma27dmxxo4wlczyee5pv2ussguwyw@uqr2jbmawg6b>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com> <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com> <ZfR4UHsW_Y1xWFF-@google.com>
 <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
 <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com>
 <m536wofeimei4wdronpl3xlr3ljcap3zazi3ffknpxzdfbrzsr@plk4veaz5d22>
 <ZiFlw_lInUZgv3J_@google.com> <7otbchwoxaaqxoxjfqmifma27dmxxo4wlczyee5pv2ussguwyw@uqr2jbmawg6b>
Message-ID: <ZiLLrzGqSIxoirwx@google.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
From: Sean Christopherson <seanjc@google.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Tina Zhang <tina.zhang@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, Kai Huang <kai.huang@intel.com>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 19, 2024, kirill.shutemov@linux.intel.com wrote:
> On Thu, Apr 18, 2024 at 11:26:11AM -0700, Sean Christopherson wrote:
> > On Thu, Apr 18, 2024, kirill.shutemov@linux.intel.com wrote:
> > I think having one trampoline makes sense, e.g. to minimize the probability of
> > leaking register state to the VMM.  The part that I don't like, and which generates
> > awful code, is shoving register state into a memory structure.
> 
> I don't think we can get away with single trampoline. We have outliers.

Yeah, I should have said "one trampoline for all of the not insane APIs" :-)

> See TDG.VP.VMCALL<ReportFatalError> that uses pretty much all registers as
> input. And I hope we wouldn't need TDG.VP.VMCALL<Instruction.PCONFIG> any
> time soon. It uses all possible output registers.

XMM: just say no.

> But I guess we can make a *few* wrappers that covers all needed cases.

Yeah.  I suspect two will suffice.  One for the calls that say at or below four
inputs, and one for the fat ones like ReportFatalError that use everything under
the sun.

For the latter one, marshalling data into registers via an in-memory structure
makes, especially if we move away from tdx_module_args, e.g. this is quite clean
and reasonable:

	union {
		/* Define register order according to the GHCI */
		struct { u64 r14, r15, rbx, rdi, rsi, r8, r9, rdx; };

		char str[64];
	} message;

	/* VMM assumes '\0' in byte 65, if the message took all 64 bytes */
	strtomem_pad(message.str, msg, '\0');

	/*
	 * This hypercall should never return and it is not safe
	 * to keep the guest running. Call it forever if it
	 * happens to return.
	 */
	while (1)
		tdx_fat_tdvmcall(&message);

> > Weird?  Yeah.  But at least we one need to document one weird calling convention,
> > and the ugliness is contained to three macros and a small assembly function.
> 
> Okay, the approach is worth exploring. I can work on it.
> 
> You focuses here on TDVMCALL. What is your take on the rest of TDCALL?

Not sure, haven't looked at them recently.  At a glance, something similar?  The
use of high registers instead of RDI and RSI is damn annoying :-/

Hmm, but it looks like there are enough simple TDCALLs that stay away from high
registers that open coding inline asm() is a viable (best?) approach.

RAX being the leaf and the return value is annoying, so maybe a simple macro to
make it easier to deal with that?  It won't allow for perfectly optimal code
generation, but forcing a MOV for a TDCALL isn't going to affect performance, and
it will make reading the code dead simple.

  #define tdcall_leaf(leaf) "mov $" leaf ", %%eax\n\t.byte 0x66,0x0f,0x01,0xcc\n\t"

Then PAGE_ACCEPT is simply:

	asm(tdcall_leaf(TDG_MEM_PAGE_ACCEPT)
	    : "=a"(ret),
            : "c"(start | page_size));
	if (ret)
		return 0;

And even the meanies that use R8 are reasonably easy to handle:

	asm("xor %%r8d, %%r8d\n\t"
	    tdcall_leaf(TDG_MR_REPORT)
	    : "=a"(ret)
	    : "c"(__pa(report)), "d"(__pa(data)));


and (though using names for the outputs, I just can't remember the syntax as I'm
typing this :-/)

	asm(tdcall_leaf(TDG_VM_RD)
	    "mov %%r8, %0\n\t"
	    : "=r"(value), "=a"(ret)
	    : "c"(0), "d"(no_idea_what_this_is));

	if (ret)
		<cry>

	return value;

Or, if you wanted to get fancy, use asm_goto_output() to bail on an error so that
you could optimize for using RAX as the return value, because *that's going to
make all the difference :-D


