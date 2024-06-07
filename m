Return-Path: <kvm+bounces-19077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A240F900A96
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 18:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 571D71F2107A
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 16:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFAF19AA75;
	Fri,  7 Jun 2024 16:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="CbWuqYy7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11olkn2028.outbound.protection.outlook.com [40.92.19.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25ED43ADE;
	Fri,  7 Jun 2024 16:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.19.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717778182; cv=fail; b=NgGz4FYMIXbK2XgARv2r9ZM5qN8QszHDocx/Oa8jASUlLPyhlbi51HygvI9gFLRxB5NaaqAYzl74fE8RbkgRyM95/u4D2aY49b1JqejPUXZAS7jxVxNgdz8lety4XfWsrOMhP8R/d+pxXOmmDyrAm7yeCQU+l/SP3g3DUhcn1zU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717778182; c=relaxed/simple;
	bh=UXo5GSw8vCBNcLr+7YxNsi7CBxQFna7P8USjNe45Ljw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YfEbEiknyPnC3ZvVxJNAXeEuOnDMIU+P/eR5TGAsY+MWUSAaVMGlBgcRcy2OMd2XyvE6jMFtSQ6ouZbqvoWtQNdhxrGsiyAufF7gFJC/sS8VmsFIlokwBr9+pNYeWbLloe4jbdUx35n+oByycC6JoFv4ot4QRW2GRf4D0Y1P0hU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=CbWuqYy7; arc=fail smtp.client-ip=40.92.19.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VYprK2XLR2zPo9IkzC78kXWNkGHRs2xlD3ah4/q6rjNBWIBftIUyoBSdHPKJVvJDDz9HppHtVCJotpELvRTiAVV5dD2l7Qz/6KL8s8egDSJtAHAJiQaE2tSNfPhUwROrDzmFJIAAuKtBtsInAWDARe+PGO9aPQQHD7QaNrZdTiV5JBfKLeAsPvOD6kua085TJN4aqOZbxIgU8ngSpqmgXYmg47bitnsqGH38PulZgOC1ZnQKE6qOLXxD9Fj4KtfecXgRGbMCalTgjjLfEvRD3tK6G0k2PPvzW4pvAQs9h2I+/r5QIZKXgS7d1H05HQ9ydAWYzOXsjvCtmOgM8A9ALw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuMIGty1hzU0bAZTbZiu8UkTlXyUoZnpT7CxcLOSNiU=;
 b=iLbuqX2nXT852ByM500rgg3P4rnuaupWv7VEqju7Y/yD0vaOTq6qa4TCMFIntmioqNic493R8MJibRivXG7oC+yR9rra22FfjtVgtwYm6HFnIcGy2Cq2fqOQtSaWAyRG7a6WipuY9S2F6wtwFK39yiMrUmZT7F++rLuo6AVd3VtEd0+rFHdea+spBl3X8rT3B8jCAoTLteNSRj2obSLkZwmfY3e4WGjKbAtD5atWisZMjlhMsVchjexcVeQG1tQlJa9urYIhp51FgKQBY2UBcFf3h3FLKqd9bvVRVQcDFhpHuxwjbJAaDn7yXeHNO7ZILYe9ZmQOWOHxmBt/wfQbmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuMIGty1hzU0bAZTbZiu8UkTlXyUoZnpT7CxcLOSNiU=;
 b=CbWuqYy7wUNyFqL3oquUW8pXhV8nYXPCXdlhyZDLVS96v90lN9VndzOTanBW9ysqEuXmLkessiXcIIu1W8V4d2Bm6Iou5+YVaRLkflDDoh0wCYLw/k4cwmbw4yvhN75ITIxc8VvdJD1NDf8aHR5GjfnOdHa1e5x2m5efzpusCybX3mnkw+KxUMpf7BsGQqV/xaQSKV1Ve3ztKYPU7pR6l3y3EhfQ1K+deh2AqhCFPp15LO0Fka99AmCnH2h8NOSVE9WnSBkMmjk01lsymyggopBE429qCpHtMbCtVY/4vvBLMopPgWk2dFO5Xx3MgaRdLlf4V2O40gNyqZyJdjRGAA==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by DM4PR02MB9117.namprd02.prod.outlook.com (2603:10b6:8:10f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Fri, 7 Jun
 2024 16:36:18 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.7633.034; Fri, 7 Jun 2024
 16:36:18 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Steven Price <steven.price@arm.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse
	<james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
	<christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Ganapatrao
 Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: RE: [PATCH v3 00/14] arm64: Support for running as a guest in Arm CCA
Thread-Topic: [PATCH v3 00/14] arm64: Support for running as a guest in Arm
 CCA
Thread-Index: AQHatysPRYaUedD8SEOOWptuNOqVvrG7hVGQgADmoQCAAA8XwA==
Date: Fri, 7 Jun 2024 16:36:18 +0000
Message-ID:
 <SN6PR02MB41571B5C2C9C59B0DF5F4E7ED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <SN6PR02MB415739D48B10C26D2673F3FED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
 <ZmMjam3-L807AFR-@arm.com>
In-Reply-To: <ZmMjam3-L807AFR-@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [lRVcfVCqhys8csLzl3o0Ghyt2LtwraEy]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|DM4PR02MB9117:EE_
x-ms-office365-filtering-correlation-id: 5fb1d624-d10d-4061-6f59-08dc870ff4db
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199019|56899024|440099019|3412199016|102099023;
x-microsoft-antispam-message-info:
 AYc+EStk+/ziDMooYzNB1YjvaKyx8SmkFQEyrLsdR2/wam+AEqfix/clHbQ4MtLm/JcWtTYuu7rBFsTbdCNQnPqsTFHoBZLBXbB/Ip+Qnt1iEE9CCUvH2wfgQ8XIKUkiLV9xzrzT2GavDXck11daOfuOHUxybVwyFD1XK9ln2+nDOQiwSh+FNiYAmRCjvMkO2ap6LFc66opK4IjsE6ARAOyd/jdyrWmk8AgKKJMcGSm3b0DihNWAmXjKQ+wva75nCWsV4OlQvLROE2jvLCcE/EjVCaXdDPXBMpY6G7FHrshKUWmI4/bWIAYmV3I8bElvkxxo5O3EKHUtqX138Z4CK7pWAJU3t9uizrWxuGi0Tujkel7eLmPfV7UWxD4Qe/mJaNEwqIgbuq6fhgaZVKLMuBxaSpdgqVTJaMmMr+bMUowZ37cyaA/I4fFxaPfggsCqAjVPh6hO1l5JDNYC+asCSHEDzRrDxJNk4+Qi5ELz8JQxteGNtv+AgfAARgEtIaQa3WuW5uekZc+lknNYeVW2nQkYSPp80aj820No2iGFkhrHiyhVOnU0bIh1smkGHPTr
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?65E8VSnH6qy0vcHpQwnWEnDcgJnlLb5BPylM9W5H4W/V9SfDYtfh804jJn7i?=
 =?us-ascii?Q?Sxk4fpMLjYXavzW7jYi0KyX3TN2tiV2iu56TNA2ZZf7MX6O/kalT+lg7JzFR?=
 =?us-ascii?Q?MbDyp7060nNwn1sIpI0ql2mSZ776eq5c9VlqPz7PignaBwJrgg6o8s6bg8gW?=
 =?us-ascii?Q?G+OllutsuRE2BRu7HqZVQQksgrE/gOFcW0Z4O53Q25B4PrvgSw46u8LqvXWy?=
 =?us-ascii?Q?ist1BtOi0Hd0uEVmE1zGwkGtt4Tee91vi0kcOWBL5JIIzJm0S1/jjSTLuQ2Z?=
 =?us-ascii?Q?imVzt5UukP2y2bE8gmjLIjuAzZExqSwrUSJ+H4RcF1clT26Y5X6mRxllGlOQ?=
 =?us-ascii?Q?I4ki0wFshG39Mdc93F0FxdO3tomxMIi/1IcX33oOko/2o2RcBHWgEMOWbdqL?=
 =?us-ascii?Q?GBKH01awiJebDIws6KqlD3K/V8jSRhWIZbrRyg2SzKHgRTK3sNiLPY4vG2aq?=
 =?us-ascii?Q?XCcP+I2zXRsnU4sxluYsr61E6GTL+fMYoVEAH0bhH64A63Ufd0VhBHIqEWcR?=
 =?us-ascii?Q?f9g4ijSrY0gs79aD7vzPBug9Qzz7MkMa9UIIpP8EUuvkJywlCHOqFDrsBqKz?=
 =?us-ascii?Q?OGubbboz0EXElp8pT2I2se5dwY56BeYwYVdCt5zCQnqNnCb0prZ6qMIpBnxD?=
 =?us-ascii?Q?i9bDVlw9RvrQsfwbB/yPKWzHYVCpuVX8VRV3//kqPaoN+usZYPme8N0cB8BL?=
 =?us-ascii?Q?Pkm1ZwVKB5IjVfwOLiRguK26OVnqB1Z9l/fuCn7C32mJAqIpY0noXPy48isp?=
 =?us-ascii?Q?KxrMhDsnBk2474L1JmE/L2wb/ROCuam2AXLPBcjedncn8eynmXcwubZCMxX+?=
 =?us-ascii?Q?wVbJN1W4zmgEJeiT3R078JMzj4DMt3bQV3Tbd03ATtzQhN4KzMpF534MYVjN?=
 =?us-ascii?Q?dt4+cQCHMxAagIwBe/vxIkdLpdY7xlEagLI1YZUK2gnNsGqR6QpGeBiu1+F4?=
 =?us-ascii?Q?J4v08YgONvyhw8kQZF5H6nQLXdVySJyRzetXkluIO5cAmZWtvJB0BbcDVjC/?=
 =?us-ascii?Q?jSyKtwzf8ryHvLUItA1V4dfgOM4gvbaw7CWnnXi7NbwyVicKHTnZ21lLzH0o?=
 =?us-ascii?Q?F9KNcXBLXRK2pBUCKqZVYZfJj9NTKKZ0stHLcA+cTYhJtNWw1IQq4WsWTcbr?=
 =?us-ascii?Q?FoYfPksndmBDsayjFJYH2HR8A/XYV64Nz808eO47kx+hIGdDn3DMO4iulXST?=
 =?us-ascii?Q?Pq29XMAYmfYSMRLBf0zU+eHz+GmFnMQP4YrzXz0VzjVRMxwdXVGwEHU/u/k?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb1d624-d10d-4061-6f59-08dc870ff4db
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 16:36:18.1701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR02MB9117

From: Catalin Marinas <catalin.marinas@arm.com> Sent: Friday, June 7, 2024 =
8:13 AM
>=20
> On Fri, Jun 07, 2024 at 01:38:15AM +0000, Michael Kelley wrote:
> > From: Steven Price <steven.price@arm.com> Sent: Wednesday, June 5, 2024=
 2:30 AM
> > > This series adds support for running Linux in a protected VM under th=
e
> > > Arm Confidential Compute Architecture (CCA). This has been updated
> > > following the feedback from the v2 posting[1]. Thanks for the feedbac=
k!
> > > Individual patches have a change log for v3.
> > >
> > > The biggest change from v2 is fixing set_memory_{en,de}crypted() to
> > > perform a break-before-make sequence. Note that only the virtual addr=
ess
> > > supplied is flipped between shared and protected, so if e.g. a vmallo=
c()
> > > address is passed the linear map will still point to the (now invalid=
)
> > > previous IPA. Attempts to access the wrong address may trigger a
> > > Synchronous External Abort. However any code which attempts to access
> > > the 'encrypted' alias after set_memory_decrypted() is already likely =
to
> > > be broken on platforms that implement memory encryption, so I don't
> > > expect problems.
> >
> > In the case of a vmalloc() address, load_unaligned_zeropad() could stil=
l
> > make an access to the underlying pages through the linear address. In
> > CoCo guests on x86, both the vmalloc PTE and the linear map PTE are
> > flipped, so the load_unaligned_zeropad() problem can occur only during
> > the transition between decrypted and encrypted. But even then, the
> > exception handlers have code to fixup this case and allow everything to
> > proceed normally.
> >
> > I haven't looked at the code in your patches, but do you handle that ca=
se,
> > or somehow prevent it?
>=20
> If we can guarantee that only full a vm_struct area is changed at a
> time, the vmap guard page would prevent this issue (not sure we can
> though). Otherwise I think we either change the set_memory_*() code to
> deal with the other mappings or we handle the exception.

I don't think the vmap guard pages help. The vmalloc() memory consists
of individual pages that are scattered throughout the direct map. The stray
reference from load_unaligned_zeropad() will originate in a kmalloc'ed
memory page that precedes one of these scattered individual pages, and
will use a direct map kernel vaddr.  So the guard page in vmalloc space don=
't
come into play. At least in the Hyper-V use case, an entire vmalloc allocat=
ion
*is* flipped as a unit, so the guard pages do prevent a stray reference fro=
m
load_unaligned_zeropad() that originates in vmalloc space. At one
point I looked to see if load_unaligned_zeropad() is ever used on vmalloc
addresses.  I think the answer was "no",  making the guard page question
moot, but I'm not sure. :-(

Another thought: The use of load_unaligned_zeropad() is conditional on
CONFIG_DCACHE_WORD_ACCESS. There are #ifdef'ed alternate
implementations that don't use load_unaligned_zeropad() if it is not
enabled. I looked at just disabling it in CoCo VMs, but I don't know the
performance impact. I speculated that the benefits were more noticeable
in processors from a decade or more ago, and perhaps less so now, but
never did any measurements. There was also a snag in that x86-only
code has a usage of load_unaligned_zeropad() without an alternate
implementation, so I never went fully down that path. But arm64 would
probably "just work" if it were disabled.

>=20
> We also have potential user mappings, do we need to do anything about
> them?

I'm unclear on the scenario here.  Would memory with a user mapping
ever be flipped between decrypted and encrypted while the user mapping
existed?  I don't recall being concerned about user mappings, so maybe
had ruled out that scenario. On x86, flipping between decrypted and
encrypted may effectively change the contents of the memory, so doing
a flip while mapped into user space seems problematic. But maybe I'm
missing something.

Michael

