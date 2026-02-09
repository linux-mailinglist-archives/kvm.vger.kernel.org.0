Return-Path: <kvm+bounces-70618-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EKj+G/0SimlrGAAAu9opvQ
	(envelope-from <kvm+bounces-70618-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:01:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 260E6112CFC
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:01:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F2418300BBA2
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46739385ECB;
	Mon,  9 Feb 2026 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4lAoT8TW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFB82D372D
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 17:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770656485; cv=none; b=JRg6vTkLPhzloj1bPNfVqnpmnj+dwuPc+sIa/JKRIN5W6rolaZCX4m/7RQCQb8HFGub4hOmh0kCAU8V8473IrUWmL2SVp0RovhxTP3nPQns1+VmlQXrp09IUdRr/58j92pCsFwK4N9l04OJO8IyT7+PJ/4iGUhLs/WUFy2aYT10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770656485; c=relaxed/simple;
	bh=ZgnQqes4djfrfi9IYR4uHMRZrCYkJ/8HL12/68MoSIw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E5txz7NEpKRILr59zyZrsgrtIPpPFcQvSV+OqzW+P91zmfzrt9NMcEtbHNAFxfmSE5ld62C9CID4mp43JyGxUN2tiiecE+aSA9MYsVoVn8pnBtyoHZ/ceg55ZUpO5RDDyLXbTmM9ciuthRmqcRE8ZXWl3r4DIxobYH1gcTvYCBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4lAoT8TW; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6dded42ec4so1578618a12.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 09:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770656485; x=1771261285; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YO6+F3jNsnF76vkonyTGMuR54wo2HffVdoLaCoDx93U=;
        b=4lAoT8TW4TkNrPVxRaCtU84vlrV3QRMd7QX7qxz3GIEiFgSlLzhIkAdeWk2hY9atgw
         IhLGI4a7POkF+NVnZ5vD8nr3BsM79GvkOf3TusmhnIL5YrpJKEBYExS1Z+O0VcYvLdP0
         3qs1/zUF3Ff1MZEIgfqi4UVpG/2dxUpK0FOTQSu3gWpm7xoXljYce5heWrjFTYazNeJZ
         kgp5l+Su5xw5aZhC2mkKYmbsZvUO8yo/2MCmtQBkT93I79DcgpJaEt5mFISgPjSBm/aL
         +mpi8dh5I0NcCRHZs1QstThaa8Xcr0MyHn3kH2CDfBTMbFoN7aTMjNnQjBAhh0yAtyvH
         TEIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770656485; x=1771261285;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YO6+F3jNsnF76vkonyTGMuR54wo2HffVdoLaCoDx93U=;
        b=PNxvM2+ivfJbef/j+A43saTGXfteiUBOxJ1RWK3aPDClinU0o587i+ZaBBqWYasgo5
         EYo55+QpVNFxmQMTWL/4mXi+WCNmMWZn9uwzdCbB3Vpe8meCTXdLJVf2oFxjIUQofkDK
         i+bIG8SvJtlMEv6HegBdVMufKSoUoyZ6KF3BFCqpbwQXaQsEYPNrZVsj21EcVV1soDJx
         kKia6voMWbZ2dJOr/cfsGiTIKw2cUo6vj+dEC/Ao26JBIezDWZzXsncWMWvMU1pV27F2
         kt3IYCtnX3l1mjUT20Pf1q2+cl5b9M2SG2wTi72nbmIvJK4OCgnqnn77c8YXRFA4CCVu
         IPRw==
X-Forwarded-Encrypted: i=1; AJvYcCU43Gty4aWETnMB/SeSxPvij3hf37a6advz834Seb+1x50qGou30hkQ4w9uAonNZfTh3Tc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjVsfaNrVWGlbnnXHX1ZxEE5Zij9dknSSsuLjv14hSGlMO7sSD
	CWrLSz3vWuThN5FmAs6NGXlUndiHXHiJxS5zi1AYwUeBA8kjYg18PX5abWGXdIJxu+GftZCQkmE
	j2dbC4A==
X-Received: from pjtl24.prod.google.com ([2002:a17:90a:c598:b0:354:c16d:17b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d86:b0:34c:c50e:9b80
 with SMTP id 98e67ed59e1d1-354b3e42c3emr9815813a91.27.1770656484526; Mon, 09
 Feb 2026 09:01:24 -0800 (PST)
Date: Mon, 9 Feb 2026 09:01:23 -0800
In-Reply-To: <aYG9ZyvpS6AZiRAl@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com> <aWgyhmTJphGQqO0Y@google.com>
 <ac46c07e421fa682ef9f404f2ec9f2f2ba893703.camel@intel.com>
 <aWpn8pZrPVyTcnYv@google.com> <6184812b4449947395417b07ae3bad2f191d178f.camel@intel.com>
 <aW3G6yZuvclYABzP@yzhao56-desk.sh.intel.com> <aXzPIO2qZwuwaeLi@google.com> <aYG9ZyvpS6AZiRAl@yzhao56-desk.sh.intel.com>
Message-ID: <aYoS45AZNY0rUJQD@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Fan Du <fan.du@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>, "kas@kernel.org" <kas@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Chao P Peng <chao.p.peng@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, "sagis@google.com" <sagis@google.com>, Chao Gao <chao.gao@intel.com>, 
	Jun Miao <jun.miao@intel.com>, "jgross@suse.com" <jgross@suse.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70618-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,vger.kernel.org,amd.com,suse.cz,google.com,kernel.org,gmail.com,redhat.com,suse.com,linux.intel.com];
	RCPT_COUNT_TWELVE(0.00)[29];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 260E6112CFC
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, Yan Zhao wrote:
> On Fri, Jan 30, 2026 at 07:32:48AM -0800, Sean Christopherson wrote:
> > On Mon, Jan 19, 2026, Yan Zhao wrote:
> > > On Sat, Jan 17, 2026 at 12:58:02AM +0800, Edgecombe, Rick P wrote:
> > > > On Fri, 2026-01-16 at 08:31 -0800, Sean Christopherson wrote:
> > > IIUC, this concern should be gone as Dave has agreed to use "pfn" as the
> > > SEAMCALL parameter [1]?
> > > Then should we invoke "KVM_MMU_WARN_ON(!tdx_is_convertible_pfn(pfn));" in KVM
> > > for every pfn of a huge mapping? Or should we keep the sanity check inside the
> > > SEAMCALL wrappers?
> > 
> > I don't have a strong preference.  But if it goes in KVM, definitely guard it with
> > KVM_MMU_WARN_ON().
> Thank you for your insights, Sean!
> 
> > > BTW, I have another question about the SEAMCALL wrapper implementation, as Kai
> > > also pointed out in [2]: since the SEAMCALL wrappers now serve as APIs available
> > > to callers besides KVM, should the SEAMCALL wrappers return TDX_OPERAND_INVALID
> > > or WARN_ON() (or WARN_ON_ONCE()) on sanity check failure?
> > 
> > Why not both?  But maybe TDX_SW_ERROR instead of TDX_OPERAND_INVALID?
> Hmm, I previously returned TDX_OPERAND_INVALID for non-aligned base PFN.
> TDX_SW_ERROR is also ok if we want to indicate that passing an invalid PFN is a
> software error.
> (I had tdh_mem_page_demote() return TDX_SW_ERROR when an incompatible TDX module
> is used, i.e., when !tdx_supports_demote_nointerrupt()).
> 
> > If an API has a defined contract and/or set of expectations, and those expectations
> > aren't met by the caller, then a WARN is justified.  But the failure still needs
> > to be communicated to the caller.
> Ok.
> 
> The reason for 'not both' is that there's already TDX_BUG_ON_2() in KVM after
> the SEAMCALL wrapper returns a non-BUSY error. I'm not sure if having double
> WARN_ON_ONCE() calls is good, so I intended to let the caller decide whether to
> warn.

Two WARNs isn't the end of the world.  It might even be helpful in some cases,
e.g. to more precisely document what went wrong.

> > > By returning TDX_OPERAND_INVALID, the caller can check the return code, adjust
> > > the input or trigger WARN_ON() by itself;
> > > By triggering WARN_ON() directly in the SEAMCALL wrapper, we need to document
> > > this requirement for the SEAMCALL wrappers and have the caller invoke the API
> > > correctly.
> > 
> > Document what exactly?  Most of this should be common sense.  E.g. we don't generally
> > document that pointers must be non-NULL, because that goes without saying 99.9%
> > of the time.
> Document the SEAMCALL wrapper's expectations. e.g., for demote, a PFN must be
> 2MB-aligned, or the caller must not invoke tdh_mem_page_demote() if a TDX module
> does not support feature ENHANCED_DEMOTE_INTERRUPTIBILITY...

FWIW, for me, all of those are self-explanatory and/or effectively covered by the
TDX specs.

> > IMO, that holds true here as well.  E.g. trying to map memory into a TDX guest
> > that isn't convertible is obviously a bug, I don't see any value in formally
> > documenting that requirement.
> Do we need a comment for documentation above the tdh_mem_page_demote() API?

I wouldn't bother, but I truly don't care if the TDX subsystem wants to document
everything in gory detail.

