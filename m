Return-Path: <kvm+bounces-37657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECD1AA2D7F5
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 19:03:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED3953A7C6B
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 18:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E421F3B8E;
	Sat,  8 Feb 2025 18:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="VgyUGNLy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12olkn2087.outbound.protection.outlook.com [40.92.21.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A725241107;
	Sat,  8 Feb 2025 18:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.21.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739037819; cv=fail; b=CjtikJpy5dHHcE/ociBNQhxSshkqLHO1VxueNL76NXtqYC8x/qZ+RMdCIyoBesPMbUhNyTGgyj0zYBEOyz7e6o8aKz3Qlrq57QhXH+at4tL1Mr0t54xEGjypob5DOcrtkYFH/cg440hADs2hsbNMB2i7jVFd+0kxpuPnT9pZA0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739037819; c=relaxed/simple;
	bh=EzBiT2tp878vO+PO35lvQKEVvejLu3RsxEtGW+tik0s=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GFeTvLzNqZ5K65SINWeK5WxSp14RZP+Cji2teWRTRYM+tcTf7N+cwxoz5b/Z+j7JizcuyfrBqKNwIiJRY9NhSaqRqc263VmBTSunOaTX1/fH/oX4LX8hu10b+3QzjFjmlJId5MxEPxDThl/LT6BsjsAGKSpGGUgo0EGWA8++ZM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=VgyUGNLy; arc=fail smtp.client-ip=40.92.21.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=key54UWWIsojX572YapYD9df7hyge/r6VrhzBU8597GbZzJUlG9pkT3L+diEmPch9B5aQRJFlXvZuuePC7fnxan+TZDFNuP3OqploYBTStx/0r9m0QV5IKRhzdjI3gT5LIq/02MxQovO13jNWLiThvssJte1PaXHKvjJ0SLCeYQa2QrHYAxOP1KvqGvGZi7MYiwIxYbpV8XxS1ooQU50sLIOG2D+DHZ298jI58QvF9zi8tRjo6+XgAwQnLog5TQDXEKzZFhXecJnrtZE5ZyKB7SScb26yDsiVcI77QKGzONynRXe3hYInzVZ6345EgM1K1rJvgkxKKt2uaotJ/y6FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IreEy4vXuUJeFqa2ACjl7G7myB7qeXHyFLg2++BZuMs=;
 b=iPCqI9kdyEkWFlWyhM183Nvxd1U1xdNkz8EZK8ZUj9Xi9njM4zcznfBg65rP5LWxCVpFZi1CMtbg1sb5Fg+0XRY0/7w0NlZCpg1G3tmZF2cu/LnqJRsPQpfdkUwjQW8k9adDREnuCQcaOyhl0k3b8MAeWtZdTDSbFFsmZ0PyNHhmdRnvPycwTmmIMDa8Xzk8kth7OWPBCFkAJzgLuGFOwko/s4KcQ4C0GsWk0lTmr8kG3sraxJQsP8wBZvh2v2p3wTcICCNJmn4s/RMdAHZutnAIWAXGQhunOt7Q0GByeLv9nG7jljUAqKw9kdfGAfBcBEfj6YWyfIDDNsStsJGM9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IreEy4vXuUJeFqa2ACjl7G7myB7qeXHyFLg2++BZuMs=;
 b=VgyUGNLyVmPsof1z7OMSTwlfb6eq0miZkudRYcfYMFGQ42Jfeqg96n58nveDaLe6f5VWIqM+R6eu8utHviEhnXFzmpLwA+jx1Le0kf7O4mIa50kC5VXvbThAm0kEmxiroSsBNm1lG6tnUpifN2rqOop+Jclq+/qyI39juBplShbiohZI2UQTwWwnl+GHG8+gwwqnfyTpGwmidVsPK7Z419r6knzf1jBawzYZAU+ap2IJyYdBaNUCA8DvgQ698/mEdQvfrsx4MycOxB9lcxeMiG4B6aQ0zbbfmDW8q1O8/jgAD7NthEqoCbQZracnwSrbq8Uq9C75gcCm3iAiyErkmQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by DM8PR02MB8121.namprd02.prod.outlook.com (2603:10b6:8:1a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Sat, 8 Feb
 2025 18:03:35 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%4]) with mapi id 15.20.8422.010; Sat, 8 Feb 2025
 18:03:35 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Juergen Gross <jgross@suse.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan
 Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, Jan Kiszka
	<jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>, Nikunj A Dadhania <nikunj@amd.com>, Tom
 Lendacky <thomas.lendacky@amd.com>
Subject: RE: [PATCH 16/16] x86/kvmclock: Use TSC for sched_clock if it's
 constant and non-stop
Thread-Topic: [PATCH 16/16] x86/kvmclock: Use TSC for sched_clock if it's
 constant and non-stop
Thread-Index: AQHbdFA7yP+OKafhs0+Qp+iujFLydbM8IVsAgAGF1cA=
Date: Sat, 8 Feb 2025 18:03:35 +0000
Message-ID:
 <SN6PR02MB4157A85EC0B1B2D45CB611FAD4F02@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20250201021718.699411-1-seanjc@google.com>
 <20250201021718.699411-17-seanjc@google.com> <Z6ZBjNdoULymGgxz@google.com>
In-Reply-To: <Z6ZBjNdoULymGgxz@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|DM8PR02MB8121:EE_
x-ms-office365-filtering-correlation-id: e5872516-0cd0-4fd1-bf50-08dd486ae7ee
x-ms-exchange-slblob-mailprops:
 0wLWl8rLpvv/dfWT6unGWbRi7AvTEDs/ZGf/ZlgYSBNcMo1bwaYwNaT2UizFYz85L0V/s27agZjOODjxQv8nuNz3o+z3J1lx9t5qqJuaVWcqPgqKvXYydgghhOcpNX67fKMNQBXfCYpAW6jgo4N3ngY2zGxnV/K1P5CTr7lMVhLMKBsA8kmM03tzCq/IKWq8NvY6QzeosXJeB9wEDt89LvWCD6lRbHRNzIVU5jSpS6A50WmfYkLH4N/HKBFAnLptQAQB41RXmTGu7eY0vf4i9ds4ZrTaoyzoP8Ec76JnXnZVdPVDS7e39EEJwbCn9nUS5TjCJfRlDmD+W5nP0ZIt5T8AqmBnwm7L0Hr87/tRlAYh01/IEq/8Ths9/mP6MuoCZtYcSa2bA2/crzYoZJDA1Rq0WSKzXP7d9i4CfBV5bzby3ZmaGMUyzU8BUcXq1b5hgQXly4WRJiOE7U1iXMi8djQRPm54ijg/y2Ejhv1TqyeAxVGbBXF8tjoeqya5TUkle5LpHdtcCOdswjBFI4OB1FP2RltHSsffz4Zh+7YUUyz6F7nMxKiIAFlEhSOS/Y33F/NqBFi5/BVFdPm3BvpTBrAKgurCl0tPYmqcJP2x+wussJ4rLMar5AZY9+ffngPO3wut84or3Z9wEcaW4+edh+/x+AIJZ73HYkz/7e0URGdr+TDNXIS6PE6sm8BheT68cdzMo9hpG9+tTCidTx3YXjSs9UMKQfH5rdsNdqVx6iXb+ir9AEGgrHykfRihblKQKQc7lZJJTF0=
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|15080799006|8062599003|8060799006|19110799003|102099032|1602099012|3412199025|4302099013|440099028|10035399004|12091999003;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?hUOhQZuPrM+zmuss094Vk4HcA03pmuAnS2xDn1lSEycjjntqAkeKEHJFRSBm?=
 =?us-ascii?Q?hdgscTmnAas/BjE+UByc+zbdtynnOFEuRfNqmjQoEToxREDh6AEe9GEYxIMJ?=
 =?us-ascii?Q?WuZzmjW7tJiXr4rdxfS8JpXMCqayahnkoqhHn+fuiVlJ0MSpEbucvEt/mbH0?=
 =?us-ascii?Q?jjRcuG480VtbXhEwVYGPIVL86VON1FRW/cKOv9VBb4elgvqvODKXwujk76CH?=
 =?us-ascii?Q?BsI+jnEnEBAmSnD9NXbm9s0lg8CpMIfULyH4hKbfd+op2aWPAPfdtDF9/dCW?=
 =?us-ascii?Q?jllftKkcCT3GFHv9KDXFCpWCeg6CTWtITCteUHdFxAfulLmBxGRW58VXzS63?=
 =?us-ascii?Q?L+wZ8ynLNFRC/tK1GMmwJSklETIEQqa06iv4DXOeNwFwGfyydcLq6jZPUQ1d?=
 =?us-ascii?Q?co/DvS3LA3FR7x9rT4Q0//Ax38HxZVhy2r6e7Bya+3XdXjoLUDbKWI6ixrL8?=
 =?us-ascii?Q?L29sM0cwks81ya7+HEAlDDHPW4pzHurbpsWsSiYCkLcie+HKHaXx41jjcvRo?=
 =?us-ascii?Q?wAWNuCxLDSdLBV3ivk8ublOXvykmxpbO/6URq7an5zQMzj89L9bBMdo0MHGC?=
 =?us-ascii?Q?8lyYkWavvFMW4L8mS76JXPyRFHNMWBwmOFRdron+BbyykC/ygpZW1codMC68?=
 =?us-ascii?Q?tinKxNlLC42b0OBzT12ahFEmCcXxv1INMFQHnNDVcx+OHP2EBNb1tXypGbaY?=
 =?us-ascii?Q?mkwykwtH1NDt5OHe+7EYpeE8amenHRKb0yGpjhU75xDRBPIItFhRJS6S2CHV?=
 =?us-ascii?Q?RWJhXzhuItvz427m2hRMZrKuKZRpls1cTVpy9D0G6wwsRxSzxS7TxCDgPWKS?=
 =?us-ascii?Q?eMdGT1AoiIlnT+phXkxqPa/x8LrF1cjlzisIGJMESVhfalgnxo6Tq7Dwhg5f?=
 =?us-ascii?Q?Ls64H/WZVbt/8g+vjeuX7ysRG4zSHCNHcSj/NPG3OPtW2uUXpEfVgtENID/T?=
 =?us-ascii?Q?XwepSPN2NYf9TEA/zCip/hltoRsvxYwz+xTl24dWCvMX0vIFQo9iwGlqoPKD?=
 =?us-ascii?Q?FDpsI7CyAecNxGloSX8HqZLAVffWXeZjH8GROomL5Zs0IFavR1aUWoK229Rh?=
 =?us-ascii?Q?7XymUpIbsCIklx7n9aBAS9WBEi5XJeEaM/9/5F5fqQoxbfdyhNbFvPaJNF+b?=
 =?us-ascii?Q?HoIbxFC8r75RVB6teH/xfEQmj4zaOOeOUNj23qIjTTT4kLxPSjaF1juTQ2+T?=
 =?us-ascii?Q?guYpUHgqMkf05jpi?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?+O0u1tGlmuv3hqfcdbPB/P0R2gw2lJ97dh6dhqXl3e24uR8GYGOdK/wZyEVh?=
 =?us-ascii?Q?+OYwXcocQfUWsyCaxzR8H3RPcChrjvDMAO2TIPJ2lhQUabwo3BEgrapMb3Af?=
 =?us-ascii?Q?wTNE9MKgjN6Bud150ovN6nZOiWMqHIqjzycX0U8xu49l3Xhc3ypj1NQwYnVC?=
 =?us-ascii?Q?7jIDM0Ll0x9hxlnnsB8q6gQsY4ovQwDglMRzMT3/kScejkPliNNTfQxPEFDU?=
 =?us-ascii?Q?u0bM1h+nRzUgdYD15yu/E6w/3XfZuiJAl+etJLdze4KENPDAxJbF7RpPyDkJ?=
 =?us-ascii?Q?gOp4UM/6sfb340m0YVLMIQXDYF4/LFSnwXRQ6mheU6azbAQV1IH09+CsNLiV?=
 =?us-ascii?Q?N4JpmAcZCe91mFnyVVjPdbfw4kWsd+JZRCLI/9BKGEe0YFj4dPQWpZa7JISz?=
 =?us-ascii?Q?Nf7gHe+vX+YXnhXee1q0efwSSNUTn7LVFRS7j5BEcxi2aMRnTXwdbsbw71Fe?=
 =?us-ascii?Q?450EI349bvkDj/c8GyUUyiUefc2hk8YJSvz6T+oZMYgQY+yKJwR1uzbFXECj?=
 =?us-ascii?Q?eUgsyvBn2+z/+EL4RgCOOcIHpXAP9vj+RelLY9RqMAV+k8vvNHrbxHMRDZDm?=
 =?us-ascii?Q?B6wFkZO5Nj3EjFCVqzpEsvsedqW7vM4Z1SwYv2jm3ADycB431uMk2C+4Izv0?=
 =?us-ascii?Q?G44Ssze6hqwz+wc4Z8elpiw9OwaAvHxz1kpcrnlRfEY00yL/FzSmHVzBKt7F?=
 =?us-ascii?Q?XDF3T9FZasKZYntnhevN1zxjmfvcCjOm8+QWucI1MAwvpVrL5QHzQ3bgdVL+?=
 =?us-ascii?Q?yhC+am8O3hprgbpKBFv3UMT4gB8E6/SASxICeuRzXwVXYPWNzzH0X8gaRBa6?=
 =?us-ascii?Q?Wj5AQeLp6fFRpGE3QNYQn5MX/zrN9oIKzHg59c4bpa1IdTWrAxn8HYYH75BC?=
 =?us-ascii?Q?0+O04az9l7+Ttf8PcLBYgVBAkuKyJ8kka8ErcGUc0OmwucLU2digOevNE/01?=
 =?us-ascii?Q?tTDsGA67DFZkqpEGotFy6WdQSQmPfgdjAgeSffMEmJA9kIKTFb72UdMvjRir?=
 =?us-ascii?Q?VBHhCuFZxuMkqKXveyDzg1hDCGjya04oOJzwJ5KkHBOv1NtooNQP8/zYQxs9?=
 =?us-ascii?Q?sfepzmJmDYQELtllQVXyZ0C0UP301f/xPATzNTBwCM6re61wAMu99XUjsxRD?=
 =?us-ascii?Q?ft3bn4Zw509+NN+maExy0Kwhvji7y+NgZSktgubAOvyw7A/vyKa428TvSf9G?=
 =?us-ascii?Q?rQy+HwGUh9Rfzbq/tPvCIBILzzE4mTW8rUW6RhF5JU1P1LRP9WVi/EWWUkU?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e5872516-0cd0-4fd1-bf50-08dd486ae7ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2025 18:03:35.1205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB8121

From: Sean Christopherson <seanjc@google.com> Sent: Friday, February 7, 202=
5 9:23 AM
>=20
> Dropping a few people/lists whose emails are bouncing.
>=20
> On Fri, Jan 31, 2025, Sean Christopherson wrote:
> > @@ -369,6 +369,11 @@ void __init kvmclock_init(void)
> >  #ifdef CONFIG_X86_LOCAL_APIC
> >  	x86_cpuinit.early_percpu_clock_init =3D kvm_setup_secondary_clock;
> >  #endif
> > +	/*
> > +	 * Save/restore "sched" clock state even if kvmclock isn't being used
> > +	 * for sched_clock, as kvmclock is still used for wallclock and relie=
s
> > +	 * on these hooks to re-enable kvmclock after suspend+resume.
>=20
> This is wrong, wallclock is a different MSR entirely.
>=20
> > +	 */
> >  	x86_platform.save_sched_clock_state =3D kvm_save_sched_clock_state;
> >  	x86_platform.restore_sched_clock_state =3D kvm_restore_sched_clock_st=
ate;
>=20
> And usurping sched_clock save/restore is *really* wrong if kvmclock isn't=
 being
> used as sched_clock, because when TSC is reset on suspend/hiberation, not=
 doing
> tsc_{save,restore}_sched_clock_state() results in time going haywire.
>=20
> Subtly, that issue goes all the way back to patch "x86/paravirt: Don't us=
e a PV
> sched_clock in CoCo guests with trusted TSC" because pulling the rug out =
from
> under kvmclock leads to the same problem.
>=20
> The whole PV sched_clock scheme is a disaster.
>=20
> Hyper-V overrides the save/restore callbacks, but _also_ runs the old TSC=
 callbacks,
> because Hyper-V doesn't ensure that it's actually using the Hyper-V clock=
 for
> sched_clock.  And the code is all kinds of funky, because it tries to kee=
p the
> x86 code isolated from the generic HV clock code, but (a) there's already=
 x86 PV
> specific code in drivers/clocksource/hyperv_timer.c, and (b) splitting th=
e code
> means that Hyper-V overides the sched_clock save/restore hooks even when
> PARAVIRT=3Dn, i.e. when HV clock can't possibly be used as sched_clock.

Regarding (a), the one occurrence of x86 PV-specific code hyperv_timer.c is
the call to paravirt_set_sched_clock(), and it's under an #ifdef sequence s=
o that
it's not built if targeting some other architecture. Or do you see somethin=
g else
that is x86-specific?

Regarding (b), in drivers/hv/Kconfig, CONFIG_HYPERV always selects PARAVIRT=
.
So the #else clause (where PARAVIRT=3Dn) in that #ifdef sequence could argu=
ably
have a BUILD_BUG() added. If I recall correctly, other Hyper-V stuff breaks=
 if
PARAVIRT is forced to "n". So I don't think there's a current problem with =
the
sched_clock save/restore hooks. But I would be good with some restructuring
so that setting the sched clock save/restore hooks is more closely tied to =
the
sched clock choice, as long as the architecture independence of hyperv_time=
r.c
is preserved. And maybe there's a better way to handle hv_setup_sched_clock=
()
that is less messy with the #ifdef's. I'll think about that too.

Michael

>=20
> VMware appears to be buggy and doesn't do have offset adjustments, and al=
so lets
> the TSC callbacks run.
>=20
> I can't tell if Xen is broken, or if it's the sanest of the bunch.  Xen d=
oes
> save/restore things a la kvmclock, but only in the Xen PV suspend path.  =
So if
> the "normal" suspend/hibernate paths are unreachable, Xen is sane.  If no=
t, Xen
> is quite broken.
>=20
> To make matters worse, kvmclock is a mess and has existing bugs.  The BSP=
's clock
> is disabled during syscore_suspend() (via kvm_suspend()), but only re-ena=
bled in
> the sched_clock callback.  So if suspend is aborted due to a late wakeup,=
 the BSP
> will run without its clock enabled, which "works" only because KVM-the-hy=
pervisor
> is kind enough to not clobber the shared memory when the clock is disable=
d.  But
> over time, I would expect time on the BSP to drift from APs.
>=20
> And then there's this crud:
>=20
>   #ifdef CONFIG_X86_LOCAL_APIC
> 	x86_cpuinit.early_percpu_clock_init =3D kvm_setup_secondary_clock;
>   #endif
>=20
> which (a) should be guarded by CONFIG_SMP, not X86_LOCAL_APIC, and (b) is=
 only
> actually needed when kvmclock is sched_clock, because timekeeping doesn't=
 actually
> need to start that early.  But of course kvmclock craptastic handling of =
suspend
> and resume makes untangling that more difficult than it needs to be.
>=20
> The icing on the cake is that after cleaning up all the hacks, and having
> kvmclock hook clocksource.suspend/resume like it should, suspend/resume u=
nder
> kvmclock corrupts wall clock time because timekeeping_resume() reads the =
persistent
> clock before resuming clocksource clocks, and the stupid kvmclock wall cl=
ock subtly
> consumes the clocksource/system clock.  *sigh*
>=20
> I have yet more patches to clean all of this up.  The series is rather un=
wieldly,
> as it's now sitting at 38 patches (ugh), but I don't see a way to chunk i=
t up in
> a meaningful way, because everything is so intertwined.  :-/


