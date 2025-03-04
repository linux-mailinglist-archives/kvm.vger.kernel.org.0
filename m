Return-Path: <kvm+bounces-39959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14941A4D281
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:19:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8BDC3AE111
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 04:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F661F417C;
	Tue,  4 Mar 2025 04:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="LdBnSerG"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazolkn19010008.outbound.protection.outlook.com [52.103.11.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185471F1506;
	Tue,  4 Mar 2025 04:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.11.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741061888; cv=fail; b=WXWubeKZhhgvasZdNpbWKfOhi0/C4V8cUnkNDb61QL2BHI/RDg4DJVqp6BnNlq5kTVF6zcQJqZ8w9c5Deert3A0NQsST/slXy4cf/RMsbodW00gjO+pezkNlon6JiMHomZzcyQJ5jgVZRskiGEzXauHn30E3Nu+vwUlsKWPFnOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741061888; c=relaxed/simple;
	bh=IkkmSezgeILSPBcM54KK1wnSLQHc3oI+QFbJZiVoQF0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CU/UFI3WsgfIS6HewRRMDqEhNX78L2LXxUGsHG5mDz0h3qRGkO+JpcS679y0z+Lro+Y8Sx704RjpME5y72K8xQ9hdojgWFb8mROjtacPoTO4qz3U8Gryxy3jWf2L+bmfc+PPxjT2GH1Fhronr1zl8qP6MfGISSMGpK9cQK08NJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=LdBnSerG; arc=fail smtp.client-ip=52.103.11.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=orVnHf5358RlPzpciPc248b9H0WkSTeB3BEkOneHB0/pxy3AuNfEPIuA523jIMn2dUARW2UbQFAtzuQN135sGhxYgVMa2mRYAGBa217xxCPIFFbJ6R+SacH0tVAmPgOKka1I7+hcypIza/VznLjB+ojcLoCUSopdv++JrmEz+JK8ZZ16g8ZcZL8oddVBXpM+Hp/+noH67NOfBaqE/dUhha7k0DJYakp9XKTqyT5O3M6sARYwLM7t/Tk0CwFUPo/VdKVv8MNS5IUXF/xGExAM1FmsWcmzFSlzxLZ9yLkj3FRLLjUY6Xh0fm+BHYh3lfY9znb0ERniHR1K6sxkKr4uVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzEySjbbc6HrK6FD5TMJLnk9DO7HVtEDsRMFDyTDn50=;
 b=u15diXRI/9xytJKOxhb82TsfGXofaVPRBTTU46dXkb+im5pw+A7Foikt+j8jmp3Z8ehhxSKCLhSX+w0CT1aE2kQWkmcuVK77uuSc5ZtF/NtVo7BYPppI03DYthuEVNuteP3CNni7YqNZYW4xHbhzPSFIXD0UgZuAd5xenPm+xWTjY+VkJ0IuE384VgvKXfr8V+G41YVob7FoSch30y8umsvPvvggjDI/bOsR3GyYgSEUTjvntK932tBcel2ycKHErinkQw7Z6f4es5bAnHzkrDt/Rot0MmpxwIKphOSrqY29vppkyErmwBtKokfziqahKU8c+rwiRVgAaLDeTZAvUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzEySjbbc6HrK6FD5TMJLnk9DO7HVtEDsRMFDyTDn50=;
 b=LdBnSerGOEIofsQi5ZalLjBKi0g1NV9utelD1zrZU17IkQ5YPIc8A3eGmtl6/XLP6SUAqOdUEwB69LKR+MSfw11TeHEeKiOamq+D/oW2TtozaZCP+ZZjh6FKJSM5TCXj3UdzVCjVmFluoxZA9+hBziektD1ZqHqviC5FH82l2zwOYoSmqSNDIrCGndOHfLIN+DMkL4m0aiBRw+oKqGqJkc93TjSXxXOcNKy9iop7GvIFEokeJXs+Qx1cfKLVFiP/ntVJ8WZ5GQKDaZ8ee6mO8q/bd+3zrIGbjmkDx94SacyQnL+Z/8fEKj4wTb9QHjCTUVASb3+kUPRrhhNFZ0Qjng==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by PH8PR02MB10184.namprd02.prod.outlook.com (2603:10b6:510:224::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Tue, 4 Mar
 2025 04:18:02 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%3]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 04:18:02 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Juergen Gross <jgross@suse.com>, "K. Y.
 Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei
 Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Ajay Kaher
	<ajay.kaher@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Daniel
 Lezcano <daniel.lezcano@linaro.org>, John Stultz <jstultz@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: RE: [PATCH v2 31/38] x86/tsc: Pass KNOWN_FREQ and RELIABLE as params
 to registration
Thread-Topic: [PATCH v2 31/38] x86/tsc: Pass KNOWN_FREQ and RELIABLE as params
 to registration
Thread-Index: AQHbiL/SUCd7zgLAtUGlvGS/sV/Q7LNiY70g
Date: Tue, 4 Mar 2025 04:18:02 +0000
Message-ID:
 <SN6PR02MB4157CBC183775A8C17AC590BD4C82@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20250227021855.3257188-1-seanjc@google.com>
 <20250227021855.3257188-32-seanjc@google.com>
In-Reply-To: <20250227021855.3257188-32-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|PH8PR02MB10184:EE_
x-ms-office365-filtering-correlation-id: 3e7219cf-5274-41d6-6e0c-08dd5ad38e06
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799003|8060799006|15080799006|461199028|8062599003|41001999003|12091999003|19061999003|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?IOdnMuGdXWduI0tAKQdceZLZVWr+sgMp6SFApUZhwYYIBNLL3D+COyOcRyL+?=
 =?us-ascii?Q?obmgaXsF4INm4wdD/k0o+JEnuLOYWMzN3i2sDvrjGH+IAEY9+e0/CoQNMtgW?=
 =?us-ascii?Q?hGkomfxS05uCMShiIA7lTUjgIeMvToEGVcdoNTfd0bXxs0tqmx0ytUiz3GW2?=
 =?us-ascii?Q?AWZgjg/y5NopYkWd8cIph+5AlI4oSNPRFG3WANj/yE4pSw+R8EMhYWitaf6D?=
 =?us-ascii?Q?/mncv87szT4BE1dvh4zqaeO2SQriZrlYJ+f9/WVU9+HVn1aaQ9LBQvvhA7E8?=
 =?us-ascii?Q?8FZqK05CrExpwo4F+kbKIfKySnX/UY0URbC9iJjpvcnkbFPbIqyur5mGopKn?=
 =?us-ascii?Q?937+bXn9posbQh6e/7vUWB+igToCXLWBgDejYoRgrTc0SnpCLkgyRRlEkxZ7?=
 =?us-ascii?Q?JU5CUYZ2SE+rFmXdsEUvT2n9/TT2UNEnu+5amKeaeb6VFqTyt4PLrWld4mlw?=
 =?us-ascii?Q?66JMAxzf2U2lFD7UZIKpdGMIVFOF3CCRPxd9Gmq42gdbwRijailo8F5wXfzH?=
 =?us-ascii?Q?5u2jU/Wx0Mt+x/S/Z+zhD7wVI4FVuHCERhL7SXYNBmJ1wp3XaGOncaXNbyDV?=
 =?us-ascii?Q?uD69HcRfku6DzAerY2kvKFUCTv4/9bF+Hd8+nmMs1BQeKRBMSR4CpjEzDP0i?=
 =?us-ascii?Q?Ks4kqRzrDvGK4uK2dmikncHWKLRayqzvRtfKBrJ2c42P61I/K1DK5DU1yFIL?=
 =?us-ascii?Q?XJGHtiOnXuxvm5CyXrXRvkAj1Ek2Jh5/G7ftjD8b2GiLK7IRUHjYjvXn2jbd?=
 =?us-ascii?Q?Pd41kZqZBix5gLry9tUrpZBeFlPNMnOIlKWGR8t/J3seL20epooVHnphJnK+?=
 =?us-ascii?Q?ANJEo75xljvmv41yM4AVUkMtjCNJqpzo3BEgybp4mawmQCWgZ79AgwSdhAQC?=
 =?us-ascii?Q?c5SEJM45vYBdrz2HQ/oHZUmqpsA4eVPjUBOKVBr9jAHRf9hGHzqvjKm32mwk?=
 =?us-ascii?Q?tiXSHsRNSczkUZy0T7ClIxi/VgGEe74CSqWzBRVLdjsaCabZMQqhI35OyJ5z?=
 =?us-ascii?Q?qJ4Lwgzy5H/EIJOXzlgzjen0yeX7fY84kHdNuF1HSQLp/529p/q8KbBp9gld?=
 =?us-ascii?Q?EynBE9FiU96zxRw37/NLCr+nYhfGReUcnOKFKGrrhPzTfYUN96jHaoViQXg3?=
 =?us-ascii?Q?CLUQBAr+0crLOyEUvD/5c3Lt40jfaqYOrQ=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zPrKRhgt1MKbwuiKcsdppWeBkUR/b76XxVLIeALE6pSVq58uE4HbRBsTjAWP?=
 =?us-ascii?Q?3+hsu86ZFOAZmtK5wIbXh7mJmVtm4srt0Y1vmuMd5NXEMEauBrER2YJFebf2?=
 =?us-ascii?Q?PxPox0wzHJCtmr3fQribryXkmrW32w93Daq61YQ1On04U+xp7GmoUrz1Yy4d?=
 =?us-ascii?Q?2MZsVvGXmkSo6C1uxs/V/C51BrnOYaIWNpcUZUFH4j9Xk4ljypVN5UEYp9GN?=
 =?us-ascii?Q?KLxVVzRm+JwVCSburM/1ZTAjmrsHyss17ZZYrVX+vycfEElB4z6RtD8UwFQU?=
 =?us-ascii?Q?11nh7vo/LnMiNmziv29U1Nchz6dyLkkuqxkOrZMmYllqkFQTWfqUKuzNr9Gv?=
 =?us-ascii?Q?0hmMurKAoo04re9hyiQ9Yy8e2UxntXH9DM0ihIKRgGPhZRnQO3zDECGlSKla?=
 =?us-ascii?Q?oiPgUXsV5f5UoM3syZKyTEojldwvmGArwtmyqCiOD4Am1dWtTe7Qm2MyGVl3?=
 =?us-ascii?Q?qQtBJ3k6/wVdVlpNlLTY3OvXaeXD2q8NFwC59UcbDcGB+9jokjqjyyzvKB5b?=
 =?us-ascii?Q?47dgdrHQxquIONA1p/4hUJ+A1xXAyzbAXq38GB+irQ4QljKBhDuyryC2281J?=
 =?us-ascii?Q?EdLGHiSjKnoorokjWNHXhfgqA2kbS5B5mKQCCsi+nCo+2wJpo88bvxHvi+zH?=
 =?us-ascii?Q?GyPG2nWxqBBQ2/Mb3TZBh+lVrcetJy/DDCB8piHVzyalhPCC+Y0E7iRICJsR?=
 =?us-ascii?Q?oNM1WAmfMx4u/sh/Hl/s3ql88tOfw9kn1Z2ttx9fhpW7HYCD+Jw356YmWP9F?=
 =?us-ascii?Q?bhVzcUpOphE+C09XOcABoEqLoL8yDdh4Y0gHo1y/6zpJGJHZtlUDxO+g9cSY?=
 =?us-ascii?Q?12aChDvOHVWEBShzqMaRClcaviiQ1NHXVW1Fp5Q1ux1hgg6rCQHtgsmZAUjQ?=
 =?us-ascii?Q?rQPui8KamL9EB/WPX1LQRT+KEKINp3yPrpNPsQR2c7hofip23BfUcsDgPNaY?=
 =?us-ascii?Q?u+bpKhK5bsYtMhG5IhvXOeQj0mfySwiF0Faz0F6Mmb8dvlUaFAiSM76gqGS/?=
 =?us-ascii?Q?A/IufiOLyM01Sr2/R/TUnfWW0fgNzn5/LLYEDDX0PWgbHl9F4FmRHnK6GX0W?=
 =?us-ascii?Q?CHflUSYO5Wz8qi/4+T95eiG9MPjenE0awDkn7GlN8saqWqaeMJMRjb6dlCKi?=
 =?us-ascii?Q?CnalEIKl06jEE9xvzn30ozgkQ9Zee1GJTkCblTfO7Ng9pTVkSuVx64iU0huk?=
 =?us-ascii?Q?JJx0olGMiUZrHMnu+i39cQPzyHhSr1Vrp/547dL50GeDDQ6lKmm4KJLAjGk?=
 =?us-ascii?Q?=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e7219cf-5274-41d6-6e0c-08dd5ad38e06
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 04:18:02.3789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR02MB10184

From: Sean Christopherson <seanjc@google.com> Sent: Wednesday, February 26,=
 2025 6:19 PM
>=20
> Add a "tsc_properties" set of flags and use it to annotate whether the
> TSC operates at a known and/or reliable frequency when registering a
> paravirtual TSC calibration routine.  Currently, each PV flow manually
> sets the associated feature flags, but often in haphazard fashion that
> makes it difficult for unfamiliar readers to see the properties of the
> TSC when running under a particular hypervisor.
>=20
> The other, bigger issue with manually setting the feature flags is that
> it decouples the flags from the calibration routine.  E.g. in theory, PV
> code could mark the TSC as having a known frequency, but then have its
> PV calibration discarded in favor of a method that doesn't use that known
> frequency.  Passing the TSC properties along with the calibration routine
> will allow adding sanity checks to guard against replacing a "better"
> calibration routine with a "worse" routine.
>=20
> As a bonus, the flags also give developers working on new PV code a heads
> up that they should at least mark the TSC as having a known frequency.
>=20
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/coco/sev/core.c       |  6 ++----
>  arch/x86/coco/tdx/tdx.c        |  7 ++-----
>  arch/x86/include/asm/tsc.h     |  8 +++++++-
>  arch/x86/kernel/cpu/acrn.c     |  4 ++--
>  arch/x86/kernel/cpu/mshyperv.c | 10 +++++++---
>  arch/x86/kernel/cpu/vmware.c   |  7 ++++---
>  arch/x86/kernel/jailhouse.c    |  4 ++--
>  arch/x86/kernel/kvmclock.c     |  4 ++--
>  arch/x86/kernel/tsc.c          |  8 +++++++-
>  arch/x86/xen/time.c            |  4 ++--
>  10 files changed, 37 insertions(+), 25 deletions(-)
>=20
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index dab386f782ce..29dd50552715 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -3284,12 +3284,10 @@ void __init snp_secure_tsc_init(void)
>  {
>  	unsigned long long tsc_freq_mhz;
>=20
> -	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> -	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
> -
>  	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
>  	snp_tsc_freq_khz =3D (unsigned long)(tsc_freq_mhz * 1000);
>=20
>  	tsc_register_calibration_routines(securetsc_get_tsc_khz,
> -					  securetsc_get_tsc_khz);
> +					  securetsc_get_tsc_khz,
> +					  TSC_FREQ_KNOWN_AND_RELIABLE);
>  }
> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> index 42cdaa98dc5e..ca31560d0dd3 100644
> --- a/arch/x86/coco/tdx/tdx.c
> +++ b/arch/x86/coco/tdx/tdx.c
> @@ -1135,14 +1135,11 @@ static unsigned long tdx_get_tsc_khz(void)
>=20
>  void __init tdx_tsc_init(void)
>  {
> -	/* TSC is the only reliable clock in TDX guest */
> -	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
> -	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> -
>  	/*
>  	 * Override the PV calibration routines (if set) with more trustworthy
>  	 * CPUID-based calibration.  The TDX module emulates CPUID, whereas any
>  	 * PV information is provided by the hypervisor.
>  	 */
> -	tsc_register_calibration_routines(tdx_get_tsc_khz, NULL);
> +	tsc_register_calibration_routines(tdx_get_tsc_khz, NULL,
> +					  TSC_FREQ_KNOWN_AND_RELIABLE);
>  }
> diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
> index 9318c74e8d13..360f47610258 100644
> --- a/arch/x86/include/asm/tsc.h
> +++ b/arch/x86/include/asm/tsc.h
> @@ -41,8 +41,14 @@ extern int cpuid_get_cpu_freq(unsigned int *cpu_khz);
>  extern void tsc_early_init(void);
>  extern void tsc_init(void);
>  #if defined(CONFIG_HYPERVISOR_GUEST) || defined(CONFIG_AMD_MEM_ENCRYPT)
> +enum tsc_properties {
> +	TSC_FREQUENCY_KNOWN	=3D BIT(0),
> +	TSC_RELIABLE		=3D BIT(1),
> +	TSC_FREQ_KNOWN_AND_RELIABLE =3D TSC_FREQUENCY_KNOWN | TSC_RELIABLE,
> +};
>  extern void tsc_register_calibration_routines(unsigned long (*calibrate_=
tsc)(void),
> -					      unsigned long (*calibrate_cpu)(void));
> +					      unsigned long (*calibrate_cpu)(void),
> +					      enum tsc_properties properties);
>  #endif
>  extern void mark_tsc_unstable(char *reason);
>  extern int unsynchronized_tsc(void);
> diff --git a/arch/x86/kernel/cpu/acrn.c b/arch/x86/kernel/cpu/acrn.c
> index 2da3de4d470e..4f2f4f7ec334 100644
> --- a/arch/x86/kernel/cpu/acrn.c
> +++ b/arch/x86/kernel/cpu/acrn.c
> @@ -29,9 +29,9 @@ static void __init acrn_init_platform(void)
>  	/* Install system interrupt handler for ACRN hypervisor callback */
>  	sysvec_install(HYPERVISOR_CALLBACK_VECTOR, sysvec_acrn_hv_callback);
>=20
> -	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>  	tsc_register_calibration_routines(acrn_get_tsc_khz,
> -					  acrn_get_tsc_khz);
> +					  acrn_get_tsc_khz,
> +					  TSC_FREQUENCY_KNOWN);
>  }
>=20
>  static bool acrn_x2apic_available(void)
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyper=
v.c
> index 174f6a71c899..445ac3adfebc 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -421,8 +421,13 @@ static void __init ms_hyperv_init_platform(void)
>=20
>  	if (ms_hyperv.features & HV_ACCESS_FREQUENCY_MSRS &&
>  	    ms_hyperv.misc_features & HV_FEATURE_FREQUENCY_MSRS_AVAILABLE) {
> -		tsc_register_calibration_routines(hv_get_tsc_khz, hv_get_tsc_khz);
> -		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> +		enum tsc_properties tsc_properties =3D TSC_FREQUENCY_KNOWN;
> +
> +		if (ms_hyperv.features & HV_ACCESS_TSC_INVARIANT)
> +			tsc_properties =3D TSC_FREQ_KNOWN_AND_RELIABLE;
> +
> +		tsc_register_calibration_routines(hv_get_tsc_khz, hv_get_tsc_khz,
> +						  tsc_properties);
>  	}

For the Hyper-V guest code,

Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>

>=20
>  	if (ms_hyperv.priv_high & HV_ISOLATION) {
> @@ -525,7 +530,6 @@ static void __init ms_hyperv_init_platform(void)
>  		 * is called.
>  		 */
>  		wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL,
> HV_EXPOSE_INVARIANT_TSC);
> -		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
>  	}
>=20
>  	/*
> diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> index 399cf3286a60..a3a71309214c 100644
> --- a/arch/x86/kernel/cpu/vmware.c
> +++ b/arch/x86/kernel/cpu/vmware.c
> @@ -385,10 +385,10 @@ static void __init vmware_paravirt_ops_setup(void)
>   */
>  static void __init vmware_set_capabilities(void)
>  {
> +	/* TSC is non-stop and reliable even if the frequency isn't known. */
>  	setup_force_cpu_cap(X86_FEATURE_CONSTANT_TSC);
>  	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
> -	if (vmware_tsc_khz)
> -		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> +
>  	if (vmware_hypercall_mode =3D=3D CPUID_VMWARE_FEATURES_ECX_VMCALL)
>  		setup_force_cpu_cap(X86_FEATURE_VMCALL);
>  	else if (vmware_hypercall_mode =3D=3D CPUID_VMWARE_FEATURES_ECX_VMMCALL=
)
> @@ -417,7 +417,8 @@ static void __init vmware_platform_setup(void)
>=20
>  		vmware_tsc_khz =3D tsc_khz;
>  		tsc_register_calibration_routines(vmware_get_tsc_khz,
> -						  vmware_get_tsc_khz);
> +						  vmware_get_tsc_khz,
> +						  TSC_FREQ_KNOWN_AND_RELIABLE);
>=20
>  #ifdef CONFIG_X86_LOCAL_APIC
>  		/* Skip lapic calibration since we know the bus frequency. */
> diff --git a/arch/x86/kernel/jailhouse.c b/arch/x86/kernel/jailhouse.c
> index b0a053692161..d73a4d0fb118 100644
> --- a/arch/x86/kernel/jailhouse.c
> +++ b/arch/x86/kernel/jailhouse.c
> @@ -218,7 +218,8 @@ static void __init jailhouse_init_platform(void)
>=20
>  	machine_ops.emergency_restart		=3D jailhouse_no_restart;
>=20
> -	tsc_register_calibration_routines(jailhouse_get_tsc, jailhouse_get_tsc)=
;
> +	tsc_register_calibration_routines(jailhouse_get_tsc, jailhouse_get_tsc,
> +					  TSC_FREQUENCY_KNOWN);
>=20
>  	while (pa_data) {
>  		mapping =3D early_memremap(pa_data, sizeof(header));
> @@ -256,7 +257,6 @@ static void __init jailhouse_init_platform(void)
>  	pr_debug("Jailhouse: PM-Timer IO Port: %#x\n", pmtmr_ioport);
>=20
>  	precalibrated_tsc_khz =3D setup_data.v1.tsc_khz;
> -	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>=20
>  	pci_probe =3D 0;
>=20
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 1dbe12ecb26e..ce676e735ced 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -199,7 +199,6 @@ void kvmclock_cpu_action(enum kvm_guest_cpu_action ac=
tion)
>   */
>  static unsigned long kvm_get_tsc_khz(void)
>  {
> -	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>  	return pvclock_tsc_khz(this_cpu_pvti());
>  }
>=20
> @@ -403,7 +402,8 @@ void __init kvmclock_init(void)
>=20
>  	kvm_sched_clock_init(stable);
>=20
> -	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_tsc_khz);
> +	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_tsc_khz,
> +					  TSC_FREQUENCY_KNOWN);
>=20
>  	x86_platform.get_wallclock =3D kvm_get_wallclock;
>  	x86_platform.set_wallclock =3D kvm_set_wallclock;
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 5501d76243c8..be58df4fef66 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -1301,11 +1301,17 @@ static void __init check_system_tsc_reliable(void=
)
>   */
>  #if defined(CONFIG_HYPERVISOR_GUEST) || defined(CONFIG_AMD_MEM_ENCRYPT)
>  void tsc_register_calibration_routines(unsigned long (*calibrate_tsc)(vo=
id),
> -				       unsigned long (*calibrate_cpu)(void))
> +				       unsigned long (*calibrate_cpu)(void),
> +				       enum tsc_properties properties)
>  {
>  	if (WARN_ON_ONCE(!calibrate_tsc))
>  		return;
>=20
> +	if (properties & TSC_FREQUENCY_KNOWN)
> +		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> +	if (properties & TSC_RELIABLE)
> +		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
> +
>  	x86_platform.calibrate_tsc =3D calibrate_tsc;
>  	if (calibrate_cpu)
>  		x86_platform.calibrate_cpu =3D calibrate_cpu;
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 13e5888c4501..4de06ea55397 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -40,7 +40,6 @@ static unsigned long xen_tsc_khz(void)
>  	struct pvclock_vcpu_time_info *info =3D
>  		&HYPERVISOR_shared_info->vcpu_info[0].time;
>=20
> -	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>  	return pvclock_tsc_khz(info);
>  }
>=20
> @@ -571,7 +570,8 @@ static void __init xen_init_time_common(void)
>  	 */
>  	paravirt_set_sched_clock(xen_sched_clock, NULL, NULL);
>=20
> -	tsc_register_calibration_routines(xen_tsc_khz, NULL);
> +	tsc_register_calibration_routines(xen_tsc_khz, NULL,
> +					  TSC_FREQUENCY_KNOWN);
>  	x86_platform.get_wallclock =3D xen_get_wallclock;
>  }
>=20
> --
> 2.48.1.711.g2feabab25a-goog
>=20


