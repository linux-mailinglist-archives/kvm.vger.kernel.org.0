Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79887D360F
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 14:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbjJWME1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 08:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234646AbjJWMEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 08:04:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CB6D7A;
        Mon, 23 Oct 2023 05:04:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgiKM4tTdMl9IELuolbYPbNySP6BPQdpoV68IuMFmSr8QdcrHqioPcjtjlBd371A7Epysf9ed3/ukh6mWqwMsmx1gJy/SI8ry4cCCWM4d5Zmyw/7xvTZeQnTBKxPIdTTHsuXa5EBN82rGLeYMpRrUzeJY8/cfFwfkPSxPN4twsWHXcguaJVbxXdysIksb+LDL4oPHaLt2tTscfKR+OxlITk9g4QpKTu7HLXpWFrgUHleB+D1H4yuJdiKxGJJEX4dLzIYIcHsFWWtTuKxrOTVpWtku5Bons11HWljP4ZIInADcDNniej4OtSQILOoiqf5wElCvttw8qAPk55Q/eeX1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXfN2i19zVMDLEgm49TGGKeHHppF1p6eb27csOjwUPs=;
 b=Lf90vrTgw+vw9I05/ybqkBgIIAhaL33Pq7Y1TDRNNWZmEi1hAys4o9LHob93FtcIcMoy7NCHEg+5eTg8LJuFBP7bYT3fp57LMoT9sGrv2/s8h3uXQ7ssaoGre7lj2hg0FuNxsGya4OMSg/n0pBBJwOut5GdqrR3eObawoaFN05b8Q8L0HSrx2JGJOujbVvlULuxYXC21dTjXsYLd//0vSnSxdKdy+f+AXeIQIIdib5L9AA1+U8C6lsiag8rcYJiduDlaRJnPxg7yDLpwmMLR0TJIU9/p4y8waUU7el2Un45dbCczgK/A8rwWc2oExJP4dmjJrR/iqkyI44BSv5kV0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXfN2i19zVMDLEgm49TGGKeHHppF1p6eb27csOjwUPs=;
 b=FXXMGRAyNCoeLeFxpQCUUHQFH8VTCpynBslszZPjAzFdwN3f4N7kJSFWxGDDOaknuXIjJMNglSwkfkfnlx58BjiijPKGpw9aQ/aSwTaFIaIzBbkTETxiZuZM1ggOV0btHDUEpoCV7jqlP120GSKjPeVkR9qVU49nr6Zxh++jQiuYmRwr9TsKiSddl1tu11/vYKYKy23Hhw0hXL8n03P6qC1uN4f9TRt/Spa4Hpc+hnI7VShqFV84OLcl0ori96/I0Wb99D+5/f/bztrBW9XDsLKZh85tLhOrv8xUzUwttyje9+jeFJSyHcVFJEXZt2LOG+5ie8GFBC3QnxxGIqTx5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5217.namprd12.prod.outlook.com (2603:10b6:610:d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Mon, 23 Oct
 2023 12:04:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 12:04:20 +0000
Date:   Mon, 23 Oct 2023 09:04:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        Joao Martins <joao.m.martins@oracle.com>
Cc:     Kevin Tian <kevin.tian@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Shixiong Ou <oushixiong@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: mlx5, pds: add IOMMU_SUPPORT dependency
Message-ID: <20231023120418.GH691768@ziepe.ca>
References: <20231023115520.3530120-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023115520.3530120-1-arnd@kernel.org>
X-ClientProxiedBy: DS7PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:8:57::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5217:EE_
X-MS-Office365-Filtering-Correlation-Id: cad0be06-de6a-40f6-14a2-08dbd3c03076
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +uhE9xAgLCqRUej80a+M4zOLWTj6pa+47mcf7xjsZ3p+qjmDn9Zx+CL8wLGT4ih5wc1T/KCKW+rbFPLCSm3xkVNESVCwEB+bAWWo42o0lKH2JLG5A4W6+QKUw+Gfav1q+Nw+vMDN86W06Qb/QIaqFsSviAV5BPFS4xLbaQ+1lQspBjdo5Nop72BTBuWvqJP6e0WzlFCXAKYNP2DhoA0gl4YqyMb97BHkclvE2CvEBF9JPS3SniSLoYUAnE9L8XSSZXSeU+Kf1BoOV2iPqkjMXMZKLyC5DhTx/hCrjx8TFfrz7we+KOeQWG0JwwK3m01mf0KCJ5fk9zdzW0vfv7VKW1pnJ74bVsD83cfsWrqJ7hwMP6zx8DMfzCKd5dH+MW6HifmSmZ6h2W6GZ4Fxo/YERd/tnZijrwpbc/0gVDqfxIrWPEP/ZJSlS6Wf/tGadEbNUQ2LCEStwQuPXJ2jugZj234LHBgWPblJYSkAzuy9bDbuD2PWhYv1NNi3aKyNurQaLM1z/eHzF7emT7c3pXCjqbbpOEmpqoK5wGFmkjJWDO5F7KiN6mV/HTWdjaWKN3fdVOetqdE6/7zebX11Rvd/soq1LsJOz7Z+keXBL3pBWGw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(136003)(396003)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(26005)(38100700002)(2906002)(41300700001)(86362001)(5660300002)(36756003)(7416002)(4326008)(8676002)(8936002)(33656002)(6506007)(478600001)(110136005)(1076003)(316002)(54906003)(66476007)(66946007)(66556008)(83380400001)(6486002)(6512007)(9686003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rDMwCOi1jhL4nuzV+pu5rHROVcAfLNI1tkCneiCBON71pU3r9nmz/4OMDDtN?=
 =?us-ascii?Q?sHcR00HR9aza3ITYgkRHQ8PebQv1GG3AJLixX9X7iGhnPVCNWHiumBk2YwMb?=
 =?us-ascii?Q?+46YvpG0RgZ7XlkoaYUay/WK0kDxXKGOiN3tMMs3bEgq8a9Pd1RTFjUScofO?=
 =?us-ascii?Q?CF1De5FJb1zxL+pgKtGlWRQ/bwW0wERnlOrsFj7pi1UWz/G7uv6p2indUU5h?=
 =?us-ascii?Q?rQ2Ps0xWZAnDCb1vGJY27j5bZ+oxgvijuR7ivQ3TelGJCbXHXdpkDoTx8J9W?=
 =?us-ascii?Q?5VpPWq9atrl8FRW4WkZ5FJF+NthTjSYNr2pV3Nf+Vos+y07PJY8Df5VcaH6N?=
 =?us-ascii?Q?shoyPTWKBCwIA7P79TBpHCzKrgk2hRdue3EjhsI3HbNFpcqvDQONYJQeqZk1?=
 =?us-ascii?Q?8ssPz9rO3SBOeLUkqf6rFdVGu1Sr4c+pjRpjZIEPVYB4NpMwOlpfGAVTys6B?=
 =?us-ascii?Q?hohwZbAVzo+rXKKFYVWujHhyngw8cjaaOiRMUK8z28ztT8cuGltdUwRiysN3?=
 =?us-ascii?Q?qlFb+GttIQTXB9+hfxkRowoG70nzU8zn7xk8qP7uJCAVpSkG2ygBXsRTofLM?=
 =?us-ascii?Q?A0PQ8e853e9PyiPkClls53rXwzTyCmnFE7P0Ds+kymlhNM/7H3fWQLQzzTiq?=
 =?us-ascii?Q?HXAcxefc0VZeIyKnzNDSV5Avi5fznb6jTFVWvK7l8QEzdEfQJI/CbEJ6X3xM?=
 =?us-ascii?Q?GmV16Yygj8zqYCEFBdifEDV+7RwhiIK4FcMCE1r0mZII0bY+wz3z5W6rC9XG?=
 =?us-ascii?Q?WKxDY7oJreEEceiaL/8wwWvSwgEt0zGibKyE6JykIthwHqqDJvw0KaPiTcmd?=
 =?us-ascii?Q?O4bfhMydCUodkupQZroroiBQ8ULFes3lJMcrMSy2kSk20NE3DOTQDST5WVlw?=
 =?us-ascii?Q?hBZl9NW8W1ydfewMFRvHlukxIXHhgNlPxDBZYcl5wD1KFKST0aVXuYF00RCm?=
 =?us-ascii?Q?OK/kdf9hokP5c/aA+CxDimj76ZbBkVSb3TU+s8Ve1bE3JvOV3AyGc2vEDw0O?=
 =?us-ascii?Q?/SlkkNgKoQXbnfxr4wr1GCLbHRPlYpQ368WPHhiQqYSjf82Q5ywNC2scCasl?=
 =?us-ascii?Q?1YijR2vBPgE/WNITZ7JGxc02JnaIbgIHPpgLDAUYeCDXRxJV0sie9sRklJiD?=
 =?us-ascii?Q?7ITfPuxkak6RC447/wLlvC1y8kkxj/IbfvRMiJaAO9d7byNBqEuDI+cdwIbq?=
 =?us-ascii?Q?od7+NhqW+Qy/ME5CzqmBB4bFsRv34cllS+scGCqQGoeyka2/TvdqO1SzJnX+?=
 =?us-ascii?Q?VlMK5igQba1ZH/3sKrPOrY0910Y+ZwroUODC35kfYApxDPQs+xo6A0KKMNAK?=
 =?us-ascii?Q?i4z/JCLPvGuE2cNyXl+Eh+Yo4akRo9aahJY8hgiRlD95DWxVd0OukA9OsRUq?=
 =?us-ascii?Q?rbpYL0EMEi2bTRr9eL9afOnn8qQY8qB/nFKhKbWF+GBfK5X1Ela+Lr3HUKii?=
 =?us-ascii?Q?9K4fwwd84eI8lUs8+EAqaFzCkR3bRLTcAZRttNktZtN6WLlK2sMu9gaWJvU/?=
 =?us-ascii?Q?Z0ayBXj+y0DGnpayCIJxfHmnlpxNDF/B3jwk06PGUU5A64oOiMwy3qi5N9sp?=
 =?us-ascii?Q?m8sIxg8KmV5oT+6vrss=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cad0be06-de6a-40f6-14a2-08dbd3c03076
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 12:04:20.5733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N4spnyah2pEwZsy+AZthJeKJWhhgEquULjeMi1foStEClpDiee8fwx1yC3C3fqN7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5217
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 01:55:03PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Selecting IOMMUFD_DRIVER is not allowed if IOMMUs themselves are not supported:
> 
> WARNING: unmet direct dependencies detected for IOMMUFD_DRIVER
>   Depends on [n]: IOMMU_SUPPORT [=n]
>   Selected by [m]:
>   - MLX5_VFIO_PCI [=m] && VFIO [=y] && PCI [=y] && MMU [=y] && MLX5_CORE [=y]
> 
> There is no actual build failure, only the warning.
> 
> Make the 'select' conditional using the same logic that we have for
> INTEL_IOMMU and AMD_IOMMU.
> 
> Fixes: 33f6339534287 ("vfio: Move iova_bitmap into iommufd")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/vfio/pci/mlx5/Kconfig | 2 +-
>  drivers/vfio/pci/pds/Kconfig  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

But this isn't the logic this wants, it wants to turn on
IOMMUFD_DRIVER if MLX5_VFIO_PCI is turned on.

I think it means IOMMUFD_DRIVER should be lifted out of the
IOMMU_SUPPORT block somehow. I guess just move it into the top of
drivers/iommu/Kconfig?

Jason
