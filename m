Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D078C41C4A6
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 14:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343725AbhI2M05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 08:26:57 -0400
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:30176
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245563AbhI2M0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 08:26:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOwD82EZzrTa8cqCgK/b5n1X/TDx6eW9/PRLPM/VWS0kNPzdn0WrUJ/TMQzE7VmgtCO8XG42YRg47kE9TDZ85Vr67e+p4b46W8Utz76Dj+nuyVcyJIphniu0IKsYSialB94WWUcEL1EiQKwGyN0B/+kuNa5owLSZ+dAdEEjuQLUbCz0ezB/S/R8KO+QEt7BS2LgZcnTFPuFrYflkJIVGl4jxo8GpZzG8FpJZgmmk/8Ml27bLgtaHZ75hEL9AGJBpY/EMj68pC0YtouGy9rnNVR7pq5y2nv4ctKaBkjf6w6t99+LM8D5O/hbp+yWNIe7qowv5GoP0UjvTqIM1m/L4bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nXDfGQqIiEj2qC1+vwZ87u54zSwVmJ7sE6ErZEHzx/k=;
 b=MywE1WhMc4KiI+hpMQ839TpmzRbE69kN8nchTvbL3blKsCn+c+lW1ks1tt9zZtQoymUvmESOA/KEwiUeeXkka2JLJ7X4HMv5orAj2cn5e9mUXY4pJh0dJb6GVFiEoe32NVJqr9XyKNSNpxGQWr823PoFQdLiiqm6poTVZwb89tHPkXjuc7EGp/ibdHcwg9RnRKvi6q3XlAuJOlA7/mUWCMAotEiIfE8J90ksE67DGD2Z1242om1Bx4rkmpiQ0rpXi//FaNJXVtnEQsphrhwuPmfJbtKwvDCKIAC/NO3QC7Tqkm6ys9xYeYeoduAtZajrRktYddtNg3LK7glTdw2qyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXDfGQqIiEj2qC1+vwZ87u54zSwVmJ7sE6ErZEHzx/k=;
 b=WLuy2+QXx1jgjKLVen0P5nlM4BWVHWq2ObvDgH3CIW1fFQCjNtvE+cd8hnBXGl12TpQraJSfoEHlplj4JPepW1uwfD6uZt4w/0lhY3hpmah/EnD5FcwadwXoBqd5SL0vc1MfpOPiNDftj5seSU8ZE0AwthvTBdZJ8xVN82VOURPDKgaxpKwZnPMMjmz+qC6hAqpr0eoCOHAocJFtaEusOUn0+BV7ESXxsJAhMeponxb4e3FERZ6Leb1FpvlK5+jzIojGx/BmtsURgfPVAbqfOWE3Juo6MUj/vrV04ELn058mAKb7G2jUiSrKJu39rvoT9Qcwf4fi0JpR2WKbVweHPA==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5173.namprd12.prod.outlook.com (2603:10b6:208:308::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 12:24:59 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 12:24:59 +0000
Date:   Wed, 29 Sep 2021 09:24:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 07/20] iommu/iommufd: Add iommufd_[un]bind_device()
Message-ID: <20210929122457.GP964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-8-yi.l.liu@intel.com>
 <YVP44v4FVYJBSEEF@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVP44v4FVYJBSEEF@yekko>
X-ClientProxiedBy: BL1PR13CA0298.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0298.namprd13.prod.outlook.com (2603:10b6:208:2bc::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Wed, 29 Sep 2021 12:24:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVYdt-007YeH-R0; Wed, 29 Sep 2021 09:24:57 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2df6b05c-d311-4356-624d-08d983442723
X-MS-TrafficTypeDiagnostic: BL1PR12MB5173:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5173145AD51EFB7B7ECB6D66C2A99@BL1PR12MB5173.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vtWmU6ATRPc60bTSU9qej6ZtzASyQTtW5Gb8CK82Oa1ZZ/yCKQYupgZw/Lv/U6+S9nRUeztnD5aWecIFKBurfhn1Xya+oiflPQCJLn5cYY33VBzOClU/OOP8hW85cMtucHEZuP2Is+fsEMbmxXPDSl/LgddIxWcQCdFcpRJtEMZ1HYg//tYgXdrq676cwR7FVkEhF8W04kO07rGGRWqTD8HloVB3HtDCSoekInHN+XxbqCHgQA5eEpK9O2ZD4MDW4K4ngi/47KbKrdgVQ4AO6JSajfZpSOdp6QcK+fhQawSevBSrC7sbre8nrXMJbj+mxUXnKYcPrDnbIeInb99Jf2zSaabEw8xy/BnU0UPIDOD5wsGE+tSOJreiiljTIMNgmnqDYfjB3OViamysJmPf+MnM0o4hgKYtvCn+UEa3EMMWZmHCr6xSTFILtlhj3A5vx/BQ2rGLD4mUcu9d+wxl0Eiwi6tOZwiirWB46UW0Z9cG2sQoMBnPWFxW5OM/xPTf79Du/sOA/dokSn1rDzCMvgPpbM4fkY6SBiQtNwAThOnqGeBP6Jh8h2OGhji30fyTcKsGqeIS3vZl+1HtI24Jyt25AreNhUHkFJt6xQojWJUiTm7PBMOAG8ERkRcTqNFwo+uQZlc6/Dl4jdXC7zr+3x8NtM6qtsnPkPLiH3N8O2E2rXo2zOZhZUXAYSEbfx9J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(1076003)(4326008)(426003)(2616005)(107886003)(316002)(86362001)(8936002)(8676002)(33656002)(2906002)(5660300002)(9746002)(9786002)(66476007)(66556008)(508600001)(36756003)(38100700002)(26005)(6916009)(4744005)(66946007)(7416002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E99KevviliFa87KkooUT6xWlCuukgD0tc6uNjcCuOkcrDDhE6Sbn47o5KTxw?=
 =?us-ascii?Q?mtWI5ObcNrxaHtVSXwymvYUgkymnjr44BtVQcKukPF7ywbiMbZMYyVokwpOG?=
 =?us-ascii?Q?HshN4j26WudqvuqNWJBQyFJzyPtYW8+blPhoZuRfzhTXTcLJleu9zYdO4jvL?=
 =?us-ascii?Q?BOw8XxFmOseWfXgo7PM2rfFfIbLYyHZ3jO79BGx1vwPNyvyj+oWtRE2JTdZQ?=
 =?us-ascii?Q?y3mScEVitJW3EWctNV99wHJXWyFydh/M0r4vZnd4QyPq7R5vxgPw8+sfKvrQ?=
 =?us-ascii?Q?oQLeXNcEo2uCv3tw5ANqdEh0CyRmHLvp7j0NLt22LHizTb3FHskd9RmsnKYo?=
 =?us-ascii?Q?w+4pPRrd+V3MTDfKw1nA6VxCmjJ2WttDbqezhxtOHUcGiuXc8863BTmpiAtw?=
 =?us-ascii?Q?qwqZ6SqlwKU7a40AgwqjkNvuKdB+GRZ67MfOEpfb2mV1hX+U99DjwXKKbpLq?=
 =?us-ascii?Q?GbkVo6T2CZiTK2Cws8B9UzM8IfeKz28oouNjjhRi1ZE58KUOUnhu5eKSXFgy?=
 =?us-ascii?Q?p6Zg7tqNkDUrKJuDFum3qSiGDMwL1LooGMR1wM++83QejIsrJsMfxp6GUQqv?=
 =?us-ascii?Q?0VKw23/EoesSGD3NubejFFmq3bQ2w6pralzmhFrifYWYwZFjyjgP5COgq78z?=
 =?us-ascii?Q?E6PnCJoXPvypOUyRZvzl+tkPlhFxq71fRujknIxo/xcHakm8nReQJhYZhy+g?=
 =?us-ascii?Q?pVHEpkcT8zwIvhsB6k4ejaUe2k3h1nFKhg86R2JCqhr2I7c3sZH5Z9mRPvu9?=
 =?us-ascii?Q?ddVtftNFx2uF6LmcNQYarcZx6rSgj9nr28xzYZDW+aaZwlVi1taGN4jCsDdq?=
 =?us-ascii?Q?ktj9nvsdcS8tnVt5fK+Ixo1fxBfMKucmcSNbWyW+WRWyaAodFE7zjCgA4HX4?=
 =?us-ascii?Q?Ch0SBtwVt/7F9a6w2qoC/vgRsicZUZY4WQtujaZ5l1RU0DeUe3EyIm8+29rZ?=
 =?us-ascii?Q?D/E88DiUPPERerkBK0SDm06FvNg1YaXrr1i/F2V9w6CS3UbjXBLo67+m7w1I?=
 =?us-ascii?Q?bbhBQb3Ve6V4PepbBP6e6cQgIbHtnpOyNsHlJVELbxmY/ENq7TpdACc8Daob?=
 =?us-ascii?Q?uflFH8ydsmEsIidVTgOlratwwbyAe/SdbPv8kmw5A3xvM3gwfwHJRtHsdO8g?=
 =?us-ascii?Q?1UfIiBeH1UNJ+2ysqp1gd/GbjjMfgt8tF3Z5REpCKUbsGgQfY9rOUYWkMVcZ?=
 =?us-ascii?Q?HWBppcvdrfQWwi/1LVjbTMjXZIc8ObJ7Zn7ecqaawzbaVSCZ6g3oTzz6LrB4?=
 =?us-ascii?Q?aEPEXkkk1+l1pbcnrgGhsMcHjACA9T/+fEG4JsoAQ/4UYKp2fZmManGwiCSY?=
 =?us-ascii?Q?hLxBNJY19IXVJEQbT8hTifoc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df6b05c-d311-4356-624d-08d983442723
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 12:24:58.9361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /n4uLlGVMQp5IYCqPOLQvTgOJzgktscN2S9xdWmBzV3djxge1cvRcIcH63CjhXSC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5173
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 03:25:54PM +1000, David Gibson wrote:

> > +struct iommufd_device {
> > +	unsigned int id;
> > +	struct iommufd_ctx *ictx;
> > +	struct device *dev; /* always be the physical device */
> > +	u64 dev_cookie;
> 
> Why do you need both an 'id' and a 'dev_cookie'?  Since they're both
> unique, couldn't you just use the cookie directly as the index into
> the xarray?

ID is the kernel value in the xarray - xarray is much more efficient &
safe with small kernel controlled values.

dev_cookie is a user assigned value that may not be unique. It's
purpose is to allow userspace to receive and event and go back to its
structure. Most likely userspace will store a pointer here, but it is
also possible userspace could not use it.

It is a pretty normal pattern

Jason
