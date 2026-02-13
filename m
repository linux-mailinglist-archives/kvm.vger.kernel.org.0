Return-Path: <kvm+bounces-71061-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EDZNEvBGj2kiPAEAu9opvQ
	(envelope-from <kvm+bounces-71061-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:44:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BC1FE137A9A
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:44:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5C4A33050EFC
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271CC363C50;
	Fri, 13 Feb 2026 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B68wcH3g"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32193361DDE
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 15:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770997476; cv=none; b=hIRndwvkkWcD+4W04b7ssWeIwHAyfBsWeV8k3vdUu571KLadJV2ooYby/BmxnBFiEdivc3kzUScr9bnGCqYmTFKopPe4HkZajz7FRjPXhfATAHPfgXMRlSd9grvd/iu+s86LM3aA4GoxxbFkyDXFRz8rdJ4ilCVbneE9aVFHxpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770997476; c=relaxed/simple;
	bh=eY4LxESXuWP8EQOhAgJ2MSTYEJ900XIrkLpAFVXrlGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MoZMfn9fi4J9YK7RJcl4B+YjxQHd3mdjEXPJVJtwp35VxMZCRXAuYUbk3B1B+jb+skYaLShGd6DevwZUyLfxD9csNNSvuj1tg349bEy1VM6z7/l/15E5NypuLLIFgPRjYr2f/sFu0Pk58v7S7etcYvUuPZBm9cyBCV3rdAc2430=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B68wcH3g; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 13 Feb 2026 15:44:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770997473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZyI/Wi5A+R4Y6pAMWY7MZ5pvRCT2MV6/XkxedKYWQeQ=;
	b=B68wcH3gdIEiVyJvMO5IS5+jRSbzhawvMUWVcpeRN6SuE8n7BMQL80pABWS8yqXd/45o7R
	93cVGQCP8Q5VQ3xv+99r1xx5PZEl5Gkk7svWkmTEYrh3/FE7dJY+X4c9RnJJ3D6WoEIxiJ
	y8iUSUMZ5PRYKSQKgM1K4NoE4geyn8A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 4/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
Message-ID: <wpkqtluxmaxyjbgyn7qd6mi2ydqtujjpgytrk3ddctgevnu72k@ur4yg5aoo4s2>
References: <20260212155905.3448571-1-jmattson@google.com>
 <20260212155905.3448571-5-jmattson@google.com>
 <gqj4y6awen5dfxy32lbskcxw6xdv4xiiouycyftjacndjinhvp@7p4dtgdh6tjw>
 <aY9BPKhzgxo4UuHB@google.com>
 <lrvnjvj7ocndldzfjkwy5mv34nacnketug2ra67uqohlhwywec@ibwwlvc2twex>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lrvnjvj7ocndldzfjkwy5mv34nacnketug2ra67uqohlhwywec@ibwwlvc2twex>
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
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-71061-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BC1FE137A9A
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 03:43:12PM +0000, Yosry Ahmed wrote:
> On Fri, Feb 13, 2026 at 07:20:28AM -0800, Sean Christopherson wrote:
> > Please trim your replies.  Scrolling through 100+ lines of quoted text to find
> > the ~12 lines of context that actually matter is annoying.
> 
> Ack.
>  
> > Actually, calling svm_set_l2_pat() when !is_guest_mode() is wrong too, no?  E.g.
> > shouldn't we end up with this?
> 
> legacy_gpat_semantics should only be set in guest mode, and it's cleared
> in pre-run, so before we can exit guest mode IIUC.

Never mind that, Jim just mentioned the cases of back-to-back
KVM_SET_NESTED_STATE.


