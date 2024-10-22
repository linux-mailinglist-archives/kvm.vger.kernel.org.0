Return-Path: <kvm+bounces-29332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14EDF9A97DD
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 06:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB9A02849CE
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 04:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DEF12C552;
	Tue, 22 Oct 2024 04:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PefZx64p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB4D1272A6;
	Tue, 22 Oct 2024 04:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729571296; cv=fail; b=hYEcqAacVLtb13Hd7mPXux71ak/3FM++IeGZvFKe6DpD4go4rwGFpn6Fgqhe/Y8dH7pRcXFy73GbIZApUHweWoCMUhWRYk1sj58W2KqLwZcksyGVOAUTt1KU7z8E8j64UEtU+Z5DAixyBjI5vdlzmaJtAcw0IC9Qv0w1CT1oErM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729571296; c=relaxed/simple;
	bh=cO7X0rDcz8j5OBgA5qk6yxgEzDkhEQrAcaoGNtuF9es=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ltoo/UPYXbVW/GtYmJfa9aABWfM4TH0osfd5WsFYpc8IfZmRn5CvkVRSOv+IiA5k7Y5oF62EoB+lEwjt329SpdqkoQexOIk+XPabWOn/UUC4aufpu4wopfXvoQbPbPlSFTKerSabRHzeohQxOQTyDGPTA0ly8lWpAFbzhcGFDTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PefZx64p; arc=fail smtp.client-ip=40.107.94.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qahrhSE5PQEw0Rbb/q03DZvbMwUgv4XQjGgQQRNPcNGCE/JbiItHQiflWh90hvyTf6CikARbdENgE0aAk4ZoQ2JnGYTpUCd6fV0i8PKwz1+fNVWA9MakA61BgxkSpoan4c/bXMZN1GvDOWwR7SDraPegkXy26X4Mk42DBWxmsFRXE0usWBzAXCELwOcONP3rawJZlZnJYesUq+X4xzXAXtds3nSfevv1dOGNeXlXeSXxBdkqWzpMVVETTYQqfJ4dv/iKh3GXG+NMrA93xboGwk78vcDV3t7iF8p3QCe3ZkmsLYZm4su3lKESvaWBE87zClZdOsNZd6kiFUEv/GxKHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PeEC4U0DUsxyNqZoHOoJNLy9f60xk2kAG3OhuqJAtOs=;
 b=Ny2uXi3P8yhttE022Pj9OXrYz/0u4r9afjNiqZNA7Ho/aGhFbEJPTspBrQJNIbTPsaOI/UapI0U5GQzaiixcNkNRDl6ZPoRFx8qTibT3GW8i7fFwozYw7VkzMjSIpLRYUxlxproEQt4FdR0P0FUIXzU7jhgeCzQ1Br1VgYO9Sf8N0XV8Wpgofydu6bh/Fj4I6jDYodl9gDwgPvfkJ7slkp+KI6Qeru/EXAoSE4/DZ1KumBPrSqbcAYjAIMEFbC2XL6ED8BKhJk/ai/Is6XS8zEHKEGlc2GK+v0utYobZsnnCnaTmEIQQ+CEqwiOEV9+o6kfijAzWWibVnCIoTqQ7Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PeEC4U0DUsxyNqZoHOoJNLy9f60xk2kAG3OhuqJAtOs=;
 b=PefZx64pYdwnKz+f2nomaeuPiy5TZTwU+kN8K5sdSvNam8p5LK0bdCxFfPdX1Zk7iXK9RsvfKR/Cgj/pvZJM6FAPg9xcHExeEjumzA9EilwH48syhJbF594bJzXFyA9jOZIs37/GU76uEiLESH5OqUB4oJfpmWoTHh0i+u3BiYU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN2PR12MB4320.namprd12.prod.outlook.com (2603:10b6:208:15f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.16; Tue, 22 Oct 2024 04:28:12 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 04:28:12 +0000
Message-ID: <8039c16d-eb1f-c416-a6f3-521107e2aae9@amd.com>
Date: Tue, 22 Oct 2024 09:58:03 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v13 12/13] x86/kvmclock: Abort SecureTSC enabled guest
 when kvmclock is selected
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-13-nikunj@amd.com>
 <4e43f173-6a89-c1ee-5f1c-2f7e23ebcbad@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <4e43f173-6a89-c1ee-5f1c-2f7e23ebcbad@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0071.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::16) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN2PR12MB4320:EE_
X-MS-Office365-Filtering-Correlation-Id: fdf7586e-db1e-4638-4ecc-08dcf251f06f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YkY5eXZWZ0RYM2VQdDVjaTRhYlQxT2F1SVJkQ2QyVW5ueU80MWZPcTJHcUNt?=
 =?utf-8?B?cDkrRS9YVGhpeWszNm1sMlJTK1FxeE1pTlZBSjdCdHc5Z2Rjd2RVU3BQbTN4?=
 =?utf-8?B?U0kwN29ZaTIvUWhEd25OYnA3WldJMnhaQ05rTkY1YTRGTFdzdkNnUXhCQ293?=
 =?utf-8?B?NERMRDFTMzQ3bUp2Z1kyV2g3dVpkc20zWnYrN0ZOSUoxQThpdWdRb1dzNzF0?=
 =?utf-8?B?NDBsZ0VyUWpjWTRoOElnKzg4c2x5MzVRRU44NTBSY05pZHhGY3VMbk1VV1o1?=
 =?utf-8?B?OXp2aXFUN3BtUXNITnQzS014NDM4TEx4VzVnNnh4WmxXQUw2REhVSG9NWlBr?=
 =?utf-8?B?MHpnVG1YTEJqb0dQMm5yWE9tbHRwbDRPbDlCVWdPS0J5Mm5zbEwwVkdxdDVi?=
 =?utf-8?B?cXVDRCtrdC9hc1lTV0szUGZiVXVPNVRnWnVyMzIyejRqNlE3Q2pJUEc1S3Jr?=
 =?utf-8?B?QWlxL3NCMWZvcmFPNWZYOXYrMWVlV1lxKzVjbnM5YkhyNUxXLzdPSTNUMWI3?=
 =?utf-8?B?SGVvUkJ3ZCtMMHZCSWQyK1ZiTGF5VktwTlRyUUxCbk1CM3k4R1JJK1dERDJa?=
 =?utf-8?B?QzltSWpNNUN5Z2hTelZoVGp5d3VaZjZMbFJXU3RIaDhITFg4eDRxd0lZQkdF?=
 =?utf-8?B?RUE1SHFDWE9CbVBqUUJuNWprUVRxRnRXbkJUTG1GdGxLYjhRR3pJSE1qS0xG?=
 =?utf-8?B?a0Zxc3V0SWVpUUJTQnB4UXNheTVTODRHSGs2ZmwwVElrQ1RxeklVakpoUm0z?=
 =?utf-8?B?VGU1R2dYNjZ2dDh5cmtndlBzN1BqYUdQWTA2VVhYWDI4TkpYQktuY2hnSjZy?=
 =?utf-8?B?R21NL0czSk9aUzl5b1lYUmlIMlYvVHlNcURBUVUraXFRNnJmVzIxYWhTL1lX?=
 =?utf-8?B?SjhoYnhpaVFmMTdMRHhLckJJM3VBKzl3MGhOdnVtVG1BakZiOWNTZFNBSXhh?=
 =?utf-8?B?UTlxT0hFWXlyQ05MWGgwTlRSL1dwZFljdHhJRzlhMUlPclAwZzVoSzVPNXJs?=
 =?utf-8?B?SzcrUGJNQ0p1Q2JPZElrYVh2QTI3RmxiV0NuckFsbG03L0RFT2EvQWIveXhp?=
 =?utf-8?B?SXNLSEtoWE5WTm9xTnhTNlFReEhXWStKTFFJSkYwbGl1L2FhdnRYL0Jybmls?=
 =?utf-8?B?N1FnU0ZRbDg4Z1VyYVdIT3h4cWxHNUxIL054endaMFdlZ0ZRMTl5L25aeFJr?=
 =?utf-8?B?WklkeU5oMjB3cVppZkc4bTBmWFB0UWVQbjNSMVRiOWZJbnNQSjl1NER3MVFB?=
 =?utf-8?B?OTZtOWdld3lQa0puSU1qMjNPWG9KTnRSbWhiWXc3eHhWSGhRV1pOcmEzRFVK?=
 =?utf-8?B?cEYwYWZVUWV0cmIzcnRkNGdnZEJsMmVvUnN1V29XK0VPeml5SHV5RmpmTHZ0?=
 =?utf-8?B?bC9PWG1iT2NLcnhIeTRRMEVFaDV2TU4wTXNEa1lWdHBrYnFpRzNaTEg4aDFU?=
 =?utf-8?B?ODBNbFRQdFNmZWRRTVZ2OFZiN0NtVjJCUW5QSFFMa0VuMVRtajY1ajF6ZExF?=
 =?utf-8?B?RVZvQ29sT3VRaW1mL2lrVzdoc1M0S1JXUGYzaGVNenFxdk5OL0RDeEMrRlZ1?=
 =?utf-8?B?ZFdXRTUyc1BDNWx5b01leHpXTjlWNzhVUnNrZDBBRDFkNkZjV1ZJVmF5K1Bv?=
 =?utf-8?B?N3poS1RpL0JFRC9YdWErbWw2cW1Qa2dWMXdJVmtESi9iRmlCTVRjbmtvWktp?=
 =?utf-8?B?ZnpPWUpMZklVRHp0cTRIdnJ4SGppejR4dFFWcTdvUzlDNDBqdlRKdjU3NkR1?=
 =?utf-8?Q?m0TBZSoxwBVekZQbuLo3lN6SjqX6Jl8+r8RsASY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VG5BR2ZUbGFXSU9sVjdSTUNHL1pDVDlIdnFCaHU1T3ZmWXdiMitDaTU5dVE4?=
 =?utf-8?B?Q2xBSmlWYzlhUU9kQjl1YVppd2xXSzIwMEYvVGxnY3UrS01TYXZjVERMYjZT?=
 =?utf-8?B?bnh2MXBMMTRBWWhyR2xHSUhpdHI2MWMvYlZTSGVNNTRrRnFDdEo3Z1NaeGo2?=
 =?utf-8?B?Q3QvSGp3M1pPcE44NWRrODhxM2ltNisvUEl5SWdMZDNnMjZDa1YyUExDSnhI?=
 =?utf-8?B?UGc1dSt6R0RuVDAyaDJiU05wekUraDliTDZSQ256dU5lZUw3SHdFWFpBbWJV?=
 =?utf-8?B?dVhxTUZjdnlibWV2ek5nZjN6RStzZHZJRGxvcmdXL0M1ODFyUnhQeFYrRkZn?=
 =?utf-8?B?TitTOW1GblhuRGNqVFFleWdqOWNrbFNiU0FPYUh1eSs4N2RBak1iVEZlbnBt?=
 =?utf-8?B?T1dNME1kbllSWjdHSzVsWHdRV3pqbi8weE5mYWpaOVMyYW1vQ1FISW84TnI4?=
 =?utf-8?B?dTVxeTFoWVFSS0RHTERWK2xxaFVJRFFZOXFvM2RXT29tOHhGR0dpcmFlREg1?=
 =?utf-8?B?ZEJEa2ZzaFJJMGhidXQ1ZTRLd1Q2WjRqTkJNMGx5VDY5YlJ6eTAreUxDbEo4?=
 =?utf-8?B?M3RuZXd0ZDR5SDZNVVhhT3JxZ3lNaWdJMk0yMkFmbkV1UU1Edm5VNTRGb09k?=
 =?utf-8?B?WGRscGdlazJvaFVDMlk3SllJTW9FV2xYL3hDb2RiQ283aU5mWG95QkN0UUNo?=
 =?utf-8?B?VzV2eDU3eERmaXB4T1dGbktvNUhsU3EvQkFQRXRsN3VQeTBkcEU3WWdtWFVu?=
 =?utf-8?B?QnJGb2tRekhOVFZQTXpaRkRPSDdVUVVIa0VBQmRQL2kySHA0MnBtZzJZVits?=
 =?utf-8?B?cEMyWHFmVU04elJ2TWhBUTlJSWhOK2JOWlhJRXVZdnlMOHVzN2laYUNsbnow?=
 =?utf-8?B?ZGZEY1VrRDhCQnlvUjFaK2tDNDdjdmViL09DbDJDZ3IydDE2ZktsbDdoU25C?=
 =?utf-8?B?Q0ljcndhbE9XYmNKTk13bkM1cEhsa0lXZnZhN1MyZE9EOGNvTktyMWRrWFlS?=
 =?utf-8?B?R2tNdjVVdkpYd20wM05yWmJUUTIvb1k3SUNOWEt1N2ZTd0VpRUxIRmpGbU9S?=
 =?utf-8?B?VUFLellqVGFiSDFKYWdqZ2ttZFc0eDIzclYrVHI4UXI5ZVBueGwxbTd4eUxP?=
 =?utf-8?B?eVE0cEZTcC9zTWRWMXB3d212WG00T0lyZ3dYc1A2em5YNUxOM0ZkdTNHRzVJ?=
 =?utf-8?B?cW9EemhoSll0RjJzM0wvenI2eHkwZlF5SUhNaStyK2lrbER5OGFNSkZ3TFNn?=
 =?utf-8?B?NklEa3pJbGF3M2w0RDFzLzQyQ0RoL2FMU1JHaEo5b2dLMEdYVElaU3NIUFFU?=
 =?utf-8?B?NVBKODNNa0NiRTlkOVZ1UTJwa25FbGIwbkRGMXphMXFtK2ZwVzVtbEN5SGtY?=
 =?utf-8?B?SGs0S2J6aStGM1VhSFBYaVVzTE9sRk51UlFya0hOeG9yelZHQS9Xcm1lU0RZ?=
 =?utf-8?B?UHBhWlpUbUtrcFE5WGc5VExIYlpOQmdvdHdHc2tPQjF0M2oxNi9Qb3V0VDNF?=
 =?utf-8?B?ejFtMm1iV3F0c2FkU0RZUVVDS0F6MEVBTEpkTU9wRVh3NzRYaFRvb0tMQ2t6?=
 =?utf-8?B?MndCblIydjQwbVpvQUhwNkkzODRIZEtYSndJbWppMmhtZDRCdUltdUk4UVlD?=
 =?utf-8?B?ckVHelVsdVE3WW9SQTZ3RTVDTkpXMDJFZDc0N2RHMDIyZ3VJdHNZaEE0QmtH?=
 =?utf-8?B?K1ZyOUdCb2hJaDlqc0RTZXJyMVBpVnZ5b005cFRBb3FvbWdmQmc3Y051dTkr?=
 =?utf-8?B?eGtPSzNiOEZ5Wm5abDAzbzFXUlRrL1hVajY1M0s4NDdReTEvVEY2TUxzMDZG?=
 =?utf-8?B?L2EwS09VOWYwODlpaVVJY1hLTklRRXZXSFJzT3JpRzh2cE5kdnJSYml5RHlZ?=
 =?utf-8?B?dmVjYnV0cmVYZklsSDFLa0swN1ZrWlNhWWF6Y2JPRmRZU0krWURteUxKdlRo?=
 =?utf-8?B?dVB5V1p1NGdwSzJwTmwvS09WcEtrNU1wV1VPMFAxVGovR202S3RzV2xvTkpG?=
 =?utf-8?B?ZXl6cGRlOTBVUUN5VWJRbUJPSDZING56dkkxMmNoV0Q2YklwWGxzUzgrODNV?=
 =?utf-8?B?MUU3V1ZUYkZlRWtjYVJPc3VNaGdmRmhDZmo3M21DUGFpUTd3eU41MzlWaU9J?=
 =?utf-8?Q?pF74zjtdEC60hmIzaGACirpgz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdf7586e-db1e-4638-4ecc-08dcf251f06f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 04:28:12.3319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0GmU7gWOsokW2KdsW0nZRKZvt1gk84F+E4eSkeGkWyRZK2vmLUWw9/Tt2+LEgmLU3Fe/iUse8YhXhoesCm7s8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4320

On 10/21/2024 8:30 PM, Tom Lendacky wrote:
> On 10/21/24 00:51, Nikunj A Dadhania wrote:
>> SecureTSC enabled guests should use TSC as the only clock source, terminate
>> the guest with appropriate code when clock source switches to hypervisor
>> controlled kvmclock.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/include/asm/sev-common.h | 1 +
>>  arch/x86/include/asm/sev.h        | 2 ++
>>  arch/x86/coco/sev/shared.c        | 3 +--
>>  arch/x86/kernel/kvmclock.c        | 9 +++++++++
>>  4 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>> index 6ef92432a5ce..ad0743800b0e 100644
>> --- a/arch/x86/include/asm/sev-common.h
>> +++ b/arch/x86/include/asm/sev-common.h
>> @@ -207,6 +207,7 @@ struct snp_psc_desc {
>>  #define GHCB_TERM_SVSM_VMPL0		8	/* SVSM is present but has set VMPL to 0 */
>>  #define GHCB_TERM_SVSM_CAA		9	/* SVSM is present but CAA is not page aligned */
>>  #define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
>> +#define GHCB_TERM_SECURE_TSC_KVMCLOCK	11	/* KVM clock selected instead of Secure TSC */
>>  
>>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>>  
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 34f7b9fc363b..783dc57f73c3 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -537,6 +537,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>>  
>>  void __init snp_secure_tsc_prepare(void);
>>  void __init securetsc_init(void);
>> +void __noreturn sev_es_terminate(unsigned int set, unsigned int reason);
>>  
>>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>>  
>> @@ -586,6 +587,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>>  
>>  static inline void __init snp_secure_tsc_prepare(void) { }
>>  static inline void __init securetsc_init(void) { }
>> +static inline void sev_es_terminate(unsigned int set, unsigned int reason) { }
>>  
>>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>>  
>> diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
>> index c2a9e2ada659..d202790e1385 100644
>> --- a/arch/x86/coco/sev/shared.c
>> +++ b/arch/x86/coco/sev/shared.c
>> @@ -117,8 +117,7 @@ static bool __init sev_es_check_cpu_features(void)
>>  	return true;
>>  }
>>  
>> -static void __head __noreturn
>> -sev_es_terminate(unsigned int set, unsigned int reason)
>> +void __head __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
>>  {
>>  	u64 val = GHCB_MSR_TERM_REQ;
>>  
>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>> index 5b2c15214a6b..b135044f3c7b 100644
>> --- a/arch/x86/kernel/kvmclock.c
>> +++ b/arch/x86/kernel/kvmclock.c
>> @@ -21,6 +21,7 @@
>>  #include <asm/hypervisor.h>
>>  #include <asm/x86_init.h>
>>  #include <asm/kvmclock.h>
>> +#include <asm/sev.h>
>>  
>>  static int kvmclock __initdata = 1;
>>  static int kvmclock_vsyscall __initdata = 1;
>> @@ -150,6 +151,14 @@ bool kvm_check_and_clear_guest_paused(void)
>>  
>>  static int kvm_cs_enable(struct clocksource *cs)
>>  {
>> +	/*
>> +	 * For a guest with SecureTSC enabled, the TSC should be the only clock
>> +	 * source. Abort the guest when kvmclock is selected as the clock
>> +	 * source.
>> +	 */
>> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> 
> if (WARN_ON(cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)))
> 
> so that the guest sees something as well?

Sure, will add.

Regards
Nikunj

