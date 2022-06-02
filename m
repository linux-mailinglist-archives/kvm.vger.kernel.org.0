Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0509F53BE4F
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbiFBTC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238326AbiFBTC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:02:57 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7E6271A;
        Thu,  2 Jun 2022 12:02:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTFUWJyvcgflURKWotFBlyjLV4Rvf0PYdjJGyCCD08z7BfDIUTKxr3oKaOo1rd1LUnr2DG1eTQxnZ976wtzxxzOL3X3bZ/1SnURJwBcHLsFAQZSvBs94Pm4z2zKMCWy1pa4Z5YIcNfv9/eNIb3qYZkVsdx+f5Jl9cfjTJfVuCH3Tl/Dk34wg5jpCkJK3YmOoAQkS0bmKX2qVpaImUD8Ebagi0Iuch7tYZgf1IXlGcmXy8VQMqJqyXrhjtMVfoNneV2SbGJAmIRvMwbExSz7hqns60s4ZcckbdxhF2Jnqn2E3+af4WbzqxFutDstBN6sqb7aIxNwZEIWGggw1zNWuCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+YBaw6P80+obo0CKvIElhjEOuFiWe0TdnzUAMxAkAXE=;
 b=nXow4fo16NVEz6VCV2iDfcBrpomoOPtxuwN0Q/UiKhd1VxSY7vbwjdLbebYkqGIu5/LvA8BHJvE6si0U7F6tgKlpHPIWizNiabIS1UzSoKukyCZrjJ3epHZEOqqTEm+SNv5OoNHPXTClC1usuAxtZ1ZXhz+F5tIAN24HQy4EedK17n1dAsABlEMZby4j4sKRcIYaueHT2D+Soenyz9cUUyZtiMmu0hLbInDGVAyME1GNyDHlgH8F6Eb31yxvkHaOOkQgxVxxMcpiG3WHOwk5dX8RuictHYSdqH+l4kP3VhFagoCVGtTphsfF6VSqbxfwvZH+kkxq2TFn8mGuRTaKqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YBaw6P80+obo0CKvIElhjEOuFiWe0TdnzUAMxAkAXE=;
 b=jFVzbBsvX19+aIC/7+SoguQjTFn49YGP9vcPtjnJdIyZ5wVYd85dlccAwy01KCZm8NU4NgE1Y2d+H+Py0p748H5GyFCfuRcQuKc6VnxWr6dXzinQoz6yv9GpyiWPo8VEq80ynKZ+xcj4CZXXXADUwKbCsXUDtOaqNRoNFxUg8Ko11TC8dBAXJWFo1BLydJIT1zEf2JA9ElBcWljlveqMKvk5p53ZV54Lx7Lz/cV4HVutXZCW8ANlWvj70fEIfjT5JMfOiZKZ/il5g/8LZniHBT51JgsoOKLLVfldlNaN/SGq0HfkPNhhBej+tJnb9d44RZweZLpvMcchN5VLMUYSmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB3153.namprd12.prod.outlook.com (2603:10b6:408:69::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 19:02:55 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 19:02:55 +0000
Date:   Thu, 2 Jun 2022 16:02:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 06/18] vfio/ccw: Pass enum to FSM event jumptable
Message-ID: <20220602190253.GC3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-7-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-7-farman@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0351.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a62dbd2-9ae6-4fe3-696b-08da44ca803e
X-MS-TrafficTypeDiagnostic: BN8PR12MB3153:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB31532652EDBE5CBD1707E48FC2DE9@BN8PR12MB3153.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AX8xtIn7CU5XWeP6G2+fIlwrYLuoR4GQ0+sA19UgCNovaLSv4iKaNm7bNPX1dUwa1tHk2Skgr4ZV8CDEcrEOJuAek1wHPOKEZvCksJDwAq6d2Qq8ZsHSfkaISzWpu3n7aYrS7YS5iuTpRrbe/yKqXozNHQVV7z7j4TPPlnru1rU77Sp/xVuaftcOttX0MmC+2zZdNz16GscX/XQZ/2frD5tZTgptBD7Wmp/s0k1gyhzYnBJzjEOwRVA8uRN3nIgc4xMz1Kdg+u9nTkeiv+rI3UA5lJjds2q/n5QbMQfzuZQT1OOEXdmPVoyySyEcLv7DZLz6BYLennADROM9ndmxFN1atJHryIElJVoWKuh1JylzbwCuPyGjBoQ88u/Gsd4PrOqX12OtowWNjtJ2w+5BUv+D+cwbjIIpTa200nH/nNGCvpbQ1D0biBNkSdfZ15GIbIwGvbILKvM+U4U0IEru1NUL3t4xYxFrheZsCe43cOGk7Tcnq8ocdw8s3qaKC1K2pf3GeNmV8WcIs95Nv6zN1+Li3QkOowrh307KgBrCaL2pr0BmPMQwa13kmayMH2lgWuU0TgJlN8+n4ImN7fxfTRW4UziwE3l6WCK/Yn3Cf0ucVAL6dRJZ4KiyOuwjSVLBJExmq5VAPdsjstB7ueFS7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(508600001)(316002)(2616005)(86362001)(26005)(83380400001)(6916009)(54906003)(186003)(1076003)(36756003)(66476007)(66946007)(38100700002)(66556008)(4326008)(8676002)(6506007)(2906002)(4744005)(8936002)(5660300002)(33656002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?onvxF1mceaxOo2ijINVWaZOB+aHVsw1rao3F1xC6B5anb3DjiFf8ftSDmdKh?=
 =?us-ascii?Q?1Vre07ASnr0QR+zlW9fHg6SCBQwkxsnmJgf52xy6ydgGyBRIJ31ujV/6IoUB?=
 =?us-ascii?Q?r09HDEXOMmqj0yPZSIfpOdTtZKFoUZQB+e2AVAcFTGWHQAWEAdQgUD2YuT/b?=
 =?us-ascii?Q?bu1fj+NLIUWeBFcSj21yVM8nJOspWOwGwsEMNiln6uCXFV2lVzZ8vjQlz13s?=
 =?us-ascii?Q?5wVU6Oy/DVvbLj6FLVYDy2a7oc+qFT8OHMtWtNDPJBacr90g1ytx6oWCTcn1?=
 =?us-ascii?Q?gaOvsHxBXwAp1FVC+tcPPBGCWDq40xNClfMWlp1pps91eGk1DDWocRdKcn6x?=
 =?us-ascii?Q?/FTgjaXnGwdVvIXmNX2iw41ea/pFfcddTcT04sS4eTIlzb8y54c88slrZNj8?=
 =?us-ascii?Q?jcbu8sdh0rDfybrskLcZoeP/EvTuJsDNRFaGe8ksgGQ2HKGKzyccgFlBCSqv?=
 =?us-ascii?Q?FtqOUckZ8VTdyb8680K2a1hbKf4fLTQGGaozZlgj58uEcqlE7Ct5s3d1/9+q?=
 =?us-ascii?Q?g98ZN87hR83YidA/iK1DGh7E48+XrRVkh10jurx8pgPHHVdemdyRSuIFw7YA?=
 =?us-ascii?Q?cC4EZSRyNyfcPs891idE4GuK214EREsJIKw9A6/x2tIBwwKKVJe0DEpWVsEx?=
 =?us-ascii?Q?m08VFSrNmSkx29+BdEiJ3Jl97yAEnshgpLnpP6udkS9pSzIV5kraoU1xrHef?=
 =?us-ascii?Q?T6SUE42vLyhcIXJHuM3uuYdpCmhP3j25ffER2o9BFMGbg23m69kGbD8Kdwpb?=
 =?us-ascii?Q?G4Bf2eECkT7LVAD8XZt41FDwkOP59TyEBIlOjyN1Bv8kRgz2t7KiSq8gA2Qd?=
 =?us-ascii?Q?x3Ke6+orbEXRzCHwfrYh+cfAxmt/VELP7vLg1sw1jLSFM4CUyJ7YPWkOQHOl?=
 =?us-ascii?Q?zRNwsK5mQgtCe++Vl2WIf1XkamnGN7rP0k4awK9EOQknnFfdnHV/3QfUau6W?=
 =?us-ascii?Q?VB0k7ZAuuAOqqw0O9ZoZJx+VBduXH2WXg7TH2M1+/VVfNmLKsjNoh5yxRRjB?=
 =?us-ascii?Q?u3BEB4OD4Zk/EIZuYB/Z2PGQ6kMJ3qrWvXMG0DdyHkbOB9ZXJNN61Gf2DdSw?=
 =?us-ascii?Q?Lgv+/rEiCgeWI9Wh/RIYJcjLgtCx//NmlB5P7QmHcsAdnkOIsYKjyf3YGiDi?=
 =?us-ascii?Q?wRwKlHZx7gE8E/XYIZsxqYXzjsYZnV1Mmjk6TO3Oz/D4Pg2cMgZpMuvVGwLA?=
 =?us-ascii?Q?+tjDYz3nHVrhBGjXSAGT2YigKjmLX8daa6I399HIRutE83FBGiTpfyHmav+z?=
 =?us-ascii?Q?rpeEQV/gHJ8HfJqB8EKiBgMUmVg7aks+a06Lq3L+GQkeO0e5fF/OvrG6AJuX?=
 =?us-ascii?Q?wtfLggMKpAQVE+7EIMybn33KsKzvJgNhxVxg7R2yOmIqJcgABs9NyV3mQe4L?=
 =?us-ascii?Q?g6PzkBTqyjp9ToUZtHBiKE/HzGWC0nZGooVolsF2niKWl9FLzoKZ6xubjXGz?=
 =?us-ascii?Q?IgiGuPUaocQtgdrN1fCSv+Ja+yJTeJ6vOiFNprNhBeInUdDe9NHsP0EBNRnt?=
 =?us-ascii?Q?5LkaLUm7Nx4MFHDB7/RGwqWEyTXDKfTYCd7gN9p2JxwI8tscW3PHEP0D+yjJ?=
 =?us-ascii?Q?7bStyMlcia7vmmGFtvK6/M+QEFAyM2Wk9BNGbg+doT/KF/tCdeT46w0FxyDP?=
 =?us-ascii?Q?8vUt7Z89m8u3io4eiVhbCrmDLqnPLFzWGmH3YveW6oxtmsWG+XByZjiPGLZw?=
 =?us-ascii?Q?W4CAZFfQGulBCODrxUG7RllYcyJDQUM0BPCX/ZPDktGjiGXxAgeSkAeUeQfw?=
 =?us-ascii?Q?tcVgODO0xw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a62dbd2-9ae6-4fe3-696b-08da44ca803e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:02:55.2627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uY+ZJwsnjAxlsPcPLYwjZhn3sPplR6UMSkYJ/r3SbS5yEKdek6qyhM5mVoJJHfkq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3153
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:36PM +0200, Eric Farman wrote:
> The FSM has an enumerated list of events defined.
> Use that as the argument passed to the jump table,
> instead of a regular int.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Fixes: bbe37e4cb8970 ("vfio: ccw: introduce a finite state machine")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_private.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
