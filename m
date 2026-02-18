Return-Path: <kvm+bounces-71273-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WIzwAswplmnUbgIAu9opvQ
	(envelope-from <kvm+bounces-71273-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:06:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 75034159C6B
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:06:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D58ED303277C
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDD93491C4;
	Wed, 18 Feb 2026 21:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i+hwrXFy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A873385AA
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 21:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771448770; cv=none; b=M2wzcHQB9PCeVFBK62N79Jn7zN/9rMFanwv3lfk0BiuCkPFxRkrQlxGA+ODO593cKsV5nB7wYjx1KzWT6RUyoXLuwm+q1FC5cIzo5iSDX4R28t47s/4wF5Cnal+jF72S4tOn8RQ4Ui4ApF6Yl8bNcGS4eFsR0gnPnlEZcsT2GYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771448770; c=relaxed/simple;
	bh=hZ+rjhElxgLGmkoWnG0q2kPevdexQ7E+7PhYwWYUAmQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gBhoPVsH5++tILsYaIZjyQ3O6vz1LismdCiMqdKKX1eewY7hLSng4AKlx7Run7FjGqs7miwNNEtWzRDClxkAZKAIFZ6mS5NTFIfq48APo91Bu6OJoFWlrlX4scpJCEm590ukMQ9wivR3TlRCEGP5F2jJriEoyVBiz+fo7DimWkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i+hwrXFy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3562692068aso1089099a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 13:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771448769; x=1772053569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ccWJDzJ7m4S4l+nz4VuzRpZZrXnjyW9kyBaNIifc8MY=;
        b=i+hwrXFy7K9Dma6gqq3vKwNIP1genuzLTn9lSNY3FuhlGgOslftjvFVXSdl8OUQDdw
         OWZgpnnT/6sxexGtpgrzZK+8lITGHj/KDdWj881OD3mDKKFIu2ZWxOWScvhLQQywW4n8
         xcN6w575Srh5+Mev2XzQIc8uLhZPJxkplqO6wEI2VQqKo55VFiJHQe8buyl7b4qqUYsz
         cViDaB/qFiyT+sRlf54u/SsTlP/mhPk+w7ldEByb+697iacYknb0mPG9iEDTLA2Aze53
         WaGjZHf8mOuUFw9c8a0spmAP7HYLwfrgcaD7gy/4ey/TaQt82ASx1W9dZn9GbxF9uoR4
         7/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771448769; x=1772053569;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ccWJDzJ7m4S4l+nz4VuzRpZZrXnjyW9kyBaNIifc8MY=;
        b=TC6qc84waz5UddASQS5jJhOcA2oMTTalYucqpWi8BDBSziNPL2F5QwHURp4tlJrR03
         bce51lZaRg/fQaEuzBvBLJg2ZqJv3GySJBFbeQR+8KqwqKmJ2NPrF+wq/ws7gEWFYvk5
         JrkLIdEs1iL/ol6/8VlAwVA3TdY5LulyDc0OvlzTxGXE2KiIfFaOGrQ5UzGjFNk6AvY2
         Mqd/HJWnYS/Iw6JJDosaseIwXD6OclawF27xzrWoBZvMa3NGNRFdUWsUpqHrT/ADxrT+
         j2BdrPZq+FPmZjaNSrptTg5mTBnmr2b5OKe+qnB3BDfMcMPp2eBGDsjJd15YQOl67DuL
         1Bjg==
X-Forwarded-Encrypted: i=1; AJvYcCUChoLlrFD+bkclhRduYIyHz9Q2LsSm0oAHQ954ND0EtL+/ceIihSAyMO5D+s2NA4lUnUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMaN8tIiO+avQc3qjKUrn5jRIz/3l/FmNbaBjLxHwXJ5wUXCZq
	clkZCbgEwEncLWl0UX/OwPdHKQZHvBYZXB2qjqCJ69Wh4320ySFsgtsR8aeTRleHMZoJTe+M7nu
	/YWxhFw==
X-Received: from pjbne18.prod.google.com ([2002:a17:90b:3752:b0:356:1da4:5dd1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5584:b0:34a:c671:50df
 with SMTP id 98e67ed59e1d1-35888d58b61mr2639291a91.17.1771448768639; Wed, 18
 Feb 2026 13:06:08 -0800 (PST)
Date: Wed, 18 Feb 2026 13:06:07 -0800
In-Reply-To: <CALzav=fN4FpZsfzwbdLeNSj4nx4OpRkwHvKiZNVgP8S-zsUvJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com> <aBPhs39MJz-rt_Ob@google.com>
 <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com>
 <aRZ9SQ_G2lsmXtur@google.com> <CALzav=fN4FpZsfzwbdLeNSj4nx4OpRkwHvKiZNVgP8S-zsUvJA@mail.gmail.com>
Message-ID: <aZYpv6O15YMlGkzT@google.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	James Houghton <jthoughton@google.com>, Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71273-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,linux.dev,arm.com,huawei.com,brainfault.org,atishpatra.org,sifive.com,dabbelt.com,eecs.berkeley.edu,ghiti.fr,linux.ibm.com,ventanamicro.com,intel.com,google.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[28];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 75034159C6B
X-Rspamd-Action: no action

On Wed, Dec 03, 2025, David Matlack wrote:
> On Thu, Nov 13, 2025 at 4:52=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > My slowness is largely because I'm not sure how to land/approach this. =
 I'm 100%
> > in favor of the renames, it's the timing and coordination I'm unsure of=
.
> >
> > In hindsight, it probably would have best to squeeze it into 6.18, so a=
t least
> > the most recent LTS wouldn't generate conflicts all over the place.  Th=
e next
> > best option would probably be to spin a new version, bribe Paolo to app=
ly it at
> > the end of the next merge window, and tag the whole thing for stable@ (=
maybe
> > limited to 6.18+?) to minimize downstream pain.
>=20
> With LPC coming up I won't have cycles to post a new version before
> the 6.19 merge window closes.
>=20
> I'm tempted to say let's just wait for the next LTS release and merge
> it in then. This is low priorit, so I'm fine with waiting.

I ran this by Paolo in last week's PUCK, and he's in favor of the renames (=
or at
least, is a-ok with us doing it).  If you can prep a new version in the nex=
t week
or so, we can get it applied for 7.1 shortly after the merge window closes.

We don't send all that many selftests patches to LTS kernels, so IMO it's n=
ot
worth waiting for the next LTS to come around.

