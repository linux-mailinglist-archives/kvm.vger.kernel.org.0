Return-Path: <kvm+bounces-71795-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kK1rATKRnmnTWAQAu9opvQ
	(envelope-from <kvm+bounces-71795-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:05:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E2A1192413
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:05:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1464D303A24A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD3EF2F8BF0;
	Wed, 25 Feb 2026 06:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LmuwbZQ+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70BC2E0B58;
	Wed, 25 Feb 2026 06:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771999519; cv=none; b=lGic+FM9HMh1s4n/QBsQ+gpNLJMthAtdeRZdA4eqAOPkVpFZq+rXpBgEn5EIbKJb85AK/U9JaiBcx+RwQujrXEVa1/nHpzDLlQaDiZyQWiXrwOuOCsA60dveOjCY+7MNoxA0/Lhqk3kS0CpdZtTtPVw6qX3IFQnJZqmTlJPUzaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771999519; c=relaxed/simple;
	bh=Wf1NAXhwwgYbTfWAQ3CfK8D4hPW/t1EznsBIOEahMmg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Hm+ZPvBsCHsO0dE+jJhN3QLyl401BtccQlc0cdV7bbB0V/l97F5b2pbJEjPKwIyh+5ZNHXzgu3y+xulQd3XAzkFZB1wtpyctSt6es/SGaysbUd9GqW3LluhTGvbXJ8MW9o6Renti3KqJsTkN9vS/Pp2a+xPdm2CPTIJ/ZeJsRrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=LmuwbZQ+; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9560740E016B;
	Wed, 25 Feb 2026 06:05:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lzr2iwiSNx47; Wed, 25 Feb 2026 06:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1771999512; bh=Wf1NAXhwwgYbTfWAQ3CfK8D4hPW/t1EznsBIOEahMmg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=LmuwbZQ+TR+/yHEhnG3uHbqfIkW9NJZYtzQGR7ntY9f14ZsTxXsqdljW/hEa07HHC
	 bsD7xuO+UFtuppQrGqBbq9UyFPEOao60KNnliUKVYy7YsMhnaIYbXqKu9ImMKkBAsj
	 Lp6PkE/QTzivdNs8N2EWZab5T2mnJQRIe+I75wKeOBzj6ijiq3LaIgA+1GfA88sByl
	 7FvsCdd2xMuHOb4J7YNaKQXoxikbKh9C8QBBUgfE76O/Pb3VUKqBjAEie9ajniuTxS
	 IDDluSKrMa4UWN51YtBfK78Csa1h8/f1k4SQwDUv1gYy2ym0KS05/0J7Q/TBBTrgV3
	 Ki3NvHgWxVzXnNGgo97WmICk3QvJMLhrkSQkavJrPjeo4jbvMmxigODqQRpzSX9Ftt
	 Py5viGI9VhpcZGBhzMKqNmnLe6mL7ber52vtjHfMoSMd/7FtQ5BMVHcVP6GErlHQuH
	 /mJU16IYT/6tBb7Y8pIVPJq0/RlCkG30ppGRPfaJaBicNuTtgdh9JNzDtWeSLXs/+B
	 5KkXEI3sp7TOCtNhCz/q2OwO8JeuKlYyzY6YuB7lAxRpgQtzSShpdn4nvCJodOCpHo
	 2mFXZ4nm7o7a/3cJyhNq+JJ7JboZ3Slf4zGne4KHPjf3sFVG2LPSaeTJYF+83Mu7Vc
	 fxIiVsHuYbDPf+vB9Wlv/H7E=
Received: from ehlo.thunderbird.net (unknown [IPv6:2a02:3030:29:49b0:dd25:4e4d:df7d:75fb])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 49F8040E0171;
	Wed, 25 Feb 2026 06:04:14 +0000 (UTC)
Date: Wed, 25 Feb 2026 06:00:59 +0000
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
In-Reply-To: <20260225053806.3311234-8-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com> <20260225053806.3311234-8-aik@amd.com>
Message-ID: <ABE746F3-53E9-4730-BBFC-52111166A7B9@alien8.de>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[alien8.de:+];
	TAGGED_FROM(0.00)[bounces-71795-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_GT_50(0.00)[57];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,alien8.de:mid,alien8.de:dkim]
X-Rspamd-Queue-Id: 2E2A1192413
X-Rspamd-Action: no action

On February 25, 2026 5:37:50 AM UTC, Alexey Kardashevskiy <aik@amd=2Ecom> w=
rote:
>Implement the SEV-TIO (Trusted I/O) support in for AMD SEV-SNP guests=2E
>
>The implementation includes Device Security Manager (DSM) operations
>for:
>- binding a PCI function (GHCB extension) to a VM and locking
>the device configuration;
>- receiving TDI report and configuring MMIO and DMA/sDTE;
>- accepting the device into the guest TCB=2E
>
>Detect the SEV-TIO support (reported via GHCB HV features) and install
>the SEV-TIO TSM ops=2E
>
>Implement lock/accept/unlock TSM ops=2E
>
>Define 2 new VMGEXIT codes for GHCB:
>- TIO Guest Request to provide secure communication between a VM and
>the FW (for configuring MMIO and DMA);
>- TIO Op for requesting the HV to bind a TDI to the VM and for
>starting/stopping a TDI=2E

Just from staring at that huuuge diff, those bullets and things above are =
basically begging to be separate patches=2E=2E=2E


--=20
Small device=2E Typos and formatting crap

