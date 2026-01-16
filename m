Return-Path: <kvm+bounces-68325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C81A4D333B0
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 48F3D30C77FB
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1CF33A03D;
	Fri, 16 Jan 2026 15:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia.com header.i=@nokia.com header.b="OD5o8gVh"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012033.outbound.protection.outlook.com [40.107.200.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4C533A038;
	Fri, 16 Jan 2026 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768577493; cv=fail; b=B4zEEcMDKRN+A3arSkkwD2185dkOhiXegS2nmY8Ntb/hRNVDJfhCBAf/NPJRMSL1I3A8eD7hhs/VEnY1HaJaIZmzN7zbqKxDc42XpSb4hQVvg9e4l2AxYhDTUhz+Jez61e3eLXgWsyLALreExt0QADTJYsJSka3bveXUBav+Ay4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768577493; c=relaxed/simple;
	bh=U17Z1HRyQq0QwplordLyhCTgKY+JE/mVfcnSMNKFBxg=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=FbBlxwFC53fVgHuO6pBWNa/dstaUej4Ua3cnq9Vf5az7UcADJ01SC2GLPSQ6j0isylOvkMqXyZLraweoVNkoxc2ELOzmj07zyCmqgWMUJjxgz+wsoyDLGyOIP5EBldH217s2qjwE0ZSJiSHFayxP5ih1sfVhAIttocD+1Ci5JhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia.com; spf=fail smtp.mailfrom=nokia.com; dkim=pass (2048-bit key) header.d=nokia.com header.i=@nokia.com header.b=OD5o8gVh; arc=fail smtp.client-ip=40.107.200.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AEWNb8sNmInCIYx/gcG5xJt9Hx3Pu+imsdquzaXQnARhIgxoCyun0/MgO71hF+hDLD3UW4r1f9crfs+99C6JhAJaR1pcgA34sb1tUMZOL07YDk8EC+KOvxvTfmgGdVmJS8V/ff9xX42h/d6gAntKBRboWvMUzlckvmKrf5m54qhEm7EoLsZNCyWYg56LHtEyR/FHbPahwQS5Czqv19Bkhh9F8ejZEn8M0mUVZ1H8X7tMavJtGTn8zbCW/bnsRdfUf6MIYw937Pqgi8aNvCQYwcIlENWPNKpxzAD/miqQQHrXIWdm23cEvj1qfLdJu/fUS10OoF8ZT3NW/vXPDQQQJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muTy6jbis4Vzi6P9aw3kEl+gyWZCcxvp5xy5cGiC5mM=;
 b=wCrSQck3SSX0oIGJ8WcR7XJ/L19URp6fJlQLrOGpyHEpY7CsEKQEOWZsjYe1xdv74MmMa8Dcjvf/zFNQMCP2qLa8+QdcxmSBvGGp9WaiDMLf7AnD+cVIuqEYkg8YsjRytIOKrP965+4OI3Oiznh5l/NzW0gxEwKSvutxJnh0vJ1OkH1Oy3ivVjim43gtkwVjbi9WEYcRMAI/wtvOJg6UnizQ1JdvytdyJ32TUjM5PXJ1ZlvRpL8+ExthfiG0Dyxi9VIQFT1FhLPYhPnpMSQ7X5NE+5ubUt6Jd2mRK3H6bR6BPQacqU9rOGAbT1+HexYljvRIsYkmiMI9/a3nh/aBzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muTy6jbis4Vzi6P9aw3kEl+gyWZCcxvp5xy5cGiC5mM=;
 b=OD5o8gVhDzQqnkLyA+hjLhvlDCu2gGhTXrjEK4RGjh/5iSstozNOSQUbjMcF1liNYTvANg2aDxnZA7hzrPgNSHH4q+YTNXRW9zlBpT4tY1G09zEbvEH4jFlhCietrVnljTnJ4myyd4rzxW0QtS6NL3tyWXSE8CcJwcF9XBN0KjpFoKccM2OP2iJNIPuKPwPs3E5qZZeZHDOQ9OlfnB9dJ8gguIRF/qwYvvTY6zAIDSVSfOnYuXoiSSKM3nnQKk6WKM4SbUTtwYmHq0xsAwKTzKtf7ELS7KnwbnpSNmxUs/eFWR36nUSV9XtbuO1OeD7kwCHsVNqHARjqEoXSD/2llg==
Received: from BN0PR08MB6951.namprd08.prod.outlook.com (2603:10b6:408:128::14)
 by DS0PR08MB9517.namprd08.prod.outlook.com (2603:10b6:8:1a9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 15:31:26 +0000
Received: from BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::4dd1:e1e:56b0:b178]) by BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::4dd1:e1e:56b0:b178%3]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 15:31:26 +0000
From: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, =?iso-8859-1?Q?Ilpo_J=E4rvinen?=
	<ilpo.jarvinen@linux.intel.com>, Alex Williamson <alex@shazbot.org>
Subject: [PATCH v2] vfio/pci: Lock upstream bridge for
  vfio_pci_core_disable()
Thread-Topic: [PATCH v2] vfio/pci: Lock upstream bridge for
  vfio_pci_core_disable()
Thread-Index: AQHchvysmxF7Re29GUO2rbh988SUbA==
Date: Fri, 16 Jan 2026 15:31:26 +0000
Message-ID:
 <BN0PR08MB695171D3AB759C65B6438B5D838DA@BN0PR08MB6951.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR08MB6951:EE_|DS0PR08MB9517:EE_
x-ms-office365-filtering-correlation-id: 55c756a2-fe06-47d3-361a-08de55144ff1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?9GpeStp5KbmWphjEQVU7o+RKnuo0G3K2iVe40GW6nBcBZw27yvdumhxigx?=
 =?iso-8859-1?Q?mSZtGGZOCTrtQuP6FvWH1/rKylMbEZil/WWquwbi1pM2oHce4r3tlaqAkC?=
 =?iso-8859-1?Q?MkvfjQuE0T1H4sYxVLM5gnIcudXBBVe5ThcRdF0rTwcu5N70Y5qTHklax5?=
 =?iso-8859-1?Q?GXYSlyRv4guXDZrmG1MJEjRt1WMD94Z+6pLsfMk9uaC9ZPSdYvJvDYnF19?=
 =?iso-8859-1?Q?JPBGqGAbkp9WSvyaxKu3mm1oKanjEtCw+4g89EEH8Oy4+ELxw4/Nk0MgLP?=
 =?iso-8859-1?Q?3rFyIYbbC6xgCUXDp6CHuRuNDkxdEZpPn8YM9lbIRVFZQCAVio4lHnH2Ey?=
 =?iso-8859-1?Q?7PfyrNDBQ/30iqZdLHufj2ikigAF2l2IOB9TZOt7YUwEEIY/0W5EDKKv1g?=
 =?iso-8859-1?Q?K2Iv6sdQY6P64dqpA5GbvYZKcDAIc/jFKrH9UbzSn1RRkw5cR8FATWbq6/?=
 =?iso-8859-1?Q?GYXIPg+fyv59jho5XQbExEixlGK8w5crdCwua/G+BerGnmbbvKpF/JreWt?=
 =?iso-8859-1?Q?h0xy/P75C5Prrum/AIni54H53c9jfHAZ3OotCVLegP70i0KO/zRX37ijce?=
 =?iso-8859-1?Q?7tKxJi/0yLkP5YJautSp/uqC15T8+lchdc3Ni1vWJ402dlbyrQITpIR/G3?=
 =?iso-8859-1?Q?+4gCXVhJW3YVPlNAEAQ2NSr4c+MrO+1IsV4zxZYk4jLr7GHzPAgdGdF3Ym?=
 =?iso-8859-1?Q?1IO8Ux8k5mXXankTZK+lMtnPCXk+0IIBDWD3uBxKxg/+cLKCg0afcQzxsZ?=
 =?iso-8859-1?Q?SWa1or0qpL7AEF82mMI/ZsH64zzHahgOMMfndLEL0If89pGuq4oWnmR+tf?=
 =?iso-8859-1?Q?0trII2lrrcqw1ca2DrGYfDbEs2Yya6Z1nq+TlDVbaZlXR8uyLK2wxyUrvQ?=
 =?iso-8859-1?Q?unYZsUbiNcYooZT8x827ENbLhE8+6rFWsF6JJIf4nqpTHD7WgkjBn7pP6U?=
 =?iso-8859-1?Q?fglTcEJCGAvq09QosvNRyzlgEP0eWeEYVOEcEZ82D4dVBlXhA17hDe9vxk?=
 =?iso-8859-1?Q?kMJZQ9tXhTv09+VSI03OUVVBqQTJOf/tTUFk3Sfn7z6azfZSQDbKFxBapz?=
 =?iso-8859-1?Q?GjYeounn3LiCeBmy0oTiby3IbQ4fssXcUyycXCs9pHWQi2Xj4KvcADFot0?=
 =?iso-8859-1?Q?LHtnZaymIXCNWpizFATmsRfJNvgu3aSQ0wv1WwjY58M++KgzjPVEMfGSxs?=
 =?iso-8859-1?Q?2740wC+2P8txfiTFZVAuwP7TTRMOb/8NQy1E5EBfXwBW9QQQprehwRPEf9?=
 =?iso-8859-1?Q?XcZnwyAPIr7dVjhI3EG87grNs79eT5BoUogXtfriCvIjG7vWjiiOjleCQ9?=
 =?iso-8859-1?Q?3UdPsSZvgo30H5Xo1G3OTvUKSu5Xuvttg0CV/7HP55U7wGER6obca//DOu?=
 =?iso-8859-1?Q?Xtox88t2kb7G7G/iEYpXX94kpuDJXfQjJj0o6au9CDuixRMo05ESjRSBcp?=
 =?iso-8859-1?Q?x3zJyhcf4ITB6mMIvyRh/aXZXUDM1eivhCDibFaJ+4lX6NpSSRTo0q4TQP?=
 =?iso-8859-1?Q?Yf2pi0MpUJ9mE8wmnacmEWRRtRTNT7uzLtV8rHPWdysP9UAHZee1XxVqbK?=
 =?iso-8859-1?Q?sVsATi0oay4XNOROvho7YNc1FIrHEkEdzLaz5EJ/Ae5Xs0i7cR91hDX4cy?=
 =?iso-8859-1?Q?kuzjbVbE7iMt1OzIM7O1dxtnVMOyeNKATVhM6OCsYM4T/P1+yY1+Fjd2KB?=
 =?iso-8859-1?Q?VxSTjbFfSov3W+g9KWc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR08MB6951.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?dhOFO4QMW8KMl431kY9gqGclOqF/AZDYkcCXdagA9gt+PGkY8G25oyLq12?=
 =?iso-8859-1?Q?Tkignqbnj2+EE++SY2Td9g6qj5zs5NG5Ulm8pVqjxk5vhfgOYbuKPqYd8p?=
 =?iso-8859-1?Q?8ouYI7yPalF/p1ZnHf4cPnRN9v6Bv8s3eNOTwsWgbY1suZaxzSqKGFZjs1?=
 =?iso-8859-1?Q?pYfWiEQxf0/K6gXe7Y6n+3HNMuYqIGz4cGJsR7PhZ/Xuh0XJdfj36gOju3?=
 =?iso-8859-1?Q?r5e66gvXRsa9pc1zxkUAdkROIqWXEIZZ6gPGScjDL3sHYyUG6stN/25P9v?=
 =?iso-8859-1?Q?87HX43BBSyrqNqLF2p1wy2H0HCO23owhMXtu1OUt8B82mwjO1LZXD81sx4?=
 =?iso-8859-1?Q?wjvgepQF+YDry1ZTRPAnL1W0kri8FSGIjM4a5cKuWkll8o6+wXs0V00Tvr?=
 =?iso-8859-1?Q?kbzHApe7y8URhrBKgw85ZZUagG/dkps19YRwEMCj4Vr3X0BbQgu63zSqOr?=
 =?iso-8859-1?Q?4ym62hetC8+9UKdEMcFI5otKaYUkf3nyO2PyHMfuTjQ4G2x8Wlp8RVG4d6?=
 =?iso-8859-1?Q?5XoDquRK5EvpYC4q+40TsJX0nrs0nYSXQBjvP4jlvjm3rJp2G5QDTunFEb?=
 =?iso-8859-1?Q?cHkJ02q+3lt0f4R2qx6m6KzzI4PVVvpAy8PFZgQu/m0YosFwHJLyFyguv7?=
 =?iso-8859-1?Q?PFRUeETgYlYDIdEHllfOUupQUU0xMgROybPyNqGk9PufslvbBug206+HKO?=
 =?iso-8859-1?Q?AtV8dl087EZrn1eNiNZvr88B+cXMP0XFaB4lC+OC/tbqTkDiEeF+icoJ+c?=
 =?iso-8859-1?Q?QFcS6srjZRUqasTpQwDqiqLtmkGvH0qAnDtUATQONFVLNbVZCJAQv3YwEP?=
 =?iso-8859-1?Q?1AaHEkf/UCVftXUchFDS2s9xY6UW67OHo1qhhdAviJI1gzje0EnsXQ3zjG?=
 =?iso-8859-1?Q?+DPq0j0SdW9ATB1sO8acyL8GRjUTkFjMlU1JHE9ThLDGLFy7zYWICAp56F?=
 =?iso-8859-1?Q?5vd0+kQS+zzKjWKwPWifKY7JrFV/aAbxkrn/95isQxqR5SNXGc0ZrOayCC?=
 =?iso-8859-1?Q?HZR8GhtfOVYCtNwzsoj6iGc+ySfkflKyyJCmDc+fUC8htF0V9ko/DGRNda?=
 =?iso-8859-1?Q?I8ZEA4i+DcJm6fzZh4jIZY2D+qXUt/Od5XPtlmqB5BXT7EE8dWqwrnzbSs?=
 =?iso-8859-1?Q?TqrmLHoRPonFWLSi8vBZahC28iXqq0HGBc/8+64qGDZku22jbhYUd8drhZ?=
 =?iso-8859-1?Q?zYZffQUHnn4g+jeZGWZ2sashY6QgmOHPTH3gB+u/wqknPPK8VSDJR7M7NO?=
 =?iso-8859-1?Q?pMwAhBjBXcuuHZKkCBKZL7OozlcwU+qsBMaL0KsCEuvAo8RrrjJGBT6lx3?=
 =?iso-8859-1?Q?VFgWSElaLB9IesXu9GGs8/si+PkUj0g6d/76vIcxtvJ/WHomp2IWnBTOXi?=
 =?iso-8859-1?Q?GtAlbHaC7a6aukjLD1LBosyzwS+qJ5xCPkVpXe9bxcKYMd5t9vZPQ8BjuM?=
 =?iso-8859-1?Q?s9D1mp8qHl2XVQ72DrU29W6c5DQTYE5c2wpevkw/j7ZoXqsjvSJRvKQvyP?=
 =?iso-8859-1?Q?GxZ8m++R37S1PzvPfV6VUC5pfHbmwmuJ9yeu6UWsQvAYP1lGyvcFVdFRMN?=
 =?iso-8859-1?Q?ZQf2NVoVLudyzljGxicfXfpLT48hd3W28kZQSywOtf+Pk8os8y2lFv3F9C?=
 =?iso-8859-1?Q?x6xoOtdbrhvwNwg7E+Ohrd1QmM8tNnsaZ5Zn6SzAG9XZzSuxAciC5N3GNH?=
 =?iso-8859-1?Q?3OZAgPLiCaUBfWxcQT/HzVLJLVBuYF0833h3dEjUL1DhsIM/WJf9XZ+7AR?=
 =?iso-8859-1?Q?mGVJDtcLB9m7C0S4+icb7xrIPUFILYeIQhgyg5NRxNLvE6UcpXsLyYgc7+?=
 =?iso-8859-1?Q?9Azepx4jnQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR08MB6951.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55c756a2-fe06-47d3-361a-08de55144ff1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 15:31:26.1811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rZq/YQ33AxPNAybMh2udVucMASH3GxTqI0gCm2wq65QRGNbzS1K8fnD06xbMqsAIaCPqKygE6AFE1URKEbQ8Z9iGBU9Z09vPHJKIXi2rgVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR08MB9517

The commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")=
=0A=
added locking of the upstream bridge to the reset function. To catch=0A=
paths that are not properly locked, the commit 920f6468924f ("Warn on=0A=
missing cfg_access_lock during secondary bus reset") added a warning=0A=
if the PCI configuration space was not locked during a secondary bus reset=
=0A=
request.=0A=
=0A=
When a VFIO PCI device is released from userspace ownership, an attempt=0A=
to reset the PCI device function may be made. If so, and the upstream bridg=
e=0A=
is not locked, the release request results in a warning:=0A=
=0A=
   pcieport 0000:00:00.0: unlocked secondary bus reset via:=0A=
   pci_reset_bus_function+0x188/0x1b8=0A=
=0A=
Add missing upstream bridge locking to vfio_pci_core_disable().=0A=
=0A=
Fixes: 7e89efc6e9e4 ("PCI: Lock upstream bridge for pci_reset_function()")=
=0A=
Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>=0A=
---=0A=
V1 -> V2:=0A=
  - Reworked commit log for clarity=0A=
  - Corrected indentation=0A=
  - Added a Fixes: tag=0A=
=0A=
=0A=
 drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++----=0A=
 1 file changed, 13 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_c=
ore.c=0A=
index 3a11e6f450f7..72c33b399800 100644=0A=
--- a/drivers/vfio/pci/vfio_pci_core.c=0A=
+++ b/drivers/vfio/pci/vfio_pci_core.c=0A=
@@ -588,6 +588,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_enable);=0A=
 =0A=
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)=0A=
 {=0A=
+	struct pci_dev *bridge;=0A=
 	struct pci_dev *pdev =3D vdev->pdev;=0A=
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;=0A=
 	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;=0A=
@@ -694,12 +695,20 @@ void vfio_pci_core_disable(struct vfio_pci_core_devic=
e *vdev)=0A=
 	 * We can not use the "try" reset interface here, which will=0A=
 	 * overwrite the previously restored configuration information.=0A=
 	 */=0A=
-	if (vdev->reset_works && pci_dev_trylock(pdev)) {=0A=
-		if (!__pci_reset_function_locked(pdev))=0A=
-			vdev->needs_reset =3D false;=0A=
-		pci_dev_unlock(pdev);=0A=
+	if (vdev->reset_works) {=0A=
+		bridge =3D pci_upstream_bridge(pdev);=0A=
+		if (bridge && !pci_dev_trylock(bridge))=0A=
+			goto out_restore_state;=0A=
+		if (pci_dev_trylock(pdev)) {=0A=
+			if (!__pci_reset_function_locked(pdev))=0A=
+				vdev->needs_reset =3D false;=0A=
+			pci_dev_unlock(pdev);=0A=
+		}=0A=
+		if (bridge)=0A=
+			pci_dev_unlock(bridge);=0A=
 	}=0A=
 =0A=
+out_restore_state:=0A=
 	pci_restore_state(pdev);=0A=
 out:=0A=
 	pci_disable_device(pdev);=0A=
-- =0A=
2.43.0=0A=

