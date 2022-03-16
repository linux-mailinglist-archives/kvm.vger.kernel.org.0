Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE924DBB5A
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 00:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbiCPXwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 19:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiCPXwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 19:52:04 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C32DA6
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 16:50:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PcbP2tNhBKcrqbRoz08QgjEVxYY214dqwl/GPtcFGlPAKODQE+ZlpM3hxJMh6IefyM3crH2I/kx53dem03eO2oND2hbDCE7dWY2rg1mnG68DRd+M5QK0peBi6qjPfo5lpVfQ5z1jruAp4S9kUIApGw+ljO369AtM3dBVD0CgNgBF767Dz7k2t8aVc5Uit68GY2oPrq9GxwKFsi5llk8zuuvNyjIXGOy6mVTKGY6v6PKRyzii5JCu6vlsBLkDO07Xfe/CBWuDQrCF++4sM3XWveBWtAF5ghmCK5tPaXWth4ujBvHtYs+Tq2t/Qmcvjhu2rl6fDHDjqEzVTXH4Tz4rFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0dOr9BtvQcYdmjQ0hc40AIcJcc9FB49S+tCbk8dFps=;
 b=RRlL5yaEaPYZqZNU6Ku37s2KYqytWvV6Gq4nvP5cAFGeo4TkzcpCTU/RvTLrOw/4OCYei2+89qKicy8O+KFaomOK+PXcB3E1hwCJTjMsoPCHa9TRz7CWI+XbyZ6Qeg9DZ11CZD4MVCFZouQCaLxNO0j2MnAN8QeyqP2mNTZGIKuzi19FrxFrin5w0Q4BfXfivcrkJBoL45jlF7bseAYZ2EKcEsOyEB9yJa6NrmKHyuLi8QhcUXnf/Qxci8W3R+lr3l7ZJqtuQe+t0YCxSXtA9TtaC5QcZX9a4tis2RD3oYi3iOZdsnHosu2oc6SuSZ2sEN29ODRa1uPJXeeQsYVIEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0dOr9BtvQcYdmjQ0hc40AIcJcc9FB49S+tCbk8dFps=;
 b=L1UIWfHg1suf+y7FZrEvrnrH7fKoQK5tBWkdRUGYyu1alNR3FbK2YOH51QDdJlSrqMMLVKlGcPe8J3V7O+EyJ5cEe7g8iAZ7oOyrS6TtxyqWkmIwzrNA7W9nzjiGDT6c17ap4htXnNwLRGJs5qtDO/uVK3yspSory+wI9ivDIdta1mlXmURILSiYOsRbPzuvIRbJ6ks2E+p0a/fXf9oXV3nAXKdfiiNHGD1ZPwZvgu9nzTMNau+1nhMpZtCphRTS7eMTM3V18KVWD8oKrVquJXDrazD2Qdvk+WKGVQ3/mrM4rsh4fppdDv0VFrz5Q5HgiMmLy/SWL0SnntnsrUwcsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW5PR12MB5623.namprd12.prod.outlook.com (2603:10b6:303:199::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 16 Mar
 2022 23:50:46 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 23:50:46 +0000
Date:   Wed, 16 Mar 2022 20:50:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thanos Makatos <thanos.makatos@nutanix.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Levon <john.levon@nutanix.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>
Subject: Re: iommufd dirty page logging overview
Message-ID: <20220316235044.GA388745@nvidia.com>
References: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
X-ClientProxiedBy: MN2PR01CA0012.prod.exchangelabs.com (2603:10b6:208:10c::25)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6bbfe37-c735-45b8-299f-08da07a7ca40
X-MS-TrafficTypeDiagnostic: MW5PR12MB5623:EE_
X-Microsoft-Antispam-PRVS: <MW5PR12MB5623E80F120EABE36A9D46EDC2119@MW5PR12MB5623.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 57aZmtDkZ1jkLIK4o/TYU06XDETOa0e/KZZ7/bDXc3bTjzlkkNYoSDIoxdlewbEILBc9KctJQo+y86rQcxHFuNFW3s0jtmR0KCtJ7NAd+0Mb91Nc0nMVWLlYo0xZASStbCEd8rsJP5hcgn57xj3WOPFjCvFcSiywIP4kQhkQe38GsowaI0HUQ7ULObT6XKSm5sQZ3g12/LvVeYb7nl7e8Cz0WmFIbbLrVdHIvs4qdYL9I+NOMzMt1p+alwaHbNv8voP+ywFEb8/oDFA3rNoviuzabiiFrBlvXrbyEsgpkUY+1D9DINL3AiRsTDi0yUnoWHNzF6I9+WHY2/ZTT9e2PgCiOCC3cVTOHNJVqes8jB3jEewJ0312Yh5ULp196DZuGEPlW72nUwTZyh8tnWAVZ6k3De2fOwKSFrKcxBGYIowxDja/qO4mBmfmRr6hq36udH68rJvdkiy28tEchPkrxiPc2PWG2vLiiZl6gMkhvON5OF9fzturvHdM1Poo20+/nUIiIVdfk1EghsmfEA0U3vCc33HdGwdgBAtcKGtL+k1Q9zFCFQB7wjk30sLtQeES6xea3DK821oCruT9L8ZRt+HJBYJ1z/xn0DockL2PUiPeM0VIVQ/l4LDcCimVveWKCFCcoQZGpMJYvy8dZ5fVx9Iv7pCcTELpeeA00nU8/+ZAJu3eCI27yqicG8ET/yPmSycgmTzBf94MKADoVhmS8g1QM1/rUFAOhvWZo3t5Feo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(316002)(296002)(54906003)(36756003)(508600001)(33656002)(6486002)(6506007)(6512007)(2906002)(38100700002)(83380400001)(1076003)(66476007)(186003)(2616005)(26005)(5660300002)(86362001)(66556008)(66946007)(8676002)(7416002)(8936002)(4326008)(27376004)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I6lR7khCDb13905FVUH4R/MRTBsweQ2V+XQxoCxh4FUAkz+LRKcmlntUwuQc?=
 =?us-ascii?Q?p/37VSXH8uRaeoFKDFhobIIIuhNlVmcNYQYPS0XKxGjf1CJZlZ4Z2pSdqcAN?=
 =?us-ascii?Q?3+bORsZIHgVHsycJ4KkvuqV1JfnoukEiKuA7S3j876euVfXAKn2EWOaqCoF/?=
 =?us-ascii?Q?NYm7j0dMgMSKMH5gm7fBZbVRcZbd9vvykHPbYEd6c3Q5GFc06ZHc8G6k0n9C?=
 =?us-ascii?Q?AeF5WiwnAvPOJiNv2jB4EZymkw7tzMjYOPlRrkp+sEcT0x6Tht4/WqJmj8cz?=
 =?us-ascii?Q?CzOHJ+v7HL2j5MaIhH+pIG2ZVuufQ3fwSHzEaXbChmfjPyXrGFj7ZLtrhksV?=
 =?us-ascii?Q?ygjQS+sfexW39NyXAZGN0Gp98iwrqoL/nlHXKtcZf4plfRd1dZv/w/W2G3Pu?=
 =?us-ascii?Q?GVh5AMHh2l3VXDxW5rvJt4lERCAzhgasu7wqGikNgVeosOs9BDXdnzC23eAV?=
 =?us-ascii?Q?0H+AB8rpnLMeyIPFViltUklALFQwiIGtKqaLRPo9FvUzwun/CvFgVfDsGXR0?=
 =?us-ascii?Q?JBfAlb0dszAUr1bn3QWzcyKnq8VgSDsj1IyvJg8H90tWW1gz3fX/t6mZpeAj?=
 =?us-ascii?Q?qGOunyk8D2uj1mZl+roJYkVO2GSawq0J/xnwpQB/Qb0KepGfe73uBla5/TjB?=
 =?us-ascii?Q?FwU2thNdhw2LCj6gX8+RjRrkzz3NcT7JVTd+cKMP40QuGCcmOdA9dwpn0/DE?=
 =?us-ascii?Q?/ztMpr9B8b8VJfgpi/A/LOUL4r+58jjedAjhh6ZiMvJQMC5zH0Z0K/d4ZVzs?=
 =?us-ascii?Q?SDqR4A9dBIkX8YJZL2LQzjwjenOtrErk2KxB4nXqFJ3hZ7Mxq7ztlYEtceQ1?=
 =?us-ascii?Q?PDdSYSAEtZlsuXA3UCYtLGdZFW+BXxr35VwGwlEmDYzawTzmxEqkzdyTB9Ej?=
 =?us-ascii?Q?vq+/D07bDyLJSR7vT8U1adf0X5IExNs29xPZfVxQ1fbtKhu32KSZFOTENd/g?=
 =?us-ascii?Q?tbqng4npCzT10jp6cTMo9xPRz1hb4FdZiHLr9HQZjT7M5o+07Tj45hU05Kob?=
 =?us-ascii?Q?p+hFflAD1Yu8nj5XPpi+8Fpch72VU6BUqc5ZpW5VUttVoajzTKiZgDZz8qSx?=
 =?us-ascii?Q?VA8NInM5lLs3828SjR9H+IG6aCEciDMS3vqKoykrnuO+YyMBvbalQxgvA1cE?=
 =?us-ascii?Q?rC6Te/Q4D4vgvbii2tYGXPXJePTL7tEvzDTYVYZfSqAogeFb/YJRr4ZXgjPN?=
 =?us-ascii?Q?S4v0ODsys90ckm/hDqRjr/v6WdhZl279bCrh4Bmyz+D7OXgDttkPdJwEP7RX?=
 =?us-ascii?Q?SIVsc7QsCQZ6Y/kgZIg4E2D0RinbvzYp8MC9HhJpOwgM/BFzFWCTxloheU+g?=
 =?us-ascii?Q?7uIaEV7AWW6GYDCuRIiy5O3XPKWfMqOQjHEesLavUQ9NLZ+qYa+9vYjOVgg1?=
 =?us-ascii?Q?RKlUO0OgARrJNYZDMwuvYxt3m/4f5j4zoM1C78gHbf81PPTZUqrYXOcG9WpL?=
 =?us-ascii?Q?bFd1VXXBos1HP9ACPQtWmxmWxmF6dFuZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6bbfe37-c735-45b8-299f-08da07a7ca40
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 23:50:46.1877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7TnW9mzI+OSMia/Qag+sLvZQ60cDmgi/LiFdPGqQvFnsq6aBgiu45rKWWW9agvqY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5623
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 11:29:42PM +0000, Thanos Makatos wrote:

> We're interested in adopting the new migration v2 interface and the
> new dirty page logging for /dev/iommufd in an out-of-process device
> emulation protocol [1]. Although it's purely userspace, we do want
> to stay close to the new API(s) being proposed for many reasons,
> mainly to re-use the QEMU implementation. The migration-related
> changes are relatively straightforward, I'm more interested in the
> dirty page logging. I've started reading the relevant email threads
> and my impression so far is that the details are still being
> decided? 

Yes

Joao has made the most progress so far

> there a rough idea of how the new dirty page logging will look like?
> Is this already explained in the email threads an I missed it?

I'm hoping to get something to show in the next few weeks, but what
I've talked about previously is to have two things:

1) Control and reporting of dirty tracking via the system IOMMU
   through the iommu_domain interface exposed by iommufd

2) Control and reporting of dirty tracking via a VFIO migration
   capable device's internal tracking through a VFIO_DEVICE_FEATURE
   interface similar to the v2 migration interface

The two APIs would be semantically very similar but target different
HW blocks. Userspace would be in charge to decide which dirty tracker
to use and how to configure it.

I'm expecting that semantically everything would look like the current
dirty tracking draft, where you start/stop tracking then read&clear a
bitmap for a range of IOVA and integrate that with the dirty data
from KVM.

Jason

