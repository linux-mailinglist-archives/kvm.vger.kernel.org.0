Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9FF4DA113
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 18:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350538AbiCOR1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 13:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347737AbiCOR1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 13:27:11 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2049.outbound.protection.outlook.com [40.107.102.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7704E48E76;
        Tue, 15 Mar 2022 10:25:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1VY1PFqvfmePSMtABF1F0d8J4qTxVgbx/I1IxIuMzMmpeyJam2CsQmIwxjMOda0f22QcVp7BfqAxCqzl2rd5Vn0jU9jv6t703F66Z/cXJiDPE99iy35HjN0KBaRFdipRFb3bOz1ZUUmBttkVA2bLA0TwbaviUZknWBNsIIJ5QXnM6rrc5Obl+koRPkuXIhKYILQBn+ayoP+5Foa3pwrF0V1EFofd1WuDceY1BCLNuGEcWXh0kCBaAvTygVnbjxKessFDwASiw8r7s8SLjjDxUWG3MdPEIOGSdPIGr4lz/Y+PiC/xVRROsOW2lHZyP5/Evb7PdQZM/SQaYmnMx4cCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sD/GoZ72/ZnM2A/Kv/wtfJ2qMBMjMAPpav3LwQBLnY=;
 b=QrGrBBYsmQmMn5BE13GxX/B6/tWnPm/DtGXDw/eTLOBgCYRGEQf1DldLgITOt6oWsWqo8Yo75La/pP78mR5t3mjtFg9Vw9ycnGVr+cG0VTAp+eAxVh1ol+huIdlwDCg90XDQnQy2JzwrDb9osdXE8+ysxmp8NAnfG8RAODKMG1W7vBz8WIrOxcT+4WPW5pb+22v4nt5OtwJCumGQBKBkQ5U2cZMIS69tyi8rxFFquq2L0d8eUADsnzLmbwQqUd6JthGdUAhASCRLZ0KkoKF9xW0Yq+fX9C6VdPXyy/08smdVvBIDTD+/OifGihyFTrq8M0yIG+dZTLq6+8OvacE4gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sD/GoZ72/ZnM2A/Kv/wtfJ2qMBMjMAPpav3LwQBLnY=;
 b=bmJlwkqYmMP6eQtqu/JJmaMSMMvTHVBdRZrWE9NcGCweOwaQ8Y/QRQm8Agz0CXQ9RM8j0NvSTu7OMp/LjTT6Glr4eMy7GusmBt0he57TXEew/HDNjRgwGmJQkQR0RJg0t1U8NlYOr8OTT3Ecn/2oWLWKnG2UC5cT3AkeNjPJAfviVCo4i/vdBuqSQ003Gu4f3RHa4rSnotOd/TrVqIuiLqv9lw8S+r2A3QRE49sb8UvRBNiWwTYasewpDkfWKirLRVSH8Udga5IQ+RUSOPcbZNQ3pZNNlIyuqsNVLuPkG23vpS1rVWbEwDbGUsjbz0QC/+ifB7QBS8KFItr7EqTMHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5284.namprd12.prod.outlook.com (2603:10b6:610:d7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 17:25:56 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 17:25:56 +0000
Date:   Tue, 15 Mar 2022 14:25:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, linux-s390@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Message-ID: <20220315172555.GJ11336@nvidia.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
 <20220314213808.GI11336@nvidia.com>
 <decc5320-eb3e-af25-fd2b-77fabe56a897@linux.ibm.com>
 <20220315143858.GY11336@nvidia.com>
 <5a1c64ac-df10-fb66-ad6d-39adf786f32b@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a1c64ac-df10-fb66-ad6d-39adf786f32b@linux.ibm.com>
X-ClientProxiedBy: MN2PR12CA0015.namprd12.prod.outlook.com
 (2603:10b6:208:a8::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38380756-126a-475e-be57-08da06a8dd4d
X-MS-TrafficTypeDiagnostic: CH0PR12MB5284:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5284739B9C78681D452C9742C2109@CH0PR12MB5284.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7EzpcgluRaqtHHawZcZRM2eE590G2RbSuMFelOw0ZhRMWNUT0DhHUgqHW4MiL+Zez9gTFphn4gI7buLt1k+Idr+NsNFTanHYHWl5eDWpSXHf2IejdY898IUMZVz2onVP24mls7GpODTQZWZqEJK8X1vbZwb7hyq67wvpdT6+lzSBV90KEtkZ20B7G2ayFV4WiaNNJqDTo1bTgzHFZNQWS485brz/yh1xVjVrhFRb5IxqJ1B6wBK3yx41kJMCH+BtBVY3DeIED+i27JXv64oN0XmsV7FlNfIsSv2GxmnhHuwz3Tp0mziw7rHvHIoY0oI029iBvIW5aM73qqTIRa/DJ7y2cijqtfjBgE25a3BPnBtsTsYP1Sl7fjld/e7OPSZpXV3R2RJNfD4eVqFMfkMGKnCe2EEVNtobhTjwyXES/C1qZ8ArpF9FzHZpSknmNTfzPBUPpNtctytFBe3PZeY84TstNTxcfAoSz2Fj5b0lTms+xIiEuUCv8flMv19i3Sx1yIi3xK0SEoqASit2IO4F19ZPPmblJr2Qh8785K2KaHj107Ko/ehT+2K5gXdqHF12ViKVdQH0ZpYde9ca2wrw9sVT9z9nuj2g0EbEJf4GNj8lCGC0po2xYHtxhZOwp/MqHKVjj74I2LEkTHc2AECeRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6512007)(7416002)(2616005)(1076003)(38100700002)(8936002)(508600001)(6486002)(26005)(186003)(316002)(66476007)(2906002)(36756003)(6916009)(83380400001)(66946007)(66556008)(8676002)(53546011)(6506007)(86362001)(33656002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dsh7QNNDlNAjPpA8vhHu+/NjThhA5gt3ikpyIRtjMHgIAflb3rakpdntidkm?=
 =?us-ascii?Q?/vqmJj97NwFDMKUzJEKdpFp7lvkGfjZhnEYtomxv8pxgFXhyj/PE3YDQrQGr?=
 =?us-ascii?Q?u7PPq3l9koCCvdQRo2jgdeKioqvulFaysQICWXXkWt4FCX+u7l4zFwTWlDVQ?=
 =?us-ascii?Q?fs0PWsMloEaKAhj9gzFg3yg+YDD/7htedtHaI0OB2pESJ6j42cG8vVruZcNH?=
 =?us-ascii?Q?oMvIj8gM4rd8Xa5CTZBgAhvajT6XoMOcPBr/Z2ZOTXJ/eCDl9T4ifJdTExff?=
 =?us-ascii?Q?aGpXsh2mB9d95RxpZd0r9Ve0pltTFY9v6X8BOG/L3CZN79y0newGJ0s5SlhJ?=
 =?us-ascii?Q?+p++N6xzxh7xTnXDDT9mOlsvIjzRxRWVCitkBiT2Ai9JdbHi0yLpPKPNNejB?=
 =?us-ascii?Q?Jj4AC2J8Q2beZbxCYnTHJDeiHADEbXcfiN5UjTlb2erhocl5z/nzGXWunsGL?=
 =?us-ascii?Q?nn7zcNSreS94vYeeFW8bJ0SxJapUaH404AOLgipI9RzFTg8gHhRBI0qT7jI2?=
 =?us-ascii?Q?uljjtRSFH4Apcobhe8mOlLYXGxSpiPYPnPJ8uoFNrLksqR+zPfNUSxIf9KDX?=
 =?us-ascii?Q?010uNMVcJQALPVdZiL60dzmytOWD+iPyi/1ZARN8fWq7TS1edYjvzKlTnirk?=
 =?us-ascii?Q?VyxAj4X7aCd2Q4kJ0NL4jDPDBaAihfx082mkR5vdEY0PAuBvSiIrAdTgemBR?=
 =?us-ascii?Q?P423uCwM2mEOJ01oPY9XVNia2MGTimJEdJAAdBWOLAGyPtuuvAOabIPK7Cti?=
 =?us-ascii?Q?tQIkgapUVZrKHEK+GCED3TCwIVSHO2RJQSg19gouXQuLoTH2uDKH90ceEGrR?=
 =?us-ascii?Q?XWxOlDDuTP1i8L9mdpItbi1P9YUA6K7Q4l4w27qFI60zMkWP3bb+VgDwijkK?=
 =?us-ascii?Q?shFO6ukyBiEJ1M4pKCpJ4Ed2GYaKtKNyMe0s0ALl3oUkTljyWGMFh3YCpgKl?=
 =?us-ascii?Q?XQ0HcNcwmbtiR0bLnBVAXjgUFlJc3lPFZrWO7P29rij3wd6nKxJGj2d3gNnM?=
 =?us-ascii?Q?eS34bQ++k4JQMNyX3P0tskUvagKd3VM6LPeYIFKHGIl6Vp2BtgmLcYy8TNpG?=
 =?us-ascii?Q?+l3iOeYri61yDzhCTbLtaoO+c1blVm1RRBu1dQEA6P++IvV7uHxRW2s9PJ3L?=
 =?us-ascii?Q?X7CH51zkS9nNK1PGqPChNIODKukORSsMgapWku2aN0SlTqrlodv+3n7r/rIV?=
 =?us-ascii?Q?htWZQ5BJ5n+AUmTycEh6fPlEYefD4NjuZTV+iWM5Gil+GiLWhWOWgDHVMy90?=
 =?us-ascii?Q?LSbeCA5jFWcYpCa19oFyZP3nRqxZHgh0mjMK32JO6L88q+bF72GH9AerW69k?=
 =?us-ascii?Q?LxKB3OuqjrlNPZi4nX/Ni7izL3ltwRRtNkF5PWsfm9WNdW/rr5iCKSjk0cGm?=
 =?us-ascii?Q?EfuxPvk0LqEsxaqd5D5OG4LMhfOvinDKyj74z6VFrM+Kd+eWBndTILmu1gDC?=
 =?us-ascii?Q?UD+vK+SjCUq7tl8XG0PcLnlblzAQpzeZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38380756-126a-475e-be57-08da06a8dd4d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 17:25:56.5197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OrwUDdEuLHcJpJ2xXCniRGpGTyIo/gBXH4SiSJZ0FDSxf2IUSTGeRai9qrtjKiEb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5284
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 12:29:02PM -0400, Matthew Rosato wrote:
> On 3/15/22 10:38 AM, Jason Gunthorpe wrote:
> > On Tue, Mar 15, 2022 at 09:49:01AM -0400, Matthew Rosato wrote:
> > 
> > > The rationale for splitting steps 1 and 2 are that VFIO_SET_IOMMU doesn't
> > > have a mechanism for specifying more than the type as an arg, no?  Otherwise
> > > yes, you could specify a kvm fd at this point and it would have some other
> > > advantages (e.g. skip notifier).  But we still can't use the IOMMU for
> > > mapping until step 3.
> > 
> > Stuff like this is why I'd be much happier if this could join our
> > iommfd project so we can have clean modeling of the multiple iommu_domains.
> > 
> 
> I'd certainly be willing to collaborate so feel free to loop me in on the
> discussions; 

Sure, I have you on my list. I've been waiting for Eric to get a bit
further along on his ARM work so you have something appropriate to
look at.

In the mean time you can certainly work out the driver details as
you've been doing here and hacking through VFIO. The iommu_domain
logic is the big work item in this series, not the integration with
the uAPI.

> but I got the impression that iommufd is not close to ready (maybe
> I'm wrong?)

Well, quite alot has been done already and I think we are getting
close to having something that can start moving forward, but yes it
will not be "tomorrow".

> -- if so I really don't want to completely delay this zPCI support
> behind it as it has a significant benefit for kvm guests on s390x :(

Every platform vendor is trying to do this exact same performance
optimization. s390 is doing it a bit different, but as we've seen, not
fundamentally so compard to ARM and Intel IOMMU's with HW nesting.

I'm not sure that s390 should jump the queue and hacky hacky uAPIs all
over the place. ARM platform has been working on this for literal
years now.

Jason
