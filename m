Return-Path: <kvm+bounces-68928-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJ/7EVdzcmlpkwAAu9opvQ
	(envelope-from <kvm+bounces-68928-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:58:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A29846CCBD
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D694A30136B4
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46E938551B;
	Thu, 22 Jan 2026 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oopj1T3C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40245371068;
	Thu, 22 Jan 2026 18:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769107643; cv=none; b=uB9wIJ03Eo1+g3luR35JFqhUIW0A0aqc6CfU2d8k3jqeqswW4ssNtzFyPYbukPqbD32SQMXqgc+eE0pkkpAosH0JYDTtABT1aDPrrraUYc7KLRZUzGmwI9YF5DMB5IKkkkLZ2DdP3vI2DQtV56ZxAe/SSEG96o1rZMEQWhr+/1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769107643; c=relaxed/simple;
	bh=puZkcLq0LJbBc92hUq9q08tH9W7ZSmix0U1xdnYs+V0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=o10Al1qlEAH8J/9x8nuz6aizyc/+xMVdKazxbAoxjiyt45jZQOEC+4Tmr5vxpOzb53MPtCcPgYz1iWyftzp3F5DVIv2l1EN0sJgXxSiCmAvYceatGUo/prnhyV6OfoRD3OxLlsEBWMtc3E0rv/l+diTZcxbcecnws3B1dNFA+y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oopj1T3C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFC0C116C6;
	Thu, 22 Jan 2026 18:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769107642;
	bh=puZkcLq0LJbBc92hUq9q08tH9W7ZSmix0U1xdnYs+V0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Oopj1T3C87F1OYkkk/5BD0ca99ulodCm+Ezbv2lwzIfZcowo3h/CJJ0q0QidAVZoF
	 Bf9+oZMr8wPnKv+D1oedhwr03xBH2o2ZfAbV2qNAdXA5GVXIKxX6QGx5wE4LVt6Abm
	 9vr0IIGCmDkRvRCBoNLmve3e5ezH+x9ECFZEyrzLEiTakr/4wVNOxgcwsHfk+iR9TG
	 Pm1YBaMFd82xZvRFpRluuvy1Ecv1Gkw3QI9lf2rTFbtohxiMzfX3EGjR05bo/mbpDk
	 HGa6HnzEkZ837z6ETr/vpqCLC3W9hg+eor5l2Dp3conaZmwspMkZNMpG+8A6SLAAmr
	 IM2dAF1bynjRA==
From: Thomas Gleixner <tglx@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>, Ankit Soni <Ankit.Soni@amd.com>,
 Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>, Vasant
 Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, Joao
 Martins <joao.m.martins@oracle.com>, Francesco Lavra
 <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>, Naveen
 Rao <Naveen.Rao@amd.com>, Crystal Wood <crwood@redhat.com>
Subject: Re: possible deadlock due to irq_set_thread_affinity() calling into
 the scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold
 ir_list_lock across IRTE updates in IOMMU)
In-Reply-To: <5bea843b-dec8-4f15-bb7c-1d0550542034@redhat.com>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
 <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com> <874iovu742.ffs@tglx>
 <87pl7jsrdg.ffs@tglx> <5bea843b-dec8-4f15-bb7c-1d0550542034@redhat.com>
Date: Thu, 22 Jan 2026 19:47:18 +0100
Message-ID: <87sebxtrgp.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [4.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68928-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	GREYLIST(0.00)[pass,body];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[linux.dev,8bytes.org,infradead.org,linux.intel.com,lists.infradead.org,lists.linux.dev,vger.kernel.org,amd.com,redhat.com,oracle.com,gmail.com,google.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tglx@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.991];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A29846CCBD
X-Rspamd-Action: no action

On Wed, Jan 21 2026 at 19:13, Paolo Bonzini wrote:
> On 1/8/26 22:53, Thomas Gleixner wrote:
>> Are you still claiming that this is a kernel/irq bug?
>
> Not really, I did say I'd like to treat it as a kernel/irq bug...
> but certainly didn't have hopes high enough to "claim" that.
> I do think that it's ugly to have locks that are internal,
> non-leaf and held around callbacks; but people smarter than
> me have thought about it and you can't call it a bug anyway.

Deep core code has a tendency to be ugly. But if it makes your life
easier, then these wakeups can be delayed via an irq_work to be outside
of the lock. That needs some life-time issues to be addressed, but
should be doable.

Thanks,

        tglx

