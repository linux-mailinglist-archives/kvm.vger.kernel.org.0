Return-Path: <kvm+bounces-21089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B3E929EC3
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 11:16:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B47C6B23785
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 09:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AC764A98;
	Mon,  8 Jul 2024 09:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KxY8xRGs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B8F433CA;
	Mon,  8 Jul 2024 09:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720430157; cv=none; b=qFgWzjI0XYoheppo38nsQ3Flc/FwRb/yreQZ886yE5K7La5PT4qtVO+wSJU9gtEsP8uqFNaF4yEeh8G95W4qCHfJ+9LpQ1WhATsXCa4AO/4T/ROKWsBDCYqYD6gzmWoe6d8wTVavAk7Mu/w3OQgezk1RXkFn/Z8l9kY+rhR7P9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720430157; c=relaxed/simple;
	bh=hgN66bAz8IkkTy8CvtHp3JUw6MLJpCYUWOaeBYIssMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sXVvPIi3tfdOK39cAoX97GG+9X2X7Vlmc90GAIuN8fsFb3yHXBESnwD9b5H6WclRRI0DBWLWVxzCNhiLa2M/HVYRqiu3vsp8B2unoo4SNSKwbbhU/uH15GWzXx9S9aNMSS1+PTwJl97NVd6H+SFI8IV9ye358l5MFlTBfKiQ6Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KxY8xRGs; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720430156; x=1751966156;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hgN66bAz8IkkTy8CvtHp3JUw6MLJpCYUWOaeBYIssMU=;
  b=KxY8xRGsbd3BfyVE/R2N5+YRZGwtBnkkRG4HvzhVf3SBWU1oyIhqzt7Y
   73eq7M+pCMgTff/EMQJTDuHQaKhj/mo5TxvhP0rUVEn/chKtu4WrijXRg
   VbfJtrCoBiZOQzBMa1lW0+xL08SfaRhQs0HLfljiMBm4JFtTZuE5p+twm
   yhjLF35orJVhFCO25aH12kPzMtEddz3ehXl/DSneCUEeWFLHjgHLPrAA5
   K3U8I7ToWufxaFnYJgbJjGn/YhtG2aQlnOHLTWnqIDS2yW0Wjf2EM8s/d
   2V58eGuPeRKMgjRTzMC0NryvNOJwtmfiVlylRGEJuyOa01zaBcjzn+noe
   Q==;
X-CSE-ConnectionGUID: 58YOtsXYQxultniENuwPcg==
X-CSE-MsgGUID: rmxa/o0uSzikG/hy/tWVvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11126"; a="17437027"
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="17437027"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 02:15:56 -0700
X-CSE-ConnectionGUID: GrQZXYTkQeW7szw5V2SzlQ==
X-CSE-MsgGUID: 5eqphG5pS+y70DV+Iv/DwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="70652136"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 08 Jul 2024 02:15:52 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sQkTO-000Ve0-01;
	Mon, 08 Jul 2024 09:15:50 +0000
Date: Mon, 8 Jul 2024 17:15:42 +0800
From: kernel test robot <lkp@intel.com>
To: Cindy Lu <lulu@redhat.com>, dtatulea@nvidia.com, mst@redhat.com,
	jasowang@redhat.com, parav@nvidia.com, sgarzare@redhat.com,
	netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v3 1/2] vdpa: support set mac address from vdpa tool
Message-ID: <202407081733.FCiMubD8-lkp@intel.com>
References: <20240708064820.88955-2-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240708064820.88955-2-lulu@redhat.com>

Hi Cindy,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on horms-ipvs/master v6.10-rc7 next-20240703]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Cindy-Lu/vdpa-support-set-mac-address-from-vdpa-tool/20240708-144942
base:   linus/master
patch link:    https://lore.kernel.org/r/20240708064820.88955-2-lulu%40redhat.com
patch subject: [PATCH v3 1/2] vdpa: support set mac address from vdpa tool
config: i386-buildonly-randconfig-005-20240708 (https://download.01.org/0day-ci/archive/20240708/202407081733.FCiMubD8-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240708/202407081733.FCiMubD8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407081733.FCiMubD8-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/vdpa/vdpa.c:1377:6: warning: variable 'err' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
    1377 |         if ((mdev->supported_features & BIT_ULL(VIRTIO_NET_F_MAC)) &&
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1378 |             nl_attrs[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/vdpa/vdpa.c:1394:9: note: uninitialized use occurs here
    1394 |         return err;
         |                ^~~
   drivers/vdpa/vdpa.c:1377:2: note: remove the 'if' if its condition is always true
    1377 |         if ((mdev->supported_features & BIT_ULL(VIRTIO_NET_F_MAC)) &&
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1378 |             nl_attrs[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/vdpa/vdpa.c:1377:6: warning: variable 'err' is used uninitialized whenever '&&' condition is false [-Wsometimes-uninitialized]
    1377 |         if ((mdev->supported_features & BIT_ULL(VIRTIO_NET_F_MAC)) &&
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/vdpa/vdpa.c:1394:9: note: uninitialized use occurs here
    1394 |         return err;
         |                ^~~
   drivers/vdpa/vdpa.c:1377:6: note: remove the '&&' if its condition is always true
    1377 |         if ((mdev->supported_features & BIT_ULL(VIRTIO_NET_F_MAC)) &&
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/vdpa/vdpa.c:1371:9: note: initialize the variable 'err' to silence this warning
    1371 |         int err;
         |                ^
         |                 = 0
   2 warnings generated.


vim +1377 drivers/vdpa/vdpa.c

  1363	
  1364	static int vdpa_dev_net_device_attr_set(struct vdpa_device *vdev,
  1365						struct genl_info *info)
  1366	{
  1367		struct vdpa_dev_set_config set_config = {};
  1368		const u8 *macaddr;
  1369		struct vdpa_mgmt_dev *mdev = vdev->mdev;
  1370		struct nlattr **nl_attrs = info->attrs;
  1371		int err;
  1372	
  1373		if (!vdev->mdev)
  1374			return -EINVAL;
  1375	
  1376		down_write(&vdev->cf_lock);
> 1377		if ((mdev->supported_features & BIT_ULL(VIRTIO_NET_F_MAC)) &&
  1378		    nl_attrs[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
  1379			set_config.mask |= BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR);
  1380			macaddr = nla_data(nl_attrs[VDPA_ATTR_DEV_NET_CFG_MACADDR]);
  1381			memcpy(set_config.net.mac, macaddr, ETH_ALEN);
  1382	
  1383			if (mdev->ops->dev_set_attr) {
  1384				err = mdev->ops->dev_set_attr(mdev, vdev, &set_config);
  1385			} else {
  1386				NL_SET_ERR_MSG_FMT_MOD(info->extack,
  1387						       "features 0x%llx not supported",
  1388						       BIT_ULL(VIRTIO_NET_F_MAC));
  1389				err = -EINVAL;
  1390			}
  1391		}
  1392		up_write(&vdev->cf_lock);
  1393	
  1394		return err;
  1395	}
  1396	static int vdpa_nl_cmd_dev_attr_set_doit(struct sk_buff *skb,
  1397						 struct genl_info *info)
  1398	{
  1399		const char *name;
  1400		int err = 0;
  1401		struct device *dev;
  1402		struct vdpa_device *vdev;
  1403		u64 classes;
  1404	
  1405		if (!info->attrs[VDPA_ATTR_DEV_NAME])
  1406			return -EINVAL;
  1407	
  1408		name = nla_data(info->attrs[VDPA_ATTR_DEV_NAME]);
  1409	
  1410		down_write(&vdpa_dev_lock);
  1411		dev = bus_find_device(&vdpa_bus, NULL, name, vdpa_name_match);
  1412		if (!dev) {
  1413			NL_SET_ERR_MSG_MOD(info->extack, "device not found");
  1414			err = -ENODEV;
  1415			goto dev_err;
  1416		}
  1417		vdev = container_of(dev, struct vdpa_device, dev);
  1418		if (!vdev->mdev) {
  1419			NL_SET_ERR_MSG_MOD(
  1420				info->extack,
  1421				"Fail to find the specified management device");
  1422			err = -EINVAL;
  1423			goto mdev_err;
  1424		}
  1425		classes = vdpa_mgmtdev_get_classes(vdev->mdev, NULL);
  1426		if (classes & BIT_ULL(VIRTIO_ID_NET)) {
  1427			err = vdpa_dev_net_device_attr_set(vdev, info);
  1428		} else {
  1429			NL_SET_ERR_MSG_FMT_MOD(info->extack, "%s device not supported",
  1430					       name);
  1431		}
  1432	
  1433	mdev_err:
  1434		put_device(dev);
  1435	dev_err:
  1436		up_write(&vdpa_dev_lock);
  1437		return err;
  1438	}
  1439	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

