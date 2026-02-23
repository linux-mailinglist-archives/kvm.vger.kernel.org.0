Return-Path: <kvm+bounces-71527-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKSrAfbFnGnJKAQAu9opvQ
	(envelope-from <kvm+bounces-71527-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:26:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E9E117D914
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:26:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 16DE7308385F
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 21:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA1C6378D7E;
	Mon, 23 Feb 2026 21:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R9lrV1Kp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0871B378839
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 21:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771881956; cv=none; b=Cwt8a427W3EgsZAnsuv184Cnhd1ZUf9dUT4+cbGO0VYp5yvQJkLFUMLBRZ9/8AC6/kg2Wfrwl+V3Ui35HVpfMdE8QGT13r4HiX+cCYDIMtxJe/sdEw0HXUcd7sSU613+EDJR35M+AZ/jrJu2QY6ZuFVGBwv7f7Nko5E9rxMcHY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771881956; c=relaxed/simple;
	bh=5qrxHX3bbBe6uAJtF0a/rnfGROb7vCb843CW5WKefvA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uRv9DyUIon4MMCSioTMQsBmUFQQUtzBTY92idQMTnhBAHxkgIWh+7vxdDP0UblZG2eoo4t2v8RcgR9fbDZSpg29KpnEksUTLyjc6sVcd+7M+mITVi/u3jEBQbBebepoBXjtXroOYh7XS7q75+5dVsj2WQkbClpl19lUVg5xonYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R9lrV1Kp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358e5e33ddcso6110a91.1
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 13:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771881954; x=1772486754; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vCvwJ+2gLIpJ0sJnMXjuHPVyD3E0eG9cwiLrsfl8ftM=;
        b=R9lrV1KpOje8PFAH0xuYF2jvc/szKqtyy9HOiA4b9VOx4R3mm7fswiaWfvScu9UjW0
         6QNJS5QlNINOwgeEwg4UWEI+AgRFeSq0bgVSMKSV9vyq2LH2ilIZFOkxtmyyGElF5Bez
         8NjqrQR/VeTAFH0duq7m26qe78pVMpLoJNCTiK2nVzCAQstJwDfvxcLt5HIbyrk9Hkcz
         Cg9IVXcYTVvGiIKQQfblK3b310ePF9BziD9ounZIuGLckkPFd4DRgCMYb0y+ZxNZRJzg
         JrInjB5E36hQ1Pd4veHeejd+75rGj7XBuNVePZvs4Hyc3mOtbWrM/80M8Y3hNpNjktL/
         6QNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771881954; x=1772486754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vCvwJ+2gLIpJ0sJnMXjuHPVyD3E0eG9cwiLrsfl8ftM=;
        b=WXWAEIEV5uyW39fzUhrCmIhbFYTDSFq9oXkZ047SmD16Y4StcmqiSP01xrNA1RWwse
         k4W4UgphzYKpI46140xiyOV2qhbcdm71x29vAi84bK1vy5+WJfiZUiHuOlmIgFind7Zd
         XDngWlVbpPbQcTc2NfisKA0m2X+Px56IBCZxGiuxpQvdsWJMn3U9gF1/15PnCsR0Swnf
         kEXpLHp1RcMnrvLsJdQwQi2Fk1C8DuN+NQEU0oxmgwwVHDoXuKv5A6k4SuLBL5irQMRC
         js2op7PLF0Flt3dLRXTjkeDOLfX4DOvtJgjMFnjVAG7AlFUHBSd/zth0xYkqbH+DXWP+
         2tkQ==
X-Gm-Message-State: AOJu0YzylXQGAX3Gk1rzuwMyblZWjwGG1BuEf2u4jdVj8dVHt0Z9JOFt
	Psf2hTzqd0guLRbXNzlDZMTPu09M5qD/G/wIRGvvvhoUs/DwXJKrilqpA4o6MtiMCgi5MHN4wOj
	f7jiSRg==
X-Received: from pjbkl12.prod.google.com ([2002:a17:90b:498c:b0:352:c413:d36b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e0f:b0:32e:3829:a71c
 with SMTP id 98e67ed59e1d1-358ae8b23damr9479940a91.16.1771881954244; Mon, 23
 Feb 2026 13:25:54 -0800 (PST)
Date: Mon, 23 Feb 2026 13:25:52 -0800
In-Reply-To: <9e899034687731c7ee6d431ae49dbe3f5ca13a6c.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260219002241.2908563-1-seanjc@google.com> <5a826ae2c3549303c205817520623fe3fc4699ec.camel@intel.com>
 <aZyGY41LybO8mVBT@google.com> <9e899034687731c7ee6d431ae49dbe3f5ca13a6c.camel@intel.com>
Message-ID: <aZzF4C1L9EdEBViW@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>
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
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71527-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5E9E117D914
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Kai Huang wrote:
> On Mon, 2026-02-23 at 08:54 -0800, Sean Christopherson wrote:
> > On Mon, Feb 23, 2026, Kai Huang wrote:
> > > But the odd is if the fault->addr is L2 GPA or L2 GVA, then the shared bit
> > > (which is concept of L1 guest) doesn't apply to it.
> > > 
> > > Btw, from hardware's point of view, does EPT/NPT silently drops high
> > > unmappable bits of GPA or it generates some kinda EPT violation/misconfig?
> > 
> > EPT violation.  The SDM says:
> > 
> >   With 4-level EPT, bits 51:48 of the guest-physical address must all be zero;
> >   otherwise, an EPT violation occurs (see Section 30.3.3).
> > 
> > I can't find anything in the APM (shocker, /s) that clarifies the exact NPT
> > behavior.  It barely even alludes to the use of hCR4.LA57 for controlling the
> > depth of the walk.  But I'm fairly certain NPT behaves identically.
> 
> Then in case of nested EPT (ditto for NPT), shouldn't L0 emulate an VMEXIT
> to L1 if fault->addr exceeds mappable bits?

Huh.  Yes, for sure.  I was expecting FNAME(walk_addr_generic) to handle that,
but AFAICT it doesn't.  Assuming I'm not missing something, that should be fixed
before landing this patch, otherwise I believe KVM would terminate the entire VM
if L2 accesses memory that L1 can't map.

