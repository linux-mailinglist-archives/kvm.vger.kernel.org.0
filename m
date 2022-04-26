Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111AA50FC57
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347882AbiDZL6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239509AbiDZL6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:58:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9F21FCDB
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:55:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V45tJjma4k3ULkbKAXT4XxO0EVq6M6Rf6EvZkYfKpcDWleAqbFtX2WfV9OsZ2a8lOISJ+urcTTQkVcaHvt5hY2cf+KprA2OB5cKrnuTMGSEvcjD1tjOyNMgvKjELFFl42iB4c72T26bOxSmTf6xu4s5VJoj897QaxrcaA7W7jXdEomoq8cFaO7RvArGv3piXftSZmHCCeGTTjIhHRLDZYdC1u5U2pFzMrU+Wc3mK/M+ukEKLQ925Ojs6aw6CKX44u43RmARuDEiKnFZL0E/yTHzt4XtdGejmcmjiXtMcSqzjUz4MkToY0GJennlSt+smFf6mTdN97zaydnGbGyK39w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pF7hZstD+o30s4YfZW3HNNwgcmf1VAV+EXwKp+eHlj8=;
 b=Lstlcsbi5gd2vPgxRtCoj0oLRFG7AmLBT2OrAY1VLGfAnqbV+XosfnULnYyVfErpnWr/JK9gpcu8PSTyenawFCiEj5ei+C/eVw5dDh6+i/SLD79ID4hZp0lQtpS5bwJ34IWsDpoYZJUaSEUJS8xQmWyZvFL0YYhMpoHiPhOAPluNPhKeqzyjVusukw8+1zuQkyudJaEYUWhNQNFi0QbIZaxnR7bn5aDZ67ah4Jx1KFPCRjn9UjbHCiulU1mWCIktYkxNSSKvNmEhPShRQh6RUtPjgmdY53OsKylfD6vnqAA77aCqdSnmjlgNh/mKqJQuyjfdkRq3PguqzkiroqTsaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pF7hZstD+o30s4YfZW3HNNwgcmf1VAV+EXwKp+eHlj8=;
 b=U5fa/6b/bNlz+J0GWJyM/aohniv3Do6OdOl+LWGHm//Z/kHviZJAphwd/9UHi5/5lT/R62e3Wt73rUL09QsNyvysz4x6J+bhErpj2TWdPpvZ2mRhVDJzkptrcsOENNfKSTjh5L+TdFLplKwZNjLp12tKKGy1h+Ol9lmyb9ejc8MrbJ1LY5U5jJKMQdBoTh/Z8Mhc9Y/qON+TPmaVlUaKbhWoeN3Eb8dc6PAay1m3qkn8MBUZrQCk//MaSUp7CfN3DuezzNgNW+qoR6FueM7+WArd2He1kV8slGdbYH2cIbDZSpy/YSFDwwRlfhRL1VtN5jtee8QBLuPZJnmE9bXAfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4317.namprd12.prod.outlook.com (2603:10b6:208:1d0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 11:55:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 11:55:37 +0000
Date:   Tue, 26 Apr 2022 08:55:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH] vfio/pci: Remove vfio_device_get_from_dev()
Message-ID: <20220426115535.GK2125828@nvidia.com>
References: <0-v1-7f2292e6b2ba+44839-vfio_get_from_dev_jgg@nvidia.com>
 <BN9PR11MB5276C7829513E8477DE7BBDB8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276C7829513E8477DE7BBDB8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:208:32b::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ec556e4-1f54-4e56-aede-08da277bad6f
X-MS-TrafficTypeDiagnostic: MN2PR12MB4317:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4317C9CE5D3DBDB90B2038DBC2FB9@MN2PR12MB4317.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bb7vnnaDfThWgN3uBSm5pJWHQ3OEHCx5gvdnehnY5gVVVdzJojcSsaDPZ7fDRyAPj8dzJ8bBpLDHBYPDkDnAvcQ7OS+ipXeu/tJEBMPiWZ5xIWPZYGgrVoAf+zf0KhOTzJN6rp33ntoDzEoNOgY/+PGGHtRsPXzIoL20LUUJuK+vzBepmyTQpGVpYpmDkRP+7z6o0j11zoMI1xOz/zmj/f2CVlrwUSQowfKM6MElE317eQAMNZG1tMeZLjEcDtE+P9fqZJ4iDTbCCgbl9E3/skBtYJDigZbjhwjHA36qMGP9ITcL4u+qcHk+Pg/ji4IXipDHIFpGoXYQXP/WcxlEk0JxOUshK4pOtFWSDZmeHErFCv9YGy5DvhMdHrnfaPXHMRYDXQ+ypW58nPyqC9OQ0tCU1kvNE+dG2KFrpW8lspRQt4gXlh4ihmsMPsTU6ywC5cMds7DG68S3UNax+MiW3sNAukXuUcZrDsly/SDg6y0U/RoLtPW+1PobqElNv1WhNA1NjYmqjuVnGeQsBlWiVghU3GEGNUppfh8yuRslNNlBIMqu/9jdFbhEVyPKGA8q4Yb7H6DUdrqsfNM4qWEjfLK/gTn03WXrS7Cj6OFxHg7zpLQj5Uf0iPMfx/RV1wYby/xPWHq2G6PvBYjGkXuIqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(5660300002)(8936002)(83380400001)(36756003)(26005)(4326008)(33656002)(2906002)(66476007)(186003)(1076003)(107886003)(86362001)(508600001)(8676002)(2616005)(316002)(38100700002)(6486002)(66556008)(66946007)(54906003)(6916009)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q/tZV9E7tegANGWCjhTdGkniuMTKAkfB3bz0zj4Kaz7j5auekQArNI7jJ+m2?=
 =?us-ascii?Q?uao7PgFr3oUeXpgfIaRVM9K/ybWNttmp58ukYAS1gUzskmy1lLMf047Qw7+8?=
 =?us-ascii?Q?JN3fIVRuuMH2+JfIb228YsDf62gZhexAm9fBcGS2V9smH5SZXvCbv4ZIxtwu?=
 =?us-ascii?Q?XF36fq+CAeHg6Z19BDjzqqQ2yWTBPisPUKmryDIWjEdwbr88wXrIThwezzNS?=
 =?us-ascii?Q?T17jGRErygSYh5p19bD34V4bmIe4g5nv0fThaR3c6GwNnTmXXCRNNnX5olYo?=
 =?us-ascii?Q?OhqO7nejJGOh/DKOnL1w4Ze7crR+7lSQ3dBWADm3gclv1LrmJR955LncwUEo?=
 =?us-ascii?Q?w3ohGlJT6daUADXGfqFnEhH1eoSTw2uCuHTxhV6AwuGw1kC7zrbBm33YJ2Zo?=
 =?us-ascii?Q?9asbs5RIVagr5/FsybWwn/iT1qcaDZGhHw7Q483Y6cZc+rRidp+vXjdNm3W7?=
 =?us-ascii?Q?9Q8K3aV8iTRbwdebCY3REPLynPTjK1VdRIItF4pKS/uXZDrpcX61HFdwP7E1?=
 =?us-ascii?Q?JUPabWiRi9+vuhjQzXaUac+GkXf8Ej/lYqfv1QLN1z+eZ+UJEZsnqtPKopCb?=
 =?us-ascii?Q?Nt6tMmWUT70K37O+0Lg+X9SDoVPdIyp0Z8O7uEOr4yxoPC7uf+76KUtx1Rjf?=
 =?us-ascii?Q?aqRQhxXdZ3OLSMA2ztXHwOwJhUYY40DvkHlC80QZiZ70lPaYKfRLD/Zh+7Tk?=
 =?us-ascii?Q?dhGkTNWEJtC9onh0D2zyo8EVqNf19/V4Id7vO6Y5h4Hq3l8F3jN5zpzjw6rv?=
 =?us-ascii?Q?Nnb58LYNaOCzV7mdc42j/tZ7mclpxK6ByiXT2nG5pLg5z03OVuWrBz6ba4FV?=
 =?us-ascii?Q?iMXLWfZFEqilsQnEBFiCJt4K91e6ll8cANC33QRNXL0iB3JW1A39u958ZN3u?=
 =?us-ascii?Q?T/umX5QoDbXpRb+ODqOKp82APjyQajOU3HzPwGHgi1Cxv6FF54/SZhvtRsx/?=
 =?us-ascii?Q?c6gdiNgDixtFapqzdEb9cbTSIE85F8dwLS2AmpfvupksQEc3QxAz6Es62X5p?=
 =?us-ascii?Q?s0luiLRMOrmWEdMxRJQOq1gBsSSvdexjv92C4ar4In4a7jNdU+BxivTxL1hN?=
 =?us-ascii?Q?1F19Rnn1Whl0qG2ByV4io15d9nvPHCVwxqdPvH4uWwy6ahuuCC7LZOLgTwP9?=
 =?us-ascii?Q?bL73dSoJ+7tKa2ISGOT/EfydYju+clAYVy7eev9itNxdoQj1GVZGZOBtoVMp?=
 =?us-ascii?Q?Ep5Ybl+zci6vqUft/uZPATG3ndgNQec9q7O6OufZPduZvGVn8h7EWOaJum0e?=
 =?us-ascii?Q?PcYG4solrcjcbTp6qR7TtJNPXS1jvTg/JedvUrNCB6L+thj8Nc6z83dhu3k/?=
 =?us-ascii?Q?+LQxDZFza227WOaJvKxoyP/SKuLfyyEqyYvJAXTQyY1y5aikfYryOrhjomuQ?=
 =?us-ascii?Q?qpUGlVR5C76+hOrXYOpaMLBuLz+zD/xee1KbFCNgVtT6zSkDb02Z28Z64eMc?=
 =?us-ascii?Q?l4D7/7Pi8MWzz5AkDPBV2oS+DwSV0Z+BK5fETT7NPe2Mcs6yx9cVscuTqpjI?=
 =?us-ascii?Q?qlBFZ11cptEbL8BkIm69PXm5Zza/QrelMDGfVNvK39q5H+0G9o/pQThyOBBw?=
 =?us-ascii?Q?k0cM0pa102sbwhTthVOlfRsgvyegBqL4E4V18/0JGiCTwaQJVBCUHFUIoJec?=
 =?us-ascii?Q?ZbS83aQwT8LHwbiSnQUu9FNcf7WyrO8RBxpXWtak0KpASd6A6tum2M3ZsWPG?=
 =?us-ascii?Q?PDdzgNJM3ORW0GZ7yEYpSW+NLBC0hbtRsHZ6NknINwNN8IzTntxism5AozQr?=
 =?us-ascii?Q?yREsUCLpPQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec556e4-1f54-4e56-aede-08da277bad6f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 11:55:37.3865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gi7SecfJvCis8k6xvNa9D5MAENQ3LtS6aO32tE+beTeWUzbgHshuNF00aSixPW2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4317
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 03:51:13AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, April 26, 2022 7:01 AM
> > 
> > The last user of this function is in PCI callbacks that want to convert
> > their struct pci_dev to a vfio_device. Instead of searching use the
> > vfio_device available trivially through the drvdata.
> > 
> > When a callback in the device_driver is called, the caller must hold the
> > device_lock() on dev. The purpose of the device_lock is to prevent
> > remove() from being called (see __device_release_driver), and allow the
> > driver to safely interact with its drvdata without races.
> > 
> > The PCI core correctly follows this and holds the device_lock() when
> > calling error_detected (see report_error_detected) and
> > sriov_configure (see sriov_numvfs_store).
> 
> Above is clear for the change in this patch.
> 
> > 
> > Further, since the drvdata holds a positive refcount on the vfio_device
> > any access of the drvdata, under the driver_lock, from a driver callback
> > needs no further protection or refcounting.
> 
> but I'm confused by driver_lock here and below. Which driver_lock is
> referred to in this context?

That is a typo, it should be device_lock

> > Thus the remark in the vfio_device_get_from_dev() comment does not apply
> > here, VFIO PCI drivers all call vfio_unregister_group_dev() from their
> > remove callbacks under the driver lock and cannot race with the remaining
> > callers.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Nevertheless, this patch sounds the correct thing to do:
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> 
> but with one nit...
> 
> [...]
> > @@ -1960,8 +1942,7 @@ int vfio_pci_core_sriov_configure(struct pci_dev
> > *pdev, int nr_virtfn)
> >  		ret = pci_enable_sriov(pdev, nr_virtfn);
> >  		if (ret)
> >  			goto out_del;
> > -		ret = nr_virtfn;
> > -		goto out_put;
> > +		return ret;
> 
> pci_enable_sriov() returns 0 on success while .sriov_configure()
> is expected to return enabled nr_virtfn on success. Above changes
> the semantics.

Arg, I botched it when rebasing over the final version of the rc
patch.. Thanks!

Jason
