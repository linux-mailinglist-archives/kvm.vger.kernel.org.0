Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6DF697265
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 01:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjBOADW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 19:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjBOADQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 19:03:16 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1B16A79;
        Tue, 14 Feb 2023 16:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676419395; x=1707955395;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=rlB0MVytF5D/GO1JVb6x7OWZHNbT+sYByHBwFN94g3E=;
  b=b0kCl3dhPT+lRiRcb8XAN87P10DZ8yJHF52+tuLeuDz95ormfOnqMLvV
   x0D4gkZVwXuSVKr33GE1urpBlNKSy1PjfK0IkDpT8kqflnUv8nKt3JE/M
   L0T5SHzyRrEZYcwspXWQolzXTOABTNL4dGgCoK16vEPyG6QeZlYOURnM3
   JS2p16O2v87dfqD4bLkgt036yVrEeRs6Ndx6KbzfLC5Gyyhn4YDk1xkAP
   dQnq1VHBNoa4hr5coECd9ZqWJaBdwChVkmD6OQIRSQ0tpsKWhJ4zfvOOE
   uaD6zMR+JKl5dZnV/XewhBklyreFTLWksQ67fynKOJsNDfLEYUXKKbJg9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="393704296"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="393704296"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 16:03:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="733070677"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="733070677"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 16:03:14 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 16:03:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 16:03:13 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 16:03:13 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 16:03:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6NLCq4gUw7WlFeIoAN0YNboimKfnxF4O0ep8WJEA4zMVzdSAkUSwO457d7THnakp1UMTO9qPMGNB5pnL7Eufzn93dSElESfhxGTn81VOGTVkyprB0EIY/9j0ufOEB130HAZ5lXTkLLxKaxftUAx8t51EI24N2bonEO24NheLX6mIasNG4nYldRH38ZnYqcwKk3U191m9iPMdNFtSpT6uisLPL5/J/v8an5IEaJc82arDvo6x6YUmjovz0gXy6Ou3EMNUsUW79GzrPQJ0N7aCbS/4qF+lbpyNqkfs4RimOZ3mWyYp3WQkposVZTic7A0fRlU4N4eAedTPoeZ2nIOtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPrz97uPsJZfMbWdZX3XFIiIB7Skp/BVwWB6Pdrp6Ik=;
 b=Am6sxZl5bqbBZSOIwXLMRpefELfRPba/EoK1bZSS/YQEfmNWpUXT/9MVDK1eIi4j51RpEMPwFVhVe90LFiRqLaBsR0ADOsxtTT2HY3dTy6wEPpcy00G7Vu0YFe8ICu61hoZhcRkUpNBKXvM6fuN2qXjhsVWV0379VpNjBpeuwTTm4ocdiAwUCjaoP+Hlk9ORriV+XkbBrKE17w3w6deMFqWrqZQgr6EBIBDzAPjHxEkDbwrY8YZpox3EvHVF3pYsSpLXNseRMQizgfHoMXhxGgRLEjSg+UVVfv+Dc2DL/SRHcTxsMSYHvQrOHLacVLq23AVoVU7NfitFoIsKrBObBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7176.namprd11.prod.outlook.com (2603:10b6:208:418::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Wed, 15 Feb 2023 00:03:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%8]) with mapi id 15.20.6086.023; Wed, 15 Feb 2023
 00:03:12 +0000
Date:   Wed, 15 Feb 2023 07:39:26 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Yi Liu <yi.l.liu@intel.com>
CC:     <joro@8bytes.org>, <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <robin.murphy@arm.com>,
        <linux-s390@vger.kernel.org>, <yi.y.sun@linux.intel.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <jasowang@redhat.com>, <cohuck@redhat.com>, <peterx@redhat.com>,
        <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>,
        <suravee.suthikulpanit@amd.com>, <chao.p.peng@linux.intel.com>,
        <lulu@redhat.com>, <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH v3 14/15] vfio: Add ioctls for device cdev using iommufd
Message-ID: <Y+wbrgqt7+045A6o@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-15-yi.l.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230213151348.56451-15-yi.l.liu@intel.com>
X-ClientProxiedBy: SG2PR02CA0071.apcprd02.prod.outlook.com
 (2603:1096:4:54::35) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7176:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bea2fca-735c-41a9-4b50-08db0ee8070d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6wS5LJ1ECGw4a5DKnuo7WbaXfHJE0iGk8Lp5p0UCO5IS03kTbEjwHxp/cwmeqmgoMD8MhKilGpzPgVUnUAMzTYtPu6NoWoJWIqdJM+zxqaMoZDAOy61kIk7k8SKiRANKFDS6th/+/N1f9NR4mu9p8Jen3rQnaDtKnCxcifdIuqPfBFVaHgSTacVFhwczVKAD8ChsdIsJwh53sgfiHUcv16ExNnNgB3cF9rjpHbgCIjJ1DRhCEJrYLsfk20HoMmdjVMLOh/6L+5GFrGdXK8LhY0D2SAS5CS5GxT7sprvegGc9SHyzw5xnzol/NV+VETios+ULz4DW+HBLTszMb7x1/dcjtTB10H0LnB4YQ8+6tlwYmque0n3C71c1N7BwE2h/6NYM5tuWY11qiRMHFLJU1yQB6/o8MBqQhVrfPsn+t0vjdwvtjpVXFZoD34T46ISNcxwg6wEVbEvNUg5mJZbiwcKz7uAK/QzBgIUtXkZ4UkSCmpuD74CH8Y/dc38CK3xrfzxpY9xEkfUV06Bf4XzVkVSlN/s0O2q9+Yd4oC/gmaKG1TSUXfNHFMdwLJHs5cN0/oUGx/jujk0LU4DgKqhWLIobHumozyBJviG63yz8t95Xl+FNbv4jHhmmlvvqttPmE3sDjBOaA/kW2Ba2Fk9drg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199018)(86362001)(3450700001)(8676002)(66476007)(66556008)(66946007)(478600001)(4326008)(83380400001)(6636002)(6486002)(316002)(2906002)(5660300002)(6862004)(8936002)(7416002)(82960400001)(38100700002)(186003)(6666004)(6506007)(26005)(6512007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TVeO4xrtbVNiLt/G4ZboLf1KL2qxCrUwU/5wNGJsZkykF5d1pnWXl1retuUk?=
 =?us-ascii?Q?LEWHMThZfM63NQWBE21WGqSJo7fLdC8Z2VOMqZQXooKfkkyIMLqCAqBC0yro?=
 =?us-ascii?Q?JSUQGM2Yw0vZAEkxvpgFmhv2E+FuYOHNgbCuQxGkAaBDKuT7MkbMipnORb1W?=
 =?us-ascii?Q?rDaR36ADgoAoGis4QYQYOODLwnIiarGFUHzN6O4YVZR/32eygVbCs/2XYVtQ?=
 =?us-ascii?Q?BS/TeDS/rwm4CYU/ZIhH+Jh6He3MKY1t0M1sks2VGyONRUzWaH3OMfDJ7Nkk?=
 =?us-ascii?Q?5FqgYFwe73eBNihGFB2p8taoGsKdCxsxJxOA+8DwOmws/Nv2kLaMLxDkQeuN?=
 =?us-ascii?Q?e+rMYTbFfpnxhpF8viRDYHAcDPqI+qYg81a7WwpOy5M0Vxlf3lXPGmGGD5Qv?=
 =?us-ascii?Q?PzSo1hv+CiWhbHZ8J3JQqRZSH0dBK2AiKwZtGtmiYCRqrVqw2GHO+hU23G25?=
 =?us-ascii?Q?xRBPJGNlBaX0Gi34pTAg9r04f2Ah8Mlp97LkwK7CR4XKZugZ0eOmh3kHPguR?=
 =?us-ascii?Q?/7n3o0VBFNrgsNVTr+PJAhQ0JvKB6WlTm51ER3/B17aZRV3yuCwDI3i7tYbo?=
 =?us-ascii?Q?Rw8FmiZHpZfmx/UWppScowS2OXp/198P4B41EoB0jr6hVDjAVc00bKWKGge0?=
 =?us-ascii?Q?+RN7tyEjYdOXgQHrsftb9w3RZGrBJQvHUYWhs5bVs/dNTmcEEHUOiwfjNoGa?=
 =?us-ascii?Q?Au/F/l6/hEjXIiJlsLwG4DXrx1Y909NeYXGzDcqNnCQGsGMa8sZJnukbQno+?=
 =?us-ascii?Q?vhca5a9KZd2S4+7YEKSZ7QmFxEHmZvdXmmwb4ejIj7KjAivtJKWPZI+Wxdxr?=
 =?us-ascii?Q?1yxkZgaYltt0vUh8RULPCbcunsye/Q32um9GikMpnCwgLcAHf61x1dkRSHBS?=
 =?us-ascii?Q?e2gzzN/pzDg3WrSP3ofmqcvJBDpscl2VpZ53E4U4VfCWP7Zs+ZuKDxj1L8Xg?=
 =?us-ascii?Q?q1LcDfCAyaWC0wT0qsQFA8AiQ7/SiEb+lHEifjpPm6SRoU3U6G5JQDQ2NvVQ?=
 =?us-ascii?Q?HFD2C39etP35cvrZOZMZz0aaIXUDNAs4Pl+TH0ElKgpBBEJj2ENg+SxoyWBo?=
 =?us-ascii?Q?JMcCL0UdA5VOURs4xWBjewMTel8GboOMI2JC1RZNXjAl/yBc8A+11EdCx105?=
 =?us-ascii?Q?Rp4KgSfV/P+sBrDfZ7b3e6NkPJFVz0XO8C/vSBJ+HG5sVvcEQb0H1xLNsk3c?=
 =?us-ascii?Q?s3mkAuSdNuEfXd6k1y06YzvvQ4xj3crhbNolA7p3z3EwxGmo4OUW2m4hXKC9?=
 =?us-ascii?Q?psUZ+HtWRW1TzQ2fwL3OOUl8VdblHUE9o+jHwef8eOUo/2DER2b6dMpheGXs?=
 =?us-ascii?Q?BVOIrVqv0WFIQNxPELOLSJ+ps+OXQ0+gAynXOyn+B5nQfjaXn0ZBgiZ0PaaD?=
 =?us-ascii?Q?r/TS2fYh0ls/15f0f8bvrw2yGRLZLAIZNZMzS3XXtZpDUjJ5n8hoIEowWzjV?=
 =?us-ascii?Q?QQQrj2NzvILchuG5Xuxx7fAnJwC0Ir8wgc7lg/9nlsC8bO0SC/+h8dklpEKW?=
 =?us-ascii?Q?KGkYiQsvtCqpejswGKoTHMgeMvH0l4Qg8WSF6tOQpyi1fsf0Z3YB2pIqlSVY?=
 =?us-ascii?Q?CsfCZN31E+LAGHYE1rHdwPH7IQOgNt9IYY0BYaSTZeAAXvIQnymjgwvRZKlj?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bea2fca-735c-41a9-4b50-08db0ee8070d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 00:03:11.9069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLlWPfATQgjUpJXOC63BxtKDwq15xNtModbomoW8MIDlO+8GFO2cryfzbu/Vqxt7vMjuVGoaw4SilOrnuZAhbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7176
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023 at 07:13:47AM -0800, Yi Liu wrote:
...
> +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				    unsigned long arg)
> +{
> +	struct vfio_device *device = df->device;
> +	struct vfio_device_bind_iommufd bind;
> +	struct iommufd_ctx *iommufd = NULL;
> +	struct fd f;
> +	unsigned long minsz;
> +	int ret;
> +
> +	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
> +
> +	if (copy_from_user(&bind, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (bind.argsz < minsz || bind.flags)
> +		return -EINVAL;
> +
> +	if (!device->ops->bind_iommufd)
> +		return -ENODEV;
> +
> +	ret = vfio_device_claim_group(device);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	/*
> +	 * If already been bound to an iommufd, or already set noiommu
> +	 * then fail it.
> +	 */
> +	if (df->iommufd || df->noiommu) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	/* iommufd < 0 means noiommu mode */
> +	if (bind.iommufd < 0) {
> +		if (!capable(CAP_SYS_RAWIO)) {
> +			ret = -EPERM;
> +			goto out_unlock;
> +		}
> +		df->noiommu = true;
> +	} else {
> +		f = fdget(bind.iommufd);
> +		if (!f.file) {
> +			ret = -EBADF;
> +			goto out_unlock;
> +		}
> +		iommufd = iommufd_ctx_from_file(f.file);
> +		if (IS_ERR(iommufd)) {
> +			ret = PTR_ERR(iommufd);
> +			goto out_put_file;
> +		}
> +	}
> +
> +	/*
> +	 * Before the device open, get the KVM pointer currently
> +	 * associated with the device file (if there is) and obtain a
> +	 * reference. This reference is held until device closed. Save
> +	 * the pointer in the device for use by drivers.
> +	 */
> +	vfio_device_get_kvm_safe(df);
> +
> +	df->iommufd = iommufd;
> +	ret = vfio_device_open(df, &bind.out_devid, NULL);
> +	if (ret)
> +		goto out_put_kvm;
> +
> +	ret = copy_to_user((void __user *)arg +
> +			   offsetofend(struct vfio_device_bind_iommufd, iommufd),
> +			   &bind.out_devid,
> +			   sizeof(bind.out_devid)) ? -EFAULT : 0;
> +	if (ret)
> +		goto out_close_device;
> +
> +	if (iommufd)
> +		fdput(f);
> +	else if (df->noiommu)
> +		dev_warn(device->dev, "vfio-noiommu device used by user "
> +			 "(%s:%d)\n", current->comm, task_pid_nr(current));

IMHO, the "smp_store_release(&df->access_granted, true);" in patch 7
should be moved to here when bind is indeed successful.


> +	mutex_unlock(&device->dev_set->lock);
> +	return 0;
> +
> +out_close_device:
> +	vfio_device_close(df);
> +out_put_kvm:
> +	df->iommufd = NULL;
> +	df->noiommu = false;
> +	vfio_device_put_kvm(device);
> +out_put_file:
> +	if (iommufd)
> +		fdput(f);
> +out_unlock:
> +	mutex_unlock(&device->dev_set->lock);
> +	vfio_device_release_group(device);
> +	return ret;
> +}
...
