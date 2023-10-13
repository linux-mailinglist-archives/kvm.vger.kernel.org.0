Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243BF7C89A0
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbjJMQDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbjJMQDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:03:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61D1BB
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:03:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0lvq+FSrsLI8qoHy+/6mozbuZ0MlwcTahPFTuGqqazHVktxOsJXcTZoLAYMbiovaLSe5N8oV4kW4IEz764t2kp21vEIGndy2zx1U9muuqkAFc2/xsVoZFA7UmSIOz6qCgN9U70EwdSfYJ/emdDO3n9W14BVJFaw1XLr6WaAxS2d3G/ee2Gpby3UYaEtbT3GMpoZ3Q6hHV45Ru4awL8tcGxR5VGHf65H4lAPi0G08GitXqQb5h7YoTzgFcKwcbqfzZq6CfwtrHJ2XNNRr8YYjw1DDWsKoWlmATUnelNh8zY/DXdyuBVPpaYFIHIuvL1Ebyrh+FW3G+7Y4F2zaii5Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OlrjfnUQ+WC++iL5/mvt0+XpsqnSgdvwjtLyeKLGB1Y=;
 b=QCsuG3+gtpTGKmaCdWfqeLW8V5utvO52c1LAKPFDwf7DjWZEe5wABh0AL9G3UmaFkK2dQx7nI6zpK31P7dtka2rxeAxXK8zA5WBozJ4I7FAf+MKLMQ+fYQe7zt+LW2mfV8qAD4oN3jr4XOl5N5hG13SmXC0ZvVt5DD8Lk7yPU5dHuGjUf/2e69dvG7I6mZDYAfeGiAZ54GuKFYRALNLmmmR8kFMAMVVajbFQm/0CCeAIEvyR51q1OgnICA4PabxBapMbvxXMTqdkHAA+WYzEbMkC+RkqBclHSyz9b1RtgTKhWJ1rEkKQkYQ5j6NkZXInbdeLIuc9rbwFHzItSbgE7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OlrjfnUQ+WC++iL5/mvt0+XpsqnSgdvwjtLyeKLGB1Y=;
 b=pIWR/oZRG0FsGiQ4TYjTpfjfObFScyAO05RoHn9SzAzjYjIUyV3THcxSUUvp6CtSBYuBgAAPoXkeywH5tVmCnaylKnFY3/c6wHD28MYWP8pGSuqkKWNBj6WdOAdIfF/OGwjbduBpEb+VcLmtDANO48o3QoTGoHWODoJEOE42Tzh7ibsTBk82cP9va/juUzQfatrQS0YoRIs1KTSOxkJrxkJ1w0gXh3H7F0a+7sapb7HXMgbUjj4NVzEHNZy44V4Smgz15j8uCR6+/QA3ptu497onAC2M1F74EOVBdee6Xd0/cbVPDvWCL7bIxZnfwBuGFNnt5s5wypGUgA7hIgn2Ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB8430.namprd12.prod.outlook.com (2603:10b6:510:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Fri, 13 Oct
 2023 16:03:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 16:03:17 +0000
Date:   Fri, 13 Oct 2023 13:03:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 01/19] vfio/iova_bitmap: Export more API symbols
Message-ID: <20231013160315.GA3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-2-joao.m.martins@oracle.com>
 <20231013154349.GW3952@nvidia.com>
 <8d141f1d-bb60-4413-b85b-8e952cceef78@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d141f1d-bb60-4413-b85b-8e952cceef78@oracle.com>
X-ClientProxiedBy: BL1P221CA0017.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB8430:EE_
X-MS-Office365-Filtering-Correlation-Id: 194d9acb-d9e2-4908-a07e-08dbcc05ea00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 33n7Ri1nJGByVMrdLplLdQAGfFj9S9NKbcVGHX4WOo3MweHbFSqcX+Sr7KBQgRWMX/Ko5+bxPiE0eYBFMtkA0K4ik7Ul9qCdxxaO2x8tCxtIx7jpnoy2XqP1ebkRDZeeGeX3LtwknMpEYHPcUeABC2OrWqpBeibQ8wZcr8KcChp0fhQkOWUvf3ZxmiZC+B4BWUvd3iclaNiDwPrLFqEvsIyimyTthTlD9V946+xRbmaROMmJ4jOlFCEdmT4RBJHevDPjiLtIaADtl+GGJ5YppLQU0lfkYyf3cDNA83eLiKPuUu9s88rSIf1CmGyvJAwjgrhKY1CImcwE7qr2WLqbX1qQ4KUNyAzuhWSJNFtby7LYZ1jucceat91jeWdNzUPTxknVageDCIUEq67w6xxW8dbLIe6czKLwHv05yjw4UyjR4UW0bboqfvmEt05J2mdh7CI2Deqlv1p6pa2xQljaCZdhHtpkgYO4FA8pJqJZHIFNJqzx8MpWdePmQUaA+/jEiY+QR4S2hKYiJ2NNnuVUFwVmcH8wVQXcrTfVN3JUbvtBYh1EuGwNaaHlLd/wbnPi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(396003)(136003)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(53546011)(6512007)(6506007)(1076003)(33656002)(26005)(2616005)(36756003)(86362001)(478600001)(8676002)(4326008)(8936002)(5660300002)(316002)(83380400001)(66476007)(66556008)(66946007)(6916009)(54906003)(41300700001)(6486002)(38100700002)(2906002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0x5qo+H0a2j2bsgOWSiyNxo0iRGzNOuddM20lzQKExaDNXbnuYR1EA/1lPOe?=
 =?us-ascii?Q?cIs7kAhaV8MbZIhoT9GZ07DHC8jNESOaIeGA5JN9DKeHtXJV6KhXMJaMsAhH?=
 =?us-ascii?Q?1yRjosY5/NQD5cXLR4EOIfdcIExHXVwp5peFB49ba6SjM2Q3w/asmkRz5KRa?=
 =?us-ascii?Q?dOjGOfzbRt0xHElRTmBOcZv6mN22hFyhgKNLC8Y36hvlKgETpjAuznE1Vpl+?=
 =?us-ascii?Q?ksPZh6jop/zcxyScv+IoZf/VDurUFQNyH2+8ceJkLggOBfH8z1HhLWaptFER?=
 =?us-ascii?Q?KbikkXaXcJ4epSnjc56TlCRzco7mIV/rv1Dh+6x1ppXPlz0j6BZLAn4dsKcK?=
 =?us-ascii?Q?EJrQdz6vsVTv08sDUb3/yN5ERFalTRJk78a82AEko8/y69uE2a++u400D9cN?=
 =?us-ascii?Q?YSFpucV/A+WIFKPlgcDsk+xGvffc86O9X1SV24FSKpiRV0ufHueJDQEk6w8c?=
 =?us-ascii?Q?KmT+jpyKCcJRliFl1ACy+m7+rcSOwtKOS9YfZwvLax5jDh1v19uTUTKDVyBL?=
 =?us-ascii?Q?lUFiH51Kp0t+A70z4kyZHHbDlOM8eyxiSHzntZzCCWstKQav9Bt9kswwqhka?=
 =?us-ascii?Q?+a+dj9eZUf+pD2KwaR4OcTex84tMM8GJfbvFfjb3najLgYdqWm5SZLrFtA3d?=
 =?us-ascii?Q?i4tAHeJ/WEYamSsZvpjwAC6C+y8zDRG/lRy93AkosEojiIuOXQOVEGkwRcoy?=
 =?us-ascii?Q?0WlUIZYIUolceNVMAWCEP4kCWh3whG3wxLa2SDMnSEf93xqRcSV0aE5yd/ol?=
 =?us-ascii?Q?r6ftMEvctytpw2pbZNIieHPObffEsyjJte2BAltsjmjInRPH7Hf6tTL1DZIj?=
 =?us-ascii?Q?wd43bNtd2YOwDq9T8In0QCdsD7PbaaU/KdJhebzt/gMm4KGjgXaabSzWmgcr?=
 =?us-ascii?Q?owpFzw18Or6w1cvzi0eZHxMtrAFGMcgcRSZTIUV7Q0Xlg/ufoW2QlXXjwI3u?=
 =?us-ascii?Q?mEwG5VHT9BkZZ+JA7gkKRTv3TcmFMeSCTWkWf2B/ALz5jYVLlxZ5s+kuYwNa?=
 =?us-ascii?Q?vzvKWjVjvnAsnhsvUUij3mZZkij1X/bIWSFzNQ1qWHCMmqPA3Rp4ChKbIV1I?=
 =?us-ascii?Q?y8bS57PMdn4lopmRPcriWqpZD2t1Zu+gEk3llzH7SO/1NMZM+17N06gL/oDq?=
 =?us-ascii?Q?mNWWj/IwunisdNNlm95nCMNHvdXeuRPr+B8r33qHDnb0jfJ8/Q+OFMLMEIAs?=
 =?us-ascii?Q?5eFidCF3P5+iMWg88DbH80IsddB6+KlPM9WmwC+vot9Shq0PVHpqVdHQMv0T?=
 =?us-ascii?Q?py0xOitpCj5/AZKkrdhypV7NBesbzu6DIoHFbdWnV/AuldMFWSqdq0dvLtjJ?=
 =?us-ascii?Q?xzXs/D2Ekrbuur//VBxORKXMcJrPVdF1mgJfjU3zVYYhA8ZB6MIAlDiep2wj?=
 =?us-ascii?Q?KcjVih+am8Ios25bHUmHj4uaVqyrAhJJmr4+2BZ8nZRMsGyFH9ebt+KM/9EB?=
 =?us-ascii?Q?mmUzDMPDvnhcextNgYTHK47Ye4E4nfq2R4TPQDtgkR/A+eh4zXRKsCsczU2J?=
 =?us-ascii?Q?KTHwX5v8vS3d6LDtBb0BnaWHfRk3xsep9Bukn30tZOUyFuegy7vhwDsfa8dv?=
 =?us-ascii?Q?g0/tbmffRHSlIs85yPhZyUDetd39O7JP8CEa8pRk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 194d9acb-d9e2-4908-a07e-08dbcc05ea00
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:03:17.6725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EU4EI+eOn49BvQPHBPIdHOMjMTRhvfRqTn4q6vZ/KSOYwH40FO8/r96qt90qVv1j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 04:57:53PM +0100, Joao Martins wrote:
> On 13/10/2023 16:43, Jason Gunthorpe wrote:
> > On Sat, Sep 23, 2023 at 02:24:53AM +0100, Joao Martins wrote:
> >> In preparation to move iova_bitmap into iommufd, export the rest of API
> >> symbols that will be used in what could be used by modules, namely:
> >>
> >> 	iova_bitmap_alloc
> >> 	iova_bitmap_free
> >> 	iova_bitmap_for_each
> >>
> >> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> >> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> >> ---
> >>  drivers/vfio/iova_bitmap.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> > 
> > All iommufd symbols should be exported more like:
> > 
> > drivers/iommu/iommufd/device.c:EXPORT_SYMBOL_NS_GPL(iommufd_device_replace, IOMMUFD);
> > 
> > Including these. So please fix them all here too
> 
> OK, Provided your comment on the next patch to move this into IOMMUFD.
> 
> The IOMMU core didn't exported symbols that way, so I adhered to the style in-use.

Well, this commit message says "move iova_bitmap into iommufd" :)

Jason
