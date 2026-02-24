Return-Path: <kvm+bounces-71573-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHj0OaYDnWk7MgQAu9opvQ
	(envelope-from <kvm+bounces-71573-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:49:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B7D5180BA3
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:49:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C1A2D302E768
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F876245012;
	Tue, 24 Feb 2026 01:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RuvunU56"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8F923D7DB
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 01:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771897763; cv=none; b=jMyIpfvSyPdZllSjh44Ao/okoNTyo4RRjYCm2M70TamiB8xhYnGePEqwNkqe+eVdK17q1h+T7KpEddcv8fXo8eqhCDn+Sww+uQW6lKc2bhTznzT5BOBG0mr+eT/qrEJMqyDGeY8u12EBqxxeablB1ypLlZHaJvppVxEAHFG5jaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771897763; c=relaxed/simple;
	bh=IM/dFotgxCBntq2RASsz3TTaWI3IzsV8R9xfptDQtlQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EzSsn5szPEDGrY2k6ADjRdwzJydD7ihHAbl75Keh8OrxQh0pjiOLK8lGuOFfB7j22thlK/HqrOU0ipCvns/1maQPIheA5oe8luuNs5/FUUXsnXYyUAlXWQBMIa9zrvMQTZj3SrVtoo2bvGmaG+ENPgCTlXc+V08mWrtPkW1oYvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RuvunU56; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c44bf176so5001079a91.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 17:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771897762; x=1772502562; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hCd5yhTyb7AdeCfY90uFmMReNGClYsEIW1vYQS0KNyw=;
        b=RuvunU56H8EcVDvgJq0DSEANAMTB+kTFtBKQ9rzW14qAMB0JmqhUFxQ2Uxe7xbLeH3
         nRfaZMLCJMYIAguRfCxflhGqXqbO6IBijdv6Fjeph27TQO5HfqcSEojn2SPtK7oVZlxk
         opU2HH5v6FpWO3NGc425ppCb9a1w9Nn4u49cOQJh4A661FowUUnmlf06x3E1gyzs4Tg3
         UxU9OaJpi+NODCWQmtJwjD+uLAOiFB8kFP1/cuZwY21EsvsVoCu1d9vjPkG8I1sli0zG
         7rFrbuNszAW7w0v+PlSlsyYdrRep6FYbC/bumxyaaZk6W7BkiiuL2wH8RNrbtoHMrDSG
         sxsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771897762; x=1772502562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hCd5yhTyb7AdeCfY90uFmMReNGClYsEIW1vYQS0KNyw=;
        b=KOE6L4YACN9niZljwyjIiEilY+471Qyr1dU8cmtGj5qvwdq3otgKml/nxo9nMQxisw
         mGBItdtuPA56kT2j/kFVYL022ZAXRhHvuQfVi3tCc3c1AkAvtgOkl+s+4ufjppUp8KVa
         bAQqEYZ3v5SgXbl92DQrxOztpiTU/0pxzbAWiUOlxFExzPYPRnEN2zkONPeCOkswJDvs
         gFbCPvZofjbl+qSw06AC/ER+uoDJr4dDTwhEKImGf28YUXQtFvtZOemW9GRsg95RISFz
         myrbWdyyGOIgd/lTNpHDvidJi/jedyYdOTi377XgDrWFNZaZMOfrVJ6JOjMTrYciWS/1
         jBsA==
X-Gm-Message-State: AOJu0YyiYb43oHQ8Oy6UXU/g9PPnNCdHDU9iqdyUgGDXR4Aboj2/r3JT
	C7Y/vOZ+SXa2D1BK59/8JyoEZIzPYq/Ce4x5ZyqXNVJnTNHIJ7XO8Z3P0iLQnZsqmvYSNId3Haj
	lFuY4BQ==
X-Received: from pjog6.prod.google.com ([2002:a17:90a:8f06:b0:352:d1c1:470])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c85:b0:352:c995:808a
 with SMTP id 98e67ed59e1d1-358ae7fe4a4mr10565462a91.14.1771897761656; Mon, 23
 Feb 2026 17:49:21 -0800 (PST)
Date: Mon, 23 Feb 2026 17:49:20 -0800
In-Reply-To: <f4dc2f2fd2c2201c9e5d141c0c83c203e1f57975.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260219002241.2908563-1-seanjc@google.com> <7986057373abcb20585c916804422a13f51d5e55.camel@intel.com>
 <aZkBBlrMd2-P-kKK@google.com> <f4dc2f2fd2c2201c9e5d141c0c83c203e1f57975.camel@intel.com>
Message-ID: <aZ0DoCheX51i3eXI@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71573-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8B7D5180BA3
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Rick P Edgecombe wrote:
> On Fri, 2026-02-20 at 16:49 -0800, Sean Christopherson wrote:
> > > But also the '5' case is weird because as a GVA the max addresse
> > > bits should be 57 and a GPA is should be 54.
> > 
> > 52, i.e. the architectural max MAXPHYADDR.
> 
> Oops yes I meant 52. But if it is always max physical address and not
> trying to handle VA's too, why is PT32E_ROOT_LEVEL 32 instead of
> 36?

Setting aside how any nNPT with a 32-bit kernel works for the moment, it would
be 52, not 36.  PT32E_ROOT_LEVEL is PAE, which per the SDM can address 52 bits
of physical address space:

  PAE paging translates 32-bit linear addresses to 52-bit physical addresses.

PSE-36, a.k.a. 2-level 32-bit paging with CR4.PSE=1, is the horror that can
address 36 bits of physical address space by abusing reserved bits in the "offset"
portion of a huge 4MiB page.

Somewhat of an aside, KVM always uses 64-bit paging or PAE paging for its MMU
(or EPT, but that's basically 64-bit), and so when running on 32-bit kernel, KVM
requires a PAE-enabled kernel to enable NPT, because hCR4 isn't changed on VMRUN,
i.e. the paging mode for KVM's MMU is tightly coupled to the host kernel's paging
mode.  Which is one of several reasons why nNPT is a mess.

  
  	/*
	 * KVM's MMU doesn't support using 2-level paging for itself, and thus
	 * NPT isn't supported if the host is using 2-level paging since host
	 * CR4 is unchanged on VMRUN.
	 */
	if (!IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_X86_PAE))
		npt_enabled = false;


As for how running a 32-bit PAE nNPT "works", I suspect it simply doesn't from an
architectural perspective.  32-bit KVM-on-KVM works (though I haven't check in a
few years...) because Linux doesn't allocate kernel memory out of high memory,
i.e. L1 KVM won't feed "bad" addresses to L0 KVM, and presumably QEMU doesn't
manage to either.

I might be forgetting something though?  If I get bored, or more likely when my
curiousity gets the best of me, I'll see how hardware behaves.

