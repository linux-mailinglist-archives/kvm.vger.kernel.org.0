Return-Path: <kvm+bounces-45986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06D75AB049A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 22:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C0869E3413
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 20:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0242628C02E;
	Thu,  8 May 2025 20:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="KptbE85o"
X-Original-To: kvm@vger.kernel.org
Received: from terminus.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F4A1E1E1D;
	Thu,  8 May 2025 20:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746736057; cv=none; b=Zfd4xuawLLQr/trrACYbUSOHWtu+EsRRgQDFOOYCECUQxzIlcCY5IyBouvVp/lJCBskZM8gdR/Z9PplUeSSN6vnHNHPEiKdoeZZI/yYLsowRxYsDLQeu3MiEOTO5JuidiXfbByFX67EYpV1ioppJvzQTdprkOJiczj41LjOL/vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746736057; c=relaxed/simple;
	bh=Xft22+cWZ2gtYua59jdnOFdwhCdFN+oButPRI8uZPUs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=fkbYTkFpIP31NB/A/+VHDIrkcYmBD1fs80hHQs3wtULB1DuWpuq02CYgswX3M0vpzZIiYytiuh14FUka6EuDqV3XxvuQuBtkOVObVntaEHQ32xyKiFS0AQd+w3f44cFsZnWzW0pMrv5QOwE9XMIGkyU8VV28kS3oTWp6za03X/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=KptbE85o; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 548KN6bY2104994
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 8 May 2025 13:23:06 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 548KN6bY2104994
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1746735788;
	bh=+NDA9AH+UV+1Djye1mB+qrw8jYKjbpRJSZagnaRFOyg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=KptbE85oTPsvevZzt5/TglVYhLw7U9YJ8OrPuHzmc1aO9ddCs7dvwUPH6RZFy0fWv
	 bXcQFoEWU13PbUtqo7Er7VbdK0SryqgSp7UoewJsHh7UqntiAp5FX+b9dL2C8meu7F
	 AnDrJkcF2f2aoSONbvSWJv7db/YnHTUwglxIUZ6vNI61IHdmDlmry0gcSdyp0hicL2
	 jsWvA6PzUYI6oOdfNWgCX9n5q3qYb5MkTM1sNGbAhsh2o1cdPEyX7LWSFiamKOZqzc
	 XqSrQmcGDRPPd1SY6R+85COcvEK/9Rx6myWBbtEmOOQg5/p+ppXG8lzeFmAQI2TGu5
	 5JIOQS+cN4YLQ==
Date: Thu, 08 May 2025 13:23:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Peter Zijlstra <peterz@infradead.org>, Sohil Mehta <sohil.mehta@intel.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jacob Pan <jacob.pan@linux.microsoft.com>,
        Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
        Nikolay Borisov <nik.borisov@suse.com>,
        linux-perf-users@vger.kernel.org, linux-edac@vger.kernel.org,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5_5/9=5D_x86/nmi=3A_Add_support?=
 =?US-ASCII?Q?_to_handle_NMIs_with_source_information?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20250508121544.GH4439@noisy.programming.kicks-ass.net>
References: <20250507012145.2998143-1-sohil.mehta@intel.com> <20250507012145.2998143-6-sohil.mehta@intel.com> <20250507091442.GB4439@noisy.programming.kicks-ass.net> <55527575-e3b8-4cf6-b09c-b81437e0c892@intel.com> <20250508121544.GH4439@noisy.programming.kicks-ass.net>
Message-ID: <D368D488-6D4E-4590-8E98-A7D7CD5E7F20@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On May 8, 2025 5:15:44 AM PDT, Peter Zijlstra <peterz@infradead=2Eorg> wrot=
e:
>On Wed, May 07, 2025 at 02:48:34PM -0700, Sohil Mehta wrote:
>> On 5/7/2025 2:14 AM, Peter Zijlstra wrote:
>> > On Tue, May 06, 2025 at 06:21:41PM -0700, Sohil Mehta wrote:
>> >>
>> >> diff --git a/arch/x86/kernel/nmi=2Ec b/arch/x86/kernel/nmi=2Ec
>> >> index a1d672dcb6f0=2E=2E183e3e717326 100644
>> >> --- a/arch/x86/kernel/nmi=2Ec
>> >> +++ b/arch/x86/kernel/nmi=2Ec
>> >=20
>> >>  static int nmi_handle(unsigned int type, struct pt_regs *regs)
>> >>  {
>> >>  	struct nmi_desc *desc =3D nmi_to_desc(type);
>> >> +	unsigned long source_bitmap =3D 0;
>> >=20
>> > 	unsigned long source =3D ~0UL;
>> >=20
>>=20
>> Thanks! This makes the logic even simpler by getting rid of
>> match_nmi_source()=2E A minor change described further down=2E
>>=20
>> Also, do you prefer "source" over "source_bitmap"? I had it as such to
>> avoid confusion between source_vector and source_bitmap=2E
>
>Yeah, I was lazy typing=2E Perhaps just call it bitmap then?
>
>> >>  	nmi_handler_t ehandler;
>> >>  	struct nmiaction *a;
>> >>  	int handled=3D0;
>> >> @@ -148,16 +164,40 @@ static int nmi_handle(unsigned int type, struc=
t pt_regs *regs)
>> >> =20
>> >>  	rcu_read_lock();
>> >> =20
>> >> +	/*
>> >> +	 * Activate NMI source-based filtering only for Local NMIs=2E
>> >> +	 *
>> >> +	 * Platform NMI types (such as SERR and IOCHK) have only one
>> >> +	 * handler registered per type, so there is no need to
>> >> +	 * disambiguate between multiple handlers=2E
>> >> +	 *
>> >> +	 * Also, if a platform source ends up setting bit 2 in the
>> >> +	 * source bitmap, the local NMI handlers would be skipped since
>> >> +	 * none of them use this reserved vector=2E
>> >> +	 *
>> >> +	 * For Unknown NMIs, avoid using the source bitmap to ensure all
>> >> +	 * potential handlers have a chance to claim responsibility=2E
>> >> +	 */
>> >> +	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type =3D=3D NMI=
_LOCAL)
>> >> +		source_bitmap =3D fred_event_data(regs);
>> >=20
>> > 	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type =3D=3D NMI_L=
OCAL) {
>> > 		source =3D fred_event_data(regs);
>> > 		if (source & BIT(0))
>> > 			source =3D ~0UL;
>> > 	}
>> >=20
>>=20
>> Looks good, except when fred_event_data() returns 0=2E I don't expect i=
t
>> to happen in practice=2E But, maybe with new hardware and eventually
>> different hypervisors being involved, it is a possibility=2E
>>=20
>> We can either call it a bug that an NMI happened without source
>> information=2E Or be extra nice and do this:
>>=20
>> if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type =3D=3D NMI_LOCA=
L) {
>> 	source =3D fred_event_data(regs);
>> 	if (!source || (source & BIT(0)))
>> 		source =3D ~0UL;
>> }
>
>Perhaps also WARN about the !source case?

A 0 should be interpreted such that NMI source is not available, e=2Eg=2E =
due to a broken hypervisor or similar=2E

