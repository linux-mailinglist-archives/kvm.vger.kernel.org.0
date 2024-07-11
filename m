Return-Path: <kvm+bounces-21411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E1792E968
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 15:24:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3D8C280F1A
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 13:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4459B15FCEA;
	Thu, 11 Jul 2024 13:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fnKlRyzT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55E315EFAE;
	Thu, 11 Jul 2024 13:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720704275; cv=none; b=DcrtpGiFgQxfmVanrZV55YdZJZwbAjUaKizax53D199ElkrD1tJTdf1nJPMcAYU8BX1JZk/ROISac/EDJhON1/6+hnayk++4cNj6XTnW8kIa1Ga8InSFUVBc45cS0Fm88iaJWtL68DlhZwx+PgNOVCR6avSKOuGGoIyeHOCpJiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720704275; c=relaxed/simple;
	bh=w1u81luxRSKXuuP8bL2ZtVySjx/0jxSrRzrfaS7TWpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqsHFzUONatg617mG+Jvr+lsFMhL3wcqPgYCg7oDffTzAhvD7BEMSW4upEKgQ66nsgg8lXqWqWMUXFrMm9ambFuwaiHEoPAJPuF5bqYFPJs+KQPuuvUSZFhHvuYuWkrdIcoUlm3TvHcv/vy7YZ7ARohRVn2IXSKOA9n/7NCwDmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fnKlRyzT; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720704274; x=1752240274;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w1u81luxRSKXuuP8bL2ZtVySjx/0jxSrRzrfaS7TWpk=;
  b=fnKlRyzTMusmSQxIr//bTdOI1F6boLgTfbRyVQUJnNsQyZPOY7wrhGDR
   OVJhlorejfnUVWxDwHVLbCP2luSVg9K5/RGzYx5QYH2mknkAeEc2MKoZy
   0iAzz6Q/jZPGk3T0DsDCqKdPbPiWnLEAJd2GEROsNHJj6UgdPqTFj1lwI
   /yHfD7OGTnXPVQ20SqJx4tCKwPNWJuKRX0zg5SyK+U8Acf1A12nqA/Jt0
   fB2EOBEy4pxASqpJsvqgbMp95mmV2QpM3NypwPYC6hxJTAUcGWnq2lwvQ
   N/wylCQ9rNKZKOkFztasjAYZm2hYXjsckhqre+yEd1YAn+2Ll5+7/I8fS
   w==;
X-CSE-ConnectionGUID: 8hmpUz8XR5+VWRgfZtNGig==
X-CSE-MsgGUID: +ZeZT5nYSlK2yJu456jxQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="28676502"
X-IronPort-AV: E=Sophos;i="6.09,200,1716274800"; 
   d="scan'208";a="28676502"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 06:24:33 -0700
X-CSE-ConnectionGUID: w68rnNGyTX+raf3+ra/vZQ==
X-CSE-MsgGUID: xfhpknJGQvakxEtM1SwOLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,200,1716274800"; 
   d="scan'208";a="53376105"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2024 06:24:27 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sRtmZ-000ZJz-2y;
	Thu, 11 Jul 2024 13:24:23 +0000
Date: Thu, 11 Jul 2024 21:23:54 +0800
From: kernel test robot <lkp@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	linux-um@lists.infradead.org, linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio: fix vq # for balloon
Message-ID: <202407112113.SzSpdDLK-lkp@intel.com>
References: <3d655be73ce220f176b2c163839d83699f8faf43.1720611677.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d655be73ce220f176b2c163839d83699f8faf43.1720611677.git.mst@redhat.com>

Hi Michael,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20240710]
[cannot apply to uml/next remoteproc/rproc-next s390/features linus/master uml/fixes v6.10-rc7 v6.10-rc6 v6.10-rc5 v6.10-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Michael-S-Tsirkin/virtio_balloon-add-work-around-for-out-of-spec-QEMU/20240711-004346
base:   next-20240710
patch link:    https://lore.kernel.org/r/3d655be73ce220f176b2c163839d83699f8faf43.1720611677.git.mst%40redhat.com
patch subject: [PATCH v2 2/2] virtio: fix vq # for balloon
config: i386-randconfig-014-20240711 (https://download.01.org/0day-ci/archive/20240711/202407112113.SzSpdDLK-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240711/202407112113.SzSpdDLK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407112113.SzSpdDLK-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/virtio/virtio_pci_common.c:391:1: error: version control conflict marker in file
     391 | <<<<<<< HEAD
         | ^
>> drivers/virtio/virtio_pci_common.c:392:30: error: use of undeclared identifier 'queue_idx'
     392 |                 vqs[i] = vp_setup_vq(vdev, queue_idx++, vqi->callback,
         |                                            ^
   2 errors generated.


vim +391 drivers/virtio/virtio_pci_common.c

   365	
   366	static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
   367				    struct virtqueue *vqs[],
   368				    struct virtqueue_info vqs_info[])
   369	{
   370		struct virtio_pci_device *vp_dev = to_vp_device(vdev);
   371		int i, err;
   372	
   373		vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
   374		if (!vp_dev->vqs)
   375			return -ENOMEM;
   376	
   377		err = request_irq(vp_dev->pci_dev->irq, vp_interrupt, IRQF_SHARED,
   378				dev_name(&vdev->dev), vp_dev);
   379		if (err)
   380			goto out_del_vqs;
   381	
   382		vp_dev->intx_enabled = 1;
   383		vp_dev->per_vq_vectors = false;
   384		for (i = 0; i < nvqs; ++i) {
   385			struct virtqueue_info *vqi = &vqs_info[i];
   386	
   387			if (!vqi->name) {
   388				vqs[i] = NULL;
   389				continue;
   390			}
 > 391	<<<<<<< HEAD
 > 392			vqs[i] = vp_setup_vq(vdev, queue_idx++, vqi->callback,
   393					     vqi->name, vqi->ctx,
   394	=======
   395			vqs[i] = vp_setup_vq(vdev, i, callbacks[i], names[i],
   396					     ctx ? ctx[i] : false,
   397	>>>>>>> f814759f80b7... virtio: fix vq # for balloon
   398					     VIRTIO_MSI_NO_VECTOR);
   399			if (IS_ERR(vqs[i])) {
   400				err = PTR_ERR(vqs[i]);
   401				goto out_del_vqs;
   402			}
   403		}
   404	
   405		return 0;
   406	out_del_vqs:
   407		vp_del_vqs(vdev);
   408		return err;
   409	}
   410	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

