Return-Path: <kvm+bounces-36815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E45C1A2167A
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 03:18:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60B7F1881C58
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 02:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C647C18E03A;
	Wed, 29 Jan 2025 02:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uli3wU56"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287D5188A0E;
	Wed, 29 Jan 2025 02:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738117127; cv=fail; b=jNxREY1wMZqKd7F1LjksVXunW7glpRf0wopJlzWzLFBAAVjIXHqm8UxHrWHDYJ0TNUAgBw8iqGHAJ3HAyTmGTVXlGwe7Lbmhu83okqQtadCjiLsbKx3RE7Tlo6IXy0lmwd5d82Vs69ikQ9BzzdBaegJ6aEIWK+Xclx9Tnnlg/QY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738117127; c=relaxed/simple;
	bh=VnSbVYEviIE3r8Wbka2vzjqUCtrvWliA4ZxnAkJdJTY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gaPVv7TcWm7JA42bAlbykGBZdmo9gUkgZh1P0gwNyttqndogXDK5ztTxB71XMgACHyBguW1IpG5EwwlwAh18QKpQBftb2FPe0tK2w1toL+9qa8cn+0443WA3wdGn1aeKuENT3KZbzzNxF839Q7XVUrklqsm+JRaWOoCA+dXLwWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uli3wU56; arc=fail smtp.client-ip=40.107.212.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c5jWFTEWc47ZyPegVrRtzLn4DmDuUBRLeDSQLBu7FdxvKyQKCpGvCRCggzrf44Bz9FOGDNdNQlLOPXJ9y+jnBsY1tZHpAWOzTfmCSkndEIbCSt11ml3OcA9RbISnkoHPqwoEFMB2P+tLSylpwtGHflaMFv+fVXbZDu9RaBkZ4zn+5eEScr0NB6/avHIA6x2+tiQ8zi2znPsWVkCsq3J+rWIxGzlYnPmsN4Bf5HxHu2QrqO7Lolr7Ry9tBH0GMeAggmNEGo+yNhXtsVi+14hhw+99V+y856DiEv/+nxdw0tzkiZ7Kf2dhGqsX5XflNNAIWXGAtd+qZhHeAGoRHEHRnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VnSbVYEviIE3r8Wbka2vzjqUCtrvWliA4ZxnAkJdJTY=;
 b=YXtJSitV9NBitfsTPZLzON+5DZQnluVYfJTSjeVE+4ykJbuFRrl7fKXeX158eyXcr53yHiG2Oi708GcjOsU7RKUju2eZKqZEUkk5pRkcFQATDd/zTIktlWJEVGfo4Gdsz3fYnyR3eXA1f+lh5lWTmXpzf74/qNMtrS+qtJOebrYi/IsNa5h3HiB3w9aWG+wPa8kq5qdyBUtuTExrYmI9Ccv/P/SrjHOM8QS1FbA6agHhwpckBWSMdFCn2HqA5joYeji9L7H9aJSMFM1/q7nORVBiHSLDyE+mlUmC3y84wERf5O7O/CmjHragxp3wvaJYTrSJ37IRDPun+7Bx+SykTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnSbVYEviIE3r8Wbka2vzjqUCtrvWliA4ZxnAkJdJTY=;
 b=uli3wU56nkq1KDvPbzoNEvF9PjruMTXamFpgnpEgfV0uvBHGqJVyxplqAU7aaBe+gP9MTAXPMx4NpCIl6eBsSAeqSPl8N7+vObj0wYGpL0hPb5jy1HcaRU4xZiUFU9OMrxxJvVfEB21iQ9TPrA8h4QmuMoR/H5cDNeengBiA6zRQdqAT/sBsNeNPBJbn5iA2yu4+48DSK+TUaiVidoZT3kdiPXh/g2wL/S55HdjWokhzv5/4e/SL9p3FADYOppInAbBepEyFxYOOyDHfN5ys+RMl5XsTFu6aIJz2gMRP90yfIe7EEbGbNL2OMnSCBzCyYfZYOL1ZoSJ1WLiD4wBVTQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CH2PR12MB9495.namprd12.prod.outlook.com (2603:10b6:610:27d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.17; Wed, 29 Jan
 2025 02:18:42 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8377.021; Wed, 29 Jan 2025
 02:18:41 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Nandini De
	<nandinid@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/4] vfio/nvgrace-gpu: Enable grace blackwell boards
Thread-Topic: [PATCH v6 0/4] vfio/nvgrace-gpu: Enable grace blackwell boards
Thread-Index: AQHbbo41cWLD0OKF3Ee4eDlCHNik2bMmeu2AgAaPu6E=
Date: Wed, 29 Jan 2025 02:18:41 +0000
Message-ID:
 <SA1PR12MB71994DF8F0AFB938040B3190B0EE2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250124183102.3976-1-ankita@nvidia.com>
 <20250124150503.24a39cea.alex.williamson@redhat.com>
In-Reply-To: <20250124150503.24a39cea.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CH2PR12MB9495:EE_
x-ms-office365-filtering-correlation-id: e2063fdc-f108-4ea2-df94-08dd400b3fe9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?K9XT2m6hYU5dpk8/HacsLQXweQRJR+n7yKsZAe8Dn74BJzw5rzmg8XbZ0f?=
 =?iso-8859-1?Q?YZ4UuPZurAyCE3/NTbMAwG8UO0UY3Q9ORI/vKQf3QNaYsTI9/8LxrR9onA?=
 =?iso-8859-1?Q?2RET3NKAszqGKHvXUS5ID+toUlW1ZDUk7Xqb1VEL/kTTC4lJZvAqdnnUcU?=
 =?iso-8859-1?Q?wU6PVgYWoYCRswKRSyFhxmMEMstqpvSIb395gcg6D8arVr+Cig/UbGy4bF?=
 =?iso-8859-1?Q?/jJHOVjE82UPvMlaNLbqP66yC6A7k2QXh0s1WJ0favIFEMT/vXRc83MDeF?=
 =?iso-8859-1?Q?crk/cQm/3eXagcaKzL670SnJp5fWS3tS2G7X5wkmoyqNYKATV4xz82qJJQ?=
 =?iso-8859-1?Q?tR1C8iFRrrbGDIGCCMj8BdiEdEjUzyMZ3XV4BtQqvR9IGXjA5alv89M1e+?=
 =?iso-8859-1?Q?aY9G1MmocYaH6QYjQFco1cwtkkF3CCHJIWt7mjPxY7AWKI6ENyVbOh9Yeh?=
 =?iso-8859-1?Q?vRMq+Ft6Y1rL2CmK/p1351hPndwmdIN4qeYmHvajJE5GH2EFbY9ZDIMuGr?=
 =?iso-8859-1?Q?yij9hleaKYLj+jah10wFLFdqnZbMmgfUi1Zs8QeoEsOhSfVJEOn41+G7mk?=
 =?iso-8859-1?Q?I44KJ4mQzUsMHkQaZrSKF/NcKI1sy4yfe42vjuutkua+sQDV6BVs/v7dKU?=
 =?iso-8859-1?Q?p9xv5z44cvlfk6F3rk3tMpv+RB8G70HGhcA6qHMZtwltuP5xzwli1BjtA0?=
 =?iso-8859-1?Q?9fmkvXlxUdtYw5107sA1gdvBLR6yNg7m0a0pwEyEWMBZRQiPCOouk/poQa?=
 =?iso-8859-1?Q?SqvypaYW7Y0ezcITokMLHeMo4sjXWNtIL7mqWi2MBbQ0YRLQjz645RMeu7?=
 =?iso-8859-1?Q?5AKH1PaKxzijtxFiFkT6OrPz5tNHyrdYbIyLkC6UF2h0jcS/EeA6/9KTur?=
 =?iso-8859-1?Q?37FiSLkkRxeBgtAXyavnCf//sSJO3j9p+k0sO/2Xx04AjZffBga+mTV59X?=
 =?iso-8859-1?Q?cqUCZWl06s28vI9vml6+8VerQbzzA5nTJu81b+OeOkRyv0JM9sN/jqx4+Q?=
 =?iso-8859-1?Q?GveAP9JbwxO9juN85LnXjUqIE8uBhsdvUBypfTujcns6iHkVkQWZ2FJqWE?=
 =?iso-8859-1?Q?a0MQF4yRnZwh+bEankYu3ppyZpM3dZvPv2EyXTg5m/MPR5eHz5Cjfc+lqv?=
 =?iso-8859-1?Q?bt3BPJtGyvSegWnSBBBBIAhLjrg+JnoMHdmaUnsrQX3XRIJKBwdThzhS49?=
 =?iso-8859-1?Q?oA3knoGN5w9HfSWvg2HDlp5s+i+tMw4By5o8u5fe/chAnSgnDtR8qazTgn?=
 =?iso-8859-1?Q?MJzD0eITk3Y4YRPNCch1u4JWVlBQnby28uLvQLf6TaG+DYPOaOVG8ziQ2k?=
 =?iso-8859-1?Q?8LKrPVpVVQYoo6CpRLqef6FOXXvds8fu9wjlXzQ/uw2CWElt+vhKCg8fmS?=
 =?iso-8859-1?Q?UqOZBJkr9OZ5LX1QS/Cue8oREI1+6jW6ttg+VbuFRqHdcpV1oSq+8i9zL/?=
 =?iso-8859-1?Q?I20Kw/ReoRNSCDrQNIg59fkatoboJAtk44bGXbeQ96jpQMs6wIiWq87HVU?=
 =?iso-8859-1?Q?2Z7PZFLyDWi+jPQB+srA0Q?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?XC8g6kRQBFA7ohglr95PE9o8ueypA4a8eC2DQBLz+bknPwToLWj6a6T2D0?=
 =?iso-8859-1?Q?88N+yi9QaTek8knEtAebFFguFLnxqnWL9agmdwEDfwnEyOHcvwtLR9aps2?=
 =?iso-8859-1?Q?k/QVQTnnan283kD6mZ237qG+xgQIY5ugrFc82IKhUZbPMGnoldF4Cu+sNm?=
 =?iso-8859-1?Q?mAIGwZMMp4WyinFBdhF0gkD7eZK92awwkb7qUDmM/HoEwUdKyVxnq6RedC?=
 =?iso-8859-1?Q?fRvDbTEE66zkO7vnjaYOxXb9kpbQ75gs+Wnw866Bzh+asi3z91SMOmqLrw?=
 =?iso-8859-1?Q?A02d5xWMTLSBvWn706v84E2hGEqN+UOZ3maXfTLBtJWFlIFnnDSMxU6kst?=
 =?iso-8859-1?Q?O/0V2MHAuWgafcVnGwYMKqljL8TTmqMvDdwbkM3kH9/urN3p/w6dZiRfnv?=
 =?iso-8859-1?Q?rF7Onh0WMnZvkKfOFUq1yUc9GKEWLQvlEjZudyqePjIqN4SkXEY+cJ++5g?=
 =?iso-8859-1?Q?y1fGs3na7dZdRZQoogdYuyJ3kckgH18j+DwYcQJ6cH59m1GwyUYoV073Aq?=
 =?iso-8859-1?Q?ie74urXSCJ83RJOMfS++JS72bHgbPQdCFnBOP6xIWsgAEc3qgNjINcRPC2?=
 =?iso-8859-1?Q?Ze6GxHl0E4CQSEahlexyq1SyDc+Xr21YVhmZXtxmPn7ltJAA3C64WHlkKN?=
 =?iso-8859-1?Q?VsnvIoU8Os3e0iZQWrxHuwq0YNOLbxgVYOVg7EXeypmNAlDE9l0KcS5Frg?=
 =?iso-8859-1?Q?IkhOEEZtrxgrjz8iBcRufZKXsQENg1t0dHW3zNrCH0vT1tYMGAcQgydDzC?=
 =?iso-8859-1?Q?mS4MTYUUn7N0ErgigLScy1iJzLrY74YhmKVSGiLfKdNA8amz6e2hAuH6YT?=
 =?iso-8859-1?Q?aV8nwyDVYUPOzbnlqFu8Nu61gMXZ+As8a++0Jz9N7yIgsi3agzWOYUFyuv?=
 =?iso-8859-1?Q?BOgLTqoPc0QGhn0i/Q6mGoeBjWzm5HqwsDkwVd+YAl0cAyuP5d9Vm6E3x7?=
 =?iso-8859-1?Q?0nork0RJM7AVgWmbpfgzWVKDp8K/X6qUo8McW7msG4XAi7qUUZsyMMJAp5?=
 =?iso-8859-1?Q?GPsfqlzf1uYdOGvpva5Mnl32/3fmNoFUeJPuNSSPzl1YnI7yuBYB20J1+h?=
 =?iso-8859-1?Q?J/iPDUH7BCPZHpwVqTadMIgmosStTSILNc6mUClqqS35pwNQ4uA6AXlLen?=
 =?iso-8859-1?Q?5+jZBKjKuaxKyKjCKfb+iYt+Do3lpqIgJcSzo8HkWI4FEMSf7KYVWBnjQy?=
 =?iso-8859-1?Q?/uhStWpZn3ndGd5PHvjWrO6UbBS4SBhqePpEMzmk26CZesWG9YeTzr3LT7?=
 =?iso-8859-1?Q?MyBx11AWCapJQtPeiSH9ACAv5hyDcppjFkiuN/q74D+w55+daHyx999d6n?=
 =?iso-8859-1?Q?xjOij7rw5rdp/7w2aerGFPxO4UKYd99/44i8PBUDZOJxKj87Y63I1IMA41?=
 =?iso-8859-1?Q?tdGlEtJ547F83afjdilZ62+9RCFUziixJYp9vGOSibUgoZAKaCFWI0vqvE?=
 =?iso-8859-1?Q?GHV8Zh4n3pnrM1pizwkVYW+wype+l+znR802SerQpnvtZVRmnXKH1LL/Zf?=
 =?iso-8859-1?Q?Nf/1VzlPO3v0NetlG2Lv9C/OSz+V0owFmLn/LA2KjvxZdSX4IzFLRyn05f?=
 =?iso-8859-1?Q?dWhDwFcCwFoPrpyYP+HPzHskSQqdtJ4frb7+yE1djGfc13bqywjalxTrF0?=
 =?iso-8859-1?Q?cc7wJ6FpvP1Lo=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e2063fdc-f108-4ea2-df94-08dd400b3fe9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2025 02:18:41.6795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 28LYrwEcfUrwR+LHq5dhGFtTXHjUsa5a+Hz6TUGeG2Vn/WFiRAkzn+6yo5hyd5L5rC8NVP0RoA/v0zi2RGQgdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9495

>>=0A=
>> v5 -> v6=0A=
>=0A=
> LGTM.=A0 I'll give others who have reviewed this a short opportunity to=
=0A=
> take a final look.=A0 We're already in the merge window but I think we're=
=0A=
> just wrapping up some loose ends and I don't see any benefit to holding=
=0A=
> it back, so pending comments from others, I'll plan to include it early=
=0A=
> next week.=A0 Thanks,=0A=
> =0A=
> Alex=0A=
=0A=
Thank you very much Alex for guiding through this!=0A=
=0A=
- Ankit=

