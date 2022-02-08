Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131294ADB9E
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 15:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378464AbiBHOyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 09:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355051AbiBHOyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 09:54:24 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67A7C061579;
        Tue,  8 Feb 2022 06:54:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyHM8JGKHd2K4v+SRDA18EQqs8YWtNnsSccFRaUnb3xdE5lnjnWgaUBmWXwVxDwSH1aQnB8BrSPN7KGJpX4jdFv80cXV1L5ddNZNF6GsBpiiFaxfPt5vuKJDx0sIFEv5PTZBNkpSy5F+ccjVwowm+z6ny5aPWT1S3hytZ1HKw23FZeJ1K/sRhBGCKzlNuAJqd9Hq9vmx4VMj5quNF+PtmVKM3o2oc+UEHhaNVhdNz44/HQujgKAhJXs/CgQ2crDPC7AWIvR6uofVVEE+UbvEqVXwUP3H4czE/bq9ckZSME1vtWoYFwwzWjtihZBNVxsvJEh1ttwiRaoM2Yprcyagaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFm8dg7I+MLoTjCQs6+ypV2Wb7kKJDoAjtBJgPn86Yg=;
 b=LX/wNS1wfdw/XzA8e9J+qwG8lsUdJp64h7giLzFrNfGbHvZ9dVx13I46QWPHwelTeG5PzpZrgRzMxxzuPq2q9hhqI2QyhTO0Zvdg0oE+LcKEIMPgu4tBK71kMT50O7EWt54c2EKqD+/Fjpy2aHykTz5RQrBpQ1XL+OP3QjWznWffThx4Lq93rQATQVE2hyXN6X1ndVBDSIEk5E24BSstcPdBhnfti8CarsGKKw0Aw74wCQJoVMz9L21chCKv0qh4ruLP1/XvhxCuNKSbO5WovwaFYgTNhdBH8CyT+6UB8oq/eEHt+J7qReienKTlSlcI35x62VfRvfVkhBZxKaQ46Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFm8dg7I+MLoTjCQs6+ypV2Wb7kKJDoAjtBJgPn86Yg=;
 b=Q4mscAcxVQP6nZWGzX/apVdKIlfumrKbq4klfzF++nIPt7NZZwe+mPYTcsTfTyUbeDPKZQORfAPe1x8yW2aMKc7jOImjtkuDNHJA93bnzaZStJMUTJqmSHuVgnKuC9EzRvYCHuuxAEwX6PXVHAe5IMkFFA5KF9G0EUsGYq+48B+RI+OroXmF+gpp1AUx1UR9fJmvHhK84eY7ZDXGPX3le8Ru2EMrp+H4F3+whK7Xq1tD/SLyUQlRFmWNjHHBDqIOGn2JMGrPeP+WjlhOLgBJTlPLEwjWnjUgVdJ8mjrpgX6sOju6rerjRy3vqa7yPApV7BkpCKHHitsVl3ZsfYKjUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5219.namprd12.prod.outlook.com (2603:10b6:610:d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 14:54:22 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Tue, 8 Feb 2022
 14:54:21 +0000
Date:   Tue, 8 Feb 2022 10:54:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v4 6/8] crypto: hisilicon/qm: Add helper to retrieve the PF
 qm data
Message-ID: <20220208145420.GB164934@nvidia.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
 <20220208133425.1096-7-shameerali.kolothum.thodi@huawei.com>
 <20220208142525.GE4160@nvidia.com>
 <05460d58380b435fb629d2e04a83a1aa@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05460d58380b435fb629d2e04a83a1aa@huawei.com>
X-ClientProxiedBy: BLAPR03CA0144.namprd03.prod.outlook.com
 (2603:10b6:208:32e::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dfa67a4-f4d7-4e16-4089-08d9eb12e3fd
X-MS-TrafficTypeDiagnostic: CH0PR12MB5219:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5219D730CC24C983E011A4BBC22D9@CH0PR12MB5219.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v1s1iG2TeqqFS5+9h2na+l6lCjKP7udGgpo6gQn3eIS6CooRei15jZK8wZSlLqn50Vmp/y5yy+Fszh9YRj0qbagBbR84V8ONm8EjKUql9+mJ61cq8IXshr506ERn5KH0XLfaFZPqV7jCvyM6ttUz9XR0gayrFKkkK1/q8pYbaBsL4UNJouzXWDp/7gOtejmCsEc9g0f3A+mWuyLik12BzTdCVghfd4/mkuE+PX+An3U7O11ZlFpXG1eQTKz7CKjfNwBv0PdBqV5zJyju6BM8yX4oL11HzyB4ToJws7Rxeaj2+6hTdFVxNWheTLggx021KGFPpFHrcBy6I1+QBF4M4Y3uYpT10oeANLg2HnW13rxlolAS6B0ji+P14V3ccFDjitN1F9YOLPOTCSwyMZL3NEwPyx9aAzoIN9pUPOmCQ+zOiwy/8H3/oC8uAaPD/CjDgedDUrs5gJzpzlw4j6JOAX0fu7DljCBeOV92PI4S6gbeD3u1MbEGQZ5r95Iv9+2YGKu+3YfNUrkGZzVLpH0dqFOjhhxWdzyi7TDQnNR3pcCdif2AjlZSWYSoUXXPZkTAAz3+4rn+4CxYEDCPXTD6WwiwRGp2J8uH1PtB0iixCV8qEVLklsz/OeywJ9IEMGqj8W7qqe8DXe1xjXJGbDnLfRHeZsPtE61yHojLH0y12BFOsQuu54Qsa1SGhjvZ2JFYbURcS+Z1kGp9BuqFf2yn5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(66476007)(8936002)(54906003)(8676002)(508600001)(86362001)(316002)(6486002)(6512007)(6506007)(6916009)(4326008)(38100700002)(2616005)(7416002)(2906002)(5660300002)(33656002)(186003)(1076003)(26005)(36756003)(4744005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pX16Fw8gDjkgHPQGvUzitmOO3OMcsUXsh/OTrFhkMjTv3wwLqXtRbx5CbeCm?=
 =?us-ascii?Q?X8TImgu6/nDOyuWf8rXNqZq0RT42NHfi61QTYvw2/44S1xi3NUmSVOlW4MnP?=
 =?us-ascii?Q?ugdg93+LkhtLk/FwZ1qSKlBxlAtqkhX0g1dGsHGVUGC4v/VKnw58Txa0ppOn?=
 =?us-ascii?Q?dAJo/axX5bhMugyk8si46Dn5jDTXLAO/gKvy0VqyYoZQGNNaghSYjjgwD3xw?=
 =?us-ascii?Q?sfk/a5g5V7pim/MHRXGAgbsikhhtWdhzlSjqfYufqfJfFTci7QRhcdYEBpq8?=
 =?us-ascii?Q?LgJzu7p5pGOdO4nv0B0tWtSvqgcqu4OebWhG9sO3iVIG4P97i+3EiRCkCvtu?=
 =?us-ascii?Q?P/Zzn8bgyAWitltNRqK2B7YhdTIteKXhGfDGRHxOxhP47G+JV5ziNAeAMQtz?=
 =?us-ascii?Q?V6iBcyJoVVsxQYYKnijDYfQFNkdukjcyRF46WP3CBRwJCmA/U1ksFnAbFfNn?=
 =?us-ascii?Q?bmh0l2aKvflkixWFTdiWYrEAvWRbT7XUWsSOPW6o1kanZsQS5zR2nQIl+6Jk?=
 =?us-ascii?Q?6Yuruq5hT7ouGJUJvwL9hPqLAbejiVAGGB38LzRGRSE5LqfFXp/C/UGkNzSm?=
 =?us-ascii?Q?gkWhsvZHUfuPsj0Jivx8VSPUo0gFle36FnKpNMQvzdJJNodHQt9KK5irD2uc?=
 =?us-ascii?Q?mk1K7ld7LOExxPo+g2ZD3/iy3iuTPgf+gDK1ZZnTcOs+BUvG9fCHw1BnP2n7?=
 =?us-ascii?Q?/4CfNOF7poskuZUqRRUWfpf08fY4Kt7nhGGhDpAPXBYH66i6ldxgG434v9oh?=
 =?us-ascii?Q?OI/RxdY0Eno0F1ufWkq4qQNAE1iFqJwVSky+k7FJMit0mjUt25G4285o5O1S?=
 =?us-ascii?Q?CL9G+MtNlNjwoxp9jTJPkBPuFZavWT1Hhg9pY7wKbGzSxS162IAgSce72Zjf?=
 =?us-ascii?Q?4YiGSJnM4Ji3IBjvFT1/9aHGFh4VWbujmgpGI6cmX67373uzpLT9FWRX5eWj?=
 =?us-ascii?Q?HhSVV8p4hrjvfJG5xPaOeN4jUjQM3r8GWesS4n+TikPAdPPoAEHZ/eb0+Q3a?=
 =?us-ascii?Q?vNWOAHrXyBuBg7zRLYVrg0wmv5/1utpe8k4/UAIDdX34dvIBr0yShyPWm0ps?=
 =?us-ascii?Q?KcnKIXwGCpvZs6rc7Sen+IZzUicSPLNZ8NUwm7aphJgToEVqE5/70xd3CKKI?=
 =?us-ascii?Q?znTlQhl7jCK7pYEAvNcBr9CNZN+lbWvRSG6HsBoTEFBPXqzgAiM3gwQ8307B?=
 =?us-ascii?Q?EdGdZIYDyv6Hpf6pzLlcXRauaoU/1pCM8/RCWgaMCjtln/cxhJoV9Sr+ABwv?=
 =?us-ascii?Q?eizJOejE3QTNwl2dTCGWa4zhnr7aDZfgVkgczXMtb59UY/gPBfnj55VFCDS8?=
 =?us-ascii?Q?8zS+efeuGVln9FEUMA9DQfIsVYUsTaZ+lJt4lLISWD8052tbdf6a+9bFzN9h?=
 =?us-ascii?Q?BQcX95DpuJLr0xzinXf7pGwFMZ9HboOO2+7N+TUFa23w8Nen5o7EjAmNAst0?=
 =?us-ascii?Q?c0hUukVPrlZnUohD82hb8UNED0PcdZSjch9ac2oT8NI2zAP4hxy1hRfeKJI2?=
 =?us-ascii?Q?j96oLlzks6JBtXPtHkrG/Bt4ZA0NZmWyinrAruYzMFIbZYS710Lx8cQhoLNA?=
 =?us-ascii?Q?k3sTY3DCGHJCTnuItdg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfa67a4-f4d7-4e16-4089-08d9eb12e3fd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 14:54:21.8474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oc18/4x0cMxdLVqpijW4RCaT72tIeDBx+WPzrwSrzSVymH4LRKigINBl/l3wRSKj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5219
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 08, 2022 at 02:49:48PM +0000, Shameerali Kolothum Thodi wrote:

> > > +EXPORT_SYMBOL_GPL(hisi_qm_get_pf_qm);
> > 
> > Why put this in this driver, why not in the vfio driver? And why use
> > symbol_get ?
> 
> QM driver provides a generic common interface for all HiSilicon ACC
> drivers. So thought of placing it here. And symbol_get/put is used
> to avoid having dependency of all the ACC drivers being built along
> with the vfio driver. Is there a better way to retrieve the struct pci_driver *
> associated with each ACC PF driver? Please let me know.

No, this is the way, but it seems better to put the function that is
only ever called by vfio in VFIO and avoid the symbol get - what is
the issue with loading some small modules?

Jason
