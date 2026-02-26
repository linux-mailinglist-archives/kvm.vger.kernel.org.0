Return-Path: <kvm+bounces-72076-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8K4vDkOloGk9lQQAu9opvQ
	(envelope-from <kvm+bounces-72076-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:55:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4291AEC16
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA6083030ECF
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 890C2453482;
	Thu, 26 Feb 2026 19:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="P9ThSoxi"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AD04657EE;
	Thu, 26 Feb 2026 19:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772135685; cv=none; b=bRrjrdM+OOhCnWLhdqL6lyf1JvSh3fDljoOEWEghzkycBUcGdanRnWOg6n6qZVnPtpuk16JXDE1OEbEmLESCEapumPRV0CBeRk7sovYUfXbTym92Olp3p/gX/s3AAWbLtN5hZD+7WwluBtH4bmVGu54x+IQ2GKbhzI1k6RLG9hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772135685; c=relaxed/simple;
	bh=x54d2baeE77yNhu6wwVcv6qrUq9rnBCcXS6uVsR2SGc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=ep5BEWhYCm7dVnojU4/80nFUq9/WU2ujDFDNA6R7/hjd5CFRxNi623YinObPQGcuRZYr6k8icV+vUPiSlo4teVdV1KUtoEzoksCBBN2zNTUUCqFfZrRZ5QT5Q+92zkH8gbpbsabaui9h/wZKoMxRoezYQiFmDwGA+lqS6PvJmiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=P9ThSoxi; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D133E40E0184;
	Thu, 26 Feb 2026 19:54:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lMKEdv77YEpW; Thu, 26 Feb 2026 19:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1772135678; bh=x54d2baeE77yNhu6wwVcv6qrUq9rnBCcXS6uVsR2SGc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=P9ThSoxizN6hmJ+QfHBqfM1qFoWkUvT+vuq3klyihOL9TBGrYZonO1OcQLTxLUajh
	 TNCGmaBOa9blFViA/lU+DCfIgdjX0/WsU2TPNDmDphnFW3RN4NF3/j3iX4NpwFdtwJ
	 hr2efNSL1vtsCbllW3YLL13wKXbsBHpSVdkyWLeO3EAuRpegCGPRqXtjS5uZn7lcZV
	 sGvQGFKh+KTdqhTPkk4qmb970cuLnn4/kzHY9CrtJxcNiIX2ouEvg2XwA1jG0AdPhF
	 YrPBEz/ZxToWjn6I09OrDlimULEhTW51NIk54GRUnb9HtOFOJmBBlq/ud8qRDLvFDI
	 sszXPTQUmqWJJc/6vuBqNui141k4MdnDyWOn59PbbQc25ntUKcq3bINGNXPik4NCmC
	 tEl0ue4njjC0+GxeNh+9MyZkEwCJMYfddTBjtrKHKMux5eCBLROhow0jHajMnFkYhB
	 tI2bOYiP0kLzJRCw2MiV6NNVZow1VlT4OXinm9wVGsVkgI9bCIphqWF+e85DnZCxPY
	 l+cadTsPZMkmMalAr9k1O1nSvwxI+prZOgZrj0FeGA0s0m6Fe/vFkhwIryEn4cj+4d
	 nMsr7d9E+EZ19XEAfaxjA5hrqy0yRzA0k4rZ8NVGy7YZjDXyimI+y9WOsk64z8bmmy
	 QZJKwLN3jVP+/6DrUJz37AzQ=
Received: from ehlo.thunderbird.net (unknown [IPv6:2a02:3033:6db:bde8:b104:c2ae:3935:ab76])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DA2E540E016E;
	Thu, 26 Feb 2026 19:53:40 +0000 (UTC)
Date: Thu, 26 Feb 2026 19:52:33 +0000
From: Borislav Petkov <bp@alien8.de>
To: Alexey Kardashevskiy <aik@amd.com>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Mike Rapoport <rppt@kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>,
 Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 Tony Luck <tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Denis Efremov <efremov@linux.com>, Geliang Tang <geliang@kernel.org>,
 Piotr Gregor <piotrgregor@rsyncme.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Alex Williamson <alex@shazbot.org>,
 Arnd Bergmann <arnd@arndb.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Kim Phillips <kim.phillips@amd.com>,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_kernel_7/9=5D_coco/sev-guest=3A_Impl?=
 =?US-ASCII?Q?ement_the_guest_support_for_SEV_TIO_=28phase2=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <428d4373-1b78-4882-baf9-1df563f66a86@amd.com>
References: <20260225053806.3311234-1-aik@amd.com> <20260225053806.3311234-8-aik@amd.com> <ABE746F3-53E9-4730-BBFC-52111166A7B9@alien8.de> <428d4373-1b78-4882-baf9-1df563f66a86@amd.com>
Message-ID: <688A7E51-B268-482F-B022-420D3A18A91B@alien8.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.96 / 15.00];
	SUBJ_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[alien8.de:+];
	TAGGED_FROM(0.00)[bounces-72076-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_GT_50(0.00)[57];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:email,alien8.de:mid,alien8.de:dkim]
X-Rspamd-Queue-Id: CC4291AEC16
X-Rspamd-Action: no action

On February 26, 2026 3:39:37 AM UTC, Alexey Kardashevskiy <aik@amd=2Ecom> w=
rote:
>I struggle to separate these more without making individual patches usele=
ss for any purpose

You sound like someone who hasn't been reviewing patches and scratching hi=
s head how to approach such a conglomerate as yours which does many things =
at once=2E=2E=2E

The rule is very simple actually: a patch should do one logical thing only=
=2E And no more=2E It doesn't matter whether the patch is "useless" by itse=
lf=2E It matters only whether it is reviewable and one can to a certain deg=
ree see that the transformation it contains is relatively bugfree=2E

And I'm very sure that when you start reviewing patches, you'll be pretty =
much asking people sending conglomerates like yours, to split them=2E

Thx=2E
--=20
Small device=2E Typos and formatting crap

