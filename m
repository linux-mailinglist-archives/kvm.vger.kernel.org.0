Return-Path: <kvm+bounces-9181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DEBC85BB85
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 13:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99857B2253E
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 12:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5D367E64;
	Tue, 20 Feb 2024 12:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tj42CD/c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AF567C67;
	Tue, 20 Feb 2024 12:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708431083; cv=fail; b=qo7fCICppceKV4Mjma4PAJ8QE/U7pHAAd5SdR5HuTIyu2eh5pCmghi6FDi/O+/vyRvlO6TLT0512VlTk4wm/DEVV68j3S6ippPfopHPwzCLFK5cygYFQUxwDlTNSb/Sg4hY98SO/NgBfLqt1O6yCszOtojefVZ2CNLUnbkrI9F0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708431083; c=relaxed/simple;
	bh=P4UjTvDzAs55W0FV87nHPdGgw52PU9GedPe7X4sAa1k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VMU2FKDUnR6ZLIULS3uYArYVueExIaBsEennH7zxPAmFUFDOzn+b/9YbD2V5NhM7y8VSPsZ2N8Y1Es4XjJBrB+iJHznYBbhn+gpn7GwWowC01PCAywtccjIjX8a1LBBwwqFVmK4jY871nb1A4oFgvmGKN0R7cqSWWiAfydAq7gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tj42CD/c; arc=fail smtp.client-ip=40.107.93.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XB7BY5GgvdueRpVustu3ea2YhczxIRapc1PTn9zEuzNODxicM71oKC5csWa+QPrP8KMg//oo22HMrvOuL1soPwBgy8PMCs+vDf5fphcPHMtTqm/GRNo9vpgSZ6SkJkfR12TTkeTxsJxAf9N1vYVDjkQFNNP/87Yd+olG34wKMhOBXPlDsbUENmT1PqMLiwtmYaJacCc1MKjpDCeVJhhOP6R1q6K7mNSlKsfbpBb3FkIATLSb1PxIxQI5nLmH+/Q3FYqtF1TJHMEa7ScNQG3RWBtDBJp5OpExC6kus++Ucp6YOvWfvrKQXmJwv/DiHeI7V+v/JOLhAJ3APH6JbY2Jgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4UjTvDzAs55W0FV87nHPdGgw52PU9GedPe7X4sAa1k=;
 b=lV8Xk6ak6Kzeu6fIhzkpS9QTZ433GyW/rqbhJ1GLgtT2Pf0L+7BiKNeeHxGgrbWBWlJf5FIh+/unDTmNETbCTzpiQcEMVGRAfH3usuGXZkyztHWuorYHGlQBuSe8kkGP5UuIg7ZXKofE0iDPkgGxhCiSoXiOWsUZAFt9G0N7V61W32JQH+nrYL+23qS/kO1/MHUfXgwv+auHZN0dRWGFwa/AQnAY3K9I7xHyIjhEu+1PSVbL60p/HeyWvCQLoUhXywbmCNLqrLs8i+d3WAc7yuFrLZfgJp8vHZwsj6BQm8s3R1WXOfaGNQPiicfRSoppcktipeP13XwhMv+DHzJgDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4UjTvDzAs55W0FV87nHPdGgw52PU9GedPe7X4sAa1k=;
 b=tj42CD/cWmCn+8W+KnrJQBTWtqbIbYOZXNHIvOEECaQgoVO5JcuB0TofRW3XkBu5rmX0XTGRpi1+FA3eDbGz+c+LLso+nmRKoJNxt30u70YXgWM2Z9EYvPTDpCTAoFOBODPB/ObGn7EVqVZl//ZbJjXSbuzXEx5hIZ02YO9kYkubEtjDQOZE05XpRqzHSDHJiZP3chKCFzoAzwTVxoymMAgLbemI+lbS2pOydZkv5ZyC/9J1ShexSCilEt/c4uH8uHbkpJJ86LrVJz6OFG7bUcpGYzYXmyHZLRxrdE9fF9kSXPo3+qMgK/0/Zy+oL1XQNAdLlWjTBt+vWItqbQk5dQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SJ2PR12MB8033.namprd12.prod.outlook.com (2603:10b6:a03:4c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.17; Tue, 20 Feb
 2024 12:11:19 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.016; Tue, 20 Feb 2024
 12:11:19 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "james.morse@arm.com"
	<james.morse@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "surenb@google.com" <surenb@google.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "gshan@redhat.com" <gshan@redhat.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "ricarkol@google.com"
	<ricarkol@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "rananta@google.com"
	<rananta@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"david@redhat.com" <david@redhat.com>, "linus.walleij@linaro.org"
	<linus.walleij@linaro.org>, "bhe@redhat.com" <bhe@redhat.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt
 Ochs <mochs@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Thread-Topic: [PATCH v8 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Thread-Index: AQHaY87ElOqCfNqv40aGQwk3/xRuTbES/mYAgAAlXLw=
Date: Tue, 20 Feb 2024 12:11:19 +0000
Message-ID:
 <SA1PR12MB7199A969E2A4B31220EFF152B0502@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
 <20240220072926.6466-5-ankita@nvidia.com> <ZdR3MI_4pqV0EZcR@arm.com>
In-Reply-To: <ZdR3MI_4pqV0EZcR@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SJ2PR12MB8033:EE_
x-ms-office365-filtering-correlation-id: e692da57-0405-4c67-b750-08dc320d0ba1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 KGHzGTQs/2Dz7FZYgEKbRzWTuXmbDdP6zEW7zSSPVoOVjdVixX6kAhBu6JGweUtss0+w21wpeM9qx/3lDxz9HaFRBAfUNDAnrdZ5obrmi5UMIDjxWAD5cmD6unO5h22JQST6JcEzK7OggkiGG7U+tom9JXr/KqgglMm2MwD9ukCddM2RCmcGm2LhqesOYzm6peUvyy20Zlb9eh125HeDojHfa3cXsgegm5Yzcy7AEnYLZE077Ah77pLeaPPWHRYdg8ixzQTBFIqeWuKuhzpAx5l3BPpZgQGo74p8Mtz73V24+L3zpWbcGnBXNzklwHlte5BXFMynDNCncXrFniB/yTVumMZSnasNCXklha0EiNINVx0g4VFwT5AackzglA2G/iU+0n1VAQmlr1FriRDJNrMxmSWLWkByCog7h77/Bjr06SCGlmnTsOBAq1e0xjM8SPDrOjkK+sMLE3g4vRRGgiibk3zNqJhPRKx7KZWaa/Z+sEKIRGH2J2itXhaY4ILUKqv8tT5F/SEQEsjw6ixMhHYyacOlRjJVRm4gkj9ISZV1rQQbp7Ee5CkGj//SJXQC4IbxxmtymkKwVp1W6mUJ921bFf1cFgPS+Na9vAr89FxTC2hH1jRidgiprdrE8RaV
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?KBdNgNHTc/49SJJ2Fho8kLr7/J3apB8BXy6EaKvgAul/ZtPfPsEaqXzAvr?=
 =?iso-8859-1?Q?WefO1J2l3w63kIc9Hthnwd3CPkiA6WBXApylwClbJYuMgBwTFOoIjK3gTU?=
 =?iso-8859-1?Q?GOgZOKZESi76k3zZQByaqVS49/Cs5X8397opdbc2PdFOwyZTuryW66S5Ww?=
 =?iso-8859-1?Q?51ilyyzgv5P+gptnYqoe4iNniobGnBZhCgeiN/qj71CVnAEtqJw01JFcZ9?=
 =?iso-8859-1?Q?uhlpgdM2QAlvyP/fli8pvo6aCRxrG4540wDnJflaAMKkhS9OtCd83CFfxu?=
 =?iso-8859-1?Q?dI63HxsJIfMmLjaN2n2qRttWaj2LsExPPW6WA2HsDSgXssTpRWNAeX/jG+?=
 =?iso-8859-1?Q?Pkd7w1U9bYRBp+EKLvZGXmcSVW2GAhWIXT5z3DkmBCFLi3/P+v5GZq9vU2?=
 =?iso-8859-1?Q?NkOSzfCscE4yuHFGG02d2JkIZSFzLnP8CSTteInSRvIRNn+fI/PAnsMzOp?=
 =?iso-8859-1?Q?pon/ikig3zJk6/caGEQYUZQmnFaY5traDFCZRxuPifx74hcWvtmZsvCYSM?=
 =?iso-8859-1?Q?431DXYJ7l5cycTP1X+ng5qiMG32Z/WeAbeyrk7Hk+faXx7aMkozNH2/rIQ?=
 =?iso-8859-1?Q?v475HQ59eQGRN/q0Ku+1uyYWSMwnIkvQNIalc7RvK2kyD4gbk91TdoYzIm?=
 =?iso-8859-1?Q?/AvI3gH8S14U1xw9po1rL3qrW5L24Uhf2J3m+flrjhFk9TXmYyOkv/BoWA?=
 =?iso-8859-1?Q?v2mAuvnkdRKy17M8ItQfhTxxQKNZVNVJf044JjoioaNduz8E4xbVCgtSGc?=
 =?iso-8859-1?Q?msONQ6dfMr4jhraXke8COsamJKIrxG+M0LgwRhjk4CZuZOQLXgScIVGaSY?=
 =?iso-8859-1?Q?0c4v4TfkGIqpy3d2Wemc7VJNtjtqY8PY7n9u3t7e0Pn2UWu/p3ULTa7GYG?=
 =?iso-8859-1?Q?14j/ggZMjcKGfGoqEPIWoDby9sSZCUoBKC2+VG5Z4IvCkvknU1dyDufFbw?=
 =?iso-8859-1?Q?H4sorCKFzPCMYkq0Aq+Q8will3vogoepo9w1MoQ0/4b7d3vIUJJeWhyMDO?=
 =?iso-8859-1?Q?l5zyiV2Kd0ZaW8w7A+J/M1MuO5ekSwV5JQ0+zFBpaI7wTWPupEifs6aS/r?=
 =?iso-8859-1?Q?Od5fxHfXTZu2MWFgb8QAIkgAvqffdCYtY/t8n7lR/lD+cwkOsWSL55FCKg?=
 =?iso-8859-1?Q?sXJQE5LlONUydi73p7684lC3hLy63Ip1BhevHzKq78Mp3QYBjUUmfkslMu?=
 =?iso-8859-1?Q?vkzb0YpmiJ7J2lYtlecsHDeQqzw4eBmijRfkgVwu6t/R2S2giycw6Pdqfd?=
 =?iso-8859-1?Q?MbeeYlyzXAkhFwJKZNS+SvLdyN2cmiWfQd/qk85qYoq+yhfJyA0JfVrKQ7?=
 =?iso-8859-1?Q?Z1MueZzddNCw0VPMhtdaYsGbH6+3Fb4SbTu2nNYglo9I6B7lsThzHGOUBM?=
 =?iso-8859-1?Q?eGCaB3IcVP3TK5Y14MtomAT0VInKRG1UuU3jbcg3BUfpvP0lK70UrQkJl5?=
 =?iso-8859-1?Q?AkGFA7UQwRx6fe5RVMEulBTG+7WNFvgSPLGVr0W/D23imseRxhxFzFwE1k?=
 =?iso-8859-1?Q?21H8UUSeEPG/VT2iUw7V6r/grLZD3puberUvG0cOKQppMB7EVQwLwvSUSa?=
 =?iso-8859-1?Q?AMm2sWHBIO9JzHQXXsx/YrMIcUtkikSTFXSCjo+5vyRSgkXW1QbvXqN5Yc?=
 =?iso-8859-1?Q?timS8yGcgCJKk=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e692da57-0405-4c67-b750-08dc320d0ba1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2024 12:11:19.0672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fr1TZiiGwCJqTwdKtjO2H08f1+sf2fuRlOtTPVtxQ/7X7qFgIkIYYHsBc1k0m/vmu+aMzwcoxNC8aCBiSXZ7Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8033

>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pc=
i_core.c=0A=
>> index 1cbc990d42e0..c93bea18fc4b 100644=0A=
>> --- a/drivers/vfio/pci/vfio_pci_core.c=0A=
>> +++ b/drivers/vfio/pci/vfio_pci_core.c=0A=
>> @@ -1862,8 +1862,24 @@ int vfio_pci_core_mmap(struct vfio_device *core_v=
dev, struct vm_area_struct *vma=0A=
>>=A0=A0=A0=A0=A0=A0 /*=0A=
>>=A0=A0=A0=A0=A0=A0=A0 * See remap_pfn_range(), called from vfio_pci_fault=
() but we can't=0A=
>>=A0=A0=A0=A0=A0=A0=A0 * change vm_flags within the fault handler.=A0 Set =
them now.=0A=
>> +=A0=A0=A0=A0=A0 *=0A=
>> +=A0=A0=A0=A0=A0 * VM_ALLOW_ANY_UNCACHED: The VMA flag is implemented fo=
r ARM64,=0A=
>> +=A0=A0=A0=A0=A0 * allowing KVM stage 2 device mapping attributes to use=
 Normal-NC=0A=
>> +=A0=A0=A0=A0=A0 * rather than DEVICE_nGnRE, which allows guest mappings=
=0A=
>> +=A0=A0=A0=A0=A0 * supporting combining attributes (WC). ARM does not=0A=
>=0A=
> Nitpick: "supporting write-combining" (if you plan to respin).=0A=
=0A=
Ack.=

