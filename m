Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38914E7D0A
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiCYRaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 13:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233835AbiCYR2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 13:28:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FE2FCBDD
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 10:26:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7w6UE5sInGLnR7L2egGtg5V70lB49ZHd8rhptpUBYq0PdiGNS7RLYYtIB0UNCsrNlczgIquod6QR76CqWm2CwgcO2Jr/IAMIIbOkfIVqizI/I932TwdB2S8ONOfO1RYBACzHVSQEia951pwbuxtRFByOr3DMV86HpHSgrBSN6OOlWQu6QlazdGLofDbj9pNn7hnEFLcLwPZ9IJL/ug4FMJEtXNn+xrY1SuKrQw1pSZ9caHdoL0Y62XqS+6M7038iZVjtvmwM3HR27dg6+AU/jX26HZw+wc6CW88HkIYptPQD9gqjP1NkB6+D78BhmAmB1IqZ/k4DMgkjuzDBh9n+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zz9g7kzYr7JjSnOrFeMU0gmbdX9n54BWo6cjFDe8ilY=;
 b=NQiGV3jtn4FzvdO4j0oeMO5dMsH/PqvHFD8o2slPx17glb8px/plvZvLQVChNfafm0Qlag3fAAJfvcAU73gAKeeWsGI4+kEm3Fufyh0nwLkjzR02Tui78sUdtxJ2fopMqH4O0JVLu0BRydTFkiaK6zx0dE9iujPVIMS6Kfl5H2jIIXy6KnZ2mQALqf+/Po8674dJYgCSZufuwDAFzj5OKdZjgvUimt9FYKNStFOqKICCeH0fnS74TaBKHKv5pK54y3nHMKKcp/IgAXokpaY3HtRaoqD832gZd15+bQXdkp7i90LQrd0W0QddZNSMJ/btnwUSJGTvQxayzss+rl1cUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zz9g7kzYr7JjSnOrFeMU0gmbdX9n54BWo6cjFDe8ilY=;
 b=gbdxYi4emdWKwQ4LKACE4WNtI9YszLyhsMJIKVHMOSjAxonYSGOXJCCya3p0wb7GxDBlniQ75Wv4WaFFcRNZdr7cUSugVrBnjPViZxTjyXarm+bJhLmZwtNnbb1nt85jhaNpo2dVHYvysxqHHOdYOXx96qwomer/naNebnFDHnOJmO9FlJ6RSdWGJ91z//w9giJBao2TpjnjSIck9x2KvHGbtZAcXmlC7RGGL3Kd4HjjQhqsFtuN+UfgHLUK3aw02gK3Zs+EL1KW4QgXw0u+7KSJ7UMmp80hdoiROvP9WK+t6RgJxFDw1VTYbZm/NULpkKs27/nMjkYZKDAT9CXi5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1137.namprd12.prod.outlook.com (2603:10b6:404:1c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Fri, 25 Mar
 2022 17:19:49 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 17:19:49 +0000
Date:   Fri, 25 Mar 2022 14:19:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        iommu@lists.linux-foundation.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH RFC 07/12] iommufd: Data structure to provide IOVA to PFN
 mapping
Message-ID: <20220325171947.GC1342626@nvidia.com>
References: <7-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <tencent_084E04DAF68A9A6613541A74836007D02006@qq.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_084E04DAF68A9A6613541A74836007D02006@qq.com>
X-ClientProxiedBy: BL1PR13CA0272.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2196002-bd22-43cb-8d56-08da0e83aa8d
X-MS-TrafficTypeDiagnostic: BN6PR12MB1137:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1137E2ECF98A434FE2D8F099C21A9@BN6PR12MB1137.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A0jDypgobEmiPxFV0LurhP//GR1VN0MpnVQ2Am1LfGpauz6JgP7FsnYil5ZYbufTC9hJ6vL4zl+aYc25liXFdQ26LydsNrSKw21r7C2NpFrMZioByUeOnWh4gqZDtvW19CGixXuWiu2wT62K/xAdzCfokTLRDUEIlfuWLXq6vjhWstz0AJMQP4Dege5Ex4LtU9DMJKg/YDl+zGL/vMxCAgXIh3DqqCrcNfE/E/ttlXlGaSScBm8/koAHw5oVjIY+R7EKKyODJTrVo968r5HBNuX6wC9w1ZhGQ6WE5IMTAUc4MvcDZ1fK1pKRy1FYN15AMmNHMtAvQq7ZvWGPyD+tUxnLJI9ojXFBZyyRkkxG+Fd/F0r/uuzLorzCrKFJk0p0bS9hUPlq5q1Iq9TH+XyGTfqL1bjWBrofis6tzK0UOJTpelGfJXBNDkYP7aHt3LFoaE1Q11OnbuAkEaxsxiv22Q8OFFnWbRIYdY+iFbwYncEWctg4QhMxWt5qSuppuN7Ad7AGNb2E0m6LcxCZ0AWN2ti1ebHwpXjS71Wj3d+SpVcSIhKVJ7bRnvky+nO1JepdU8vjGjQaSz7/kDD6pIeaeGPyNS4BLWeIYxMfYZkrKQzwjucm5PGTLYOeGl8Y5nphTdrLFbLLEdH7qkMOxPlfE03V/62V6jDwc+51wjtOnrapW0QBoCuPxBxwbsCFO338oxB+GSle5JeJ9cSytbSXew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(66476007)(66946007)(36756003)(186003)(26005)(316002)(4744005)(33656002)(1076003)(2906002)(86362001)(4326008)(66556008)(508600001)(6486002)(7416002)(5660300002)(2616005)(8936002)(6506007)(6916009)(6512007)(38100700002)(8676002)(48020200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hqEJ0ypJKKmELHeNIngqOZCjL0DoB0+an0a1o8q1qqxPH6RrK0zSzAprgGE4?=
 =?us-ascii?Q?UDKS3A14aTewmlpF13wYDHG1TlMiJC0TlfHsNqGgXzy3QwkipmFATOXb4zSu?=
 =?us-ascii?Q?76O2P53+UDABmg7bdUdXo7c+cq/z45buvnIH/axv3HzXAb9GZaxxO35vL5RN?=
 =?us-ascii?Q?JJS7dhc014+iMYG749nOiJ4TfUNCL0synnZsCo4L5SVn09iJ8eU2Z4tIjTos?=
 =?us-ascii?Q?f+ho9SomRw0E33RpsiQDMjBxsFZtec54MpDyrX1McCzmv5NR2VVytl1GhCQO?=
 =?us-ascii?Q?DkctANsW+ZAW6wvIaauyoN6nifGn2U/KddO+t6ezhWpWfunJZGaVVBkz4e5L?=
 =?us-ascii?Q?tWnlK/eR/evgAUceb40ig1lim71kGifiYPWLfLte+IolLZN+SYmg1U1rURHt?=
 =?us-ascii?Q?4m0QgMCG5vmmUZQmyXIOC8xWBqjrN2ucNrKiWvXLksEcyaFUcAhSf9ir7vkg?=
 =?us-ascii?Q?m1+BFK/zDNTQnVUVgEbPWirD9izin8u+Z8m3H2GeDMZy0twKtnkbkDIbswNB?=
 =?us-ascii?Q?DulJJP+O4L3cv4A5sEyginU2jeoLJEiR4O2wKx92NHYLagcqbH9EvERJPcvL?=
 =?us-ascii?Q?Waz0vRO0aq1gxAGeVPBThBwgBhUslWT567hUMoySYM0ygiOKGU+1G2EC+n+J?=
 =?us-ascii?Q?uQ4QpLIng1HCt35TqOHMEc4KJ3ejaTNJeJQ4hXbbc7I75C0+Op0Mt+fKDYKW?=
 =?us-ascii?Q?KIrN2HqJvmrzseOnYdZ66RyUvBGfVQBmreQqo5C/LokVmorcNxXGmNZFCPaY?=
 =?us-ascii?Q?CBNkP8oBjR0bcmqc1Xh3KQY7MSgZGthNIIQNtCHZNAyTcfBScPrMzSPT5E3G?=
 =?us-ascii?Q?iKlSMX6pvHDEFWccuJafX/+FDysMuObihxBn566Lkd6FwJLBRF5KdeLL9Jtw?=
 =?us-ascii?Q?olTfryt2HBR15vFUqxAnREy87DANcKHfwX9OQy7gkTKxbWzp3xie+9ly1DL8?=
 =?us-ascii?Q?nWS8PH4l9o/1x5hksSIjn2p9BdR5i9xr6gG3TQAhPyzQP1cCz3NOfOtXIHy0?=
 =?us-ascii?Q?miwzqHiPUe558zDRYwvf3IKTbpotI8OoerhtlbqsRevWNiLaqp6Hr6kf2GoE?=
 =?us-ascii?Q?Ou1LvurViKzRJ6NYTG8EmVGl0FIauga0J6bGxmqoPTltSg4Rax2l/2VL8aAD?=
 =?us-ascii?Q?bS+S4FiWIGkAjVOMLbvdunZAmcw+jeXMg9ZObJDXurg26oxGeL5FnhlgRkvJ?=
 =?us-ascii?Q?/dNTrFC0G+mMgdXzA7piKfpcLJVxM2nqD+d1xIagm02k8ojxmFnoihoE08QI?=
 =?us-ascii?Q?U6zLUEfj5jKS2KSSsLdBo3NxC1+9r9TE8Si8SWHV6zDoaxkZXMV/uTLXjjRD?=
 =?us-ascii?Q?Fy70mFh9DlyWCwU1qvnNFsy9IDkRVQRWPCAmYqLkDyurJrwi+TsEEWtBP3S6?=
 =?us-ascii?Q?AQF3wwiKxKVw3UR1e47CkESqQGnTOOdfNM9x//+2k+WqESEXe7DZW/gUbti+?=
 =?us-ascii?Q?qPU2eXzwQNV59kK1WAy6w5H6BA7l5RiaAOmNVKBnuGCHie5TFAjc9Vt4kReB?=
 =?us-ascii?Q?ndRD7ZunZfY/JH2GdS4RqU5aTl4JrD/pqoOYLn3Bk1ghOIP2oClQobuLs7Kv?=
 =?us-ascii?Q?0bhbZpzkFv9c7nfEbGrO/RcZ7R/NNbbvFoeB95tkNOffNGYMTfjq11d5yLij?=
 =?us-ascii?Q?Ch8zGs/ba+mucqI26xOFv1MB5BZ6+cQ9s5TrTWZopd6lb090HgwX/uZmYiTK?=
 =?us-ascii?Q?hcwdocsXpT/gWzlZEArlBjUiw4RvabQezqzZifD5HGScXrmilXFnvyKwYUMG?=
 =?us-ascii?Q?mdRRJdlUng=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2196002-bd22-43cb-8d56-08da0e83aa8d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 17:19:49.2816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGyPNaGJ+QM2H0gtwtxg7OzLPXH4KrEnPxgJm0D9FJTgOMKD4X/8HotFFQ0JxDRj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1137
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 25, 2022 at 09:34:08PM +0800, zhangfei.gao@foxmail.com wrote:

> > +	iopt->iova_alignment = new_iova_alignment;
> > +	xa_store(&iopt->domains, iopt->next_domain_id, domain, GFP_KERNEL);
> > +	iopt->next_domain_id++;
> Not understand here.
> 
> Do we get the domain = xa_load(&iopt->domains, iopt->next_domain_id-1)?
> Then how to get the domain if next_domain_id++.
> For example, iopt_table_add_domain 3 times with 3 domains,
> how to know which next_domain_id is the correct one.

There is no "correct one" this is just a simple list of domains, the
alorithms either need to pick any single domain or iterate over every
domain.

Basically this bit of code is building a vector with the operations
'push_back', 'front', 'erase' and 'for each'

Jason
