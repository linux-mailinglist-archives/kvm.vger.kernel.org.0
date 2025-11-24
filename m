Return-Path: <kvm+bounces-64420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4276EC8214C
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:22:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 363EA34A5C9
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F3427B349;
	Mon, 24 Nov 2025 18:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jSnYX/nq"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD793176E4;
	Mon, 24 Nov 2025 18:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764008557; cv=fail; b=Eo8gMCHvtbwl3N08ksxhg8fvWdoWBy+/2JL6FtCE5ibxZnNe1Z9+YmdjWZ3HH8ueuG2dZt2Jizd6/J8PXKI2pNOp50ttHsj0lxWJbWuHCQgAVCw5HfbUoJJOv44EJ7l74M/1xvyp5VSszNjRzplAglbU+HLuNNVyThJ78ahlHAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764008557; c=relaxed/simple;
	bh=gZ0kgYKTaiUo2aR3xPWQMJnccnb6+XKMohUJBKVdo1Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rdNjocbKw9crHl8ZXHhgcBdaeiRiEbwm78isV7MhwACBLxlvGkFjryXVy7+Bgux0Dru8rPkHXSDAHa4URd0ydjj75hCZA171UpYaH24Wp5dlpCT+r/vqetANaGA80SreU40u0ZiQUq2IDw2ckaJIR569INq6y+UiWhahmbZdlPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jSnYX/nq; arc=fail smtp.client-ip=40.107.209.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kjWFFAAZe4hlQjbEjhxIBXZWxQ1iWntwYXn/rDqtrvRQJTNSmgmU1sKj3xhVthxBU+P8w/zG+dGaiUEKcLzBuElrSsTer/4F79Su2A/t4W9hT3I7LPI3SbJ26ApkSHCin/S147ssTs70rq4EUjLf6UZysSHUplujh4HpfqS/PhiJQvQ/c+/YyYjUV5E/LB10AYJ0QLfaKM0AxRkWK4QdngcJ/du33zxnudxfvJ+KvoGC03nofeEuq+ce+vv2vabOlsXOGH51XU7ATlNjZFBp7v0YkyN6gKkH7WX0hoYjaC587hOTxt10bzQ6IM770vOmixL25vb6KhzOrMwcyX/CZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQUligm8utojURaRbgo5OvFtL6lHaQ21AOQIXbwvq/Q=;
 b=Qo4EGgMUZH+JAkjVXniE8b0pZcuchsZWLEh/FeevKzd5APVEWch2UpuCWZn3wq7o5ERP7ug7irvIisEo2hj2QWbVzkHwb7qtYS2aN6TKjqBWhJ3mwJPQ0PuNor/4fZGUK4p5bpQr26kn595hCGONS73LJ9nXsOiUmTkaqSzZpRQqa9XNX84FNAkR3f6j6t1ptdh3eg59YYRLIaNicYwz+ldcFZgXeQXKrvJVZm5OCYvS/i7kAc7B3UcftbxRnVddu63XAHF7buHGHb0M33+6tRIVkRdbzPsmWWId3sMGrSn3QmTxgyh0mHoooV2n3QRroFBSwiR2Uh0EJnZg6RsKyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQUligm8utojURaRbgo5OvFtL6lHaQ21AOQIXbwvq/Q=;
 b=jSnYX/nq6v3AWNZYrLbEYIt4MQyTG+biBBguNoAYx0YfgW2MLozeMwTMeSz/buM+IfSbtbUo3B3mJk1qFWosMecQ7wp8I5OB3URmPrihUu2yMEapXVmIQ0BtaYcDkxjWPXYZBe6ioLNtwe6/7beo54RLL43tIjOlf00RKpZXTblUDwmFKiIJeWMXPykAE5rybt0NWAiiepmz9LSTqVIcJvOQEWRCoHRrh02VA5O0ppvYYqwLjLcBe6urMIVnskwID5W+bCTEmY/XKEmTEPbN5EGb7b0/wk6538omQaa0qwMP/gU+cMMQYQTwHooHSW4k4jh5pQvzUFekzrNmx9f1kw==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by SN7PR12MB7909.namprd12.prod.outlook.com (2603:10b6:806:340::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 18:22:29 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 18:22:29 +0000
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
Subject: RE: [PATCH v5 5/7] vfio/nvgrace-gpu: split the code to wait for GPU
 ready
Thread-Topic: [PATCH v5 5/7] vfio/nvgrace-gpu: split the code to wait for GPU
 ready
Thread-Index: AQHcXTnXi57zRjKXNk6abw0ZipdCi7UCI6hQ
Date: Mon, 24 Nov 2025 18:22:28 +0000
Message-ID:
 <CH3PR12MB75483B12E8BFFECDAEB9E3BAABD0A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-6-ankita@nvidia.com>
In-Reply-To: <20251124115926.119027-6-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|SN7PR12MB7909:EE_
x-ms-office365-filtering-correlation-id: 530dfff5-e907-433b-dc0d-08de2b866d1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?LF0KX3+P3grTRy1tx7PaC+YdqPIasVGN+pNAKT6dbWvOVvZCDUla4w6YPKCO?=
 =?us-ascii?Q?bSrnkGQGcBqlpjQ6d2HCGPxL8V74dRUnlKknTxksLqYSMdWuRuUAsYnDJlDa?=
 =?us-ascii?Q?iX8QMw3ukKxZ43XYwGTWmcsw4ZbkLN83Td4yuJ9/SanUFQTqxzkRjbQ/Q0J/?=
 =?us-ascii?Q?VHgmv8old1Hjom3e+L7ZCKVbDbIMM6YYhf7WXyyvYSAz/oWGAFl77orMBdcd?=
 =?us-ascii?Q?U0E4tFG4V+JoSWU7POUhBZRaBXChEKJ9q4AhB3SRCvHQ5J/VLIedd/ag4swk?=
 =?us-ascii?Q?NMjuK5cKKj0QjOHqQTMdDwR5ougOiSsCCtiDVvV0oSprcgFIuaB+aXE7Ycwj?=
 =?us-ascii?Q?DD9NG2xfvvvXGwGPByA86vTWjFaCY3GpDl18p/AEHWucPDHvFWEBa9iR9pRZ?=
 =?us-ascii?Q?+7wPjJ+efZHiEISQN4jbPiTmUPahBKDJu2fNVQKWdh5iVT5imYMBO1x8tbpW?=
 =?us-ascii?Q?+1NPDlcPOU7romlU96M667ni7UsWyAZWdE3J7KzwkYvYglULdPTn7Bggbijj?=
 =?us-ascii?Q?+h6JPf3dyixxlU5OSkCHducMQMKaD3lqS7ki84NR7x0289hPyHBqQKncXpnZ?=
 =?us-ascii?Q?WoPEG1eoX92ALnWd6nZJ7rfWMN3OUBYtx9w+0MwGAf9H77RjH418yjvzVqVw?=
 =?us-ascii?Q?0Sr37yAap8jy/Igm5Rx3XNl/4fk8r8fd45Svm7veOiNig1Pwg0HEPWxP+pu4?=
 =?us-ascii?Q?lRWSwKQeeiwRfV0cR1mQK5nJ/MH4gerOvLXAoDpuEtQjNrZlfEvsxLtISabE?=
 =?us-ascii?Q?EN4l4gUxdD/91osxZ58JgEu86DBKgDnFQ+jk5rsHvMZ1V0cn70skIH4jtv0r?=
 =?us-ascii?Q?sEoL/Bk0ekxrR9zgMclUVBMvuZpKixlEbe7NVKujNKm349xTrVZnbthTmD9o?=
 =?us-ascii?Q?XBsw+KKm3Lw3vGED7Acq0KBmzBFk9QK11VSOyebKU2WV9tBDmm9OslwqZRA0?=
 =?us-ascii?Q?q17JFPlSNADQHQ/EMuZ+6a26MJMaKtx25P1m0jgc4tGegBzIONNKnxkvUQ0m?=
 =?us-ascii?Q?LvzmczHusgRniXbWE0Lel/yffJnEM/7dgoX1cdRgcZMC9o8GReonsG7ezABV?=
 =?us-ascii?Q?r00HYBdDcLgwzPN3IJAgop1Aw+CYgx4K6lzFaptACctRrxP9VjM5YDeFLQHx?=
 =?us-ascii?Q?2ZWOMd5QAE38BjvK3FZDy9TVT/AKK99ygTS7+Uz4NAaqnm6TfFW3gODvQkn2?=
 =?us-ascii?Q?0al9keR7il15H1ZKevQtrnbDDSuIwBz15+pWvSa+Tq52q+d4z7K9Qw/HlMRe?=
 =?us-ascii?Q?D67orwATW6B29ehpveFaMe4RUuh221CwXnnucFl1ALHHf+bFF8/1u6rh9cW7?=
 =?us-ascii?Q?wmqhUkkJRwRSVBbVpRrdGHYpcQ1yxtSc3enfCgFJPOMC0hF6dGYuM4wdyeOv?=
 =?us-ascii?Q?8wt99SbvJVkNDxBcI83RTeFSnFP2Fr0P/fAvc7XDW064npqfCA3TcWxNXIYw?=
 =?us-ascii?Q?45l1PvH58IqRvZFGhWmoNEHpSxbYi5Dr0jRS58dZBfH+AuVwf698vBp1ig9L?=
 =?us-ascii?Q?sAypiNXqOC8wdO9fg9GBsKVleu4YKPnBO91J?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yLtjxH6007E/iAUbLKsLFUes8fef0A8C/uFL/6LW4AvklR9iSJwXE5eOhTh5?=
 =?us-ascii?Q?kkwc4RsqqASDD0RS8Y184AkRjGx2Cm7BFKEKlnoNY3SYYesECbNVccy8AB+G?=
 =?us-ascii?Q?Xq7DaJSUtVf4tnSnRVG2Q3ZhMAT9oiZShwUxpItq7lwhpGwjmwJ+CNAc0b0k?=
 =?us-ascii?Q?Ehi03yq81uBOz9viowaLYkIxSa2Q1QIUdFWDuDPtJdbagjag8gGUycnXn03/?=
 =?us-ascii?Q?xgpuDwmcEJ89euWMVOgI+4xi43JPDdjqPCnBjLJXiyMz/FXE9YcFQKWu6O8s?=
 =?us-ascii?Q?CXIOi1MqkJqM3BK/yYKqVmvzsjswFIQOXCs16GIAiE4kPX/34dEyp6w2U3XF?=
 =?us-ascii?Q?U6SEgKrrg2X0BgmlAfv30fmm7gcOUpXrOdTvcrSQFrYAf5GGM+KGVqWnLHQ5?=
 =?us-ascii?Q?lQYzsjNizidRmaU052iAA0LXTrmUsphnSYLGfGsGH8Eq5KyrNVRUbCQnJcLE?=
 =?us-ascii?Q?iOnE9PTTcSVm/8vF42G0AmHbOIw17oVLZCCb7xlCxp+YWk6iCFoocuNB8HQT?=
 =?us-ascii?Q?JaNRE3RLIdNcRY7s/+/MhnvqrbQuLcXd5cZLYHl3F35G1DG49XQ3SKhEEgBl?=
 =?us-ascii?Q?XlwRq8LND7zILqNFOT+9ptAm9cE58nCgkxzOWh7FXercQTSRW+Qr7SVkntRj?=
 =?us-ascii?Q?shl4sigLUNKFd6kTq1VuBO2f252TbMsjZbk+fUt1irlrUCEGxH11GJBHI3vC?=
 =?us-ascii?Q?wFkOIqZRXgBZRVdFXMJKgMPsYb8JFcYnBTPFZPc4dkIDchOULVi/4jiwkChn?=
 =?us-ascii?Q?7ovnn6AP4ZbYvCNp5vgXrCHk1zu6qcNMunxl2TH9SMDy7b5KqOCzCfLoYGnQ?=
 =?us-ascii?Q?nkQAwQY89vV0hjbOSggeqrvD1hbAsobqbQhUj9ZOdCjSfkdNGZCkMzH6aBtZ?=
 =?us-ascii?Q?FaFCLhDui7KWGPBg1Iy64SPLxpjmB1neW7LCS1hLGeb6NXQDiPBVcxuBGymD?=
 =?us-ascii?Q?HCZpblNIe5Kt497BNo1LMr1TMblSjAIZUIMQXi8YIE+bCSpXWvUPwL6+y0JD?=
 =?us-ascii?Q?mzM1CJhB0WbfO69gW5SULCbgcrsrF+OrCJ67IDY7RqYz8shpXEebz33jUjdt?=
 =?us-ascii?Q?B7qMMTWTdfmopC2dBfdcotzQufdFXKp4zlZKzbtcD2MwdQdvld2xRwyRuS2X?=
 =?us-ascii?Q?nI7EMRKyzadBfdc9OeihTpFbdf7Fbh1r383dcAxbakyYjZJbZ1UxoWB/LYpy?=
 =?us-ascii?Q?RmgYCjcfEIsgfeGAtKftae4OL2rgzHCd1i+2bzOyX8yvGY0x0/k6705v3IXz?=
 =?us-ascii?Q?EXJelbZwH0mChYsD2cFPHyBP3ziWXAhPDB07jBZ+XoxSn0EFJ05E0u2nM+tB?=
 =?us-ascii?Q?rvoRJFgggyNqlGExBNHaRaCT9Rp6F16TKu+khIYPEoW3vqbFeMUuw7DOm9Mw?=
 =?us-ascii?Q?u3gPJTi7HRyvV1gZgYZivW+iEkxm5/rnmZ+Ac9moZbDPVNV5x3QNXoloxIqD?=
 =?us-ascii?Q?tT6FoNWERUgOhgkBA8yXtwhSKuebElDW51e8+LbyxhafxFF3TzsvcEJF9IE/?=
 =?us-ascii?Q?wuyniivB8ar7Za3ROQY/b3ZkDkJBZp6kJ8OzEcYaE/1kCqj0s7FG2bEUUAbr?=
 =?us-ascii?Q?rhW+mZ06xSuHlHjI8S6LU+tfiGz4tkwdXbuj2ucM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 530dfff5-e907-433b-dc0d-08de2b866d1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 18:22:28.9279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RBl7WkgQ72F2xlEUdYDWz2hwrmWj3jjYars2XhsrCM4fZGbTgpuKVXENQ4uhcL1ZtwB4BHMxi/2JY/PIZCmBQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7909



> -----Original Message-----
> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: 24 November 2025 11:59
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
> Subject: [PATCH v5 5/7] vfio/nvgrace-gpu: split the code to wait for GPU =
ready
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> Split the function that check for the GPU device being ready on
> the probe.
>=20
> Move the code to wait for the GPU to be ready through BAR0 register
> reads to a separate function. This would help reuse the code.
>=20
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>

With a nit below:

>  drivers/vfio/pci/nvgrace-gpu/main.c | 33 ++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index c84c01954c9e..3e45b8bd1a89 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -130,6 +130,24 @@ static void nvgrace_gpu_close_device(struct
> vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>=20
> +static int nvgrace_gpu_wait_device_ready(void __iomem *io)
> +{
> +	unsigned long timeout =3D jiffies +
> msecs_to_jiffies(POLL_TIMEOUT_MS);
> +	int ret =3D -ETIME;
> +
> +	do {
> +		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) =3D=3D
> STATUS_READY) &&
> +		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) =3D=3D
> STATUS_READY)) {
> +			ret =3D 0;
> +			goto ready_check_exit;

You could return directly here and avoid that goto.

Thanks,
Shameer
> +		}
> +		msleep(POLL_QUANTUM_MS);
> +	} while (!time_after(jiffies, timeout));
> +
> +ready_check_exit:
> +	return ret;
> +}
> +
>  static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
>  						  unsigned int order)
>  {
> @@ -930,9 +948,8 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct
> pci_dev *pdev)
>   * Ensure that the BAR0 region is enabled before accessing the
>   * registers.
>   */
> -static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
> +static int nvgrace_gpu_probe_check_device_ready(struct pci_dev *pdev)
>  {
> -	unsigned long timeout =3D jiffies +
> msecs_to_jiffies(POLL_TIMEOUT_MS);
>  	void __iomem *io;
>  	int ret =3D -ETIME;
>=20
> @@ -950,16 +967,8 @@ static int nvgrace_gpu_wait_device_ready(struct
> pci_dev *pdev)
>  		goto iomap_exit;
>  	}
>=20
> -	do {
> -		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) =3D=3D
> STATUS_READY) &&
> -		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) =3D=3D
> STATUS_READY)) {
> -			ret =3D 0;
> -			goto reg_check_exit;
> -		}
> -		msleep(POLL_QUANTUM_MS);
> -	} while (!time_after(jiffies, timeout));
> +	ret =3D nvgrace_gpu_wait_device_ready(io);
>=20
> -reg_check_exit:
>  	pci_iounmap(pdev, io);
>  iomap_exit:
>  	pci_release_selected_regions(pdev, 1 << 0);
> @@ -976,7 +985,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  	u64 memphys, memlength;
>  	int ret;
>=20
> -	ret =3D nvgrace_gpu_wait_device_ready(pdev);
> +	ret =3D nvgrace_gpu_probe_check_device_ready(pdev);
>  	if (ret)
>  		return ret;
>=20
> --
> 2.34.1


