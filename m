Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131DF6A4A30
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjB0Sq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjB0Sq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:46:56 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5771EBC0;
        Mon, 27 Feb 2023 10:46:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQtQtjTy2EF1eMQpqJ/WDLJO0rLlOarQ/3hK6R6vibsPh6nbdN321nUyzuOTw5GInRDw8/v1x+VzYIgcLVsL7pAUttppq2PEq4riBcv/YemYiublB0Q+M8P+0Arcrgv3qugMTwzhxlfTxoHoT743km9aq3sbJF/nK91+Wy/SnX5v/s8v2TQKiHkrE/XWWxY1kWQgaG+rZG48GYOPtbwljGaE24WWf1VddDStAiBlL2DQElIpOd7+KkfOtFx704BFxq6XCRpgb/kFMSpnQliAcqZ+e8nR7pLMvIxDEICBuVhlqeGfjaKYNP3a9uv33l8bJlsGplvysdTRSOMBLgU27Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+WLnTKxYMfUSfwakZUHEOZpe9hoyWhN8Y9vo0UL7g8I=;
 b=BJOmi5bkpfz8syT/qH0yb9va66YvsuziQwfLYt28mAtdWOdsgag6BsFXxN88/hrJ+dZtXYauUiS8RJq4NTH16npYpHOnD3Cm7kbQSCdZ/L7noQfuGcBDoyGMebUWGcZMFeQlEl9PX+f9tTW1nEcGxC9tcB9G4Ti6ZRO2UMtAf41smtmICWyTOW62QobCuo2ePT4s2IN2Ji5Ea4E6QIAzzNcPeU/Y+OTZzvNxw5BSDKEADIKBPMobjtinuBlGjpl5B1lU7wBsSPSD4qJLoEhY922nd90wZzEodrrbZ1Sea6nRmoGlSgLcTd+X08tJTAm89vBYtPB9DKBbO+7cJCzbBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WLnTKxYMfUSfwakZUHEOZpe9hoyWhN8Y9vo0UL7g8I=;
 b=nFqXPGt4Zg4IW57SbnqahaMGzGCFwS66N0nl8GTbv4S32XyOYTYnqdagYGNg+8zVjeWG6SgJJL6YUoLN/mrt8afPNDgVUXk0JkLu2zz+jXYz2R8+K1anaod/Ip2JV6kyWZmQMkhrhALD/oAhq4ydEmzhy7wtQlAj90uRPI0JMPLHwHdW+xneQw6rPibx4SaB8e91XWuQIhO+7/GciAgctJ1kwYflbi/fjOVHfU8yK13/lDgbbCSyKPkyvFThpunM0BY0QwQ+qoSNumZO0eU26ZRCII+VuBdeXRlyTiYwZAeHW2h1ANKOqupp9cFIjSeNvdqrXkQ7UAnvesUB5bHfvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB7950.namprd12.prod.outlook.com (2603:10b6:806:31c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Mon, 27 Feb
 2023 18:46:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:46:48 +0000
Date:   Mon, 27 Feb 2023 14:46:47 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 02/19] vfio: Refine vfio file kAPIs for KVM
Message-ID: <Y/z6lwd0CuT3+yG3@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-3-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:208:23a::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: cd35927c-2e67-4951-f472-08db18f2fb9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WYV7+7L+KBYStNqYxaHmaz/SUGb8/kQzv/ryfkiQtImyVmRYobSnFaS2wRqdkY+0wKX/igiA9rOrtAJlLo7SFEwvE6WEjQMLNZxbPvQd8SCyW81RjsMYpt+8FObL66TKtPXKdmV35NVzvy+J1Vt3LZs688nHxY0eSBxOdH/C1T9y0JDW1kQjhe7X3ujnxmHOaJQq4sO9QoWDmuDe0lmMXQiInKUUMM11tFQ1QwDxW1z41pDCl4XPsOj2rR8EqktF6UNMa6J/YQcvuekeLq/pxFZuFk273shHszYYRP3mTT2CP8O0l/3Kv6fC3FJ8SDSOaLXFzt9SuU8QtT+Ew7oyf+t8gtVXjXwAG/97zsqiioMxv5K7NyMSTEFmecnyDb2FbSOnaGVpmDjLtRx5UHi7oJuhykRAjIs006ht9Hf8a9tgL7O0E//wovt/D7DZWqZ65Vcxd8JSZdvuJnshpYG6kzBa9QLcNlapxtRFIShNvjzxSKW6mUetNCY5KpxzXfmE2qfAvWfFj1LNK9dTp2RldZad9iHXmt/430obnL2C0wqvabWyLZW9IEg0IiRMAR3c3qzrLPdIoEfxQ7QXoepExN4ARG7ScEt8SU7KKg7Xn/Ygh0EJBOBXJ5LDB1lm6TAfg04G5gYVw/6130oxgQouDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199018)(6486002)(316002)(7416002)(8936002)(5660300002)(66556008)(6506007)(478600001)(6916009)(26005)(186003)(2616005)(6512007)(2906002)(38100700002)(41300700001)(8676002)(86362001)(83380400001)(36756003)(4326008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AbKFMR6mxPmk4cWyZKLvbc46MZ6O2C1CBlp81u82guw+f//kCTa4bkzQmeaa?=
 =?us-ascii?Q?Iz/ypZOmyh3ZBWXiB9CjnmXVv68nnfjNzDG7zdj+SXbuCwtkGO4YDhfOFXdV?=
 =?us-ascii?Q?3EBhhvPOcfZSt/uaDXzrU2LU2INIIJ6w7WW5J2raLxSxnRRi1UQTHU81VBNi?=
 =?us-ascii?Q?Ngaq1YJf1K4p07GtX0DFBIgnSRyS+V3DvwZ9h3Vn0t8jKXlaZrh8iF2SV8xr?=
 =?us-ascii?Q?P7ITM2poIdn0LEIDhUflPmmbMNscd5QSepTKuwy+SyCmoxloQSeELKpmnZq9?=
 =?us-ascii?Q?/9e6w1eOBPkmjsdY/gongHI7xWjKsTvAUh22PLYxtbw/0jlzgHXAF4FqHiOY?=
 =?us-ascii?Q?BiW3Pz851aJEGGVK/7ifrQToa0djqQ2tgv1QRGn+lRdlRgH46pgLlSYDBxCr?=
 =?us-ascii?Q?zN3UVbEyN/Ge5JwI1V+QLRfDb6u3AdyPmyUVAxGCx3pPYwnJxp5ATIJwACjE?=
 =?us-ascii?Q?E2pq94F7WK2TXau+FntnJaQUE4hhmLK9FWbbrPycttXuOQ0pCCLGN9zVLi3Z?=
 =?us-ascii?Q?mq1mhL//D7zTpyyYmkx0hGXEV/EhZglG7a+kcEt/BvPRX+2yDQwETmCUcX3w?=
 =?us-ascii?Q?JdPKOKSeiRS/SHlHgyugFJXb/5OK9l8SsET4GWdtLvngUe1m/etH+HbqKm/d?=
 =?us-ascii?Q?vkLk3oliTVvtZGhmjcpbEsxw3cQF2Gvrcwavka/AhaKf29fG1aEtcFVMLI6J?=
 =?us-ascii?Q?1qss/K9/XTE1qzVs51Z6Ww01WAM90bKNMzCW1Gj/+3ZS03l27+H3JATGmQek?=
 =?us-ascii?Q?5x9ilghvLlduV1t7e5JxWuVGDyWXYGh4zVB3QxqZKBju4mh0gRY3EyKqokRu?=
 =?us-ascii?Q?3+xu+echP9zb0jtJNwPGBwEmC9evVzruIIrtumcPqPsNdqCBnjdt5wzGOmSR?=
 =?us-ascii?Q?TOje1VUvp+OaK5g9zJNjQyGutLC28wgLut005j0XbLR3PIkKJQmgXL/47o6L?=
 =?us-ascii?Q?i+nyDLs+sDNFV9TfC2YbC0sdh9q+8+J7fcUNfv7QofgzXEIuf6CcwzzPevOE?=
 =?us-ascii?Q?QrRgYsIokkJV1fy3qZkftah+Q3CUGbnKeeI9ht0wJaPWJJxuKLL+i16QPH3l?=
 =?us-ascii?Q?peTKxs0PujPVmdY2R0xm8Bt65FmjI/qyGsCRfncty9FaczgS6XY3HskVXgjz?=
 =?us-ascii?Q?aviIKJFR2Ho9iTNW2LZM1PBiQBgMzJQuX1WsVxy8+JA6oIdXlYz/4coBH9Kv?=
 =?us-ascii?Q?xCXdL/5h/KDqZf5n861l22MxjG7IQLrWhEAJ2Az6mL2gsRmMZenOS5sEr7EG?=
 =?us-ascii?Q?UyLJJnaqY4LzQAIyBwHGBOhVd9scnJo+RmPdwFvrlRkZliv1cy9WxYQFgzb6?=
 =?us-ascii?Q?LGCwJWnFXDLvT9Ms1qu1XV/EigEflbgtGZCC5GSOPXgHWQ+l/6j3KAkCJkMh?=
 =?us-ascii?Q?sTB8oHZjI30SRj+sP3nd0fl2GI7H9+C8vHZ1lBcC64D5JHMMI/ps1IVkbqPJ?=
 =?us-ascii?Q?SkcmcAtxGfMXzbVcpniqPT5qEFn2S41Ja1DuyblwpA0ZWkjX5mmqLmn7A/6r?=
 =?us-ascii?Q?WxR61uoZ/M61IT77RBn0O7BEujL8rtJ3HbZ4Llb+HqTiF4k0BxAEtkAU/i8I?=
 =?us-ascii?Q?HyPH1sVNOhHl3iuLtylE1FfJvmDEMNO/iqzM0Hnw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd35927c-2e67-4951-f472-08db18f2fb9d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:46:48.7204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2lQst/QP2llHNr0YMIok5EoCciUTYV2hHsaW7Obt00QDn0LaU0zP72oycT5UBp6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7950
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:18AM -0800, Yi Liu wrote:
> This prepares for making the below kAPIs to accept both group file
> and device file instead of only vfio group file.
> 
>   bool vfio_file_enforced_coherent(struct file *file);
>   void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> 
> Besides the above change, vfio_file_is_valid() is added to check if a
> given file is a valid vfio file. It would be extended to check both
> vfio group file and vfio device file later.
> 
> vfio_file_is_group() is kept to for the VFIO PCI hot reset path.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vfio/group.c     | 57 +++++++++++++++-------------------------
>  drivers/vfio/vfio.h      |  3 +++
>  drivers/vfio/vfio_main.c | 45 +++++++++++++++++++++++++++++++
>  include/linux/vfio.h     |  1 +
>  virt/kvm/vfio.c          | 10 +++----
>  5 files changed, 75 insertions(+), 41 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
