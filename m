Return-Path: <kvm+bounces-66779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A643CE7391
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 16:36:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B7963013EF8
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 15:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A8A325700;
	Mon, 29 Dec 2025 15:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yad/3u+y"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0535416CD33;
	Mon, 29 Dec 2025 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767022575; cv=none; b=uV1yV5NEp0NqjiDseLWPsyaHke2HcWdJBY5ysy2LDhbTcU+rjYAp4l4F3Qvcar9MmWR+7VquI4AvlgZ4EiDk6SdDzjKUPXhB/QhYaZvqn/+lbMiG8Gt3zfJV65SDml5xzfF6M+dyMWdDCe9BXMvEwyw5+gl7bUa/xbNqcwxNcxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767022575; c=relaxed/simple;
	bh=vPos8tMKyFalMXEmW7FG3fOfEYOyPxH+bggND0prJvI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=E17Q6FrJDIYOpzGWnp/cTrm+8aYxcPR4O2Vs1VcqiHCGxnW7aS9la0qkKsVTSZpuzHV4VznrXUiTUy7jLAwKVx3zOOryIc4Lu1lEj9O7jIlCsECA7iBn4eEHScHAbfJQBtrI1NHEbSppSWoS5DbXHKSJ/2MHKso7WtZp9F/Efi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yad/3u+y; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=vPos8tMKyFalMXEmW7FG3fOfEYOyPxH+bggND0prJvI=; b=Yad/3u+yN4JD/hg2estUQIoDIR
	dcqdX6KkFHQvNLiV0oHjAVRLnZSse0zh/q2bxz31FbsvhPsUi1gPwdXFFvFGlQstAiW1mvJK9xeMZ
	1fy3ZodBGRke4Fa4ZC+DpqUazrHb/9Aqxxos0MnmTyL7r+2Hfw/XwTKMfWKtxB+Nk9Gf3MG7c5w8p
	c42Ylm9+5wWNyESJgi+qKQTbQDHUGAMoXGO+6dOz3/JrARitqngfASf+LcoJ7XndqtvqjajaLPSw9
	TynVr3cQlBhQWqmr85UOv8MwHOsaij5dCzR3eDdmA2RECYo8rsLd0BA0lo70AHtWtaQ4j2Mgy2R+t
	AzB23VJw==;
Received: from [2001:8b0:10b:5:c095:f2fb:8d79:fda1] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vaFHs-00000002vKB-3xyO;
	Mon, 29 Dec 2025 15:36:01 +0000
Date: Mon, 29 Dec 2025 15:36:00 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Khushit Shah <khushit.shah@nutanix.com>
CC: "seanjc@google.com" <seanjc@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kai.huang@intel.com" <kai.huang@intel.com>,
 "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
 "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, Jon Kohler <jon@nutanix.com>,
 Shaju Abraham <shaju.abraham@nutanix.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5_2/3=5D_KVM=3A_x86/ioapic=3A_Implemen?=
 =?US-ASCII?Q?t_support_for_I/O_APIC_version_0x20_with_EOIR?=
User-Agent: K-9 Mail for Android
In-Reply-To: <BE16B024-0BE6-46B4-A1B4-7B2F00E4107B@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com> <20251229111708.59402-3-khushit.shah@nutanix.com> <7294A61D-A794-4599-950C-9EC9B5E94B58@infradead.org> <DD13B2B3-5719-410F-8B98-9DB3E1738997@nutanix.com> <9a04f3dda43aa50e2a160ccfd57d0d4f168b3dce.camel@infradead.org> <BE16B024-0BE6-46B4-A1B4-7B2F00E4107B@nutanix.com>
Message-ID: <D6CA802E-F7E0-410D-87FB-6E6E5897460E@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 29 December 2025 15:16:40 GMT, Khushit Shah <khushit=2Eshah@nutanix=2Eco=
m> wrote:
>
>
>> On 29 Dec 2025, at 6:31=E2=80=AFPM, David Woodhouse <dwmw2@infradead=2E=
org> wrote:
>>=20
>> Hm? IIUC kvm_lapic_advertise_suppress_eoi_broadcast() is true whenever
>> userspace *hasn't* set KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST
>> (either userspace has explicitly *enabled* it instead, or userspace has
>> done neither and we should preserve the legacy behaviour)=2E
>
>The legacy behaviour for "kvm_lapic_advertise_suppress_eoi_broadcast()" i=
s:
>- true for split IRQCHIP (userspace I/O APIC)
>- false for in-kernel IRQCHIP
>
>The in-kernel IRQCHIP case was "fixed" by commit 0bcc3fb95b97 ("KVM: lapi=
c:
>stop advertising DIRECTED_EOI when in-kernel IOAPIC is in use"), which ma=
de
>it return false when IOAPIC is in-kernel=2E
>
>With this series, in QUIRKED mode the function still returns !ioapic_in_k=
ernel(),
>preserving that exact legacy behavior=2E The I/O APIC version 0x20 (with =
EOIR)
>is only used when userspace explicitly sets the ENABLE flag=2E
>
>The comments in patch 1 explain this in more detail ;)

Ah, OK=2E So in the case of in-kernel I/O APIC, kvm_lapic_advertise_suppre=
ss_eoi_broadcast() kvm_lapic_respect_suppress_eoi_broadcast() are the same=
=2E In that case we can choose the one which is easier to understand and do=
esn't need the reader to refer back to an earlier commit? I accept your cor=
rection; the patch is correct=2E

But I think I still prefer the check to be on _respect_ as it's clearer th=
at it's part of the new behaviour that is only introduced with this series=
=2E

