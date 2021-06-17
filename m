Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF7B3ABF2B
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 01:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhFQXGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 19:06:50 -0400
Received: from mail-dm6nam10on2086.outbound.protection.outlook.com ([40.107.93.86]:24832
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232601AbhFQXGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 19:06:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXkS6tPf69kxnM3PqIN5NnQC/N8yi4iVs5+zR/BvftF5t+XaTkfu6YW6qtBZCXy0YyDNdEDoAx+buOoY4S+vjmHbZkogiIrevQxdokbyOz1rWZTbGu7wRFQ+PrK90/8cQvnLn/D7E4X9GFfoSN62FGXsTBwTTy9NeKKBF+Dqz5WTHP1S4+xbPEk54GdUkqiq8nDxDZXSL5CeD3twHL2DoyKlW1jtepNB7rTlAMk5M0KX40uLdf3iewyHvJDc59hziFhrpw5AdRfa2bX+sV7M6HwhJbR8UM0GS7q+P4ZErm0rcCWTuUg3NkEzbIcHxTSDW4V20Wi+VoprJaAbay7/iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57nNh4lj915iJ3BJAgiLrcGLbj4HT74P9lAEQffvS8Y=;
 b=TEXIc++3xa9IGaCrh2N/QHMJRBV2yp4q+YXoKx/+cR5c7ZypQfVte1yLrHOha99LYriEQvU3nP3BwDgb5bncu3Q9u0BAB/WpkoHDsVPAfv0W7xJBYFSxcDEIqfPRj+TkAbGYD/Fka0TkXaI4mH/LBjGO8XMeZlrb4WflYjMr25zYneSN1wDaHgLKktS4FcMrQODzT7fAfzpwJJC7zlKYfESdL7yIgdnszczKMuQUkLc9+jYMaDHYtbtPqGQuDVUWKtrmSQrrnbrfc0a9P7reeRWVNsHo3mmZMNhWSnV96vSMR2r1uFyGEcipOsSqYa4YkhQaT2Oi0b7xqEgcqnvMhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57nNh4lj915iJ3BJAgiLrcGLbj4HT74P9lAEQffvS8Y=;
 b=t6V+qW1Ee863nhNnuiJuWXxmVWCh4Id3NH6G5zeOF5Ti1nG0r5ESAo4DdIzIRDxpl1ZVkaZGcH+VhdX+an795Qnzf09KopcPkQLsiHHGQcvjHCY97QaaETkh1peVFn4E/rZY05pnTw3Ej+M61RNfkMec/dTET2B3oapZcMUO0YT64r7r4AIJR7aJAoJpDzWtIO1LyhAUvKnDnd/nGhzSceDFelbmZC/esn0gjpPenPxrA16csPXA96JfXYdSvzey+2V0icKP85PIjDTabtXivuGlwf3mnSnYobtkfRSA17dR+jNHD4ZVarmUokFoDF2vDNJznTrWubm2q1W2NBn2ew==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5128.namprd12.prod.outlook.com (2603:10b6:208:316::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Thu, 17 Jun
 2021 23:04:40 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 23:04:39 +0000
Date:   Thu, 17 Jun 2021 20:04:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210617230438.GZ1002214@nvidia.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
 <YMDC8tOMvw4FtSek@8bytes.org>
 <20210609150009.GE1002214@nvidia.com>
 <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
 <YMrXaWfAyLBnI3eP@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMrXaWfAyLBnI3eP@yekko>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0407.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0407.namprd13.prod.outlook.com (2603:10b6:208:2c2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 17 Jun 2021 23:04:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lu13u-008JqX-9y; Thu, 17 Jun 2021 20:04:38 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98b10d07-bd8c-4cdf-8bdd-08d931e448bd
X-MS-TrafficTypeDiagnostic: BL1PR12MB5128:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5128ADD39931FE4FD56DF68DC20E9@BL1PR12MB5128.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q9Ul3MS7Juckqr1CwU234XkBgPwv3fcJe8nUaNsi9rsFn10v/5RP+e3LWzVNOW9qWrZr08mH69+HIPa646Rgfy7xs+1z4OVyqxm01xGXIDOB8BHu49dJUf65uOmx0Ka2YicemKvMPLAJFgG3q4AzXe5eGHc7dUkzKXq2YU1DPSs+nAmW5xdK9NLYqKGmmKOdHwUlKBKVs88wNCaQjFpqVuPPa3LrT7ArybOPqeYJ99H1F6e6ESInclK4orOhgJes+TN32i6MZJm2c2mVcuwbqxEje++kreLnLyWDqOjRn5n9MFQOfdo8RziC1dSJj5R1dasi/8JyN2zL5W4C1p+KjWbU/SmVL4vxb2x9vKcJppkliwryi9jpL9xDqo8OSx8d0y6ZjDg0jWpCKfN3N3YAc2imGBvBGuiD6slHM0fEeDjJEXoxZzXzL2ffu8SNfgIaWCQZ8LedajRf3beuWBUAMxbvhU/GRqwZDMQzLTvfUd0vbO8+EYMDQUjtiFIIiNN0cwwZni6AuY5hKeXf9VvEByuFWpGDpjgDavegldWu9dKdJ+Ymg6v3e6PHZxQKwERF8oQafRYZu26VeCDPqEzh9je+eDMVlSwGstm+/LYo80U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(66946007)(66556008)(66476007)(6916009)(186003)(4326008)(7416002)(2906002)(26005)(54906003)(5660300002)(316002)(8936002)(33656002)(38100700002)(478600001)(2616005)(8676002)(86362001)(83380400001)(36756003)(9746002)(9786002)(4744005)(426003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XvBb7bUf9LcRp3GZzrVWCmZ3K+QbAlhbEIUmE0zxFZivz4g0mQZOleFyfCwa?=
 =?us-ascii?Q?rGdVoZKeA3Fzrd0Xx/CMkOYsr1Q/9108ZI7/E4WvtjEifDNsR5gYiRyqI9pO?=
 =?us-ascii?Q?5iwdEYaYyCfq2Qy6RJNCPqbHoguYJdvq4wkqJU8Pv7ijc7XjRnGrUeTL/wNf?=
 =?us-ascii?Q?jFDX7ISfLxacwChPGdpPw6yFtXA/g69arWqmmaBVnt4q7mUC0bjQrmHGf4sg?=
 =?us-ascii?Q?IvUthzacty83c0aASyslobpEIIeXwuIRvPZgTsx6CDaVsHz8btlKta4lxfiS?=
 =?us-ascii?Q?O4wZRZolxtEevOp7AKtShEpzwyVv8W7ctrKJdaTNuNhMPCucmfIKFBJ34S/i?=
 =?us-ascii?Q?dNSguSlkYZB0txwDwJLDPBtA8eFzhMseyBQ2Uy9bNeZ2nE6dx32IOREcTVMC?=
 =?us-ascii?Q?LM0gi7o+WpoBUQVpndZbgPiy42HeMZ5v6MrsZT6RyddDxJ5C7nVqenBvE2jX?=
 =?us-ascii?Q?yJagXKkTV7Z4IdIxquVFaaqstkxGi36kSXK/pB5MWhg3kzaYE74BR0mhsxsm?=
 =?us-ascii?Q?ixluGcENcdgR3ouE/NuXcuZptTHqtkF9V0r17OBbGT4rG/BqegC+ch6ujMA/?=
 =?us-ascii?Q?/73fsuAzO6ByPRpPUcmgxG1reRytOj0BNqFmLUjawft356A6q1lePjCl9LD9?=
 =?us-ascii?Q?FKCYqJw8aoLXDPc4rGzLZ+mm1lIC8Gy0lCTG5Cd81mNYsQs7QhwEeZL562OP?=
 =?us-ascii?Q?22r4nDNpDjWt5v5fnUkmVe9V+I2rfNT1PgpHBcRmwnxN2F08Mdp9eCoHEj1S?=
 =?us-ascii?Q?dDwjuleMTwOpnmbCvaZdaVLqeg7pOt8MnG7r/AYL9bGbEVdY+Xi+5tzmOd1O?=
 =?us-ascii?Q?JRSlTaYCOByMiHxW5gyyw9tlMCbf3p0uN1bORnmwQoWwKPDK2+1UTWAkfG5c?=
 =?us-ascii?Q?mYysVXu3t5BNkXk3e+7OltWV/BSo2ybd8D+tP5w65gPKEwGXDUgHvRtD2yov?=
 =?us-ascii?Q?xXdaETN5c747CM4dbTfQNYzLbVi3pQlHjNFwRENpMCulkmY6pz12xGiGfiqX?=
 =?us-ascii?Q?YHp9mG6s5szMtDO9UbjS9evcJOhsaVeYQF6cgZ1nYARb9/0qlnSDpSJYTZWd?=
 =?us-ascii?Q?568gJdSlETW7DTHKFpDicvrqXMnbR0d1Oc1SybdYLNjJ85vrlHZk4EfLC9yS?=
 =?us-ascii?Q?MYysbDYMwZ985glA0H+QBm72BCb3HRFLl62HaGjaHavtnYZe6j0pEfjOjp6i?=
 =?us-ascii?Q?O+GVGh+6iCRMlzQ8phGN9GE1hsqfBS8WHYpuK6yZzMobcesfbrIxGcg6u2CA?=
 =?us-ascii?Q?98yzbrl0Lh732vieqD/PgYM8mpyoWRmfniaK2Q31gCltc4bKy6ocguqpKSaL?=
 =?us-ascii?Q?EVnKmSHWPwRg69hnNcx64qYF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b10d07-bd8c-4cdf-8bdd-08d931e448bd
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 23:04:39.5328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D8XxTH0ANlGnancXx3KoO+OsKn1QvR15aTsF9Ja5TUPzIYzQUMczMYNrinRMHZtI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 03:02:33PM +1000, David Gibson wrote:

> In other words, do we really have use cases where we need to identify
> different devices IDs, even though we know they're not isolated.

I think when PASID is added in and all the complexity that brings, it
does become more important, yes.

At the minimum we should scope the complexity.

I'm not convinced it is so complicated, really it is just a single bit
of information toward userspace: 'all devices in this group must use
the same IOASID'

Something like qemu consumes this bit and creates the pci/pcie bridge
to model this to the guest and so on.

Something like dpdk just doesn't care (same as today).

Jason
