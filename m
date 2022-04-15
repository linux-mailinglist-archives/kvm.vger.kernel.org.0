Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4721C502977
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 14:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349739AbiDOMQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 08:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345847AbiDOMQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 08:16:14 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2089.outbound.protection.outlook.com [40.107.96.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2BABF946
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 05:13:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPM9SsGbiHCASUF8zWA1rOC+o2lJKNnZy1IdOk5cMARWAypYP6CwR866eJLuAO0RIjooTsfCYToLwjrbv/aUqgPEYOVjxflEE6ZnDwZD8iBcR28e+bitLyaSCUPVunlEv4eY9C7vYtQ6IrdD3mTiHz0pZmGWnuZBmKjGtnBhYht0bZcfwd6MGx/1CCStcVww0AOKw02hd+bxd8bvmPbwjCLv0iWHdbIefLnnVggTtem/vd8rfgrUkiFvEYFbg6QPTw24/HgURnA3fjzl4pN+hT3meAn+giR/wmn8k6ZsqhdUwigj5/iwN9bXcvmG/q4/HugzIZ07O/dcpgJIrqeFyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3YCOebEWV5R9q2E9eTodjLG4B6oqOU+cYZ4yRgb5Zc=;
 b=Ff39070r/UUT+bUiydEAO7eecwf9aU/BxlsL/7eNEq5P0i7+22k3azRCogBT+ymO4/SwUgn/m9URFA+W15IQoaiTIlo2k8V4UBPRE5z6jqCoMi9QexuR1Z8klKp6vLLUkNjki5ytQNXlOEkYYKtdsuIGGjvhr32C1lVGSujUritafiZUqTMUMDUysyxYmWO7BphJIqmcbmEGQyuiXz4+ulA4X0SKgmI/5JUNPwoApL/C731S5rsMmfBSSw6BpUpRfBjeqr+CS1IR/r0zR1k7BNmTH3jUjRDPmUDoTt6HKvSZ6D58VfvLk5GjPpWc885+bh9smssgR+hP6JB1IHkqUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3YCOebEWV5R9q2E9eTodjLG4B6oqOU+cYZ4yRgb5Zc=;
 b=N98amQJd34Doh5J+DBOjF/gRJmkpdeGGY6zTGKFawTEaBltKSVn+blj12olvOMhWvgZg2RUUXeJ34SK/krtFTZ7tir1gGAc9xXG4+sk0UgnPr0ED6AmmwMUxV6rjpb1Xt45krHJU96A247EQ6INr82YWGnN8k9W4/KF38rAwTc5n2BjRf83hqPaRBIIikoEdOqggJ1jOPWTF5z0YOOroVNVwYXkd3vXOeK0K6KRllbS0dMAePVFk64N1bUjFn4l6FovNACktVJYAjzPS8Y7Q7xeKoImaS3qXc8txNRY4toyRBmA5k7POSou9ioZySB9lJmdlfcUl1U/FbpM/01Qzdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR1201MB2554.namprd12.prod.outlook.com (2603:10b6:3:ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 12:13:44 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 12:13:44 +0000
Date:   Fri, 15 Apr 2022 09:13:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 02/10] kvm/vfio: Reduce the scope of PPC #ifdefs
Message-ID: <20220415121343.GI2120790@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <2-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <20220415044731.GB22209@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415044731.GB22209@lst.de>
X-ClientProxiedBy: MN2PR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:208:23d::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 348009cc-f9d3-4ee9-8e83-08da1ed9630a
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2554:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2554FBD9E6718D8FAEB5362CC2EE9@DM5PR1201MB2554.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 47+nuVDVB2r9rXznRhV8l5x2PVfmDMkSE9cty5Vau3F6ovPSiNZLuBVGHcXuKI+Iwx288SNF28Ugos3lAAewCYAZCeP/HiU1vhD9fTEt4B7Za9JZOzQVipZdxiuzGD3Ue93bb/FrwkF3FWo9zMbZEWomWfCVf4vnhbH1EUbXtXoKj00X2dZVHBWU33vmzqKdbQSX4bh50OC44hgiDVlJIV3mPvTWT7auVl2Fs9C3qbbBzdeD0LhBU68E7eupyh08HcpyBwc6eqc3cT6j5k5qknvVCoxfW7o3B9ufK07gYqfFdCYYPMj5Y0yoggsyqwZ98vAFihDQA8WfWP9JrNTlWk4QZb1P+ZA8crQ+CQLUjkLHKtTCd0za80wKZOA+UaJVy1h0VK13bsu2gJRY00rdgGUKvibnbJZQipGqYsxvH8TkFPfZTBDLaT4J1H9/cqoTE4zBhqmnXRVjDuQiD8/ulAaErCgNJTGq+Hc7OKAPEH+Z1hCjFKApyHr5I1XE2O+1WH7MLMYhWdk9Fd34S6BzV8VX63Tk4X4Y83Cuf6ZjGmK16HUz91o791Ld71Ax29fiwbQt9dpxcK0aRpH/guOdkfX2klX+YptSBCRmXfAG2GcskJJ9L1Kfd5JWyhRBIkY8b26UXZxwod5N54g86DMKmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8676002)(66556008)(66476007)(38100700002)(1076003)(6512007)(2616005)(8936002)(186003)(66946007)(4326008)(36756003)(2906002)(6506007)(6916009)(54906003)(33656002)(6486002)(86362001)(316002)(508600001)(4744005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y7AZlpWkLiEPntYedhp8sIaHYY5bnxLzN5avbZGONIVtHIsCQYq1xaX7Dtu0?=
 =?us-ascii?Q?8v2u7m0z+4MxiKxTIEB3Fy8jmM60/pSQKjZwFkH1EbSoBsptOC7WplCjPSOX?=
 =?us-ascii?Q?/M5+XotmT1lGzWsyOl6V7Z1YnTpnI55GBWIq+COh2WpQO7HR0gL4ABnTJjtU?=
 =?us-ascii?Q?gE0ScDyKAwCxuL+j9ijkzxq8HkL1IHXM56jnlzK5X59duWOkN8dfWJTH11KL?=
 =?us-ascii?Q?bo3ppzpmTI2mKuru2a1wjVV1Smg8nwGwz/GAAW/djWYE9688HZ0xUxcsdsTr?=
 =?us-ascii?Q?rkzb0ztCg0L7kuEQ9J6ijY93E8r7J9d9/BqfUNJ7Y52tSI4H3S0nzJtvzgDP?=
 =?us-ascii?Q?cmN/EHxHdOOGZkcKLERHvAsqaQsFy208EfXlx68ri865WRhdR94q0/XU5AYK?=
 =?us-ascii?Q?D1Ja02luH+kqNImBWr8soiEGGPq3aadg66SgwsG94flzkJhluXvDZ8Eo9S6S?=
 =?us-ascii?Q?F16/MF1y9H1gLLtUL9e7JAa3wHAmcuRkwvidONAv9E4hwJTXYSzR1F9XesGl?=
 =?us-ascii?Q?v3XPr9shiRcN7PQirE/rc3SkfZnniWAaZdLthXSRg9HB4vOmFbvffKoklU6d?=
 =?us-ascii?Q?djWn4oEcUWAeSOp9SFGtT/qrGD8fHi76oSy9Mq9ZqWHC50IGQZob7MP/xsnj?=
 =?us-ascii?Q?4GAmXgObwbsBnOYoEf+9pFUBgoK5quoe++IsaxzxWTQYehsEqH4ILWy9dUm9?=
 =?us-ascii?Q?olzcnIIppB+KK0CzGuyUNu8afDeVP5EGZiwvyAJ6E4EUfZLgJ6nkkio28Pub?=
 =?us-ascii?Q?hpavaqmuqtR7/Z34R8JRYAZWLw3N+cvnB+IfXzCNZ03ISnASgY3+bB9g+CbT?=
 =?us-ascii?Q?CW/F7jLfa5KCW5QiylokAAtBLx+dakmpeYLHuCNr1AHmF326OH5pAjC7C23L?=
 =?us-ascii?Q?lJy0eOB8yye4GuE+14zles3lK4yS12NRnq4T3EWHhIneD2rwf3hVO7VpjLV/?=
 =?us-ascii?Q?J2sR7I6uKEbzzHimjYqalIcoVGTa/05+Yrxf8TLEdvDx6TG/f2PEiryoRaxK?=
 =?us-ascii?Q?Xqrtosic5YdLW61zKlVYWAWwrWMmp0PU/Ez/DCG5XcdCd7lwUI2wbjG5eGxJ?=
 =?us-ascii?Q?OR6m3G+bo+pPcoBm8eWoh9uge1OzMNy3Vu+wykJ50hPgMWI/QBF45qQavvxy?=
 =?us-ascii?Q?kIgGIJR7W2mm7nhseOir60Lg847zXJW7H3Hrl4sqedmGaj3lJheSAok/R/lH?=
 =?us-ascii?Q?Bk7aU2vdYpCbxjZj1hxaBpEa+uI/27gyvj8Z6vHq3aTz8M4UMk0hkkNdAR86?=
 =?us-ascii?Q?xmW97/PQ3hIF7g22UwMTBRa6Y4s5zvd1VKvNjRDcCEA6t/C074n7y7/KcF91?=
 =?us-ascii?Q?RjyW9UdYuobc45zIWt1xlwsonggwkExVoZEFZ4xFD92LTyfMdfGj8CqiwHG8?=
 =?us-ascii?Q?ch9A/HRb2CD09lTv/WvYnBKGhN3rAJN+wVwvPzskNckmk+900MDQbZONgcNb?=
 =?us-ascii?Q?hLi+MfPf0Jjfffq6gxqlemlxW1MWIn4nLkiPFuOMk2DCpRbDe25cH3NdEJy/?=
 =?us-ascii?Q?ZTYhgSFCrgjcdliFdOdEx6OkbzEVFchHeh124yODWwldK37JDNI77V2Q3D1f?=
 =?us-ascii?Q?VV5gwzlSBIosuDIVQyUkvJ40GLSj45ZMbBxor4mT3+J0ZBAPGc7FYiiPC6TH?=
 =?us-ascii?Q?VV6xJYHUxsjy25qh4SouFmbCQPX4BPW/tWEg4320/gzrM05hkvl4D7Luis2n?=
 =?us-ascii?Q?/dj179Xc6cZ28nyF8LMHB3zd7Ub0gxRJULBotePzefKscwrLDG6oxixagKp4?=
 =?us-ascii?Q?FuNR/aNAsQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 348009cc-f9d3-4ee9-8e83-08da1ed9630a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 12:13:44.6125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4f6goDuHY6TE55YbNCvDxgeY4nlhFT+WfxPCXJbC20BwQfIlY2Lf4QkXSt98kOH7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2554
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 06:47:31AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 14, 2022 at 03:46:01PM -0300, Jason Gunthorpe wrote:
> > Use IS_ENABLED and static inlines instead of just ifdef'ing away all the
> > PPC code. This allows it to be compile tested on all platforms and makes
> > it easier to maintain.
> 
> That's even uglier than what we had.  I'd rather have a new vfio_ppc.c
> to implement it, then you can stubs for it in the header (or IS_ENABLED
> if you really want) but we don't need stubs for ppc-specific arch
> functionality in a consumer of it.

That seems like a good approach, I will try it

Thanks,
Jason
