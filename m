Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC83B6A254E
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 01:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjBYACw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 19:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBYACv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 19:02:51 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4398BB9B;
        Fri, 24 Feb 2023 16:02:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neQlcHeGB7lSrAr1HBUqjcytb2/TukTAS17AbFBIx553bdG3fV7YXP6xMuKPNrJAq3QD59xeG6OC+um0odL/rF7BNXqXUOVzyDZd+TblcZDVMEMOW7weuPiPmiEgpF5Hj09Fc0g2S5k8zcYGkiVnJNPpuoeZUwcd94fBMxjYMJMFEhM4fPG+1Br0i2dHRYIy8SomjmJNhxONoYm7vr5syuce8dw3nfR+zyUuADMEcXpo7yal0B3IKvUv7F8D0yDWaGYHBV4rly32GHvDdI0UiIv3rwKTDaKbE8nfjc/VMNSoyIV1uf+mUpBVmm0OozzoSbP0ik2EBncAxN85DHNfgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GmptfPGVz6H9JPWHonEMVi89Q4smGdevbdMHN4eP2ng=;
 b=Zl8ryZWz38domvAWufY5M1cI2bGshTlM1g4r6hiqcB/jaRQ1fLTaDsaG8jTqu7Jr1AaBepKuCK4qT2ZVvlDg/FVPrreNNGuOKU9Wh5HM5kUZl/iTeR/Len+Lv1ryXSoEIRvYZyqKPn3mL94FGNkX12S/M9fOg5seolyM3BR1NvKaG38Suql1zgBWQPmmgoWTvhpjASlT4hXQnWXZrnw9V+EFfBI1+ijHP+Z9HavDcqzdgFiAyTRr9+Wg2k/otm0w691eFMXK6nX5SfYHGf2IM/zheRACnbZ1qi9GbdkSU3Ras8JpZ8Q9WyWCTKCW6GM+5EK/4IKi+ikEWTKuH0M7KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmptfPGVz6H9JPWHonEMVi89Q4smGdevbdMHN4eP2ng=;
 b=UDRShEZZDOuXvFvun5d0lS0KmMg81pAXsleoHrft3IDkap13fwSTGvy9Gt+Dgih//0jv5o6KpfPKkb+wDr1GTpLMRFIgC9TEg2AAsHlrVZK1SSdctHGIvcfcJLjUZxclI4l+v0hMX4ngmT/DrMucwM0/6BCLEhJBOwh/HmUHrZrl9e67djVrcNsbmiJ1VXiWxpv/+rjtn8jFhpklBAJTkw6LdH7/OwRImL846H1d3ZeCAX/AH9SRgtwyzAGm0OoNAiFhHGLKIfsjVRLLOBB2kcnJGzqBlVfx5tSLZfdxPD3oYtVsnpFtQvvkc0w5tS1+Y4VQL5A/dmZniKS3Hk2+eg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4334.namprd12.prod.outlook.com (2603:10b6:208:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Sat, 25 Feb
 2023 00:02:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.021; Sat, 25 Feb 2023
 00:02:45 +0000
Date:   Fri, 24 Feb 2023 20:02:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <Y/lQIwcha1DFq2om@nvidia.com>
References: <Y/Tlx8j3i17n5bzL@nvidia.com>
 <CAHk-=wiy2XRdvxchyuVYJJ618sAcGiPPam14z8yAW+kyCzgPmA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiy2XRdvxchyuVYJJ618sAcGiPPam14z8yAW+kyCzgPmA@mail.gmail.com>
X-ClientProxiedBy: BLAPR03CA0174.namprd03.prod.outlook.com
 (2603:10b6:208:32f::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4334:EE_
X-MS-Office365-Filtering-Correlation-Id: 4177b454-f427-463c-9f27-08db16c39f70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xsXXmQLeXtCL6151+GePgvqBi5k5mpSg/dXVsRm68qk/HRkxnOYlYcjA/4SO13x9n8TZf2VjaRzk6PKBBFNPr8pj7L1g6MGqoG/79watVR2ih5MA6pz6Fen/0TTrv2Xozr2qmRlnfFfjLimDnk2dLgg8EM5FLxmlU28tPf7hB59/Y2P9CcAk2alz7NoLgw+aMGqmpBQ5QCC+zdX6JnvlHYi8JfOrA3clAkiDbXhhKMreQBDyOQdyu+3CcBRyOZTjKPpXoEUPzbXedNzrYeomwge26Gni7lufTXp8NpEDdQQV37oNET0VEnUy+z4vBnVUqYPk2QaGd1xtkEsdivTHNaXJglkszkRvHYn3oL664nNL+mfy4NCVYQd9WkrIa7CaiHqTQcn+UmBylmj2Tbx2jse+qSZyQtAc2oHOHCiGPvWDJ8/bHbRrP89EzgIN+MWFSIYjahCZX5CqzJz4E1Kb3aCeuiFzCSgKcPgn4ePHYf/3lQ1A9TJ/vMc8T62faKcgSFZqwKNw0i9ejGP/kB2QhVmRjAG+q5PiptxXEjeA+GGcX2yDJxbWFyTA/Rd2YuQwwTXDPRBpxCCri29mMkLBGui9gmtJl2jCUVJmAL2qlvYEua7g9jEx1Gtngs8pNwOtacnErleD+Y7lza/I3nKsEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199018)(66556008)(66476007)(66946007)(6916009)(8936002)(41300700001)(8676002)(4326008)(186003)(26005)(5660300002)(83380400001)(316002)(2906002)(6512007)(6506007)(53546011)(6486002)(478600001)(38100700002)(2616005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2bDZhLM02s5sY0g6RfZPndS+3uSl1g2O3gxZgOZB/s0u1F2Uo9Rc3bhCyrJ+?=
 =?us-ascii?Q?a2W5U9kcrlghyP2AnRznQDL5uzpAzWeK4VPLAkAJSCtOZGpjS2sl71cciCtL?=
 =?us-ascii?Q?ZdSfqRLNYQEDiiOvQA2sC8Na3OsCNNaFxbrl2iDdS6aF42A7gsJUHNSUbY6Z?=
 =?us-ascii?Q?EgwY7phfUDKnblMaMXdeCwS1XF2rX8XsObwUoTW47ybG5L+7v4oimUk5JEpQ?=
 =?us-ascii?Q?LiecpsSW0u62OkBc26BaNwfqaJD461HtqTYbzYRDBxCtWwFWH984CSg+VTuR?=
 =?us-ascii?Q?2MroDLs4YL1/1szrwvxkeIlK8PryByr5V3asiTxuamIzF9QebzG8n2OWtTc3?=
 =?us-ascii?Q?8aMIlnCqG9QhD1tAi+Uvs4xh5Td4+fVafNdUiwRGPvwq1SAvP8GBDbgwyPOz?=
 =?us-ascii?Q?Zh87CTxmrpUVkLX1VOjk+YQeAi8AMAYod7P1G8HG/rvkYzrnzRU4nRl9VrET?=
 =?us-ascii?Q?+YBL+KQizIkoM2mbtS/XSHcQ/2gcgLz441ejKvIm85bSLQd/flKapbZLt7WW?=
 =?us-ascii?Q?uklOUeb1PWMgcsLFmLWX+MsJGZvXWQ46BSxxTqe8v6vXfpSypNh6ngtAPJjY?=
 =?us-ascii?Q?4Hb4bzfBRmm+kec98C557O6++w5RUw5+/dgViVpTS8is0qY/abGEiSbBytYt?=
 =?us-ascii?Q?RoVB/68jr9eJTj3MvnXwl1xExi2g3SaLpjFD7z7dHBFc9jYuSW+dXFJw69xW?=
 =?us-ascii?Q?Bhz8CNSXT4/DaA9fuJPqGv4wVhTYK03ve5nzflggpNJivjKW3/fnuiItkxbp?=
 =?us-ascii?Q?DfzXBQfHGDfPj48f4pEQPHrvpdgTq0LwMvJ8pyEpmL5Q53scHnGlPSrKopPJ?=
 =?us-ascii?Q?E9OfZMa3un1fisuc6NBWV7HLNs6hAavkbZvV5UyXdb4bkG+ZmvfA/VaaSmMu?=
 =?us-ascii?Q?MQZyZz24u7nX6kWicCKotMYIQKQozSv1sLNA/NgQQ05A/iH6Yckd5r9ZfEz7?=
 =?us-ascii?Q?lZsW+0M3MVZN1Rofv/adWNq7qW3F61ZcC+EsEpwNQRu+PSpPSFR4Iggt3+RZ?=
 =?us-ascii?Q?XvPues6/BCM+9wCLcYiL1aW6IBN9m44DA6eAI/rtji93sOFiPMzZVb1j2vGx?=
 =?us-ascii?Q?q5Qte6T7Ig6HisaqPd33GU8xHVSHvLUho0D9BclvDrXS/Q3UU/tyn87kZ/Rx?=
 =?us-ascii?Q?1GOlflXuZhDgV7XpY92tfBEX8yb+zekQSYH9lz6V9baLzY72T89rb5HtmuJj?=
 =?us-ascii?Q?35T8eYKHYiGNiG8i333P6Ocm5ifpMvPkUeEDZmTMeidrpaZTWL+nLjj7dBJ0?=
 =?us-ascii?Q?Ryy+hel4Bf4GDhEcKI0pp352L78yC9Uq+agL4TM/eMhH4KJxHqc1FGIdPdbd?=
 =?us-ascii?Q?VyLGuO66xwV7sjBTM3J+HivUrc5s/Fwog/bc0PRPIqXqvcKTXykzFo6+kgNQ?=
 =?us-ascii?Q?hJ7sqzgi+6cgx5tQzIWI7vcVo48U4mGHILN70w8SThFScZpkeN1XHdOKPAPL?=
 =?us-ascii?Q?k0SCEUo9KcF5CNHEPIStYQiXRpVV2UBAdBe2mKFxBPMGyysCTkyHwWm7y724?=
 =?us-ascii?Q?QDUIhKjr3SUxYSXPHcZTo3SIGIGduAtSuCGp8qw5fTbC7Vj/0kV75L3ELq2Q?=
 =?us-ascii?Q?46QmVvEXypp0G9OCKCi4aDraPflDgxjaaaRkwZ6T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4177b454-f427-463c-9f27-08db16c39f70
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 00:02:45.4335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExojJMwrTYg/k+07c4bibC/P+pTdxP9gnZV4pD1XuEyoEmvE/7bCaUVKfob2Kg3n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4334
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 02:50:45PM -0800, Linus Torvalds wrote:
> On Tue, Feb 21, 2023 at 7:39 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > iommufd for 6.3
> >
> > Some polishing and small fixes for iommufd:
> 
> Hmm. About half the patches seem to not be about iommufd, but about
> 'isolated_msi', which isn't even mentioned in the pull request at all
> (well, it's there in the shortlog, but not in the actual "this is what
> happened")

Ah, it is perhaps somewhat cryptically mentioned in the tag:

"Remove IOMMU_CAP_INTR_REMAP, instead rely on the interrupt subsystem"

In retrospect I can see that is pretty obtuse, but from my POV that
was the goal of that series :)

> I already merged it, and am not sure what I would add to the commit
> message, but I really would have liked to see that mentioned,
> considering that it wasn't some small part of it all.

I think the missing paragraph is something like:

 This PR includes some rework of MSI isolation/security capability
 detection that touches irq, iommu, vfio and iommufd. It consolidates
 two partially overlapping approaches into a single one.

Do you like this sort of explanation in the email or the tag?

Honestly, after 5 years (wow time flies) of sending PRs for rdma I'm
still a bit unclear on the best way to write the tag message.

I suppose you noticed, but I've followed John Corbet's suggestion to
capture the cover letters in internal merge commits. Eg isolated-msi
has a lot of words in commit fc3873095a

Thanks,
Jason
