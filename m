Return-Path: <kvm+bounces-64416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1219BC82088
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 71D77349C84
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19C4318152;
	Mon, 24 Nov 2025 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MjG5vecX"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013063.outbound.protection.outlook.com [40.93.201.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBDD314D17;
	Mon, 24 Nov 2025 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764007689; cv=fail; b=ZkHG6xjip1hgi9QVXjr7041VV0UinNk8RlOzRhy3s/QNHLX6sh9wmIv7mjRefWb1W/84ZH/VfiTLycKevYjKZk6DF6oQsmPyylQ/RE2vyHF5tMF440HI2DAYY7kS/73mLmWEvFp+J3HUUaJxStYnNo40CRvxif/oLWtRB7gKggQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764007689; c=relaxed/simple;
	bh=i8pnYE9WloPIMw1gIoEhzh7bh5Hl9Nk9oMzfX+azCYU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WaD6RGwwNZ459EiNZtYnqJj0yUBUdTB8CnHaOVpN5xoSFlhAoZ3MYh08zduyogffMgwCPuQHYiGxwn2/9+5LzHMPeCMl/zPKau+/oIOvOrfDf9QfnTd372o+VmJeJn/8cprd1PtdRMJSCOdAbjiodgLM42YgIjV1SbB41t6Iuio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MjG5vecX; arc=fail smtp.client-ip=40.93.201.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PwreFWB5M087zkorMi/FGmjYv//gByrEck8qgxkA186xx8K4LXWZ30SOQVIBdkHSTpaakuGFMJzwWJ6nUW8Rlx4rRVGPa8eRiWtsMc7cz9A7iHLLuOAPlidTLuEF3/bdq+25I36wybjETEXkYA03IOloVpTPeGxDfEqYC8o1uD8tQGmDKJO6kQme1TCJ/Aj2eA6vKu6ecl2FUcwTUjwTNRtf9EZtwPQ9hi4ceSPdQNUpvWeQHAv+eVabMihONKgPkXXvZD1OSsnoRQcXAgVBvPT9yua2p8O5pZxiWnk4YKd3meyiwdlTfGrEJb3Gg4e3Sql4LyFzSDNz8+5l2nsfOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kg+E9LHH/CUJIZbVm7ewHwpCNyB7GTQGqcUuTBIrGvw=;
 b=Y/w1aZuuTXlT6+EEurQ9XIsggYSOvxOzQTUIrCtNJB01sTAQSN+4f86jSTB/uRRYM3SNGWp3gPmghtKJnv2e95cMofLgqSsCJS3Gen3IRZvX0O1pM/hY6Xdsue7fR6z4CVve2xZHsRdQkM6RiCHALjZf4kkLiXgyhXDok5mkBQgLrtCcCt/DMhh6A17ED4sG/oVw1swkWW1HPGiHE/+CEAAzjKYQSpZYGiU2SknOjFEsEcF0EDtDtQC2JAmfTQh37cDGJqPVjZc91PoeSgjJDFToLFZuoLeAnRjFHxsj9NZy8Hl3+MTw0g6X7MYDawfIGmMHNuUMLgwQS3hFSx0vXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kg+E9LHH/CUJIZbVm7ewHwpCNyB7GTQGqcUuTBIrGvw=;
 b=MjG5vecXmkosG1D51pvF5dfBV2l5T8uc2NEPHAEAOriumLIsSWuTry0K8yQEhyDjXgnOQhSJgwE7D61RH2unMO989vrBItxD4XltlukiRtXCwSKwnATqi2p5wTWnwF0MI1jO4siz11gaosryfhybk9Dm2Wcb0RMYX8isZ87RajSF3rHRv2/pkc9OxAOjEf4vw1GUXph0ZxWWoKOsBnYKs/FppCijkOSLWc9UXXS5i9K3cWHbK7mEdkdwFiS/+a/QSt4hB+tHOQLBlKDxMf0fPsM68tgr4JXlz1I4BECnFqRyXa+Bk+KytzMz8ye6Ki2zoT4fV4D1i8ytuDq3r2Cqlg==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by SJ5PPF8AECCE022.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::99c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.18; Mon, 24 Nov
 2025 18:08:02 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 18:08:01 +0000
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
Subject: RE: [PATCH v5 3/7] vfio/nvgrace-gpu: Add support for huge pfnmap
Thread-Topic: [PATCH v5 3/7] vfio/nvgrace-gpu: Add support for huge pfnmap
Thread-Index: AQHcXTnUJShiqd2+GU2SWA/+Yd6vO7UCHoXA
Date: Mon, 24 Nov 2025 18:08:00 +0000
Message-ID:
 <CH3PR12MB7548D60ADF0FDB0589ACCDA3ABD0A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-4-ankita@nvidia.com>
In-Reply-To: <20251124115926.119027-4-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|SJ5PPF8AECCE022:EE_
x-ms-office365-filtering-correlation-id: b2e52ba1-d322-4ede-2db8-08de2b8467c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?woPmktsih6yVvXBpjuvoyp2tCYuJc4VNZG4oI9DQLvzwdy07g8jrJPlpRwee?=
 =?us-ascii?Q?/Sh0Mls5mAelMhey4xVFXMI1POHSNKzCj4DQ3ILsVw3RWvVu1igevRp0MYd+?=
 =?us-ascii?Q?UpOBoc81xYhrLvcWH1MAftfJGRL2vmbyKPApT6D5U0WbhOjbnvbWmQQgJNOs?=
 =?us-ascii?Q?fDW2CHjGJlgB88Iu3FjrQAym47LKLBSoKB0P/dA5PamsmZmrrapz3tzSE+yh?=
 =?us-ascii?Q?m5OD7Vu8ug7EXBOvt8qKK00bxiaORCXV2Njs22Y9sCpj6qTB4Mw9TZ9dpXBk?=
 =?us-ascii?Q?FXF02KI3D6dxr6v8mqX03JVv/2Eh3nN2AQcQGeI2CddZd1hLIFlf7ptBrncK?=
 =?us-ascii?Q?cOImloW9mqGoIpPvxnPkyipKzv5EnZuS/lIUzpvZcc42NDQWMPV8wsYgOYa9?=
 =?us-ascii?Q?KsFg4Hez4O9Q04B0/1g38Jf7/fpl/QvAu5lWJV8hXNFYvn/U1pq6G/lQyjXk?=
 =?us-ascii?Q?/IGpiuKap6PhJEXnl1H66UwUgUxJUOo2JC8wUFB/SK6t//tD5dv0GWPXycaq?=
 =?us-ascii?Q?mRva0Yfhv3nHXQlBCNPh2QNyL0KQ0RJnUGXjHYFuWnKOXVeq8e6Bo2/2puw8?=
 =?us-ascii?Q?iCUzhwnjbuQmGbFzHf7plVuXMmJO74v2XKkeJLdA5tSoGETcmyLjjeB2lQZa?=
 =?us-ascii?Q?XBXqfTxsLNh2xIUqg1YIjbd0tDCozw2OzcJejNcwXkFQ/zNTrE+wcAnNUJRV?=
 =?us-ascii?Q?MnDPhj+0WkRf4H5Zhdoy6JFNrOb4qYd6+LYsLdPCvgl0MjYLywvAPCzmqLTq?=
 =?us-ascii?Q?cwU/9mKSEBp/w6Sos5t60fkiU4YkFA9KDc0khJyBFOa15yDvyD7VjQkh/4xv?=
 =?us-ascii?Q?b0I7LPOsrmEGUVj2wXsABrngHWvEqqIXw4Va/NqKt+SVCGN5HLCqVIn2OQkM?=
 =?us-ascii?Q?FFML4IhXU5bxKpPiT/cAtq3becuO2+DkqqR+wSjYRnn/3tQRdmr/GP/KVFTE?=
 =?us-ascii?Q?EFn5sbYWFcL4hM80bPqP+8JfkVZfz7TObiXuDBboOlLgV6t+oEGm0CCYcJJ9?=
 =?us-ascii?Q?7SXHJ93ia3V54Y+mIlWecsC36eMPF8dm+qQwvwSTbuYXjMg6ha9bPoG3Yl8E?=
 =?us-ascii?Q?hhuUMmX0niJWLna3GXp+nv54u52lsJlk2ZguU0BMz7nFht5pAmdBVVei34oR?=
 =?us-ascii?Q?/hF7fduR5w1BTL8rjBxCM61ontm10IDuuGWGTSG6VuCiwsrj/Uf2c3ln5IJV?=
 =?us-ascii?Q?9qGJKza//WEwpwhUQRvuHfJMvjJpXBjBchX8sj+LNVXPPwX8liLjMCHnwI/k?=
 =?us-ascii?Q?qAyBPgwOhzsz1uIEiD1PiIvmIx04wnCy7foaiTdjUHRIwpRuLFDPzhKDhY3n?=
 =?us-ascii?Q?GTXx1zJkdcw5KgyiOG23NrEMXRnrhg4AlN+8xRI09nqljFsWItLbft8iuaf7?=
 =?us-ascii?Q?fPUyHzJYpfin9DUMtGPgSK1DBa0jOwB/EBBJd0s+2OERRKPsYqV3Dmfqu7KY?=
 =?us-ascii?Q?7bZXWoUE/X2e609jLAyNac0I4qVA9RLgi5XORZE6kZA3ZvSVcaVfv8Ocs+wS?=
 =?us-ascii?Q?TH5WCV9toKOedOrBRGaC6HJbRshwdVzstlVD?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Xu6LtDMxXtWU3lE7Qi4EqLWgQWbbWa2yZ5qeCcNtFR8mJYCMG5J49snUr7lX?=
 =?us-ascii?Q?OJhh1JtmHzHD2iRn4BmEVmZedbGhR6X5lbQIhuGPNF1x02niOQ7+ptOZorzX?=
 =?us-ascii?Q?9YbG1Q2563qLpOjDJOkD+P3rETNS1bzWvuInxKYAuDlmM7KhXSBQZc+9z4q5?=
 =?us-ascii?Q?2G/4IeXgwLXlJtkSgfRb6txRIi/3/3GQOl+zqzKk6fkVzPCz74xweJ7T73EH?=
 =?us-ascii?Q?HIrKcsA/t6rYPDIfiRd4WUWwUNTLEbB6lrHIL/tLPtjh01lMzeS7vV4yIVsQ?=
 =?us-ascii?Q?Rnqk+lBuO6R7wzbe8tlHHTqQn2JsOFx+VVaB6VjicwABT+yofa+uDT+vLCxx?=
 =?us-ascii?Q?sDxx9XJdU/P4aek+nPTktPLLglc5xF2b/dubvkC7B37BjE9b98JkofABI5TW?=
 =?us-ascii?Q?yt+C3oSrFpbrpRCcpVhQgCpuQvAIif9FYvynbCaLYtPYOAQQjFoUFB4Kz7LT?=
 =?us-ascii?Q?RobXK+Cqbalwo55Z6Ir0PvtEUoLv+IT7ve+qV7+jZWbkU8RcGPEPDc6c5fq6?=
 =?us-ascii?Q?NDx1VKjLFEwr8VlAQ5BRC85ncrzw+h2gK2w2Ttj1BCkN7cw8fyX4i0AJDVwG?=
 =?us-ascii?Q?dozb1ILSQi8OuWyvVfxFVtkMp4G1pJ2B8Zwuw6vW3F6iu7Zp5gcX9YkQkL7q?=
 =?us-ascii?Q?8zh1YQbYp9N7RiOe/d0pmSMBysmOljBvfJyOU03HZwZHNEVKPAfjgJAlFpm+?=
 =?us-ascii?Q?67xY1RQ5EwjmLsdDN4Pa2A6EZzhNSluC+1AQB3wUZXEsrqeU34SHxUMof2i9?=
 =?us-ascii?Q?RQi6vli5EQPRwvR3xdOETsDJjnRr70C3Mt0iYQmTSgu3VJ86kYMO+D8OIVme?=
 =?us-ascii?Q?ETmBlI3nAcd283/p2v/ZVX+lUVt7h1gOsJKlAISVvo1KiRSVDLGD96kJLcfK?=
 =?us-ascii?Q?kCKLX9ojmO9ABHG30ZgvclOU+JqLNrbVFl24xIQRjZ/9m49R/cIcKRgqFRCg?=
 =?us-ascii?Q?qFlh5iGo2K+I7fflQaYT8ivGJfjugFSn8ZSiqDBr2OlOQ2iJ7cw/XnUgRBB1?=
 =?us-ascii?Q?+cU29y2RFyVUCsp5Dv+5mgY2Ww8/WlN2gprtzTLN6aKrH3mrrZgXNJgJstS1?=
 =?us-ascii?Q?BtdRuLn9PXUhXvVavCYyhuD1Zy0IZF0oW9x739MahTIgl1VPByPWze5K2c4Z?=
 =?us-ascii?Q?eIN3EBr5sE5V3KhOzJhV7tFXYe3e8tVe0bJdv/MUcYYmVY6JG1+c6OSvSF6c?=
 =?us-ascii?Q?aPNCwed8uPzlEkBauwU39mtX5m+0agvRew/O6ER6NHPDgJXWGfn4w1fUvs2B?=
 =?us-ascii?Q?8PowmRODQjWr6E/OVnlUAqH/bdjaq6wdmEE62ZtC3A/ZUq+FsL+e8eza4kWs?=
 =?us-ascii?Q?s9hYILj2ur1pFGd2v9JufdiqKif2uX1APhD7o1yirWsDWyaGUM9vY72jBdbF?=
 =?us-ascii?Q?7fRtJAvJwi4kvehNNa12UH+Etli5KyMVHgGWMkwU6SNXcRRN1+M7VEGppIWF?=
 =?us-ascii?Q?zOepdHPx25ulz2d7jJ+gAfkcXhE+mgqtD1OupzP9iHM1bqTBYXAJEzqY/6df?=
 =?us-ascii?Q?3fSwQ724E+n74lOwfCY9nTUG5xCv2afuHaA0Fd/k6slsH02iownyK9m6xWsx?=
 =?us-ascii?Q?9RdMwI1pGhtcumvdAbLn6dzKcxAn5pwbGwDPq2NM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e52ba1-d322-4ede-2db8-08de2b8467c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 18:08:00.9490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8OcdZAfCHdP/LY4dlHGqrqbuqQGR17okwm/mRERZUwOmcyyJqA3VpJEkcwQa2/4Q226HniHeb3u01xKSXFYbUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8AECCE022



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
> Subject: [PATCH v5 3/7] vfio/nvgrace-gpu: Add support for huge pfnmap
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> NVIDIA's Grace based systems have large device memory. The device
> memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
> module could make use of the huge PFNMAP support added in mm [1].
>=20
> To achieve this, nvgrace-gpu module is updated to implement huge_fault op=
s.
> The implementation establishes mapping according to the order request.
> Note that if the PFN or the VMA address is unaligned to the order, the
> mapping fallbacks to the PTE level.
>=20
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-
> peterx@redhat.com/ [1]
>=20
> cc: Alex Williamson <alex@shazbot.org>
> cc: Jason Gunthorpe <jgg@ziepe.ca>
> cc: Vikram Sethi <vsethi@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 43 +++++++++++++++++++++++------
>  1 file changed, 35 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index f74f3d8e1ebe..c84c01954c9e 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -130,32 +130,58 @@ static void nvgrace_gpu_close_device(struct
> vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>=20
> -static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
> +static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
> +						  unsigned int order)
>  {
>  	struct vm_area_struct *vma =3D vmf->vma;
>  	struct nvgrace_gpu_pci_core_device *nvdev =3D vma->vm_private_data;
>  	int index =3D vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT -
> PAGE_SHIFT);
>  	vm_fault_t ret =3D VM_FAULT_SIGBUS;
>  	struct mem_region *memregion;
> -	unsigned long pgoff, pfn;
> +	unsigned long pgoff, pfn, addr;
>=20
>  	memregion =3D nvgrace_gpu_memregion(index, nvdev);
>  	if (!memregion)
>  		return ret;
>=20
> -	pgoff =3D (vmf->address - vma->vm_start) >> PAGE_SHIFT;
> +	addr =3D vmf->address & ~((PAGE_SIZE << order) - 1);
> +	pgoff =3D (addr - vma->vm_start) >> PAGE_SHIFT;
>  	pfn =3D PHYS_PFN(memregion->memphys) + pgoff;
>=20
> +	if (order && (addr < vma->vm_start ||
> +		      addr + (PAGE_SIZE << order) > vma->vm_end ||
> +		      pfn & ((1 << order) - 1)))
> +		return VM_FAULT_FALLBACK;
> +
>  	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock)
> -		ret =3D vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> +		ret =3D vfio_pci_vmf_insert_pfn(vmf, pfn, order);
>=20
>  	return ret;
>  }
>=20
> +static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
> +{
> +	return nvgrace_gpu_vfio_pci_huge_fault(vmf, 0);
> +}
> +
>  static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops =
=3D
> {
>  	.fault =3D nvgrace_gpu_vfio_pci_fault,
> +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> +	.huge_fault =3D nvgrace_gpu_vfio_pci_huge_fault,
> +#endif
>  };
>=20
> +static size_t nvgrace_gpu_aligned_devmem_size(size_t memlength)
> +{
> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> +	return ALIGN(memlength, PMD_SIZE);
> +#endif
> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +	return ALIGN(memlength, PUD_SIZE);
> +#endif

I think all this should be ALIGN_DOWN to be safe.

Thanks,
Shameer

> +	return memlength;
> +}
> +
>  static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  			    struct vm_area_struct *vma)
>  {
> @@ -185,10 +211,10 @@ static int nvgrace_gpu_mmap(struct vfio_device
> *core_vdev,
>  		return -EOVERFLOW;
>=20
>  	/*
> -	 * Check that the mapping request does not go beyond available
> device
> -	 * memory size
> +	 * Check that the mapping request does not go beyond the exposed
> +	 * device memory size.
>  	 */
> -	if (end > memregion->memlength)
> +	if (end > nvgrace_gpu_aligned_devmem_size(memregion-
> >memlength))
>  		return -EINVAL;
>=20
>  	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND |
> VM_DONTDUMP);
> @@ -258,7 +284,8 @@ nvgrace_gpu_ioctl_get_region_info(struct vfio_device
> *core_vdev,
>=20
>  	sparse->nr_areas =3D 1;
>  	sparse->areas[0].offset =3D 0;
> -	sparse->areas[0].size =3D memregion->memlength;
> +	sparse->areas[0].size =3D
> +		nvgrace_gpu_aligned_devmem_size(memregion-
> >memlength);
>  	sparse->header.id =3D VFIO_REGION_INFO_CAP_SPARSE_MMAP;
>  	sparse->header.version =3D 1;
>=20
> --
> 2.34.1


