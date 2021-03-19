Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315693421E6
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhCSQ3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:29:23 -0400
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:60705
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229785AbhCSQ2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 12:28:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mui8RGXizF0itMt1C5kmmzJ7RSemWTYqG7dLe/nhv6aPazP4wJX6EdSuy85Fpm5GKDWxiGrnVHEJhkMJ/NvMAjeRGp0L7SJabAlHWvMetBAIjUQ/YNDRDQzv0yjEHGZmXCyF0GBjG3ZA0RCwTwEAIzwcOuf5NG8yAUPTzo7X9jAUDux6l7rjfxy+HqmWP3pEDYp8WaENPHzSb0Ve1DsMw5oCZFZNZ7YRE0h7p7qpww4oxv4alrKjxz5EOQMxvtGIB9A5kAJ/YYcPdGjljMzaEsJdlB8yGi5RSRpXLSZzQKgSaRM9uHojAJN0TS7c4jkGjW184iRE5HbUN95mMpOAag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LlR/Zxn+0Iz7PjYIpXQ/aTHPeOZ0cRBJNugiIOGY8w=;
 b=nvsKvtqvtfIUmuDSVnipRoJ2tDHZL1UjbVj/lnDMc9Ywn4p8e1zQ/fqkAWA9D/K/PsBb6c0pr94frLF2oNqMiDKJI8N6KcCzDwX+OpGeRYAB7h3OTklZJKVcxJ3uOexo2xj6CLmOuljijJ69hpkPGiooAqYc+raIpVaddmAlNeGwpNeW/WASWc8Qd4HuehimDVakSFGNwo435mOMixnDZvGpQo29i6A8Xs+4FBTIlaKj80Qpyvjhyo539zJen1MYXlo0++PpnWAG+bpS7lLF4aMhUdtYJrL1nHhAIw4dDzltk0XW9cqH7eATS1jzrgejd/CwL45jznu4KIfsAN9Ujw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LlR/Zxn+0Iz7PjYIpXQ/aTHPeOZ0cRBJNugiIOGY8w=;
 b=lx+9nhqHVN4l2W43zA1k1510UXjBOhWH0zjDgVFCd4Rl00YZN1Mi+S+xlchm37PkgouVQ5GIJI3iEeev8A8Zk7u4X64VJwBlg8sQTEsBbwX9w+774M2TfBeAxGLaoY8tSIz5hPQ7qCwmaNQotz8xZOp+mjhZhiwuxQBFzlCkycIPfvLB+v+biBOx1xufOudL+GyWcK653x2MAncX7UM9pEh5yeTPmOyy9NJPXvGiQvgpLSLrRwof+I+cBVl9LGAapnZi29yoZDDYwbYi7F/7+dq8Brzk1/KQKjQh6A2cHJrsFyUnLKS6imVwz42FhHHlO89jNNuZ1JM8v8IQYWPYyw==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1545.namprd12.prod.outlook.com (2603:10b6:4:7::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Fri, 19 Mar 2021 16:28:51 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 16:28:51 +0000
Date:   Fri, 19 Mar 2021 13:28:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210319162848.GZ2356281@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-9-mgurtovoy@nvidia.com>
 <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210319092341.14bb179a@omen.home.shazbot.org>
 <20210319161722.GY2356281@nvidia.com>
 <20210319162033.GA18218@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319162033.GA18218@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:208:236::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR05CA0051.namprd05.prod.outlook.com (2603:10b6:208:236::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 16:28:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lNHzV-00HMIP-0H; Fri, 19 Mar 2021 13:28:49 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c4580e4-b5fc-489b-8a6b-08d8eaf4141a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1545:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB154526E98BC103EB07DC607EC2689@DM5PR12MB1545.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VPDb9EAUTn4iCqyIXY2f9//jovYl4HJZRQWw5wYJ3+Rfmf5KsSvgctzttxCFVg/wV5CkQir+EqhQbPkSnDV6csMkeNLkHFmpENT52A2oUfgxC5Ct0dV7uuRCOmOSH5G/742eQN7ZPgl07VGI5XhhXQhT4In1qygYDDBZypulyTfqlXRUUsY1i1naz1mCWoWkLxXorlvN2yBPTHnmQ9BhAScHZ2RBN9OiGbso5u4HEmpBF3Ht7f0EDLxuRJb6B0VsDiD8oNVjwVClw40Kt4TAflrfOBxgkt+SL5xrdhtOi5kp+ES39u3i94btkKPiQzbxG5Q/fta4U5Ed/dOSDEv3CZqvq0c/9z2itn79rftjupXZZ9bAISEhKMsQerDk5/MwDnB4n8chbJ/E9iR/zn5nIKLCrX7X8tdcHlkpPyLkMCPQPUb8uRywxfdcMED5oLWulJl+WhijMO4t28u5Ts+YJ/7fhtgk6wMWlFBAOwGDSvM1AAsCbNXsuHjNxtnXL0PhQqYeUeyv/XmHql/IFihlu/G7WdSgjbS/KLFuX1NEAc6BHsTp3s3K3ew7Wh0rsX/8jSyyBV0Donwt/rU1aY20OUkkVX1QDZOy/eo4VPzoxWf68ortla46eMVuGSMDH6LUNB/ZMqdOEUC+RzZH208qMyF6CAlTcOWsGdZh4oHLbhE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(478600001)(9746002)(4326008)(66946007)(8676002)(6916009)(66476007)(5660300002)(83380400001)(1076003)(86362001)(9786002)(26005)(38100700001)(36756003)(186003)(316002)(426003)(8936002)(2616005)(66556008)(54906003)(2906002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?o8bykUjXFHcYmrdGNFPXHgrz/Y8i+diffvKxgQF262GakJTrh5gcAcGSCDcv?=
 =?us-ascii?Q?tQxFdC7MLv+Zla+wwTbU2c1c/CaEEhNQUCW+ZJ3eYQsutHnZ5St1wt/r1+jS?=
 =?us-ascii?Q?0gIM5dvnfSSMEtAqpdtctfXztoJzj9YTHSFhBh39iW16N38uTRB4YmtJxt1N?=
 =?us-ascii?Q?ytZgFqdkbtDWy6SBxNQqr4w1W48lPtrDR6i2N/CN9Fz+NdptzjphV7ivrJ+C?=
 =?us-ascii?Q?x1rcUquB8k2fymaBgqBba+q2xwpVtbkGfQoLNXdXdnPbFXhCNdRGVj/pgUH7?=
 =?us-ascii?Q?10PvRcndl67BRpusSku4F3mxMCxrD+O+o29banEjP31MagLahhE1VFpo/N17?=
 =?us-ascii?Q?im4aOCI49pEHoPmThZerH9O9QuW5WbAdF4pOz0Y/MTff78B7gd2oCSNTSiPW?=
 =?us-ascii?Q?ObQXyJi5y36mbJ+FwXjNS/IoEg9e2rHf/kF73iOJ8LOei/NmQUAC1w/G/T40?=
 =?us-ascii?Q?dni/x8e15c8EkHjk+kS+uTCcHb2UlCDZRKx9WiNbSAC7zNBTualbN1IAOPFU?=
 =?us-ascii?Q?IfhMSaO1/ccmGGHF4Q+5WJYrjsILSmylzSJr49z7TFWMQjPB5kDeCXxbjN/2?=
 =?us-ascii?Q?VvVebVeXSluZ4A1VtsAsr841R+MO91mrKoWBwCFaqdwLa2VnNqLsz1h50xak?=
 =?us-ascii?Q?JftdM3MOuAAiXOwT4VFA0hKkVbK01GvVuzbU+VSatyF8PIgQ8YDEC0iMzj6l?=
 =?us-ascii?Q?suy4+uIvF8Jcb/JJCgufC6s0Bxmi342cRJUE6YDg3Ri5tHbb8A6EQ5+AF0Zn?=
 =?us-ascii?Q?bHkz7hbwEUTPRaDYKRbmX3n1D4gD8BQc15d09YzpRZ0w8vJBbO9ni5MLaWtP?=
 =?us-ascii?Q?KzTWoQPB1q0R+9YLbENDW63Ge5imWN/g/oWxw5EvgmB9eqkS7l/sHcE2m4I8?=
 =?us-ascii?Q?iFPHoML3b/RXS3jgW+p0/bR9C3xlJED5ct2s2Er8wtmu92ydjAU+PAS6/ExK?=
 =?us-ascii?Q?Cny6iZbvCVzmE3rjr6IEkI57He9Xmy3nL5/MVVcvDnabmj8qCzgQei8Kv5Zm?=
 =?us-ascii?Q?bh1OF62R3jxhW9+UaOE3SzFK15ApTBIkxOYI4a8GeXuazeUGhaOYI0MpwZpA?=
 =?us-ascii?Q?DB7z+Ou64ib6flwo0b41csDRTVeP+u9EPLohyN72cXuGC75Cg0Gjp18mp7ED?=
 =?us-ascii?Q?fJq79ws309wGAH8xQsxQSbH9ttGEUupULGLno8eUvo96sClD/8uCd6OYXxIK?=
 =?us-ascii?Q?IRZoFKHy3ALKdCHK2gfuLph4xnLOfAGoc8ztxdPuhlZzDSWavwh3TnBwm6BS?=
 =?us-ascii?Q?3ih7uEYLG6vVWn8HEnqjv0a7xdCSXz6oqK1cm+zK8LOO78hzXEsPuCu+XMSk?=
 =?us-ascii?Q?D+34uzEaUyDHUsLXOxvlf63Eh3gyFtmIJdY4QPfZzIGsxQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4580e4-b5fc-489b-8a6b-08d8eaf4141a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 16:28:50.8845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxllXnyvJaBpgWERniLVIM34ATr8IOxShwlptXECcJUe0uLFmJgcV54Yn9fWnjSC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1545
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 05:20:33PM +0100, Christoph Hellwig wrote:
> On Fri, Mar 19, 2021 at 01:17:22PM -0300, Jason Gunthorpe wrote:
> > I think we talked about this.. We still need a better way to control
> > binding of VFIO modules - now that we have device-specific modules we
> > must have these match tables to control what devices they connect
> > to.
> > 
> > Previously things used the binding of vfio_pci as the "switch" and
> > hardcoded all the matches inside it.
> > 
> > I'm still keen to try the "driver flavour" idea I outlined earlier,
> > but it is hard to say what will resonate with Greg.
> 
> IMHO the only model that really works and makes sense is to turn the
> whole model around and make vfio a library called by the actual driver
> for the device.  That is any device that needs device specific
> funtionality simply needs a proper in-kernel driver, which then can be
> switched to a vfio mode where all the normal subsystems are unbound
> from the device, and VFIO functionality is found to it all while _the_
> driver that controls the PCI ID is still in charge of it.

Yes, this is what I want to strive for with Greg.

It would also resolve alot of the uncomfortable code I see in VFIO
using the driver core. For instance, when a device is moved to 'vfio
mode' it can go through and *lock* the entire group of devices to
'vfio mode' or completely fail.

This would replace all the protective code that is all about ensuring
the admin doesn't improperly mix & match in-kernel and vfio drivers
within a security domain.

The wrinkle I don't yet have an easy answer to is how to load vfio_pci
as a universal "default" within the driver core lazy bind scheme and
still have working module autoloading... I'm hoping to get some
research into this..

Jason
