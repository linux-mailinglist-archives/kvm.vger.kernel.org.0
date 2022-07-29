Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E703D585586
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 21:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbiG2TVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 15:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiG2TVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 15:21:24 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE7C4F6AD;
        Fri, 29 Jul 2022 12:21:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dN0Jczr/gBl2IEIAcDIoDzNOsc7nvEo33OCCL9zlITF/+KWboyzgW77+o1m4kDieEqG38ppXA0WEt6KutwhdYMRuqpWFQIHKzzt/NI/BdKnzNT3XwJroa+Nph0DgDfqrxBiyR1huB2GBgdImOV1D8JnTWUFjdksV9eQO6XxVPN+Vj02FY0PEnNrXHPQr5QXUkvAX/Ook4G1YNWbxSwN3nxr1/c4e+JZhZXWq5iO8KploaznZkGFFQ+KHBEgGNYOt4s2SlcMVg+VA3hYooOvtjT5XJFQpOPquKxDPWo7xOwjIedzWDX1Es7jSYcMVf0+W8Ah9AHQbE8i3IkHdxK2oBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=al7h2DkcDJhn7HZ7/XZNF/wCYAdX0xwU1S6Ry4nddQs=;
 b=XHs/I5QascOgLG9IoATsRS/8JUXJdRcuzC1P3Jf4AMfek+kkV0fJme8rrApkJJYdJ00HBe683pYnhGuZoNRLgeqFA8urn7tjf2searQiIh8LpJIZHdoZwY/6tV5MQJv2D0/WFIRfpUp3Nn0cZq5IzTVPUqKG4+CyUBEsnMC3aCHEWIZP9mweN69Z0KtgHEmvOMXiCelGa2iFOn6Xq9DTh01VuZaU6+TvKEu8jWQYNuEQv/SN8+kHa/eyjGleM1gbCJ8va8S/sL+gUD5wQ7XsU+u32e1xCNHkS6J9OJeVxmVfwjO76nkGqdU4Z6vUvTp1+RLCKy60LdE4Uq8S8cdKgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=al7h2DkcDJhn7HZ7/XZNF/wCYAdX0xwU1S6Ry4nddQs=;
 b=Zb92VmvpSZ3i6ID0DYwqqlbY9qOQIs58qW1sJskuof7J+d10bkRr3E0NQCX4Cs0XndbVMG361lnbnT1EBaPi9/IAlNvSG+VR+y1f3oEwFTsgGAXRo9uHuw8vEwj0McWKrnRcva/atQMsgAjAwwQKUGJpryAxcUAtnzXDoC31nWg0zI/3cdaKmGnSPkzIQ4kWOhzQSdG6swgVABn+7disUYVtAWeGDRWsT0nBhpJfUAyXw6wwTKuNX4xr8DamuhcFkhT0l1nZv2T+9IzrM4m7LwMsH16AJKgGUkznYVi7inYB7Y/WmV0jl6wzdi0waGQv3UcrMs5ClYj8ALBmjIlamQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1651.namprd12.prod.outlook.com (2603:10b6:405:4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Fri, 29 Jul
 2022 19:21:21 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 19:21:21 +0000
Date:   Fri, 29 Jul 2022 16:21:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/3] vfio/ccw: Check return code from subchannel
 quiesce
Message-ID: <YuQzMHgvntewpYd3@nvidia.com>
References: <20220728204914.2420989-1-farman@linux.ibm.com>
 <20220728204914.2420989-4-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728204914.2420989-4-farman@linux.ibm.com>
X-ClientProxiedBy: BL0PR02CA0121.namprd02.prod.outlook.com
 (2603:10b6:208:35::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ac46f58-6f5f-4348-8895-08da719784c0
X-MS-TrafficTypeDiagnostic: BN6PR12MB1651:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SwwlOHxEPYxH6CGbPEZueIsccyWSO+RgU85W957qflh2LGtH99JNO6li7cd3DuLGEk4Jq2+gjhROV5kymn1JWGnB1n5G3ktIjvCmKtpCZ83ENwrtszIEiH255MlM2+IeCFFmHGKE4bPJGYULmtj3ylTwZ49U3e2GhhiA6LxPH+WTD7cd2GpWHGoF2JXrwOWg+YjJxZxxMWNsyRClRKY5wLAwLbHVwckjP1AQ1du7OaaoiI9c060J5BnH9Jq37VA2a4cAXTMgb4UmFL9OvT+fiJIJmaYEifmdD2Ei68FirzIDrUCkspAlNhP7JsoRc7A0s+dzeJeIM8EjbTUhKHrBZpgfrRIuWe9IaqSORFm3/6TNT9ZX7P8XRH0sJ2rPhEeiCs8UxiMaHE8TgmI5+8+lj1Bz3dC5RYwvwVZYfcICA2TxRUoNkucICWkDfov+TYSBb6YhdULchwq40Oo+pl6ke9PLPQ0rZnCjRxuQOzS8wOhAElnjDmKuHLz2PtD3szMlE9xRumNDOMMnug3XfN6UG3wzJJWPOvmSZKtkNwJp845S5k1uiMayCX4kceCSd1ZYcK4GUEIVQH8VU/q/QgQWtZ13sEKn6fFwg9sjwJl9qloVKqRtX87UuEJUAlu67WVz5heelYe5ase5RdTQKCfDSWheeKECD2AyXkX0M/BTrFm+nI/A4FDQQ37H6sC8u61eMgG5acO6+fhEbmDR/xUdVILuq/SCdpJms5VSmov7j6TASwgqevnkeoR8U3+0l8sn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(316002)(38100700002)(6486002)(86362001)(36756003)(26005)(6506007)(478600001)(2616005)(41300700001)(54906003)(6512007)(6916009)(66946007)(66476007)(8676002)(186003)(2906002)(66556008)(4326008)(5660300002)(4744005)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hz1C4ajtei8UhqBKji/im/jUMn42cI2rQvPzvBIr0Kuold+FLY0fRTFHbrzN?=
 =?us-ascii?Q?nyeFM+B5Y9jez7NH/gTEaXe4El2RnNbojRZkE82iwTAfptokpZ4+vdVjdZhx?=
 =?us-ascii?Q?dybPdJ85mmo+u2JSLvklYj91jCqEJzV4cd1mF0GiTMvK+1fia2FVFFUrnYgF?=
 =?us-ascii?Q?Q0KDw8ngv1kAMfvccQn0pJFlqZBhHDrvp5qASfFIV9rgElis/IuQy7IfRB5E?=
 =?us-ascii?Q?stlealPw5ONv+VkgSvB5YTuBsaTVzuylgqyuG91fKvfSnFFBAL3/REz+YhAp?=
 =?us-ascii?Q?PKD6MptRQKDq7ZCstCTNs/oZ/DzH8X92d/RlgB7d6+1u4PNbYXhjWyuinXu+?=
 =?us-ascii?Q?y64KHdF+jFeryxR/uTN+Mje7OehA9ANTltWDVT+4384FCIgyrbvsq6gFQats?=
 =?us-ascii?Q?XDvzAtp24bu40z40n3cmCYO0EnvnBCn+wEHmPn1xCHqH5W5iyn4d7qErz4Ak?=
 =?us-ascii?Q?3wJpK9+8beDV0XgBFujcQg1uD151yCz52g2hakhKjwHzH0cEFhFyEb4ybQDQ?=
 =?us-ascii?Q?SDbEPpxkNLD4VfsWbBxwLolV8XajqTz/eVum/32EQiwrKxl8roCq4Tlj7SQF?=
 =?us-ascii?Q?naS3YhDFYhs+n0lsKMLe19n6wQdl8/aZWPxgH21iqBO1G+NiAZ1eSr6el7Ed?=
 =?us-ascii?Q?JLRASZQFj39sMnLpVGHjVqQrTIEHPUfi+XCw0vRRu1MAgipfM+RCGdtGeniv?=
 =?us-ascii?Q?zp4OmBGvXDM+t43n5wTas5KF+jWQUdJ7Aad9G8v3VX0lT6dCppyNaj1tzMrA?=
 =?us-ascii?Q?bXuzw2tXO3UKwSgbbKQhTi2pz+TUwto0AQ1eAZ8Bhue1YfICHfsmMcw+A6fx?=
 =?us-ascii?Q?lL+fZQVNGTKYtpPniFothyeDy2pbnThcS/q9qENBpcSnINtMHrljabR9AIft?=
 =?us-ascii?Q?0DvSi26HSg1nVsOnC+BilebVQJFsQJXqR63byhZojmnmH55rnJ7mkRHOkkyr?=
 =?us-ascii?Q?Yf+7CHdkbo4Ng5IOwRwpblgMrHAn1WDgjEkpgcUTYz/44CrjDp/4iBQNZXkN?=
 =?us-ascii?Q?ZZ2l5/cRgt5dbRK96zwgkMpGwncHZr0PDMYPcXsTcNOmbVlL/+plyNwNgL6k?=
 =?us-ascii?Q?Edv09kRa8l1DOliPjBbUNP21iCUkP60OT361NMmhqx0Bm9F5AiAoFlspVJvG?=
 =?us-ascii?Q?yrvsveC+FkU6ImRRnI6r6lH+64CxZ5UmFTp1p0vexpdOnfVENxyGPZrAVMIP?=
 =?us-ascii?Q?BDKzKCeAWsDY58IHS49/3Aji1VoRhXvSkbN+JjLDNkB/1ybUIXRANbP8I1mh?=
 =?us-ascii?Q?017U+DxTiuHe2mBZrik5yqr3VPO14mW3L02jcqUYxD8ObhToFJC68p1vz+t0?=
 =?us-ascii?Q?6ocoT9wfcqQgGwsmfnpHtK1WaDBljXmoo7JxFhXJIUb8830YBclEDLCmK0P2?=
 =?us-ascii?Q?U95lLcizTwAj81sKi7HazFDeYPFWROZQBRaEDET7fp/rU7zCOqbFyHrWLeKr?=
 =?us-ascii?Q?HEHOiG/zR5/mtysokOFjKmZGGx8trODRBDDxVGvt86mU+WuTNw22oHqCl4pg?=
 =?us-ascii?Q?ZEOpTnu6sxr5uSOEgEBk/wz9te40SqDmvQ+e5ZeEr1h0IZUpdsXmEqOQSQYp?=
 =?us-ascii?Q?heLc5lJHF4+F2958gnQPET/zswBoMJ9oHLEfRny4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac46f58-6f5f-4348-8895-08da719784c0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 19:21:20.9119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qm0LB2ENm2sNHlhY7wHLg0j6h1Ezk1tL/plDhOMpNO7AUJMEd8Rp6seBrD7QwLoQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1651
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 10:49:14PM +0200, Eric Farman wrote:
> If a subchannel is busy when a close is performed, the subchannel
> needs to be quiesced and left nice and tidy, so nothing unexpected
> (like a solicited interrupt) shows up while in the closed state.
> Unfortunately, the return code from this call isn't checked,
> so any busy subchannel is treated as a failing one.
> 
> Fix that, so that the close on a busy subchannel happens normally.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_fsm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
