Return-Path: <kvm+bounces-39955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A5F2A4D26D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:17:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA8863ADD64
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 04:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56761EEA34;
	Tue,  4 Mar 2025 04:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="U/mE/iZQ"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazolkn19012050.outbound.protection.outlook.com [52.103.20.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BE337160;
	Tue,  4 Mar 2025 04:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741061849; cv=fail; b=QXgqHm9T02myJkCBUqFMOgqVp2Pg7WXyzWmptuS5oMm+0saDlA6Ab/uSK09kBRn3U8rVxXXtuTf4eTXEydYJYiZZbVHZ6EpIdKGmI8nDDRZO2xf68Z4+9+IHtryamfKEZx2lCATBJI4HRDtX9hG+/Ze7c/4tlOffa7xNl1NPdDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741061849; c=relaxed/simple;
	bh=NhTwR32+27i+8Vm+nq+/PBjyVge3rcNkRe/y6yOAK4I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SJUoaN7Iing9xE5LuSQIoqOQodIaoHAC8foj6SQVkYtunHACojBWqruXEz6E7TN/avtNq3a1k+sXPuDZ9qbZtiMnls+7uhOxfnjDMvFX+NrQzAmJRqCoDrjPIjgzuDdTBVpgEdhWrWdBDKdXhiitP1iRfID1TZ6kik3FYAKfhwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=U/mE/iZQ; arc=fail smtp.client-ip=52.103.20.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vYaxWVCncCXTII5UOkm0kIDzJXsgk6sYqPh57IoGMMxQgfv9xw6bKUXHw6MEkeytD1fgWTyE9G1sjfTpNBjfBD0JIjuy5xx1iRwN02efwPige9gEHCaipqG92plwS5AFz99GKD1/iVmmJwEACqd404Phck5OuLCrUFAMMVDs4UXfqAi2e4tN7K4Yxo1w2HrtvScrNYAEdCWyd8Kz2IpmF4uVtrEbGAIKsqzbK8AXE+KIL4bQnEfNTOXLVArpfwaZhFjAJinr8jXztvGaz3gCyY6zSJy7bopSnnHUGQFkyckZYDqB3BzG8fSdMIMXwKLiIhTYFbdhHpLioYEBmYjjrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqRClfs4rHwkXJCbcoLWbHt7kxv4Q2TM/yrd6z2vGVc=;
 b=W20FfDnYowjNaaBZtFAh9WRnMkvU1ONpc/3K6uf+kEzXDNlEtSHqFPX3Ls72geZjSL+CX51j+znlo037dDVZc3dqsDk+dQAGbuyTL/LJmYi/kjpz9keW9oDVEyNDhtIYQd8t0HacGdWzdTn5HF7FPGzugfjLU7G70KCpOgN25nQTC7BVlR2maarkV6OB1ty+rl8cyKhOx90mUis6FD13NRL4QadFmZnCD3H7vW238GYn2WqmEJqLHAtsKmvO7TeyiakiouFzr827DTlv29P0n4lGuJcgjlVm2woAwboAUPProG+QnVxuMOBqOEAPbKo2L0Kh381G9jlLkW6FRu7Diw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqRClfs4rHwkXJCbcoLWbHt7kxv4Q2TM/yrd6z2vGVc=;
 b=U/mE/iZQqz0TH3t4WsPwoxDDmJvB8CdO2SBWYPEU5xaPdLh6Rh+Ac6A7iEeUkW9N3tMrlLH4ikQVccxM91MDRAcf3irqrvAwAwqWasibtZwgxEUbZ8yrlDX92sq37KSkwERQMDlhjpi0jS227mz9YjLGIa82GMirH6sjtYK4zU0Fgsf8TgwCj/ni8JNvGZAi9JmNQzyMTo4UXOY+tmAGyPgH5+3zLO9KaWKdC957LY7H5PBfWFvSTkGCZoI1q55enphNVQKizOtzrm9glTjb4Hna+/iGOrMnFcHn11bEAYqfoXAJgEr9ScGrRuh2YxEr6ULyK10ZngUuNJ02cNkdSQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by PH8PR02MB10184.namprd02.prod.outlook.com (2603:10b6:510:224::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Tue, 4 Mar
 2025 04:17:22 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%3]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 04:17:22 +0000
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
Subject: RE: [PATCH v2 03/38] x86/tsc: Add helper to register CPU and TSC freq
 calibration routines
Thread-Topic: [PATCH v2 03/38] x86/tsc: Add helper to register CPU and TSC
 freq calibration routines
Thread-Index: AQHbiL80axP959hlHU2Wqtf1uuWY5rNiXsPw
Date: Tue, 4 Mar 2025 04:17:22 +0000
Message-ID:
 <SN6PR02MB41579F676A4F30B1421A0376D4C82@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20250227021855.3257188-1-seanjc@google.com>
 <20250227021855.3257188-4-seanjc@google.com>
In-Reply-To: <20250227021855.3257188-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|PH8PR02MB10184:EE_
x-ms-office365-filtering-correlation-id: 256c2bec-8b45-41fe-fc3a-08dd5ad37673
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799003|8060799006|15080799006|461199028|8062599003|41001999003|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?S0zfeu77VqqkIQL1LKS9qo9rbeB+e8P5djta9XwmrTXXp4h9igAMJmQ3A4sD?=
 =?us-ascii?Q?IRoMRLA5fMpPripeXv2vzoALKYDkmdJwKXDI7xClhvDOk9LEMVyvy40SFeC9?=
 =?us-ascii?Q?P9UMVnLW3j0psfUuGTzpCJzBUU8f5jR9CBlIwSlP8qw9KJslsUjLBLunjPag?=
 =?us-ascii?Q?3jsSFIYr8sRVi5e1sqozYk31m7I8DG+DpkHW5Jb8zh0kjYbQejfhlB2auS9H?=
 =?us-ascii?Q?9b00UyCkJxsoHCoCsFwiul5Rw3VvJb0i+AXTmAf0pvtnoNNgLZ6HUPpTgrGf?=
 =?us-ascii?Q?I2YDrl0ZNUdjwD9womHeT+6O+5VhLL66l4MtgRaiWs+1opg5YDVEIr8PNQ5O?=
 =?us-ascii?Q?uPrKflaxPlHKQDyAEVuX7/dIo9iQi/Q48zZHskeYdRL49rhSyi0yLuCnknG+?=
 =?us-ascii?Q?22Fr53r7vts74hdPIofrWfJNXanrkLAbrdiFo8XcKM/UakrA+ZPNXylOO3RE?=
 =?us-ascii?Q?uQEAJmaZBBw0bzw/XCVJ686n1gUGpKjwxpqKee/ppxbGtalbp1ggPJFDL1pu?=
 =?us-ascii?Q?TATNvIn4sV5+ioRPrXCmLd+V8BsdYrx88AS29G267diTYPqcxvPNd53Nv1Ik?=
 =?us-ascii?Q?yeHbxPaSh5s0dCERP//wsoYCeuJUmN653ADDDimllycFhMCer2GdxvNOsOnj?=
 =?us-ascii?Q?9xMfkyqz3p5Y5wwAOHbiZ0In3vsWiH5XbNbQhJTk7UU5fSp0AZQtapdv8FZY?=
 =?us-ascii?Q?BJjECOg8lXSbD3OlcbK8906g7MPjaH2HXWIJU1EiNO8FoxLDwot1WdGS3/me?=
 =?us-ascii?Q?vYjQ/Nv2m2BHZNJxXpT/l8KIdujHwjR67sJDmghqnK4zGvih3Wq9Rzt60NA/?=
 =?us-ascii?Q?A3OHv5fPB18iRhOw86r8RVQpxbgSBZuY+L5TpQZPvn9pa3wV2HtipQUW7yi1?=
 =?us-ascii?Q?5NcBs7Y4itOcNwySHh07nkhBhtBa0cu8QfpIV+I5Z7IpCkPPdXgm4Lnkezud?=
 =?us-ascii?Q?aUN+hz0BUsOFl/yhwa7/dXATJU714MLhBR0g3YL0VroQTJS5H4UyHwYVwOsg?=
 =?us-ascii?Q?Gjbf4FHlRS0ZSIhII66k+t0/PIPIWFRv2SUPsJWhfE6aP97eJqRKoB1kDwCO?=
 =?us-ascii?Q?ZfNLG2X/XpwGFjB0fCfsw296tV1Mew=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?MFm2fnpYv+YbSElqhHP7G7yII5hW41sxxZMPrZ4BZONQZz/xgwUHYuxk0s+5?=
 =?us-ascii?Q?ayKb9HNOoNGe/z0H7VSvdhOPpE+oiTC6I2ZGxvSTqZqBukrjmKLoPGp3t5wN?=
 =?us-ascii?Q?JqJRr791ylftKtAi/nlePVHC/njUyHizICjkGrrN+ojmg5LwLM6pD5A8a4XM?=
 =?us-ascii?Q?fmS+9pH9A01hr6sgIZ4G0i7w56Sfa6zNwL+N8eRQ9uk2rRN50lO+siX9chli?=
 =?us-ascii?Q?glKsKFP2o/rHuwYRoMd+R/k7O8AVlAcEOXlvizgbJD0IrgK1HKWRw4laZiPQ?=
 =?us-ascii?Q?fO9uxJRA/w6ofd3LbqydNpl7oHri8MG9X1GlFGtHXIFgIwttXx7pL8Abdr+t?=
 =?us-ascii?Q?NL9+QoOzg2CvJa+lX5x6J+SHOS+Bb3L//bVDHi9G0XJojqhXMN2QX4lLFRlj?=
 =?us-ascii?Q?QrURPQAu4P17R8rVdwrW+7K6T3xxxhPACR8d7lsr+hrQnJBSIK4A6x/ySz42?=
 =?us-ascii?Q?Qv3graqkcsgFswegQMAc+J80uiKLWl0tzKm6D5hK9uLcgFUVi1gUs7hqwsyV?=
 =?us-ascii?Q?2AOBw755sU+gEIjeTAQeTYg14r2S6fFFYNmN0fZyAX7dZTpzdrCBfuK+Lw5U?=
 =?us-ascii?Q?4vZ6a2ueU8J3EcB2Ketd933FztbLR3r5sN3GskOjELRy+LZf5hvkHcLElGAJ?=
 =?us-ascii?Q?sJTNfD8pdSLacvJ5ng9Pbbr0YjM1yp2m5Y8d46uUtUtXNuHh0DcfCQ5gC+81?=
 =?us-ascii?Q?raiZZ9QzTxqImoiykes3VXqc8UfEpkMsrt3cajus/Ec7HPrqWScfkEgqgzlM?=
 =?us-ascii?Q?0PxXhBPV+t9dWcktP4WZZFwr2+OmchNfI1o+bafpOKvzfXoACI89a5KRinWl?=
 =?us-ascii?Q?s7mYU0J54Qc7RyrsIJUQmL4ITParvZBQC90KIx0eciMzKTDRy0n+T8qVSxDB?=
 =?us-ascii?Q?UxgzLxlCJiUgzIw34dt+Iv6tNA/l1XNxJN66tXKkp+LGLZ4uu8FZ8KfnXJc8?=
 =?us-ascii?Q?F8qAylfq2Sd/PfS0kn2STIlsnrpaCV/z2o9RfGZWgjndd9efWAWozYGg3RIT?=
 =?us-ascii?Q?4yiGtfKfruNrWiyvRVwHmT4vIPsA30OZrnvjGZLAlcDIVlT7uiJI2vDJIwmw?=
 =?us-ascii?Q?RNsOyyg0DpVSwsaNvRf2kTqCtJ1VUnus82571Gz2GSB5Fn+l5SfMsivtumkd?=
 =?us-ascii?Q?eHCkR250o2po5ykHJ5LkKroRE+NXlRLzcnGNpjisdNjXL4o4qRXWJrVUNKP9?=
 =?us-ascii?Q?ptsCXjOVFNaPruULAFLBOzj9pnOX9mURYprEov3A6xORJqkDjd1CuvTW8Ks?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 256c2bec-8b45-41fe-fc3a-08dd5ad37673
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 04:17:22.8096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR02MB10184

From: Sean Christopherson <seanjc@google.com> Sent: Wednesday, February 26,=
 2025 6:18 PM
>=20
> Add a helper to register non-native, i.e. PV and CoCo, CPU and TSC
> frequency calibration routines.  This will allow consolidating handling
> of common TSC properties that are forced by hypervisor (PV routines),
> and will also allow adding sanity checks to guard against overriding a
> TSC calibration routine with a routine that is less robust/trusted.
>=20
> Make the CPU calibration routine optional, as Xen (very sanely) doesn't
> assume the CPU runs as the same frequency as the TSC.
>=20
> Wrap the helper in an #ifdef to document that the kernel overrides
> the native routines when running as a VM, and to guard against unwanted
> usage.  Add a TODO to call out that AMD_MEM_ENCRYPT is a mess and doesn't
> depend on HYPERVISOR_GUEST because it gates both guest and host code.
>=20
> No functional change intended.
>=20
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/coco/sev/core.c       |  4 ++--
>  arch/x86/include/asm/tsc.h     |  4 ++++
>  arch/x86/kernel/cpu/acrn.c     |  4 ++--
>  arch/x86/kernel/cpu/mshyperv.c |  3 +--
>  arch/x86/kernel/cpu/vmware.c   |  4 ++--
>  arch/x86/kernel/jailhouse.c    |  4 ++--
>  arch/x86/kernel/kvmclock.c     |  4 ++--
>  arch/x86/kernel/tsc.c          | 17 +++++++++++++++++
>  arch/x86/xen/time.c            |  2 +-
>  9 files changed, 33 insertions(+), 13 deletions(-)
>=20
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 82492efc5d94..684cef70edc1 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -3291,6 +3291,6 @@ void __init snp_secure_tsc_init(void)
>  	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
>  	snp_tsc_freq_khz =3D (unsigned long)(tsc_freq_mhz * 1000);
>=20
> -	x86_platform.calibrate_cpu =3D securetsc_get_tsc_khz;
> -	x86_platform.calibrate_tsc =3D securetsc_get_tsc_khz;
> +	tsc_register_calibration_routines(securetsc_get_tsc_khz,
> +					  securetsc_get_tsc_khz);
>  }
> diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
> index c3a14df46327..9318c74e8d13 100644
> --- a/arch/x86/include/asm/tsc.h
> +++ b/arch/x86/include/asm/tsc.h
> @@ -40,6 +40,10 @@ extern int cpuid_get_cpu_freq(unsigned int *cpu_khz);
>=20
>  extern void tsc_early_init(void);
>  extern void tsc_init(void);
> +#if defined(CONFIG_HYPERVISOR_GUEST) || defined(CONFIG_AMD_MEM_ENCRYPT)
> +extern void tsc_register_calibration_routines(unsigned long (*calibrate_=
tsc)(void),
> +					      unsigned long (*calibrate_cpu)(void));
> +#endif
>  extern void mark_tsc_unstable(char *reason);
>  extern int unsynchronized_tsc(void);
>  extern int check_tsc_unstable(void);
> diff --git a/arch/x86/kernel/cpu/acrn.c b/arch/x86/kernel/cpu/acrn.c
> index 2c5b51aad91a..c1506cb87d8c 100644
> --- a/arch/x86/kernel/cpu/acrn.c
> +++ b/arch/x86/kernel/cpu/acrn.c
> @@ -29,8 +29,8 @@ static void __init acrn_init_platform(void)
>  	/* Install system interrupt handler for ACRN hypervisor callback */
>  	sysvec_install(HYPERVISOR_CALLBACK_VECTOR, sysvec_acrn_hv_callback);
>=20
> -	x86_platform.calibrate_tsc =3D acrn_get_tsc_khz;
> -	x86_platform.calibrate_cpu =3D acrn_get_tsc_khz;
> +	tsc_register_calibration_routines(acrn_get_tsc_khz,
> +					  acrn_get_tsc_khz);
>  }
>=20
>  static bool acrn_x2apic_available(void)
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyper=
v.c
> index f285757618fc..aa60491bf738 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -478,8 +478,7 @@ static void __init ms_hyperv_init_platform(void)
>=20
>  	if (ms_hyperv.features & HV_ACCESS_FREQUENCY_MSRS &&
>  	    ms_hyperv.misc_features & HV_FEATURE_FREQUENCY_MSRS_AVAILABLE) {
> -		x86_platform.calibrate_tsc =3D hv_get_tsc_khz;
> -		x86_platform.calibrate_cpu =3D hv_get_tsc_khz;
> +		tsc_register_calibration_routines(hv_get_tsc_khz, hv_get_tsc_khz);
>  		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>  	}
>=20

For the Hyper-V guest code,

Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>


> diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> index 00189cdeb775..d6f079a75f05 100644
> --- a/arch/x86/kernel/cpu/vmware.c
> +++ b/arch/x86/kernel/cpu/vmware.c
> @@ -416,8 +416,8 @@ static void __init vmware_platform_setup(void)
>  		}
>=20
>  		vmware_tsc_khz =3D tsc_khz;
> -		x86_platform.calibrate_tsc =3D vmware_get_tsc_khz;
> -		x86_platform.calibrate_cpu =3D vmware_get_tsc_khz;
> +		tsc_register_calibration_routines(vmware_get_tsc_khz,
> +						  vmware_get_tsc_khz);
>=20
>  #ifdef CONFIG_X86_LOCAL_APIC
>  		/* Skip lapic calibration since we know the bus frequency. */
> diff --git a/arch/x86/kernel/jailhouse.c b/arch/x86/kernel/jailhouse.c
> index cd8ed1edbf9e..b0a053692161 100644
> --- a/arch/x86/kernel/jailhouse.c
> +++ b/arch/x86/kernel/jailhouse.c
> @@ -209,8 +209,6 @@ static void __init jailhouse_init_platform(void)
>  	x86_init.mpparse.parse_smp_cfg		=3D jailhouse_parse_smp_config;
>  	x86_init.pci.arch_init			=3D jailhouse_pci_arch_init;
>=20
> -	x86_platform.calibrate_cpu		=3D jailhouse_get_tsc;
> -	x86_platform.calibrate_tsc		=3D jailhouse_get_tsc;
>  	x86_platform.get_wallclock		=3D jailhouse_get_wallclock;
>  	x86_platform.legacy.rtc			=3D 0;
>  	x86_platform.legacy.warm_reset		=3D 0;
> @@ -220,6 +218,8 @@ static void __init jailhouse_init_platform(void)
>=20
>  	machine_ops.emergency_restart		=3D jailhouse_no_restart;
>=20
> +	tsc_register_calibration_routines(jailhouse_get_tsc, jailhouse_get_tsc)=
;
> +
>  	while (pa_data) {
>  		mapping =3D early_memremap(pa_data, sizeof(header));
>  		memcpy(&header, mapping, sizeof(header));
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 5b2c15214a6b..b898b95a7d50 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -320,8 +320,8 @@ void __init kvmclock_init(void)
>  	flags =3D pvclock_read_flags(&hv_clock_boot[0].pvti);
>  	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
>=20
> -	x86_platform.calibrate_tsc =3D kvm_get_tsc_khz;
> -	x86_platform.calibrate_cpu =3D kvm_get_tsc_khz;
> +	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_tsc_khz);
> +
>  	x86_platform.get_wallclock =3D kvm_get_wallclock;
>  	x86_platform.set_wallclock =3D kvm_set_wallclock;
>  #ifdef CONFIG_X86_LOCAL_APIC
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index bb4619148161..d65e85929d3e 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -1294,6 +1294,23 @@ static void __init check_system_tsc_reliable(void)
>  		tsc_disable_clocksource_watchdog();
>  }
>=20
> +/*
> + * TODO: Disentangle AMD_MEM_ENCRYPT and make SEV guest support depend o=
n
> + *	 HYPERVISOR_GUEST.
> + */
> +#if defined(CONFIG_HYPERVISOR_GUEST) || defined(CONFIG_AMD_MEM_ENCRYPT)
> +void tsc_register_calibration_routines(unsigned long (*calibrate_tsc)(vo=
id),
> +				       unsigned long (*calibrate_cpu)(void))
> +{
> +	if (WARN_ON_ONCE(!calibrate_tsc))
> +		return;
> +
> +	x86_platform.calibrate_tsc =3D calibrate_tsc;
> +	if (calibrate_cpu)
> +		x86_platform.calibrate_cpu =3D calibrate_cpu;
> +}
> +#endif
> +
>  /*
>   * Make an educated guess if the TSC is trustworthy and synchronized
>   * over all CPUs.
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 96521b1874ac..9e2e900dc0c7 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -566,7 +566,7 @@ static void __init xen_init_time_common(void)
>  	static_call_update(pv_steal_clock, xen_steal_clock);
>  	paravirt_set_sched_clock(xen_sched_clock);
>=20
> -	x86_platform.calibrate_tsc =3D xen_tsc_khz;
> +	tsc_register_calibration_routines(xen_tsc_khz, NULL);
>  	x86_platform.get_wallclock =3D xen_get_wallclock;
>  }
>=20
> --
> 2.48.1.711.g2feabab25a-goog
>=20


