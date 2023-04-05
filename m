Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CF56D83CD
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjDEQhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjDEQhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:37:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8894C03;
        Wed,  5 Apr 2023 09:37:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDq0fk+rBwV74Rb6k5UUM7OcRlCHt4HXnj4HDUGk6EsMHIROtEF6iyMEnXS647l8I4rp2rsSZjjOWe3YfBrnBQ6uu2PVJbu2lLr7dDJcMwCI8dg3hTWv5unMe+z3p8EGizeHHX2PsBYLdhrwGhx7SYw/n+7V2vFeH3EJJAtHAQBxgPI5NtK0oZXiWzEOBvZHGmof12h9myvF2BFc1GPzm++MSmb0uOVh4YcMYtf1t3gxTjLfSUpnVSagWu4phFmo6T5w55rWF1EFV9+AS1e7CuuUWdT/U2M0Sm952UnstUOZfhmv3HLi760mIWS6ENjwHwf2f8TfhRamUtx/5tbatA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsijQCfTpdQIQXPOfQI/ccmEdRhnGb5yFkBi0+TliXY=;
 b=Eg+eiWsZf88/zx1fOIUStB6/5FvWFRLcbcOKErKoaIjCOX+94EikTS/WSF2FPwwaxB4wyEvwgb7gYFATUyXt9W2MExJ6J+MXaxdcIur4w7moJfeYKrY1IbQaFfkJwVF7c6FYMNM3fiTJozCaMTdRLwDpvppg8IoQLDZx/cdkjWkXUH+a2ELjG2IVNQ+Jz7KngwPLbP8eQG8JAaFiDIXnvGbhD4CHvzN6ozl1kiJLrqZ54TPsUUKcwv+XeTYYHdWfzcFtJ/ky791JHhSB6a/tpZn/eA+RXKY/LRg2hdOP0g0NuQ0tqzjiDP2mx5J0ypAhWOsuF8Kx1n9dzLJAgUwegw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsijQCfTpdQIQXPOfQI/ccmEdRhnGb5yFkBi0+TliXY=;
 b=Vl1hKHSz4yoqWylggRXOvtyJDL18EpwOtNzkcQP+W9DfMFugp0t53F1T2np5WBsocQnFO1xGdxqXBFPteidXBOBSli5DWGJlc83+lnZH+vJiUIiG6v5c3bWYJc3ZTdMx4QABgzKUkq9BJ5J3H9aKhCslPxOPmsYlt2xzWA1A/AnRusWDV/ke1fmfHQKApTDZAcW2rCZOMtLjhAz8hXlppOVBny91qysvS6mpRKc/KU3/jOfDxH/+pW2PcxmWF1JpiwS1QrTAc76cZ5MgCx/BsogeeDr66MdWKvNaPDM90aUOk38iMYzZOpvmz/JeFsZMqV/Em/4K8ZKzdTVYTNOzOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB7591.namprd12.prod.outlook.com (2603:10b6:208:429::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 16:37:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 16:37:06 +0000
Date:   Wed, 5 Apr 2023 13:37:05 -0300
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
Message-ID: <ZC2jsQuWiMYM6JZb@nvidia.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-13-yi.l.liu@intel.com>
 <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
 <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230405102545.41a61424.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405102545.41a61424.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR02CA0117.namprd02.prod.outlook.com
 (2603:10b6:208:35::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB7591:EE_
X-MS-Office365-Filtering-Correlation-Id: adb37ad7-80df-4b4d-90a9-08db35f3fe33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KbZF8C6Za/QJr0XbuCantp3/xBHaBG4Nnwy51OYfJVCdR/0TCRvSTv99vQyQMz2d66aNkjge7OUtJkQDyML54wEPCcZ4OEIpzQv4WgzGxN/JF4MebKeHk74x0pGrIt+zLTR/HWVzCjUj/1RsvmYiVzr8hYNMgAu5akTS2riVtyY/xTHBHYjYMXtAHGi+X0GE2QvjLHhppaZA+Abh1biyGBwTMs9C5gSTrOkPOBO/csnapK3ufp995te+ARY9knT6jnxr8Wq4oo9v71sSACR6tMO10QiuZRwLp8+76HSzUD+VaIZbIrLXOcwq84qOE43Y205ATIvCxQBxLJXrhUf1nf/lUnPlw0nvGiVJMMeP1rXaEALGHoRwPiPHHVkM4AhqiUCqAz0l3QctootGXG8PTnkbkFioOjhGFme/TggI1ox7dA8GAL9M8Tul361Cv7aPKIGhBQskq35JlZJzY5iaqdatTutF+Z6f36O1znIOS0lLbXeXxMt51/mJrRzEJ/U9on3ouX1ExwKsCusiFJczzltp4UvFricsSnbCx9a64pBhOSQrUscD9QvJKM1Y7FC6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199021)(2616005)(86362001)(36756003)(2906002)(8936002)(83380400001)(186003)(6512007)(6486002)(26005)(6506007)(66476007)(66556008)(8676002)(66946007)(4326008)(478600001)(54906003)(6916009)(5660300002)(38100700002)(41300700001)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b0xF/p5COGgYxxW5OHwpJXAHo1wAPV1f1uFlSjY2xll8w7bMdCfuMOy6pc6F?=
 =?us-ascii?Q?atXL9RLCDuQEbYvI/2WY+cF7EtUFyGIRdQSV7ftTYNqAtb82qvYeIBUcdBg/?=
 =?us-ascii?Q?WzRHRqFCQISrF0NQp5N4EmiNSlKN/QZ1meaDuIHnnOt9oqhaeuV9JV81YXDU?=
 =?us-ascii?Q?CPetj/dUXmnQCCf1beioJMOBOXD07FVtmb0IkXgbaD4mkrZvXML8JTezSyC/?=
 =?us-ascii?Q?7IT0Ifp9118IT5VIRHm/jPKnNRXxr1y76aKjGFuEyM/IMIhlYd80/2vZzsy5?=
 =?us-ascii?Q?GywzN/NrRj4+64s+m3kqVPjZpcEipt6QalVe5C6gqwmcUEUBwKPJp/FAZiqa?=
 =?us-ascii?Q?g4ZPNlJ4DVA11n3U+YYzhbM7zXqeJjy+cmQzfBIURTr+rA/Fw/9ztssOJ1Jn?=
 =?us-ascii?Q?p7RUg0A8vnerO6o4oPUNahq6qcbI8BE3J7Gehr0URoE3mE/9u9gxoDYQe/1V?=
 =?us-ascii?Q?Ssn8S5EvJTV7sMdZ+9Xz/V2odHghmcHugCr7i1ZQembUn3TjmwOBgueUPDWW?=
 =?us-ascii?Q?b0WAAsGa6g9v7NjsGMkHICoQhy2ckLg4ETC0hapIIgDajhUDtDtnBYPyhymO?=
 =?us-ascii?Q?8t1/S37PXxyJwfi6yC5OPOLLpgHivkxZAGEl36JjY+goBPhycQ1+yFTEO5vB?=
 =?us-ascii?Q?/82zLr/BklT1nzarweYIvQ/jA8yTIbFtp7jICaOPIce59Qkn2HuXrANFESCQ?=
 =?us-ascii?Q?7JS223OiaMLcho3Le8s/3q7YQ++ToBGyBXMb78wTY4XVG2AGvrT3sV5DOWeU?=
 =?us-ascii?Q?CYRrSxFQIxHxfrlGvYNqa1z3kKl9Oba+5MwqlJ39CW8bIMgG6eKiE/zNCT00?=
 =?us-ascii?Q?82pKh3pTLOHcwZwijOp8ziF+9NjcVdzUG4jd82PRwDJPDp6C5aWajsSkxWGS?=
 =?us-ascii?Q?WfXz8csf8rN97hpbp/RXvdKue4svVkfjXXukvS7BF2yMtSOfCCClw3K+lnO7?=
 =?us-ascii?Q?qK6SkITad/XTGDx6/tfSKauYd69M+8C5yS0DakBDB5zk1VAz6hSLbW7asQeb?=
 =?us-ascii?Q?qxMlbZMhDQJhfYL0zLryGdT+wKk4PdEVyuL5yGsypkN/azD0TV1DViLZs02R?=
 =?us-ascii?Q?Mesp6prDgROvXKbMZnXGqeuReRZxrTvyop9WemE0npAVc63UmEgwwEPbcIu9?=
 =?us-ascii?Q?sA9OhlnTmNqOVp4Z7eK/ZIFOTuF8NthU6dYiK8UmL74x3IuQ/ia27L1/lGCM?=
 =?us-ascii?Q?0CS5EcThTyZ3pgiok/Fyxw4XONLQlv53yw+Ah47M9l2cxYXdhGuXWnj7Jupa?=
 =?us-ascii?Q?D6kRmREz/vdsDxlAM/Qs6oSkTjEC9SNaLyK7ihK3eYTtsTMLtdDi7teDKf8Y?=
 =?us-ascii?Q?jpMi+gg+x9OTzF9hn3BTQ9/xx4bP5FvmPANr+ALCMebKzbXI21CN+HIVyfx2?=
 =?us-ascii?Q?NeJDDgjGCr0Vn8gtlD1rnqYlJ46DWZOpA3JN4K49A2RvrKbx3GOUwJA+kJrU?=
 =?us-ascii?Q?//MYm9AHX2O94IuMapXCfcu2sfi7jJORmQpne0LdTxyWQberuRdCpJk0RxPc?=
 =?us-ascii?Q?yOvhJmqBrJsvwx36wjmzK0Zt1jHiszzsbvtSaUhYDxQBiCo51bWB93f5d9ng?=
 =?us-ascii?Q?f16CqeC+4nn1azRqedhCa0gpkSDJBX/AKYU+s2cr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adb37ad7-80df-4b4d-90a9-08db35f3fe33
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 16:37:06.3706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQMkzyMKElF3lQFCZTCpg/ostyrnj3yJI49ApPGQWsmW7YShh8JOMxZvxVz+D4Y3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7591
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023 at 10:25:45AM -0600, Alex Williamson wrote:

> But that kind of brings to light the question of what does the user do
> when they encounter this situation.

What does it do now when it encounters a group_id it doesn't
understand? Userspace already doesn't know if the foreign group is
open or not, right?

> reset can complete.  If the device is opened by a different user, the
> reset is blocked.  The only logical conclusion is that the user should
> try the reset regardless of the result of the info ioctl, which the

IMHO my suggested version is still the overall saner uAPI.

An info that basically returns success/fail if reset is security
authorized and information about the reset groupings.

Actual reset follows the returned groupings automatically.

Easy for qemu. Call the info at startup to confirm reset can be
emulated, use the returned information to propogate the reset groups
to the guest. Trigger the reset with no fuss when the guest asks for
it.

Less weird corner cases.

Jason
