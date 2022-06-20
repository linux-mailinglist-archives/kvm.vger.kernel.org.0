Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B442D550F0F
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 05:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiFTDtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jun 2022 23:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiFTDtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jun 2022 23:49:16 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2069.outbound.protection.outlook.com [40.107.100.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16C460D5
        for <kvm@vger.kernel.org>; Sun, 19 Jun 2022 20:49:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEtyBc0UJpiuIZOyCCBmxA934o/dLx9hh+OHBLq6ckN40AFpHvv5HDcs4T9xKomOUp7p1AwWdaSbj/zgdUBDVemLezj5TZ69V5hDnjJlVLpMxYdHxL1AIW16s5iISk0Ijy2WEYc0o8yfKa5sBH7h7R+fn3qbf/Ol4oVzdWk+7AWLnHXTYvs4MiWEFBlC7HhdosaYhXYIBa80pYhdFluEseOX67d12jnf95OX0TOBvhLIylcLXXQDLYKqMfbIzzIWq8C4mFC1GeEn/XcEeG3KSTMunQrVaKiuN3ZhQa0DQoqhjtflqoCm+QkrxUsHki7YfJt/30rQyHdv/VRT93koQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9rIjDacMX6Oaiek21Kqs7DVw6Rt9dzpr9mWQQo/Csc=;
 b=D81sRcklQTbP6BsNTDlTtFNNXAkLEtQka9jB60ZPM5j79Y10T5iJvt0HPbahV/ngibqiY1E/+6ukCzs5fHWWu5/C4CW6n1uW//iAhQin+Zg9IdvsCwzsC2MmXr8NUgPIl59LoBH8bktMCi3fgdshmvMK0FF2f3qReJjLDn+aFjenttEkDv5gHVfl9CMnsr/RMQ8ZF9Qs/8DpaVtmzxd/KO0nYeJQkIDM/gjJ9ZkaY3NgVr3gbNAgsSDHshDJ2xODGXg+cBFBCzfaITdytafKtAQXS/IPWxpdJnJikCoQZo8eAOqDpShdhj1UKiASvwcECNCJh7w+7E/Bx7yNdL20bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9rIjDacMX6Oaiek21Kqs7DVw6Rt9dzpr9mWQQo/Csc=;
 b=ofHTvBVR+tSwdkz7ApfXJVb1VsuUHNsykumSATpsFHfX6UL+boU8OkJ8/Ffp8CDrjIrYYkEn0OxXVph0TDmGbjbN9RmneKsFbfCc1+RWdUIfzXBPQbIK1JxOoGkK3LT4E80J+jzqUtvYmf7w59RSeuFs1Rcz1959PG/XOeEb0AY/J5f8Vo7I4sFGaadR9Riw4owC3cxqPdsXFMIgSiPYRcsqLytl+pxoqjIEnKz4Dd50qefz9CBvHDGMXP6/bJXgUD5fP8MYh5XZ3kZ8ELcSxv+S6Iryo2QNPjyNCdehSqbztqh38onRCmMREz909W0oPUVbGiLyVNGRYAr9HyNXxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Mon, 20 Jun
 2022 03:49:13 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::5e3:2d1b:4a56:f21d]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::5e3:2d1b:4a56:f21d%7]) with mapi id 15.20.5353.021; Mon, 20 Jun 2022
 03:49:13 +0000
Date:   Mon, 20 Jun 2022 00:49:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        liulongfang <liulongfang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Message-ID: <20220620034909.GC5219@nvidia.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
 <20220606085619.7757-3-yishaih@nvidia.com>
 <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
 <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
 <20220616170118.497620ba.alex.williamson@redhat.com>
 <6f6b36765fe9408f902d1d644b149df3@huawei.com>
 <20220617084723.00298d67.alex.williamson@redhat.com>
 <4f14e015-e4f7-7632-3cd7-0e644ed05c99@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f14e015-e4f7-7632-3cd7-0e644ed05c99@nvidia.com>
X-ClientProxiedBy: MW4P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::12) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96ecb19f-aab1-4452-697c-08da526fd748
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5609:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5609252749A94833DEA95B91C2B09@SJ0PR12MB5609.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gk0wCRikFjBT7ENxOi0NaMLAEh8hYBHJQLCjlH1avOUPSa2+flYjm+QkgmruJy4m1ZW6VGK22SQPsHSmTr4O0XoaUJ7hBKNhHPbjZ7DsAPvbwbjnhs+/nbngMKWMTzSn3OId+DKsc4o2CRaXEaXx4oqHi1XMKVi4pXEMbGAHf7CcJ76VcEHvzV4J8sumj9Mlc0Ycc17NhDDOHGF2jmXngDLqaV56IHv8usrF9t6TkgLkho66A+QtafOgsfNg06Udc0pMYrLhKUNAG2rxXgafF7/uro5p+fi6eQ+304ihSH917SQgE2VeB20CEar7YtvW0kd2dqyJkJyJ28Th7R8Jlq+imK2inbi1DCXLJ264ztqrEjWdfc8/ar1MXQkwDZX+wwwwvoLUoCtl/XxhtWWFfn5tYzUWudhKhn1RiMkQgI8nrv+WQGmkE7J5O0f117fifA2XI3qme1N4UH3kS+UxuVwIYmL6PTwXQSDnaT/hXNmZjOfFej6B5XYJ9BZ4R8g+yFTE3wy8PO0eDitXt9C8PRoNVqH3jLMvjK+UlaZhVG3nDtEckSVEU7HvHyoJgxSWu21bJ0DZyEV1HVwJvxroXkNyxadE4RpWnWN76Zb+CT4Y3Q+yw4kPv8gN6zo5P2kCEyh1q2se3wUsgTS8C3ekog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(6512007)(26005)(66556008)(2906002)(83380400001)(6666004)(6506007)(66946007)(4326008)(54906003)(66476007)(37006003)(316002)(8676002)(86362001)(8936002)(6862004)(36756003)(4744005)(6636002)(2616005)(5660300002)(498600001)(38100700002)(6486002)(33656002)(186003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c+XQ3H7mix5qVzjwN9k0snvqLHdtETJPcesDfHXDCmZePWsHSEThMnR+W+iQ?=
 =?us-ascii?Q?Ys5mJZvPr9Zk6HrSxHj2pK+gUlJbnIOR3uv9hz+XDuLKVUMgpapMAdqsA9/A?=
 =?us-ascii?Q?WSDwUykW0dqqzIb4cN511w/shkZTQ2T47BmlpIl0X4oRIPs6+NZMCQ3uesNR?=
 =?us-ascii?Q?sH7Gow50xCWbsimo/pKpyb+jP3+Sz7p6h7Ky/okJW3sJQfffKJvehHfe58zR?=
 =?us-ascii?Q?UgU9T4fwQC1C+bVU3O1e3UoGLU9VFq6EAWGAR8wl2E44PQbI4XhbnKKjPDrY?=
 =?us-ascii?Q?itR88FTLpdqK0zKfCcGyfoSYSeqfOTHJNlVcR8O82rIH/6LZGeAAASRozl5X?=
 =?us-ascii?Q?OXEMr6z7T3OL8iROMmUJL5qaktlLwfFCuq1/iJgoLQWOFZmkm4xcwJnJy414?=
 =?us-ascii?Q?uDKW2Wg11anlI4o/jttfiGs9PZoe1TWBoinmv+M2flGYdhXJ/kr3yqamwKN0?=
 =?us-ascii?Q?cZwaTUgiVtIMCWC1JvQj9yXlT9lB/ZwW9oNB1uyMnrEPBz7jixrkqIAnkoH9?=
 =?us-ascii?Q?2fvgIpbHuS9ncYiMsY8oLoKtx3zi5DQW+uZMtDXhmuTQHms+zOriXu/vPQ5M?=
 =?us-ascii?Q?G8O6zlm/TRioCpO0+bgY/rjCdWF4PgvEMkTtZJpX3SFs9+60BQzwwqrS7GHO?=
 =?us-ascii?Q?50HM1J2gkrdUqIBJuRWQof8zGrX65SLE0v/4tburt5andwC8MUKqgJT8mNhY?=
 =?us-ascii?Q?XKkZKrbqF+RWsnDr2bXLlmshpkzHZnCWi8wOtnGWt7Rg6RBoN5a1CtPY7NlH?=
 =?us-ascii?Q?zzf+S6x7s2uWfqkQWIQzCajbot1t/WiyLdJju+upenKMX6qEOA273CW9yHP8?=
 =?us-ascii?Q?VXNWcmCL2w6Z66bkshiOac50TN36Et3GuGmxezDd6vqkR+WElcRjI1lYTTo7?=
 =?us-ascii?Q?+4sDVCqluPdAC4Mich3jtciZMV5a+FHuMS/MDpc5tr7qN4B+a9xp9MWq6r3J?=
 =?us-ascii?Q?dtHy5JGFl2YK8X16fVGz7XgfRHtoE97ipSkCw7ewsi1qnshzhzKwmrNoDJeK?=
 =?us-ascii?Q?iqv5IUnnzCz4K8R6MRaQ+Auloi1THBjkEeg8yXsSTgdTrZhp4m/y+RbK8Odq?=
 =?us-ascii?Q?Rs41EWehGoZ60dRAfoMqMcjNtp6DMk77SqnBmj2Foz6Qfin9Vu4N+ZU+nNbA?=
 =?us-ascii?Q?A0jdE5oFSPSQ6qCVEQbdpG8X2IYXwR6qUJKl3gyNyPwnaOVXixYezA0j3hUS?=
 =?us-ascii?Q?lX5qn/J5hlLA4KUAuZxxP1c4a0CEXy2Nl6HAJX1gdRW8fnpcB6pefwM08Yr3?=
 =?us-ascii?Q?qVhkQ4CaTopik6FGw4GeIs313S6fhBSMzOe1r4oBgfrFFBvogkUAAsrK3h3J?=
 =?us-ascii?Q?PZtjNip3JA90OiytFl3sII2wE1e7erXyUWych8PMF1idNHHPItjvSciflelT?=
 =?us-ascii?Q?dCpzcgZ9IjjZtsVbyN+GKyxXDB3sVSKDK5dwrVVM5FBV0Ogw2RzmatZ3vAG0?=
 =?us-ascii?Q?bGXI1mKw4MXgdHCrN/cRxJCwp7aIWlDjR05xuWrlvcXe6mFHeE55kCGrvLvA?=
 =?us-ascii?Q?6KciFcGCXhEJzPVg7yt6m/Oi2YC+cp8loOC7qdSmKhrCQhB5TxB3uUPhUVzr?=
 =?us-ascii?Q?/xR6nccN7gb5ZuO3+2nOm/orqxzfKkMZ3BURUzgPb3601seoHELy3z0UEYxO?=
 =?us-ascii?Q?3OmsuNp+Bdg8bPEj+OtEXuuMCJDo29v/kt7lsNFsIEXhDqbAdobFiRmeUA9O?=
 =?us-ascii?Q?CNwsNZklazT6YsDULOb7JhC+P3joLqUcWmvrwQ71DVZo9PB6hHYY5Z72KtW8?=
 =?us-ascii?Q?qr3YhL8W7Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ecb19f-aab1-4452-697c-08da526fd748
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 03:49:13.7258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LlxdCyYxFkaKGTgZTE3qFiVyjhps6d14sJrOklzAEWDlsb0EI8k9YzMkHVkakAFr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 19, 2022 at 12:25:50PM +0300, Yishai Hadas wrote:

> Means, staying with a single device_ops but just inline a check whether
> migration is really supported inside the migration get/set state callbacks
> and let the core call it unconditionally.

I find it much cleaner to have op == NULL means unsupported.

As soon as you start linking supported/unsupported to other flags it
can get very complicated fairly fast. I have this experiance from RDMA
where we've spent a long time now ripping out hundreds of flag tests
and replacing them with NULL op checks. Many bugs were fixed doing
this as drivers never fully understood what the flags mean and ended
up with flags set that their driver doesn't properly implement.

The mistake we made in RDMA was not splitting the ops, instead the ops
were left mutable so the driver could load the right combination based
on HW ability.

Jason
