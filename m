Return-Path: <kvm+bounces-70204-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sDksAxhag2mJlQMAu9opvQ
	(envelope-from <kvm+bounces-70204-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 15:39:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D524E7386
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 15:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1FA863009172
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 14:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C48E941B354;
	Wed,  4 Feb 2026 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cvchkcrm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA699296BDC
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 14:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770215942; cv=none; b=Z/oMZxDBt4f4vihrCUrYPcXx0cIkpMjmIdUvaxviubS5Xh8lzh4GqZcPn1Jr1Yx5hfJ4UuzV6KXbWBhkSgFPwnN52ZVyYwB68ZeXMaEUqZWtzflWWJ/xwVcL2NF92vSYn28uemVVhldspJGr20XX5pO5cfz1iwrzqNRo546hf0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770215942; c=relaxed/simple;
	bh=evs4o3kg+1XkxWgnNZ9BFDrK2Lk1BY8Wj9Pc3qa5Brw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qAf/du9aLxJHyar7eS8jCKUIQO5D1MCheJ/hX73cy7jP/Ycb6xmw/gXcSj0F7xwcsmrUpEP7HlkLEsAyBTHUSgBnBVASPRyx9HYklYxJakaQhCINmX5Kh5vuqGEpoi7RJWGlgSUhwl4guTUfX7MSB4KSFnjniVI2XL+I9fbSV4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cvchkcrm; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0d058fc56so50985975ad.3
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 06:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770215941; x=1770820741; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sc4qlJ2XppRbMaP7K1epexO5oOZyS10mutkmgFd7v4E=;
        b=cvchkcrmZ4n2eVphSZ8//H5FRv5Knrh7Lg3YqaNe7w9GDApQex8yBomd4jYcFffHDm
         LcjR6GY4HYGpHiWo1SnU5glqFoeDpxHOCG88OZZ08Zx7l5EOg5WFeufunkU5wAVvr+LC
         on2tFQ0YLDnLvYjiJj4lnGDMdd0HFWSg909NtHcxUxe4uNfMF5pDpJfe3g1N2vZFvTxV
         UuY+ERbdE2r7QbgwtcGvqDEpAp171NOLjRRhT1u1usOqCs9HD20l4ava44XYO018RJbZ
         2PaxhGHTZ4wOLYZA/tDPkPjTypKQKrpEf4eSZYy+TCKifWL/hheKIqInUJUfBkH0lud1
         KKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770215941; x=1770820741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sc4qlJ2XppRbMaP7K1epexO5oOZyS10mutkmgFd7v4E=;
        b=uzrRjh/33WKPNel0Gp6+gZAIyn+VJ6piIkYcteEJHYierHcv4TlIdnxYpxECPQY9Nm
         MUE08tv7VmjdRLlMAC56b4NID1HOagHkBLLzolu+EMAAjgq8a4ACGoFuZQNfluGF0WZb
         PdVKqitz8F5HWudSyLi+6xH96BqG5v5xXuT0y9JVPn6MjrksulKbffa3Uh/TwhWSUtoS
         pXvDLflinP+Irm519B6ZwJiMY8JefNnrTxgDYaauyCMOmOMRECpZpunggBskUwHWAhAW
         XKzZQxhQs0yqXWh89F6//C1w1Mk9/PBxlWaQZPyrA3mdvwAV5fDXmU4b+PDlvFoGF8Gc
         9wiw==
X-Forwarded-Encrypted: i=1; AJvYcCVoe18IBvJisfQ6vvIPOpWIiI8H0+JBhURE587MChqpGok9vJw6fAtCvJOvwoWV2VeFrVo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywje/hUbSoCmYyYeDaoIv5mP5/R6YresCQ+I6EXwyXDuWeprDIx
	cveUAKSBydfkQzNL5ZpeqQhrtbTMFP5uoDZEz9CQvxz3B8v4cm58SnR0Sy9gw41AjBxGCWuvGi8
	fmJHssA==
X-Received: from pjne5.prod.google.com ([2002:a17:90a:8185:b0:352:f654:c302])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3886:b0:352:de8c:7270
 with SMTP id 98e67ed59e1d1-354870d71c6mr2540076a91.9.1770215941201; Wed, 04
 Feb 2026 06:39:01 -0800 (PST)
Date: Wed, 4 Feb 2026 06:38:59 -0800
In-Reply-To: <aXuVR0kq_K1TYwlR@char.us.oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <aXuVR0kq_K1TYwlR@char.us.oracle.com>
Message-ID: <aYNaA7Td23xKHoHK@google.com>
Subject: Re: [RFC PATCH v5 00/45] TDX: Dynamic PAMT + S-EPT Hugepage
From: Sean Christopherson <seanjc@google.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Sagi Shahar <sagis@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70204-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5D524E7386
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Konrad Rzeszutek Wilk wrote:
> On Wed, Jan 28, 2026 at 05:14:32PM -0800, Sean Christopherson wrote:
> > This is a combined series of Dynamic PAMT (from Rick), and S-EPT hugepage
> > support (from Yan).  Except for some last minute tweaks to the DPAMT array
> > args stuff, a version of this based on a Google-internal kernel has been
> > moderately well tested (thanks Vishal!).  But overall it's still firmly RFC
> > as I have deliberately NOT addressed others feedback from v4 of DPAMT and v3
> 
> What does PAMT stand for? Is there a design document somewhere?
> 
> > of S-EPT hugepage (mostly lack of cycles), and there's at least one patch in
> > here that shouldn't be merged as-is (the quick-and-dirty switch from struct
> > page to raw pfns).
> > 
> > My immediate goal is to solidify the designs for DPAMT and S-EPT hugepage.
> > Given the substantial design changes I am proposing, posting an end-to-end
> > RFC seemed like a much better method than trying to communicate my thoughts
> > piecemeal.
> > 
> > As for landing these series, I think the fastest overall approach would be
> > to land patches 1-4 asap (tangentially related cleanups and fixes), agree
> 
> Should they be split out as non-RFC then?

Yeah, I'll do that soonish.  I posted the kitchen sink so that people could
review the entire thing without having to chase down 4+ series/patches.

> > on a design (hopefully), and then hand control back to Rick and Yan to polish
> > their respective series for merge.
> > 
> > I also want to land the VMXON series[*] before DPAMT, because there's a nasty
> > wart where KVM wires up a DPAMT-specific hook even if DPAMT is disabled,
> > because KVM's ordering needs to set the vendor hooks before tdx_sysinfo is
> > ready.  Decoupling VMXON from KVM solves that problem, because it lets the
> > TDX subsystem parse sysinfo before TDX is loaded.
> > 
> > Beyond that dependency, I am comfortable landing both DPAMT and S-EPT hugepage
> > support without any other prereqs, i.e. without an in-tree way to light up
> > the S-EPT hugepage code due to lack of hugepage support in guest_memfd.
> 
> Can there be test-cases? Or simple code posted for QEMU which is the
> tool that 99% of kernel engineers use?

No?  The core limitation is that KVM doesn't yet support hugepages for private
memory.  No amount userspace code can overcome that limitation.

We can and do have tests and VMM support, but it's all out-of-tree (for now).
All I'm saying here is that I'm ok landing the S-EPT hugepage code in advance of
guest_memfd hugepage support, e.g. so that we don't end up in a stalemate due to
cyclical dependecies, or one big megaseries.

