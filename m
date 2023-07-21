Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E542475CB15
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 17:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjGUPLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 11:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjGUPLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 11:11:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8E23C06;
        Fri, 21 Jul 2023 08:10:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNteRgSWWr2Vs4ntoLq01f06vIbTLvRTztll7aPSSjDbj54MWc0LLRFK3CT5ryFP4MS29N8qmH/Jy2H9h3Yt/4Up1LS/rVSKfW8BceGMNsjr9DFtUNGWRAsprYjgmgzrG8kcey6M+7xBtfftl5KB5YxZfLfq1SshZ6dHSOBlIYAthTLJbCgau5mHCc6DucHdSzzd85TmkVLfTJAEul/mXjHeTNwMpFHjsupMtiWPTph7sDurUES3EsXHHx4w2mGLsD/klXccdW/AoXIG2Dj8EcLEfjFgYCaVijKP4hh1/x00FJ2jUl1JSaQJlYvwY4JUhsZVB7zzXtejA2dLmb+Lfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzA/P60C3lLJjQG/uN5mtD8N+DeCSoekDFGkmxI6JfY=;
 b=dfOSQC/TH3SIGWyV4dI/97xLFY1lotV26Ux36NpYU7DvGqEoH6oOs8eH/uiorJuUfAKMhqDSC6tVsYxHVOrf9VN2LFUd1mIunkcJFT/2mhuFmae74eMAWiffvm8QwdkCzqazIknGHO6MZRXY+3DcweMJJnmmRhYc+189etJ0Gt/tU554JOEszXH6vFFWMA/akhgbVHJwAEpQISQlKKa/44jX9/e/J5gwJuXGSswN5tSQDstAO+Dakl3Y0wyrXUnR6Zh/1xs96KWjqDijSdXks2DuyfkNwK+160OXeXQ0WEa6j+eINKZ+jSqFVcO191LVPeenQpm9fYU5z3F8PMw5hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzA/P60C3lLJjQG/uN5mtD8N+DeCSoekDFGkmxI6JfY=;
 b=kBCpHonmp/cWbuauSqVBv1JkxBJpP6FeyHppuc2vVMpMBUfx6GJl/Bnaqh2T1rWC8AHxRmD8c3GAFFDxg52An1SM7b+EYQfWnJG5H6ebuambblyDT92LjeKicLjOS11UFWekN9dsP6agIu8ShXN5U3QbooyJuG2ATHKLc9zB2QX/BLYx0kyMKBuPx+mO+g2gOkxTeb5p6GsngyUfHJ3Ik/zlvm0gzHjZZGPG1JtQWQUrwOKA7xwQikrqW6ZrQvklHWoivAf+gI3En8HY3GJSonH323n+aenucGy9L3iQ5AdvQRNXinzwgn00yP/tc7y06r09Jay8W+P2noGS1Q0DTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6253.namprd12.prod.outlook.com (2603:10b6:8:a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 15:10:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6609.025; Fri, 21 Jul 2023
 15:10:25 +0000
Date:   Fri, 21 Jul 2023 12:10:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Message-ID: <ZLqf3Q6zlnMi+woU@nvidia.com>
References: <20230713043248.41315-1-baolu.lu@linux.intel.com>
 <20230713043248.41315-2-baolu.lu@linux.intel.com>
 <BN9PR11MB52768040BD1C88E4EB8001878C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52768040BD1C88E4EB8001878C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BY3PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:254::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: f2cb779f-9e54-49d1-4f97-08db89fc9c52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+NWaTOFDSUQicqjbIu+pep7RTsEZogNK+ajjhWC01zEx08AVnCCJRl7CRuB6yorTTkJn9g7VuTaWJXzD45Lq7DlCB1Mv6WY+efcV+JVRqhlO67Ytc8qI+/53DQpeqIFADwK4T8oc+zimz3ywjrBii+TK5xyOh7fkgsvMywPzViOe4UNfh5r1+mwnpnIuRi32yD/lhucHgj9yfhc4Mcfon1ElIas1im/0RaiFAYnYXPhp4OuOkiLvhxvw0pyx/+hnQn1QSAAzF2CKwpC+RoJFwqpm8rnCi6UDGfWDsSVUFyJzjrA/rPD7uq420MDZNXt4aYRy4tN8aFiow3SNlbD1idwLiTCVilAA6d+qa+SEkPc4ZNEmaBDTTGpKB9kR3nrz45iUAGeg3PZo34x2elTjixlqU75lZOfQGimS71zPvoWFR/cU7U3RSg21mp0+84vWw/Ks5T+ClctDwB7xoTSXFm7VmCx7TILt4c2rzDXcwK6tcuyv2wrJ4XsBC4raxD/Q3RYkRfDzk6yJAo7noqhOU31Z6PRYddjQeFU2ynfbI6jEj8gDPV+mBLGDlUDJf5NzKFGF1nsNiOZyPXqanZFZ+ItGRft1XZv9UvYyL3bPzo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(451199021)(6512007)(6486002)(478600001)(4326008)(6666004)(36756003)(316002)(66946007)(54906003)(66476007)(66556008)(41300700001)(86362001)(6916009)(6506007)(2616005)(186003)(38100700002)(83380400001)(4744005)(8676002)(8936002)(2906002)(5660300002)(26005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lpcwxckVu6j43b13V4jfNPqzYjc28QpPpv6Np8ndQFVtHY+ZEcYPGbiWHgnv?=
 =?us-ascii?Q?LfitFtRyAyIRfgJgfiQBsREwHBw2+/2Ky7MsnhbRNSB2GyY1n6ajtD9zcY0S?=
 =?us-ascii?Q?jd55fakb9v2jUJP4lOQcGG5XMWfKWqAtvJE3PomHU7DyoRMJK5knLO/1U/W3?=
 =?us-ascii?Q?yfomcI8GHbPGDCVbal6cpodA+84ETSBhUvDqJYjqELM2I9jyE3orUaX5380H?=
 =?us-ascii?Q?9S5JY0ywbawRkt1XN1hktloE5PsSm4pkUaLR6+fmtXGXhl2kWSwC1p17bEuN?=
 =?us-ascii?Q?ULBEQGDaYWOkfandP5Llu0pRKCBDrLHcMN9idmPsBFTz/KYwCJd6QHR40Lyq?=
 =?us-ascii?Q?YtbKcBfQKMXzCP5ORELyt2LvGQPZ2j4qdFz4dZP59tbVJJIKjBcS+dgE+EW4?=
 =?us-ascii?Q?nPQJ0TIfVCchs4jFX3mWR/s6s/EKKIrT0SqcKSpGMZdcTjlw3kbKbMz+zNU3?=
 =?us-ascii?Q?1yYKvsqCF3qxjLDBFWw9ap50BqtTrYY9sBHX5aX8Y4A+nKc9QnZwPg9wNhCM?=
 =?us-ascii?Q?lG2KdhgUlT9UzqSpOZ99xJwCnUXs64at3dzS3VrEYbFH3EVaVHu9xmaVIfZi?=
 =?us-ascii?Q?IWQOkmU2OPs0ZCxJgzhpRjtmGO9qD4iXAToeHAMrsteYGOAxQzA+uB/yllAE?=
 =?us-ascii?Q?syucTRTRNyYH5GGS9CmZ8nsYdFjqmIhG88U0a/y9+jNgbgn/Qp1zwQJ/dxxO?=
 =?us-ascii?Q?yqPXFIs9/Mzc0h2lwcMcNHtivXVh9fRcWFfsY8ODo5Y8TLpIXMFFYyCxd04a?=
 =?us-ascii?Q?TPb07KYqpowlPs0+IwIV0EfhkW05TnLSVnlCtTcSI2fKbDYanF3go+hhi8yH?=
 =?us-ascii?Q?kD8W1zphdVVd4FRp+OGtzNcaAKLChVdt3va+tIHaKamUaewKma8N5ortg7hn?=
 =?us-ascii?Q?CjBTc/5R0lHqgkcpw8U3ZqaTLLdcgb53V4rWcT7uYkoqGX56BZ4fhzOPP7jI?=
 =?us-ascii?Q?/7JK7LPUa17H1kEdURDRNk6PpRkoLtiK58o9NtUp18kMioJ3Mhm6R0Ur2Rdx?=
 =?us-ascii?Q?SnChkNwNk1Bd+ohWGsmIExNJf2Rc6dAgAZ8sxnkR/RNlKpmZdYws4Ivw5w7b?=
 =?us-ascii?Q?k3f081fXXMoDQY30UkKaqXFXiZ7g6Mh0IYaexYjhkdP+0S2YuV4dZiLKTnWx?=
 =?us-ascii?Q?EGzO00ZSYcWO2dkAQCaGebu8BMhEMYb5YXgzzkgKY39v/MteOkksgecqOhaY?=
 =?us-ascii?Q?c7XrvszWFzfOK5i97to0jgq1Rdmr6HOgm8eiLcWfwcPEV2EPqzNVNMfCGgOW?=
 =?us-ascii?Q?+R5oT2Fo/2pl0rdB9EFAzzIi/rFU2W5OrPkhULT6nPxklZFxYKOF9pZMrDYU?=
 =?us-ascii?Q?eglmXE20FfV7NWgxvaptD46Jv1WrjsYYJ1OnTVzL672fu4J62i+lszvJfPq1?=
 =?us-ascii?Q?cZ6M3LcgLYUDifVap83CGqwu34Fv+2c4kDWhuqCIAqw25pYyC2ldobaMtFiU?=
 =?us-ascii?Q?YkrSfJ1BlmfRGXuhDqqzjRbg65XwOLi1t3ibK9DLb66HP1iTwylEWmh6hej8?=
 =?us-ascii?Q?lSL7z51S3hN7WVSiodSCLtjOUTmHjBu4BZU2W/e1O20JU85j+SDSRngSR4/s?=
 =?us-ascii?Q?SaYPQhfkGfUZdYadoqupxHq+q4xMNlW/E6HUq8IC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2cb779f-9e54-49d1-4f97-08db89fc9c52
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 15:10:25.2254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ShqfWZIzL+mzNdmzjk/G1BSI30zliE/os3xeS9cpeGEz0vbRN97ADujwmkXLW+6q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6253
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 03:07:47AM +0000, Tian, Kevin wrote:
> > @@ -974,13 +972,17 @@ static int
> > iommu_create_device_direct_mappings(struct iommu_domain *domain,
> >  		dma_addr_t start, end, addr;
> >  		size_t map_size = 0;
> > 
> > +		if (entry->type == IOMMU_RESV_DIRECT)
> > +			dev->iommu->requires_direct = 1;
> > +
> > +		if ((entry->type != IOMMU_RESV_DIRECT &&
> > +		     entry->type != IOMMU_RESV_DIRECT_RELAXABLE) ||
> > +		    !iommu_is_dma_domain(domain))
> > +			continue;
> 
> piggybacking a device attribute detection in a function which tries to
> populate domain mappings is a bit confusing.

It is, but to do otherwise we'd want to have the caller obtain the
reserved regions list and iterate it twice. Not sure it is worth the
trouble right now.

Jason
