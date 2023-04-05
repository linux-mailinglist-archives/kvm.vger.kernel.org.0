Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81616D7C0B
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 13:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbjDEL4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 07:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237630AbjDEL4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 07:56:34 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7861E3C0E;
        Wed,  5 Apr 2023 04:56:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNCHhax4jjJa5iU+9jixF+ULHLR3yP27YtvAf9hAVaSzt73IZTa/MEmWsGf1ZajXHp6bT9smjuAs+spbaSiZUNm9VISdmX3RlkfbsB6xP3xLkEiB79KyqD8mB3m5Pm//BW3gLWt9MynvXFf/I7ojfaEN+WrXjyVwEXqbC9Pn16XUECQ2oDSeVXm3cqiFrlz07ECxkeq7B7/iSDliIJrFEPe6ASd855fhsclhSB6slxo4eQEYLwuDhRwiuo4KALucw4P4zTpjt5o6nsKtQnPYbBAJs/B5iIl3chi1rRbk/+Ryu8FtzyKtqyX74p15C+yXEG6LBwAnxIst6ACYG1uxlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+rJEMDHra+1+BQMxK42FJzeK0s7pnL9mKkFBo/ih6/Y=;
 b=d+GHRL2rg/Zt8qT//RDEbMqs1r1AhjjJtZZIb26IxZVv0fHlybq0XdIEqKlwdsqdECKfdeo2zcbZRYNF0ul9idu1fILR/AbsF29B8I7ZSexhHBFgbkxYflBk2h9QHUNbdxjexdxxlWPiUEi67FDCOI3kPZ/G84XitskQr1mBlwDmj386b2V/mcCN2UDPDvT8797NlKDNJgi02riHxWZ0dQ3Ve4pBE7wGMDzLVyRst1l2mhe0vmuSJZ8dABTcCXSteqMmW9k8t7RhV+sfDlWSzY3ePUs8blSmviKH/gd67Xqv5+lRo01GkJeJx2iqST3ZYASkFHjui6sR19q7xmQxJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rJEMDHra+1+BQMxK42FJzeK0s7pnL9mKkFBo/ih6/Y=;
 b=TAQyvG3eDRSA/kiiHzartXzfe3c6vrptpWbdI9+w0WmqdpbsNaXMcmScv1390c/s1wwbBz6DTemEC2DomkOeRj7L1XjhP9vJhjO4NF9EqLJ0emGWGjkPKGwSoBoWG2FqBerbQAvD3cNOKj/qzuT7zZ3d7i4VCh620t9XpKi70tu40A/2H9NbdVUxo1zhYYyWbKyocTGcVcyTIK4UOsmvvVYkCYuoodqOGXyway8eXa5cJZSTNcbkVlu4CQpU/lhibhWRsc19iIEzr/3/C1z8ZTKK8fyNIUw6ceNZQlSU4Xy58bONVPeDmT4fgv8xGJTGEz4giYJD1haIceWizafLBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 11:56:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 11:56:29 +0000
Date:   Wed, 5 Apr 2023 08:56:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v9 16/25] iommufd/device: Add iommufd_access_detach() API
Message-ID: <ZC1h7PyuhEg3ZMcj@nvidia.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
 <20230401151833.124749-17-yi.l.liu@intel.com>
 <20230404164512.37bca62e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404164512.37bca62e.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR22CA0024.namprd22.prod.outlook.com
 (2603:10b6:208:238::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: f269dcbc-f1d6-426a-bbf1-08db35cccad6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L1ceSZz5amkOYLFRmAQarOBhDuH8hvahZLa+WCrmYssOnGgJ63Wf/05q+JdoXVFxhqIEvuhJPhamuQM0WEGaK2NUwjWUr7JgBUizvcMDp/JIEUb/ZioTK9WqO+vHfmG01fWEmoNAHWmYN3CxjXH47Fc6BXS5+Auk3sBtMUFhNqZMTj6wmQ7Y+0jIu6VyeuJWr4z6BV2+uUmYF80UMVCBuZc/QKd1G2gXhmlXjTMtyQUeSi+0S0keqc1fjCC7KKdo6rw5YBW8zFU4t8BQ/FZNiN04kJhbbOfRVGHLAeTT20/a5FC4gRHd3aj3NFgf9r0oDl0diBUygsiaKwQCag4OfyfK9tGDt3fXjhQaNT/FQFAuOus5u/+VSd2s+XfAZqxrlxPGztqiDhfNQN5FHW9GoQajkSIYe1XisRroec02H2FUE8oGbU3uORfAFNwTXBJAACMmKFoOJ1CjpyJQp8vaXT0ZkRjqtaFJtkgSfFLdwPWPpzth6rIL9iqRXfcJK34nKuZ7dUmyskyxWRuFVcx+KWl3BU8LYZMyF1VJUnNBLX6IRm5yy2G953OLou98XIs3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(6486002)(2616005)(6512007)(6506007)(38100700002)(186003)(8936002)(26005)(2906002)(7416002)(5660300002)(83380400001)(478600001)(36756003)(66476007)(66946007)(66556008)(41300700001)(6916009)(8676002)(86362001)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?smaD7vZFBr5KPlxQ9707RRoBUfY+MjLxoLcW+04MJ2+0vHaBmzwAaFaE+AT1?=
 =?us-ascii?Q?vLfJ0YSat12yt2P4qqEP83IaOd9Iw+5TTaNd3tzkfClMoS5Bns9MxO1l4ZZT?=
 =?us-ascii?Q?kjhtIL/uZS8y79TSB+3yYbRmhK80WjH2Fnnc7FQ0R7S+cE3EKh81zGvk53KL?=
 =?us-ascii?Q?KbRVZ4iNCcgVk657x9FSznVwdnBp/NT8sHTsa7DkKa9nMu1O4YPMPLiau+WO?=
 =?us-ascii?Q?eCBDMXG8z2PaAVPEqEh49H8/LgXFMLUmsMzWWECD2jAck7ZZpLpbITW3c4A0?=
 =?us-ascii?Q?6WzsDc3pU8/Tq/aH2A+a5T6il3jnlJ9hRrpcP+IPJ5ATKaKe2fX9Lqm8bR4q?=
 =?us-ascii?Q?XD2XONXmZ70C78Q9UxSp1gJyY2qU0lUh1QKCeZ4itcmE6zznVb7wILtE09Re?=
 =?us-ascii?Q?uQzjkSJlpgZWbzC2gqv6Wy+OWZtTVhZExt425fgqkNsgDaf2WyrMelV5h3uD?=
 =?us-ascii?Q?0FrbTUo+ZGMLI/GwHTBJvsuuJokolJosoj/f5S6lCL3qQFmd+ap1Sj/E7DUL?=
 =?us-ascii?Q?qiktL29g/wyGwMTr03o3pUwnzugIUaCBjlOtRbdrGfY5J0Zyp3wAQlhk3pio?=
 =?us-ascii?Q?olUoQfYGpc/QtXxUz1ngQaEb63nf3TheLu1VwkZZjC7KSkG7hd7NQ8ysd32F?=
 =?us-ascii?Q?o0+yv7OhRRLMQZdOQ2yvnDBnNbQG3GD7H+4yKHT4laivWvDuqVDWbW6Kb6hG?=
 =?us-ascii?Q?fft+FiOAAn2p5ujRhkMDDIRmwXbKI64Ph4ZG4Oy+I+vhir8sxEr1YbRb7/a9?=
 =?us-ascii?Q?AMDF8x4vijKyKu0NrjalRmnWfHfNkIkheLPbQ9gibAgOWbEub8rc2G3uJkEQ?=
 =?us-ascii?Q?bo05wb+EyAwqgxQevgXGy+6RA1AkFtlY5C4kn/G2Y9C6/LvrZVfNRptva10j?=
 =?us-ascii?Q?c2Jothq8C7qxKUyZEQNOe7T4dyUuSrB7QX6Z4/bLUohRC3ve27I/iaL+9Ffi?=
 =?us-ascii?Q?Y4+gIuN19dDbQQfupND5T9QR3RQ1X90LJhVq0IUcVn8CLMSKJFubVWl+P7zu?=
 =?us-ascii?Q?L/sw+yH6zFGF+8iNZ0AxwQdPLMmcaWsX+I0KFn7/Vc5YotqmWcxOMfGxHjYe?=
 =?us-ascii?Q?kZ/eO8t5rFjUr2Mth+1YDmnh0k+9d8OOreztlP6BwYJZEsmdY+YcbyefEWZT?=
 =?us-ascii?Q?IgENVWGIX45uM/KM7JWH4sIkEJD5CwTcJgdUftKUq8h5AicrCOsF7HVCDDJ3?=
 =?us-ascii?Q?NBKHv+fL3tJqMiBDq6aa8slhhC44sCw3Zhbh4PqjNBmtYbAhbsSkGoKzrwML?=
 =?us-ascii?Q?5zY9g6OQmBah/EBE6HZFf8ug+h8PW7p6F/o3GLKYETiIObcg7Sp4HM3lBnwb?=
 =?us-ascii?Q?b2U3IeXorZU571rgyPfqBxxkse+OF2QZo5cqrYxxJdYCtiQjJx0r9ysXaT/L?=
 =?us-ascii?Q?0B0WjwF335hewt1baA0T4qRlv+ilJRfbpUNKkSVw4dlERJb+jfDPnWUYLkTx?=
 =?us-ascii?Q?gMcamxC1GWAihrs8o0Ts8Zy/w35LhMYHuiQP7hTj1adalyxY+vxlFW6wRA1o?=
 =?us-ascii?Q?WMZyWPSv0PAcYj45jewYgFqr0F2KM231Ie1AXE+gwG0XtDri6J17Slkp2zhg?=
 =?us-ascii?Q?483A9LURpMyGFHhMUWITHr+thuMFDXffBm2kWdkl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f269dcbc-f1d6-426a-bbf1-08db35cccad6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 11:56:29.8282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AW5h1NZCpnJUlVC3Ok6dGJ3YnFOYDd1zjFVr7ybTuyUPvk50szn8tZrkMXyIMPpd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6966
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 04:45:12PM -0600, Alex Williamson wrote:
> On Sat,  1 Apr 2023 08:18:24 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > 
> > Previously, the detach routine is only done by the destroy(). And it was
> > called by vfio_iommufd_emulated_unbind() when the device runs close(), so
> > all the mappings in iopt were cleaned in that setup, when the call trace
> > reaches this detach() routine.
> > 
> > Now, there's a need of a detach uAPI, meaning that it does not only need
> > a new iommufd_access_detach() API, but also requires access->ops->unmap()
> > call as a cleanup. So add one.
> > 
> > However, leaving that unprotected can introduce some potential of a race
> > condition during the pin_/unpin_pages() call, where access->ioas->iopt is
> > getting referenced. So, add an ioas_lock to protect the context of iopt
> > referencings.
> > 
> > Also, to allow the iommufd_access_unpin_pages() callback to happen via
> > this unmap() call, add an ioas_unpin pointer, so the unpin routine won't
> > be affected by the "access->ioas = NULL" trick.
> > 
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/iommu/iommufd/device.c          | 76 +++++++++++++++++++++++--
> >  drivers/iommu/iommufd/iommufd_private.h |  2 +
> >  include/linux/iommufd.h                 |  1 +
> >  3 files changed, 74 insertions(+), 5 deletions(-)
> 
> Does this need to go in via iommufd first?  There seems to be quite a
> bit of churn in iommufd/device.c vs the vfio_mdev_ops branch (ie. it
> doesn't apply). Thanks,

I think it is best to stay with this series, Yi has to rebase it

Jason
