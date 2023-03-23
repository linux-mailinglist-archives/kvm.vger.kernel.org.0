Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86D06C6B50
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjCWOnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjCWOnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:43:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6A723A65;
        Thu, 23 Mar 2023 07:43:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T052fmcvVNLE3twz4KKsLSNMqh+WKbZLg2sFN78rWWGGKHMz8S/TuEZoPO0S0Rzo7PUtbSa/J6Ioc3fYnQT98TDY0CNuo+fRRNuTWSzINIsRALr04gM6U0OK+sqGkmAyfRiueK82sn0MBlOMR6uOqscY/N0d/YFfPKM5P0BJBvU17YoWFTJYRudjy266zqhRqfmKSqZ+CdgakaXr/xhuMO2CJTKdG72GGqHnNeBRaADHp3qznogJ+pF2PBkLSBaXr9aw7BwkkI+qXCj38IeLkRIE8LrunYRrbsydM9IwSjfcdJuKl3wN00pfFJi8tHLRFph8sy+wfVzugYHEVIQN2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZQyarvGvVT+NVLhw504PPrq7LhzidR+gYwnKWibsUs=;
 b=Eu697J0G+p2Nq6j11OsaKWC3xhWp9JJnI564Was3gA/IM6ngTF+foTl4ehQfNEeJltWNogSeeyxlbTrIAz6tuEgIUUo/z6nM9AnAuIZoskjNVz2SS8z9Y1Re8lP0oMSpBmGcYgX/uaGtahO4tqb6w7VU4HXe0qYcZPzrNk3n+z7Mb3bwNg/IouESl9LrVnQA1b4Pq1R2Vc4/HbJKMVzZW1qWGAdZuCWNp5WI1rM6gacUEBl/Cx/lXsqOXnFw0K9CuzfjxKjLt2Vf1xjOs6MzI+ed1RFi7UsN0rkBWavp6/RiCcECEbG3PBM+QuJQKPJb3lQ8/H+FRK1teEzqtRjMxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZQyarvGvVT+NVLhw504PPrq7LhzidR+gYwnKWibsUs=;
 b=Zfl2y9ylsJsykVNBteIVkvdHaxDXtFbtauuPwQLldBT/7PS6lGG5GHBfh4zWJTBbgho9DHDdYuQQPso/YlzIzSDGCzmXEGhMHNGHrYYEDXckeXFDAxBTtIAVAEPKXeoPBHGK/AbcqfdkvfAzlW7bg1kTFGTzch3DTliYXqrc9+ySNYpzP6KYaGz4poVj510iN+mU5wi+SjGNc5TweQTmZ6KA2sNcQhzHzHw34dk1NNcYsn+r7meBYOm0pvKnxHpxXZP/oktcJeXkfs9gkdC9Ui+2ENLNwAPJCOa156ML5za88t/slGYCa20VgAXfD+HPBZj6u4Ivb+5NZc0gNNXiqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5218.namprd12.prod.outlook.com (2603:10b6:610:d1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 14:43:16 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 14:43:16 +0000
Date:   Thu, 23 Mar 2023 11:43:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH 6/7] vfio: Accpet device file from vfio PCI hot reset path
Message-ID: <ZBxlgnpg9QzuoO56@nvidia.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-7-yi.l.liu@intel.com>
 <ZBiu9+mVurbW0x5k@nvidia.com>
 <DS0PR11MB7529BEB87EC6941C19D56660C3879@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529BEB87EC6941C19D56660C3879@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH0PR03CA0415.namprd03.prod.outlook.com
 (2603:10b6:610:11b::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5218:EE_
X-MS-Office365-Filtering-Correlation-Id: bdef4f76-69bf-4876-a1cb-08db2bacefbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cvBc8vkb9YEE3Vf0/XGtca5duCsrdPCr4RcoLxVVFTt7s5aSGMdzLU43YT06daVl6gIojJv/g8wF1hFeSQDusEMZ0YiOHehNrcrbit6mH0a1IPF3LxBPFvHEUxef98fVi88eAD/31dHiHl9h/ez58kwvgKx50ruV0650ZY5vnirCeO6rEqUGDo3qs5qyz6MM/w5IeXyaXMfOSmm+K53nZYTUidZMHiADGYcQhRF0pijHQknWRhB+LnHqla1LgF1dHY5XwVzz2SF8bYvlDRR9DaQ0yJNg1wvHb2+nlmDc1VNrTp1ZhCbva2QG8fLsuEeRwAH12/In2Hfmjjfc6YYUmifljguu51BCobsm01q/8TjLINfTMrYWfxIXe8OrNhNCcf5fbLDkFMatSUUsN9yx8OvDhyCM29SelhVNapa5UVvvOtp1/3bkTta7mH/Ojtpy3+gEw4NB36P1YQF9xFl+yJCR3DywhUhrk8zurpzBQN9G1+YvqDcKdZvO+DZxid+gW4mVXN4I2bkYqVfAknWy3SONXaj4y2qMVdnqtVlN+xJWhAsaf5PBXbZtUFtikGFEblcdVGWnzQADe7mUQfmjvjF0HCE8YDSbrComyk4JMiPmt805dlf5w89OaW0RbrZ+4NXbfY5SxVCaCGZTQWcKtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199018)(8936002)(66946007)(66556008)(66476007)(41300700001)(6916009)(4326008)(8676002)(86362001)(36756003)(38100700002)(26005)(6512007)(6506007)(2616005)(83380400001)(186003)(316002)(478600001)(6486002)(54906003)(7416002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0ujSqp4DQ8Xjnt8sTTN0JTmt+iQA71M6Mgj5DbJ2AcNFc8jQqjOhOxLhCwf7?=
 =?us-ascii?Q?sDDh14r9USOKa3rGXi93V9qDMRFmB1/WS2yYlPS0hPQDbktzjWbnSb6QCPXq?=
 =?us-ascii?Q?9oFwWk3ORmeDUgEcWmlCQAtSAVTNWtPqjTyg38FNQDFmwX/uQdI1MOyjEenW?=
 =?us-ascii?Q?qjqRlbLxADy1GP2ewvDLdJ9UYB3iELXZR3RstwDmrF5bXmNKCulfyvJLbPfM?=
 =?us-ascii?Q?+58W342qcoiqEtT+Xd5xrgtfcQEvqcuvrnG/yUcyFSiDoR7GKAYBbJBdebMC?=
 =?us-ascii?Q?/w5m9C8iW2S6UTt2UyFvmsq3Y17NtbUlGPBYzgfj6JqaRUxzcGrxRV8ttCF1?=
 =?us-ascii?Q?ZEGN12GfkkgmMLfwgM4ickVaBZxMbHH+8oICL4LP50oS6+4lrdi35otrvnes?=
 =?us-ascii?Q?JQx1qVdhzpf+gw4ogWOCJbaLyFZC4eszF3iOu2B7QtLS89pi1m7gL3RyJv+l?=
 =?us-ascii?Q?3sLNTHxvqWeL9/qsO7qo4EpjzWMjTKSVOCDUHRhyaqd0pZLsRa+EyIONCsl8?=
 =?us-ascii?Q?xJgGHdldQrIaacNiSzHywHTlCe27sUAhmqhRo4qBRYGg7JRx0xCxzps8dXl3?=
 =?us-ascii?Q?MMAZ8vduGeuqQhK0uSlqQbUGKSxp0evCWN/Ubx6TS1inXAup1NqKX2Nnud0u?=
 =?us-ascii?Q?ZNDhpInjSZJkTsx9DX0ySwMS5Rtm55+AoVjQVGflRCPZTIG9w8I78QwSZcsw?=
 =?us-ascii?Q?KV4pO4UFUjBm3AxI0mLTD+uM7EzXYkSZ2FT4pBfbEb7Xbh8sQxXkirR4TBIL?=
 =?us-ascii?Q?ZYLX2ZVqsUQn3ZYvvWhwobtGJnICJBctqQP2YBgdvyvx7elNa6BWy8j2j67j?=
 =?us-ascii?Q?oDP950jr/Fcs3BFiCP2zm88SSjWpHC+hOEb1HeNnCnt9t5wApAfvPwsoEJLs?=
 =?us-ascii?Q?jaPStnxDyI27ZAiqjMeRqpOpmJadcesEx4FGp2x6MSK22t4RFBRSzqeb1tNc?=
 =?us-ascii?Q?W1r+nA3AG7PlJ/ligB+Z+QLwOrRfwwMc7PECmWqgR+RzHXf0IpFH9pfP5luG?=
 =?us-ascii?Q?1KCjDGZs6M7rCcfn7ERe5sW0C1aNotdgrBzw3qgwlDfrkuH73D0RnFquFNmZ?=
 =?us-ascii?Q?VWlxOb3as7JUfE8fFSqTh2Z59bLkappuCAfbdO/n3urRGFlmN3ttYxBr4zu+?=
 =?us-ascii?Q?zeulhGVapRdjm+fjGLhQHAPodQbKJpoXT0hmVtfX7FrjqWcVMzWGA02AvWJX?=
 =?us-ascii?Q?BmN0VspHUMp1HyKpYPV1HGbRKaFEgNAUCpa9P7F9M2PPENXXvjh+UADgMUhK?=
 =?us-ascii?Q?NI9MW5eK5PVwb7elvns0X4CsKhDoVeaA9qeMn1QE8DNrC76qAgr97H0kesCS?=
 =?us-ascii?Q?RuFJgVCqR/LppmmNevMJgJ1xxGT+I9F3AWFKodOJd/QZ+m/PoSfvVsjeIIMk?=
 =?us-ascii?Q?CdcdowINZtVSWixNvk2kBtITRtNL0oXyY3ptR6X+Nf5TN9zJdOjb/Tux99rZ?=
 =?us-ascii?Q?d4DqESG5gr4mOzVKMx4StdhrEArrI/1ba9t2cRyspUPmGQ8Y46NB4ePImR7W?=
 =?us-ascii?Q?4HwKbOYdMcxoj4cXTOsLOkvfaNcigsDypK85IKdy9b1G6SEGkEM8fp4VBUF8?=
 =?us-ascii?Q?8RBKhzYlU9xysZCBIIY2puuHh6IIQ8HuS6HD3t/l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdef4f76-69bf-4876-a1cb-08db2bacefbb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 14:43:16.2758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQYigiGwzg57yrGHPG/8ymIAB6CtdfFIaIfZBAmRxKZO3ax4ykm2NLdmdS497O+b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5218
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 10:14:31AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, March 21, 2023 3:08 AM
> > 
> > On Thu, Mar 16, 2023 at 05:41:55AM -0700, Yi Liu wrote:
> > > This extends both vfio_file_is_valid() and vfio_file_has_dev() to accept
> > > device file from the vfio PCI hot reset.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/vfio_main.c | 23 +++++++++++++++++++----
> > >  1 file changed, 19 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > index fe7446805afd..ebbb6b91a498 100644
> > > --- a/drivers/vfio/vfio_main.c
> > > +++ b/drivers/vfio/vfio_main.c
> > > @@ -1154,13 +1154,23 @@ const struct file_operations vfio_device_fops
> > = {
> > >  	.mmap		= vfio_device_fops_mmap,
> > >  };
> > >
> > > +static struct vfio_device *vfio_device_from_file(struct file *file)
> > > +{
> > > +	struct vfio_device *device = file->private_data;
> > 
> > Isn't this a df now?
> 
> Not yet. It is placed before the cdev series. So it is vfio_device here.
> 
> > > +	if (file->f_op != &vfio_device_fops)
> > > +		return NULL;
> > > +	return device;
> > > +}
> > 
> > The device has to be bound to be a security proof.
> 
> I think it is because this helper is used by vfio_file_has_dev(). This
> requires to be bound to security proof. For now, the device fd is
> got via group. So as long s user can get it, it should have been bound.
> 
> In the later cdev series, the below helper is added to ensure
> given device file has bound to security proof (a.k.a access_granted).

Yes OK that makes senese

Jason
