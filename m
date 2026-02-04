Return-Path: <kvm+bounces-70259-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ALAQMKePg2lCpQMAu9opvQ
	(envelope-from <kvm+bounces-70259-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:27:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C79DEBA0F
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:27:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1107306296C
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 18:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B674426D25;
	Wed,  4 Feb 2026 18:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tOSzHDkc"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814BB347FC3
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 18:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770229501; cv=none; b=GAR6AEnOXC/5yksMLi22cAWqQNoW+wlke7yA/WxUCugz5nMiPDltjbyXpN3UMX9320fOJbB81di9sP2vShtiCVsvpbZ70RC/bGjkMx7EN+AANqfQ8ShcnMO0n0UZQhMLEJvSZS8zel2w0/vXgjiJWcqc/4JZlcFDYdF4sfEwNTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770229501; c=relaxed/simple;
	bh=8Ud3Rp7tTcMybgpiwmDz6gX52rDwLzjr0mYQ2R64+i0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QG3s+8aMBMUkg6LS87V6U+rR8ke9Ci6rY/AJRU8klqN8z/SR0W0EAgVlyquIrvWHWG/bpyAuP0xTLTYIeLMo6VbpN3liGEy5vwa8cqpfzdZffEaQLiRKFsUQHYOd8gJH3cZPkJEjWF5K6WBhi0PO2yRClDBVA+0ud8Zl6Ra8ST8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tOSzHDkc; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 4 Feb 2026 18:24:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770229499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ouGydqJ6H03jUz/faJIq6vifHMi1v9YOfzZ5Xl8D51I=;
	b=tOSzHDkc/lYbBk/4fhDTcJFfGZbsDFUJviM1g1vwkgScDyvVLuq6azZdjFkwqu1s0vlZc1
	g1P6swjbS+MZ0NwEDOPbr8O4ASnXiIvtGC1wom90MKyRdsnjj4wTFtpM3NWLa49ig+V51j
	c1g6F8SZgA9Fna7BCdlH8QwktlRukfI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: nSVM: Use intuitive local variables in
 recalc_intercepts()
Message-ID: <ujghelftsta6zcuyajew74yqtfkhqgdgnsomgyphkfb54itgmd@ouew3jl47nbg>
References: <20260112182022.771276-1-yosry.ahmed@linux.dev>
 <20260112182022.771276-2-yosry.ahmed@linux.dev>
 <aYOCAH8zLLXllou7@google.com>
 <gmdou4cp47vpx72tw3mwklwixpd3ujcdcomoplosv2u2tzfub2@wtqgzkhguoap>
 <aYOIGDlPs3bHLVo4@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYOIGDlPs3bHLVo4@google.com>
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
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70259-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:dkim]
X-Rspamd-Queue-Id: 6C79DEBA0F
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 09:55:36AM -0800, Sean Christopherson wrote:
> On Wed, Feb 04, 2026, Yosry Ahmed wrote:
> > On Wed, Feb 04, 2026 at 09:29:36AM -0800, Sean Christopherson wrote:
> > > 
> > > >  	for (i = 0; i < MAX_INTERCEPT; i++)
> > > > -		c->intercepts[i] = h->intercepts[i];
> > > > +		vmcb02->control.intercepts[i] = vmcb01->control.intercepts[i];
> > > >  
> > > > -	if (g->int_ctl & V_INTR_MASKING_MASK) {
> > > > +	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) {
> > > 
> > > I vote to keep a pointer to the cached control as vmcb12_ctrl.  Coming from a
> > > nVMX-focused background, I can never remember what svm->nested.ctl holds.  For
> > > me, this is waaaay more intuivite:
> > 
> > I agree it reads better, but honestly all of nSVM code uses svm->nested.ctl,
> > and changing its name here just makes things inconsistent imo.
> 
> Gotta start somewhere :-)  In all seriousness, if we didn't allow chipping away
> to at historical oddities in KVM, the code base would be a disaster.  I'm all for
> prioritizing consistency, but I draw the line at "everything else sucks, so this
> needs to suck too".
> 
> I'm not saying we need to do a wholesale rename, but giving at least
> nested_vmcb02_prepare_control() the same treatment will be a huge improvement.
> Actually, I'm going to go do that right now...

For what it's worth, at some point I was going to send a patch to put
svm->nested.ctl and svm->nested.save in an anonymous struct, to end up
with svm->nested.cached_vmcb12.ctl and svm->nested.cached_vmcb12.save,
but the names are too long :)


