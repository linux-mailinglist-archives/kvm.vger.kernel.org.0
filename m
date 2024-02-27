Return-Path: <kvm+bounces-10041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F40868C92
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:43:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C276E282416
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99CC3137C33;
	Tue, 27 Feb 2024 09:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QrSerz+x"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2042.outbound.protection.outlook.com [40.107.95.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218081369BB;
	Tue, 27 Feb 2024 09:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709026978; cv=fail; b=BVZiR8U/3jvTSzISimQc4al8fsdbqKYKgz3M3LpSA48+cge76fRCFnPOm5+8enqjZidm4GN9x1UUAwNyxgByT6MTlL/kh+fcZc/SLVLthUym8fM3PD0Isu4xCcdBHi0dXv7TLpTMpZUy7kU4Fa4hjTYCMAQLmEWJh/NS7cIcLNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709026978; c=relaxed/simple;
	bh=HkIKD2NWuJZlgLF/arvg3OF1ouKpccDOD+qoUrMlnwU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DzqA6KpHgPh6DOmcR50wkkwID0O6Zyg/WIHaPms99K1HAXtzLIzGDZ2lMiycxSxbOB861MlG1OeYY2A7nqnPkUSbIKtE07QBiXUa5ehxPYRzvvI6DX7IDqmzNUsYyV8FXpcNyV55ZnISECFIzzSrReqE8BwKnWuUNfKgUJyctMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QrSerz+x; arc=fail smtp.client-ip=40.107.95.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxIauLuDBDWEat9Fe9vPIthV8h9z6DOsXJhBbpkCQPgaOp2JUqn8caHz1CmT2Eon/sQ11fWyLFWLWWr7D6Q8SGEt9PadID6U4oBGVxwSNPvXUfv/r1B3dEcS9BTYNsv5lTXu8CU6TgkKl+aTG1hosN08vz3wUUtU01VqAG3c5N1cn1JUjwArFhhhW1Fk6iFUHsa5crYhZBM3FQtEMwE/VGRlru7/oIaFngi3S2nCqmZCXG0CMA1aWSKVmnfXNuUyeb940UyR6K9dON5dsplMjI9c5dS20ND2SEVDzbBdqGaYa4y7Nagi+0YeQXWKpgWY1jhmGpl/9DcwIlpWWq53jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkIKD2NWuJZlgLF/arvg3OF1ouKpccDOD+qoUrMlnwU=;
 b=DbBcf+P10vInRuww/GDY+Dk0ppTDEzYbdcS0q+TqL2tcA09fZGgG0+LcJQPhxGiKZ5b0yqUYPi8NM0WDcCPZ6HYWWml5YoNLEZ47R7RdomTZkYrGamJpXB/au18AaQrPHjdgokMmdlgh9tAwWc/mCLzP7iKH4+JbFDnRB588J1CNb889gZRf16JLaV5qr88EiwKM5AosNPtGi4ZfcPC9hJkZCvklk0yHmY1DFdu3vzbh1Gt5IfGrpYiAOZJ1r7xwWqUHEiOK/FJjIg6cimSs3UFQAvKDMTYkjzegfQ+jZXbpnvdZ2PFzUQ0xPenvj/fLk7tRlcEEyU6vPOAN9SeoxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkIKD2NWuJZlgLF/arvg3OF1ouKpccDOD+qoUrMlnwU=;
 b=QrSerz+xTLHxt2SixnVENiChWK0Rg4FA/1XIjcblZuPO2lBTleb6S04S9zSuql6S4QhmQbRQr3vNM+oz9FfzPDsFBwf240C7aB5j1OG3qqs7ynOYH/Br/dVT2lBH7F00iVrPQ0h4V0ke8xgl+sn4qEZmFyyIX45KlpP3nEPS1fgPNCX+WcTeLFdPo04TX03MtqoAUrG0PCNjnamhP7AU6VdrGDKvdwOaXXN47iEMpTnLdx71nHjaEv+DTDLNYBjjcK1+TIEM6oEVzi0/QwPAbmKBC0MZU6u5b3w/Zl9Tmwx0vHAEHb4poF2+50MPHoULo18zAGvGCJsbmk5EFHhjyQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS7PR12MB6238.namprd12.prod.outlook.com (2603:10b6:8:96::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Tue, 27 Feb
 2024 09:42:54 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.032; Tue, 27 Feb 2024
 09:42:53 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: "wangjinchao@xfusion.com" <wangjinchao@xfusion.com>, "shahuang@redhat.com"
	<shahuang@redhat.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "stefanha@redhat.com"
	<stefanha@redhat.com>, "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"david@redhat.com" <david@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "gshan@redhat.com"
	<gshan@redhat.com>, "brauner@kernel.org" <brauner@kernel.org>,
	"rananta@google.com" <rananta@google.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"surenb@google.com" <surenb@google.com>, "ricarkol@google.com"
	<ricarkol@google.com>, "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
	"james.morse@arm.com" <james.morse@arm.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "maz@kernel.org"
	<maz@kernel.org>, "bhe@redhat.com" <bhe@redhat.com>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "andreyknvl@gmail.com"
	<andreyknvl@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>, Dan Williams
	<danw@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Zhi Wang
	<zhiw@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, Vikram Sethi
	<vsethi@nvidia.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>
Subject: Re: [PATCH v9 0/4] KVM: arm64: Allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Thread-Topic: [PATCH v9 0/4] KVM: arm64: Allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Thread-Index: AQHaZzMEm+T/CCvzwkOvE3ojID9DN7EdTV0AgACUxr+AAAMkAIAADrtn
Date: Tue, 27 Feb 2024 09:42:53 +0000
Message-ID:
 <SA1PR12MB71994CF9EB35225CAB0E909FB0592@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240224150546.368-1-ankita@nvidia.com>
 <170899100569.1405597.5047894183843333522.b4-ty@linux.dev>
 <SA1PR12MB71992A7E86741878935DC385B0592@SA1PR12MB7199.namprd12.prod.outlook.com>
 <Zd2iCg5A0Zg_EyCm@linux.dev>
In-Reply-To: <Zd2iCg5A0Zg_EyCm@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS7PR12MB6238:EE_
x-ms-office365-filtering-correlation-id: bdc4181d-0fec-4232-01fa-08dc37787886
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ycf4UC0PfobR3g+UbwlT+cEYeR/VtZozXinrQOe5StgLzWuNMmkRfbX1FdBn2RFWSKa2DCMDoBCWUp9Lb79XmY6e1rnIxcEc9fVYk2JInRBnzfjj13OYMuu6TJQDTZprl5vi6MB7iG3fJ6f0IUItZ3XBG39hO6byHP2Lgn8xQUtunhIu0tpm4/0F9Z0fExiVnTeaNRHBHW93DOxR23IWxcM5B3UzcSC0nwGeyiVgs1nb0kw0gunJ8M9scZtpwnyzDidit3rImQ6IIkSbUDZvboOGOnJRGsV3RRmGuedpbv1me3v1vPJHMzxbtMopjU8GAfyqVyI29gbdnx6BmrT7Ut8LCgDKZ+Def5CG4Y+fidqIuV/EuA+6G6QvuqEUm9nQg/OjziItoqSpLpLg/9+TK7vzir2E1jM9I7WQLhY6lubVBKoDrza6Ew8jnwEW/QXYDB3DiLW8G04GI6NQaPlB+8VH3vQ1KJQmCt7ngWtF0qVGXwVo+Y+EgW8xDpgsye6X7wzJ3D4eQ6bLOKZIvuFfT7rhXWLvs3QumZTMQi4M/OCA3RRXEA0o1i9Al7YxrG9+VYaNRTmvUrHq4jtTHH5Z663ZyLGOYyX3KMn5jPkAVi28uwqEC301i9lEsHDgKf/hAX/g2OrgnR/xmMj8dnUNMp5IVKz1PZ+Dqi/FgqDg8QHXH/cEmJIlG+tb6sCq29ksIymIm0FZKTzmz5b8K3JoDeZg1yU4fuucnUpgaa1x4RE++7/qq1hYaIOsReL74mGt
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?lTuVybUB+/w3Ga48tz4MNROYKUoNBZNH6RTKFXKwthWKpyTuXyrOvkikb1?=
 =?iso-8859-1?Q?lmeGqWWq646V7CSbjqdQAerMGUNWHM7idyOjjzoApKf7mHlJaCUiGu7qS5?=
 =?iso-8859-1?Q?zlm0zGaxZmZv8p1kNc6cMYwdy/vVFSMUme6vdTD1wqR6rzwRZJA6M0diHs?=
 =?iso-8859-1?Q?oUOoMYBYdwGEZU/yP9+Nl3QeMIVt786WITtM4qQ/0VgGGFtCGkgIilw2ZF?=
 =?iso-8859-1?Q?h17ZQLLMvp8Wya8rjotqmGdtsfEr6DmpDeDwu5fJ1bGdrXrm60vNEqBzdh?=
 =?iso-8859-1?Q?JThwQ1fdz88W+g67gl+U/u2d+hlZWCiwb1x++rb2G54TOCzG021ElcKZsT?=
 =?iso-8859-1?Q?wPRsRQ4It1B8owOYqZHii6q00wgyE1DYE5i7eijbtge+KpvbP5ujJokoWA?=
 =?iso-8859-1?Q?a9t6bJ+pRJ7uj0OeR4nu6DDskhI23LrJdRBhfbW8/cmvPtze0qg2tn25vt?=
 =?iso-8859-1?Q?+yv6nG9cVaP/UWOXtJH4HWgFQuggRhKk2iJ2re5vQgNPicKGcT90JTJQfF?=
 =?iso-8859-1?Q?31a9BMDIhPDNtPBuineRN+lTyNqc1W3nFYPrFanCzxjSi68xQA/icrlrZI?=
 =?iso-8859-1?Q?nexQ+XUUjdQ8xd1Zm7syVpR+r6k9hehJBFKn9YX09UdPT/UFk8FOlS0K/L?=
 =?iso-8859-1?Q?jvktV8vT7PVvKFrVGlxHZO4PjdnMRDXMXUVK8FRebcJ/Pa0T+4N8ujtsNT?=
 =?iso-8859-1?Q?EmOO6FWBB2FWFsQeeriU1d8I2rAk073+JqxU9YJgWYnSY37qA5pu7GE6+a?=
 =?iso-8859-1?Q?/RgXJaEXcvXI2pkHtscmY0u6+VbF1E29JPW5rXryelU0EygbVolKEFdMVh?=
 =?iso-8859-1?Q?99PHdQRW/SSMj80VNND72iMrE3odmmfhXwpZ2Q9aEzHoAkhUyWKY1UUlrg?=
 =?iso-8859-1?Q?4yXJEHa0ufzbovLJn+TYCz++IibfkDEO0xkXObc2udg8WDWBIfbzEfIR6b?=
 =?iso-8859-1?Q?VLcpDZaXDdnaX3heKF/02Xe9dq+sciADu9WXiOeGYv2niI1i1qT+72tc6k?=
 =?iso-8859-1?Q?CdZPr02BVZB54GD6sKyJ+ngefA2o7PubPutqELoprxY7vVXnlNMhmRr1+Z?=
 =?iso-8859-1?Q?YKhixLAcN4RBhArdc2tsjT2kazENsGfjlUmzCkkHAji0xsoyCqEL7NN5H+?=
 =?iso-8859-1?Q?LjH/RXsQsMdZElR6YzbsYlrU7RRQkbWXNIXFxx7rPQ3FCFKXtj4347KerC?=
 =?iso-8859-1?Q?wCjKromfac7XaKhQbU8QWluCh4Y/VsIMrU6gueXo3011kHLmTOeAHQ5hWV?=
 =?iso-8859-1?Q?50591J2+XPnbzer4TKIOL5KfbT2TVFG1bQgGBmo5mSh/eBnpSY+xzhxgh4?=
 =?iso-8859-1?Q?uLIIJB28PODeCqgDXqynDk01R3NCxBPE6i5e4ScwbEnocEfGfgG9JUnW/e?=
 =?iso-8859-1?Q?3hxdfe15U6sSCzhaIfEIu7+/CqHwyy+PYnC9YQplIXUuP99rwbfus52ipx?=
 =?iso-8859-1?Q?VGs6yboaXnefy9KNEEoOavxr8VbaRkHi4MmpNO+lEX7nDVQe9mMRvxErBO?=
 =?iso-8859-1?Q?R6qFRoRfiqfitUgTCj8nSmn2H1RmovMTQ6KEFaij0Vfuiw2zym/Dvw0zu7?=
 =?iso-8859-1?Q?3UlPpthb6zUMMrd4ARjb6N5wmSNwo/VqD5/grqf7QBHElujQAjed/wNi0t?=
 =?iso-8859-1?Q?yqQEt7B3A2stA=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc4181d-0fec-4232-01fa-08dc37787886
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2024 09:42:53.7154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dKJEt1XmkSTa1z4ziGieTiWA9ZM2tg4p0+UAFH3TV5O7QTyz6rQDT2+Kd9HzEO7irs5AyxacutwZw4kT/7/5GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6238

>> >=0A=
>> > High time to get this cooking in -next. Looks like there aren't any=0A=
>> > conflicts w/ VFIO, but if that changes I've pushed a topic branch to:=
=0A=
>> >=0A=
>> >=A0 https://git.kernel.org/pub/scm/linux/kernel/git/oupton/linux.git/lo=
g/?h=3Dkvm-arm64/vfio-normal-nc=0A=
>> >=0A=
>> > Applied to kvmarm/next, thanks!=0A=
>>=0A=
>> Thanks Oliver for your efforts. Pardon my naivety, but what would the=0A=
>> sequence of steps that this series go through next before landing in an=
=0A=
>> rc branch? Also, what is the earliest branch this is supposed to land=0A=
>> assuming all goes well?=0A=
>=0A=
> We should see this showing up in linux-next imminently. Assuming there=0A=
> are no issues there, your changes will be sent out as part of the kvmarm=
=0A=
> pull request for 6.9.=0A=
>=0A=
> At least in kvmarm, /next is used for patches that'll land in the next=0A=
> merge window and /fixes is for bugfixes that need to go in the current=0A=
> release cycle.=0A=
=0A=
Got it, thanks for the information!=

