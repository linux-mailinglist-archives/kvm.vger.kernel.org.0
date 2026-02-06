Return-Path: <kvm+bounces-70507-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MFLAHJA/hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70507-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:22:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DECCF102AA6
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B3C21303EFFD
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57424309EEB;
	Fri,  6 Feb 2026 19:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="orhQ8iNo"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312232FF161
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770405378; cv=none; b=W1Qt5Yl6c9x/xwbmixL2C3retUf5d1uQ7/bGmbMA0KmKx7+FJo0QHbytofz/Mi46RaVMgXvqffFsj9fti7+EUSAli4wjtQ+019/BaUXxOhnxMd613P31iiATV+E/+Y4BWnmwwSSqrz9ErIS26lmF9uM6Wh5C6PH1UWNKRThfBEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770405378; c=relaxed/simple;
	bh=g7Q/4E8zt70aXOf5dy8iJ0NfOc1yidlmFr1vWeRybCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYgVSv4hnQl4SGYvbyHdNpomBgE7lecYuANxZWXlQGQfepNfNUaKu4j81BRTKmc9Ms+z473i4C4DR10PTyiOFci+ntNMgic2KrEEoFRZwP6G9kNTttKKxtm8RlC/avIOfyoIr5uB2b6D38HYM49ktr12iiNQJAJw8sO/TAuttS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=orhQ8iNo; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 6 Feb 2026 19:15:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770405366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PcGLtUtaphN2Nr0u4MsBtoYPb3+8xuPZLI8DiFWh5So=;
	b=orhQ8iNogj8ooih4p/QtD8YEW7S+V9u7u4s1lRd3SaViDmAU/40lUAqeqJOsmFlyrCxIa3
	wNUfDTi1Dgs9O1Sn9Ux7eKYZ55lyA2B522MC6wEoRBKlUlyWu0huYWDEj/FaLMF7NdNOE6
	08zKQcxPJBankPThMKJ3MwQHe3k9BJc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
Message-ID: <u566x5dz5a7trddlb3s6kustfvewdredrfldbu7yxlnl54wicp@tvzanbhtbmbd>
References: <20260205214326.1029278-1-jmattson@google.com>
 <20260205214326.1029278-3-jmattson@google.com>
 <aYYwwWjMDJQh6uDd@google.com>
 <fb750b1bb21bd47f85eb133d69b2c059188f4c05@linux.dev>
 <CALMp9eTJAD4Dc88egovSjV-N2YHd8G80ZP-dL5wXFDAC+WR6fA@mail.gmail.com>
 <aYY9JOMDBPDY48lA@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYY9JOMDBPDY48lA@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70507-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:email,linux.dev:dkim]
X-Rspamd-Queue-Id: DECCF102AA6
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 11:12:36AM -0800, Sean Christopherson wrote:
> On Fri, Feb 06, 2026, Jim Mattson wrote:
> > On Fri, Feb 6, 2026 at 10:23 AM Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> > >
> > > February 6, 2026 at 10:19 AM, "Sean Christopherson" <seanjc@google.com> wrote:
> > >
> > >
> > > >
> > > > On Thu, Feb 05, 2026, Jim Mattson wrote:
> > > >
> > > > >
> > > > > Cache g_pat from vmcb12 in svm->nested.gpat to avoid TOCTTOU issues, and
> > > > >  add a validity check so that when nested paging is enabled for vmcb12, an
> > > > >  invalid g_pat causes an immediate VMEXIT with exit code VMEXIT_INVALID, as
> > > > >  specified in the APM, volume 2: "Nested Paging and VMRUN/VMEXIT."
> > > > >
> > > > >  Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
> > > > >  Signed-off-by: Jim Mattson <jmattson@google.com>
> > > > >  ---
> > > > >  arch/x86/kvm/svm/nested.c | 4 +++-
> > > > >  arch/x86/kvm/svm/svm.h | 3 +++
> > > > >  2 files changed, 6 insertions(+), 1 deletion(-)
> > > > >
> > > > >  diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > >  index f72dbd10dcad..1d4ff6408b34 100644
> > > > >  --- a/arch/x86/kvm/svm/nested.c
> > > > >  +++ b/arch/x86/kvm/svm/nested.c
> > > > >  @@ -1027,9 +1027,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> > > > >
> > > > >  nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
> > > > >  nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> > > > >  + svm->nested.gpat = vmcb12->save.g_pat;
> > > > >
> > > > >  if (!nested_vmcb_check_save(vcpu) ||
> > > > >  - !nested_vmcb_check_controls(vcpu)) {
> > > > >  + !nested_vmcb_check_controls(vcpu) ||
> > > > >  + (nested_npt_enabled(svm) && !kvm_pat_valid(svm->nested.gpat))) {
> > > > >  vmcb12->control.exit_code = SVM_EXIT_ERR;
> > > > >  vmcb12->control.exit_info_1 = 0;
> > > > >  vmcb12->control.exit_info_2 = 0;
> > > > >  diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > > >  index 986d90f2d4ca..42a4bf83b3aa 100644
> > > > >  --- a/arch/x86/kvm/svm/svm.h
> > > > >  +++ b/arch/x86/kvm/svm/svm.h
> > > > >  @@ -208,6 +208,9 @@ struct svm_nested_state {
> > > > >  */
> > > > >  struct vmcb_save_area_cached save;
> > > > >
> > > > >  + /* Cached guest PAT from vmcb12.save.g_pat */
> > > > >  + u64 gpat;
> > > > >
> > > > Shouldn't this go in vmcb_save_area_cached?
> > >
> > > I believe Jim changed it after this discussion on v2: https://lore.kernel.org/kvm/20260115232154.3021475-4-jmattson@google.com/.
> 
> LOL, oh the irony:
> 
>   I'm going to cache it on its own to avoid confusion.
> 
> > Right. The two issues with putting it in vmcb_save_area_cached were:
> > 
> > 1. Checking all of vmcb_save_area_cached requires access to the
> > corresponding control area (or at least the boolean, "NTP enabled.")
> 
> Checking the control area seems like the right answer (I went down that path
> before reading this).
> 
> > 2. In the nested state serialization payload, everything else in the
> > vmcb_save_area_cached comes from L1 (host state to be restored at
> > emulated #VMEXIT.)
> 
> Hmm, right, but *because* it's ignored, that gives us carte blanche to clobber it.
> More below.
> 
> > The first issue was a little messy, but not that distasteful.
> 
> I actually find it the opposite of distasteful.  KVM definitely _should_ be
> checking the controls, not the vCPU state.  If it weren't for needing to get at
> MAXPHYADDR in CPUID, I'd push to drop @vcpu entirely.
> 
> > The second issue was really a mess.
> 
> I'd rather have the mess contained and document though.  Caching g_pat outside
> of vmcb_save_area_cached bleeds the mess into all of the relevant nSVM code, and
> doesn't leave any breadcrumbs in the code/comments to explain that it "needs" to
> be kept separate.
> 
> AFAICT, the only "problem" is that g_pat in the serialization payload will be
> garbage when restoring state from an older KVM.  But that's totally fine, precisely
> because L1's PAT isn't restored from vmcb01 on nested #VMEXIT, it's always resident
> in vcpu->arch.pat.  So can't we just do this to avoid a spurious -EINVAL?
> 
> 	/*
> 	 * Validate host state saved from before VMRUN (see
> 	 * nested_svm_check_permissions).
> 	 */
> 	__nested_copy_vmcb_save_to_cache(&save_cached, save);
> 
> 	/*
> 	 * Stuff gPAT in L1's save state, as older KVM may not have saved L1's
> 	 * gPAT.  L1's PAT, i.e. hPAT for the vCPU, is *always* tracked in
> 	 * vcpu->arch.pat, i.e. gPAT is a reflection of vcpu->arch.pat, not the
> 	 * other way around.
> 	 */
> 	save_cached.g_pat = vcpu->arch.pat;
> 
> 	if (!(save->cr0 & X86_CR0_PG) ||
> 	    !(save->cr0 & X86_CR0_PE) ||
> 	    (save->rflags & X86_EFLAGS_VM) ||
> 	    !nested_vmcb_check_save(vcpu, &ctl_cached, &save_cached))
> 		goto out_free;
> 
> Oh, and if we do plumb in @ctrl to __nested_vmcb_check_save(), I vote to
> opportunistically drop the useless single-use wrappers (probably in a standalone
> patch to plumb in @ctrl).  E.g. (completely untested)

They are dropped by
https://lore.kernel.org/kvm/20260206190851.860662-9-yosry.ahmed@linux.dev/.

