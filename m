Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE2F5EAE5A
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 19:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiIZRlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 13:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiIZRlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 13:41:32 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2073.outbound.protection.outlook.com [40.107.101.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E250760E6;
        Mon, 26 Sep 2022 10:07:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrYr9elmokJYfRr8saNIToCQmV2SwY0dBtZxzvar9jjHdMAyMKFMnLGFLtZIgdWtQu0kyJSM4pfkgTsY3cT1t1MOs9T+rIMFPlfJOrfeNHWoFIHOC9XCzdHjTz+cg1QX5eKb/CpHuDUtCEm8uuZ9oq5lII66oTA8vtsLQ7CCvfa1AQCuS8YSFV2bDMfImDrnpUzxmbHtXcTRFHDy/bCal8sPZFKwQ5hg9rOqP+2dZMZQZRP/3tyA33NXJU4VwpGXhPPTMWDPn0of9rAh7NRdGIrC0G4qI87r7VlMIklMegPjFB7Cea6THrgP4WC5ra38vUCI1wjkie51CAZWwyteuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+at2YuWilhzpnPdEqOv0g4hzIIGNAd0Lr8MvKN727rM=;
 b=k6Z+n+B1CWyHQs4T8/KtCsF4g8ErSu/WKAylWkfofuuaBj8AF/z/9BdWZXbuzRz8fIW00tvq/q4SXvtMCxKO7hwFs39LbF5WskVDiCUPihiVG68vFDGMEQLrcChCfWAqU/57j6fQufNT3VQhfCzUHStONw7sYPZ4kGaaB6YSA6S6tbOPxYMJbphy98zSJQ3t1oELP63YtvfRD5+4nJP2JVdz+j4sJe+g8DS7h62MRZn3auARPr/ROavNivIOkFLe+pDm2GrSoAt/9rtWuBhOMNlYZm+FgQMzIvFNed21YxcsDX5c/16gTGFU7Z8mgoDvJKSTImTe7qGpSJ/I+tr7Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+at2YuWilhzpnPdEqOv0g4hzIIGNAd0Lr8MvKN727rM=;
 b=OwJYuFC1PHj+A+K7peJZD/HPG4690XcLMtw70JJRB/I/LrXTRFBxV3nrCLmkiEce755K+oEPzAnvOYyFlOqBBBXxM5un1DhhVFxTxk575OLN4+Gja5SfZtCF4Fn9yTp8nGSHu09LKWf4Os83wDj8ddY0fzGhZ0UVBPA0WTVnI7EcF07l3RHIQG63wHLAO9j3AsF9rwOrYIar3Qtwew0uF9aWT9N2F1qs4LpF3Fs5AX8PnHmAOBPSoZKQuhY4pK5W3g10l7PyQiuhaf3JZDyZ6Upm6dKWMo973nJbBfNbkCwMZyH8VikihRmFCxp3Snfsdot8Kda24kIIgBjvS6oYEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY8PR12MB7588.namprd12.prod.outlook.com (2603:10b6:930:9b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 17:07:46 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 17:07:46 +0000
Date:   Mon, 26 Sep 2022 14:07:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Deming Wang <wangdeming@inspur.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: Use filp instead of fd
Message-ID: <YzHcX2VLh+0n2mAP@nvidia.com>
References: <20220926065407.2389-1-wangdeming@inspur.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926065407.2389-1-wangdeming@inspur.com>
X-ClientProxiedBy: MN2PR06CA0024.namprd06.prod.outlook.com
 (2603:10b6:208:23d::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|CY8PR12MB7588:EE_
X-MS-Office365-Filtering-Correlation-Id: 69cb57b7-7065-4366-3dff-08da9fe1a13a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1JKnAASHNFWqcQIL2A84+ROklnT2MPXsdrXgH+hiXdroRmuT19g8Vd7XeOviejSg+iyHdCyPINQ0Y9gc8px90BWNBGGe0jrQ2SibhE9HFN48q+ZqhDOKkq5fOrIuS0J5f1CofiZoxedBHOT44Lj5a5fJi8nH7hcZUUBlpQMli5aN8/Y4MKa691XOcZx87W09hAdmJKIfT5C47qVmjccGfsyAW8fbniMs1XTIx7DQKIsjfnk1JEZkVrmYSglTk5MYqsuqhIZGk4uQVQ6iceH5cXX6Tze4ruxZe40LWak0loRqKvKR8pRuEMLL6YPtfaYMYbE+GUQuMEi4ix2Vz+sQvTtFldqNuYf4Da4Y+dOFY3s5CJ3K5bkYVCFeYNnPnnw6e7lFUi5v8dlZEQ0Y4NivYyfFwfrJSrTdVs6aZi5KbEQasFmPge60Rdmc9c1AZoDI7ZCqddiSfvPcOkoo7MvPqDhUwiIQ1s7cNmO6peo6LGrj7l3fLqrrPR9St+pBW/alDcx27Gs3Gv5n8rQ2CtJrd1gEzur48m/Oa3owTAuvOETXwuYgzAb1PXzVERKCspBlC7P4NC9etnsqXKmA+LdKuh/vARF8yBOJX6blcoF74OLtpQkZn3QGL9xknfLGNcSSMXRVUDzsh2uDhTfvA6/daW4m3LitzqegteOdDSiH/QeKF1CWN7Wb5LV7mZXZzk6FiaxLKQ9+JWR2oY9829jIZtHfMyfPANfTzAW2iKkEM5oJ6OktNSLhkEUJlO3lZBN7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(451199015)(478600001)(186003)(36756003)(2616005)(83380400001)(38100700002)(66476007)(8676002)(6916009)(41300700001)(6666004)(2906002)(66946007)(4326008)(8936002)(6512007)(4744005)(26005)(6486002)(316002)(66556008)(6506007)(5660300002)(86362001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V5AEtnTMZQYEHN774qcvfOlDsrrvUUjQYkrmRJi3xVxXNqG++ip+25uLLxOJ?=
 =?us-ascii?Q?metxOa3QLS6MBjdx833ODDRD6bRgceRjHVBD9VfSzDScUXizMFnB0lZPQ3ut?=
 =?us-ascii?Q?+nEX6z6MxS39I5Rq+eTV9d311coz8CWana20eH1ZB+BWUfptShv6Ac+5FlrV?=
 =?us-ascii?Q?sGg6QhP5JfNBsW9yTfP29S6MgeMphqj137Pk/ZyGBRbtaKEMhaMX8g68f5aD?=
 =?us-ascii?Q?c/CWju6GRu2s3UVO4nCyGsd4cM52oZfkGJ3t4ZuC3vkhZRH4O7yRiDWpCcCS?=
 =?us-ascii?Q?8DWPoKGVMQ18Ywa6pXQf+Re0wDYFcpZO4FiLnHOW9eTO55Ktqa5a8FKyWS5s?=
 =?us-ascii?Q?XhXA1k9kM4B7QSYPdhpnrpc3ZspJeU+ei3JSKXqC64WAn6j1GVo0MN6QZpuE?=
 =?us-ascii?Q?p7QCYwOBzKq6UExDS6uh1GY5nhbZFRnfD7Jfzxtr27UkHY/8/VfF+HCeLVDI?=
 =?us-ascii?Q?fPUa8+tJIzonn5RoPkkXTBKaj8BZEAVp8LxHyKbom13TdxfTUTArEWclmIyS?=
 =?us-ascii?Q?jNFnWaMLXH1ZNsYe/RfN3elJZJoGXL0DbT1/vFaGpvEOIC4qxxt7NKs6deJc?=
 =?us-ascii?Q?i4G4/YKqOtsVTEx88swHnouo6/2Z+ZqGvNfNv/GWX/NUJRbdR3PMmQ/rKzpE?=
 =?us-ascii?Q?zgl1ygQRjPZnVuhgFLlBXDz46XszmOHA7OD/foHo4P2/U9M6yA6jgFip5ZST?=
 =?us-ascii?Q?C5H9LZgNfO75gRgY5GHUCQsRlpZhm77FTc9Sl2umKUj6FDVakqR7rKHPl5qZ?=
 =?us-ascii?Q?ToGJkk7e8jA6zn+neQUkMr70hN97cijfQKZum8mrxx2TIK9pWnCTmyfhL4o3?=
 =?us-ascii?Q?+MAPuzY+hk1/I7laZK3H6J6E0cAxBIr0FRIXdllD5c0ZBhzinHyXXVlEjQpZ?=
 =?us-ascii?Q?mtQD1AGxOkGztcex+4dzYqK8Rh4nSBmCRwdF7//0RHeJnXz/WbeZ/Ty8C58j?=
 =?us-ascii?Q?i9IOimTTm96ES5+orjyzdLTf8+hBUR7ZqQU2qNZWQuQBgU7UkzosnBQauCi5?=
 =?us-ascii?Q?XVACuNqFzMo96qOgXlLZxuy1QVBOcDqvB7BzcZPooNLG6CQ4xoeFuzBocLnT?=
 =?us-ascii?Q?S3nMecTQFfjyzPxd3duLfmnscbN1nl13v/hTY7rU/DMemPDQN9Pexb4B8ZOc?=
 =?us-ascii?Q?1No067OWA2yUfCq2W3/bMam1GFrauRtd0HZrLbJ88vCjDZGMauQBOCJHtiRr?=
 =?us-ascii?Q?nZeg8hmeKySR8r07CkfYvNvQ8iKA9f2ADARPXWPgtYFl3qHPdYijDfeI59Rn?=
 =?us-ascii?Q?rjUxAWIXnUSIWzApUNaKihHQ0Wedzu8fai/gagtqRPdnuj1w4WQrQ9p1R4Db?=
 =?us-ascii?Q?KZDDDNDm8DSXJj2bnFM39pvZurjPLLQP7zVbkvDHko9I6meqIAd1+xvU+/qI?=
 =?us-ascii?Q?iYREVln0SYMlKGuT9N0az9qB7fecoq4Rm3hE0u4ep6Np6nkFeIO6gbJV1PGI?=
 =?us-ascii?Q?w3wC/TQ4J8M1XgKCwzYD72N0PWAd2XH0t53Y990AqZo9d74Ek4Gx/WXtsKrH?=
 =?us-ascii?Q?Vx6n3Gif+4vv4g9QGaqToydKaPCP1JxwkpiReNV680zD1G0/tDKbG4ph1sNs?=
 =?us-ascii?Q?7lec6ktFiv9cZswMsy0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69cb57b7-7065-4366-3dff-08da9fe1a13a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 17:07:46.2139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fjw/IJQeShqB4iYqwdohUWp/1x82eGcb5dEo5j/J+voAKWYtlAnAGvjWvb/8ynkt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7588
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022 at 02:54:07AM -0400, Deming Wang wrote:
> The function of kvm_vfio_group_set_spapr_tce and kvm_vfio_group_del
> use fd indirectly.But,it only be used for fd.file. So,we can directly
> use the struct of file instead.
> 
> Signed-off-by: Deming Wang <wangdeming@inspur.com>
> ---
>  virt/kvm/vfio.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

I thought about changing this too when I was looking at
this. fdget/fdput includes a tiny micro-optimization that is legal
here, however I doubt anyone cares about performance on this path.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
