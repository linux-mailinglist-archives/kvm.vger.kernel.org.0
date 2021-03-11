Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC810337850
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 16:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbhCKPnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 10:43:31 -0500
Received: from mail-dm6nam08on2060.outbound.protection.outlook.com ([40.107.102.60]:2431
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234156AbhCKPn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 10:43:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ht+5q+76+X1sAxjQBj3lXTL2okFxfLMIyF/EgDURDsFTMVBz7QuhSevl/OWjqBV2Q96x5jZN+L+gc14eN1RdaMXl+/eqbSuMoQI8dpkMtTSBYW0KynkbmBWM5UpuG5gErR2ImSr0BX8uB0KdpJaMCGrjwlip4qsw0sskGYe7L+82SM6mebYu4VZssBAtdIqgpzJySI6gdSykNev6WwdB5CcV4xX87VUIoxMoHnfU5xmeHSTiqjG3JI6FTLOdt1vUKA5IwEsE32hPjoiG+d5pgjhfPeun/olvwPwbK5+jVShYdF0xD1++JlXyWdHrKXpDOaJAUPPSvHFH8KId5f7NOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzjNbxqVz9ClPz/NJ8rHva4JIxoSlpwEJoxR9Syxk7Y=;
 b=jV/Dv694HH+BWHdpVrufAb2hg8mghQLk7aGS1vWYvAU7Eq+/Bq6hRsUfAf6VdR/52+KNPskBTc5FYEL8rT6deO6su9wZMvs8P9jAQ/lcyTmzEngqoW6I8ihgmqd5hSJ4I7ivlwBCnt0/Pa7bVZkUIG84Opheah7t0kf6YpcjqaUf2IkaHVeI+OzlLiNzKmMPwYKwnku3Ue9YmDrl1nqWpIkV4WyaznECHMV4VkBO0oEl1Q74UZgahizO8V+ruw2+pmQ2nF+ttvg931/rcBkK8yY6KMk0yRlOKROuP4SqnWeWYqZE9fbs8gIjcFXm8Zs5x1f5Uvximjv+uhdGKqcTgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzjNbxqVz9ClPz/NJ8rHva4JIxoSlpwEJoxR9Syxk7Y=;
 b=sKGMlCKjXew2N6hW59FNRzfSXYUifJWUF/b8x9KDzTvQ4XrcD3wJUW7qeLHoKRqbzOG2GkifCKWpl99DOfwEKGCmIaLRuxzFd2kjGvQQjN+cw2/LmU2fmuN25wrADPnpphnbxn/msBj3wA9F4H26RtGkEC08Um0KozP/LuCOYc4k7csjDIp6TFLny5G0RcAP/FJTpqrb8ZRsGNWKCunXfdBmbMGHY3Fqna3eL6/FUlMSx/psmCvU1uFjyGlIcQ3oErOGfBn3lQawzn1k4YZrDnCnaFt11knQkC1YwO/uEDK4sLOAoCKvnC7Fg1HG+zBbgfhhZjtUeUgrPLOtKdEq/A==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3593.namprd12.prod.outlook.com (2603:10b6:5:11c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 11 Mar
 2021 15:43:26 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 15:43:26 +0000
Date:   Thu, 11 Mar 2021 11:43:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, mjrosato@linux.ibm.com, aik@ozlabs.ru
Subject: Re: [PATCH 9/9] vfio/pci: export igd support into vendor vfio_pci
 driver
Message-ID: <20210311154324.GJ2356281@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-10-mgurtovoy@nvidia.com>
 <20210310081508.GB4364@lst.de>
 <20210310123127.GT2356281@nvidia.com>
 <20210311113706.GC17183@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311113706.GC17183@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:208:c0::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR05CA0015.namprd05.prod.outlook.com (2603:10b6:208:c0::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend Transport; Thu, 11 Mar 2021 15:43:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKNTA-00BKKa-B7; Thu, 11 Mar 2021 11:43:24 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3f7c694-ffc6-42a9-86aa-08d8e4a468c4
X-MS-TrafficTypeDiagnostic: DM6PR12MB3593:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB359326DA9BBE2C9816D60B46C2909@DM6PR12MB3593.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5RHcjy94P1KV/s57Y8yTVoj3f7+8e8OCPNjTur4NXrZg0oWYOP438ETIRLdYxTJtC8yNIrpyTTy1uINEaLmm4NXRXrG+UvWBIJt/dr4RVZtxqAA47rfjdZz5U/B1tJCUEzPVn7elrLXP4h+LLDH0VCSZnhEIwB2rlUG7kxC6Oy/Vp7qMGXUWU8MTHBj3L2rv/1+5nasOzL3M+jL4JC9QaEZ9bAaWIwoRTf5tS1Rzia8dm7CPowR6Z6pOSFrXJ6cUhR7id/qbZ80n8pY4n56PslUTSK3DbZR+qzvabmvjL+fJcQwl0CyYk93aTqJF9WkuOHtJD/nCXBhQZzFggINzY9Rh1BAn8xzgqhDAyTrsjUGTms/BdMV1l74fubRhh9xUpB5DIaKfQ5XImEIk0K8hFDedmtQZJeT6wrJVrUKyxXPdmDV46uyvfQrDHidK8qXL720SPpaSo5hDlzHXZv+3rMU4TlrHXAUGjOLVoXGWmDsau3TRJ4XErw86Jh9Ij2IF7mI20ib8f0lEUBSefE80ry6nuIk6MXgnNHtp9MtjE7tOI5Uc3NIYIKS0qw/ziIm1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(5660300002)(66946007)(33656002)(66556008)(4326008)(66476007)(8936002)(1076003)(2906002)(86362001)(9746002)(8676002)(6916009)(26005)(478600001)(186003)(36756003)(2616005)(9786002)(426003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QFN/hyZ/5jnW8tB2/bP70bwipOwO+vLW4NWxtGSDSdJiYc8uzvDTGzNhdxBy?=
 =?us-ascii?Q?DCuJ3lvfw3uP3cy0zyTlgsN7qCmp600jtGzlwsbUZI3ryFYUZG1ZUh+lQ8J4?=
 =?us-ascii?Q?iB7bMV8Oerb1Ql56C5K3X0NkFQL415UGLHBp5204GWB0wWICSap/vf8KmVqH?=
 =?us-ascii?Q?ay5EKy0/NHxCdy3dOXHXQcouTuJ8opNLA4+H4T/wmNscmm/qDBgJ32cQLYEC?=
 =?us-ascii?Q?tbqB0QdPQaxycLpZ9YDr/NSKY1PLtjqCXgIqM8JaC+W4NEvCwFdZI2TGAbXA?=
 =?us-ascii?Q?BzT/BHAd1sFQEwxyya8YbukO4MNCAwtNwJCTjP30PbWm9k9SBIodptm0ArA0?=
 =?us-ascii?Q?xC5+7X3VmZBoPZxjpm8otb/ly/CMyi515jRsTRbX74OuIaWwAkECICzuC2Zf?=
 =?us-ascii?Q?INBLSBet141bQBnuzSyQ+mS/9SWeB7RE1InBreyjfVW/ioej+BXvF6W9BEby?=
 =?us-ascii?Q?exd+QaPGvntEWUn58g5Lor2jv5s2p1RukuideGHF4i2Iw7i7YryqoxlY+PqR?=
 =?us-ascii?Q?tYJs9H+439nIpkWyVolYGIRbh1LIdBZ9kFNnjbhdTzqxn31P+w6nQb8kbxzS?=
 =?us-ascii?Q?mcS8VHkV+zNGYDMr/o0RrgN3qBsaT3TAYT074g7djc49EDEqeKQneU6Vhy4p?=
 =?us-ascii?Q?+sB5EjHy8d7DIfRY4mNdjC2Q6k6dOdKHGZGJSmgn6iat79lmvmqrKQlSRJTW?=
 =?us-ascii?Q?zffRcD3g30PMmgcRDSfKj+8HZp5URMQpKvBnELK5amtPIQj0zNPOdN+uWN7+?=
 =?us-ascii?Q?SnHzt6Du0UARZyntFTLibtMbJCED52rFZs60CvFz/eVqn+prREoWAxEzKnJ/?=
 =?us-ascii?Q?3BPnJIKZhrTVzrsuaHV1gGKPPDYfuAmn1tmW9wqRZJZ/XHYsEgf+B7VALrlD?=
 =?us-ascii?Q?727JgIcy9VzsCWH39eXFKmrsTyRM0EK9hoGtOfVt8PEpTk6LZuYiuFhl2YDm?=
 =?us-ascii?Q?KOJoMffo97Ua3xh8cVp0MWzr6pdR5sGQ9KKWe+aqNffi0Rlb3o0Xt3koF4F1?=
 =?us-ascii?Q?mP2CQaeUBgVu/uq43oYdwlhZPLsuc9djIa1Y8PdajAXtrYJXy8TnOIoRuwqE?=
 =?us-ascii?Q?rcQPUPsS92PGRaIu42D/wL8troigxkjLzxkXoO2Hqo8PhRIZ3XUGZNYn2wfE?=
 =?us-ascii?Q?jt6Qj6r+8UIAcCe/Ae3WtzcKWGcqjUpLdqlYK4hO7S22Wq4WonpWLJjpFsae?=
 =?us-ascii?Q?3EGG3baio1ZnJM6UxxpxC1RxzAcz3hnF+4sMK8rRsSOX9eZjF4srsHNsib9a?=
 =?us-ascii?Q?grfgSLpULiQrs+b8VpHZw7wQGLimNLAkVmRCkaNkt7g8ZtkmDg+5KgCN3aKB?=
 =?us-ascii?Q?xPfZGLRwbc/ww/1+7czvMlMk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f7c694-ffc6-42a9-86aa-08d8e4a468c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 15:43:26.3170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cvf3DLgBWLwA34oN5Vw6HnKEcs4i+ZYbb5mF0HYP+pnFceGjPNFeTQvnNful57L4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3593
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 12:37:06PM +0100, Christoph Hellwig wrote:
> On Wed, Mar 10, 2021 at 08:31:27AM -0400, Jason Gunthorpe wrote:
> > Yes, that needs more refactoring. I'm viewing this series as a
> > "statement of intent" and once we commit to doing this we can go
> > through the bigger effort to split up vfio_pci_core and tidy its API.
> > 
> > Obviously this is a big project, given the past comments I don't want
> > to send more effort here until we see a community consensus emerge
> > that this is what we want to do. If we build a sub-driver instead the
> > work is all in the trash bin.
> 
> So my viewpoint here is that this work doesn't seem very useful for
> the existing subdrivers given how much compat pain there is.  It
> defintively is the right way to go for a new driver.

Right, I don't think the three little drivers get much benifit, what
they are doing is giving some guidance on how to structure the vfio
pci core module. The reflck duplication you pointed at, for instance,
will be in the future drivers too.

What do you see as the most compat pain? 

Max made them full proper drivers, but we could do a half way and just
split the code like Max has done but remove the pci_driver and related
compat. It would static link in as today but still be essentially
structured like a "new driver"

Jason
