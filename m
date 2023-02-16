Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FC9698EF5
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 09:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBPIsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 03:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBPIsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 03:48:15 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CB538E86;
        Thu, 16 Feb 2023 00:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676537294; x=1708073294;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=5djWH0WSuY+3FU/poQKqEXOPP6rLmgylUgHL+WSICYk=;
  b=TnQ1LekKZl0qO/EfklRhJthcJ3plK0YUdeWMHjjGyOqSkODjSlpUULCd
   tkADF2FTzDN9eOQDIEvj5NUOBn8h4im8yoUwjERQwxJDolIG+qUvJjgEk
   dPeiNjsZHQ9sD+UPuNu8FhFtayAK5asI2EvU0Kx3adiO8m8hOfuSGTvw3
   vdelSNTqwcoU7Cg0NcTEiCo2a9vE/NOPnYiUprfzr6VP24Y6ntnSPECoY
   hys1HLEXsw5HhkZ12su+Zpds/+hrkw330KonRnbH8p6OXRbRK3za3av7l
   Iwmc0YIdo/xb5UFPttse7SM/5NLiMKIPZB+c86nu2hSnVyy3BA+2MJARY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="394086968"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="394086968"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 00:48:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="758854711"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="758854711"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Feb 2023 00:48:13 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 00:48:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 00:48:12 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 00:48:12 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 00:48:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lR85EwXtecKKGlJUKAv9y+NvCri6KbO87TwzCaXquwABnTBUPFWoOPAkl3GAVr8ccBjBZY5Tjc5920GM6y2TkxQfD42kTcyDkWMtUZ6lkNq3niM1ToGl4hYolf9fJrJNVuUXme63WJRzjQ0TVJCRenMjRz272bjWFxdyUa4qOWTelsW/yNABcS/0eBdwo9i3kL1OgvQO+NXR9p2lxFmj1Pr97fmSDJxDwpHw8l2MD7kM45PUX+nH7NQ9F11m4p9vgVBA7xoZso6GYZssRckcJ5pQIPpyrpFrACnebxYlrFs7ygzPAm6EL0T6Zs8Hz5kYdracF0y4lSt8ZA/eZ1BvtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CN1RFxjnQRLPr9wPofHioazHdbV5BL8JLjhKJqXLijY=;
 b=SdQwz2NVpPT7sQtEsrz7jG3YQpgbCTTDxa6+LgyR1w8pLwiX9/aD0NbC8y1vT/AgWLW1ub5xwIgUQ3CtAjndBELNdGsu/suqOQG3FMwOxnEaYMPWuk2VgSJacH2leMDhwiGjVLnqOrSvmunj2kVxephj8JB6m08B1x2ClLRZ4WcKI4yUfs9JZ5xiKMFe3sH7DR/t/hUnE4ziGiyPFqctc3JOxU+RKebe5AFNFBZv2s9MzVPm66MkdZN6x1KVChYJobtyw7/L3TDn/+y/g6aX6Wkqe9uO4/TGLEvCHa1c2sQ3Fe7bC9Lo6Vk712jLmAAooSrxfUm9o16aTcmSL6+z7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7933.namprd11.prod.outlook.com (2603:10b6:208:407::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 08:48:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%7]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 08:48:10 +0000
Date:   Thu, 16 Feb 2023 16:24:25 +0800
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
Message-ID: <Y+3oObuMG/v3+x0N@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-15-yi.l.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230213151348.56451-15-yi.l.liu@intel.com>
X-ClientProxiedBy: SGBP274CA0012.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::24)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7933:EE_
X-MS-Office365-Filtering-Correlation-Id: 92da7912-89dd-4506-4c21-08db0ffa882e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XVeql+u0pTjCqaO8TB4WNRJubVrEz4v1P7Z0vumcovHOSAwY2oK15ZytwvMAwbdhtps0x6I3/e3w1Xw4e3W76e06r3hhYn58eLpcusvcUGXLyCXeb/hgbRLdvlI7WPwMpfMk5Bh2OWI1Pb/wK9b+5VCLIKVPKOER64Fwhk7JBzaXFsUJhWrHi+IK9Cdqv3pvDw5LsexCiIzJDG6mHms58I4oh61wKXgylQxKURohzIDojA3pABYWHn6Js68Uf9883jSTEeLdkasVcsS3jbagDu6l3grV/pZMtIxJzR5rH37D2BWpUD6RZTDkpzKKgp7I/KdoooPeJx9x4d8QKM75Niy1PZToDIPLb3luks1Z69WPbvaFc5dLLb71dt3OMtOATU6ZBHu9UQL1/ge07/QGz00SJByRvsUGGlCo8qMyDEou7KItF8GN9REQ3riTzjunnTfrl2isExzlgKe6kTPgZD67Bb0fs726SuJK/GVh9l5O4TDBDcCFJPgBuRDtnGA6TgKBI06SjphEP1tlO2xuBfTtQb2Re42dpDOUQhpfapWQNWnVLdWiyxi+0bPZQL/sRFxoVOVHuMCxyWUrsptuXcPn6S+aWFWGd+wanai0JwJyZzOTWTLVRlgWZU8aBTmjcJVE39Dmq8VD3gs6SAhjiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199018)(6666004)(6486002)(186003)(6512007)(478600001)(26005)(6506007)(86362001)(82960400001)(38100700002)(83380400001)(8676002)(41300700001)(8936002)(6862004)(5660300002)(7416002)(6636002)(66946007)(316002)(66556008)(66476007)(4326008)(2906002)(3450700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gq52KCWte0hEm6xDFy2Saf4J9qbGPeTMJp/QINPiMzmeRq8CoUJPtXB3pjkw?=
 =?us-ascii?Q?ja8BmkvP1Lh0ZAi9eEAymazGStAhn4AKpRpfixeoHAw/SBs8L6ijtGJ5QZSc?=
 =?us-ascii?Q?j4xlG6WLn0WU6ify1P+q0TGY+LtYQKagdz9uBInfdRF6bgJZtNh0Ctmu+Hwi?=
 =?us-ascii?Q?3cgcvszVLQ6l1XUie7MEarg3b+SetYFkuNIWrpDUNgUoLyyo1wp1JajTd5So?=
 =?us-ascii?Q?kUtyNpnlMbg5utHEy+1anYLUecs78ejNMS1l+trzDBFlVEs95kyQvnE/Bm79?=
 =?us-ascii?Q?dyn1VFeqiHAxUKxzA21VUOlv1Dbdo+aNtiqs+qY6FBoCMgIiSjMnv9OoD+dg?=
 =?us-ascii?Q?FhVdC56JEH9zTgwJj4pMJFrstK8ZjWKA5IO7ASIyehc/vYVfOidCWEr0CW4e?=
 =?us-ascii?Q?FSH8lrE6wqTtS63/Cok3e3AA/Lwi/6Lbppiz2xrTV7+Xq45cXpgg9EkzBmfA?=
 =?us-ascii?Q?23vQHkzKvpAZBANQZensLIF4LOk/Q0BFpQuVcdS37Zusue4XpKuCm0wtLi1k?=
 =?us-ascii?Q?rvNJITZQspusU9t7Y2jaVoNa9X8mj2bJXO+QB3UkcbhyBYkMjWg1OnoIvL+u?=
 =?us-ascii?Q?O/CJhSJMhbH8UNR1HWSYpohbP1OiQrKvQBltH6eyv28+XIgmtrgSXkkFFbk7?=
 =?us-ascii?Q?UdnSBuQOv+ARWNI2jK5aPSGSOq15qAPNbQjAF96KSmMImJRh5b7Mx0rT5cYo?=
 =?us-ascii?Q?8lQX8vbvRqTkoRn3wLc3ETzbz3u88oydZf1B4iJtGZ8+V1kw0tSr/cVkBTfY?=
 =?us-ascii?Q?KudypfEptUdoWk4xO4I2+MSwFeH3p5vun4U8L6jo2U+vuyUkM71mdqrI6FHp?=
 =?us-ascii?Q?an/TnCEz5O4rrB/Lj3cesDiPAQrg9jOGeT5IWuTk/DmpqASBbbV73ZllXRnB?=
 =?us-ascii?Q?qXXlMjHNfVYD1USvqirxyPZGY+l6nVeOvovsc80gVnlbrOxXdn6oa4MlDL0d?=
 =?us-ascii?Q?v8CTyl0p5qBF7ZQCG2Xp0iHH1HTYSVEK8/4p9vO0IrPi3iKa4xaRbHNyypd0?=
 =?us-ascii?Q?kqCXUawHD5ewfapKu8qCX76XTWnGafBHSrklxTExuuAB8tI+MopsB58mGEff?=
 =?us-ascii?Q?qKXboe2+8M/++M0Jr9yLA/e8vCpFoSK8O6E94xIaA5E0qAJMUYJPnJZU3yih?=
 =?us-ascii?Q?xTVLdvH/fOMpqTcQ1fRFDpowTMMfpVZou5qzzdpTLgE1HMKMjD7xfgc4gNQR?=
 =?us-ascii?Q?udT/Sic04V57SrhK9Yu+oNo1MqFpXJQXwACZ8SDyl/t42T0DvQJ4rTyoahQm?=
 =?us-ascii?Q?k34+uZuZ8qtMVDv881jWfyRSC1Q6jOcdmP5Idm2yLjAbvHt7T9r4dgpOOfEo?=
 =?us-ascii?Q?O8gydcgcgjUYG40PdkCm6dwB88uMNELcrDD7smXNPzRNFbGQDyLZumq0Xf6T?=
 =?us-ascii?Q?yjVhgyDO18OJ7gTEv3wvKR/e6c/0TwR0o0J31UTPTj0N0gHmBplq4kEZw9Ih?=
 =?us-ascii?Q?g7QPNIjwjFXhyAfWvHXlaqGrsG1fGQ34CtkoZfuM/NpuNgE/kDDp1k5NPcr6?=
 =?us-ascii?Q?O+2/0TfVVoG0YZF+FPeIpCQ3LR20EB0gdHSY1akFgHus0sj3iwOmjBI7VmdH?=
 =?us-ascii?Q?M2xNCYNur30XJ+vRMhk8aNHpB+UkT8k8r6gtrybkJFTmNb127uYL/xGe1Zjf?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92da7912-89dd-4506-4c21-08db0ffa882e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 08:48:10.6689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OeeH2bcMUvEjMBW+OyNK2Enh0aTtAI0R0eYI4qhL8virFlIsxWgK1m3HEIRTwQN7yU+4CxO7gqpiOfiS56eCAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7933
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
Here, the iommufd file count + 1,

> +		if (!f.file) {
> +			ret = -EBADF;
> +			goto out_unlock;
> +		}
> +		iommufd = iommufd_ctx_from_file(f.file);
iommufd file count + 1, again

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
iommufd file count + 1 in iommufd_device_bind for first open.

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
But, only one file count is put.

Need a paring iommufd_ctx_put() after a successful iommufd_ctx_from_file()
above to avoid iommufd_fops_release() never being called.

e.g.

@@ -1222,11 +1226,13 @@ static long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
                        ret = -EBADF;
                        goto out_unlock;
                }
                iommufd = iommufd_ctx_from_file(f.file);
                if (IS_ERR(iommufd)) {
                        ret = PTR_ERR(iommufd);
                        goto out_put_file;
                }
+               iommufd_ctx_put(iommufd);
        }

        /* df->kvm is supposed to be set in vfio_device_file_set_kvm() */

> +	else if (df->noiommu)
> +		dev_warn(device->dev, "vfio-noiommu device used by user "
> +			 "(%s:%d)\n", current->comm, task_pid_nr(current));
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
> +
