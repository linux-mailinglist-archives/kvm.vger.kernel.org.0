Return-Path: <kvm+bounces-64635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 833D6C88D2C
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 10:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BC7F03442A4
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F778302CA7;
	Wed, 26 Nov 2025 09:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dUBNG2SI"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011041.outbound.protection.outlook.com [52.101.62.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFC52DECDE;
	Wed, 26 Nov 2025 09:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764147806; cv=fail; b=Y90VhhsVP2oFXwgDjUfImIJiu2WPY4bS9qXCL5RqYFc2LSJyzwhHyooKwDIlcYQBE0+mi3dIi5LHj0+SB4DS0HcsQCZZoTeGYvLcj/yogVZiFG/Yzgl2fU9ZxJfRtFK+0GdHyF1PtRPZzrCD2b+AvdQ3Bh/p3UABeMpS59qDZX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764147806; c=relaxed/simple;
	bh=/uU7FGZHIg7aTBoCoRh8w5IGYNG0abqo/tqKIKcSSKE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iXS6avzQ6fTs9f8bKZVUJ3mLuva8TrthwOsfFDtCModQfgdiHPm3Rk+Ym0ne1Z5H9zlbrsmQZrwBdd9PPI9XOKhkhqWI4GtSj71GN0VGwq454gIoGrffAV8XMEul4xO33vLjkacPYrqMj7lqMcv8t9h61+pxcgTE4q9xfZ1BnVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dUBNG2SI; arc=fail smtp.client-ip=52.101.62.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fMgR0pOno0fIKHifqs/e/duPnk5ayVVd3xhO/+LWa8rL7tOCfCmLhQIbM56za32J/XoKA3iv5UBGMfejYofu5HXJiKUxdrOWYq/QFfMm3nqblvSBH2ML8B5TGnxCmeD0olxDk3Fzoq3zSf+1vKVm3jnzgMVNKGRlsuAsNoVFFoZ6/z/nRzCINJABY0ynHCPfFe+W4ZKFh3oq7zmq3U05cuu+fEGJUjgDGL7o/cy+efJQkIi28e5G6bRCVIoZrO9aW7fTnPetXO7VJ8iOelF2cnhqFVY13GgmcN61qdHONFdEl4bVniyz5yWN3cdHZ+srRXRm5p8LsjLLwN11uVGAMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=josBj52ofF5h6uxDcPgn8tfCfJECUALSnDz2ATHHejA=;
 b=oyGjVEPvy19s+GnjW1hIdDu463zyvHOsacSXumszOgOT+0XpeA8dPV+gKizgaYQoqnpOKx1LJ6XOYDC/L2c/yCwRajG06G4CkHc5nsdlhtZhVmQkbSET6Kql+871k+Woku1j+U3+U9lMAOENrAnO/lKGHUdH0J6/4VvWXpTly078qTFfKA3Q08i8lSX6N5ZpeS8j6YnsK/DxJKGgBSc9UGTPUUlf9wpWkx+C90rb9HLd35n8xikhvVvQOJfkGcPoz892lbJWLbgIyGXxZ7MS3ctZmQRh1bjYpy0CdnqC+er52RemF15x8j2ZUKMW6VsGjxL/7FQxhZ/QBcvqryupIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=josBj52ofF5h6uxDcPgn8tfCfJECUALSnDz2ATHHejA=;
 b=dUBNG2SIaKjlcGe66jrvBF4gCmbtdWElVX8GnGZzha/NuLJyu2PTH+c7trSfREbpW8rROobjifLCmzTMPiuy0ouniePpvQHDhLnsxRXjmvKeGyxAuhAEBxktMGPClQlEZ55laX9HcipuYz/hcqUOtCd+cylxFAynPnl+IsW+giCzBdYJ3dBg4bI4gXWTT0GzLquknKcL0ahZAnEUcnZopLiQqqH24+ynTqyFRiIGVjhTUQDeTeY5mF6Eh7zocPo4yLjgHKHfPswtliFDlq5FdiOk5lKL400O4K0qU2zXsdpcZPN/tqqO7pDRG1Ec9+7XBpTiqf+uoYmag/0e5J6nMw==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by SA1PR12MB7293.namprd12.prod.outlook.com (2603:10b6:806:2b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 09:03:20 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 09:03:20 +0000
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, Yishai
 Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Aniket Agashe <aniketa@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Matt Ochs <mochs@nvidia.com>
CC: "Yunxiang.Li@amd.com" <Yunxiang.Li@amd.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "zhangdongdong@eswincomputing.com"
	<zhangdongdong@eswincomputing.com>, Avihai Horon <avihaih@nvidia.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "pstanner@redhat.com" <pstanner@redhat.com>, Alistair
 Popple <apopple@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>
Subject: RE: [PATCH v7 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Thread-Topic: [PATCH v7 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be
 ready
Thread-Index: AQHcXpVDv2dFGNJ7nkuXfQf3I+widbUEqQYA
Date: Wed, 26 Nov 2025 09:03:19 +0000
Message-ID:
 <CH3PR12MB7548D2FCEE9A3FA1F4210BDEABDEA@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
 <20251126052627.43335-7-ankita@nvidia.com>
In-Reply-To: <20251126052627.43335-7-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|SA1PR12MB7293:EE_
x-ms-office365-filtering-correlation-id: 74112cea-984b-4ee6-f9e1-08de2ccaa52b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?pLbVXN0fZurBFL+nRD45P6uGSU7FqI1XX0UumhrCdtnpsD4MW/jiSIGQoNK3?=
 =?us-ascii?Q?PtTS9dKEYdLIY5dlme4YbZiNT8Ry0/SfI9p92fIs4gDwqFa5yGuJyLHu6E+G?=
 =?us-ascii?Q?PZp5GlhR7/J4NYK3KewYZO0EieqfHW9QNA/HkGJ4Sq2ZvjHVXGNLG6nBMdD+?=
 =?us-ascii?Q?tUc58MU94jCGp4gKnWsj52VMlyYGEMnWWo3Ivy5EJssZ6CwPt2KKZnOlqEzp?=
 =?us-ascii?Q?11ixOPUpd9KCzCECNJ4ZCIQ4kfWrH3uN/TuMoBDq6zEgxLCS9PALXz13axEm?=
 =?us-ascii?Q?KFWVU9qOoc7au5B4Jx+BSsOTcVSdJOH2rS1ZbjigkP96jEpjlhHBb0BiEpTS?=
 =?us-ascii?Q?6dKn+x98D2sYQvdUmlDjzUDKx4BcalEomWI37SWESH6wWp7kUQ1tdzpPCiLi?=
 =?us-ascii?Q?SycR7Jv6JQQ6zJQIQnnkxvyZXEtZkfDMZW2P5Y30MirSWPzzNxZqj96ZyFaL?=
 =?us-ascii?Q?PM920jRimEr8/6aXBv1oIzTNQCvHYBpa6erjLUT7yvoWCGUMj0nrksftRVV4?=
 =?us-ascii?Q?KqfvNMUfTh//+aI0bs5my7MLu5f8plAdnvsJ021ZPBarU6l06EWSZBSLqo/T?=
 =?us-ascii?Q?VfNlxKxxLIN2/42EhMZwJ4jASxReeENrWO6pq1j5BgjFmVO90aRk8IsV9r67?=
 =?us-ascii?Q?r49VRHnxNIdHPUN/TRpd4xZ9lM9lTs9Asg2ak2XloTnuBHT4ut5AKh6+6M7e?=
 =?us-ascii?Q?kIHnylH3asttzgO7+g05qWvpY9OajeOZ/QWSJWC4XG0aDypSl5aMeRemss4j?=
 =?us-ascii?Q?zTSvlVselnsdabbsqCIkj0myPg2v9WMJTNh9w8oWmfnllK4zAc0ayug4Gnwo?=
 =?us-ascii?Q?kJtw5byYYc5wfQD1C5mgjsseRx/4vYffdSXp1xoqRe3APwcgDcG8+IzEiT+u?=
 =?us-ascii?Q?Z71oafaJ7jIqr5IFBi25jvSJXhFzsTMgwv9AUev9z1BmtsCRIrFYLxL3CdVw?=
 =?us-ascii?Q?8R50nCU5rbuR9CLRkA68FHNHqNki2DcmTT9kiysN3fr8Y2xDi+U6crxrJYT/?=
 =?us-ascii?Q?UIx7oxK//S81mOK1L5wnAva0Fj+1/otLl+395bxC5x0GQ2CJ1N+q5XNkaYak?=
 =?us-ascii?Q?qjve849v9fMCTXHGl+BTlOJK+TR5TeBOJtcaCmst9vs+nls6xK8LGnIeXDP1?=
 =?us-ascii?Q?prmzd9hgce2jA3fnJDNYIqUJzDsxhcan7DxQ3SK1B1bINiEdZoGzdxhxCokG?=
 =?us-ascii?Q?qnXpTZu2mM33MrM4p2wE+xK5VI7Aoxx4tPb79O+Cc5oHbciekO7C5aPOluuy?=
 =?us-ascii?Q?P/ojTzx9SPou6FouSKEZ7Vw3ERTQLPoXrZISy+lH1j7HSqROt94dbnlPTzrU?=
 =?us-ascii?Q?RAYnpb6ohe+4geBui0VFcL+ZXjc7Gpas44amfg7EW0KBjPVvULGaBajSnick?=
 =?us-ascii?Q?wOHVX9Q6EV9m6q/zFcexTcP8OmalRyNVHyPf/JK0YY0IWYdhhpteHZah7/8g?=
 =?us-ascii?Q?c9hufjX9TIDrHfWJT9Q7VKVfR9b/u8+UrzPesaF684ZpIlGFSvufnHqML/b7?=
 =?us-ascii?Q?1hlImzi5KTdxuO3MV4J8zr/RH/q5cRH3PYMZ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?8XIh76zT/8HPuukB3ZZk305elqYNikkjV2pOxcyl0zzRT4K5HwYQ9z32AcAo?=
 =?us-ascii?Q?F/FmmauoCknhhztZZ7t1ia5IrFnpF7/3g0sNfg7GTSZBtQxXCZSP84R5jP50?=
 =?us-ascii?Q?IFEj5KJ+esZbTrEcVYR2qN4g4UGOGOCT7GekR5xEqIPeRsY9NHef17lTbhoS?=
 =?us-ascii?Q?FPopHfbHsotUc6u43IkWm/Ivc32nmOzO5xIfC2qotdfc3D4dnFNVyZpmgU/e?=
 =?us-ascii?Q?+RAK+nmf9fYy9UAbi7HvpK5nIlc43onvyzpcUtiiN3YowlZPaJ29Me6tJfjb?=
 =?us-ascii?Q?N3eT53hhpwTQ/FB4l9QhXl3O3i/roxfBwLaBp30JXcX9U/5aiLb673bZ0tTz?=
 =?us-ascii?Q?uRkr8WFUDUDkAqeRP9YUJ6FEQWyxWe/vs5RhfmHFKeKLw3Yowysr8u+F5MxT?=
 =?us-ascii?Q?2qPrX63RmSvaFjNEu+1XzhPh4F1RbPtFbHL2gM4ypQVUP/mA1QCfR2fvFByZ?=
 =?us-ascii?Q?pa6LvAaPPWg+ZiUkD4nHZWyIiSIOBNM7PoPtt1Amhm5ABv5AmUk4syNx45Hy?=
 =?us-ascii?Q?6d+oVcb/awpOh0fQneCvdYPaK/ns5FKoD4+bZipq8ZRVn2RGKf8Yg7v5mIN4?=
 =?us-ascii?Q?+Cg7AuTvqPso4AJCoslRHAwxNYGuCw8+XwmXtsEfkHi5llJ3mHaxmIclyfnX?=
 =?us-ascii?Q?B7UIx/np7xK1IDxaoAse/LsQrKA3ox6cRvGq5OzSKD842NdOuc8yjoNlPHFh?=
 =?us-ascii?Q?2pQRAEhceiiIqkKwHnGyxBwCh6Uqoq0oyUJJ38jbQJE8VjQOPKGDsMfZlYyO?=
 =?us-ascii?Q?qQXZJ5M4iwXozTroLU+Ms1EF7SIUJ3c1Gq5pr4Be2UZ/Iaxte55lhF/p9ATR?=
 =?us-ascii?Q?hClq4qvQ7Cn1KwwEaKg6gaz1z1X0nOFR/z1L8YeJ1DLkRc7FPIRpx9sgUfNL?=
 =?us-ascii?Q?3x5FwQwFL6YCo911+HJnAIo75P1fMtDNGIkwWXerwo0iesEquawtpGpxCMJH?=
 =?us-ascii?Q?11BHHnAHXkBG1OGRm8uVVCuuu1a4LPaWYIioLFPKZ6JT8w+wpp4fT/uctUnE?=
 =?us-ascii?Q?lXYX4G07X+C3u3BUhwfbgmug3L/P2oyE7V6+kD8whwo/ohsYBAfCXTJY71Jv?=
 =?us-ascii?Q?k1Jx+sNNYTBWa4q3c47y86XrXuRBosQeIiX7R60i1h6XI0LiO2sM0bb+nyBp?=
 =?us-ascii?Q?j7kujM9JaAmfSgw6YEOzRhcB7sj2wpZ4r5+mySK3/eQi/Hi17BEGEefZcfZQ?=
 =?us-ascii?Q?sf+a8D5S+cge+uuU5fBQ/F59MlMsAgp0c/7lpsV3Jmvvhw//xmFLwyDHDL6w?=
 =?us-ascii?Q?55gvNb6owL5kX4hYmIacJ23Vxdctc8PRdprEfGsqyqB8I5N92XACcL9+WDaC?=
 =?us-ascii?Q?buZlvJj+oaWWSopuZGMtxa7aX+J4YCtQrfUdWJNQSV/wKrxssZjUJUgminpu?=
 =?us-ascii?Q?FoGRrhRFvffyBSK5MPcGtAGr+brRTEoCkhorbNQAZBmpV1bTcpvWGakyUAcS?=
 =?us-ascii?Q?fLNLoyu0IJVDlmelShzKn60lrL4YxBef6R3T0gynkaDT95BxUcbIBb4PNgZV?=
 =?us-ascii?Q?wGzK6Rvy0JUFCA5JFvaALoiW0x/ATI6/VtbDcxQlwO2htIsF3G2nEuYJiugl?=
 =?us-ascii?Q?j6Ki3fqrPJzMYUEvUmk18bzWFLepe6pAx0tgV8M+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74112cea-984b-4ee6-f9e1-08de2ccaa52b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 09:03:19.8777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sJNcr0tgEpZ4d9G6VYiNG0hVkCTwd/41FomskQEhzWl1l8+0SSSBrVZ/1MX8Nlbx7A0BalltMNvISAmD1OOj9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7293



> -----Original Message-----
> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: 26 November 2025 05:26
> To: Ankit Agrawal <ankita@nvidia.com>; jgg@ziepe.ca; Yishai Hadas
> <yishaih@nvidia.com>; Shameer Kolothum <skolothumtho@nvidia.com>;
> kevin.tian@intel.com; alex@shazbot.org; Aniket Agashe
> <aniketa@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>; Matt Ochs
> <mochs@nvidia.com>
> Cc: Yunxiang.Li@amd.com; yi.l.liu@intel.com;
> zhangdongdong@eswincomputing.com; Avihai Horon <avihaih@nvidia.com>;
> bhelgaas@google.com; peterx@redhat.com; pstanner@redhat.com; Alistair
> Popple <apopple@nvidia.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Neo Jia <cjia@nvidia.com>; Kirti Wankhede
> <kwankhede@nvidia.com>; Tarun Gupta (SW-GPU) <targupta@nvidia.com>;
> Zhi Wang <zhiw@nvidia.com>; Dan Williams <danw@nvidia.com>; Dheeraj
> Nigam <dnigam@nvidia.com>; Krishnakant Jaju <kjaju@nvidia.com>
> Subject: [PATCH v7 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be read=
y
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> Speculative prefetches from CPU to GPU memory until the GPU is
> ready after reset can cause harmless corrected RAS events to
> be logged on Grace systems. It is thus preferred that the
> mapping not be re-established until the GPU is ready post reset.
>=20
> The GPU readiness can be checked through BAR0 registers similar
> to the checking at the time of device probe.
>=20
> It can take several seconds for the GPU to be ready. So it is
> desirable that the time overlaps as much of the VM startup as
> possible to reduce impact on the VM bootup time. The GPU
> readiness state is thus checked on the first fault/huge_fault
> request or read/write access which amortizes the GPU readiness
> time.
>=20
> The first fault and read/write checks the GPU state when the
> reset_done flag - which denotes whether the GPU has just been
> reset. The memory_lock is taken across map/access to avoid
> races with GPU reset.
>=20
> Cc: Shameer Kolothum <skolothumtho@nvidia.com>
> Cc: Alex Williamson <alex@shazbot.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Vikram Sethi <vsethi@nvidia.com>
> Suggested-by: Alex Williamson <alex@shazbot.org>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 81 +++++++++++++++++++++++++---
> -
>  1 file changed, 72 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index b46984e76be7..3064f8aca858 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -104,6 +104,17 @@ static int nvgrace_gpu_open_device(struct
> vfio_device *core_vdev)
>  		mutex_init(&nvdev->remap_lock);
>  	}
>=20
> +	/*
> +	 * GPU readiness is checked by reading the BAR0 registers.
> +	 *
> +	 * ioremap BAR0 to ensure that the BAR0 mapping is present before
> +	 * register reads on first fault before establishing any GPU
> +	 * memory mapping.
> +	 */
> +	ret =3D vfio_pci_core_setup_barmap(vdev, 0);
> +	if (ret)
> +		return ret;

Should make sure vfio_pci_core_disable() is called on err path above.

With that,
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>



