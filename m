Return-Path: <kvm+bounces-15302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A8C28AB099
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:19:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EF75B249E3
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DCA12DDB5;
	Fri, 19 Apr 2024 14:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TiZkFHU9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D782E40E;
	Fri, 19 Apr 2024 14:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713536369; cv=fail; b=V8qhbym715BvYsq/AVNBYy5iJTQVR6GbWOpmXp1XRcaypQUSyY8yHOPCqZb6thzsAy1SMboUKmS+EQi+AsgwMPtJO9wPnGkBS8re1fOF6UXYvataoZNB93lkmBTFuHrA7M6ZLyV8z7ERECwphYqtAdxFhaxCBVFmFokcolwhtM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713536369; c=relaxed/simple;
	bh=gGSpfD/vCz7jYXwK4jkHC5zF/jZGN6lAxOWi4UL8tK8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEXK7QmRDfqgnvidRvnR8K54++Otj2ZK3AGJkoOqeNPyCvDwlsooZ3zFhwGBBqYS4clYQt6gSYi8/pwhfDL+xc8rAvayzMfYMrcFy2mBLmSFGE3j9vgs0UhAL4mAH4oVliO3CMSL3VsRO1mgPzQl0l6MS1jCwmuJGkilukcpisg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TiZkFHU9; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhGr1OAx9GT9BZSBS6p1yU8M8X/ja/Z8byapf2A21ymX21UX1Io45yx9NGKZIBuqgBdRqSChwzgBB5ytMMbbnkinjcMrdSOgOv0vs83ztX1yRUx1bczi271D0IBnbTcN9GMZzPKCDl+mda+GT0S0IwYPd+3xfH/Xy0eOcw9w+T7JdlbKvIGDRS98VZtXKa3lDGIlP5d2m5j8DHfx0ps0EcBDQuncahoWMquCWfcsHHTyn+S0swrXVG3ygPzYMlwM63BPW5Oyqf/WltMKNd/ZILuNb2Q5/YoiMsNo91bfmbqTEybD1S0i82PJJiiLRGGrNEphyjL2cIMK6w1H+ek/tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCLECH2BTckagVUfu2ZQ3LTaU6lM5yOLfu5mpophMUw=;
 b=TPRMD5PEAuQ9/+eUpRvMuWKiZ75CrDbvb140ga7ksOnx9AoUyXucVOhBbP1agv3k+CRJ84OVP1W4daJQxhFsyZENDiYwbwPCCZerWT0P0IYb5FBZc5xXUawKcv0GgKij9q07iIKDrs1epgo9fxBIWYmjCIonkesoY9xAZoh96KIFF/PTLsIbI3LRfNggh3DxTsVVNNn6mu1Ek6sGaJhQ3DKhV1pHoQmV6kJ3XrB0dOnonC7C2ZhASK3TBEVlJs9hFwFOswITanDuK+DReiKPawyBmKSxGIfGYlkOUBGSv6iaAiUjE7ouGd9xFIAKSXo4U/2rHHJwdoi+kWAmDveZ/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCLECH2BTckagVUfu2ZQ3LTaU6lM5yOLfu5mpophMUw=;
 b=TiZkFHU9Ewohv0QP2wBxV4SGoD5d/+7PqtWnHMfAPP7p4b/XqO4TWlQuNg+kgH8ECeqovWH0dWXYjUJW/jRMKjkMfMADuSWVi50ObpZGo8qQYYtpJXLUwmxPFOC67ZifQ31mKEs+VI3jQ+NCxZKo4TKEFvTVM5hfcCURhC6uiaU=
Received: from BL1PR13CA0193.namprd13.prod.outlook.com (2603:10b6:208:2be::18)
 by PH0PR12MB7470.namprd12.prod.outlook.com (2603:10b6:510:1e9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.43; Fri, 19 Apr
 2024 14:19:23 +0000
Received: from MN1PEPF0000F0DE.namprd04.prod.outlook.com
 (2603:10b6:208:2be:cafe::be) by BL1PR13CA0193.outlook.office365.com
 (2603:10b6:208:2be::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.14 via Frontend
 Transport; Fri, 19 Apr 2024 14:19:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0DE.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 14:19:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 09:19:21 -0500
Date: Fri, 19 Apr 2024 09:19:20 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: Re: [PATCH v13 09/26] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
Message-ID: <20240419141920.2djcy6ag3peiiufn@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
 <20240418194133.1452059-10-michael.roth@amd.com>
 <CABgObfYztTP+qoTa-tuPC8Au-aKhwiBkcvHni4T+n6MCD-P9Dw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYztTP+qoTa-tuPC8Au-aKhwiBkcvHni4T+n6MCD-P9Dw@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DE:EE_|PH0PR12MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: 274bf5cf-09f1-440f-9f6c-08dc607bb627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VGxOOXFPWWY3c2RieUNHcTVKWjRLV1RoWlVUcGNPdDlMY1ZkZzdCdzRVSzB0?=
 =?utf-8?B?YmVqRDJsQ0U3ZzllME9Xa3AzTURjMUZKbWxhQ3d4djBoWlNKVWN3RU9PTXVQ?=
 =?utf-8?B?OWFwaGRVSlBML2R4YTVtdGpKaEtBc3FtbVZveThMQmFnSW5RWkhxMHd2NmZr?=
 =?utf-8?B?TmlWY3A3Y25TUlV1bkhFMGhwbnoyMWc0Z0xsT0FuM1d2Z25XclZaSXBhOXlj?=
 =?utf-8?B?RzYzUDVKeGo4a2FsemIvcGVFaWdGcUU4Y1BpQ1ZsaXNCQ1Jnek5tOHJQeExI?=
 =?utf-8?B?a3lKeDIwcHhMM1BsK0MzQlh1aGxJQXlmVUVYa1loZUJ5SWt2OW9KK2p1M0ZS?=
 =?utf-8?B?ODNZUnhLOFUyN2dLMy9DdXlDTjFmVDZTS2VTRm05OFRNeFZoNndmTkhjeXpY?=
 =?utf-8?B?OU1TbzBMeDBlMGd5c2NENlZESDBzQjhPeVhSSGhXRzRhZVBXcXFpak1YVjNS?=
 =?utf-8?B?eUpoYWNxMkpSV3NEdUM4WEtsODdHYmpvdlFqWFNLRS84N2FFem83YUgzUEFa?=
 =?utf-8?B?MlRZMjJSY1BQMW0vYnd5MWE4T2xTTEkreUs0VnhzTjIrRDlUZlYyVjhSVklU?=
 =?utf-8?B?VTVlSW5uWWNmNFh1L0FqSHdUUEFMZmRlVjVrbmpscC96WkR2N084c1NvZ3Yx?=
 =?utf-8?B?eWUwajlTWG1HQk03aWgxUXZjRDNIeGszUFlFN2V0bjU5Vk5JZzh0Ukg3eGsw?=
 =?utf-8?B?UTNLQWxqUDdXbVFiMk92S29WTWtycExqUmQwQTB6cFliSEhqemQxcE03VDU3?=
 =?utf-8?B?dDQ2K0Y1MDJaN3V5RU8rTmsxZEZMTWhMRTNHV3d1aG92YmpWZVIwajEvZnVa?=
 =?utf-8?B?TjRFQmU4K1FPUFVyTUVPMVpvMWtxNkNDTk50SGhEZlE4ZnV0VGlUdUhiRU9H?=
 =?utf-8?B?OS9qYm9FbHg2VXViYWYyUXcyb2R6ZStRVllOV0NJTzJuSVRRSHp1ZUxsTVJ5?=
 =?utf-8?B?em1RNjNNbXA5MFNjTlVYdU5QZEYxc0ozMXlBL2YreTByTnJZTjNUbXpvZFRz?=
 =?utf-8?B?M3JhSkxrL2V5SmtyeGo5S1hHZE1JNVR1OCsweGZZWWFWamZkWnN5SDRmY1Ra?=
 =?utf-8?B?S3I1eUhkMzN4UTE5OXEwUnZjM3ZGNGVjb1V5T05FN3JIdHQ0cWRPWExUREJH?=
 =?utf-8?B?a0tSVElQcVpXY3J3WGE5UFVjUUtaM0g5M1IzRzhJZUI1K0oySU8xZmlVdGdw?=
 =?utf-8?B?NWZJaEdmclVGWWhwZlVJU3VJS1NlaEM5UHdZekxRU0NWNVdMSXFyOWRrZ01E?=
 =?utf-8?B?bjFtanduYTR3eWYreEdDU3lhZVl4ZHBQZVJhL2xnRGxzQUR0N3U5KzJNR2NN?=
 =?utf-8?B?VWhCL200WEw5OFM3b3FMYkN1dHcwU1FBUHk1bjlqWG80NklPOURjaE9lWTFi?=
 =?utf-8?B?eEk4SnBIVk10Z29nNDlHbzM1RythbjhoWW1iUCtkbjF2Q05ncktVN1ZhdHBE?=
 =?utf-8?B?cU9HNER2TmFoWDlLZHlxWWRsbWx6TmdSV2lsMlZEYlRCMzNtbkx5aDlQbHU0?=
 =?utf-8?B?bnlUNmRXL0NoRitmY1JmQkppc1RBODVuTmFvN21VdFBKcFlMci9EVGV4Q1d4?=
 =?utf-8?B?dm9ralJUY2libVc3eFJOdGdGM1RnQk1iZ2E4NEhOREdxZUhPS214SERTUVNu?=
 =?utf-8?B?aE1OaU1NZDFPV1JBZ1Mrb2p4WGhyWU9NUzRJNjdTNmdVbWR0STFmMzVMMGd6?=
 =?utf-8?B?S1d5L2dBbE85cHQ4Z0l5M2NxWlhjZENQcVN3WGR1czErRjFPS005dnlldUc3?=
 =?utf-8?B?Vi91dWI2M3pjR2pkK2t0NzhCTUZUdEMwb2dxSWFoTkVmbGd1Z2tTckVTZE5E?=
 =?utf-8?B?K3RWclV3NDJnckpUTDBoQ3J5Mll2YU5MbGFSR2w2ekVxLzkyc3ZNdFhHTTJq?=
 =?utf-8?Q?cY3K7uKXv+SRv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(1800799015)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 14:19:23.2280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 274bf5cf-09f1-440f-9f6c-08dc607bb627
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7470

On Fri, Apr 19, 2024 at 01:52:24PM +0200, Paolo Bonzini wrote:
> On Thu, Apr 18, 2024 at 9:42 PM Michael Roth <michael.roth@amd.com> wrote:
> > +/* As defined by SEV-SNP Firmware ABI, under "Guest Policy". */
> > +#define SNP_POLICY_MASK_API_MAJOR      GENMASK_ULL(15, 8)
> > +#define SNP_POLICY_MASK_API_MINOR      GENMASK_ULL(7, 0)
> > +
> > +#define SNP_POLICY_MASK_VALID          (SNP_POLICY_MASK_SMT            | \
> > +                                        SNP_POLICY_MASK_RSVD_MBO       | \
> > +                                        SNP_POLICY_MASK_DEBUG          | \
> > +                                        SNP_POLICY_MASK_SINGLE_SOCKET  | \
> > +                                        SNP_POLICY_MASK_API_MAJOR      | \
> > +                                        SNP_POLICY_MASK_API_MINOR)
> > +
> > +/* KVM's SNP support is compatible with 1.51 of the SEV-SNP Firmware ABI. */
> > +#define SNP_POLICY_API_MAJOR           1
> > +#define SNP_POLICY_API_MINOR           51
> 
> > +static inline bool sev_version_greater_or_equal(u8 major, u8 minor)
> > +{
> > +       if (major < SNP_POLICY_API_MAJOR)
> > +               return true;
> 
> Should it perhaps refuse version 0.x? With something like a
> 
> #define SNP_POLICY_API_MAJOR_MIN    1
> 
> to make it a bit more future proof (and testable).
> 
> > +       major = (params.policy & SNP_POLICY_MASK_API_MAJOR);
> 
> This should be >> 8. Do the QEMU patches not set the API version? :)

Argh...it does if you set it via the -object sev-snp-guest,policy=0x...
option. I tested with reserved ranges and other flags, but not with
non-zero major/minor API fields. =/

But I'm having 2nd thoughts about trying to enforce API version via
KVM_SEV_SNP_LAUNCH_START. In practice, the only sensible way to really
interpret it is as "the minimum firmware version that userspace decides
it is comfortable running a particular guest" on. And that enforcement
is already handled as part of the SNP_LAUNCH_START firmware command in
the SNP Firmware ABI: if the policy specifies a higher minimum version
than what firmware is currently running then it will return as error
that will be reported by QEMU as:

  sev_snp_launch_start: SNP_LAUNCH_START ret=-5 fw_error=7 'Policy is not allowed'

On the firmware driver side (drivers/crypto/ccp/sev-dev.c), we already
enforce 1.51 as minimum supported SNP firmware, so that sort of already
covers the SNP_POLICY_API_MAJOR_MIN case as well. E.g. the test surface
KVM needs to concern itself with is already effectively 1.51+. In that
sense, whether the user decides to be less restrictive with what minimum
firmware version they allow is then totally up to the user, and has no
bearing on what firmware versions KVM needs to concern itself with.

Then the question of whether or not KVM fully *exposes* a particular
user-visible feature of a newer version of the firmware/ABI would be a
separate thing to be handled via the normal KVM capabilities/attributes
mechanisms.

So my current leaning is to send a v14 that backs out the major/minor
policy enforcement and let firmware handle that aspect. (and also
address your other comments).

But let me know if you think that should be handled differently.

Thanks!

-Mike

> 
> Paolo
> 

