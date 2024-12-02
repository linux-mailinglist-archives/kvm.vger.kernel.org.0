Return-Path: <kvm+bounces-32807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2738D9DFA09
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 05:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A6CEB21B65
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 04:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062B41E231C;
	Mon,  2 Dec 2024 04:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O/E4J9Fs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018DE2A1CA;
	Mon,  2 Dec 2024 04:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733115068; cv=fail; b=B43nR/Ux+iNle39RL5Vcgk3iPgXVW2vTxEzFGWsHmWiIDJnOowhqqHwbRZehtETV+ulIAfbimf7rrJeHN6kyDnYX51uKn3Xc1N3QfYmWdFb/BqtbiYSJCTsioAdU2zoPvClHlNkvVIA40lA8V8820xUnyyC11lcpAYyunlgaQ4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733115068; c=relaxed/simple;
	bh=FgUl1rOohwmTZLHxcH4mY2Pdr7lA9lpBCGOnoYWFoB4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=muP/hmsy4UvF/Q+5YunqO2S42Sc0LlXIN0XJ7t9Lq4pvCx29OG6rx3vTNpwo1Joswp/L4ijKcpm31YcLW5gy2ud2xTGoIiYmZ0wfwCL5hwteh9XHJvIhKGea0Bbw53fDqSrv99ptJx8/xDRo6s3z9F1R3XoPbuAitBDZZ3G8v9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O/E4J9Fs; arc=fail smtp.client-ip=40.107.95.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykIpJkQsrUL6SjrY9KtRh0PuZr+Aq8nDXulQ5OD4oVkZOHNbRNtBcBYu/dRrI5Fx0/V+6T4qW47macDw09MM7v8md9xB5F63uSQpDZDVcOAx9OLT53xtLB1GTFfdcIJA7ZgecRIpVQOIsuTHhZynRNVFV/DsJbi9VZDKmbXe7vvBQ9zEj3xCIPrqqF6XIkov1A8nJEFlVnfBZtYrFk0+tgNItycf/DLxsEa+CuQSNMNOslkUaYDfKMCXsxbg0DQcC95W3nnRVpN/9bInRnTKorZX/OD0kzeSYZYOpUTHxFsOg4k5JEdgylNMAx7R6xax2AqbbGS23fExd/YGk3W9hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FgUl1rOohwmTZLHxcH4mY2Pdr7lA9lpBCGOnoYWFoB4=;
 b=eDjHaFMQ/S+/MNbl515to898TpzzhbAndnRfGXEIuAnqU/5OfnJ5HITmbYez3qeEr+/kZv/XqybyqC5IXzWROrfBRFpE/JcrI+QtIV9KZrWDyGPjXpi8hd3+2qehhX71fDZfHtCNWqC8LGSn34FqVtKvEJsAnggJa7+cTPZbqnqoQeoVIm4HUEVbW1AAXLiFmCJrBMGViBBQOOUHJzL0vJr3J2wDxBlAY4kdw+0jfN6g7mDPdCUBGS0n1f11lzVli9qBj6ggxOCbRJLOGJfpYuRB/Yn3CAWl4Z2b7gtp8Rh3kXbWKVC6C7GAkU538+ev8eG1xcWFboxD4jluTQCfFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgUl1rOohwmTZLHxcH4mY2Pdr7lA9lpBCGOnoYWFoB4=;
 b=O/E4J9FsJVYcRUBCa/lXAZy5Fa6i51ubp7CP3rSsEKUpyohlpgi5gOWmJ0dpIHvgiLbMt/Z5y+omUtZi1kaRVfpukfadXKK0sN4yPD8PKJNQydxdKO7QqqYdrMp351iDHgY72r1/aClI+9UrEeZ3wphDetur1NPzE9/cRZ2ChtNi1cUbLs0DFuRdeWLdi3JR55P91vMKWxUKK0ZGhX6usqQuhmwJtSmNUmtx2NYfSGP9pSAjOKdChBdapmNUFGe6lqbC8SewSZaDxs0kNmtsOkaFZIJWitbxwr5gl+0+Vw0vzUvonlTLXya7T4/ansZavmxzgbtr4rwpUMgOr8VwRA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CY8PR12MB7755.namprd12.prod.outlook.com (2603:10b6:930:87::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Mon, 2 Dec
 2024 04:51:02 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8207.014; Mon, 2 Dec 2024
 04:51:02 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Zhi Wang
	<zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com"
	<coltonlewis@google.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
Thread-Topic: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
Thread-Index: AQHbObyXz5FE7VYSKUOn3d6sXZJ1xbLJ2LAAgAidLGM=
Date: Mon, 2 Dec 2024 04:51:02 +0000
Message-ID:
 <SA1PR12MB7199EA7300F9F1C5D3505C0EB0352@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <07252361-8886-4284-bdba-55c3fe728831@redhat.com>
In-Reply-To: <07252361-8886-4284-bdba-55c3fe728831@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CY8PR12MB7755:EE_
x-ms-office365-filtering-correlation-id: 302475e0-310b-482e-2d5d-08dd128cec4b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?H+PdR5UGRoz9KfpGvCjEFJyUMQNTGbPAPpOaW7QwQLz7j+qO1zhZ268cos?=
 =?iso-8859-1?Q?fWMc3g9uRsrKMkwscrNJs5yKXwlyJ9zdNWFQmF7vqNASvnvLvJo3SKLHTN?=
 =?iso-8859-1?Q?Ypmruw79Ph4scv3pNbBKbLKdAAuf6h6DocoJsFiJTRsFt06DKyr68UY5tW?=
 =?iso-8859-1?Q?UvkJeSklscJHM30ztYCxRGy+Kdp9OgxHxNdQp4/GxXFlcwBKuzMOzYh6y0?=
 =?iso-8859-1?Q?6yJ2PEOmWF51+3cQwOZ4QpwfhHe4AECSjpltwzlNIHiWiMrgncORC2V9ZF?=
 =?iso-8859-1?Q?Y/GPnGsKUr+B/jGhLJkZufr1wxAz8Ed9qi+sarEQYNJwl5H45yY1m4vu0M?=
 =?iso-8859-1?Q?Z2AddLv+wsqw2d4M2s5ylzLL0JLM1f/ytoMeTegWad8wPsaB00gGozz6OJ?=
 =?iso-8859-1?Q?LHfhFolfF2IhOPaJPYmC0tjrfF2jo+IdxTkOts2RHU5VRWwvLvSWxGUPMD?=
 =?iso-8859-1?Q?WIBRwCoVixVMIi9ayHHUEAI5nrUqY2S+G56XiXoJ7klkOXzbaHfmfQ6pAq?=
 =?iso-8859-1?Q?r8VTzhqYelU2oZdfXxGskQq5vzLE3P42F+XY4rSigSxbZV0f8MP3U9kt7b?=
 =?iso-8859-1?Q?V5YHfwDwaTbnCGr61moLiLpLPfUbHlic04m0QT7VwCntCpVWDRVtuQ7VHQ?=
 =?iso-8859-1?Q?nL6PMiUlQAvK/DyTfjL3HZE82aGv/TOEyytKpwkbkqOcxVJGKt9pTsadFJ?=
 =?iso-8859-1?Q?R0TcJVHPHHJVUJU0rfcVQ97J6Fkw+gpNeFz6J3PCC4BDT53fdwzpfwirTC?=
 =?iso-8859-1?Q?AslVGSVzfUziFQwPej7+xAeSbtROFyA4AA4XLOaA9jlgIwQSCrIQ3E+vyb?=
 =?iso-8859-1?Q?NndM5S/Y2jpjFORMwKxylJeu8pwh6HL4OInmOzuwzarLTQhIpYG8YBald5?=
 =?iso-8859-1?Q?ridiFcKqPatilp/xgYl3eOFbsxI2wceGXQ6DGtuPxAH51KHCu9Uww1Mklt?=
 =?iso-8859-1?Q?aMuExjK2tCq/7PXU+Buw5am0X6HFz2aHRc3Y/i0Bzu8DuAnpp6n5d4gmVu?=
 =?iso-8859-1?Q?YVPcDT4amQReuVFm5J225u1yVYp6Cb2wJSj820jLhFqCiDG57QAvedFxQc?=
 =?iso-8859-1?Q?2+euPmqJopWb/k2toa74sW7GCLcT4qiQ9+ayth/aHuLmKXTTr3SISELAEm?=
 =?iso-8859-1?Q?3MPrxMWE59vxR3OBvhXAXvHSbSPo0llrp+IBeT8f2wpO2ghw4We1G4yz4K?=
 =?iso-8859-1?Q?5dOwPnAHyTAnbT+FGuu3ufLctZN5ZrTRTxLYAE/Q/IJp9F8KoUROuloa9x?=
 =?iso-8859-1?Q?DpiRKDigkbJNWi+JHz/J7+5+sIFTNPz4v8tWMQhP5ODiSNEbEGhPYaYk6w?=
 =?iso-8859-1?Q?xCmQ+4AqIAGJlkKgVZJ6LYoE5aqlhZ+k7ts53DTiQWLSuyArO+qSuFHgm+?=
 =?iso-8859-1?Q?y/49gxC9J55m6zZWH+x47NHVHfp32MN3KNscOPuGRAX9KOb2IlZSZJl77/?=
 =?iso-8859-1?Q?2M28KPZtzZJc82c2v0e1UjzjOfG9GfbOSSXPsIW4/FZkrZ+dOo9/D/X63H?=
 =?iso-8859-1?Q?A=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?/ZF/nbErG7c0ztO66Gde3FbsauPmYCqOa2F/oj/5sijS33vZJS3QysmAlB?=
 =?iso-8859-1?Q?R0caeDinKZEY4qDQafqFCFK7Y51ynEsfwMp9YEdM9pHC29ADQPghk052Vy?=
 =?iso-8859-1?Q?n+MdHTDCqt+cVobnE3QDWcVO42CrKtRxRNfhsIadQ0iH8vRGFBhfa/xATu?=
 =?iso-8859-1?Q?NJbd/w03oYoBI4DA0IIRowezJejTF9/F2kJAjG2K8Q8pD5yevmB/oLUDKh?=
 =?iso-8859-1?Q?Szdgc7aREP1CJ6EqindbnLltOuU+xZu20sv82tAX3STkWaHxgH47HpEnRC?=
 =?iso-8859-1?Q?XCX2ogkIycx0zmFmZ1+g+SgxvawqtK/hVfC14BJsGRw8Zcxkzl8tEy963T?=
 =?iso-8859-1?Q?PY7A+lXNfblLDZRVHb9AUEw0Y+W6PwxkosjvZRmsdux/29w92h2AtiWD1I?=
 =?iso-8859-1?Q?SPyt7eC6a+aP/ThJn2yu+ohN6kW0GKHhLEBlfLnhsQt4X0UR/ZkyRuNw5d?=
 =?iso-8859-1?Q?Bpi8AI9nZ6Hy81aPrDySWc1GT8545Wra8Lg1wavdudByCufzOEUybA5vqG?=
 =?iso-8859-1?Q?R3fSRSXqByVyhpN/U2TZFvK7Qh4Nnhy7tWYjmJ1B7Uq8MNuE3RnYwHrXLj?=
 =?iso-8859-1?Q?Cd3Se4EYtX4ZmO+4FIGHA+3cwU6aRw7f8/SeHYiRPnFtg70JqFo+mllVeL?=
 =?iso-8859-1?Q?Wnh6IuxxCCo0KxY8v2+Omtlvpiy0dz66YIVpjq5MMXkX6c7p04DGaImwnz?=
 =?iso-8859-1?Q?0TFlYiEz2inIK8zhLWYR4k2naqrGohdeiuGD2b/oDu5CimEFKxDrJG9Ur3?=
 =?iso-8859-1?Q?RlopJiy3vpINQoziN0tWF72+TpgBf3YkgY7ytQzeejKBhAotjRDu7QteNI?=
 =?iso-8859-1?Q?ZCFn8ZnJvFoKvpvTkFyjSnmrGjWWAGELQ0DHTb9Mdr07ZKIFUl+M9B11oR?=
 =?iso-8859-1?Q?igpczp3tftkuEifsKyUfvbozizr2sFz85LAlI+93I5TaE8WEJg/4xlAfwT?=
 =?iso-8859-1?Q?ds2fl4bFlyg2Huin1nhe5bVXGrC3iSrXDYaF8Z/F55HwZIJgcoovcwnpZG?=
 =?iso-8859-1?Q?w9JFCJbDvGkA8/t22q47Pp2ge0GSXieJgevguQo7UG8VI9kW1776WPibE6?=
 =?iso-8859-1?Q?F5GBBsZBDJ2F/wZw1V+dJdRvzDog9Xv5Ro+E/DpteXC3tvgubJZ3jN9Kku?=
 =?iso-8859-1?Q?XwV0DKwa9kmQMNlUXpnxsd3lqKjKTQ6Yx0nrIhkBdZc1PiEEzzw/6lfxmh?=
 =?iso-8859-1?Q?mRlZiQ3p4JbYLi2HHzeFb7OSHAkicUPYMnpl7g5JXaulOTp0nzOsCqEoIT?=
 =?iso-8859-1?Q?9XM9IMwbac3CfZvg9VzgCUPIqlgPnZ54TJbVmPoGNHpXsZM5j8LtnjDQRU?=
 =?iso-8859-1?Q?QLM3jV45QZqsCekclME8g8sopQVMj6yOWrsVsYtnrVDggNjsef9QS0T9PQ?=
 =?iso-8859-1?Q?IPQl4CdkXJaFh1N5AvJ91ECecge5LBp07bCEiUUYzDT3Iv8q5nMreh2tGb?=
 =?iso-8859-1?Q?kN18GgdIN+Py1JRLnlbBOwO67I+K5obZp0KLGL9p9Z4H0AFAebhbCs1FP4?=
 =?iso-8859-1?Q?0Wj95W4A7d2Y1OSX1CMOCrrHzTYefy5Va9154MgvFWVraqEBijEBSTye4x?=
 =?iso-8859-1?Q?/cBu8C6HBMOL3knt0JBi/PMrVrex0z11AXGrE06YRn6S2phLW38Gq4OwCc?=
 =?iso-8859-1?Q?kuo6Y5fSHE/JM=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 302475e0-310b-482e-2d5d-08dd128cec4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2024 04:51:02.5177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /BLBc9V0hM2gxb7UT6w6rqZE9AzkDmzeruEGWu4uGqM8dT8WXDhVGNVTzNk5A8mhhWLp0vrXrPCtzi0nBqC/JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7755

Thanks Don.=0A=
=0A=
> My email client says this patch: [PATCH v2 1/1] KVM: arm64: Allow cacheab=
le stage 2 mapping using VMA flags=0A=
> =A0=A0 is part of a thread for this titled patchPATCH.=A0 Is it?=0A=
=0A=
Those are supposed to be 2 different patches (0/1 being the cover letter, 1=
/1 the primary patch).=0A=
=0A=
> So, could you clean these two up into (a) a series, or (b) single, separa=
te PATCH's?=0A=
=0A=
Yeah, I'll send it as a patch with a cover letter in a series when I send t=
he next version.=0A=
=0A=
=0A=

