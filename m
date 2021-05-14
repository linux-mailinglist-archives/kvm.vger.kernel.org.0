Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AC53805D2
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 11:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhENJGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 05:06:44 -0400
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:54177
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229659AbhENJGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 05:06:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZiD8g3pQyt1GhDdD9oF6lR6QRf4utmqeHYg4vwTnrW2tIVRh5JVMK6oqUGokkxW1F4WD9nIrP+I1oPlelau8grBaTIXuY+fRhbx5FxSRZq6QesBY45MdygvSV7igAfnxKf8V65QOzLbY8w9wI2fJoqVtCzHsMXdz8RIMzYM4dMXWy9CaAi/FOPTuAjzq++YefNSp3QC03TUwKXcAsn8t+5UqGcW3eCjDzuEERl56GYRKQxsZdYusts/UxrmwVln4pbEE0HFscHrhjORwcUBYapeaTyhPuzpxLduwfHFs51gIoN/T2ZJ2qXD5xARA/YqJkcJVHtNv01a3QncFboobQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=di28MuRtrsx/Pkk1Il8Mmdzl7Cy/19WRIkMS3p3GFlY=;
 b=incOFuFZ0GHPYuDEVb3ZYmeGw3lnFlXVjLCMccJJEAY1oOW4XqFaJ7f2QuVaKq8Au6PgIQYqkRShMipmpDpwWGxK1uD/SirSqMireaLk3saQafqBM3rHEB5xvvtEq9bal7s9UASq/olCZzFvrF3s5Fi7F/wyPTwLeUuJTYu0qjqA+h8+aj8qc6VQxr4VdF4iNmBJw3t3Rrbp64Zx+R5kJZKEanT0l0fWRtYxMITG3t0OZaI9/M2RyTFLWNFruWZWSGe4Y4awEqXEJ3DDHvuYXo4lkjECDGbGqaTJoDhdoX9yiEoghk7kERmIMAeTQ4uO5PKTq6X28KYQRDMfeSBNew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=di28MuRtrsx/Pkk1Il8Mmdzl7Cy/19WRIkMS3p3GFlY=;
 b=wh2p/ZgnoiX1hcMw01RYUDCjuBb6BEi6Jo1RBUHLWptOMeW4tRC4hXKj2Ekwq/Vt4mFEaI61hNDw3NjkuSZsfJqGilhrPI6cCmhgf/u0bP+BzpvN0IxwCGVrf2vEBwx+HD2VII4nhAfRxoraDV2QE0Ze4lj6kLhS9uLuFsvz1/A=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB4672.namprd12.prod.outlook.com (2603:10b6:805:12::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Fri, 14 May
 2021 09:05:29 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 09:05:29 +0000
Date:   Fri, 14 May 2021 09:05:23 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20210514090523.GA21627@ashkalra_ubuntu_server>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
 <20210513043441.GA28019@ashkalra_ubuntu_server>
 <YJ4n2Ypmq/7U1znM@zn.tnic>
 <7ac12a36-5886-cb07-cc77-a96daa76b854@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ac12a36-5886-cb07-cc77-a96daa76b854@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0050.prod.exchangelabs.com (2603:10b6:800::18) To
 SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0050.prod.exchangelabs.com (2603:10b6:800::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 14 May 2021 09:05:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc58d149-c4b4-463e-cb53-08d916b76bc1
X-MS-TrafficTypeDiagnostic: SN6PR12MB4672:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB46720A81499202B5275A972E8E509@SN6PR12MB4672.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:255;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9TTobUcrrj3mmm3rnDLfOSaHw3/CIzi+VXm4c0sAG2i2w7YKEspo5+oHfmFjgkJrePojupPhTdWkGSMxJ08ziGAyh9npIkTjXLwVdVLSsi/NLUCDmvWw2+O4MkqeQqiE49VT1PMfd1UnLNppfB/JeJbdacS5sBl+Yh09LUk3TMB5rIUwBZJWpMdoyVDLiIcCw6XAZvyoe736BW6yu9XXpcWREs8gNxyoFPQ/BtfajoZL5hn3EeW+qDy1XwBOm6x5Mh6ecTXh9wuX/sqNy56y/vgpsDnzMBSIN/mu36aMWmOosfGF4Pp08rJyI023FNfT2hsLBkZjjEr14Ulmpj/1BEz/udBmzPGfj/4vj+McvfxRlwU3dPtqZMhPLYMXMVygD87XjTA6cnJ0EohL6z4dsHVht+ulaBx59k9vHq5aPOau797UMNrk3jIHy+gbGm4IDi22mBW0zYaO9i0vDkAAkjG5ZQDoc2EODl5a4yOhGvhxD15cNjvHyyAAC8LvR2kXR3wqu8Wx6EYBnBspWvvy7RKJ/UZiAQMSBoboXLsgi2sXC+N6MUJajGQfAHdSQxI1/RZFpZqFruP1et8orOfES3K/Qj5W1HPvsYqwmOUjEHIr6b+eDTc7ZkT+ZyTaBuONmTGX8TOKQv+tz8zXXPs2etQFya3DAZMJYla7ysbwzO8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(9686003)(5660300002)(38350700002)(66476007)(6666004)(8676002)(53546011)(26005)(8936002)(4326008)(38100700002)(6496006)(44832011)(55016002)(6916009)(7416002)(956004)(1076003)(33716001)(2906002)(186003)(66556008)(316002)(52116002)(66946007)(478600001)(83380400001)(16526019)(86362001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ytSUvNuiLf4WD3A5BOpk0dI0RkcuSpeoIGSpMBzIYRoEV4wh2Iv5FC3N8Q4F?=
 =?us-ascii?Q?p6cpoc8QnljANme5EG1LmOoTpDt7lPfRquoljdjJFaGeHFt3uah7aNHDtmrs?=
 =?us-ascii?Q?TZEm/eUKuTq8DXdAb5zgaxVEQ90H+thRTeJn+GLY+Y0/PfX5Wvs9IKmor0aC?=
 =?us-ascii?Q?MtH3PEORFJkL9Vyk/H8SkRuCSUd44YdOoQnS/5ziK9JqJ493ki9M93RmBIgY?=
 =?us-ascii?Q?YTG4jRxvLnmTNbtgleAHDG5SBU2G0EoMK1/eZXJ9Mw6Swc4krVEnhl0ZRppS?=
 =?us-ascii?Q?dy3YWpHz2ZR61NKsAsjTDQE6+qVpJu6MZjN97ky9dCK0RI5LqCLgm+saXirD?=
 =?us-ascii?Q?g7+UQz7q/mazloje1NnN1NrpIgIA0x0A1ByxN4dYB2a1mYLrKfGbhksVL5fy?=
 =?us-ascii?Q?XxTZo0c9soDuN1YnU4P8oO5zkKhOkE6LLolIKF3AbbzcQdXaFwm827x7UIpb?=
 =?us-ascii?Q?tCdEKvOC7nCQgPpjsXJc4X3s5TGcWQEpirR50y5M45em6aMEimoIZVtO+LG3?=
 =?us-ascii?Q?FN9qNFHtX47hVk3ithjUunPwn6fWkcrcKzcgqIySOLkN89L1IKPKDak30RZo?=
 =?us-ascii?Q?lUimIL5izbWcVJfYk32h4bG99GZ01Md10GzUZ4MpobMiYveAH7r9G1xp+lfc?=
 =?us-ascii?Q?QxyPgYBSH+Iabo+jjjd6SeAw89RvEAxs3RHZu9pxaX2YfUA/6tN3DvgXcAzP?=
 =?us-ascii?Q?0ULOCVQzMiWJisVEec5pWxNKBPUe4bw0FQMN7IGWxuMV3iU0WNaPghVOWyFz?=
 =?us-ascii?Q?LCjzViKYo/i9/SNiOLZhJDHb3ReiK6yMFhlqGulEPcMOim1rvNMu6qN3k7ZO?=
 =?us-ascii?Q?8MQWixcxL3XinYSP+cyF9sPiJbuB4wBXbEnZ0xpuMFccvzlm0AapAsr/Uzu7?=
 =?us-ascii?Q?FmYmqAV4MRh1OckGgF9AHzn+rcmGJer+RBV406/f+EzrZxJbVUGDHOPUcddE?=
 =?us-ascii?Q?n/j/vDsMtMX239gykKFbz8b8fjicm0hZhmOTQty6k1NhPu+op+9xPrNQhaM8?=
 =?us-ascii?Q?DcJVvUijlICK3b7gippSnXsu+tNfNzMT2cXDlM/p32dhng44S/PhYaGZN8jY?=
 =?us-ascii?Q?TTPx102W4P1Qx/kibYw0G6PJCCBI87sjilHDrQLJHSWseIwvl1acfVMaxzWT?=
 =?us-ascii?Q?WjCTrpoTyBzMnePTBVsZ3EKXgeLtxqWGq2wh0+A+4Z1/Sef874vB2AWnS5nx?=
 =?us-ascii?Q?TouRCBqf323TaJ0yeGLpfbbm36VLLwwwhV8z0VKRJN/vbtx4TBVaDOW4Ns0M?=
 =?us-ascii?Q?H1SPwJ98L6Y50yPOAEdU1Bz7UsXmNoj4u9Zx5uvO1SHyUn8GuyM3zubQ7Y7h?=
 =?us-ascii?Q?J8D2k/AiSMNhxXxL9XFPYpGu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc58d149-c4b4-463e-cb53-08d916b76bc1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 09:05:29.4633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUzl53hVhuiic80PNLWrILcqTezOVNVDVzKkfVvrqH4C/KPyg3QDLV9qZ7IMDl/eBqVDsbb0QacaW3WapZF44A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4672
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris, Paolo,

On Fri, May 14, 2021 at 10:03:18AM +0200, Paolo Bonzini wrote:
> On 14/05/21 09:33, Borislav Petkov wrote:
> > Ok, so explain to me how this looks from the user standpoint: she starts
> > migrating the guest, it fails to lookup an address, there's nothing
> > saying where it failed but the guest crashed.
> > 
> > Do you think this is user-friendly?
> 
> Ok, so explain to me how this looks from the submitter standpoint: he reads
> your review of his patch, he acknowledges your point with "Yes, it makes
> sense to signal it with a WARN or so", and still is treated as shit.
> 
> Do you think this is friendly?
> 
> 

I absolutely agree with both of your point of view. But what's the
alternative ?

Ideally we should fail/stop migration even if a single guest page
encryption status cannot be notified and that should be the way to
proceed in this case, the guest kernel should notify the source
userspace VMM to block/stop migration in this case.

From a practical side, i do see Qemu's migrate_add_blocker() interface
but that looks to be a static interface and also i don't think it will
force stop an ongoing migration, is there an existing mechanism
to inform userspace VMM from kernel about blocking/stopping migration ?

Thanks,
Ashish
