Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B76C607F28
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 21:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJUTjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 15:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiJUTjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 15:39:17 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BCB2930A5
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 12:39:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gn5rur0bFWf+IKVTUY5dFAuLAC24lAKUaTFmpkAZwGhBpXqG0ACs2g6DXfmWbwkcq6Fo9uWWoAcGPsoMK9WhPPqP1iosYLwktJ94e63d+YIYSUZf7ZL0i0F9sXH1AMuzZRA3ChH1MPU0585fyh42OhENlNt3bHN3QBsm37BGyghDdwhqyROitgxy41GecXhL3xAhcGfjlzVKOzd3AjysyDQUlIJw0SR9ySXBp0ehT6b0GNdUk/hP7yf9Y1bJ4MSEraCREzTWACWDqrz2p4MuDfmx7Y3L/uUVK4JeIOASfaUN1gIi6VpFCLkGzL2674T6S1TsWZxwZs1EyNnp8dBNNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38To2IzioG/0c1nWdscPjkWq4+HBXpt6dAk53/veFNM=;
 b=BQIpk8jmRN9n+/Sokh+WRgc/AaW681+SstxVyyOI50RlHlM9+iadbDHzO6A7YrQbfIzeE67Tfn9zqznBFNxOUmtPA97cu8KQvLe7bod2J4E+Vh87eOJHcB+dXqfHw8WOKFUM4Y5dcs9Ny3OAZQFWzZgKA1azbOOmFCGI4pZJqrFonCE/Vq2gEaX4N2m80Xila+A8fHJeHAukZrtRfLq/y6Aa/dY9i8a+2kSa2yv0kU2AgwElb/AndZxusY3rMeiXH6HHcxRmnlPOyyTQEjAD6BszSC561P4iu+GtwA+QQl5/pG9LQW8xn0PMMBNbKY3iN3KiqR8zFsQbKKtVbTZWkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38To2IzioG/0c1nWdscPjkWq4+HBXpt6dAk53/veFNM=;
 b=e5jXT4ocLWtzG50B6NUTq2Tq2tFr9w1Hb+eGz/P1MtJcrwIcAeYoIKFNzTC03ogr55w0ETLtGMtvir4v760Qj4nZGVIGT0SPxf6TJpS1CeTOrP4A04U5TqIAAk30P8vmPKaZfM2zT5rTYVmXO3YNZ4r2HldPREn/6fYddmN0Foh4uMImc+tpJWmCuepDmgq5z0KhVa/LZUjTYKt4hP7+JhwhEQ9giH9YhIwny4+48+eYkga5F6j390DBNvRzmurfSSUmOwoV2qqTtQxR+1Z9jSAUSH+HTGKeQNtoZLIN4PI5hqORb4ZCOfPaCQNMBW/jNL2/uQy+pMXR2wabirvYtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5103.namprd12.prod.outlook.com (2603:10b6:5:392::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Fri, 21 Oct
 2022 19:39:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 19:39:14 +0000
Date:   Fri, 21 Oct 2022 16:39:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/5] vfio: Move vfio_spapr_iommu_eeh_ioctl into
 vfio_iommu_spapr_tce.c
Message-ID: <Y1L1Yd7DfyosjbTg@nvidia.com>
References: <0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
 <3-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
 <Y05CW7nYgVN53I1+@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y05CW7nYgVN53I1+@infradead.org>
X-ClientProxiedBy: MN2PR01CA0050.prod.exchangelabs.com (2603:10b6:208:23f::19)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e7d768a-91d5-4c1b-cc8b-08dab39bef6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HO6PmZdQf0Y8matSEAHQOUlXc9yIEaSBkEJJANPAXkY++1REskIazjYGZUhb8Hj3Jx4d1HMDm+rHDSjVXwqICFTfdK879AFKFal5On7vDw59pAKUA0c7qF5W3wZlVSkAvcPPVuytOpOa/lTKn5IngwlI/V4VhwpkKWzm46ury4Zp6xt8vhc+zrlJIpPiVefFtgzV1dizDiL1Pc/lJ7GJlyQzBg8XUbiF4ZydvSPrPkMQkj1/+zkkN6eshkJbsoR/fEbMDWTH1zWtbyxUOpaZuCIzqY0h5rAFACqOFOvqKXaF8HK0RVaObASo/w4n6Arf0zBaaOJ5iLwTnAWaJno1vL4HIKpAOZfYau/J1b3Y7VK7H9pA6Jt2HEeSveVMc0uTWA821IsY6RM1dOMq/+QYEEERzmJPyD099TNI9Kdp8gUP80QHQqNitS+ycjJyk0uygBMZQEFS7pG+tdqUGJa1wzBbPtca1o4p+PzRV2xz2PmIygrFySiMcqeOCepiHlUkvbFtGy3bJGluKbE9adrVGdPBi/dkY+FiYsH5ISSu85sHuHA532uWgZSVGhJbKPr1vz9eOCf2c88PH2KvD97cggM2INZStwRYxaUpdvHuAOPq7bIB2Gy/T80LpAsYPcPzHaSre+r4hPu1K8MrSx0jVEzPW8pIgQ1lPWeocHm7R7t7LfSAAMl+E8R1tywXZeIi+2xVrsH6UU4hvMPpcGholw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199015)(83380400001)(38100700002)(4744005)(8936002)(5660300002)(2906002)(478600001)(66556008)(66476007)(6486002)(41300700001)(66946007)(4326008)(2616005)(8676002)(6916009)(26005)(6512007)(186003)(54906003)(6506007)(316002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HSWLpdZQmeRyaO771JnY0aPCVD5uD8qYH4G1k5Tu4hlgf5uVCeIAYFlAnGRm?=
 =?us-ascii?Q?WTf+1UrXrlnlAHENAGK9W53/CvIsPhkDaJMH1/vGQvO5zEdLkqRuA3an6E0q?=
 =?us-ascii?Q?dEUo2BYRsD275URuQzHLfpdGYt2S71j8B0/GN4B3R9Kk6iezPPCbM+YjluPv?=
 =?us-ascii?Q?Ub78O3QiGgWkyEfnxNEMdej/nXMjT1Y/3gmZxDaV0X3YWnTlwgvnS/FQs6r5?=
 =?us-ascii?Q?26CwFEIyARI5zyRjnLYwXvZxe+EIb+Q25zjFLUwFtjyxzRZI69n8xJ/g4+pb?=
 =?us-ascii?Q?Vtql0Q22W2WkVK8rgsxw2iS2CZZSJoD/pCMJC+9jmbLprQDc2LkGRcZ4VpmD?=
 =?us-ascii?Q?g+Kkyo4q/HtzHoiCiJUnrKQkKu59imcL7yhBwUi28DwXMcZxmEYyW8grKwgE?=
 =?us-ascii?Q?z7a9xnErQE/IL+KyGCu2uBTlhjRbuhb5dG0Lsr5Re2e+lx1+9xp2tovJQByo?=
 =?us-ascii?Q?lnPEVsXM566RUun2J6u2Yo2occ8TUaW6A99m4rlXgO7a+k+NExXE1PW4lQNi?=
 =?us-ascii?Q?jSdcs0ZTkWyWsE2GzfKPN8pk9cu7U/bIuhecP8/0RG7kiTKOVpBDd9gowTRo?=
 =?us-ascii?Q?dwqPsAyIILrEXwlwGCwDC885b+OK1eHAY24kFWupmctg/wyHwPy00h9vZsoR?=
 =?us-ascii?Q?Hv51wOtbNmtskrtgNx34Woz/VCx0DtYZqT2Z/LFLp9NoJ1uvqtyzWU0CTp1K?=
 =?us-ascii?Q?8IrljUwQpw7qB8cRXpao7f7EpfuZNbOwaMCESh37bTcwcAs6e1iTJch9rwc1?=
 =?us-ascii?Q?ty6uLya8gmstcd/3eP06VXuk50I1CJQ8RET7pAWgRgFj2WZrW2vdvHqhYXzq?=
 =?us-ascii?Q?cDnSz3MirR7aTaXF5PdZHfvP+2VSBOKPVVIiq44FtkDwfjDabDMZ8eZYOiEB?=
 =?us-ascii?Q?FDVI1l+w4GELMLr5e/RtGmtH8ugjHtYizZpb00LgEi2ms3CObyeW7sZrDlTE?=
 =?us-ascii?Q?ZYe9lu4/t63vEjRQpItupJMhU3AFiZX7SUqMm0Y3Had//AZGPuJDcFgz7GM6?=
 =?us-ascii?Q?eSo2OJW56f0PdrflJ5ASAG3PxNJdCFWd2nKQSozToL6OLpfGPZouFhUR2Coz?=
 =?us-ascii?Q?IsNfyrFKt+4OIEtvjRzF+0PVwWVQnpDxIJGjqDzmhCpJ1BEAaLa/2Szy0DKt?=
 =?us-ascii?Q?t4ia8x5jqIJjxbIbALYtYu0zTQo3xdvWOgD0DYXoankk4MNGzh1/d5w2xqI9?=
 =?us-ascii?Q?0PPn5KWRpyYJ0a42JV2Q0mIk7nR3zfusAcOmCLQH/lzMfWQChMCBrD0DV/BI?=
 =?us-ascii?Q?VAegVU7zlUAM2uZKf0u01+6HDcNioz21GTCxtHAQvSwptnlZq5UTRw9GQBMT?=
 =?us-ascii?Q?YbPY+/T30zuzVQPvqoxfES4x7bpqs16y6aGThtozVMUFjDlE865AJALQ4bIG?=
 =?us-ascii?Q?M2L8p8C12y503lMrCjosCyUuvtT0p1uvYZDHNxcknFxEQ/sSDqz9vH454gxc?=
 =?us-ascii?Q?VovTfj71Ji7tjmx/vqfLn3pR3o8eN6M5WdT27kj9Qg0InbxXRMeJkSTsKNBk?=
 =?us-ascii?Q?pTV1fACb2nVrr/dEaf7c8ddXU3aim0VciIpPUL9ykShLZAWMdy3Tj//EZGD+?=
 =?us-ascii?Q?T7cw6iClndIf6/Jz5kk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7d768a-91d5-4c1b-cc8b-08dab39bef6d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 19:39:14.6474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYx6UhxxJZFc/FfDZKz4r9l/Xmg/lbWhYOzZ4DuhadujozaBxSxd7PahoZwPjopU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5103
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022 at 11:06:19PM -0700, Christoph Hellwig wrote:
> > +	switch (op.op) {
> > +	case VFIO_EEH_PE_DISABLE:
> > +		ret = eeh_pe_set_option(pe, EEH_OPT_DISABLE);
> > +		break;
> > +	case VFIO_EEH_PE_ENABLE:
> > +		ret = eeh_pe_set_option(pe, EEH_OPT_ENABLE);
> > +		break;
> 
> This could be simplified a bit more by moving the return from the
> end of the function into the switch statements.

Yes, all the rets can go away

> > - * Copyright Gavin Shan, IBM Corporation 2014.
> 
> This notice needs to move over to vfio_iommu_spapr_tce.c.

Ok

Thanks,
Jason 
