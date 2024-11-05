Return-Path: <kvm+bounces-30740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68F6E9BD023
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:11:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BA9A1C20E9B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 15:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2A51D9350;
	Tue,  5 Nov 2024 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dp38+dVo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309D31D6DB9
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 15:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730819454; cv=fail; b=WVPvwaoC2G4//4F9TMxADWWBQYH+TbTR/mGn/vyfB6Sj7aSW1drOHJL9IocygE+MmjG95CDPvEsdWu6j9/cJPH7Lgrx2ql0G0uLu9wyWbad771OtHcbWl3kjtC/B7td2oi6GS3ePYtoskIhOEQ30nBJPVyx1HH/0bDdFiVMJ4cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730819454; c=relaxed/simple;
	bh=upJzXPR0Hb4rwf9wTR7WMyVerHMLMrodqFyVJG1Yrpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=toOCvQCiT+FYvLj/jbGlSnGnIS9IU1cQJYGNdF+5QAYEFY1VQZoBLSXloSFNmBpsCqE+dHExlp8ira5ndVMXv/f8mAYUk6d/jVYVB6ruDs1O8g8S74S9cZBHZ/vAIRJcqSGBOoOzJDQQUysmOyeWA3PTjQ+1bdrYb1w96OGyeq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dp38+dVo; arc=fail smtp.client-ip=40.107.244.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QvqH7RroBahMX69bQL8ONeukthFvmLpfyykMv2rlA+soSx10l1nB3mvPbcnsi/zuxpHztAkUOJV5eG8eESAVx8TNsQD2lslUVjmwjtHvOYFCW14y2c9dttjBEmpvUIvObKLMpKpuhHrVZsOM3wu3F7F13fN/2Vuh3W7Cd2C15SinenGc1pt7Ga+R9c1lzELk6vE09etw9WSrBD0rXQBNatnsZbV4W0lUCFNS1hUH+zxe7ugP+C542IynpPQr4H7V01VRYI1Q8lTLmzM0g3I9EErq7V5ighDKhCcnhwxYEfNAYI/UxpPbg3OPChSxiWFhIb7a1VN3BE28DsdrPW5opw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KdO41G0taUyzwuc7QIxbzIXjUGka4CEXkuUwv6y2gxU=;
 b=FTtrGEBgq4fEZ/x5Rtjl2mv31MBk1qEdEAjqyexsLdH5m/KgWDQUFNx/yx7Z6LXTEIzydA8KLnlneQ+AUu4/Yh7ZEOmih0XbMD5a1psCb7VHGhTUNv6VXm/sR1dP7CNNZZwRfg0VKlsOWEsuVZPne/1hr2Ow8EHYo5xCASl0FeCpVqht+JPTY64RXCI3QUlPWJz/Ex38q5g14AERLhqNzvWzNHiRXWfxpv1vQy2OgAr2Obqa27KzokBrzVmpSu1OJMUdDKPtprrKkYSmx5uUmER7eGYYU96w+D5Q6pdcZzYs07l1M+gXUBEUBatrXB9Aju0Gw3rKg7hM2cQ87Z8RHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdO41G0taUyzwuc7QIxbzIXjUGka4CEXkuUwv6y2gxU=;
 b=Dp38+dVowGkFk2Ejk/jS/xKRTMwM/lMc/KdT20et1NxDHKwRVwldLoqfWyEyiLeNHnMWo3OMxJ17ZV+InYVONdaWl5eYgmpYb9M5HJq6ZQU/Lot922LuoPecQ5cDqA0EzcWbf+lJt+O7lONOV/IGcgF/pBmtYy2B4RkNjT3s9/7kw9MskaDVSWoutznVeovNJoVXyoiSDROvRcg4mFa2Cl1WbQUxRWxcRT/W2b65p3KCYN+ujmePRKUn+ejvgdssOI6aNqKsJj2Tj2suTLeA+ykL4vPug8iXTHc/mUsPdG2Rwy2QzNzrDvhVkoZWrC1XRoRUwtPTfI6PJK+Hs8eUAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB7569.namprd12.prod.outlook.com (2603:10b6:610:146::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Tue, 5 Nov
 2024 15:10:43 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 15:10:43 +0000
Date: Tue, 5 Nov 2024 11:10:42 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, joro@8bytes.org,
	kevin.tian@intel.com, alex.williamson@redhat.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v5 01/12] iommu: Introduce a replace API for device pasid
Message-ID: <20241105151042.GC458827@nvidia.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-2-yi.l.liu@intel.com>
 <9846d58f-c6c8-41e8-b9fc-aa782ea8b585@linux.intel.com>
 <4f33b93c-6e86-428d-a942-09cd959a2f08@intel.com>
 <6e395258-96a1-44a5-a98f-41667e4ef715@linux.intel.com>
 <64f4e0ea-fb0f-41d1-84a1-353d18d5d516@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64f4e0ea-fb0f-41d1-84a1-353d18d5d516@intel.com>
X-ClientProxiedBy: BLAPR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:208:32d::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB7569:EE_
X-MS-Office365-Filtering-Correlation-Id: 91d9df6d-dd3b-4d4a-5e2d-08dcfdac04bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mII5y9u/QsCchQnCU8Wdo5mBJhe/G6MjVaK33b7aRksRPoh39qT1PHQnxZi/?=
 =?us-ascii?Q?R0XpSP1ft+ZyMhTSpfO0vZAKQt1bahbhLSK72zo7x2ptDddAzJ3+DWMT/5Jj?=
 =?us-ascii?Q?vfZIRyEwj9aFBqk+zyl9hgJ/hOaQLZVovHutfhsWTC1ZffYKefLvYBaMUpOO?=
 =?us-ascii?Q?W0RnD0vCbovRUSrT/HkKiwpfZ9k67V2qlABu3SIBnLJn6rQwGYxHaYR1JZ/b?=
 =?us-ascii?Q?x81Fw+hW1RT1EAUJD6F5qjm+PxaSSnm4SivQuJ1KaDrVeCO0Uuvq9XgWvEXI?=
 =?us-ascii?Q?R0i9tj5eBYDLmtC6Hgl3iz8J+CoGqB5PL8GddP3JRVEuhsK+Zq2Vffpr4Yk5?=
 =?us-ascii?Q?hCXiR45EKCLb63DwjGd7FY2lIxqfEY+6AMxrnKQQzBauFqHCZOKfSy4+20lO?=
 =?us-ascii?Q?ZagPtnXQy2Y5FGMXWrRg0TH4PEcnQhjh13J0tEc61MrpBN7asUHGmQJbI62i?=
 =?us-ascii?Q?WmJPm5+woGFjJ+757ZmjEiSoPpDGZOjPD5np5M3Y1C5TK5Cr9MZxvmhYPgih?=
 =?us-ascii?Q?FQ5HPSTI/PvLbeXpyEldDrfkcObTuaAeSGV9XHLod84rf49LqRANq2N6RplD?=
 =?us-ascii?Q?/dua55oCRzhVOYKamTPeADcuadSUSJ9612dJR3NafA/+cO0AYigaiEoPskof?=
 =?us-ascii?Q?YNILjmYA0T8VmfwMEB55OaU5nPz8x5NBnN7zZPDiMD4i9ajWAPoR4Ksl4jLi?=
 =?us-ascii?Q?/32TWjHpNJgFytbPVllzIVf9X893znS29MKDuXi3J1f28zwHgo8RsvPU2V2B?=
 =?us-ascii?Q?A/i18o5IM4EXZpzIa67HKEGevg/Vjq3q7Z2W8rqJECj7vK+qE51yXiD4lVfP?=
 =?us-ascii?Q?+J2vDAxi4r28BJcPsKlxjqKTJ3JIEhtqwrYogLrEREwdWtoxNDCR2bt7J0UK?=
 =?us-ascii?Q?q8lKNmBSfyiotlbSdd2fPH4XB4v8bE51WQAQ1XBo+sJfTtb2vYFUmKphSljq?=
 =?us-ascii?Q?ZHhGMGjfKp8KEGtebIQV60/9mf122Abf95rs9s5QvHtjfvPB4gaOY901g2ML?=
 =?us-ascii?Q?DJltYliqwKOqgL5zHCRUk7wE9H/IKHL2YDYprBfx+SOjH4MEyw+7nd4/fUOc?=
 =?us-ascii?Q?HXC3yyaiLlu2XD7fGL9TY1pvgAH0hseNCCtkyMqLd1uNi1IOXrZuVZIffTKq?=
 =?us-ascii?Q?60CMbS9NKOx2bMDJxF9HX5qSIs4i7DmnfCBvtdhLwwDO3o1pm76Rv3rSz+Tj?=
 =?us-ascii?Q?yhRkg0lJpJpnAebFMWlHnUtxMDfxrEdja9l3WAFNvR6/6dvzMuLQnCvvN6mw?=
 =?us-ascii?Q?69nN6t/sm4yg/ozDzfKXpM0NpWdVYNNpDc02+lvV1QkNGmeh9WC9RAQvKqo1?=
 =?us-ascii?Q?x6VMtZtrQrJPcEHx6mxQ32xZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k+xv2XqYqdGRLROleBC2sJsQf3DOc2V1VMLcjv4dZfp+ON0GRpJiS3nrfs6n?=
 =?us-ascii?Q?cZXu42CgFBlRr4rmRtA8L9yZgIM2N3m8hd1YoLbDuactB8X0o1MYxks5zdA6?=
 =?us-ascii?Q?k8uO+/k9wkDUJ/4bjtDKyTiD3gLsWqyDcYGKhaCS1gHEiypE8YlNDO2sLMsW?=
 =?us-ascii?Q?KeiWxs6C6ubDnKfc+0fmsA16FEZ9UEsUxuampOjFFheBtr32k8968H1Oroa7?=
 =?us-ascii?Q?9+ziAFgm/Coq5YC3vOLLNX5HlZV3Lj8VLU/CNteVpke+zgj0J3L1cig5FfTJ?=
 =?us-ascii?Q?veLRwMCm3h6JEJif2KyklM+WflisIBDbjmtXvjpAC2D/zECXdDw207+O6P80?=
 =?us-ascii?Q?ctl0B4fzTQarJGGxowoPmLO6vyX8DdJgw0E/xUnIsFOuXzEv+nf2Zo1B/Xbx?=
 =?us-ascii?Q?qsiGErwAZOkGV48Ma2T1EFm6VjoBWuonRbamncmaQ0/x0Kn14K6J7wgCTjA4?=
 =?us-ascii?Q?ExagrzE0n0yAHuXwmAnBczgpZlaL6vmcJG7699I/NZ4n4Q34/Knmr/aRZv6s?=
 =?us-ascii?Q?7/mWsWBb1MXx6/hpMWXMLvJSC0q5NEt+zhMrLI9Ac6vM/NxwN6W5j4yw9NzV?=
 =?us-ascii?Q?5GefrCeIlN22MZH4LgP9ui15QYPThtmd2BkDSFZHCxEFpvJkZ+w1lzfFIr7/?=
 =?us-ascii?Q?HgrPHE3wcr8ZilGLTVKSa9uAwOkmryGDuF3haN3PSm9tiK3TpN9kl65w5o1k?=
 =?us-ascii?Q?+V4HjJbbX8JzVsg/ntuM2nuT1+x7Ss75KelnXqsJrl4yF8HQkKDT03bgF9/U?=
 =?us-ascii?Q?td7ZQ/vEDFpVy4Pzd+8wzA8h6H3M/7xcPRTpicFmct9oRMeNmeG0lmhjX2ZO?=
 =?us-ascii?Q?f4TtCeiR9flnHQa98ul16XyZamkJVJKEquo2sjN/jIQRIN6EWR7SPYBAMCvB?=
 =?us-ascii?Q?O8qxea902AQK0JVrRKjtT7VZHz/+wvlEPdXJMeDMW/sGg8xDAUZpPUMKrquv?=
 =?us-ascii?Q?mpRGDj23IaR7S/6YAGuhTdIGKgaetfluFCWA9zsz0yV/+bC1Smx4/Ie4agpr?=
 =?us-ascii?Q?qAJbpX433IawUHdMBUKpsnH/0isRY9ARNnQ6OD3NNtw9Xfq2CRTGLP+Pu+VO?=
 =?us-ascii?Q?g2+6+Ld217wIn5xkwnowieKXx6P4KV9qfscSfGf1oWB181DySyJZyxM3s9PH?=
 =?us-ascii?Q?NGiSODkUeMWLIaWOAauTQlJWP68Oe1ljLSPue0B280FOGu1UCNIIZv6d4lBc?=
 =?us-ascii?Q?0j1bUdGqlJ+hUFSGzgUfFdC80zfaox62qv3lfLBCtgkUPCw/7g7/mwor3n2p?=
 =?us-ascii?Q?xFE/ufWIs0V4sup/2fSFugnUEyjh4rERljb3D79bO0z40tNCoTiB+BJzo75Z?=
 =?us-ascii?Q?Y/xM6nt5gxwwt2oKnYzaSzIOXozRwleEj51e5HEYXx96DuVPxWR5kvjxJllT?=
 =?us-ascii?Q?PKV3/EHcQVExQQaZuIpJ9nmKdQlLWtj00IPtgPsU7qq5/Fudl6UEaHRQOhe9?=
 =?us-ascii?Q?qST8UHYqIy5vAzBFSdFj8ary/TCHwIcJlcDV5lTceHowXJ6SCg28r0I7E4et?=
 =?us-ascii?Q?wkH7u7kZcIaXRCQBerAku9Gk9SkUd2WbKBk+dJs68wOHGsbZDYW7UrHUrxS5?=
 =?us-ascii?Q?OqEzhxLCmZbqz+xKxenvm4Xe33C5zXoDn3XZSVs/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d9df6d-dd3b-4d4a-5e2d-08dcfdac04bd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 15:10:43.7250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +eyACFt6IEnNnR4Se3r6r0v9faIMSFXQ+Wx+6eNpOzhXpHwr5r8vlZ/bngMJ+2dL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7569

On Tue, Nov 05, 2024 at 04:10:59PM +0800, Yi Liu wrote:

> > > not quite get why this handle is related to iommu driver flushing PRs.
> > > Before __iommu_set_group_pasid(), the pasid is still attached with the
> > > old domain, so is the hw configuration.
> > 
> > I meant that in the path of __iommu_set_group_pasid(), the iommu drivers
> > have the opportunity to flush the PRs pending in the hardware queue. If
> > the attach_handle is switched (by calling xa_store()) before
> > __iommu_set_group_pasid(), the pending PRs will be routed to iopf
> > handler of the new domain, which is not desirable.
> 
> I see. You mean the handling of PRQs. I was interpreting you are talking
> about PRQ draining.

I don't think we need to worry about this race, and certainly you
shouldn't be making the domain replacement path non-hitless just to
fence the page requests.

If a page request comes in during the race window of domain change
there are only three outcomes:

  1) The old domain handles it and it translates on the old domain
  2) The new domain handles it and it translates on the new domain
  3) The old domain handles it and it translates on the new domain.
     a) The page request is ack'd and the device retries and loads the
       new domain - OK - at best it will use the new translation, at
       worst it will retry.
     b) the page request fails and the device sees the failure. This
        is the same as #1 - OK

All are correct. We don't need to do more here than just let the race
resolve itself.

Once the domains are switched in HW we do have to flush everything
queued due to the fault path locking scheme on the domain.

Jason

