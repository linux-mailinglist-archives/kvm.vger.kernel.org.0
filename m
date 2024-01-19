Return-Path: <kvm+bounces-6460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 439018323D5
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 04:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 683EE1C2373B
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 03:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327244689;
	Fri, 19 Jan 2024 03:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pdtl9Tvj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C7A1FA6;
	Fri, 19 Jan 2024 03:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705635249; cv=fail; b=Oo7+1D5X5ZukBPGXqfhWm98/0SOoi1TCn14qtcH7dI5qnupjs5vuXW/GW0tcND4AmSsqTfeUTDzo2wmIYwZ2cRdbz4viCTdsWvpObSVdRrIL6SuoiZX17YZeJxyLGoD1CqXZizDUpoVDiL6iDiRBU+Pw/p+2P5zNDAsedRytF60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705635249; c=relaxed/simple;
	bh=gGlnFB8USJL2CpiqGeV+AF79aPCggoeDwBXm7BLp6LA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RhMsEvRbH6u140UQLV2o1mcPzlxvBfat7x8XecAQL6R6bsJFweRS44901zguRL9dTcM0vV03RdLtcFuYzYM9jZWC74v2q/bxiBaK+BJpeN2GXqaWjfbZMCy0V1eyUgEFy07VUIi4tjeerVSBc6Q7556ydTxeuRtOW8oX1HJbAJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pdtl9Tvj; arc=fail smtp.client-ip=40.107.94.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lisLPLJwrSZJDxCge+zAk4Nzu+3dWxTuDqGbkcbiM/nGVqSybskNFaFGixqQxxi8W0pOPpqMaxwuVBXb6UllSqips8h+DlprXhh+f0r0sw6xiKqMg5mMgFm5bxTZACUDumCZhc91KfwoCl9bD8oCVyrCp0Bj9bxdbZ4Cd/4wknLq7PtsZPBZQR5nqMJGPHLa53fzFMJ99FWAH7btS1V00hpYmM80LIANvqEK/I5jAnyhKFnv8OLYT8MGND3RMRSwIXR1HFinJY2Dvyx/BWXHk5xcrl/ZcUzIs5G9qzQyLch7ijm9h4g4k2/uojdoW8NYrFzOv47gOdsY5zyoY2z64Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGlnFB8USJL2CpiqGeV+AF79aPCggoeDwBXm7BLp6LA=;
 b=PJOjjJZQN3ZsuEAb6lLQl9vlnChqi2YRwZpq3k0mb6ksGA/kLPwBILmwxo660F6KdiNfQ5XHBqY6wvw3qKrGlvqG7fV54WlyAV5RU36Gzm+3r4GJCXM3UChivnjh0xDSu6PdeeGWljFktwnAD2w6cf0/oau7iqQHKEzuCXUjB1vpen0+DSIcJ9mBv2qwPXHKWhyfZUoAmHDWjlNbCkiORF/Vu/sZ//D9ZgYFAM8CSpsAbYRL11Bd1e2stsbfa4u4CyACWW3VSV89MFiiOEypqA6MGvzZHQ6Z4KZxmx2jqDYSLTe0AC7YwC6BmWEgM+ysJ24rtM2pOVxpTZ+b0PWWQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGlnFB8USJL2CpiqGeV+AF79aPCggoeDwBXm7BLp6LA=;
 b=pdtl9Tvj50OYc1P7NCsc7ekQh/PNgZ6N2j6cnQJ+b1Swa/7GFQxMvRWSLk7+u5LYIUZRjXszsO4b/GncFCapWTjT38DACgcowG3j/FL24+TiDxShay04/M5JuPE/LTZvgcNtN9CXyG3iFAZ0z4fhFryavRvGuw6DbjY2eK0iL7SMhmJVNbIwsTLrICZO4p84cuDO01ANCVbmVgfMeO1um9T6W5z1OsGHk4X+7e5dkicy8cfEjLqXCstm0ZWXCgXdDqLv2y927KOx4TiSw7KPJtyBsc+4BpxKKm803wXX/9DUwTQ+/MFG/gACDoOlUxkX5sOZ0SRHGji74TarYqy3jw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Fri, 19 Jan
 2024 03:34:04 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d%7]) with mapi id 15.20.7202.024; Fri, 19 Jan 2024
 03:34:04 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"brett.creeley@amd.com" <brett.creeley@amd.com>, "horms@kernel.org"
	<horms@kernel.org>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v16 2/3] vfio/pci: implement range_intesect_range to
 determine range overlap
Thread-Topic: [PATCH v16 2/3] vfio/pci: implement range_intesect_range to
 determine range overlap
Thread-Index: AQHaR/f+hq/WnUlfoUWt4169ze8Rb7DeiekAgAHl30o=
Date: Fri, 19 Jan 2024 03:34:04 +0000
Message-ID:
 <SA1PR12MB7199D0108377FDC8AD4671E3B0702@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240115211516.635852-1-ankita@nvidia.com>
	<20240115211516.635852-3-ankita@nvidia.com>
 <20240117143418.5696b00e.alex.williamson@redhat.com>
In-Reply-To: <20240117143418.5696b00e.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|PH7PR12MB5805:EE_
x-ms-office365-filtering-correlation-id: 49d18cc8-2626-4b48-9750-08dc189f7c6b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 VBPhn1rDY+0aVjFRfrK53WXiYo6Xl3zQCS3SI7erjxG2aTbxmPfI1egIwz9v6jmM7pgELt8pUl5ORArr9Ay7dBVwnzkGLQeWp+MpEDjLvr5RhByqiyQOjCkxr26gDMa8RlxAIRdPgWAVwPk9UsM+HfUJbGu4ztl8OsdpNr7yA/qT+s4JfrGPgQBMn5Ngo/o4//jnc1ngk/1gjUcCgfujaQ44cNwL4Z1Qa0ugzvLuX6kCr6/H9EX/BAeO1BrA51iGYBPXSQ9pqOdB/F/z9YLlOZMbORaiwFk2SgDzu/lPN7zNuB9nuCVOMewjaujKp3H9JIKcb28IFGpcIEfJ9xabyMaVpk+j3qggpw3/Pe4ME9JQCVl+5gE6jAKvo0kZ5G4DMHih8mxVK0UiTYtYA56d/j28jNNGUIdSd/sWoisixk5DYoarQXUYALI42GIiW8fq3gEepcfK4kjie1Yauyh5g1tJ1/Y1hg338p47dBEP3RFnJJ9gP5JsfONp6Q9dN3OkbBOp3uLi2cVK1tSxUz/nLmaPRsztdBVHH2amr1Bh0vXu2TwrP71jxTwmD+MoWjL40TjxyuNSmnJEk0Pf3x6aebZ3zEO41WhWDgSenRzW6iB5ItzPtjCgNrpa67ckgdOWxsEc4bUOCZHA3g6gFE5NRg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(346002)(39860400002)(396003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(55016003)(83380400001)(38070700009)(33656002)(86362001)(316002)(5660300002)(26005)(9686003)(122000001)(4326008)(8936002)(478600001)(91956017)(966005)(66946007)(8676002)(7696005)(71200400001)(66446008)(54906003)(66556008)(76116006)(6916009)(64756008)(38100700002)(66476007)(41300700001)(6506007)(2906002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?JGB2l8J6z3X6uIkCtD/JR46rcIjo9EXNVIq5LxTddnwx9s+jb8rofDBqDg?=
 =?iso-8859-1?Q?860HfXL0GCp8EagC7+AyxkKbrJH3TMeDcEYxrpm0zY18/uHGNq+pXEIoe6?=
 =?iso-8859-1?Q?PWJPBZa7/jTLPLtPdoE0104FfeLEbTG8eF6gjqYtKJ7wdixHDeSZ5CI7jL?=
 =?iso-8859-1?Q?GBgyQGMkM8vlR7VhkiEVF2/QYbkusIKd9RzSAOLbwXEQyijzu2QHyvOJ4m?=
 =?iso-8859-1?Q?8/+YytqUpdymBC+/HdE+ZvybXMzORg4rT13p+9U5FhsahpJFWH42CuzSwJ?=
 =?iso-8859-1?Q?bpxjoP6J8DUvcH/zn3dOoFbWPlHiRl3DmLNUVhyDi7oVM/+R/O0a2k3/mK?=
 =?iso-8859-1?Q?WkftgOSEBoiTmsOpGNYJkE7LNBCYjOVEAZHcL4jvM0X3D5lgkHeD8UiGnk?=
 =?iso-8859-1?Q?szE9rXz535RnMzGUeVqfm5tyHIYU7lNG6ZS1kmLmVXi6KAnW5gY9Vpsqkq?=
 =?iso-8859-1?Q?RPu1ue9NjXlk3KjHaEB/gouupIMbfdEIAWiYG9QExA/sg0XjtHlFjP/7Mu?=
 =?iso-8859-1?Q?rsrIlrRtrUhA3qOMOJn8B2STj0upTlHUGsBYdTvxlcmmBB3QITZOxJ06PC?=
 =?iso-8859-1?Q?sL9LBThR1zXURjsfoJj2KmZvr00iMQlVQa5J6jBix0BsyaSfvQ1AYu0tiP?=
 =?iso-8859-1?Q?IcgWgAkGfRys3VINFhdxpuuxywZzeoMw37Vcb2BZLfTtZN92ILKduP47ZK?=
 =?iso-8859-1?Q?bhWDxXHo1WvkwMx7FjAOeyBAwQRoAWIZl62oXsqR4qK501IHB0AFkCV5dN?=
 =?iso-8859-1?Q?S9LxW7ksUpB1x0alFP12u6Pm8LuYURO+VuipRpXBDcnvXQYXfNSllt4OMG?=
 =?iso-8859-1?Q?tSJfJdFEYXjms29EBngox6mvcbf1dXtHnO781fx9Mo1ziKvOPA5uYRRZwh?=
 =?iso-8859-1?Q?KNy+gNWsOAg+X481wx7AgdCzRpTDKhl4fj9dzY9cV2nvthfRH4BEud2rus?=
 =?iso-8859-1?Q?GHTbkJpmAi+9f9cV+sz4l8DXQtaWuzsYI5iLsF1U0Jq2R+VG6Z+XgoMGGf?=
 =?iso-8859-1?Q?FzbsztZLmP4vGU5NclKLayR2P70GKgzeB5xLkYc/64rkAfXI0OJZNLAUVC?=
 =?iso-8859-1?Q?6/G8dzd0LXWGbk707+SLn61bwdQ/K6C6XVR3iy//q4AmoRp5WHZZ36h+sm?=
 =?iso-8859-1?Q?7OfrWcec/LzWMp076DQtS0PwmXSxX88CT0qHh+BVA53+RAcL+uCnL1CBak?=
 =?iso-8859-1?Q?ZSYLaCU9IcZaWKSnBA+69vaBbX7gAhGdwtfKAMZfRxo22Fj7CTmZhxAFtL?=
 =?iso-8859-1?Q?N1fp57XPcHu6hywceLJsmnRiu/jgE19KwQOXiqMB5sHHIpvpgRtkNsxmVS?=
 =?iso-8859-1?Q?LePQXFxx+e367aBm0NPspHWv/hStRfCz1iZOatpvuNP39M+a0niB15AMvW?=
 =?iso-8859-1?Q?FzQxvlvCCSkhri5x85lxFOyud2CZVZAp/94k5dqaUswOdzqUhwVzqFf7wK?=
 =?iso-8859-1?Q?L+X+WIVPcLTBvEVXwQG9xEfhnT5eW3zNCujw5NKI1DkJ/sbuElv1bxpbas?=
 =?iso-8859-1?Q?3wL5tIh2cbYoJ55x0fic64NWA/Wdk9VuJvs4Gdc67FdkOTCQgXLojGe8EA?=
 =?iso-8859-1?Q?Le04E48UsFX/tk+olDBqpzQ+XC4/3BAvFYiMjaC5PVEkDCwgb80eskw5YL?=
 =?iso-8859-1?Q?+XFHp8X2Hf4fg=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d18cc8-2626-4b48-9750-08dc189f7c6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2024 03:34:04.5878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FkCN1zH273F+kUQ4GtxzYcl9FJlelllU/txyRZ/d/4oUtjkaaedLgOR9hF6BNTb0l6r733M7OmzHCchtc21qJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5805

=0A=
>> Add a helper function to determine an overlap between two ranges.=0A=
>> If an overlap, the function returns the overlapping offset and size.=0A=
>>=0A=
>> The VFIO PCI variant driver emulates the PCI config space BAR offset=0A=
>> registers. These offset may be accessed for read/write with a variety=0A=
>> of lengths including sub-word sizes from sub-word offsets. The driver=0A=
>> makes use of this helper function to read/write the targeted part of=0A=
>> the emulated register.=0A=
>>=0A=
>> This is replicated from Yishai's work in=0A=
>> https://lore.kernel.org/all/20231207102820.74820-10-yishaih@nvidia.com=
=0A=
>=0A=
> The virtio-vfio-net changes have been accepted, so this will need to be=
=0A=
> rebased on the vfio next branch or v6.8-rc1 when Linus comes back=0A=
> online to process the pull request.=A0 The revised patch should=0A=
> consolidate so that virtio-vfio-pci also uses the new shared function.=0A=
=0A=
Thanks for pointing that out. I'll rebase it with v6.8-rc1.=0A=
=0A=
> As noted by Rahul, the name should be updated to align with the=0A=
> vfio-pci-core namespace.=A0 Kerneldoc would also be a nice addition since=
=0A=
> this is a somewhat complicated helper.=A0 Thanks,=0A=
=0A=
Ack.=0A=

