Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BF43A0810
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 01:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhFHXzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 19:55:00 -0400
Received: from mail-mw2nam08on2075.outbound.protection.outlook.com ([40.107.101.75]:48288
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231409AbhFHXy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 19:54:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGpYzKlbbQuHKj2+yfdEuHgKx09hJo31hqmh05dZPHcYuE2FtYL1sJdiwnAYE98QqCtrfyjOdUY7gCqP1k9twa1IImxwUq8nGtT6HCULAuvzgAUYyoN95lBdYifXaigwqvlF2E4irErzx6EWsUbjU02Z+Xg5udaoG7mkURDO/v2L6QqSGikWe4gxbsgK3GHoZzSxJZpr4rzK1JBQ2Xy1BrNDghFFWPsT68zcf28pL7/fP6gzXv4XN9QsZ5FZwYI0UmCKujG7mSymOMndCkeZM04SE7DZjkVfkkmHet+N0G5vAjA1rFztTdab4CfFp+WSdThtu3jH1Xj+B3SvHS+xjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mdccyyx3u1P+LHslqyDQG6iN/P3leT1L/yZ3A3FNQcs=;
 b=ZlkMvxPu8ydTyHFTAD7QpD06HDOWL9K4u8R/cNBSXskbGCYAxUE97rCc7Rue5O+mzI7jdosqkGamGESTrbjWL4eGdSuDfZAU9H1P4Vqx8bPBY8YVzDdwkCMXtNd226qjQzjGytszBLlyIbdC65tM6FauEDndvI76KumVev8gZfSDgcu2GjcF0Cu2siq6b2lh9kBRMnTWhw4uy1U3QUS8ohNG3yGidHdI2CZTM2tyHoKeEBUmbQwARiju4x2BaMp9ADR/KrUEBYuXKjOg2RT3KAiWbhbkMb4OWkl1+u/Bo1kt8TJzNFiztHpDn5qJqX+2SF5ulUEGY4VuH8IXViWbuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mdccyyx3u1P+LHslqyDQG6iN/P3leT1L/yZ3A3FNQcs=;
 b=lUjzBhG2/cDOFXpPXDev2OXodImwp6Ed1VLpAn7qYFbb34tyFzM7q+vuBkmZ4FXV7EGvRckOg7XqY08ZSqtflcKOBux/u5RYbkHNRh7JQEY3qkLw6cUlf3Sssvw3GGBDPFNybrz90s/8YrMRXkVfS9gYJyiwwVP2Uz+7CLShxn3GzYEXdk57b7X0TguM3NtKxA+rqITfQQKL+W+6zk/nW1uJo9Pmvyxc0dhxrr30JaXRwQ7T6immvjlT1HoIyX7VptKWz4U6cDOzTbPHORsivBVXQHS5zvrR5bNTOjpyXz+FnC6nozeTcEvLQh2kc/jabIBNerXuSvnVLXQuaRHocQ==
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5521.namprd12.prod.outlook.com (2603:10b6:208:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 8 Jun
 2021 23:53:04 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 23:53:03 +0000
Date:   Tue, 8 Jun 2021 20:53:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 03/10] driver core: Flow the return code from ->probe()
 through to sysfs bind
Message-ID: <20210608235302.GA1037007@nvidia.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <3-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <YL8JNWJeh6JSB/DS@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL8JNWJeh6JSB/DS@infradead.org>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:208:91::36) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR05CA0026.namprd05.prod.outlook.com (2603:10b6:208:91::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.11 via Frontend Transport; Tue, 8 Jun 2021 23:53:03 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqlWo-004Lve-T2; Tue, 08 Jun 2021 20:53:02 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31d346df-9691-4ef2-2730-08d92ad88e33
X-MS-TrafficTypeDiagnostic: BL0PR12MB5521:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55211644E93E1BEBA323C0F7C2379@BL0PR12MB5521.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VyDjuRqXyoXCRGE9zL7Q4Xb2LYmZwod+vx70IUYZNE3KupmX5V+edxE7veC1ls1gUvrs8TnX8ydTWzwiGl53RC398drd7phOQv8U/jrh058lVann9yPYXqfP0ekH8587d5UFKddWlnMjt0cvRBGA+kdNmJPlKq3n0ve0kJ8w6cN106MVk3yO34oCBHB2QXo1073K/1kxx0rvUUrMh0zw39YKepsYHB9Asqy0fJtEPVuFh2nN+hC4uAGYLvxmUYZmxpIAYhKjV5Da81mpAp6jPJks40sOWpycTvs84M5nghv13vtJii0XZqaw80fgSRnbobVvYn2G24UB+XZ1aiXw/l8olXZX7WaM+AOsq5b2UnppATBBKvJDwJx621x0psw54+VuPOryd7IEchwpUvE+F2dX+LSMody6byZvHs30Hdex/MePiPIWQaxRlYm/s/tf27UpWw9eqlA7QGAFqBXFkz9yeWoPsJVqzWQ+FrMfqMhy6fpC7ctmFq0PA9f+OFtSYPG3n72foUQfF9MJt1W0cCiq2twjflqpKTi/0VCEpJgm8yaQjEAnehlydJoRdyDdSoNImxVI3ES8oB4GEdvoI3f/1qQ1j73ui0AvzShLzZo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(2906002)(316002)(26005)(8676002)(1076003)(4326008)(54906003)(86362001)(5660300002)(33656002)(478600001)(426003)(6916009)(66946007)(9746002)(36756003)(2616005)(9786002)(66476007)(66556008)(186003)(8936002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gYpXU1PGXOmWCKYuPmZv8r0H5MB+yvKvlnk4zYxnQCDZbEnZQ8EBeP/7Kcd8?=
 =?us-ascii?Q?PPRuI2c8GTZdRAW1UOi65gdXxKqxLpvH5KdZb2hNBqLn7Wb/9+Uu6fYSLEKT?=
 =?us-ascii?Q?et4mvuI8y1IFvcZPJ4M8uNJRN4ggFFB0cJRKQjGDuFy777PfZl2jrxSlUONa?=
 =?us-ascii?Q?szlw/fbk3bI5pBVpg4oe2+kewNqpOppilS/VvwR6pYvsDNS/7vkmoidHvS/J?=
 =?us-ascii?Q?Qj7rBUNlYP9TIfuMl/z3SqFdTifKOVa4t+c+rCNAlgcb6/LYyZxsyfCzt+G8?=
 =?us-ascii?Q?s88UnWjleuqLuEsCAvCUCi6XcuI3kjyRIE/2io1KYounHkW0qOWtoOXIejko?=
 =?us-ascii?Q?tPC5yNgvkBWndHcN1IWqmQVeqhpTqqw6zFn0oWDWjWonN+chK3QZ1tncyxcg?=
 =?us-ascii?Q?xo6Q4I5IgnPFGiPAqZhNPEOGUbCXeVusRnj9UWMaOLVij4SkI7BliGYy0Gce?=
 =?us-ascii?Q?AvlDhHESjEMnXbBw/MeA7WDdMG4zgqX2Pae9PfVoWHxZIR+AM9pjNlg9lLZA?=
 =?us-ascii?Q?1ILy4R1/bKBqwXtp/lfSSXxuIDYWV3E/MuOC07USJcF9nrreOl2yXg1E4Tk5?=
 =?us-ascii?Q?iSfSulsBeN+VFlRiQdSQQ42bNxEA1Uu2zOeZmEqrRdrt3zW5CrVLblSWjeua?=
 =?us-ascii?Q?lwKuQixZYDHgR4W2ppccgLlmMS8uYN4TEttEXfXAEetd5RxbYAQbCi085XwA?=
 =?us-ascii?Q?vmoMC8je9E6FrCVZJv7qI8G/IdSyqNMeIuWcEW8luQRO9L9Fwiz3/5ne1mrJ?=
 =?us-ascii?Q?U5gVeIfxf8zoIgzj1DQbG6F/nLkT7DQb8HtHpwTYIjuop3HOF3RrUuUmjkM0?=
 =?us-ascii?Q?WB5TGs8RagLVa0Sj7evb4hjEOz0NI34NFlkX7w/6H3khuCGvIm8ZqUFVM/fF?=
 =?us-ascii?Q?PP3+nqfILS1A8k5vdCu7eUgBhBJ7SKHmNO/HfgjY+Hrl+4b/6GwxhTYD84g7?=
 =?us-ascii?Q?OCFpzDshooBb/8TyJbY4sVum8CIzJLJPKQGG6LdeZXsGpcDnQeAfKvZm93Ng?=
 =?us-ascii?Q?TkkoPl9KVwbk0rBVCmFqfvU51IGJfPcxzm5OaxRHD96Q+8j0JTtCgWO6svm0?=
 =?us-ascii?Q?IOc7g84cnAIGM75u5+RIsX+2Xdd4QvDnNnEklP9bfmG+0/x2a6lKDcnJICJM?=
 =?us-ascii?Q?KRlOFsvNOTzrRIatjskpRPDtM7yhqfBO2kzIGoPbGZTac/TYg4//nwhkJu13?=
 =?us-ascii?Q?BtkcOFh5QgTAmZhVSnLlbV2ZActg2CXZD1O2LBJ4wt1z0VRgydi8Q6cUW/+t?=
 =?us-ascii?Q?pNPw+b4hq8Tv3XGg4KzWMDrrjJhsV7jISeE6irVhshLVbplLhGoTxNk/2WLk?=
 =?us-ascii?Q?VjwFBGwZcCa8erjutAk5Z/Pi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d346df-9691-4ef2-2730-08d92ad88e33
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 23:53:03.8457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RqP65b1/I0jDn5AO9Qu+kE0OZyLNZxjvPsYEYyN0oep9MU4RHo6FBqgGXze9nmf/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5521
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 07:07:49AM +0100, Christoph Hellwig wrote:
> > index 36d0c654ea6124..03591f82251302 100644
> > +++ b/drivers/base/bus.c
> > @@ -212,13 +212,9 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
> >  	dev = bus_find_device_by_name(bus, NULL, buf);
> >  	if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
> >  		err = device_driver_attach(drv, dev);
> > -
> > -		if (err > 0) {
> > +		if (!err) {
> >  			/* success */
> >  			err = count;
> > -		} else if (err == 0) {
> > -			/* driver didn't accept device */
> > -			err = -ENODEV;
> >  		}
> >  	}
> 
> I think we can also drop the dev->driver == NULL check above given
> that device_driver_attach covers it now.

I'm glad you noticed this because it is wonky today:

static ssize_t bind_store() {
        int err = -ENODEV;

        if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
               err = device_driver_attach() {
                    int ret = 0;
                    __device_driver_lock(dev, dev->parent);
                    if (!dev->p->dead && !dev->driver)
                           ..
                    return ret;
               }
        }
        return err;

Thus if dev->driver == NULL this will usually return -ENODEV unless it
races just right and returns 0. So I fixed it up to always return
-EBUSY and always read dev->driver under the lock.

Jason
