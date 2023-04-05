Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A0A6D84D2
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 19:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjDERXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 13:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjDERXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 13:23:48 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2049.outbound.protection.outlook.com [40.107.102.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC0355A2;
        Wed,  5 Apr 2023 10:23:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cw6DekOYj01wkK5iMzpxEEDh4w3ZR7OCDkMTOPqv6cqMdmzxUKLm1LcHcxjEYPDprQJgre60QD95nhO3mv/nBf/y6j1jG2AXeYjAp8Vr5/pdZ157EXDFzcq2qhSH4BHx9LyVJg43/rkXYS3u3UQf0Cqz1YKUG1M2dZRd3agEWLNYQ4VOx8CqahLoh+GI+K0IsCsc27aF0jEEVU4wGMXQgn3rYgMq0w4/nFhtNdhrAnGCU9B6/gTQQWj4SMDawMH+boTJJVorSsa0t4hc7iw6QxgTY3b5jw/uYLWC95+mxuFXGVBXlZDXUip1LhFVDdKailRi7Wr92JgARzYDKWg0fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UoV5J70MQ1jgf3mAfZITV8VuVmrutal3JHuVCrtKGFI=;
 b=Ezo4siiSwSOtu987rTuQgh2pquwwK1GyopZUqDq1HRGBuYnn4ANOsJfbtxqwgrrlbSwMo1dQrcgzHaNfk90jgagKzajDNiVt3GbU04dVZVXfXUXUsKRJUBfAZyndA34yqPqSDYA1e65Sukt78sEffccwzhGYFAvMU9zYQes04imivMW2XRcNMz/bQe9p+PPecUr7wpVVqlRv5zh+80FzcgO/xSRNRQx4kdYKRgBHevyCgwwFth884ZNUZ9ksZbDNRGxDB0RZl+e6aLHdvMyMFJ0NMBsB6xUzYKeNs4m1VphY4Dl0Wu7cq9kTJBu17atN7MxSukYdbL6dB6bWguhHFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoV5J70MQ1jgf3mAfZITV8VuVmrutal3JHuVCrtKGFI=;
 b=OzlIyvSQUjf7XL+JOvOvBOttcRmGJyq3QHjsOlI8U8pn6oVf3qt9t1z98uB/06CLXvUbL1NrnsHodfBvPZUXj2xfS27oSJhUrJiJobSUW5S0bzHvSNU55YSihnJ/0LlPnV0Tclcf6EStTjifuxKqxJs/si5pXP8xPh6HD6hEgpBD4oQwl0BNrkpGPx+s+Ek6Pc/h0UErlU6+/jeOwbCubTyUsxVTVdLmue20VkH5s69keAGozPP2Qnl1l3yRO1P7mf2TGbbUbcIs+/Tz9gVhFOll/PiuEbGLaAdvudE+e4g5Jr4fBJ1N4afJlyKhmZUIxHizSEE3kPS5UWCyhyCjJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6229.namprd12.prod.outlook.com (2603:10b6:8:a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 17:23:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 17:23:45 +0000
Date:   Wed, 5 Apr 2023 14:23:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZC2un1LaTUR1OrrJ@nvidia.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-13-yi.l.liu@intel.com>
 <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
 <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230405102545.41a61424.alex.williamson@redhat.com>
 <ZC2jsQuWiMYM6JZb@nvidia.com>
 <20230405105215.428fa9f5.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405105215.428fa9f5.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR20CA0021.namprd20.prod.outlook.com
 (2603:10b6:208:e8::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6229:EE_
X-MS-Office365-Filtering-Correlation-Id: ffe25177-ef25-4520-d2ff-08db35fa8298
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZsmebPLcPyMCGl9OaxGOlZd1YISPxI/fZeow/26BoRMwoVv8umlXrQNAmQcnvZhIhtbFq8sNfDaC+4jcIiCI2BtfOKaeAjCQrmpmYWX2HT0r1omezQkPwxwrzbKxuswXYupX/Dow+KPejhwj4PY+efbVc1Vv+d0vY+l32DhQgjsfvGnMFbt84YNpLysmih7fJ596/SUto5csf0yPBQVBVPDyiY+d8YOVs/C2tUgqvuehs//LkAg9LnMtf4iboQNlZa5M6vuvMGp96D6j25eUV653y1iNQZ+tr+NNG/qh5Oxg8oIVpq20oxkvZUEFfaOQYP/X0MzvQDTSaV73aMUw0QyaViCLN8nokuv2W+xz2Bd+/XTp8qyp8SUyfnwOQldNGA73ovIsPJT5H60lCxZknVnto3c3avV1BRtSAhFkjhRVwq4hT4ymI23IcTyNjk+lzrwXcYpThx1VROQSKFA+M/xO2wViKVPI7cYI1Y53jNuZdIEM+arWYZdepedMzZud7wcT1MWkccNop1sjKxJSJ3EGlZBQl8BJFqw/0zZnxQccGoh9+VuyHXzF5ZRaJkMW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199021)(316002)(54906003)(6506007)(6512007)(26005)(6486002)(2616005)(478600001)(186003)(4326008)(6916009)(83380400001)(66556008)(8676002)(86362001)(66946007)(66476007)(7416002)(2906002)(41300700001)(5660300002)(38100700002)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FNFxkCbGdT423IX0da3AsPmR8byTrb/T5TE+h4N2rViOjy8nZuTJhJrYzyx3?=
 =?us-ascii?Q?5IQkbStVNNK7Ie1ivd607MuCVCAXiVTMW93n7a02UkJmxjVrUiZdxbdfZM6U?=
 =?us-ascii?Q?/lWQ3uQFUmipVk+VsGXVcuQ2IPTgVHhwF9/62puD9hum4VV0hZL/acN2m4ND?=
 =?us-ascii?Q?zHvfKnTB2L4/BWncNzSL5ciIKSjREhd9+pPfQEQJEr5IDFx5T9QurzmlgQ03?=
 =?us-ascii?Q?XM3IR5FudjqMW2B0e7heH8Rl+JBmd0UxBefpQUjRwTLnPu/RrFsOaa6TCfhp?=
 =?us-ascii?Q?xE16ax1GsiRA4KTVFZPF+WY7u99xfXe5r5IRVePG6kRZZKOgNVRewUGXzd0s?=
 =?us-ascii?Q?HsTqw+B7ki3Nq7Scc7UI6oWLyuH6150RSS1/5+7XWwnsd2HDJFFCT0wdSUhp?=
 =?us-ascii?Q?9AZavkeZ7Zt3VxLvcO9MGw15MPgpiRuRHa9g3OUfRXIkuMOC5ekcdhkcBSh3?=
 =?us-ascii?Q?5pkOI1Lnn7TxN/NyyAqmWgyZDExYv4ldwDTP0IQwCzUpkfz7Fvwqh8CsbAYw?=
 =?us-ascii?Q?dI1SSGS6/5Lf0nL9O5KjwZXIrv3hoLJmpslQSeHLUi1E6tJ2LbNZP+p07xuG?=
 =?us-ascii?Q?GzIn6AYlAxgS4wcv1rNSI0Kw0Ztt3ArJ0Ax5CEZzeLkLd8+kEXG+dITdGbbA?=
 =?us-ascii?Q?1Ef6fQH9X0HWLa97NE6FOzQLuHTO2BF1uulWfRyaekYuvSsRJPnCVNe0gQet?=
 =?us-ascii?Q?kWKJNd+PNwNgcgXtWmwjTJUQ4JY3pb+fNT2rs+PqopDjNegx0lc3lrOw6bd2?=
 =?us-ascii?Q?sqmeELtqvbctRbN5ucjfhRXemGPC0tuVtPL9+8Hjau061i2RlB218MA/SgPj?=
 =?us-ascii?Q?gyM9I8M2yQI1HwKIIc8bbIN0gP+TmeckFrfLvU2oZ/VMLLdcsD/9kKrFyTSP?=
 =?us-ascii?Q?BJJViKH6v155FQG9K+0PnZ5Y/AnwFhwKCaLeuoY4saIaq8RzitJ8Y8614IuJ?=
 =?us-ascii?Q?sVOC8PN8XKjnT49SL9OR3JnI1u8ja0JGPmAicyjDCxXRFGgM8/wybT7Gq+nn?=
 =?us-ascii?Q?sJZe0cwe7juhdkGts1kpnOWE8VX/D09wUzOrErtbzE9+YjRbWkTjomKgkV0b?=
 =?us-ascii?Q?TZCSBtdJ2ydcYE9R15AXDGOzzDGWAlKkMGFPT0cyRKHByQBa2xUq9n2+a9+B?=
 =?us-ascii?Q?7jRziyym86DK8eRCnoP85/EhnfwU260+S4E3nhUWD+LVJHWNkht7WJksAynQ?=
 =?us-ascii?Q?wxsl/nF7SBv8HUxU/H6CyEsaM9aXY6zAdQwXFNimHOM6d59yjn5FhvU3Yvxj?=
 =?us-ascii?Q?qkffNKpgtozJ0rUxbAtYTBOBTwXrGqoirXhUgsVcNafPC9UHLm2Zpl/T6A6d?=
 =?us-ascii?Q?Qcm7fy2VGfidLv2YzewEsXDlrg/PJuSBIQ6RlYiokT4EVQrFJfC3+Q4e1Nhy?=
 =?us-ascii?Q?RVpoEa3pJePvR6W4hDecdClCh3K61jtBismpNMBaXe75nhw7kDvl50jTif+h?=
 =?us-ascii?Q?GWz1S36yyvCdXsNd9jkzNlr58B5o+zLXXOoNlNCMM3GEpK/wACOBLMF+1B4u?=
 =?us-ascii?Q?+EBc0kQRODMt6fmkMDWbC3a7oxyYtisL+TSOkzEuOm8EW0HUyP39n3UDfkzW?=
 =?us-ascii?Q?oyf/Y1Me2xwhem3YjqKs+yReQYWMhIYCQJoQyxYM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe25177-ef25-4520-d2ff-08db35fa8298
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 17:23:45.5159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZBASRQbOY9iQoEwLPSC4qDgfmgJyPF5rKfQyC1rdKBLnVBbnMosAKIltzgWaMm5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6229
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023 at 10:52:15AM -0600, Alex Williamson wrote:
> On Wed, 5 Apr 2023 13:37:05 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Apr 05, 2023 at 10:25:45AM -0600, Alex Williamson wrote:
> > 
> > > But that kind of brings to light the question of what does the user do
> > > when they encounter this situation.  
> > 
> > What does it do now when it encounters a group_id it doesn't
> > understand? Userspace already doesn't know if the foreign group is
> > open or not, right?
> 
> It's simple, there is currently no screwiness around opened devices.
> If the caller doesn't own all the groups mapping to the affected
> devices, hot-reset is not available.

That still has nasty edge cases. If the reset group spans beyond a
single iommu group you end up with qemu being unable to operate reset
at all, and it is unfixable from an API perspective as we can't pass
in groups that VFIO isn't going to use.

I think you are right, the fact we'd have to return -1 dev_ids to this
modified API is pretty damaging, it doesn't seem like a good
direction.

> This leads to scenarios where the info ioctl indicates a hot-reset is
> initially available, perhaps only because one of the affected devices
> was not opened at the time, and now it fails when QEMU actually tries
> to use it.

I would like it if the APIs toward the kernel were only about the
kernel's security apparatus. It is makes it easier to reason about the
kernel side and gives nice simple well defined APIs.

This is a good point that qemu needs to make a policy decision if it
is happy about the VFIO configuration - but that is a policy decision
that should not become entangled with the kernel's security checks.

Today qemu can make this policy choice the same way it does right now
- call _INFO and check the group_ids. It gets the exact same outcome
as today. We already discussed that we need to expose the group ID
through an ioctl someplace.

If this is too awkward we could add a query to the kernel if the cdev
is "reset exclusive" - eg the iommufd covers all the groups that span
the reset set.

Jason
