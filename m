Return-Path: <kvm+bounces-58897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57FBCBA4F53
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 21:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DAC52A777D
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 19:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF1927E076;
	Fri, 26 Sep 2025 19:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QQ4n2MOI"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012019.outbound.protection.outlook.com [40.107.209.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB7D202976;
	Fri, 26 Sep 2025 19:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758914599; cv=fail; b=AaVJzz+7mcJZXq2yaK/zi2LyjsRuK1mWByhONK0vyftpph3uUbSfFdQvEOIIYFzgVdufS4bZ5jntqXZFCWQwOSwEH0PBcRy2QT774MHcYZHOk+jcskQ+9WOIhlEuk4Jm6bLLYWn1Vo7KDeop5bEBLPlAv5D0YZ67cyQpOu8Fxzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758914599; c=relaxed/simple;
	bh=rfGzudLwOoIMTe0PrD1Vof1wW3p6TojPzlk2BNDvx4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pxddw0gNV1c7w/AN4c4kXjY2A1wIFtOc+bATldQCP7hu/N1XCJARIPvwzgPvV9x6d5nxKPdYpn36KFEkNkP0cw/djvI45KD+E1iSvVnw83Q79y3z5UnV3Ec6WbXB2M1hBLZlLaMtZxolUgDCaHr7yk9c4FZ+P447otVsrKKKB60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QQ4n2MOI; arc=fail smtp.client-ip=40.107.209.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k0+7gCchkIOA9v//5bO6/34AJUpT20n/TfISD1cc17RkEk+0ZaaQP2THqnBkohwq1y+S482HohElUe0pHGb3ZkP2Tw5N72VTEB5t7Bk3lzWuTC+8EHZCto4frxMSQNT3KiMAr7J5aqwDKDPAjKkbAdkI5j+FP05ZhbgpmXiPe7S7sBC3VgwMlDkqOfXNNxse7TmiL3pK+daDUeDeGKFkzsaAbq/4N6LkhSzUBW9qxI9cUtDL1BPsDN/3EsQPdIYw4rUgdYBy0z/wofGbPCMx+oilOQM/FBUSX84EyV39I/90Zxr30qSJqx6V2TtnuucT+aYCQPQ9sbzUs7u44tro1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DcxbF6CbwkkNvyMFxUKzYKnyNoZXhu70uZBfX7uJiys=;
 b=mn2AoYxpp5LrUlXTUPfJMhQVLjzJJpny4f7Ri+UBGoCpPQCZxbeivFvcPZMj7dhc3TQfa2XTI+Z7ppK8yVA05O9Yo4rW908rMHUBet7TkwfVU2f4PVsSXW1VvAu4LcbLq4vcjVjckHvLiOOx4LunOw2V8cbybTqABVk6yq+u8XuvJcXBdTMHOkZ8EvWBmkz4VNJyf5GhEIELiY+Yu9unFNAGq75pEOgxlQnlLYfhrAdgoq5igvCJZYBWEpikf8EHoQUy998D6PxNAmd0RZAeqH+zRol/i+9p/VbrVFNzF6OPBuSEuzULYRxn36nThEniHrcYXpTQ6wTdx4SoPq86IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcxbF6CbwkkNvyMFxUKzYKnyNoZXhu70uZBfX7uJiys=;
 b=QQ4n2MOINUsunTjoE3rM+k2Td5/1YsJEbDPGm6tj2U04P27YR6fJMbWN9ujvmBmIoxTG4zvwRLY94qVraecFIu6mC5ySF+fAtHmEzwvdm9VjlN2rC46gZuExGCTWjEboGUgKU2HZgF6hDQhJ6WxK1afySiTKkHvsY4lHM16YSRQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by BL1PR12MB5826.namprd12.prod.outlook.com (2603:10b6:208:395::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 19:23:11 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 19:23:11 +0000
Date: Fri, 26 Sep 2025 14:22:59 -0500
From: John Allen <john.allen@amd.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	seanjc@google.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com, weijiang.yang@intel.com, chao.gao@intel.com,
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	mingo@redhat.com, tglx@linutronix.de, thomas.lendacky@amd.com
Subject: Re: [PATCH v3 2/2] x86/sev-es: Include XSS value in GHCB CPUID
 request
Message-ID: <aNboE3FqdjgqlEuy@AUSJOHALLEN.amd.com>
References: <20250924200852.4452-1-john.allen@amd.com>
 <20250924200852.4452-3-john.allen@amd.com>
 <e0b0180f-17aa-444a-8ede-39709501e82b@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0b0180f-17aa-444a-8ede-39709501e82b@intel.com>
X-ClientProxiedBy: PH7P220CA0146.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:327::32) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|BL1PR12MB5826:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a37465f-b2c8-416d-aa6a-08ddfd3221d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p+sCFUL0YuhsyoZ6SVpraccQqeEq3HtXt33ex00Gfi807dMVr5zxGTtPaA6q?=
 =?us-ascii?Q?Dz1My/gthCDs9DspTKxVPhFmmBkpGJtyDaiXVN1Pv/09FNKK5IFbQAis5yFu?=
 =?us-ascii?Q?tRAjTnHFxgkMT35ylLTU83EjucvShNOkLuPkeUBMES0AoAjBgPxbwSKFAbuH?=
 =?us-ascii?Q?kTanZXlXk/CqwqnE0px0+pXBA/HDlylb/WTtzAMrxMXVROvwqfwMrr9Ja/z8?=
 =?us-ascii?Q?VK+860+EScxe3o3J+d9xyEJ7xkmeoT0gPAsvXgeDlfW1vJOi6J1JQT4CcaNZ?=
 =?us-ascii?Q?zbDMSaS6cI7jZh7PZ9oIvReijjsZdap4I3nUoCd5C69kbsH+CO9tkYuxmdUq?=
 =?us-ascii?Q?SVI3leHk9d3cnk1KYjAj75cdyp1zpOBA5hJMNdLif5qBfyL7Ui6rcqFQkcqm?=
 =?us-ascii?Q?8XC6b1e5JlU5K+ztduffEpzchXjfcrKx5nsayQq279/ejG4jKU/ZIKaF/CXO?=
 =?us-ascii?Q?fULUYWlRm7UAeK1ZZ8FeCyEfiU6hKgOt6HZ81LvSoF8QS2aal7WnTGFIyTzU?=
 =?us-ascii?Q?de+UAGMojEuVe0pcEU7UbshJWQhxgsCeGIiXeh/ebhNJNfwkEe/SNCOIp+3q?=
 =?us-ascii?Q?8ZNbzkAuhG+YZ+wVa+iBp4UV6t4QvYkoG9NqgEDoQP7L5R+PCgy1raiKdF+v?=
 =?us-ascii?Q?YxRwN+52U8D6OTal77vBlL6licKrHC8oyrVW3dZ3NbdMDeWRe2fLsFbWcW76?=
 =?us-ascii?Q?IzYMD2iLAoUeSu1f7KRmOUjeGRENtzYuIU5JdDYcuww+OhnTkrGJw8BdBB+Z?=
 =?us-ascii?Q?td9ynKmHf9uHtw0ExagZ1F+qcaYWxbhFJ4BYCay873VZbYFFI4smdMIgbxYD?=
 =?us-ascii?Q?InWVt//7NCvjR4ffZPuWp9RD/yRvasNMstHiup9jnktApGzZpMlbH1sVDxat?=
 =?us-ascii?Q?8PHHG976upSbGkz7hAvbkBI5EYalIxqI89L9UM0o0U0RZ0IpeFPR6zY007bX?=
 =?us-ascii?Q?R6JZVYEG4aBfn6AqUKZV8RcI0MlUXiVFPYhg9R2iP8KgSu//I8+sWcEhWnN9?=
 =?us-ascii?Q?bxTCZCJJ44H4IL24Ryq0w+i6LeDrVOTCfNbsYoi5MZKF8+1S7b7uKv94ieK4?=
 =?us-ascii?Q?rw35oBMcL4BAriyLtShwEP0FoChN5BZJrRouoW3iOkMl+a9Wa3rUpt2w9ogp?=
 =?us-ascii?Q?wm/Ok6+87y7xIOpB79kMzTJEd10y+W/11S3SEs/mVmAf+4UfIk6P3VCS/tEe?=
 =?us-ascii?Q?AerwKOJVDQa/OS3YHyUu7xI0l8rTCzecqFw6/IZc2WvU0cL4+6F+atb7guFM?=
 =?us-ascii?Q?8orWyRwA+lUzWEItCBMl76F/vPWRJuhsl8QqJLLU0Jj8sFYHsYYdh9tuhX+M?=
 =?us-ascii?Q?er6CjgYGu84Q3/qMppVZbsZLP4Pba182A6ZsriEkeTH1CkeCyxCFM5vOTpq9?=
 =?us-ascii?Q?eRexC7dF9CY3t/NK5tfeuddS7xZ6cKemQ0BOju6VbgTO6MJYpWo+tuunYhWW?=
 =?us-ascii?Q?ybzD1IV/onTK3UXJbvS6DpGG9y+S6DE4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kDCNmeAvkKe5Gfm9w1GXAlgXdqHLqTdBeCM6srq7ch2gqqUCEMULCQWymXIe?=
 =?us-ascii?Q?gwKx+OmI6d0MT/+ivCPIBS6C2QCTGPLtfuC101imWFX9GCimabIFXF54zUD9?=
 =?us-ascii?Q?bbojGaKAsNtN5OAfIPfbGQAUqMVQnIY6QiToGS4heCZ1KHGbFpBPn23I37ru?=
 =?us-ascii?Q?+h3EFmFXVAOhD/oUZ7jgZItOtt8ddNySqVkWk11hYEw5QMhxaTvCB/UmoQYM?=
 =?us-ascii?Q?CQugPzZpdCqvQsugmfmH76+J/q2+8xBldUBC0NuvNUpx3Kz5urc7ygW0dBRV?=
 =?us-ascii?Q?pna1nY/XAlwyfO+TLSDb/0DIvCnjVLRlBxVpdNymjUqrMh2kocgoRpJ6VFSI?=
 =?us-ascii?Q?qCKZaEls/p9Z/rWilclQD7fuTSfTi+KvI30gO83fIRvS/ETqNUaQ/oWt0KXr?=
 =?us-ascii?Q?UFlH8bSVzpLbGP+H9/qB3+9YdlQKJFegh4+EzoTi0HhCrclF8WNInCNMbbDC?=
 =?us-ascii?Q?+rx2MmiXBFODXgxz6e7tLeUOFubi0gZbnPvdpFVDuRbEMcZJZCUmOUN7f69v?=
 =?us-ascii?Q?Bn4rR4aDQvjn/9roQ/L4oKhWgnT8v/Jntw5hY+vBBMvlvMIh399f8BtVJMXM?=
 =?us-ascii?Q?d4m6vKR0XmjKoWvjKkWqwjJ22JdN95DUTVSPeHeKVLnFTNKKT2w85XE7ky2O?=
 =?us-ascii?Q?+jaFVugK4+yo0AfGVRyvgC7PNURrGvkJUrm/v/LIxnqzboqNKJwTLTzj/bCh?=
 =?us-ascii?Q?D/x8phvGAoBR0LLAzi0LHFVmvcbq+rIFaRebj+NbLDq56VLdoY1Kh57MecHh?=
 =?us-ascii?Q?bX/lPixTtWrUzqzGHGCaQ1A2TpAuUojLedWWSDiB7N5rpQ5l3mafmzdotjx0?=
 =?us-ascii?Q?0C06YKNUSI9NPjJ5v54iOhFCxVqarucFlSL8cbCsQFtE3lUnyj2XPglbos9C?=
 =?us-ascii?Q?k/+ClP0CETniPGrq3d6NpXHmqwee3wiiOUptgP5/h//K1svAhB2lshDDBFLs?=
 =?us-ascii?Q?kifwjDhPL5rfNkidh05R3BMZcR5AyfYLFzlgsZvyImRzk1oqOSCMoprVrL+C?=
 =?us-ascii?Q?GYaB2UX7d/ODSKTGyznAb9k/sy0xcSR7xwSpQ6XUXkGL6xb6oU/4Jf/+YbZx?=
 =?us-ascii?Q?s9ANgN28YWJk1ETNFu809c3yd+kLEkI2bHhYmq9TYutM+p6j6494w4Cd3X9i?=
 =?us-ascii?Q?RfA5rc5BC7OfyCXCsqDpRSjjYJw1lAxUor/9JEN0YMgnhFhxdvPJlbXCg6bu?=
 =?us-ascii?Q?W0vkqa2fGcHNmeNaZ3jcqJHcR+ZcDxjKEnMYuLDfz1SchMw4DCjQJWRvGu5U?=
 =?us-ascii?Q?p1Gshj/hv4t5bQBsFWXGhYM8F0c7Kzk7gfcCS+4NMxWa7nSnQrhZP7yfIBk4?=
 =?us-ascii?Q?uJbITx9lJfC3NtMzijMPRK+enFOz4ju1MYljTdVyF6Yrpgz+2bvzraHMDGAv?=
 =?us-ascii?Q?Pir5fqLdG2RCDMRT904Ipc64biTvSIP9OCJ9ZN7rgQ4JzZhTdyJXDnV9b/sy?=
 =?us-ascii?Q?npoMbIDGwfYm0iixqHjlnrExo1fKjPjt55R5vpVLEBBHMd4nCGNxk/KZ8kbn?=
 =?us-ascii?Q?17fppewhl7b4fzWzm/6jKkxiyTiTWCqF7LDrVYfgos0y9y8+OoFi88ANvo/x?=
 =?us-ascii?Q?DDvtG5AtnV3D90GdWBW+vS2VuhM/hfDgOipNl/AB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a37465f-b2c8-416d-aa6a-08ddfd3221d2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 19:23:11.6453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9hV4jeLrw+mJiQLA4s3s2FwZ98GhPNbJHPnd9WDC2+whK4ZhyViCeLKJPHPm5kCZbnoHLtIW4ifGfLii6RSLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5826

On Wed, Sep 24, 2025 at 04:02:11PM -0700, Dave Hansen wrote:
> On 9/24/25 13:08, John Allen wrote:
> > +	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx == 1) {
> > +		struct msr m;
> > +
> > +		raw_rdmsr(MSR_IA32_XSS, &m);
> > +		ghcb_set_xss(ghcb, m.q);
> > +	}
> 
> Is there a reason this is open-coding CPUID_LEAF_XSTATE?

That's a good question. This patch was adapted from an old SNP patch
from years ago so if I had to guess, maybe there was some issue bringing
in the old pre-split cpuid header into the early boot/shared
environment. It looks like including asm/cpuid/types.h and using
CPUID_LEAF_XSTATE works here and now so I'll include it in the next
version.

Thanks,
John

