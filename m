Return-Path: <kvm+bounces-70820-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8PJ8In3Vi2kObwAAu9opvQ
	(envelope-from <kvm+bounces-70820-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 02:03:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 21DDD12069C
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 02:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86CA83054D36
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8B126F289;
	Wed, 11 Feb 2026 01:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w0EU0qJh"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D1723E33D
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 01:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770771786; cv=none; b=Jd5Q7s9fy4r3Wqdw0NOk8Ql1zVGtiqbIaPzLueCltlG2G5kBeF72qKpq7Wr+Dn89WCJT8dDFLvVN4dKnRC42Sg9rGhPgSTlRTeiSwVYBv6fSIQU8YMaj8lLoS+nl+f71ot/+XujVi93w3ZfypnBnVlkM8JjBFMJBqpXJ+Q+gB4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770771786; c=relaxed/simple;
	bh=KcwxNoDNSDyS0+eLUK+Bw0c+k8fKFlTk1zUgDfbN0WQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=STgJNF/Pmr0jEurFYF0Rx0KQY0d6wx8IbXC4/PIzl08s27+1ILKRR0kUUEsZIgpvQr7RLP+LrL3GAkQPijhTRDndt0KaM1Tv8n4xtYzmmHWnwodOORyEdbPLiTsoI0MuQBrrxmlIv0WxloJNMH9Hhzz11l89njRGLXTvS6dnJ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w0EU0qJh; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 11 Feb 2026 01:02:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770771772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qJ3zJW8FDpQrdYbm4L488yxyJvVIS8X9c+crsb06WJY=;
	b=w0EU0qJhncNjbRTBs9AAgKkS1TaCZ4XTYAXEhE3VllhmgYkb7vO37RlNszJ6RnV6wktzxk
	8nCP2Cut5qFSAeJkXLMT1z4sfAPHacy7vH+l6Jqa1FkBBItZs7g6AP07COkYPWnfNrKUXA
	/P2B9iBh9iz8PCHM3XCNXfyYbzBeT/A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: nSVM: Sync next_rip to cached vmcb12 after
 VMRUN of L2
Message-ID: <smsla7jgdncodh57uh7dihumnteu5sgxyzby2jc6lcp3moayzf@ixqj4ivmlgb2>
References: <20260210005449.3125133-1-yosry.ahmed@linux.dev>
 <20260210005449.3125133-2-yosry.ahmed@linux.dev>
 <aYqOkvHs3L-AX-CG@google.com>
 <4g25s35ty23lx2je4aknn6dg4ohviqhkbvvel4wkc4chhgp6af@kbqz3lnezo3j>
 <aYuE8xQdE5pQrmUs@google.com>
 <ck57mmdt5phh64cadoqxylw5q2b72ffmabmlzmpphaf27lbtxw@4kscovf6ahve>
 <aYvIpwjsJ50Ns4ho@google.com>
 <mxn6y6og34ejncnsvdapcoep4ewcnwnheszhwkp2undkqcu5zv@bpmseexuug5z>
 <aYvPwH8JcRItaQRI@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYvPwH8JcRItaQRI@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70820-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 21DDD12069C
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 04:39:28PM -0800, Sean Christopherson wrote:
> On Wed, Feb 11, 2026, Yosry Ahmed wrote:
> > > > We can drop it and make it a local vaiable in nested_svm_vmrun(), and
> > > > plumb it all the way down. But it could be too big for the stack.
> > > 
> > > It's 48 bytes, there's no way that's too big.
> > 
> > That's before my hardening series shoved everything in there. It's now
> > 256 bytes, which is not huge, but makes me nervous. Especially that it
> > may grow more in the future.
> > 
> > > > Allocating it every time isn't nice either.
> > > 
> > > > Do you mean to also make it opaque?
> > > 
> > > I'd prefer to drop it.
> > 
> > Me too, but I am nervous about putting it on the stack.
> 
> 256 bytes should be tolerable.  500+ is where things tend to get dicey.

In that case I think removing it completely should be fine.

> 
> > > > > +       u8 __vmcb12_ctrl[sizeof(struct vmcb_ctrl_area_cached)];
> > > > 
> > > > We have a lot of accesses to svm->nested.ctl, so we'll need a lot of
> > > > clutter to cast the field in all of these places.
> > > > 
> > > > Maybe we add a read-only accessor that returns a pointer to a constant
> > > > struct?
> > > 
> > > That's what I said :-D
> > > 
> > > 	* All reads are routed through accessors to make it all but impossible
> > > 	* for KVM to clobber its snapshot of vmcb12.
> > > 
> > > There might be a lot of helpers, but I bet it's less than nVMX has for vmcs12.
> > 
> > Oh I meant instead of having a lot of helpers, have a single helper that
> > returns it as a pointer to const struct vmcb_ctrl_area_cached? Then all
> > current users just switch to the helper instead of directly using
> > svm->nested.ctl.
> > 
> > We can even name it sth more intuitive like svm_cached_vmcb12_control().
> 
> That makes it to easy to do something like:
> 
> 
> 	u32 *int_ctl = svm_cached_vmcb12_control(xxx).
> 
> 	*int_ctl |= xxx;
> 
> Which is what I want to defend against.

Do compilers allow implicit dropping of const qualifiers?

Building with this diff fails for me:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd..0a73dd8f9163 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1343,10 +1343,17 @@ static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
        nested_svm_simple_vmexit(to_svm(vcpu), SVM_EXIT_SHUTDOWN);
 }

+static const struct vmcb_ctrl_area_cached *svm_cached_vmcb12_control(struct vcpu_svm *svm) {
+       return &svm->nested.ctl;
+}
+
 int svm_allocate_nested(struct vcpu_svm *svm)
 {
+       struct vmcb_ctrl_area_cached *ctl = svm_cached_vmcb12_control(svm);
        struct page *vmcb02_page;

+       pr_info("%p\n", ctl);
+
        if (svm->nested.initialized)
                return 0;


I see:

arch/x86/kvm/svm/nested.c:1352:32: error: initializing 'struct vmcb_ctrl_area_cached *' with an expression of type 'const struct vmcb_ctrl_area_cached *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
 1352 |         struct vmcb_ctrl_area_cached *ctl = svm_cached_vmcb12_control(svm);
      |                                       ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.

I don't explicitly see 'incompatible-pointer-types-discards-qualifiers'
anywhere, but I do see 'incompatible-pointer-types' in
scripts/Makefile.warn:

KBUILD_CFLAGS += $(call cc-option,-Werror=incompatible-pointer-types)

Is this sufficient?

> 
> > > > I think this will be annoying when new fields are added, like
> > > > insn_bytes. Perhaps at some point we move to just serializing the entire
> > > > combined vmcb02/vmcb12 control area and add a flag for that.
> > > 
> > > If we do it now, can we avoid the flag?
> > 
> > I don't think so. Fields like insn_bytes are not currently serialized at
> > all. The moment we need them, we'll probably need to add a flag, at
> > which point serializing everything under the flag would probably be the
> > sane thing to do.
> > 
> > That being said, I don't really know how a KVM that uses insn_bytes
> > should handle restoring from an older KVM that doesn't serialize it :/
> > 
> > Problem for the future, I guess :)
> 
> Oh, good point.  In that case, I think it makes sense to add the flag asap, so
> that _if_ it turns out that KVM needs to consume a field that isn't currently
> saved/restored, we'll at least have a better story for KVM's that save/restore
> everything.

Not sure I follow. Do you mean start serializing everything and setting
the flag ASAP (which IIUC would be after the rework we discussed), or
what do you mean by "add the flag"?

