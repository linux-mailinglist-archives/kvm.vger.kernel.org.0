Return-Path: <kvm+bounces-11792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E04C587BBEC
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 12:27:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AFB81C23323
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 11:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3516EB7C;
	Thu, 14 Mar 2024 11:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vq1Q3vey"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350FB6EB5D;
	Thu, 14 Mar 2024 11:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710415652; cv=none; b=nAg/XOAwRqav9pDRE3waLfcwjoKy46lLa02Bytb4m8s+vHGEBC7hsCrFEP0x/9HGiq2s5HhhKoloX6L+AjMzFJFzQpWHZmnHJTh3/bCjPO7D8A2DsckU4KxLw2azHa5eWL283meEg2Uird+fVDpyIBYBwP0rpGKZpb/FHe2270E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710415652; c=relaxed/simple;
	bh=GqRRN7Gy1wji1RHe+Tu4TFLSTVMzkG2q5lTvefIyzRU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=KTR2/dLO0c2n2T8Getk+QriEDsnsht05s4wVnD5gkcimpaB0yXrQl+AfMHJXkcYn9hltoesenpxiDjQWZrH1nN7TAXgcZw5fZQYowJTUJYGwBekScX/lNgZtapcztEi4leEjYoYNLNV8/K4k+pFVcLxWKhAs0C4dq0M5qLtq6a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vq1Q3vey; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=GqRRN7Gy1wji1RHe+Tu4TFLSTVMzkG2q5lTvefIyzRU=; b=Vq1Q3veyZarK0LuaADg8Zj8zER
	U8eljUtoa10X4GQuCrkZcJwRveL8E3n5jSlW0CpsRjgOWvRis/JdLIh+G/nU5Muk/hxb6I4HR6jGE
	iiwJmjL75qSAoJUhe0PpRdn1P4uALnBHIp2TpJ4aF9NXWoyAZBSUjJLPRJSbftPVQj0GDzjAFfplY
	7lVlbe7+vZ70HrHdLIQLPbrMrAeibCHzTQDe/rQlVP8JfSfTCY2ZYs1lG8XYa7rfJPjmQ2dhrVYi/
	ciCo3hrXXufTSlrAB/NbPZ++eD2jCWHMKnNvk+KgdtLqqhc8XrSQ2OUor3a1eUTVJvqgmvLjh8UZ/
	Lz0Hsgyg==;
Received: from [31.94.26.231] (helo=[127.0.0.1])
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkjF0-0000000ASlo-3aMq;
	Thu, 14 Mar 2024 11:27:19 +0000
Date: Thu, 14 Mar 2024 12:27:14 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sudeep Holla <sudeep.holla@arm.com>
CC: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <len.brown@intel.com>,
 Pavel Machek <pavel@ucw.cz>, Mostafa Saleh <smostafa@google.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-pm@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_2/2=5D_arm64=3A_Use_SYSTEM=5FO?= =?US-ASCII?Q?FF2_PSCI_call_to_power_off_for_hibernate?=
User-Agent: K-9 Mail for Android
In-Reply-To: <ZfLa1_TWArT7tCtb@bogus>
References: <20240312135958.727765-1-dwmw2@infradead.org> <20240312135958.727765-3-dwmw2@infradead.org> <ZfB7c9ifUiZR6gy1@bogus> <520ce28050c29cca754493f0595d4a64d45796ee.camel@infradead.org> <ZfHHlBgSNr8Qm22D@bogus> <ZfLa1_TWArT7tCtb@bogus>
Message-ID: <5A0D0B83-F898-4B5B-893F-7953847ED5CD@infradead.org>
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

On 14 March 2024 12:09:11 CET, Sudeep Holla <sudeep=2Eholla@arm=2Ecom> wrot=
e:
>On Wed, Mar 13, 2024 at 03:34:44PM +0000, Sudeep Holla wrote:
>> On Tue, Mar 12, 2024 at 04:36:05PM +0000, David Woodhouse wrote:
>> > On Tue, 2024-03-12 at 15:57 +0000, Sudeep Holla wrote:
>> > > Looked briefly at register_sys_off_handler and it should be OK to c=
all
>> > > it from psci_init_system_off2() below=2E Any particular reason for =
having
>> > > separate initcall to do this ? We can even eliminate the need for
>> > > psci_init_system_off2 if it can be called from there=2E What am I m=
issing ?
>> >
>> > My first attempt did that=2E I don't think we can kmalloc that early:
>> >
>>
>> That was was initial guess=2E But a quick hack on my setup and running =
it on
>> the FVP model didn't complain=2E I think either I messed up or somethin=
g else
>> wrong, I must check on some h/w=2E Anyways sorry for the noise and than=
ks for
>> the response=2E
>>
>
>OK, it was indeed giving -ENOMEM which in my hack didn't get propogated
>properly =F0=9F=99=81=2E I assume you have some configs that is resulting=
 in the
>crash instead of -ENOMEM as I see in my setup(FVP as well as hardware)=2E
>
>Sorry for the noise=2E

Fairly stock Fedora config, with a few tweaks=2E
http://david=2Ewoodhou=2Ese/arm-hibernate-config

I note kmalloc_trace() is in the backtrace=2E


