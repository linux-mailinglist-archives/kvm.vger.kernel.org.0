Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6BF62059F
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 02:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiKHBJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 20:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiKHBJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 20:09:06 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2082.outbound.protection.outlook.com [40.107.95.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E22A22539;
        Mon,  7 Nov 2022 17:09:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EA5DHkDQ9sovL4luAp5vgMPHegR7GXm2upbdKIK2ok4CezgosYRgc5xiTuKHZgymQ94KXOIRh5Wf1FUoUTlbfi8tAwY/ui8ukyLDVLfvOkSnQ24TgPKXlve6RfB6aDBpN4TKWc2nlIfxjv6dBwX4RXWfue3rSYuRQkobRyF4egIYghqlzZK+IkRHqYxYwbpZzXqyCbMrTPuUU7qWVii8itPnp9iflS2D3RJzdoRGjQxMZtwZShPWZ3Vv9yfD1TIt++wxf6VvWG8qH5rAfzCyxgXxWyJo1W6pnGIFBVBkDe7yLed9SauI5n+EFZJvLk6Qy9U/R60p7gkajIRjeTJRjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cz+MuQlbUArAQ+CDdk4dg6DbWlkvNMm3Sl/S+XOr/c=;
 b=Dq30tBkFS5fH2PEfD53emJ9hzQk/6MG0LpoWdxh6XXN62Mniqs45fyggS+n3pNoPug6Gvhr2vQz6+4eu+SfqdH3an7DUQ7s7pEVA5WmFaeHmFXjx03PcwGAAzTyAUAyQAQSxn8buqmyf2Tv+Uuu9M1oYhxMqCggzRdc2tv44C/+V5qq49YERwq8Z0fK1UAvn/MuuTIYWVzVoHsbZWe6pB3Q9NXBNR23zRSpwCkRzmBFCcmTaOe/LL7lstpn7pm0V5Ayg2RXUq6toyl4aIaD7xeml7O7oP5vTe/DfKUrKi1URwqSF8gJK3kY0NGtepCac+VYfAy6PdQA7XtcT/EON1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cz+MuQlbUArAQ+CDdk4dg6DbWlkvNMm3Sl/S+XOr/c=;
 b=fmbGjJSwqfUkERawmHrceZCZ34CgmlR/xgGVBV/RdQV+9aGVCxT+zqRjqqbpMA12hpr1w/luKQLX+fM48mZgU5jMVQH9EYvxfLulNjb8WhfwNz0yihu2nXSHt/YksqFfB9a1UBgXswdRbcz09oYtWS5JvAopOqZC6YtV1IqYQGCggMKfmoC4lkzM8Ei3avGnsc8ov9axByY3S/yulFwkckKiksYN4QmHSUrUFlYMy3FCt1Knx/xeU7+kPbZWXdw6+Iqaex2Buhkf/mscu3H6RgW65WuWTpi0FAL3jFCQW+UsROeJx59KoYnJKqGVsdr9eLGtchert2XyBp3NgJ/Qqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 01:09:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 01:09:03 +0000
Date:   Mon, 7 Nov 2022 21:09:02 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: S390 testing for IOMMUFD
Message-ID: <Y2msLjrbvG5XPeNm@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
X-ClientProxiedBy: BL1P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 031d4671-14b7-46d9-931c-08dac125d3d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: njAsIUiCtTw7vuGYoL9QZsfptcCeT9a8wdPzH1aOIid/Iuy6h6L4zRs9gW+5wBt4SveTtFJZfqPk2DamxIViTh9fKU1KTENcj21W0n5XiRO85CsQ57+5BJ7HjH/bbsCihF1LYpEkJ+OIjigVAm9kScxr4tUhUDmMSeR9Elb+hAmK3cozHxz+giLGslfq4O6Ujgq9A2gsH1J4PfMMb16F/RGM86+rxlBxx2L5O9zIasVv3b8UtfJdeHiiP22IPeRFjccUgndr/Vs2khD4lblYDtcH8nCR6mV1N2w8gS8aggGBSDtXDACC54Jm1T6/Pxcqou8jrYJ7F1j9bOXS2UyxeHR6MLJPkjtrbJbXiB7ioerye7fs4inLkcNETjRzQT5cgy5n4uvaIame+v53lzs2yjjRux9fES4SuJZ82dghdX168QdKet+zDZrv8Fdj5SmRdT7l1ZcXtx+sGl6SgHEuF/ZhBfotc5BSMOGILpgXl6C58tKnp4p88o+cBOuMyujxzP7glkKi3t8ojPqYdpXX4ZKy3yCx9l3BiDhtJ2SreC/N2slP6TXBr4sY9p31xy2K1Zl72ICPaEm8RMrMMJRTeE8WDPWwtjUQSm6eKcdjFWknfePYBpKkFWVjv3spy9t0fMw/uzrtSp5G1Xo6WPFeHlPEBc2llD8d+H8yk0fLZsyEwRSPiqK+tqN7N4ulbrxbwDNS1FlcoN35Sd8x0XARIs/sgIz+r0YSjRd05HcHnhHVHKYMZeWxrxGCXsB6PfKvCqFRDFdRHdT1M8P8GVFYUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199015)(36756003)(86362001)(2906002)(7416002)(26005)(107886003)(6506007)(2616005)(186003)(6512007)(83380400001)(66556008)(66476007)(66946007)(54906003)(4326008)(8676002)(110136005)(316002)(478600001)(8936002)(5660300002)(966005)(6486002)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yUE1dT3VriS5Em5M5/rSyT9i9gO4sdVbZI3IZnvGFLN8X6cmbjSeaFvA7H8S?=
 =?us-ascii?Q?4fOyF+VSVrBGz0+anuk4A2lz9/b7CHGXkBsQxlnFfZglcYhJOzOOHS10Oyol?=
 =?us-ascii?Q?N520KIBR6BxrjadIZa/56MXTSvhHjqwMGVQBhkxzTcAtYnjVCsk3ZSNviol1?=
 =?us-ascii?Q?85sJa3gfbbaQhQfNVJrakyPpTNBqma0TiMbLDo2egKWiZnGtrfAH1xuHUf2J?=
 =?us-ascii?Q?i4mjPF+WHjS4KnssP6Fr0o7wOSgoCfLSFQwB1DZMSbQQcU95pSx/vPpO/nT6?=
 =?us-ascii?Q?t+qL59jaHpOr/WFKKmTXPnACSWQv/oDRq0Wxd75sdziZPIZo6pI0CJ4LZjMO?=
 =?us-ascii?Q?gyjuwVaXvBJnDmyszzA8+OuvYcbi5XNOnGjrVDLEh2iW5KBdRYR43+UfMowA?=
 =?us-ascii?Q?5mwnd4Gg9PLZl5DPSUSXHTgPBng6SdNNwLPXXgMxdNSocFv7Ib61fcXGEktk?=
 =?us-ascii?Q?EGDOaZU3MEpBoZt3Ed6FbUcogBRUK6wX3tQEJI7FfL7PGHGj6wrOIdiLHVUu?=
 =?us-ascii?Q?ki3c8iq3elWZck97vYDHmyYcNfkK9pTIQRkxTa3O9zhMu1vyc2I4IOi07aQr?=
 =?us-ascii?Q?NU8Khk6O1qp5exViJ1N7rsggA95wAaQXjdJbu78Ht53yULwu6r8l3vF8l9Xr?=
 =?us-ascii?Q?nVkXNPLDMagUtebQOUjuEADNAha9z4EV72N7HGbaYnl8NkyQUFVkzSjK7Uh+?=
 =?us-ascii?Q?XIeEFllvxTP8zc4TSWJPGLsFzt/TJF0uMjV1zq0FGa/4JZzw0+vwFpJxIcXO?=
 =?us-ascii?Q?WFttIVdOV5Ut24CK9wAsJGdgwoWVaNW/lGO8kK+vvAoAv0DHqG3HSQPx6EPy?=
 =?us-ascii?Q?CNhYT8YnOQcNZ8BUZwbH5h/ZulVS1qGXWt8mShs/S3U498NfMdAI1vGSbKV/?=
 =?us-ascii?Q?EoXMiht+OXw8ShaBn8Gjatou5AJbU91HsRYfePNUwAXYyrOCUi+KQBx2iqS9?=
 =?us-ascii?Q?rY2FOg1BF5X961BIvCnU9NrwxQeFNxSKfIDOJppLujVSNtRw1XMrzBqGwnOu?=
 =?us-ascii?Q?5kokME2Zm2XWEZ1oCz8igFauAewRZeoun6WhFBCAHpzkLTOcKsCeM9nOB4Tl?=
 =?us-ascii?Q?oMgfwZsAanG8k3NC9tgVsTIZZak2lnvUUWwAzqx2o1NMFf3F+AagUcv77dQm?=
 =?us-ascii?Q?zmjKlnyf+9ExdSSAnFyb09HRkRZLQxiGeo1GaIEf4r4ENIcLhQFPd665rDWm?=
 =?us-ascii?Q?/hS11tvFWUwlTC1AOoDrQYAgrG5LOGRUEcQLXNyNvTsCrb+tIHeS5hGR1QO2?=
 =?us-ascii?Q?0eLdzUhUEJr3fiouuKXCfYkCLEQ41IN5RYd/T0ph2IK7ft346sJeLUku7wZI?=
 =?us-ascii?Q?RN7brmDEC73gy089XfxuFdNRrMgSh0IfFp9cS/dI5lpP2L/NHjDP1yvEmKFF?=
 =?us-ascii?Q?pfdgPG25JBvuJ86D3T10Dgx1xQhU1W9iUSjwZrgHt/2pSljLHxet84LkgwSp?=
 =?us-ascii?Q?4hNRdBvislxW/lz2k/lHAB46KfKJbVhgnUwbQ6RR3wiTHTDCo1+LlXK02mNt?=
 =?us-ascii?Q?YOthYQZIE/dkDefb5LGwu0SaKOvtLZ5rMouVp5WHJB160tjbIalH0Pvu654z?=
 =?us-ascii?Q?KqKg0khapkDOn3mF4SA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 031d4671-14b7-46d9-931c-08dac125d3d2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 01:09:03.9339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: icMN0k3U8rSZ8NxLvO25ocK28rxVPHRcSel4ZFk1voM+QtJ0CgPjZVmrupwMtUae
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 08:48:53PM -0400, Jason Gunthorpe wrote:
> [
> This has been in linux-next for a little while now, and we've completed
> the syzkaller run. 1300 hours of CPU time have been invested since the
> last report with no improvement in coverage or new detections. syzkaller
> coverage reached 69%(75%), and review of the misses show substantial
> amounts are WARN_ON's and other debugging which are not expected to be
> covered.
> ]
> 
> iommufd is the user API to control the IOMMU subsystem as it relates to
> managing IO page tables that point at user space memory.

[chop cc list]

s390 mdev maintainers,

Can I ask your help to test this with the two S390 mdev drivers? Now
that gvt is passing and we've covered alot of the QA ground it is a
good time to run it.

Take the branch from here:

https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next

And build the kernel with 

CONFIG_VFIO_CONTAINER=n
CONFIG_IOMMUFD=y
CONFIG_IOMMUFD_VFIO_CONTAINER=y

And your existing stuff should work with iommufd providing the iommu
support to vfio. There will be a dmesg confirming this.

Let me know if there are any problems!

If I recall there was some desire from the S390 platform team to start
building on iommufd to create some vIOMMU acceleration for S390
guests, this is a necessary first step.

Thanks,
Jason
