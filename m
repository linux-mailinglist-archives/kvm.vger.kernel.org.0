Return-Path: <kvm+bounces-53050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EA41B0CED6
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 02:45:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F8E96C610C
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 00:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608AE12CD96;
	Tue, 22 Jul 2025 00:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="khrrwvad"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534442E36E8;
	Tue, 22 Jul 2025 00:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753145094; cv=none; b=as4EMSy4/popHeqScJ+m9vRjYEY8eDhXeVyrzg24vv8+XEpqnCe7avPHXetAOWJ6xiwwk9iCrWIUTwKAbOvT9wRpAB/m4shxFxdXwJTp8ZHwR06UqXFmDAxOOWTAlgse1qa69lbqvL/1aE5Z6nkTAxF8q+EcXRiP4fGFCwXnxwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753145094; c=relaxed/simple;
	bh=YnYnOMMcPhP91J0ZDVahIKQvhv2k14TcqZm+L0HNrN8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=lCpZsG3XY1vnhUd4e1YV6jqw9aVOmMYfswcnMy8QXPQ9uenuVCBkgypYkCwou7OHsS/cjzv9yWKPrxahq+2xKYtzkEUzS6O1TDOPwQr+mQIgZaCKn1GTG7qffAUKIWOgMCGR7hHSWWtlfzNBw0jVXNWjIcFDlFd4WEePVshnRPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=khrrwvad; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56M0iCaU294873
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 21 Jul 2025 17:44:12 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56M0iCaU294873
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1753145053;
	bh=VVDXd94/H5kRM3l9h1Hqsygj1y2tHMViFb4Getf5Mko=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=khrrwvadChRGQiG2HVM7eAaj0k6Gs3Bsjn2eeIu1TgYtLzTVaDxwWwidMUpmm9GPP
	 sC2AM80JLrv8+nnpRpwhIefOsYOBIQGh6t5BYfn/I8WSCyRCWzodZBU+vXILlaed6n
	 3m+DqqZRo8VX0VoJrnI7PEfeazDd0U6kg6K+odcF4aB0bCk61tCWSqhQkZtzck6Em/
	 pg5sxtrr+pD6LKjyqEfxv0ffzU5C+BnfAYM1qxeS+7pGkkNyuJzEiDmIt2+6xgl0V3
	 E4nvnbEoTQX6H2yOHBNoxcbRsLi1gPv5cuAyzVsI3lf4mXn1r5/J49bxmWehqWAr8/
	 5OdX4dr22P+9g==
Date: Mon, 21 Jul 2025 17:44:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Huang, Kai" <kai.huang@intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_1/7=5D_x86/kexec=3A_Consolida?=
 =?US-ASCII?Q?te_relocate=5Fkernel=28=29_function_parameters?=
User-Agent: K-9 Mail for Android
In-Reply-To: <c494ea025188c6b1dcf7ef97a49fcd1cf2dab501.camel@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com> <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com> <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com> <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com> <7eb254a7-473a-94c6-8dd5-24377ed67a34@amd.com> <1d2956ba8c7f0198ed76e09e2f1540d53c96815b.camel@intel.com> <38C8C851-8533-4F1E-B047-5DD55C123CD1@zytor.com> <BL1PR11MB5525BEC30C6B9587C2DF23A0F75DA@BL1PR11MB5525.namprd11.prod.outlook.com> <c494ea025188c6b1dcf7ef97a49fcd1cf2dab501.camel@intel.com>
Message-ID: <D6A63DDD-6A33-4A78-8A3F-2A7D0ACC9902@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On July 21, 2025 4:42:22 PM PDT, "Huang, Kai" <kai=2Ehuang@intel=2Ecom> wro=
te:
>On Mon, 2025-07-21 at 23:29 +0000, Huang, Kai wrote:
>> > On July 21, 2025 2:36:48 PM PDT, "Huang, Kai" <kai=2Ehuang@intel=2Eco=
m> wrote:
>> > > On Mon, 2025-07-21 at 16:27 -0500, Tom Lendacky wrote:
>> > > > > > > @@ -204,7 +202,7 @@
>> > SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
>> > > > > > > =C2=A0=C2=A0	 * entries that will conflict with the now une=
ncrypted memory
>> > > > > > > =C2=A0=C2=A0	 * used by kexec=2E Flush the caches before co=
pying the kernel=2E
>> > > > > > > =C2=A0=C2=A0	 */
>> > > > > > > -	testq	%r8, %r8
>> > > > > > > +	testq	$RELOC_KERNEL_HOST_MEM_ACTIVE, %r11
>> > > > > >=20
>> > > > > > Hmmm=2E=2E=2E can't both bits be set at the same time? If so,=
 then this
>> > > > > > will fail=2E This should be doing bit tests now=2E
>> > > > >=20
>> > > > > TEST instruction performs logical AND of the two operands,
>> > > > > therefore the above equals to:
>> > > > >=20
>> > > > > =C2=A0	set ZF if "R11 AND BIT(1) =3D=3D 0"=2E
>> > > > >=20
>> > > > > Whether there's any other bits set in R11 doesn't impact the ab=
ove, right?
>> > > > >=20
>> > > >=20
>> > > > Doh! My bad, yes, not sure what I was thinking there=2E
>> > > >=20
>> > >=20
>> > > Np and thanks! I'll address your other comments but I'll see whethe=
r
>> > > Boris has any other comments first=2E
>> > >=20
>> >=20
>> > You can use testb in this case to save 3 bytes, too=2E
>>=20
>> Yeah I can do that, thanks for the info!
>
>I just tried=2E  I need to do:
>
>	testb	$RELOC_KERNEL_HOST_MEM_ACTIVE, %r11b
>
>in order to compile, otherwise using plain %r11 generates:
>
>arch/x86/kernel/relocate_kernel_64=2ES:212: Error: `%r11' not allowed wit=
h
>`testb'
>
>I'll do some test and if there's no problem I'll switch to use this way,
>assuming it still saves us 3-bytes=2E
>

That works just fine=2E

