Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF873AA7CB
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 01:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbhFPX6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 19:58:33 -0400
Received: from mail-bn7nam10on2055.outbound.protection.outlook.com ([40.107.92.55]:39825
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229503AbhFPX6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 19:58:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDKQeoG7suWDpYxxqESRVlIPPW9mH4OWVuC+6G0D05K7zPmbis4b7pjVYI5x/VZQQbpnPxO9jKbpLTEmp8lL5vypY2CePK/+6/Iv069qDd+NsREBKnlhAMvhgaQvxmIpciwFXz/HSUwwUvSwD9FnVvxm2o9XWRXKx4AgEEPOLWjenfpgIzRQSU8AWh9Den7JYi16MSBV7A4yHsj68+g6f2lfk4ZmxPzXbXK4Cyp/eGcPueGreW22u1eX3YyOjp6JgnzCAEO0EWXE7jB7iwHma7l+lfe994mjW4oX/e2fBnYsCFxy6zeilKy3ch04f4QdpOO2gmS6wiyU+js1tAiQUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLfUzRfAnFdgeKpsq8qQ1II8JwIrDFo0ESfVnXkHpFo=;
 b=YbQc9HdD/FETbCM9I5aXN9JCVUMCelY2ZMaa/N9baoDnoaeQNhBjLc97BZ3CU31ze4eFq+nukNFl5LK9zHWjOppJmutqddUHy7Lq7TiNe8xI9lGxsxhV+9O1NusQNmS+xRR0l0X7bWijKMq+DyJTTKNrRydD1hLTVSt+0UXq4/YZv0I5JZweWv8cO01mNI93h/QMRHtB3vwxde+R3nqzbEYgGY2fqaXAzWN4mqcM2OhwO1yhe6+7zBuwtcj3tfnxr04wvyyhwt9zQY0ZY2i1m0xWu/+X3n9/3waNtM+OHWXR3ymKXgLwIjtJaVr/bHKmYZKutOPVx3QrWktg/OVWHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLfUzRfAnFdgeKpsq8qQ1II8JwIrDFo0ESfVnXkHpFo=;
 b=IeQvi+cGXJDQyXzSRPDz8DLDen+9WlNDBo8O5nhD1xX1pH/8PWw0IIbhL1AtQpUPk1UJLPLj2t4HwVBXdrUHZSJeaRaORWTplaklM3qkxfKGteiJcqhgrPSKOI1aHHWC1ZM4xkJbsw1bx6StpNiWjgmZ1hjOHaicb2GVSxjYujrcq8/+EFgG6PZXg+nFMXw8FiRi7Qr1U27rmua7e9Gl2j+smf+aEx4kXAIVE0BY9n92RLGxDyxJ2sVUVP6xu+XOXBopgGn4AbWbP8HQGr5BlcJ2OknU50g2810PCFlZ4/Ukl6tMgkkrBNt1qjcG2tszmY2migzG5iaTwXz8L/a3Gw==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 16 Jun
 2021 23:56:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 23:56:25 +0000
Date:   Wed, 16 Jun 2021 20:56:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210616235623.GT1002214@nvidia.com>
References: <20210615230017.GZ1002214@nvidia.com>
 <20210615172242.4b2be854.alex.williamson@redhat.com>
 <20210615233257.GB1002214@nvidia.com>
 <20210615182245.54944509.alex.williamson@redhat.com>
 <20210616003417.GH1002214@nvidia.com>
 <cd95b92c-a23b-03a7-1dd3-9554b9d22955@nvidia.com>
 <20210616233317.GR1002214@nvidia.com>
 <f6ef5c0c-0a85-30ca-5711-3b86d71c141a@nvidia.com>
 <20210616234437.GS1002214@nvidia.com>
 <6c97caa0-f6f6-11c8-9870-4f08f6f8d6a0@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c97caa0-f6f6-11c8-9870-4f08f6f8d6a0@nvidia.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:208:160::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR13CA0017.namprd13.prod.outlook.com (2603:10b6:208:160::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Wed, 16 Jun 2021 23:56:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ltfOR-007xwQ-JX; Wed, 16 Jun 2021 20:56:23 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3eea6bd-a974-475c-7b8e-08d931225966
X-MS-TrafficTypeDiagnostic: BL1PR12MB5380:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53806F69A1A9A20D042670EBC20F9@BL1PR12MB5380.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pgsqdaf6HJHokwgEkf1cKx2tqzbCblFe9QLqqsa2q9Nf9rC7uQoxhslv2jAxbEonEozhTmLlZXs6JAoGDnYhA3O4bS7iLqEPCEhsCkEF9Ky4mFzdK3wFVTpnnXhBdRCjPtMThjPyyHg7ACkSHXK8TWKUdPamFF6/4I0+NSzvWpWkG74/K857rJR2YKyCdBSuQmKWqtULedvmdCn25uJlX00g7VBjTpz5MXRZl4c1ml9bU/EUfTN3D24PiK3lwK+GE+dwZvUBfFKDt//Rs9he0vW1Fv0gx62fvnDfeBen2Yh0LW2mUX7DuJc/LfW2nDgpHqKhVmSJ66k9l36oVTLGJZWi7Bc66HtFn2F+/MYDwjEVKKA2ByI9Vfxprk28SULxJFyYZvIHKwZF4pUa+PS1UboDmYU6ffVMVN27vUfNwjqTG/hb48D0gmvS38yiM3xnpDCCCdOeha8s6C0GzJM/Fkz/Xe7IUVuCyRWmmctWQZ21Rhk5pV6ddH5riWiEjtOHgwJYNaNiYjnPpaSbKG1qw3dXA1f96A1eBunRazkur1ZNJERmjrghuwxk4j5xXFqUyaw3VsKU37nFxZjBrwSt7cuC4Gp8tMYsWkpk8Mpg0RY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(5660300002)(66476007)(53546011)(66946007)(36756003)(2616005)(66556008)(38100700002)(478600001)(316002)(2906002)(86362001)(37006003)(1076003)(6636002)(33656002)(6862004)(26005)(9786002)(426003)(186003)(4744005)(4326008)(8936002)(9746002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TNov1zgfK65ThK4xR6I4YAQtWkoizDx7NWZnheZjv/+1tri3SodfuuDWjAtG?=
 =?us-ascii?Q?Ixw6rqTIO+X4UMMf4VRtR3LgyAbeFnp18zf7Zy7VxV5UcIyx7jOlH2Jl1/jK?=
 =?us-ascii?Q?jFegySQqILXxioaaqeNKShC7COE9b73A+Xojgqm8uGxCA6YOuJ+cXeHW0L7t?=
 =?us-ascii?Q?BAcNtnbL7KgddqGN8XlMJl2+vl+VwxMdioiYfCIN+hPW8giUZT3PY35KJnXN?=
 =?us-ascii?Q?rMXQyGIrUWmkIaQKm9fGKqMBcLtjI8V6TuGVqOSMYFtGvgSQ1zqMrUL0HB28?=
 =?us-ascii?Q?qN2TKyuySorkiq6hWQ0fkT8XMLAvaShkLnDdN2EZ3LiWBCb/n2QbL/+lAaTv?=
 =?us-ascii?Q?a0Iw+4coiqlSp5p2wYlRn42KnI/zwQTqmeuOX38lWKhEw1o6ySl01djdTumI?=
 =?us-ascii?Q?kMGcd5l1UJ6Vj3eRvfTjNcx7seDhXIp8dowf4RGc0HB8kONT2ZAfk5Qnpe0t?=
 =?us-ascii?Q?umSEl92RPtTtU29YJCZXiGpDGLn8ach2pzoSAZ/vf0L++nG4ItdJ2BVdglSV?=
 =?us-ascii?Q?k07e1ACakz+fpo/Q1X/qgoljlgtN/tFfZeuiRZr3jL+K2NuIMBfbLeS1mLPj?=
 =?us-ascii?Q?vvTWd/Va4C7Nm/EV16ZuJ0INvYUqEV9RPvCpXtAgEfQnJ9eywl/y7bZNdPpK?=
 =?us-ascii?Q?HIVb9vTxiyoEkSvyfDl70Szx2IXBh7l8nWpMYKu3xLmb4XE/8qkd07Z26yy2?=
 =?us-ascii?Q?astVHyh6BIfwd1v5Ve3IIqj9jZFHc/AQkOvF1oknGVzRYr2F5J8DMcEQi/xf?=
 =?us-ascii?Q?VXU6ZQEVvnYTzEGGoLQwWvSAOp+fFNh82/VXGFlgw+r345YQsbxuHIsSE4iy?=
 =?us-ascii?Q?0yhVLIccGOvLD2a2Ht74ktN9cihKSDMvgMFv81qvGFh6IkOUqVjmPBNr2DRF?=
 =?us-ascii?Q?wvMvOODBsxZB/eSblSL1TBn+9LjzF5Zi9Pfp38stWJkn3XX5u1zwLNeOgyak?=
 =?us-ascii?Q?4qFHnZsu3QEyVqXF4mWhnGQQdCj8BFXRnoNDpABmE+iDcB2fqQIVqIkaypVO?=
 =?us-ascii?Q?bv4Pp0H3/WfL9nzjiBaY3f/AGaFiCT8YWyEsSUAGItswFfp1ZhTNco9iKHrF?=
 =?us-ascii?Q?Bu1OWmeeuGvrskClxrIqVvwQz246iXrXgdleczBgGaYUA4RDASiBs31gPMvf?=
 =?us-ascii?Q?B8QpHPR1VlEXy/PWV/JapgRB1k2SqMzbAFeh/agVB911Kpp+gPODCvUBb+MT?=
 =?us-ascii?Q?Ee67BCCm/y4Neo/pZzKTtItDftBhL/mzLYIknSNMKZJW4KtCpkbkFQAMxk7C?=
 =?us-ascii?Q?AW6rUaG6perfzHmjb8M/6vPkZEKTT2G7ENjWCFGAt/Ysrp37rz9x1YOySm5D?=
 =?us-ascii?Q?jyz3QwZCNEci6Z13zlYmGERA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3eea6bd-a974-475c-7b8e-08d931225966
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 23:56:25.0333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uiq8Z/LOqc1/8lKSWvBEYRLJhEIwwVuNzc5YD1/kVpWtPMAoV04xn4DC2z38UIjs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 02:51:09AM +0300, Max Gurtovoy wrote:
> 
> On 6/17/2021 2:44 AM, Jason Gunthorpe wrote:
> > On Thu, Jun 17, 2021 at 02:42:46AM +0300, Max Gurtovoy wrote:
> > 
> > > Do you see a reason not adding this alias for stub drivers but
> > > adding it to vfio_pci drivers ?
> > It creates uABI without a userspace user and that is strongly
> > discouraged. The 'stub_pci:' prefix becomes fixed ABI.
> so is it better to have "pci:v*d*sv*sd*bc*sc*i*" for stub drivers ?

No, we don't want to convey any new information about stub drivers to
userspace.

> or not adding alias at all if stub flag is set ?

Yes, just don't change it at all, IMHO.

Jason
