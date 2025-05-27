Return-Path: <kvm+bounces-47790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C957AC502F
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 15:47:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 586777AE2B2
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 13:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E5F274FF5;
	Tue, 27 May 2025 13:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kmqjg45m"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696EB25A344;
	Tue, 27 May 2025 13:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748353655; cv=none; b=VmBECRHC33p7C95d8pvhVcX0QUJgzpNrdrcUrU7ve14hOYP20tMEBnSgLLVHeThS/cIcE96OwgLtwQonBKOebAmOoXClBoXye6lhTsmy7YvUnJ8Z3lFKNZOlhNsX1pYbBYhHBdMwm7hK7E1cMxImIIG8b1IZNMm8HcnIoLQQNq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748353655; c=relaxed/simple;
	bh=Q7FXiFXElVbe3Rrts+wlF1qJ3QpjN3TjIPrPLQPCSVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivD2Ylr6BIMmNoutMDfGETTxE3yRBbvKURNftQc8qX7pyYP6+vJAGkgWC/dcir01gOemGJ0N7CcWAx5KoWDn9uIDLDPK599YTVWQL1ca3W+P153uW0ZBmncDfRoe126W6XQQ/Nx3gfAZIWDlHxbkYv0wIZx12632UgWc6eCNC6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Kmqjg45m; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zstxsZlP2zf0f8XCfGO5I37IYFJ8XGyJUPDphnrIkAc=; b=Kmqjg45mvWQF4Ne90msw30o8Q5
	DfeFrc6/ti5GzNXqAyGHzhMFR7jC9EqIv7J7BMedTFP1gnzR7+anqec890Yzjwf7E7fFSa06+8JGB
	QjNFhp1LmXCL7RZPHyYu/5rW+SqwbYAMTdmgxiGpD+8KaQE+JMd4SDt4Xkm8eDAHTaPxb41+ixr4c
	kZPgZFUH32N/SFdSYWazJlOTUh/3MXcjN02raHDe0nx6GAtEkogq0r+pR+p2t6Sh7lKkLeSGKOWkO
	pHnbJfXSb2Suo8KKQG3/ZE4QqBCLwn1uB7B+x6lAE5ZwmwtylTRUC6ZZtbZ1sCevdlkkLOA/CuvzD
	SLWxgkXw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJueB-0000000242l-1UMF;
	Tue, 27 May 2025 13:47:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B15F83002CE; Tue, 27 May 2025 15:47:14 +0200 (CEST)
Date: Tue, 27 May 2025 15:47:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "eadavis@qq.com" <eadavis@qq.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and
 is_td
Message-ID: <20250527134714.GC20019@noisy.programming.kicks-ass.net>
References: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
 <tencent_1A767567C83C1137829622362E4A72756F09@qq.com>
 <20250527110752.GB20019@noisy.programming.kicks-ass.net>
 <5a6187af0c4a73245ae527bc44135d4eb1a9b3c0.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a6187af0c4a73245ae527bc44135d4eb1a9b3c0.camel@intel.com>

On Tue, May 27, 2025 at 12:34:07PM +0000, Huang, Kai wrote:
> On Tue, 2025-05-27 at 13:07 +0200, Peter Zijlstra wrote:
> > On Tue, May 27, 2025 at 04:44:37PM +0800, Edward Adam Davis wrote:
> > > is_td() and is_td_vcpu() run in no instrumentation, so use __always_inline
> > > to replace inline.
> > > 
> > > [1]
> > > vmlinux.o: error: objtool: vmx_handle_nmi+0x47:
> > >         call to is_td_vcpu.isra.0() leaves .noinstr.text section
> > > 
> > > Fixes: 7172c753c26a ("KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct")
> > > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > > ---
> > > V1 -> V2: using __always_inline to replace noinstr
> > > 
> > >  arch/x86/kvm/vmx/common.h | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> > > index 8f46a06e2c44..a0c5e8781c33 100644
> > > --- a/arch/x86/kvm/vmx/common.h
> > > +++ b/arch/x86/kvm/vmx/common.h
> > > @@ -71,8 +71,8 @@ static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
> > >  
> > >  #else
> > >  
> > > -static inline bool is_td(struct kvm *kvm) { return false; }
> > > -static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
> > > +static __always_inline bool is_td(struct kvm *kvm) { return false; }
> > > +static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
> > >  
> > >  #endif
> > 
> > Right; this is the 'right' fix. Although the better fix would be for the
> > compiler to not be stupid :-)

FWIW, the thing that typically happens is that the compiler first
inserts instrumentation (think *SAN) into the trivial stub function and
then figures its too big to inline.

> Hi Peter,
> 
> Just out of curiosity, I have a related question.
> 
> I just learned there's a 'flatten' attribute ('__flatten' in linux kernel)
> supported by both gcc and clang.  IIUC it forces all function calls inside one
> function to be inlined if that function is annotated with this attribute.
> 
> However, it seems gcc and clang handles "recursive inlining" differently.  gcc
> seems supports recursive inlining with flatten, but clang seems not.
> 
> This is the gcc doc [1] says, which explicitly tells recursive inlining is
> supported IIUC:
> 
>   flatten
>   
>   Generally, inlining into a function is limited. For a function marked with 
>   this attribute, every call inside this function is inlined including the calls
>   such inlining introduces to the function (but not recursive calls to the 
>   function itself), if possible.
> 
> And this is the clang doc [2] says, which doesn't say about recursive inlining:
> 
>   flatten
> 
>   The flatten attribute causes calls within the attributed function to be 
>   inlined unless it is impossible to do so, for example if the body of the 
>   callee is unavailable or if the callee has the noinline attribute.
> 
> Also, one "AI Overview" provided by google also says below:
> 
>   Compiler Behavior:
>   While GCC supports recursive inlining with flatten, other compilers like  
>   Clang might only perform a single level of inlining.
> 
> Just wondering whether you can happen to confirm this?
> 
> That also being said, if the __flatten could always be "recursive inlining", it
> seems to me that __flatten would be a better annotation when we want some
> function to be noinstr.  But if it's behaviour is compiler dependent, it seems
> it's not a good idea to use it.
> 
> What's your opinion on this?

I am somewhat conflicted on this; using __flatten, while convenient,
would take away the immediate insight into what gets pulled in. Having
to explicitly mark functions with __always_inline is somewhat
inconvenient, but at least you don't pull in stuff by accident.

