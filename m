Return-Path: <kvm+bounces-71435-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WF0oNk/3mGlyOgMAu9opvQ
	(envelope-from <kvm+bounces-71435-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:07:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A9916B7FE
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:07:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4459C300E166
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 00:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A7163B9;
	Sat, 21 Feb 2026 00:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tav/cQDA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44109A55
	for <kvm@vger.kernel.org>; Sat, 21 Feb 2026 00:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771632457; cv=none; b=oYjqI+6op4cgQQF9JJV/Svvzi0gXmlXGdNOimuV4xtqE9lOu3FkwcayXXswfGP5iwlQsfQRptv4VbJdSovvk2hkckXsViQiXfm1Djbe4SoKQRqMYxL8IGOt9LKALIyUjesxt3sCk5e1Nn4sRjDMEikvk5x9+NgH3JEA+Q3MQY/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771632457; c=relaxed/simple;
	bh=x9fruw5mw4/z7zPmhPy0VfmkN7OYHIHgvYEFztICfPE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MXyybUApfwUHxhlVPfCPXgz/Oh30jsoLDrKLeffvDzb9cO+pJO5kYagW2lLYNNfKqpTrVybi9Aq/MBk8SGsRYxjX93w5JoLQsJVRgJIt7lkADgGdbDmqVxzHp9WkOf6G/sFWPaO9A0qWmUZ6IxOrLSaSPe3dj8qj8iY48pR31cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tav/cQDA; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a7b7f04a11so172842435ad.3
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 16:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771632456; x=1772237256; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=axJOs1drKDzZYs1ENBmQ4eIAMLxj6lPtQgyCBtlbw3s=;
        b=tav/cQDAhZRPsVkf0mkqpOkRj6WtLehMUywxhryfG2NdniLh3joRn0iVMRWbNe9EMb
         0keN23c+FbJxa8Yt54AngLIQkT1SFEPYPGzGNHEa7R9QGm81Q2VBavzkPgsdRZY/JFOx
         Fq/09Girin37tiqFJY6/YTO9YfP7FDc/YYc2/qlh/e9e6ujcWmr6yjYuzGzToBtbB3qs
         F/b8jBmzybPmPu9x9Diy7qTKfKPNZc4gAIKqAzbD7iIXMKnlLqEPDrwQdEghnV/3ysqv
         Tk8F8/i++7CZV0g5P6sBk6Vws3N4oE8BG5uwNNxQN4AHCAz5tKN8AFc97o2HtiJWPvkG
         gYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771632456; x=1772237256;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=axJOs1drKDzZYs1ENBmQ4eIAMLxj6lPtQgyCBtlbw3s=;
        b=lcH59aYumwhlDWXEC60X+24NJPjzyLL2qZQavsmVDJLnZXPkSaX40ms/O/cg+aUpe0
         K+FK5akIzL2YqZtPWPhdl5KLlZWvtDEp/8x35cYvN5fLVP5Fm3JWmMiW4TAHTci4ndoX
         yn+fmjBFUcJEUwepRptYpRPZXFQZ/W9pCGO5rpeXCDRtzZ4R/Ebgj4BAVuzydOFtlXmQ
         li2domtd8dQmO8p2IHpaL48JfmJvqVBhsXlADp3vjAq+8ub7Az7d6m87uFRzVD8hLIEj
         VIn4uooQ1ICn24uIoc9OUITFVCJhvrv4RUXks6/1H9H0ukSlsX8kRxXzijWw7JIhm3dR
         BVJQ==
X-Gm-Message-State: AOJu0YzXt7ZqpFW2xhF0nJZIpXMB3WzxMPARn43nDx93BDgsvV4Sxty2
	v12p7l4rrx8h4NvIdvnFiw+SDFuE4mYttQes4SXJwi1A9vN9V6/9HeqFvEIt+uf/dKSQ8JPUL0M
	Vp4sO+Q==
X-Received: from plbba11.prod.google.com ([2002:a17:902:720b:b0:2aa:e480:c392])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e752:b0:2aa:ec1b:d3c3
 with SMTP id d9443c01a7336-2ad7453735bmr12958125ad.43.1771632455592; Fri, 20
 Feb 2026 16:07:35 -0800 (PST)
Date: Fri, 20 Feb 2026 16:07:34 -0800
In-Reply-To: <dbf47f0eb749e88d2f2e73d2caba0a679ad8bc81.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260219002241.2908563-1-seanjc@google.com> <c06466c636da3fc1dc14dc09260981a2554c7cc2.camel@intel.com>
 <aZiR1cQxbDpRkQNn@google.com> <dbf47f0eb749e88d2f2e73d2caba0a679ad8bc81.camel@intel.com>
Message-ID: <aZj3RiPYGqgE74kE@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71435-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 10A9916B7FE
X-Rspamd-Action: no action

On Sat, Feb 21, 2026, Rick P Edgecombe wrote:
> On Fri, 2026-02-20 at 16:54 +0000, Sean Christopherson wrote:
> > > =C2=A0 Which meshes with a logical analysis as well: KVM only needs t=
o flush when
> > > > removing/changing an entry, and so should always derive the to-be-f=
lushed
> > > > ranges using the gfn that was used to make the change.
> > >=20
> > > And the "bad" gfn can never have TLB entries, because KVM never creat=
es >
> > > mappings.
>=20
> Oh. I was under the impression that the fault gets its GPA bits stripped =
and
> ends up mapping the page table mapping at a wrong different GPA.=20

It does (by KVM, not by hardware).  The above is juyst trying to clarify th=
at we
don't have to worry about the GFN from the fault, either.

> So if some optimized GFN targeting flush was pointed at the unstripped GP=
A
> then it could miss the GPA that actually got mapped and made it into the =
TLB.
> Anyway, it seems moot.

Yeah, we're on the same page. =20

