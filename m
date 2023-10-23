Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2847C7D377C
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 15:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjJWNMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 09:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjJWNMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 09:12:36 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229B7C4;
        Mon, 23 Oct 2023 06:12:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAzsWGcwDv/XAsflgk2JAUwM1ml6bBD3pE2kzZjAZpuw8l4OXSyl5+UB/+q0LubjvcQl1nHby66J575MjuQyG3fqFy2/nCuCj1uxyhhZQNHfxqZ+FT1zCBgqk7YSV26Se5iCVYJRZitETAPuhwG7CgyWYDjr2va2vl4TwEhA3NM4VE1T9p7e0YAyLsjYRDVdj0lRz/MD6w0UgCi7IqaqkpXmKKEhR9ok/C1quEp1pAaQxZG/huZ7S+kLS4em7w93BUQfntEgQyHeQQ1+a2jDd53nw9qn96zD0FwnNlsbqgwtnatGIDCOTqxXQz9LX3mWCgU+uYINoI0Reia1NZS09w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mVUBWXf2sjMoeiIiHjwUjG8En+S4rTqVwWxUOgbQOPs=;
 b=b65kHyihRS6OCAO4CMxGxPuCg+6Y5exgnpbq8wmU3S5hx85Yu1dgzB7gzb0Qm4InT25Hce1TipXsovYhGihpBSTDDPoWm6u/WcCYXDZHh/yKKWj2JOJndU0mmSBnsDkd6/X4PPk5K+gv1ZLfv+0iBpN6K766kwfKEXHz8XoTgZW4G1wTIs+xK0uN9PdNXDdKW28w3sRABmt1drX1T4uy38S96Py7+nhlcpZLYeHfodC3ULAa9i790BpDV7X2X+MElklguoIqiGjr7KJTnPbkJYFhq9P+rClzCEmbrfDHjR30catGNfnfFPXjbYRNbEGAaeYeSV80xTJKbDSNcoGzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVUBWXf2sjMoeiIiHjwUjG8En+S4rTqVwWxUOgbQOPs=;
 b=ry1NZR1M7Cy/3bOKtm7+K6ofjDk6kKHBGJrfOXSEm8sqJxwJ72AAcwqqp9eaHPLlq4jaGFwautsZyFwJkPa+bfSTSGqYf+1Q0CG1QdMMLqA2onMleObue8D/WnevYeobc846UgbRlRQZ4NZvwb8q7xlUZGaQXQRUnPCUHSNo5gDfmljkhgSgRZJBi3/wHacFAqeE38yTfeWmpPg0UvxZF4nso9plfxYo0l605NAiB4t2/qxDT0o0bW3JGPJlKVl1OkkNxajFPvztay/L8WArtgJq0p3tdz/kuLZyClfSPJLPH0tsWWF7vmKwy9bCqr9rwPkRK1ZnyvsZMFcs225eXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB7950.namprd12.prod.outlook.com (2603:10b6:806:31c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.31; Mon, 23 Oct
 2023 13:12:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 13:12:31 +0000
Date:   Mon, 23 Oct 2023 10:12:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Arnd Bergmann <arnd@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Shixiong Ou <oushixiong@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: mlx5, pds: add IOMMU_SUPPORT dependency
Message-ID: <20231023131229.GR3952@nvidia.com>
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
X-ClientProxiedBy: DM6PR11CA0033.namprd11.prod.outlook.com
 (2603:10b6:5:190::46) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e92482b-9b6a-4515-d0cd-08dbd3c9b6b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A+HpzxT4ukXjupK/YiZxkmufPjg9GlMBMWbPSFmwwFE9+4IhetBCt8tglvahpyHDrtZPjrLIEJm7RDgspWz81C2uZqmIJHJHXbfpR4z55/bZI4513JBzvyetLgH7ly46NWSM4HLzh10iEgck7Go8sxbZ/vu/ETkwc8Uqa/csr8LIEAUeiNBsxwHwA/3gpvj7KPrl4TKRup976GwXDvx4v3Cd+V9bjE1YRhKjlWmj5MXyucd+ZomUHnXR7BcA3K8F9Q2QX48XlFfAaesr3LQWX5N1peICP/LCcdRSfS9X1My/X3NrZRAVcY24mWNTbIGliGrUsXk1+23IQwh3brQohVM1uheJBmB1keGgYahTgzfUrb8txTKcRbPt3lqMjrz4UctYuWN4LOX2NG0givNzxSC4/pL7PVTP9DT5ffz/v5KZpnYXi8c1KIsAqFVRJoeFN2VSxvAS+4GSJit8QQEUFmvWJsMB+Qg2awjzjpkKdT/K+mR4IwDWtQlLp9Kekp75evd7DAfuxPhVikTX2cxqEZFNkTmEHTbCyRIi3BM22KA0REDDElKJp5LhLQa0xHNu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(366004)(39860400002)(396003)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(26005)(38100700002)(2906002)(4744005)(41300700001)(86362001)(5660300002)(7416002)(36756003)(8676002)(8936002)(4326008)(33656002)(478600001)(6506007)(1076003)(316002)(2616005)(66946007)(66476007)(54906003)(66556008)(6916009)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q2iD850dLS/uK8ODOHiVBPxDDu4/nFL+KWkGVMR8HT+JwstJAxz74tKaMj0o?=
 =?us-ascii?Q?IMTNmgMrrciA/RsoG13DJ7ql3BktVll1dkjONKDcrb/AW+RrjEhl2OI1h0PN?=
 =?us-ascii?Q?HkYTj6XWlYqzhDRq+E7shaMSJslf2pQ4TVNCfULwX2kWvFSjAg/PY0ehI+lD?=
 =?us-ascii?Q?+Rgt3+556sv2m67kFt9z87TvnnJDyYoN3lSka0OUpC4Ew3YmNtMLtKsvr8gr?=
 =?us-ascii?Q?LANrhY01MsnDWGAFSUR+NcS4LUxgbsCQ+oNZ2U4MhsYcl7r/ERa0QOL2uV+W?=
 =?us-ascii?Q?m9yr1D9/LT7kggQbnE1eC4Rb5oKJYN/DTy44FPKZ+N37agbRcfW7LG+0Bvy0?=
 =?us-ascii?Q?fb/A2XCeHb4Z5ZrRMMCB6keUvkto1750D3gT6pxq9pZgo0nwdgLtFYP3FNax?=
 =?us-ascii?Q?YLjsVKuZezm+LMJOMX5FcuT1JPmjVcrGuS3Oqmxy9TyDk2jH/YlvT4CAzdc3?=
 =?us-ascii?Q?kFmleeZEmua3z3UQPoTvZG6FCZk0+og2eh0NJ6AdAnGE7afiVmlbRfibeYhi?=
 =?us-ascii?Q?Jh3VkvmXPJxD6p3qUeffp8UbjO9u4EAOYgru6COCwQxc4JhIu0zG52EqX4So?=
 =?us-ascii?Q?dbLtKvJPvmA1xbgCh70yjxIVa2ANuqwtojHvfmZc+tBwk5K32nScsO2JCyJ+?=
 =?us-ascii?Q?EUtxNJzGn11a+BZ445NscTsm1PGl6m5pfAr2i5b8C8ZB1hyYfaog+F+NO28W?=
 =?us-ascii?Q?C62phLZyMDZyHhb1wXq4G2RLIz4OEkEnzyUrlw/jJWy0sKL7I8v41j9QmpTr?=
 =?us-ascii?Q?KEdt+BtGOKB3ZWyt82sjyA/Apcl6bv6AFWNCudBCLU7NwqdUZmctMM+DNGIK?=
 =?us-ascii?Q?yDEM4tqeZBJr23WR3u2+pt+hhS0FEQ7d3jmAQcT/Z679QobLAcOLE+SDGNMU?=
 =?us-ascii?Q?Du/HSMs2GvZjhoahYMhzfgaPwiZ9zhlcdQ1ikK6qAldOrMZOg6e9o/dIt0eh?=
 =?us-ascii?Q?4SzR3NKbh9HWgxJmFFNy4M7CkJ+jBAQAtvbNOopj1Y16EAgIYp8LWIgBpkFp?=
 =?us-ascii?Q?nFhZmOL7MiCoE55aR/NX9EnY9cvaZFoi1vDvEEpUI2mbU5ucU/ikwB4bQ5qQ?=
 =?us-ascii?Q?x18SkS/HwDu9rGpSLjAVdooy/x0FsRB71/pWyB3CACBO0I5+XGTnz0HXv7We?=
 =?us-ascii?Q?3FcZ+uSCtfUP2VWzAT07KA07k0kRJhHoW5jmI6fDq182no82ly5LdaY0XcoC?=
 =?us-ascii?Q?5TYrzhVvQa3KF9H8JkSgrns35nNRSs+UYnCFk+p/oVekTZ/XPv0gNz4DfZhp?=
 =?us-ascii?Q?PA41obJZFU8Azf0SM8XqAFdDWJlyTcf7EO08FKINgBeHH6eIlGC1CiY47eUI?=
 =?us-ascii?Q?oLDd7Zpf/DYcNmFGxMVpEiSS4jQP7+fs8serjTrTmFfQbJ59qUui1Pr3zD5/?=
 =?us-ascii?Q?ULXNe3vjVXtlkbRgfJyFrwV5AsbiDADwKEmDwnr0PudThey0ANaNUfN3l08S?=
 =?us-ascii?Q?3xtOTtwBXKk6ApqRDd6pTq4VX9y9x6/a3Q5P9VzioBCy2xccGOA49NQp81na?=
 =?us-ascii?Q?ZgwcauizkbKh7bfDtD4uwzOrS/LiLf8EFUUqsOKkAWol4J6XZZb2oG5Gu7Xm?=
 =?us-ascii?Q?8cXRReEVIIZTy8FL1ic=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e92482b-9b6a-4515-d0cd-08dbd3c9b6b4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 13:12:31.1955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSkKckDYedXEuRXKRcnG2mLdyhdN7OlqPYwestrnqa7zay2Gkpjm93+fwy6Q2JtS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7950
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 01:37:28PM +0100, Joao Martins wrote:

> iommufd Kconfig is only included in the IOMMU_SUPPORT kconfig if clause; so
> moving it out from the iommufd kconfig out into iommu kconfig should fix it.
> Didn't realize that one can select IOMMU_API yet have IOMMU_SUPPORT unset/unmet.
> I'll make the move in v6

I think this is some cruft that accumulated over the years, it doesn't
make alot of sense that there are two kconfigs now..

Jason
