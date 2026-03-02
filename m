Return-Path: <kvm+bounces-72365-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AO6sN2KKpWk4DgYAu9opvQ
	(envelope-from <kvm+bounces-72365-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 14:02:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 600621D9609
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 14:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8773A30B5634
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 12:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55CDD3B8BB0;
	Mon,  2 Mar 2026 12:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JbX5qDIr"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012053.outbound.protection.outlook.com [52.101.43.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746273B3C0B;
	Mon,  2 Mar 2026 12:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772456103; cv=fail; b=h1dyGYmc7oXcs6j9AoSMsGPpdToKiMwLZ3kdrRWpAhbvGZWecJ9tVUdJh00ucr8EBYXrscCP7p6WJmnHnUrCEwHNmy5PcUJI4ivMCVz6LhrxX9sAP2hmxdwNoA1BydebXGWTicpQEDfrarqefvVyQVu/Efu5jCVQMuioFkVN4fI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772456103; c=relaxed/simple;
	bh=CCwCvYrRqi8vQtt0E1A71n/KYJHTYnoEeNLfKw1FK14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uh2kDPjMFh1j2g21HxUc6IW0y/SE8eShW9WAZdnUconsLl5llNcKK59/mZEcp80MDbRrJvbR6uVhwggZzbPxMLLiv0yt99KXA9RWs0nMwc6YgFdNIn2obKJsSL9DgQsJx+Lo5TlAxNGnSzb8dQ4fR8DWVjkaSTwup+oeEmbL//I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JbX5qDIr; arc=fail smtp.client-ip=52.101.43.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CL81P/TkG7F0IllP7n9O3V3OOy1Jpfpi3f5iJ5iD1qI8jiaKnm0Os6FQClYlg33Pjky4g1sLBcZd7PV93TE90DMEtQdF+MKVA9eE2xX+CS93773MuQI3CnBSzUPrrPHKaIan5+H9yNiLckbmsAoKWh3LcBN0QIYIGzGcBDa392EkhH3tmcJ2qKdMHhiWmXsWHheN/yiGKhpL5fE3B/a+gZHBHVuQzu3qJGPOdpTeAbyXQw5qvoXYuVc7WTcATocXR6avv15xuNtmnkmJRsHVSFn/paZFiUbqQAvXhmQiQ/VmVWzwh0CR0MzpQ3ZUyoxuL1u1XaO1dcQyAYnruN19ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPZl/abDKnezFpsiB+exKjWt5Mue4jKHqM9QCIFb9Oo=;
 b=agOChGp0Sk6wNMcKmSVxjAsfm1hv7hQDEAxdzv9HwuMjtu/5JtFs9VgTpP5dl0jnun/GmmC0YEsPvmJSqKxjC7iRDPrh4ljk2JCKwjI/YMn9i/oXT8CzvVwr+awxTJcDRugUfqnpcik3Og0FI8IsxY/aqCgTZMxal+Og5SbkCGM1mShG7yxr0mJnHjY3UmTGzhAp9QlFl0LvPQ1KY7TrE3q2OC9wEkVGdODLOyoV3yEqRyKux9X7JdpqjHkINwNW7lMydfCJsyN+LxCc/bSAYwRbgsbuVxBiqb2uYJUYbd3OWyC2geSc+bMU0oxlos9gMUfJn3G4Te9hwgZX1s94yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPZl/abDKnezFpsiB+exKjWt5Mue4jKHqM9QCIFb9Oo=;
 b=JbX5qDIrkjkrTU1u958VEuDHUiSblgHYhzP4dmowoPVPbgSn4rBRcK4255x9u90Qpsrxk3KuKnQmrHMGjawzQ0sqbaWbJ9CROHvK3G6KVdv6g17OjqYV+sLy7dDiB8NwgS8O80E2Kd6OVoeJjFPpozXXinLOiRyZDvGto3Y3iFX7xsI0kABlEk0d3BIu0ZUdVPxndR170COUzHPGhZ26kE4E/uNhLpjRsyJtaHFVv1dmdIK5D75Krr1Q8rxY7+GOz3/Kf0xx20uUfbQe/IpR5iqXgaZQAN1O2OEcTuRS/sDjycUJgt81e7jKbd+nV4sUeiOZDODxEwwm6zLsvzCtbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 12:54:57 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Mon, 2 Mar 2026
 12:54:57 +0000
Date: Mon, 2 Mar 2026 08:54:55 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Alex Mastro <amastro@fb.com>, Matt Evans <mattev@meta.com>,
	Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>,
	Mahmoud Adam <mngyadam@amazon.de>,
	David Matlack <dmatlack@google.com>,
	=?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Alistair Popple <apopple@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 3/7] vfio/pci: Support mmap() of a DMABUF
Message-ID: <20260302125455.GU5933@nvidia.com>
References: <20260226202211.929005-1-mattev@meta.com>
 <20260226202211.929005-4-mattev@meta.com>
 <90bd4185-1e87-4393-b9e1-1318a656a7d9@amd.com>
 <20260227125109.GH5933@nvidia.com>
 <c5a8f318-20af-4d80-a279-2393192108c3@meta.com>
 <20260227194807.GL5933@nvidia.com>
 <aaISD4mw1XzQl1S8@devgpu015.cco6.facebook.com>
 <20260227220427.GM5933@nvidia.com>
 <b729ebe1-aea2-4f45-bb3f-3b4b59078c8d@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b729ebe1-aea2-4f45-bb3f-3b4b59078c8d@amd.com>
X-ClientProxiedBy: MN2PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: d6eef778-d94c-45ae-2b71-08de785ae7e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	91tnT4rqsKcrJymd+suQ7zTRcsRiEskApNZRgeVjPF/UcrCKPySL4pAIMR4bUlf6s3pbw78Q+EUJSQsAs3ldSi6Oh9qHc9588d5hjIF2LoBYnQmlHu6hATZFEMd55homJ3j1B9drHyCTbVVocQhg/T4ws2D9EgGRLmt9yZ4LOAIHmNGb9IcEwo3HGCbNsGayuyPPQ7gXKsDEl3KtbpF/lplcpErDDm/EMMDW8tz4FDqxWeyoxlmddztzZPyJkJtEnljmBChzjHI1wlG7ybfe8i7lOUwlXluAH3hBdk1KAU+pnLD89ZC6SWmWsnBcsWkswnBpWzFQCFaGYwrDOImttimUTIceSOsvYBrj2jHOmTNTTgqViJ84RHSpMA4lXPOcKTFGgDTGyfoV+1oxlQOum9sV+C8MgAaYDJEqh88OI7IWA+1+nxxA90PqoTePcSzLXOPmpvFdDW4xjSnuP4/ASxRJwNwkQC8tGoc0XNkcXycwzZfAFaCDzdmA/8OtPwV0esBnOebLbRsSzpRdFJaYTJqd+4Efh7N8HgjMcxT9PDgyQaGkOPJXWQS1xXRqKjwSiD/zl4BG4XylkPK9iihTyVxWAvW0z0CjOMN2kPir/wJvMIBXfPbwCHE+DQNlqQO8rt2b6uTQRX2UGyZlUeGfIFPC97+/uD62AbckcqIZJuKdMdN2uVNCgpO5wa03lsMcQy6UNOlV8CVRA0sUgJptxoZqxucRkTBsm3nsaX4gBcw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TG14RzdoNUVxRTNqdUZzN1VHR0lUTEV3WUltT0o5aG5ZSVQ2cXkrcHRUNkVT?=
 =?utf-8?B?cm9NRnNsTFhSZ1drUFdOVEl2dVVrenY1YTJ1aEMrT25qN1dvM1FZMklqS3ZW?=
 =?utf-8?B?S2tCTlRXUW5zRjFFOEZtbzZWbDJOOTdjSDBWNm5IZ0pSM2p5UVZNNG5qeTJa?=
 =?utf-8?B?a0pvK0dBbUxFU2I5NkV6Tk4rL29VdHJJZzFtRnFUWkdkc1F0OS9RV1dBNWor?=
 =?utf-8?B?WFRKaEpTb01lbEhvKzdXWDl5WGhIOWhuOS9nQzRlTEdmeDQ2NEhXV3JVdUJy?=
 =?utf-8?B?NS9xRjVwQlRNZmVsRFVGZ1Y5YW9ZQ3BEOHNXc2poRTlSUnRNSGFDR3VOL3VD?=
 =?utf-8?B?MmRmbEo0S0lpQTlWNEVSTkpnZHZiVmJHcGxZZ1JkamxQYVgzV0RGeFJwWnV6?=
 =?utf-8?B?NnBhSHZBVS84OC9rci9MYTNvUFRvQVdVdlFwdGd5dXJReHAwS1VGZjZqcit5?=
 =?utf-8?B?bEVtL0l1RUN5VHR0Y3piWmNiKzJod1RQeDFjMFYyNldCT1oyR3c4dUhFcnZs?=
 =?utf-8?B?Qy8rQ1VBa2RpTmJJTEt0R21mc1BscURpSkxJOUNJZXpVME1PcU8wRW1ZbGlp?=
 =?utf-8?B?bEhlMGc3UWF1NmxRNW1GYmtwc1NLM0JFUlJaN2JxSjBHQ1JMOXZZYkR6VElD?=
 =?utf-8?B?OU5xQy9tczM5RzdmbE93clN5SXRrMEEzQkJtcFNkc09vQXlEVmE2eHVHcmxZ?=
 =?utf-8?B?YUtaZ1pscTJyL3NFeVZRY3BQME9YeW5uZE8xM2RhbVptNURibm1jdXFuNHdw?=
 =?utf-8?B?YTVuaGRKME40WldoUTRzM1RXamo3eTMyU0djakZMN3FSR0dySW5UVVUvN0E2?=
 =?utf-8?B?Y0lBdHZESzNwNUNsMHUxYzBydGFEZGpZV3RTcHMwalJEaEVKTHJBbEFBQmVv?=
 =?utf-8?B?VWRBNDcxUHpMZXVBYm9oc0FtNHRDNCtXaVFFSkRiTVdlTkh3RjF3ejFpdmVN?=
 =?utf-8?B?RHk3ektjaGQ5RUNuWDZvVkgxejkvRUlHT2pNSW1yN0lmVkNoR1Jwam5LcHo4?=
 =?utf-8?B?RmRsUzhkS1dUaXV4UVJWaTJSSXlNQUZTd01zWWdPTTk5YXV1V2lvZTd0RS9B?=
 =?utf-8?B?OU9kbW41aS83NUN5MlFXak1IMEsyc0lFaVBMbkRSOHpQODBTYlpwczQvNUhh?=
 =?utf-8?B?OE5NNlpsc0NMTldtVE92Y3dpcE45enpPdzRzQmV0REcwUTlQTllwclpuSGVO?=
 =?utf-8?B?MUkzYjFQdGV0Ukg5bXBXRFZ3VUxVNWZUT0V5RThHa0JnYWJJTnY1OC9iUHRX?=
 =?utf-8?B?Y1ZWaEk5UVFrVmIxVXM5YjNWb0prRlJ0V0NCR1Bvam1tY0dtaUtPV0d1bmtu?=
 =?utf-8?B?OEhRdlo2RUFuUURhelUzRXlaRXlWdHdDUFY4N21LbllvQ1RRQjhDMHJRNlJr?=
 =?utf-8?B?Z3JSd2FuSUVrdi8zWkVrSlZSYlIvMG1TajE4VEkyaGFJUWNCVUtxcldnNlZ1?=
 =?utf-8?B?MUk2MzZ6S1k3eTNpTkpKWVU3WXFFcG5yY1JJcGJJbVE3MGZGLzl4a3BTcDJT?=
 =?utf-8?B?YmxaK3U3UTJqTjdRVG5Uc1JHMXhldGV4dW5WdUl1dDBRbzM4dldKRURycFcy?=
 =?utf-8?B?TmJiRXUrdzlrUGFKbjlRQzl0b012SCt0bVdwMklKTWVyVzNpbWwwNjlXZU0r?=
 =?utf-8?B?UjhPdVc3Zk5lbXQvaDNEYTNrS0Z0MGJxUS81ZXZkWk5CVHZRVnlEUEhMT045?=
 =?utf-8?B?c0RpYzF1Um4vTXNqWVpJcUp5Ky9DL2ZBdXpDdmxmUE1BeVA3ZUU5NS8wRjJt?=
 =?utf-8?B?dW5Wb3FjZGptRXd5ZUsvZTgvcVNLaDlsS09HaWJUdkhZTU5IRitCZE1Bai9z?=
 =?utf-8?B?YXZkc0ttVUQ1Y3hTOC92SlRQcVlzTHE5ZXJpUUZoT1J6ZDI1SUlsU0lPeHdw?=
 =?utf-8?B?TTVaaVBQWFlLK0tOa1Y5aisrM24vMGFSMWVnOW9RWmZjOGhmSzRVNmJTbCt1?=
 =?utf-8?B?RjJLM3BZbUJCTWhzQWxRSzEzV05mVzNKa2xza3J5bkMwUWttWUluR3pNV25o?=
 =?utf-8?B?c3V6eHAvbVRCdFZoZHZmdHB0ZFZlQ3ovdjlzdlJ1dVJ4aTVZVUxRWGJVTmk4?=
 =?utf-8?B?WUJPQXd6RVJaUFZrQ2J6aEJMdkxMUjJWNjlzN1FBeUVObk96UTRzVW9jNUFm?=
 =?utf-8?B?U05jY3lBRlFjWG5OSG1xZVJqOCt5dEpwZmpWWXNzOEtKOFBqaW0wNDZMVGlB?=
 =?utf-8?B?VS9LVGFNbzByMHZXbkx6bUdWdVpzOFJ5ei8zQUtwRStCUDB1NTVzWS8zck44?=
 =?utf-8?B?OWFkT21zMkRpejd5MHhlYmtjbGN5SEEyZXc0Q2w0NXZTRThwSWE2RkFHeHFR?=
 =?utf-8?B?S1dmVVhmQjlGNmxHc01tajZIZDNYRDlpY1VxV1RQcVhFcU1Ld3JKdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6eef778-d94c-45ae-2b71-08de785ae7e2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 12:54:56.9678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yy1IXs0MI4K41j4oDL6JocmCuRqYG5nEvo+/EUB0uBPlAqALm5/r0iVK1nsSJXxC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72365-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nvidia.com:mid,Nvidia.com:dkim]
X-Rspamd-Queue-Id: 600621D9609
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 11:07:41AM +0100, Christian König wrote:

> As far as I know background is that on x86 pte_special() only works
> on true leave pte but not pmd/pud.

This is not the case, there are pmd and pud_special as well, protected
by CONFIG_xx

The arch should not define CONFIG_ARCH_SUPPORTS_PMD_PFNMAP if
vmf_insert_pfn_pmd() doesn't result in pmd_special() working, for
example.

eg:

 vmf_insert_pfn_pmd()
   insert_pmd()

	if (fop.is_folio) {
	   // Not Taken
	} else {
		entry = pmd_mkhuge(pfn_pmd(fop.pfn, prot));
		entry = pmd_mkspecial(entry);

This stuff was all put together by Peter specifically for VFIO to use,
AFAIK it is correct.

IDK what Thomas was using, but if you tried to do huge faults before
all of this was built it definitely would not work right as it only
supported a folio backed path.

Jason

