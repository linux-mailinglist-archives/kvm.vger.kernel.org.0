Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EB136D832
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 15:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239785AbhD1NWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 09:22:24 -0400
Received: from mail-bn8nam11on2089.outbound.protection.outlook.com ([40.107.236.89]:57569
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239634AbhD1NWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 09:22:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Py3KBZ6C7UKneg2/hIkZ/XUf8YTQvJF2WPnco1EtMVrJjnsM6t52I1+ncQ8MpN0mPGygg1SH1VfaCqGFaJNmYn/l901QOTZdfWbsXEuCr8dJAVf69GPsT/6g0KpdsMA9BdRgMz4uahrSYll6lBdNVpaP7+h6wQUJRDPo8h6YD7sxDYF2kIs2Klo7uU6+Fj83cqTkuD3VHlGmbhzu1oQQZxWsttwnDcEF8CcG8kK6ysqkL8gYyX1thjXYLXQUqu3R/BAoejRmo7MDoBdi8TuZzXUqTtx0wkl8N89zmk8A2KW0AnN5LvxBoqKoZx1w14zvxkVQ9q0RN4D2vOhcs3J5sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hyOBpghpK45LPineiz8iwenPHuyzITxCcxMuQknJVFo=;
 b=YKQvW1iPhUqfodwTrGbclrQxfmCiwwF5Ijz4naEza1aT9EIre/i3rC460jnn27qnFS3cxn1dLWACPmyl5XqQRvSwXkjPhn2JQzT+0TeuJ4BGTxCW3MiQ4BzEQRQkV2cl7BVJoW3ax3Dhpth7K6zxBqzRBrwkUhvlVKXHrPkCr3XNrvncxwpbA5TA0yXHTupmUkkoTGUrRjHPw0nZX9yDuRV03qEu5LVnn8dFYK75RANaZ5c12c+pf2mZH6g0Xp8lH2cVK5DMypXLo6JruRhMCtRggqvxm0WRug1Mci+rABTdvSPrZ5RcKRKd6C0QzJmrBhy+T/0AUpZhNdzRryDa4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hyOBpghpK45LPineiz8iwenPHuyzITxCcxMuQknJVFo=;
 b=jeFyg/Dz85w3mN9hCwXa83/ODVOxA29QxpIkp1uk48fkCQaxtFepLiHDQBjiDH04/WMe0P/zLpqE6Q0b7+my0fbrxF/62XX5u04lHk0u6RJUmoDILgesmT93u756aWZEjMLbqiF/sUQwdYpsA5ccTP7mYPlvGFvJQyTDjSWy6yOvdWVTMetWi2vM8I4Nn5SY5PEhVrqgcTtKZ4+WtQpCTkP42BfQF2oc3rBvNQW52uhmox/Z6c7ehYzyMEG33m3eNqtnkYJeQ7m3qHmAqBIXSK3VMcjr/V/prPLmonUhnDe9t4YhVSLDe2AeumURUiZnUHaoAi1RFeeem+LIL9zztg==
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1657.namprd12.prod.outlook.com (2603:10b6:4:d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.25; Wed, 28 Apr 2021 13:21:37 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 13:21:37 +0000
Date:   Wed, 28 Apr 2021 10:21:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/13] vfio/ccw: Convert to use
 vfio_register_group_dev()
Message-ID: <20210428132135.GR1370958@nvidia.com>
References: <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <5325cd47bf170b66591bc1e64bf9fa3aa9c365b5.camel@linux.ibm.com>
 <20210427221030.GK1370958@nvidia.com>
 <564ab34574dac135cd4e2f8f1816467d4d6dc25f.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <564ab34574dac135cd4e2f8f1816467d4d6dc25f.camel@linux.ibm.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR14CA0013.namprd14.prod.outlook.com
 (2603:10b6:610:60::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR14CA0013.namprd14.prod.outlook.com (2603:10b6:610:60::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Wed, 28 Apr 2021 13:21:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lbk8F-00E0tN-Pw; Wed, 28 Apr 2021 10:21:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06c08364-bea5-48df-cdd5-08d90a488d12
X-MS-TrafficTypeDiagnostic: DM5PR12MB1657:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB16571E19D022DC67E1206254C2409@DM5PR12MB1657.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DLHjpi8NHyLAKlk+ygQ8xYW91RJFWVukn+ElK4BPCVjzA/gpk+F9KSNrjX3Dy9gpgCI9cW7yvscl1A10X69msrRT7STBod2MqDnyP1BtMPdpBOvwQb/gXkvgF9O+9Ro/amoKmFL4elrizCsp8baR2YoDRon4xAh9HHYGclJg3+PUomqQOL2Q2E4BVJvBqf86nWJ+du5vgu1YCdMOSt2eOiQTdnCGggaT4Q1LdhW4wMha/vKUBV+6ZAwdplezjxF550E5YFPUI0YMIC7GXSxJcPGcEpOaNF0eoL8/IHSgEqHwIAnWZeb63hmeblCOwMMLp6oxD3HX0CncA5HQlYHMF+uzDpEV0FypFI+KIDqKZuQFj+dCKRXXt+t8xRdKe9OPG0MjAFvS9zl+sn0369WQKR2+eXwThUnWZOCxx/59hU2lDow4yiIIBR2T5zDlj3nhLy+uyhHE25TNt/V5XChKDZL3y9d/pJHZIOVfgXITSGqRpLOc6FWhknFxWL/i2zeGBvaDDGx4lEtLcK693ntm582Ac2rid/9TupXvTPLdH/C0iw1ltOKK1NoP99bD+lraJwQO9R06oS/E/w/Qe0pANQ+lJlno7Z5mKN9KL1RN+SE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(83380400001)(66476007)(36756003)(7416002)(86362001)(33656002)(66946007)(66556008)(8676002)(4326008)(6916009)(426003)(8936002)(478600001)(5660300002)(9746002)(1076003)(9786002)(38100700002)(2616005)(26005)(186003)(2906002)(316002)(107886003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YDTFOOkUGrFfbNJsqsnI/2aFgnuaZwPGmJ7nu0pQKz4lxE+VoPmQWRdCU3b4?=
 =?us-ascii?Q?/9Povk9lvANxaS03y27ivxH2287fPxagJo8hKM5hXQ/uSxnMRJEOEt9StWbZ?=
 =?us-ascii?Q?763dY11XDuW6dEuUq8pKVETkUo+zUPzkwReneTzdAAwe56KB1p0juRfH0nTz?=
 =?us-ascii?Q?KE9iripfcvg/8ft4cVt42AiQCGkWf1fl8EQEIl4FOB27wsl7IMOQLQs0olz5?=
 =?us-ascii?Q?Ogzo2+DOnAdezBBnMvrnlYXiWpHLVJBydehO/HtjKwbb73wnVQifWho7y8h8?=
 =?us-ascii?Q?gTzWA7d2kygQNhA3ARNZJkoWDb4MDrqWtyv3nRPx9qwI1X3EACKKajfImh3o?=
 =?us-ascii?Q?cP5AN6z8ml+QRXANvELXrQ1bo1SN/CbvFVAiK3Z0Toch2YYqEH6JOcA6sHqv?=
 =?us-ascii?Q?Cs/j3bw3TQZ+a/03d1eEMX34YQ5d8TjeAutyTsf88QLGaE0ZwgyHCDpzSIE5?=
 =?us-ascii?Q?gML5B9jhvmmnW/QZLOuALlNI54poH6s8Eb55hsic0RLmVw45TPwybhK5pPhu?=
 =?us-ascii?Q?IAxkDrmV8zSwASaNuI3iswq2ddNGVnOsCqF9cUZju7MWZr+hOHyKFa5lmC1t?=
 =?us-ascii?Q?fPEzr+B9oIWkLGLdHD5UJ76Svub8kp8VgphIJt+R606rhsFjODnQiSu/jNeW?=
 =?us-ascii?Q?DbrwsBSZuzdaTlVbYX+1QY8UGZ3jy6walbgyW3e8Gawz9oLie2CfxppmsolS?=
 =?us-ascii?Q?9fcKVgO15ZaEobUKuVugXQAwrimGoww6PUwwoZ0w5fdo770pFbqitV9+IjYh?=
 =?us-ascii?Q?sI7RRbs2xmnEDtp6j6lCXdmRov0RjfehPD8Sp8HZhW5KLguFKf2nwfI1kKxQ?=
 =?us-ascii?Q?RCqIFkbTIdgRl1nkLrBXu4Mrh2FHDr787usuF86fmNGBoEREnPVJOvy87W58?=
 =?us-ascii?Q?qFLc53ZMCQnn4ek3KYnrYnxU/IPS5lzFRGBC5yP5/K+hjglwOLw7hDBIQF3/?=
 =?us-ascii?Q?qdSnB34Bl3DmbJRF9h1sByWGQcKgIJlG+P2uUzBP/OTf/YbM9G9vFjvuFRAH?=
 =?us-ascii?Q?3OX80y1h0uHNy0m1AUPv1w8G7tr5KQRVm5TygOXCf0hcRSfLy9TrtXntANZL?=
 =?us-ascii?Q?XuTOfYgi3b8hxrNdkeUNB8r3Cl9DfHA4DQofTCYjqqOt0ujFJ7vdy0K7w4IO?=
 =?us-ascii?Q?rdVIhWhgkAYqUpnXoiveUEzJUubBkWxX6EXhZutT1mVRz2tHn5tQdrXCxIeh?=
 =?us-ascii?Q?IOV6PHyj+pqC+3uhdPX75aGxcDzP716jLQdLqZdhb8YSf5XQaS8t4yo2VA8o?=
 =?us-ascii?Q?9mxdl/4gib1MYybzRfE+odyWPfGB9OpK94VJW0i6dCfGeI3DGayrOmU/hhhT?=
 =?us-ascii?Q?oxZly7jT+t1Cla5a+GZeesYj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c08364-bea5-48df-cdd5-08d90a488d12
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 13:21:37.2447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+kXP3fCELpgVmdacfVkJG+byBzAodRh6HJxlgPaOn1l8eI5jQzNQ1Titlt86qFM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1657
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 08:55:51AM -0400, Eric Farman wrote:
> On Tue, 2021-04-27 at 19:10 -0300, Jason Gunthorpe wrote:
> > On Tue, Apr 27, 2021 at 04:06:04PM -0400, Eric Farman wrote:
> > > > @@ -132,19 +137,28 @@ static int vfio_ccw_mdev_create(struct
> > > > mdev_device *mdev)
> > > >  			   private->sch->schid.ssid,
> > > >  			   private->sch->schid.sch_no);
> > > >  
> > > > +	ret = vfio_register_group_dev(&private->vdev);
> > > > +	if (ret)
> > > > +		goto err_atomic;
> > > > +	dev_set_drvdata(&mdev->dev, private);
> > > >  	return 0;
> > > > +
> > > > +err_atomic:
> > > > +	atomic_inc(&private->avail);
> > > 
> > > Since we're unwinding, should also do
> > > 
> > > private->mdev = NULL
> > > private->state = VFIO_CCW_STATE_STANDBY
> > 
> > I can change this, but it looks quite weird to do stuff like this
> > with
> > no locking.
> 
> I agree, but mdev_create didn't fail before, so backing out part of its
> work seems weird too.

Before if vfio_register_group_dev() failed the device would be left
half created but without a driver attached. It wasn't good.

The way it should work is up until vfio_register_group_dev() returns
success there should be no concurrancy and no touches to 'private' -
those WQs should all be shutdown.

Ideally the private would be allocated here as well so these rules are
clear and obvious

Jason
