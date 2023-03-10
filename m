Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553846B4290
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 15:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbjCJOEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 09:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbjCJOEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 09:04:22 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAB910BA5E;
        Fri, 10 Mar 2023 06:04:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVuiEyfCiWAhgGRgUhBa9T677BWLJR1Gkes2TXAKIzlMS1xGFqTxw8FlKb9tnyUYEwMGtDDW5wutbUSvwP8ON/lhFcZW6toFW20vMQp8JYJZPaiveNiLkb1DDL0zMg+qayXl/gqHV/TQkLtDuHrMLk7xQeqt0IzYLRNpQCyl2tsqtJ4uHHIWWUJx50349FJ+cekuHLhzygN454c6r4C0iuSUPbgt9MdH+NZhpOBZz/oYbacObBUvhA00eQWVtryF7Na+4yfoEatMHGRWHrS63T+6gcjgkO9YIysBLs5dC5PYAtAxcEk+y43zIzmP3yUQ1acr73dHQ357XLbsykXiTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XY1Esr2GyTssuQkHEoUPQP7tesiDbHhh5Z+MX9sT0A4=;
 b=fUqpxYsneoz+snCBvquURYjHZo4RP1SYld4B/1ZVqS+kv5bJKzd7g6PJNr1280Gyfr6R221dWG7ai6zPTvIF3NT0pBXh/wnZ50gOVKjdQ2x1mhKFuUEeo2ir0DeAF2C+YJOO91dlBG4JDv8HR7AYlH3K2S6f7ABlsiH0xmS19m3su6uGY27AStVi4DCkRyI+wIn9vmvNTlnmDmU8W+FLh+2GRUsc3Q4j8UABG13bDtawD3VdPafYVCESg+tIyvb9faZuHOLaoC9x7b97jNALgbwO05HYEYvIg8ZOQnjQIyMVc4ju8vtGgKecOAK/gOoi5OjjBAcwJIiwz/d/wvRh+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XY1Esr2GyTssuQkHEoUPQP7tesiDbHhh5Z+MX9sT0A4=;
 b=pQwx8GaZN/5yu/BI8n9AIRrE9Xg4xzcooYS4LF4IlCTeHW8ZlC78WmVwRW57QCqinsghy1Jjgv3x1EsrfHTh6g3xId+tX0LQVUS/fyll24iY5LyQtRFgdVh521Pg6ShG8eRBgy3rFgn/kvjNWVMNOiRNWTacgANwaKRqGL8ebOfxIcWEY0XEQ87pYTffFmlbY0H80nrcoumJnbzQba0prCLUG88gibsS8ngTdJjTWgqGSo/Qe9kZs7rtyLwgXllq5eLn9/MduCFUUjJLk0pRAw9W4tGsqKTVGJmQ+pYrM9XFde/JKFFMjhHlnPHwPcs3OyqYvxFsq3BK3NctZWxMSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4863.namprd12.prod.outlook.com (2603:10b6:5:1b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 14:04:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.017; Fri, 10 Mar 2023
 14:04:10 +0000
Date:   Fri, 10 Mar 2023 10:04:07 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v1 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Message-ID: <ZAs419G/RNoEgPxq@nvidia.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-6-yi.l.liu@intel.com>
 <BN9PR11MB5276BA4E1FF1345433FB8D338CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276BA4E1FF1345433FB8D338CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::48) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: f278200b-159f-4c83-a8aa-08db21705229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dv4MG95q9ie0HWYEYOaY3/5CpcSXAtiVHnMlliMfToRWZ+wrL+7TMBe22e0D9czLFg3uTuMvBPWNeysQ5YSgHqgBVFz6u5SjI+EALjC5oylHA9TN8qpHYJRlpOSi6PrLGldNuKE6LO5yPe9tj9X92MEuuV3sDqzBT6xfGppaauzB34t9UUnCOBY/9sztn5LLpOhN2kzDBqr7u9r+oHLvfYUoqBc7blP7gB7JEoYzvdw4zWJJqiM8DqJo8le+eeTwbrTYEuBDKEAjAC4vM8PqLzKyKprY7az4oZ3XY+QxIBPqm8ld4EeHjixOEq8KTgLGGMeqyzETDHA4hb8dKX25iPADk/stzNA5nldGyh+2rqPINOAyIKlRhrRXdI2o9kB4VXMpayLBcCb+Nmii/0KPbc4DC/l8hssWWOPsnFmlhGTB46apUm526UMW7kjHo8L57G9gOTKH9Kqcr/Az4VgTjDKJ+9d5K8sOAK1oCVetDMOc4WgS6NOfdjFEYbUU7Ez68lyke7h6M25esGoHH9fxPp2EgN+H+ra7EaWJ3QaDSrOkKjkx8jbANKoGJTirhjKYG/GMRO97p1KHhLBq98Eanr9WpzphWMGFOBTc9yLhZAcrHm3wbdV1C7q8Smnae/Npxd/BanevuzzAvPwA65rKhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199018)(316002)(54906003)(36756003)(38100700002)(86362001)(26005)(6506007)(6512007)(6666004)(83380400001)(186003)(2616005)(7416002)(2906002)(5660300002)(8936002)(6486002)(478600001)(41300700001)(4326008)(8676002)(6916009)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gaaG9ctM0ghDlLfzCJ7Aj9GH98O5uUovFIXyiE7nQ5RI9GW+0Tu9wqPx0qGe?=
 =?us-ascii?Q?/1U6doBrIUNTlpr7M4RoxXpy1O22JYfmPG3FJzNStoh2za1EijUYthCxEBLa?=
 =?us-ascii?Q?wT+y0nOS8S0JjJhNZHFKeq8dQBT0fw7ST9I1OrTVpQYu3VNEyVwkIJ5znOf1?=
 =?us-ascii?Q?MyrBwUGY7xIHrogY12eSHJ2UWsdArwj4YU5WUc9YLBguNsVLfbXlXVivf7Ub?=
 =?us-ascii?Q?tD45ctQ3a+FcBoh4JiA3Ku+h92VeeUOKC/HDW4xpLUoKhJbzmIMdUsahr9Hx?=
 =?us-ascii?Q?R+7W4tpzOKVCYfLURJ31ZXLFNEBknDrUnyLIU5ZeVtqd5fkjQLJFmc8xHEPo?=
 =?us-ascii?Q?83xLtYEOpFx46Wk+wzQfPF4+zfKALLpl1gIGeCuQWWrhmH2vHjVQVnNDvifF?=
 =?us-ascii?Q?vOa5WgVDwBbkznDlWPmHrT+gf6dGJsYw9KQthebIN7OX1KOj6mgk3QrfrhVM?=
 =?us-ascii?Q?VPwcgEgRaRcoV1eUxZa/sEPD9YbvBJw43J1Rw8ON95qixlChcJ8XAE14kvqC?=
 =?us-ascii?Q?iwBF90MpSlWGdsCtccr/AMNXYY6l5dU1id5Z5t4683JNUXq2bAeu2dZjL98Y?=
 =?us-ascii?Q?nMHn45tXi7UDJBItYm74kC/NFF18YR2Ft8SnY/9wSYCuOOd1PAETAFcvODxv?=
 =?us-ascii?Q?vN4A3WP+G5TNlfRdny+pyG52drMfK6rexveJ7j8ZOjyHc0wU9X+eEc1FSeco?=
 =?us-ascii?Q?j2My2rDqDbRq5kouNmIbMgzg6uy3bfTgDuJMQwOqbsdpF5/1yZ/NDcOmeiod?=
 =?us-ascii?Q?yeaMv1Eq+nMykOlyJ5abdrL7Km+rG2lEVz30CJ8kPY7LWdP6B5F9B+jyJ4/D?=
 =?us-ascii?Q?bsnJKoF04xnXPd8h75QnCvWGkBjP0a3N23kH3qV4e4pqRb8p94v8YFuNvVRY?=
 =?us-ascii?Q?1GbcQlW2hDsFqoI7e1NOXF/rWaj5uGZR3kV4IXbZrsYbP5ag34H4XxCn3XOi?=
 =?us-ascii?Q?NACiU7Cz3llL0sODAnDDKMyzEO1RGkG+5G4Ffq11XlIAS9/t0TLGZdRoQNB3?=
 =?us-ascii?Q?G9HEyN7flx2QOgAx2KdaFsfsfkJoF5NVOXeZ3QpAo0GqWoSbbufWKlqwJPBv?=
 =?us-ascii?Q?jQoWMOBrSZmd5weHdWJls0h6BQpCbmz6NisqTgs5LgRAbW1RMrC4OCuAjIm2?=
 =?us-ascii?Q?krI1OJBCy2UShnkgYQOAscLPXIEi49GoZ0y9UtFNCbVu7Bk25slyYT9Mg07R?=
 =?us-ascii?Q?s1gDXHmsZMgLlCjyESBQENZj941iCQ5ynpP9soJNsLLdWAymqO5hcoEFErpU?=
 =?us-ascii?Q?onRlciIsMirjxZYDFYH+0rYoMeQ68TjuVLWzIDeGUVyCfVHJ0UMcp6n5f4n5?=
 =?us-ascii?Q?k31TSYUaUZjPDq/rMatGJ9CosiypMLMnUX1Tb802400UZ+wBYf5/ipf9OJ9k?=
 =?us-ascii?Q?9NQ5MDw9AcWU6iTM88507bzdHlWr3gS5U2oa4eOkLuATv0o0yV91WO1Mr/xC?=
 =?us-ascii?Q?b2rTPCNRE8SgAkXvU04nK0waMlIyYl7mSrHGu5nR1zlSs1Kok32v58Z/2o2X?=
 =?us-ascii?Q?glTsCL6sDHrOHUgen2jxdKr7xzPL6wWQtkg/eMtLrjvp5pevG81n3+cKYHeb?=
 =?us-ascii?Q?sg1L5xq+To+CVB9/HhC6jHgf06IPc97OYLWPR0sL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f278200b-159f-4c83-a8aa-08db21705229
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 14:04:10.3134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G0J1KJFPtXP16QP8/jAB2m54/fNntklznOABrh7PiLLPpBfTifWeJ1giK15H13fi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4863
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 02:15:32AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, March 8, 2023 9:14 PM
> > 
> > After making the no-DMA drivers (samples/vfio-mdev) providing iommufd
> > callbacks, __vfio_register_dev() should check the presence of the iommufd
> > callbacks if CONFIG_IOMMUFD is enabled.
> > 
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio_main.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 43bd6b76e2b6..89497c933490 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -255,8 +255,9 @@ static int __vfio_register_dev(struct vfio_device
> > *device,
> >  {
> >  	int ret;
> > 
> > -	if (WARN_ON(device->ops->bind_iommufd &&
> > -		    (!device->ops->unbind_iommufd ||
> > +	if (WARN_ON(IS_ENABLED(CONFIG_IOMMUFD) &&
> > +		    (!device->ops->bind_iommufd ||
> > +		     !device->ops->unbind_iommufd ||
> >  		     !device->ops->attach_ioas)))
> >  		return -EINVAL;
> > 
> 
> I don't think IS_ENABLED() check is necessary. those ops are
> defined in the driver side w/o a conditional CONFIG_IOMMUFD.
> 
> We should warn out lacking of those ops to the driver developer
> as early as possible, instead of postponing it until someone
> starts to build kernel with CONFIG_IOMMUFD.

The ops are NULL if !CONFIG_IOMMUFD. The previous code was OK because
it checked for non-null bind before demanding the others be non-null.

Jason
