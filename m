Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FA6517768
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 21:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356497AbiEBT3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 15:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238991AbiEBT3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 15:29:14 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627C1108
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 12:25:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H02GWqMgyGBXtVHT5xVXGZcaqK7hWClhT0SJHdDsc0crR7mCSEi+qluH0gLHZTs+hMwx35+UGLJKQdWpot+oUQ/Mp/hbhezeMJifIDhfYwQyRbJFxJqeId/xoC9InV9i+aOwybn1CmlH2v6pkcm5ZZO0CZVR987TiNEmGPt9MVN1saqlUIuadd5oSlu5EevLn1v00yZhOrAtSDo26cJhzbzlkHfImRwajgUkuoD0wAcaVPvsBFzqkI1wUnMa7pN/96FQQKkEGvTD1fOyyrqJD+rQ1PIzo5JJ9FHylkZzGTz37ihakx3SasJFWEHcINaNdmxgaEvUSWFVpau5wKxM6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IvLowyzvv4ifKQoBQNdDaw3Y/kB4N/iWSzRcrZWVvQ=;
 b=YaDl2FfUWWWQ8Ciyp9saqT/9hNDoikTx09EaUwOONS3WjDR34p3cLQUmn4ReV3n8h8Rw0EAkmgQ7JSLq9PLa5K8eLsM6YTBingZWhF/bB6GiSZ+1HAK2I7WkHil8+Em0wlvwhMbwhBxVZVCrYF1vndoqAuIBb0hVaHu9KZFweKYEdwdR6FkTuKQttl1ZDxD+j3+NQAxseY7Z+uf4nEy2BAD+28XfTL9URILFmmOuVIDaYE4GGRIm6uM1uDPu4lyYdfTQtJ+iJIHdCc3HXTv+Wgsn0zPV8SN1HSl5C4G4J6AOhVCxDHsWUEhiA+m3SsTfhW8Rxz0a9r/X6OxDFviq2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IvLowyzvv4ifKQoBQNdDaw3Y/kB4N/iWSzRcrZWVvQ=;
 b=kjCVYK/iErZ6Jok3flmux14ekV1e7m+UlKAjoPCtCxQdQ3w6l68SEC4RipdoamuHnlaXgzB+UtvlKeLMWrmRDYSG1vxVxaSiLUXyKaudtlR47wCNVxp0F5o1dwdfefJHYtidpbsmZfxKwpvPiaQvAsUUWWDUr1pNgWG8c5Hr9VrN6Lj3xzbY7vRYXK5+LiK3ThbRXnpDJRBD5GbYtqw3bLIFF8IYYRdCjbRQbmWZ66PHzvfd+Trm3bZzhNRhLANMHDZ0rtI6x7s2Ez6E7Xha1icUG3tQOl20vjkGKKsyslCHWHFcvftzUmuljtQBkg+Cs2otYP/uyJVnug0VKlxXxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4907.namprd12.prod.outlook.com (2603:10b6:610:68::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 2 May
 2022 19:25:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 19:25:42 +0000
Date:   Mon, 2 May 2022 16:25:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, cohuck@redhat.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        eric.auger@redhat.com
Subject: Re: [PATCH RFC] vfio: Introduce DMA logging uAPIs for VFIO device
Message-ID: <20220502192541.GS8364@nvidia.com>
References: <20220501123301.127279-1-yishaih@nvidia.com>
 <20220502130701.62e10b00.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502130701.62e10b00.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0258.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 394b7a4a-7ca2-4114-c90f-08da2c718c70
X-MS-TrafficTypeDiagnostic: CH2PR12MB4907:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB49073B9043F0591B931CD869C2C19@CH2PR12MB4907.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KBDJmGTAFTbpJaxG881088wC8U+YIY5jySygcJhJTJQ/M0msoBspW9jCXuD94M8eGflM+jXpqgWFkMF0iHSZKuP+fnqulPLWs5zW9kqUEQPhjYptN69cl1K2wdEQU9s2BQxpyYpSSAcEKs93DU3LQ17shZbseVTkqsybw88AAu1AjUHt3ifF0nVfh52EMvfeTrE9H08VYvLWERQDcoTWVf6XDU9mfZQo1B+1Alfgoz5KjI0ICxEGs91VcQbI38km8+Od0JVfKC9dWegGoJwzt8pXhCMvymfzThNzOOZ3YAoMHEByTCWN37EGr0LlNB1q4hBvrG5Dsq2IcthbpGG0gVfLXceNu7Qsd6LwtZqnZePOflhCRB12wxSFklhIsk1h2uLFwYdOmjDXu5YAQ5RLkGvr1JWFjqsZbjSvF4Kdldz1aGFjCXP+6Lo8y7Yv2oP5nCz48C8k0N8NoMTjYLAP7Jm12oou9IHM4+FxEqOFykUf7rr/yjUnQU1LbxtiB0dKaULhc9oznuNBwsIchdjK3Fezu79naWZuEhe5RigKFb9nEQoj/0sjM5O0VZVrHdxjduP3Xw3+Iy0P2FO4ngFOzgVHHea5JwUqoa+7NXL4qUC9U/lRBlik60uVQoi8Ah3ZtKjG3qluIeuTqGGqDL1XuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6486002)(8936002)(508600001)(86362001)(2616005)(26005)(6512007)(2906002)(186003)(6506007)(1076003)(33656002)(4326008)(8676002)(38100700002)(66556008)(66946007)(66476007)(6916009)(316002)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Li84PjmxWILJx5/WBCi2BB8PeYo3LYellApH+LmvBgjZJIPpP+YwgcYPctzu?=
 =?us-ascii?Q?cVD6+SfLwnnWJzxwz7vYesEn8TbeaBppnoLzFqIy9eeP+DU/xhqXT094QJZZ?=
 =?us-ascii?Q?FS03Qj52R0STig83+BFLBdlT+AfEJgDLOOSYHh4dv1+Hv1pbRYTxo/mBQHeV?=
 =?us-ascii?Q?AiZ6kTOAfZeY/ULYZdsuQ0kLFssAoxTeFD0yPvGotnKyaDh4B7IaXVwHC6CA?=
 =?us-ascii?Q?Cta8orB/8Yy6siWuc1L+TV+6ijRUIw1tYDvL+cymlXifpO+BccSzfNt82lfm?=
 =?us-ascii?Q?8F5y1YZORxd/JSsOeGwqV01K5fUSdIuX6D3lGJxOC+Heibw5Xv+NzwEKyuJH?=
 =?us-ascii?Q?4FsRgT2V+sN+PeOC8Ele+JcPrHs5CwHNhh/Kt/XjTKqeXeJBApkUyRFi54s+?=
 =?us-ascii?Q?7s/dKYr84bvQxirvxSP019LAsAR0WmFJ/7EkX/8NoHJe/McBDwbTs3HMjqdF?=
 =?us-ascii?Q?U/zpXxBZUkEttN7wjzkZ68LhBO9SCeUlqjmimvu06QaK/f5PY5GT2Zt6u4rr?=
 =?us-ascii?Q?V5c4ZmxZAiG4Eg+F3iS34vip8LMV1u9qcf4Via3oMj4dlbIGEiqZ3Eedj+6V?=
 =?us-ascii?Q?gO+JQ1tVGne/sIgYwGmrOkI30YuRmPLYm1cIjeEzBUpzmEKDCyMQMfayX6pO?=
 =?us-ascii?Q?qJWwKzUd/zrvhoudQRK7AS4XwkUpOXzOC2QVkUZmtJY7uJBhq7m64hJ2Nh14?=
 =?us-ascii?Q?1fsyADRCAiO6GaL0lOUwU/MGc19qL2C2X9rSD34UEUuwP2pHkukH4MtoM1RJ?=
 =?us-ascii?Q?rIrMJsAvJQTe3L4YCUFiwv29KM62Cul1nC/ES4xZJ5uV8pNSSpHqYnWKZ3zK?=
 =?us-ascii?Q?60nbtDkuHMgBcbtKXTEI/7QLNAgYiZTovLP87+gyiqY7NrpXPp/F5MLia3WM?=
 =?us-ascii?Q?zdhTrMFAxEQXuV1999zvrEGn4PzVwgItYVVMqbMwfdkvd1k1fclm7k7BRCT1?=
 =?us-ascii?Q?46XKs1lDsbzDl5yKgDOpFbKJjHlU/aV+moo/Aj92zkWjp/O2WCWL91UT9WvG?=
 =?us-ascii?Q?B5kAm8q7vwDyDdcPpBUbQkElBnXFXYheP5NWkMUvIQpBTrHGGjnpDOK61Fg+?=
 =?us-ascii?Q?vWdYjJ2nDY4MMymu0WW6XAuSuhq+5zsdwhc5c/kVQIt4LFjL4ZA2WNxDfJDS?=
 =?us-ascii?Q?WhArwGwQviqsAY7fJE/Zy+HQEfI2W9bZK+5mNExvKFdx3IagjV3eMQN7b+xp?=
 =?us-ascii?Q?vcoSrt7lfkJ4A646SuoNxols5hAaK8FNppRPhHKFjwMhPDwIHiJIVWaOI+Z5?=
 =?us-ascii?Q?RDSRjfl6kJU8s3T9ifkhXryt+AThnjZlF6kDk/GMkTp/ULb4RGf7ZIRJSujq?=
 =?us-ascii?Q?E5Mmf5YCYtAyZOB9JiGJTc/iqvZDt6pG8uQHLGRK3YObHPUcrVbvGmeGAq+M?=
 =?us-ascii?Q?S36B7cF2l4Tn8EegRoHDWo45p82EkLrp4ccd0LHh9EYYVcgdYWSSZ4IxNkIk?=
 =?us-ascii?Q?AJ66BTt4MFrzZKDEVZGeDF1SOvRD1WKAVb8ESYXHLaPZ6CALmAVF45crSmfz?=
 =?us-ascii?Q?9wXmyXn7qA1GNhNSuY73zTg98p7pUsWLMgHo+6vom2GbJpASVyRYJ3djI9yt?=
 =?us-ascii?Q?1On6ATaDcIoIQv7kGLrcN9x+voNB4UcGowcry+uWdodePW8dADPn1/uWGJSY?=
 =?us-ascii?Q?N0QTGt6kvetdF+OMKzOvA2MOSDfGdHCvJsWHix3UA9WbRaD60gidF0Vl6xfA?=
 =?us-ascii?Q?U6+sHRPcAWYqNIeVguuN1GmJETWQdEdQW+zhQsmtl4A8IC5hkAeJ+p8P9QOW?=
 =?us-ascii?Q?MOw1eoNlSw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394b7a4a-7ca2-4114-c90f-08da2c718c70
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 19:25:42.6880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wuShR4gWuthsYyL3On9xTNyE/WffPI0/SKDON5FSriQXEn21FjN9mNhlvst/l7p6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4907
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 02, 2022 at 01:07:01PM -0600, Alex Williamson wrote:

> > +/*
> > + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
> > + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
> > + */
> > +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4
> 
> This seems difficult to use from a QEMU perspective, where a vfio
> device typically operates on a MemoryListener and we only have
> visibility to one range at a time.  I don't see any indication that
> LOGGING_START is meant to be cumulative such that userspace could
> incrementally add ranges to be watched, nor clearly does LOGGING_STOP
> appear to have any sort of IOVA range granularity.  

Correct, at least mlx5 HW just cannot do a change tracking operation,
so userspace must pre-select some kind of IOVA range to monitor based
on the current VM configuration.

> Is userspace intended to pass the full vCPU physical address range
> here, and if so would a single min/max IOVA be sufficient?  

At least mlx5 doesn't have enough capacity for that. Some reasonable
in-between of the current address space, and maybe a speculative extra
for hot plug.

Multi-range is needed to support some arch cases that have a big
discontinuity in their IOVA space, like PPC for instance.

> I'm not sure how else we could support memory hotplug while this was
> enabled.

Most likely memory hot plug events will have to take a 'everything got
dirty' hit during pre-copy - not much else we can do with this HW.

> How does this work with IOMMU based tracking, I assume that if devices
> share an IOAS we wouldn't be able to exclude devices supporting
> device-level tracking from the IOAS log.

Exclusion is possible, the userspace would have to manually create
iommu_domains and attach devices to them with the idea that only
iommu_domains for devices it wants to track would have dma dirty
tracking turned on.

But I'm not sure it makes much sense, if the iommu will track dirties,
and you have to use it for another devices, then it is unlikely there
will be a performance win to inject a device tracker as well.

In any case the two interfaces are orthogonal, I would not expect
userspace to want to track with both, but if it does everything does
work.

> Is there a bitmap size limit?  

Joao's code doesn't have a limit, it pulls user pages incrementally as
it goes.

I'm expecting VFIO devices to use the same bitmap library as the IOMMU
drivers so we have a consistent reporting.

Jason
