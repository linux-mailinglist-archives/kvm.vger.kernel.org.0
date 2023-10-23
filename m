Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560CE7D3CA8
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 18:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbjJWQeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 12:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjJWQeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 12:34:18 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F7F8F
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:34:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5CvYiNYwvX7UvTF7o8e63aOmizhynesi8mDi0+oDFOmpm/GEGqm2sz71ZgTTskheim6w/CW6ehhgiDY6dmWTKivqtEN+Xe17xgAgO3DZR/qZlsiK1fY+P9s4T79He1hZlPXuAXpNkdCyJQmtpdIBxCj3FNMrBqc7h6NBTTuCdYIcH7bCWCttPDIIVYZcoCz2t7NU3t0LIKmho+Uz7NG+QyaTLcDw1zcIryPZR99qFArPir2vYZMtOm1Y3CFTNbMAwASjccIkDxBHBf3uUEJIYHpjEBQBWlQCEr/zE8bo3DwveinSu5FFh/eEV1Ippm4b0BhFxulXLPdE8j2TPtk5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hHpPK9WfAGcUDyB1FZpQBMkDtMFDuFeTnmGmtLngvUk=;
 b=bJpugiFg9DlyUOpsQYCM0UDHANBeAJDiOHkdlQ17gqEhIjomVwDoz0XXi5xnb4vSxUAracea7WMtJ5ZjPrztsRI3vOw7VAFnocW9UKGKSkWTg8QA3UrgQI5h3UFOk/VMsupaEwGIRQx5lbMf3lCt3lNil1/AseXJhgnpmeGNlLcPlWW4/osfDRN94nVr4qGJeB8SkNW8UWL7bPgQBHe/U3CJddeREKWbAx4I2OceC69DnfnvIK3XXz1UyGL72WXsEdzaRD4GsPced/75dnKHoX/oanvzCm+9Ofk16JPU2Dxi7zs0P19H/MVskrcjDpX9FZsx2R5w9FxlF95LApw3hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHpPK9WfAGcUDyB1FZpQBMkDtMFDuFeTnmGmtLngvUk=;
 b=jOSRP8gF6wRVvcY2ecP3DiVvfhSIeTVINKsim6fInhGfguuDhtaQK0D4bgFVpSkQbKqPZ2ICwdESC241OEg1+8EKRsUVI0MwAWK1Cj+0U8svixW5mHcnfmmu+eyuJvEVC42hsK7B8ncSnNngPxzVBsvYzMob1aJarpHsvXIUMZqnP0t71P6TJ6ndd+Vob6MlYPKxeBKnwfeh5tTXVFTuk7Ra7qECyo4ipzCBDq4BWx8dk9pOEq1pAwD6APBzR//26waoUDaoygXzPpwuDDdHTrjhe16ELX1GPBjCIp9xeRR1FG4rpozZ71BykneUURrwzXxLUPuXYSDE0pi8W6Dvyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7632.namprd12.prod.outlook.com (2603:10b6:8:11f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 16:34:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 16:34:13 +0000
Date:   Mon, 23 Oct 2023 13:34:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
Message-ID: <20231023163411.GC3952@nvidia.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-8-joao.m.martins@oracle.com>
 <b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com>
 <d65cb92a-8d2c-41a3-83b1-899310db1a20@oracle.com>
 <20231023121013.GQ3952@nvidia.com>
 <5a809f02-f102-4488-9fb2-bd4eb1c94999@app.fastmail.com>
 <7067efd0-e872-4ff6-b53b-d41bbbe1ea1e@oracle.com>
 <20231023161627.GA3952@nvidia.com>
 <f511e068-802b-4be2-8cbd-ae67f27078e7@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f511e068-802b-4be2-8cbd-ae67f27078e7@oracle.com>
X-ClientProxiedBy: SA9PR11CA0026.namprd11.prod.outlook.com
 (2603:10b6:806:6e::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7632:EE_
X-MS-Office365-Filtering-Correlation-Id: bf9b4de8-2749-48de-d984-08dbd3e5e3e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9t/Wu1LYrq5n4NrDI0m4smkBDpERRoqYKUSLrfGfa3y4+PuXukBKtYm5MTZU5VH27fbMbdWqT9IwlD5ng6ftFHnq6rBPcaX5jFR5rzrhCLqmJpjNA9ktfAKm5VH+po+tWQG2ct6wpttgpYq86R4Y3W2t+EXPYsUNgfy/7QMelSWQuNuo5wTEWEbZmm7qMRHIcWYJO5BcfgbXhbBU3pR97Q7zv1EoBy5756Y6SDJc2y6UypwHB+bvJb1HRQM1tNmQ/qImQI6V0FKLrS3kpihKu43wxuUSf/JcESku9iC2ICwiwJp0gQTCgcdHw2EbaFOVCCZebzjDNHKsOzF9rlc//9wHs0QSocnj+bdt7soPn8HTmMGZgzeJSJuIBw77jQmWB+Gwq1AHaEbnSXluRKPFBmpCuUnPHp2+X7wavr5LwQm7ozDm5aszEs5OCtbASpHcCj8ztl1CeXjtcwlMJvwM7SlNpj0n0DOFSLvl5nABsh1MPGbMyjE9RIdXA0ONqAYlTHsSJdb1crqAu4spD1bLHRKHjN8wybEf7OgIr/WnRguF4m4xsMtu4XOA/cuvh93jdWFwuakgtqxwMhrq9xQn+Svc3od1XcERkkIXXLfKjuI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(366004)(346002)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(36756003)(33656002)(41300700001)(4326008)(8676002)(8936002)(5660300002)(7416002)(2906002)(4744005)(86362001)(2616005)(6512007)(26005)(1076003)(478600001)(6486002)(6506007)(38100700002)(316002)(6916009)(54906003)(66946007)(66476007)(66556008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/mEZ2OATgql64BpN1tn+72Sw4hE3QTdji1CBghN8ANR7YLQR1oZe1N9x0CoI?=
 =?us-ascii?Q?O5lFDB6JKbOlWFY9mvfXmzcPssZ4maGDGBYbYk+kvivBiKhOTEOX57oXBT63?=
 =?us-ascii?Q?0nDBUvX39+Af8UYAfP9nCQisuHVrO0OFTGWMv67cR9f2CDNz1LTknkNfBlQ9?=
 =?us-ascii?Q?MzCImX6CMKPzb/LG8MbwBC4kuVbu7gjlUO0elz9v3+qwetjeayFfgPkdldaC?=
 =?us-ascii?Q?gchQu+hovYo0cszRCXl50kcGTNBbGlw6z0U4me6DK4THc6rS64uF5cv0H65f?=
 =?us-ascii?Q?NDJEfqteRt7sdiEfSKPpMhh6un9bcWfYsy9rQGUZ66A6Cqkk7EE5rQ2i82Ec?=
 =?us-ascii?Q?kkiekKnz/VsmTQ6vFNioeYl7OXGXdB2+kL1oe8IutL6IOV2VPv62iLUfAWSe?=
 =?us-ascii?Q?VN9BgghEYcNCJ69bAP5dVIM6Cy380cvoY028zytI0yrDfqUcAgL28Z3NQ4RJ?=
 =?us-ascii?Q?+c1K44iX7TRKz9HI8reimbKMIMJjkA1NWC6vBsBNbrmf2OpBefI0pN0YuqwU?=
 =?us-ascii?Q?2exONoWKmN2olXw0+vR30tPXFN9dWGEjlSxDHrodd65k+UP3oib0kp6R5rKg?=
 =?us-ascii?Q?tFCIK2bdfZhAaXlw/A0fmAFwzjl+PxCw6ENoxhoFDtw3gwmokll+WZIt6WcM?=
 =?us-ascii?Q?CydoEr2tfbznNolz9x+zEw6okonu/W+ndQfJGclPLxxPTQ5hwAWHnuzzZjp8?=
 =?us-ascii?Q?cm1sHHimnHX+DdY0KASOE1ye+BOCT0HJXjT7aKcpiVvwydabKfDnrJCVXEVM?=
 =?us-ascii?Q?wb8vWePf4FB9E4FDlLKGMUOVQ6qg0RBxqoaiKJswQNUJ7XHm43ew1t4AJpgz?=
 =?us-ascii?Q?WSFJyzWMCxsCmSuo0ag52zoQyKQ1uono3HCsjtUNfbeUyY37iXHnETlzVY92?=
 =?us-ascii?Q?X+og3EsG3rUKDwwYLlheFI+rkidLh/lG+grXaVGopsYD+4EpQAKQVGLx9n7a?=
 =?us-ascii?Q?PH8iNONap7TFMh3cD9H0EFaSgRQMuB5pZ0kfjT/q/zvCLCkKZ+3xys/iWHbT?=
 =?us-ascii?Q?KGtXQFINKUIOb6SQZkdy699eXB+uCuSOh3sQ6JKhdNLheNydcPH8MFgj+kA0?=
 =?us-ascii?Q?9qWTNHxaGd5ZW/grz9e1lSSh/sSsscb7Jtj3t0I7X58XSuQFR0kJh9Cvfide?=
 =?us-ascii?Q?MjrtdguPPf7a9PqDyk7PfiOWTB9y86wl40gWWYF/rNRs67GXy4psbte9yrhH?=
 =?us-ascii?Q?MCvIuE6CwOQE3KSvxtBiVTFJpfdfVoEw2hpeRWAC3nlxqMFDAfhrluqceVNa?=
 =?us-ascii?Q?FJPHkUVqhsHnBKXc0Ugj7a826wZYeUEyt7+8IACPwyI6DZ0eHHF+bD9xbxnv?=
 =?us-ascii?Q?W1N5g3jd/lQHBwy1DZ4tuPd+mBRqqAxDhdLIQH03R05OtyrfJOIY1lkEAMy9?=
 =?us-ascii?Q?5XeRLic3od1trA8S4hPmK/IuZaKWS7z49hhHcyGidedB7+Rkt01RFPwIzgd7?=
 =?us-ascii?Q?1xEWHsxlirNr5WdigGg3jbIJ58+9UzbwhJ4qc0KbbUMBuai7OJBCqoKWQ9Tw?=
 =?us-ascii?Q?wB2sr8FDSurAjqBUBd0Hr6uJHFhHKXRsmNRhvQByU1ipF+Ot1bZ+fh86y/NG?=
 =?us-ascii?Q?B1kA9KAe+8KhB/ip1DUHVkLmUIVN84LC/I8EOZO5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf9b4de8-2749-48de-d984-08dbd3e5e3e8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 16:34:12.9743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: huynM1ED2UnPF0brkwRX8IxmvR1TrFv8MuPVIjxRBQeDGO5apRpC0YS+bMK5QOo4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7632
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 05:31:22PM +0100, Joao Martins wrote:
> > Write it like this:
> > 
> > int iommufd_check_iova_range(struct iommufd_ioas *ioas,
> > 			     struct iommu_hwpt_get_dirty_bitmap *bitmap)
> > {
> > 	size_t iommu_pgsize = ioas->iopt.iova_alignment;
> > 	u64 last_iova;
> > 
> > 	if (check_add_overflow(bitmap->iova, bitmap->length - 1, &last_iova))
> > 		return -EOVERFLOW;
> > 
> > 	if (bitmap->iova > ULONG_MAX || last_iova > ULONG_MAX)
> > 		return -EOVERFLOW;
> > 
> > 	if ((bitmap->iova & (iommu_pgsize - 1)) ||
> > 	    ((last_iova + 1) & (iommu_pgsize - 1)))
> > 		return -EINVAL;
> > 	return 0;
> > }
> > 
> > And if 0 should really be rejected then check iova == last_iova
> 
> It should; Perhaps extending the above and replicate that second the ::page_size
> alignment check is important as it's what's used by the bitmap e.g.

That makes sense, much clearer what it is trying to do that way

Jason
