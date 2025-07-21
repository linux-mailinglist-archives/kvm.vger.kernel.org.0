Return-Path: <kvm+bounces-53043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1327CB0CD85
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 01:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC7131C226AA
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577BA24397A;
	Mon, 21 Jul 2025 23:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="XxoJdyWH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2479241665;
	Mon, 21 Jul 2025 23:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753139148; cv=none; b=gRL+h2jtsSSs74YZcHfwyqORlmrOeiyZm2+YmpaOhzeeL1Y2lrt1BQYggUtshXh5UgTBPUmn4rmmn1XFruRVVaZbkJojkMoszve/DAgyZ7LVPZ6sfy7gRfXnAUAwmyrzxAeKSOXybLPtQhl4q3f1bHpGZSpIedQuDGwMBm8SqVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753139148; c=relaxed/simple;
	bh=sH/j7jC8YD3T7eROXTCNl+TXagdKPgArZMgaaYWQ9f4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=QoLrk4giUa7/hZ21B5SM7OTwWDJ73zm3EOdLiKGH4mLhOGiidz56KX7HcP3ndzItPI70pNLoihT3tkdmvhIdsIuzk463/ELNveAdvmqee8Goo5rDVLLtDYUwf2YPkLvzoro87Cf273lCIMxqF8TIT5EsQRGoPFEdKI1ZL7s9Kf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=XxoJdyWH; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56LN552p262172
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 21 Jul 2025 16:05:05 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56LN552p262172
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1753139106;
	bh=IcSLGI+UscM41aBN5mpfNQZiC0pJ8b3fxaE2PLwPgtk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=XxoJdyWH7fCFOedARIMot9FsHxXuzObxbi41yIhvDbjS6dbakJfYr0AXF+PeEKEid
	 R1blE0LIaFBQS0HjY6fxlqMaMu9fqg5gNFF6u648Tud3zaBOm/6iMx3r2Txo+5F6Sb
	 2N3XSZxfl13vhQlws9+AUS28ptk48mc9wb2eiIJ87F/Ui7EpxGb7CwC17vnuTD8RyB
	 YLoraNVjNTUr/tWYquA4pFk9eqQ+bZMV9WkMPeOkaxmS11lmkpYPMwzG5AwZNBWP8+
	 ow+RFhQZ2ujsw4p061qQypByGVudGXjGXof/aKFys9iuCpyWERla3z2JyinT5mi9fS
	 zFBCKCfa2j47g==
Date: Mon, 21 Jul 2025 16:05:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Huang, Kai" <kai.huang@intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>
CC: "Gao, Chao" <chao.gao@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
        "sagis@google.com" <sagis@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_1/7=5D_x86/kexec=3A_Consolida?=
 =?US-ASCII?Q?te_relocate=5Fkernel=28=29_function_parameters?=
User-Agent: K-9 Mail for Android
In-Reply-To: <1d2956ba8c7f0198ed76e09e2f1540d53c96815b.camel@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com> <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com> <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com> <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com> <7eb254a7-473a-94c6-8dd5-24377ed67a34@amd.com> <1d2956ba8c7f0198ed76e09e2f1540d53c96815b.camel@intel.com>
Message-ID: <38C8C851-8533-4F1E-B047-5DD55C123CD1@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On July 21, 2025 2:36:48 PM PDT, "Huang, Kai" <kai=2Ehuang@intel=2Ecom> wro=
te:
>On Mon, 2025-07-21 at 16:27 -0500, Tom Lendacky wrote:
>> > > > @@ -204,7 +202,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
>> > > > =C2=A0=C2=A0	 * entries that will conflict with the now unencrypt=
ed memory
>> > > > =C2=A0=C2=A0	 * used by kexec=2E Flush the caches before copying =
the kernel=2E
>> > > > =C2=A0=C2=A0	 */
>> > > > -	testq	%r8, %r8
>> > > > +	testq	$RELOC_KERNEL_HOST_MEM_ACTIVE, %r11
>> > >=20
>> > > Hmmm=2E=2E=2E can't both bits be set at the same time? If so, then =
this will
>> > > fail=2E This should be doing bit tests now=2E
>> >=20
>> > TEST instruction performs logical AND of the two operands, therefore =
the
>> > above equals to:
>> >=20
>> > =C2=A0	set ZF if "R11 AND BIT(1) =3D=3D 0"=2E
>> >=20
>> > Whether there's any other bits set in R11 doesn't impact the above, r=
ight?
>> > =C2=A0=20
>>=20
>> Doh! My bad, yes, not sure what I was thinking there=2E
>>=20
>
>Np and thanks! I'll address your other comments but I'll see whether Bori=
s
>has any other comments first=2E
>

You can use testb in this case to save 3 bytes, too=2E

