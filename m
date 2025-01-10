Return-Path: <kvm+bounces-35120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CE12A09CE7
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:16:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50B2E3A340B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 21:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E990320967E;
	Fri, 10 Jan 2025 21:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OP/YaxD3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2065.outbound.protection.outlook.com [40.107.102.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8CA20896D;
	Fri, 10 Jan 2025 21:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543759; cv=fail; b=pM8vsDn8W/I9qmhbzhAM4p9h4hIu0eQdYVnwOK+omcOgpo9f55Cx8aOwjRFktcmTgfGXs0F4sLeces+elFEhwugRlVZ2Ez+8mxTfH1lS5Pyh/dPMEqtjl7bTcn+CoJCJFxYtij6Zy5ubdYWf/e8twXsFC+ilmnbEQLrVXxx4h8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543759; c=relaxed/simple;
	bh=yAREwn/49E5+0U1ZKvnogPwAwFJFrHKMvvmO3SAbc/0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G8x071x+kW/0Lp9jCdxh0JFwOL/M9rPaCnDYjvYJ9LocSLy2okjd42pHcLSnceUXK34AIhn4R/CO7bJoPtXAjY20fDpMhgA8F1H3fG0CXeNlDkTJxTiFVSH+qf2zcNrW5lIJjo6bHw1UfuW4duJbJ6a6vrnkTX5XG9ySBHSLbkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OP/YaxD3; arc=fail smtp.client-ip=40.107.102.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VweRW55kZibxKQkdEjrxkFVt3qktuYuBvahfowvUDZx8RQazGaZnQE2eFstLd+uW0Jo6wVKb+DiNcCxXAgHOy8UOTgmvd72C+khbStM3zZHKo3rH1wPT7btCL3ooFWcUqXso+JIIVhBF71QqF4kn6YfwrIHIs2m320UwNkLWHIcG8VGNOibfUrhAPrcHz9kKXLZZd67bBp5N/MVSGmCKIOPZx7v8h8vpk1gyoYri7fRSz7Oz+BAgRlBrJ+d4Oxez0DdQWLAk0CBYcANQmhs+p+myYRcV9DjUkTE1LtCCmU5Z3Dy016cmEEdQLcA0Zki0Frn2EL4BSrmPA6dCfwOG9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAREwn/49E5+0U1ZKvnogPwAwFJFrHKMvvmO3SAbc/0=;
 b=UXUAEIpLESQmpFY9RxuphiiwBvoarDf7kNnWn6y20TUXtTKh+3XbAFOpUUa4/jmPDZVa2XlNrtMXVZyZlw5hEONRIWxTBoxWwUV7Ds6nkZkJ45ncdi4QV0yvQ9IKZAKSWP3EiW6S87pC0P+nuEOIcULD7S6xAhkox9RYN2H4xWkHwCVebKk//eBCp5bdt87bI0ABncn4SQeFBducLlcZ5YCzyf7BSQDinhMHzk6jE4z4k3EFuj8lsPPrlzTmoTlE9MkrH3O4HDfzfz83U1uU/XJmMZnsfgMguBBbd4vvO5zI75M39nNKwWhhFcqYJK9hARfe2D5KsYwwkz31z+l+mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAREwn/49E5+0U1ZKvnogPwAwFJFrHKMvvmO3SAbc/0=;
 b=OP/YaxD3GuchszFv6unA/SHWoW2k8JKw1DVHSDj2qdQ7ckvG4lvTbYZB1SNTsG6yTVSVt9zfJIggymthe/lcf0k+cYlCczzPLJfvCKoBgSM4/69Oo8gAB6xSgvNWhrTkNzVzLQKu9Wxiy92oYF5TqDcCtDUPyDiZOy8/GWSh1oEDMG73ZXhTS1X4IlJTPzo/9j7B9aIzvVbf+DYZe8IOdzv60ho52ao6w9Oei52xJS7Q9r7R0hkR9/YcNYgsHlc4Mm1Bg0g0n7d6WX18LRy+kOMR80x6F1s6Om2yw+lOMyAgKi8eNF+9OYFSp2HIFbD/k1q4wTYRBzE8UavEfpgmsg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS0PR12MB7927.namprd12.prod.outlook.com (2603:10b6:8:147::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Fri, 10 Jan
 2025 21:15:53 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%4]) with mapi id 15.20.8335.010; Fri, 10 Jan 2025
 21:15:53 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
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
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index: AQHbObyY4gofHx3CJE6tGYAUqrUkhLLveBuAgBrLBoCAAxi2gIADd6/9
Date: Fri, 10 Jan 2025 21:15:53 +0000
Message-ID:
 <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
 <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
 <20250106165159.GJ5556@nvidia.com>
 <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
In-Reply-To: <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS0PR12MB7927:EE_
x-ms-office365-filtering-correlation-id: 96ec3086-c664-4a7c-24c6-08dd31bbf734
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?5M/R/jISvg8Q05mnSkmsF9qwpIqg5djl+mBbERHIB+WVXX9jnHwXvVVaIp?=
 =?iso-8859-1?Q?Jp7ALGYoSbeznWHOlTdTFTGJUta+XPQA3ADL/hui68RvbIYl4WxxZmfI6p?=
 =?iso-8859-1?Q?7+gXZ8KPO5mbSc7MUfetoeVfTtK8kcHTsx6ZvlhYkOMj+RuvIv0pBilGOe?=
 =?iso-8859-1?Q?r3g9cvWd9Yr5z9R7mCZkikKyIh8cMl0cZIP9P42rEUdOp0RdMC2JfQ/Hil?=
 =?iso-8859-1?Q?JCr9ihKmpk/mrxplj53barToBNeYeTTtiJx0YwSosGnhDmnCQeBt0huD/N?=
 =?iso-8859-1?Q?UI50ZqA7+rl2JoLoBbe0/AOMUXEot6vAFib8gObA7d8Z7Vqc3c/jbTSo7y?=
 =?iso-8859-1?Q?U9V7C2F0KjxUF5Qgp1zEe20d/0g6x6wjuWAIaN/HcjxliR2ktPVxjOv1oX?=
 =?iso-8859-1?Q?BNTxklFwQM9+cpk5Nsv0ZJbG3oDUOIFNGH64JM66v3mBQgw+IAWwZFQt59?=
 =?iso-8859-1?Q?WQXKUbfTMm+z6A3go7eneP3q9/r+pbiQS3hTuD2bUqSRkrweXeRgnsKuFt?=
 =?iso-8859-1?Q?e4RwN8u+VjnY6N4zNQFiqOeZz64wUGDdaRWIi3+GTj7NKKeEplFS9JEzdP?=
 =?iso-8859-1?Q?uh+ZoKPJoe6gzYSmHMQDD4Iy4fetEkq6QFaL79QMtmdDOz1vahpS40TLFy?=
 =?iso-8859-1?Q?G9duhSQ1WKVPO0j11VZSVDnzkZiKFZXCdSjtTh2oF1A3fBdPLIkpDMJx15?=
 =?iso-8859-1?Q?ZdVs0+MelGBaHv7WIj/DHkqpIPiZSezKDGK/TSi8QpRX1YXpIcmJLntF85?=
 =?iso-8859-1?Q?8BkJqo/Y/ZojMCIecFXTz6CGgIga1CLbXZ4PdaA9FptBIYOZt7P/ho4t2+?=
 =?iso-8859-1?Q?8aY5GSLgyhGT2Bd5IUOem5RBXlHgc4X054J28MAExG+C1/zqZ9gSknlKMR?=
 =?iso-8859-1?Q?Vx7OVBssaV5wVzqhmBqnqHQe6ZjtD7WkL4YlulHd7G8hgeVrgN8UDKwzCQ?=
 =?iso-8859-1?Q?YMGKf/xd4XrGyKLvpiiuFsXu/gHM6lhDANjCvnD16LIQHXjVqQF9RZ5dcn?=
 =?iso-8859-1?Q?mdjm2Q+uJBfoasCGONgCp+PYMMbnKOaeqaKVcDE0P/+Jnp9OHXx4Gf+rO+?=
 =?iso-8859-1?Q?qR+JqYdJUwsAdpCdacAvUsFUm3cLZjltZEowhpcWiHC0HhE92yLap61LaV?=
 =?iso-8859-1?Q?iZ1ijzSHiY79fM7zMfZnNttiJvxBkhK1fol8y2u8DLnmuPmPKIUVfAmqgF?=
 =?iso-8859-1?Q?5PtrrVJivDSq90HPeaENtEAx2uxldtSkLLcmn8mzEPa8JOh61SzfNarY9W?=
 =?iso-8859-1?Q?BWK6TTOlA2YspDwNhd7FAZqUZMSgkCv3gXY11IYXdz/zxlZU71yrsBYg9V?=
 =?iso-8859-1?Q?lcx+yi0fIx66yxPhO/1H8OxVoGpv+UpjiJL/P1NT7sJSVU0TorCRyoUoen?=
 =?iso-8859-1?Q?Ei1QuxG7t9ylMh0dyQynoDuQ50Peodz3oAys0Hhea6/0mKbFQi2URvkSQ8?=
 =?iso-8859-1?Q?23UoquC9Qp0y//E6oVJLxZNhC+C1GwaHQ9LTAV+tvH/WyioDXxJUTTNDPc?=
 =?iso-8859-1?Q?4vQj266FuhWsmRUgzdUIm0?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?VXj9w+WD9+uk6L62OY+j1mvCfnTWXrYLHODnIn0IJZ1ta5n3XIJ8X/ZjXe?=
 =?iso-8859-1?Q?zL76L7KHtHBpQZyEwI/uUf8K5p0hbQRb2P9MyzAqTqJdBYWdqQgAuhG7Of?=
 =?iso-8859-1?Q?DWvsvJgsHLbbtaA3bPxRgiTLSdU0afo4OVYl4YSP5DWUAdrwC5rr4YF3UC?=
 =?iso-8859-1?Q?w8KxJzbpzJBq9/akVobpnwo61zcX0A4F3zJD9+NjTRPTf5vce1QZM2ON2D?=
 =?iso-8859-1?Q?DX/Ic6bdvCL56S2U/od0ADN9xsGuN4DkmcGE6umYALRwNutR4SWLPsDJSS?=
 =?iso-8859-1?Q?V90f1w3/3gv5aEvbYRrM44wkJDQXHLtS5pPg5rHzRkas1+Fhu//AtirSDy?=
 =?iso-8859-1?Q?+wqGKhK4QdsVzDv6XE8H4Li2SBM4q5jOt+jVJqkyEufHQYUo5v40zZAx7r?=
 =?iso-8859-1?Q?0suiFJF5bZN8OCWfpHP7d0KwvrFhpJo9oG+2dYYLZxSv9Ds3ctHBm/ldGQ?=
 =?iso-8859-1?Q?++uqtRBVWFBNAYgsOid+Pp57Vqhq5omd0fMIofMVgreyGRcb0UylvlXeeT?=
 =?iso-8859-1?Q?DoQwZAiyJuzgeIfOsXM8jOur8hDIKgfXEAJSrKbgL18/bU44nsUZLz+c86?=
 =?iso-8859-1?Q?14yjmG5ecokUkSDITxzTindwXVQwCE9R02hAVB1Ogdb5sdAu7rZfv9PO4Y?=
 =?iso-8859-1?Q?37KGc3xpDFA2INeCjyluSlxRK8E4MOELIPzgg6QoT8sN2x/l7hFXd5bYJU?=
 =?iso-8859-1?Q?pMdd4pDCC+r/FNcjZN4a185lhIFlaEhTK4Jlr6gw8sxt8d9RxLxIvz2wmz?=
 =?iso-8859-1?Q?u1DReViuM/lH4MtzgD2X1y8PjtPVnhsMxrYdKpTp6C5YZQLM0E20PrzL+H?=
 =?iso-8859-1?Q?iFRQqoCLn4MQuwONkzyImn6QGV/QPfxtfdOVAZBcA6sikWpX9cqjaDJ+3O?=
 =?iso-8859-1?Q?BKuRSODpkAEBKc1TDXgBm/YmS4YRom1Is8QtKP/LOANkHVWCC2aaBJRdXu?=
 =?iso-8859-1?Q?FUXKMVBpupYbk124ki1x9sqTO/yu9NJ4njhhWvhPNrG+kfqLn3cPsQXR3b?=
 =?iso-8859-1?Q?KZlA6JVX9cLI/AP1XKDs+rLsn7ko+n8MsVM9/Bpcjnp3Z2ttqn3L635Yw5?=
 =?iso-8859-1?Q?TMGHiL45f0FwN9f51j1/bQ3RYcItuI3YfzvHArdug61sZqA76BPT/rtDmM?=
 =?iso-8859-1?Q?GGx7Kx2lgv08DMSmARD5WmU4OYpkXAjFlJtJl494kCBofLRgzJsFVi24Ul?=
 =?iso-8859-1?Q?vH2XfPGu+4K78fuc166f1EJLdZ/I9cTv3JX81rvoBFNKUsFIRfnNcixNDk?=
 =?iso-8859-1?Q?PYfJHjlXFko1fW/v3crlaPoCOtBXJxfnd7cKRQAqtyM79oNYsRgoXJi81p?=
 =?iso-8859-1?Q?AvsvGKjFhrUGiEf5nR/cuocwo0WA/jWV4IzxPDE26uz9TZPdMxtaiFX8cw?=
 =?iso-8859-1?Q?8htFCjouZBMGwjoxhJo0loWpeyKCWkx+p39f2N0v9Cm/IrlWFpM/l+a+WK?=
 =?iso-8859-1?Q?lep2rq/lfDQhvQRjUPvoIsyYA3h8fXm288VViRaQnXrdqylhNH6p6uCorQ?=
 =?iso-8859-1?Q?fNMbNakEtGXr5M2mv+Les55qm1Tv5CnUkXjcRU/oXGc3Zicq5Nlm3nnHY+?=
 =?iso-8859-1?Q?pomEemcfPJRwJpo+k4g4AHCCERXK+MvK9JpKl+7w8twuPppPo0Pw18cTzd?=
 =?iso-8859-1?Q?2tnb4Zbv2P900=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ec3086-c664-4a7c-24c6-08dd31bbf734
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2025 21:15:53.1973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9LCpjPbwljMkvarmOw2u76xxl4jWke8K0qcdCL+hRLBiBrJV6uBGrL2D2Zj8bv1d9aBpmPG/eOQB3f1hYkfXfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7927

>>>> This patch solves the problems where it is possible for the kernel to=
=0A=
>>>> have VMAs pointing at cachable memory without causing=0A=
>>>> pfn_is_map_memory() to be true, eg DAX memremap cases and CXL/pre-CXL=
=0A=
>>>> devices. This memory is now properly marked as cachable in KVM.=0A=
>>>=0A=
>>> Does this only imply in worse performance, or does this also affect=0A=
>>> correctness? I suspect performance is the problem, correct?=0A=
>>=0A=
>> Correctness. Things like atomics don't work on non-cachable mappings.=0A=
>=0A=
> Hah! This needs to be highlighted in the patch description. And maybe=0A=
> this even implies Fixes: etc?=0A=
=0A=
Understood. I'll put that in the patch description.=0A=
=0A=
>>> Likely you assume to never end up with COW VM_PFNMAP -- I think it's=0A=
>>> possible when doing a MAP_PRIVATE /dev/mem mapping on systems that allo=
w=0A=
>>> for mapping /dev/mem. Maybe one could just reject such cases (if KVM PF=
N=0A=
>>> lookup code not already rejects them, which might just be that case IIR=
C).=0A=
>>=0A=
>> At least VFIO enforces SHARED or it won't create the VMA.=0A=
>>=0A=
>> drivers/vfio/pci/vfio_pci_core.c:=A0=A0=A0=A0=A0=A0 if ((vma->vm_flags &=
 VM_SHARED) =3D=3D 0)=0A=
>=0A=
> That makes a lot of sense for VFIO.=0A=
=0A=
So, I suppose we don't need to check this? Specially if we only extend the=
=0A=
changes to the following case:=0A=
- type is VM_PFNMAP &&=0A=
- user mapping is cacheable (MT_NORMAL or MT_NORMAL_TAGGED) &&=0A=
- The suggested VM_FORCE_CACHED is set.=0A=
=0A=
- Ankit Agrawal=

