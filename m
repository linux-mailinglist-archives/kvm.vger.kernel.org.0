Return-Path: <kvm+bounces-72934-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iL0BCZLVqWnbFwEAu9opvQ
	(envelope-from <kvm+bounces-72934-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:12:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C0F3A2174AA
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:12:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6630E3181DD1
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 19:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1523D299922;
	Thu,  5 Mar 2026 19:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DOx2at7u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43675262FD0
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 19:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772737708; cv=none; b=B3nWzP+H51JyDN/SMwyvBLkOMqA4uieuC2rTCLrCq59QA4OWmLQz1lZ0BYdDfwUpDgm/gXbxni1lVppNyoj8PRWVq3jBtRNIdiri6kS86mvUpSW9OgTZqT//wYpfnQnU+uDGfgJ3Gz50BvFGNc+X207leX/pWdQyHhk9N3FHr+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772737708; c=relaxed/simple;
	bh=bGuaeNqr6VWaAmbiXSPDtO63UndDQutthS6wDXTX9W4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bgfLLMgcW7MwssnJ2i4U2ppvccXIUyiuxPmDl51lRnv/5xOtVU5Tfx4jmIzxi3yZDoEtoX/E8OJn9EaljxXRJQzifUOT61FhZv/SS59vEt7BIbPVnvc5xNubMiEDP2bYSIBSqrddFT6nVO31j/mzBEffvAZVR8Y34sKHzyJUy8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DOx2at7u; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3598733bec0so25095652a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 11:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772737707; x=1773342507; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rd+7isUxcEtu9dXZzRy3nxo9ohGQnZS7iF8S+D9SDgk=;
        b=DOx2at7u/Kkz0XXpZrEGqaipCZC9ooahe8trHC8eyXSBytgRkGR2CQbXGETad8Im6f
         r4LilrBiRtkuJxGs0hWT89K/6jNsfHojxHb697UYuJbwyQizg3UblABFb4pThzeGrQ+/
         LLsHbfdkysIaG8WU165xPZA35jIggSmJnRkvlkWT1do1OKMS3BN8S4C77mOgCU6Co215
         z2Gdc6eb1j7i+7jINoT6BTzQ3CclVGwamXmkmV7XLz1+635rsqmmJJ+tEp/SXp4stkgk
         rKhDSPs22m+3KOkZIWmTLn/dKpZvx6qTW6WIK3scIhWRnQhGlx7/CurKUat6WRVJPoAp
         h9yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772737707; x=1773342507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rd+7isUxcEtu9dXZzRy3nxo9ohGQnZS7iF8S+D9SDgk=;
        b=YydQfffzTZpXPQhgb3TrT9JGfuuZRrgJVnarT/Ta5Bkj9jTFCEZNRUgwxM/vq3vDkO
         dTVBwln1T32yzGybB7QRM+eZpRgqk6pt14bC+qsrDFJ0B3me2Xkaw+5HSFkORSvhEZoB
         mWfwvC0KS1Hm0eiDDlhdqb4Zdiu55UcDBkLxo9WBgM60l6WzKEJjbz2ZLaEm1kH90NDl
         MFx6p/Xbm/T3tF70xKJvAbLLzDLrIcFJ/BDu8rPyBxOnHBJvMeiwwP9xZtxdwfKVa0S1
         AafbIuL3eRfzd91z/yKurLgxV55mYjMp6Ucmy/HjHGBhoN4zv31Q8SojT51jmYIFAvth
         3x2A==
X-Forwarded-Encrypted: i=1; AJvYcCWCeem6AZj8lIf4LohIv+VrS5YDzQ3x5H6gEOWnXQz4yUKp9u1Dy2YIqL11VGcVz3NzueI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcPXZ2aZOFxQNvb1KHcSM4F98+PgPMkamfBtsFLqn6+yjpTLOa
	vYU+aGpR5Tq5W4rO3TZ3TP6aziJMJOXYkRkBV1+Hp1b9g1rrwDx6nv6m10uob0GByaKh6Zup3yX
	7hRkdXQ==
X-Received: from pjwo15.prod.google.com ([2002:a17:90a:d24f:b0:359:946d:cd28])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7cd:b0:354:c629:efaf
 with SMTP id 98e67ed59e1d1-359a6a83ecemr5537189a91.35.1772737706499; Thu, 05
 Mar 2026 11:08:26 -0800 (PST)
Date: Thu, 5 Mar 2026 11:08:24 -0800
In-Reply-To: <69a9d0645bc31_6423c1006@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com> <177272960351.1566277.2741684808536756847.b4-ty@google.com>
 <69a9d0645bc31_6423c1006@dwillia2-mobl4.notmuch>
Message-ID: <aanUqJWYMSXSwGRR@google.com>
Subject: Re: [PATCH v3 00/16] KVM: x86/tdx: Have TDX handle VMXON during bringup
From: Sean Christopherson <seanjc@google.com>
To: dan.j.williams@intel.com
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: C0F3A2174AA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72934-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026, dan.j.williams@intel.com wrote:
> Sean Christopherson wrote:
> > On Fri, 13 Feb 2026 17:26:46 -0800, Sean Christopherson wrote:
> > > Assuming I didn't break anything between v2 and v3, I think this is ready to
> > > rip.  Given the scope of the KVM changes, and that they extend outside of x86,
> > > my preference is to take this through the KVM tree.  But a stable topic branch
> > > in tip would work too, though I think we'd want it sooner than later so that
> > > it can be used as a base.
> > > 
> > > Chao, I deliberately omitted your Tested-by, as I shuffled things around enough
> > > while splitting up the main patch that I'm not 100% positive I didn't regress
> > > anything relative to v2.
> > > 
> > > [...]
> > 
> > Applied to kvm-x86 vmxon, with the minor fixups.  I'll make sure not to touch
> > the hashes at this point, but holler if anyone wants an "official" stable tag.
> 
> Thanks, Sean!
> 
> Please do make an official stable tag that I can use for coordinating
> the initial TDX Connect enabling series. While there is no strict
> dependency I do not want it to be the case that a bisect of TDX Connect
> bounces between a world where you need to load kvm_intel before the PCI
> layer can do link encryption operations and keep it loaded etc.

With a timestamp, in case fixups on top are needed:

kvm-x86-vmxon-2026.03.05

