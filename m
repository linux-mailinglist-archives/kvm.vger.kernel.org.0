Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C732E568B64
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 16:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiGFOih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 10:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiGFOih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 10:38:37 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145281573E;
        Wed,  6 Jul 2022 07:38:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPS95TWsvkq5DnUQm9y9nawAftR3l1nqwcl10Xibxa/uqBBgmBrlOyIxKhVsNW0fbpzlyErNPy+sscK///RGUUEWGMvh/EehiEGU54e4nBRQLrXdYB9JN4XiIP7o1b2ncUlL7A/VXkQqf9gC0TulZ3g2J1Q5cTloTx1q9asgxoKa4SmzbAzv0veGdkZy49TrmYtDzufxV2zvk7j1U5IB1onznbnzbXGxsXjVyqcx/xABhq1KKgpJXBNdUv6tP+cDc+cpjU0kfMcYszc+rJuciHq1ILhlJeFeCebzZNNVOvUDLFg8N7C92MxgIkPg3akXms5ce5QD58kff3s5Vsmvdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+yWPo1tvuIEUxhwqkgWAnXMg0Y+AxAv/67zw1yf9UEg=;
 b=aDXzjWe/LoAdo0HqVBFzmp80CwDMVeuIRGWHhZJ/itXeGO8cPfj/PdAd+2u5kPW/HuDjiWN74wBYtGA/roYd5CD0cITMtaOWlYj4d0fj5Jc5VZ/gOnAmu3sn/nw8l1wOoSTvnIP2mubOroeTsg6zXyZgVVI2WeM1+eO875RAtholtOHB3ZchTBz0HNH3DN1pJQvCB1gJESkj4DdWewou6PO7CvSRR9ghiy/Vx3jWw8HZBP+E7r4o3hpAyzWRCsqMuBkUBnqBQ+ZVDmqpv/sP3WyjbheYR2Ied8i4tZBrjyWuPsyc5lP6nISgUuZR40UUQxPDnRH3AQh+3xgBxpbiug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yWPo1tvuIEUxhwqkgWAnXMg0Y+AxAv/67zw1yf9UEg=;
 b=eWhuqQBi2Fofw4VAzfqrt7CTpkTIwuM+jur/5/3zuA0FqwTH2WLcvAlREdfaXJJkWAcH2qvEvM2kI98qXuq0rSKhh+hWOcJK+eWQu16vBVn0dfVXPhkT++ZbgE1I9gLYekbiJXuXP1xm/xGHgATBd73dmyvTJyegiFV+KpP6owIxNjZMPNpkzlr9GgdO9RNR6iwKdpe6n0yM+Anc5VxlcUxGWHOghYq5iqAOaqPMk7z3noNVhmKnSejap9Zc2wZIb/4b51aiPdJgiJwow1PNIaalsDW97t/s0rY5gxzUT1SKGSVITFDoG7H4qVlQVRW26WB+4JWZE5hVR8HlUxCqJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR1201MB0236.namprd12.prod.outlook.com (2603:10b6:4:57::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Wed, 6 Jul
 2022 14:38:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 14:38:34 +0000
Date:   Wed, 6 Jul 2022 11:38:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 15/15] vfio/mdev: remove an extra parent kobject reference
Message-ID: <20220706143833.GD693670@nvidia.com>
References: <20220706074219.3614-1-hch@lst.de>
 <20220706074219.3614-16-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706074219.3614-16-hch@lst.de>
X-ClientProxiedBy: BLAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:208:32d::6) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f72cd91-92e6-4679-4771-08da5f5d346b
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0236:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 78BhOR80AwL3qg6z8ZQAl3RTMNkCVyda0io+xzRqxBEfwm9fqlpk+CVcCP4Aeuh5ZxtrpZy9KFF7A8uUlKgvcmxGHw4HGqN8gGeFNB5ntDwKJKryvGLkVn4K+G4oAMqEDg9mZfpSl9N5qY6kH5TKXWO05iPqsY5zuijP2TF4eZIQl77XF/z+PJAuBupC92amQ9+cTi1ZLYhDfGFIcqZ1QkT2WkkKhJJlC6dHyblQSFPew0LTTUgxv5uD7cRvlKsLCGGbWTUWJt7MvjwJOwRl8YfJJKYFF/uKwn7oNsmB0LqslycP0FPc7y1A4XvjpUW41iYxk7yYhqxnvWI1MxHT5K0oGMIrJdsC3zdcak3vIhbSM9oYQr7j1WkCu63TM6GHwRHGT17CFC4rFmsd2mGnVZfrVfkcXOOpfRRINjcLEiEfr/AEr6N4ofNx5fC05x5aIMG9qUIM+bCpRPiJuInigdG0tFUN1BuEgsDq0BC8b3AxDsUW201RA/6PLnzzKmHQgid0flMk78Ai4JgSOG+Z8OQ3ECWR9bL6y52sczyNioq3bG427fnOx8nME9S627/6cLM7woBBmOfKaTojLz++j6JnOWE2ohoka9zARKq/7O669G5k4sMIVWe3MDvU+2HyurpiY69ZQwADRCzbzTLz+5U+UY77HRwh7YlBgiIgN2d3gkV5eTtMjpnvG0duz4FcFCa3Nn+TtMuZRvSF4494CW2YFqWXZZjcNe5+yhHMYMYTiSYnQg4ePuRzC/kBiGARB/CTUldqyA2hhANnJkFUa9oHil9nIjoCY22mdeS4SCHMm01QsCP6g4NscDye1AKU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(6916009)(6486002)(26005)(54906003)(6512007)(186003)(36756003)(316002)(83380400001)(1076003)(86362001)(2616005)(66946007)(5660300002)(2906002)(7416002)(478600001)(6506007)(8936002)(8676002)(4326008)(66476007)(66556008)(38100700002)(41300700001)(33656002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RB4chQUdzCmozzd+jjPpdxfQp8V4vDabUu9b1dJRcdbgAb2iOVqoDUrRPrSV?=
 =?us-ascii?Q?v2frNzzB81BF2BZNBYbUhUrosElWhzOWLJibYCF+Rn03LmLp8rvg34r0hqso?=
 =?us-ascii?Q?hO4yn162Er2ILE6Oc30EgyCLUBFynCmwtRm5qQEH17snivMwz9vUZSlu35S8?=
 =?us-ascii?Q?rlaMKWaz7TTDloILWVoB9y0MbbCl1iyDfe0ktC/x9iTsV9SwCLw4wwXbqGXG?=
 =?us-ascii?Q?waPjANEsss/0nDTSQ9yZGyrHuED1TOhfva437Ekj6AzqAqYo3LspcM30l/7N?=
 =?us-ascii?Q?9f2HJmZOHnapqkkyCwKiFFZHO45mUPf4fLY9rtZeB6xKvt7RHwP2MJjoa2SA?=
 =?us-ascii?Q?AdTdtXM9uHBx6DRjLk+tJvV5eehLVMUazapJXfWnsA+mxrEFLn5lXAcGZ5DD?=
 =?us-ascii?Q?ihrxvAjoXKgIIInK0EyaBF/U2LpIUw+p+9+XCbm2MbpT6tdGo3mar4iRBgYH?=
 =?us-ascii?Q?cgkVrFkQsGQ70zC/VeENTWQ41nHTKIcTlsN2WNd24EZczjZ8q4GmIKdQXq2s?=
 =?us-ascii?Q?6zMdXuVZ5Z49j8C+cOhQv/BrgxuxstvpkFEwm3kXjcaPychYGUJsOtIF+okF?=
 =?us-ascii?Q?wqPKRrRlEMFZkeUrCQAa/rg5BfQ1pwEzaSy/tgbtHxbP9r/44oB+6VvkJUoF?=
 =?us-ascii?Q?uBhoYDqUQGvKfsaIwkPGwdVu2V+2WchlphpzEGHZ8hUQCS2hWgWJwIWy+KY5?=
 =?us-ascii?Q?j5WqquDd417jmnAA4wv+/kn8mu9dBcAHUYW0knyS4AvvavYWKeu+zuWNsm3t?=
 =?us-ascii?Q?fntXiowekOQimGCZVIkTNgciem+DQgyADCzqKrjrlLo4v5AB7UYKVFWlPEGr?=
 =?us-ascii?Q?Hnna1DsmWdkMz4cuo5e5ngRtIezoLJn1hzQ72PJwORYGQecY/K1PHRgKisW1?=
 =?us-ascii?Q?vHsCLfipROLbtKPzeFKLB7/gVjA+3nS7BVm140q/QT5IPKfcSCYzt8JSbHlN?=
 =?us-ascii?Q?sQKZslyMz2ouHgCX38SVisL81pwuopIyY2h2CVS+CvNc4mwmxJVe7PNO0wUx?=
 =?us-ascii?Q?ZoMQITj7A4naow+W7hVb2dsbCSb8mi9OnPavFIP5I4sr8+qP5H8HKyMY+QRj?=
 =?us-ascii?Q?h0MqP5ItYA08/Wm9qLhc+3XGrOCBDbmJyWwAls2RhD5P2QMS1h8oIwpjrcJa?=
 =?us-ascii?Q?dV394ELmzKxnZZOf94Inn2ftq95zFbmz6/8ACHZ6LgRxwMgon/wpHfxUNVKw?=
 =?us-ascii?Q?o9ZP5QzjiZy61I1mQErHpM9qrcGIP/QXVHnCc4+Yy7vcKD8JW0uAuEy7LxJX?=
 =?us-ascii?Q?i2RrEvglYeUZpwDknSLlqOn649T/+nWyACroi+zB2yPcfBQuIbRPUUGP4v+1?=
 =?us-ascii?Q?Co80sDrIRNZUzwFAvw6TGn5kvHa6Jbo4ml02mmufGmARe1eKiTKO+/TzkhQz?=
 =?us-ascii?Q?yYxnDp8ow9j/XzvZ9UtRHCBaAC47eM7BPtVXRl/vJfzgGfsk7sPE7XvAALOo?=
 =?us-ascii?Q?erm4W115ZM0XLWQmcWIyymaCaBsAYGuRXDYjh8BCPIYmpjfSQF72qY337sRg?=
 =?us-ascii?Q?5JMhX0VldQNXhEtcropaK3Pg2VMXEWqVR+O6OTwZWLnkzwt8nGzZf6MV5pJj?=
 =?us-ascii?Q?W4GXWjloQQZYUSbOBEL6kHj5aTA5u4ZS0w8wU19p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f72cd91-92e6-4679-4771-08da5f5d346b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 14:38:34.3951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xwzwbC0RuzLK113X1tg2nUZdky7kFFrTearzStkMsHBXpcmHLJKNZMgI1xGB38rv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0236
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022 at 09:42:19AM +0200, Christoph Hellwig wrote:
> The mdev_type already holds a reference to the parent through
> mdev_types_kset, so drop the extra reference.

I would drop this patch, but at least the explanation needs tweaking..

kobj's are weird things, they have a kobj.parent, but the refcount for
that is dropped during kobject_del() and parent is NULL'd. vs this
reference which is being put back at kobject release.

So, the extra kset reference isn't contributing more protection - when
mdev_unregister_device() calls kset_unregister() it still has a valid
reference on the parent from the caller.

If this change is safe it is because no accesses to mdev->parent are
happening after mdev_unregister_device() returns, due to things like
the sysfs attribute fencing and the mdev_unreg_sem fencing child
devices. I didn't check everything, but it seems believable it could
be true.

I also suggest this patch should NULL mdev_type->parent during
unregister_device as the kobj stuff does, so any use after unregister
but before release could be crash, we generally shouldn't leave
unref'd pointers floating around.

Jason
