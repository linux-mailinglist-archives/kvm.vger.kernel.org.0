Return-Path: <kvm+bounces-21033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CCA2928128
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 06:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 015F1B24D81
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B0A1369AE;
	Fri,  5 Jul 2024 04:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E5xu9kPu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2E673448;
	Fri,  5 Jul 2024 04:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720152170; cv=none; b=KwA3xlu19nhHKZdJuMBHz4NyMbSe3zoBscvOwti8Dquhk/2Yg1F/y88Mo/r6AyucyEf61lfPPGwxuyr3GeEJpcmQMA0rKyOdXCaa894VbaMsIWELrW8Yt3/AvtHjonHlovTbISix+fRHKv/8oh1nZbnfnYbwdR7f18OJWCjatgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720152170; c=relaxed/simple;
	bh=NTs8cdPmXydAT7wf+ZRCPvOrg5JcTb7r2luwDH/A6qw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YZo1lDJ2O0r4J9sc4981iMRNTt4gsV/pdGcSyT9stGGDu6yfKxA/1A5Yv79wnmlMvltDM2nrTtMQP1cpjzzxW7t1kqEFjtPdfJlGfmnsULdelN2dcUoOQk0EJN/zE6ICWvLyoz2W5H1uFPnfGQk35eVi+pBCNJtskvQX61tEv8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E5xu9kPu; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720152169; x=1751688169;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=NTs8cdPmXydAT7wf+ZRCPvOrg5JcTb7r2luwDH/A6qw=;
  b=E5xu9kPuDQf9qj3iE5Xu9XctKKT3VOjLzbGb7xWDJ8IdD5E0QJrZS9zx
   UY2I/ejAbU7EPtEkIGHcwH8QNiVn7zQSZjI4Xa+95aJUDVb7EXJvgCEct
   LhqTJpzyuVTkR9tObvaEteBV27rJQ7mVUTg/nwPdGFv9N7H9Hu3N1mzPu
   N3HzUurDWCcD6df/LLbbUeH1TM1QkRF6YIq7OO7dNBCsvujY4aojI9qvo
   hNIxRDybNOyJwrDisFeqzKhNgptc+Ui2kn67YvnffwYdhq77BE3BGtgt+
   8DM6wlnBGm9xEKMf6QDIVMIyCMOzqh+X+65DbkgUHpXuENED3KDqPenAN
   g==;
X-CSE-ConnectionGUID: EJhGwkyPR/u6b76ex07JXQ==
X-CSE-MsgGUID: OM80KeV5QD2xnW6aC683Gw==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="17081660"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="17081660"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 21:02:49 -0700
X-CSE-ConnectionGUID: miGB7wAdTG+jVSj2Eq3mJA==
X-CSE-MsgGUID: gczDXJkkTSy5j3tWShrBdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51091746"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 04 Jul 2024 21:02:46 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sPa9k-000Rt5-1I;
	Fri, 05 Jul 2024 04:02:44 +0000
Date: Fri, 5 Jul 2024 12:02:15 +0800
From: kernel test robot <lkp@intel.com>
To: Jiri Pirko <jiri@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [mst-vhost:vhost 45/58] drivers/s390/virtio/virtio_ccw.c:708:22:
 error: 'vq_info' undeclared; did you mean 'vqs_info'?
Message-ID: <202407051121.VASLAYUt-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   b3dab3dfaa73df6bde78cb52f6bc03f57c4d056c
commit: f07c2dc394264dd811776de1dec9544f2181f2e4 [45/58] virtio: convert find_vqs() op implementations to find_vqs_info()
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20240705/202407051121.VASLAYUt-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240705/202407051121.VASLAYUt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407051121.VASLAYUt-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_find_vqs':
>> drivers/s390/virtio/virtio_ccw.c:708:22: error: 'vq_info' undeclared (first use in this function); did you mean 'vqs_info'?
     708 |                 if (!vq_info->name) {
         |                      ^~~~~~~
         |                      vqs_info
   drivers/s390/virtio/virtio_ccw.c:708:22: note: each undeclared identifier is reported only once for each function it appears in


vim +708 drivers/s390/virtio/virtio_ccw.c

   689	
   690	static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
   691				       struct virtqueue *vqs[],
   692				       struct virtqueue_info vqs_info[],
   693				       struct irq_affinity *desc)
   694	{
   695		struct virtio_ccw_device *vcdev = to_vc_device(vdev);
   696		struct virtqueue_info *vqi;
   697		dma64_t *indicatorp = NULL;
   698		int ret, i, queue_idx = 0;
   699		struct ccw1 *ccw;
   700		dma32_t indicatorp_dma = 0;
   701	
   702		ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw), NULL);
   703		if (!ccw)
   704			return -ENOMEM;
   705	
   706		for (i = 0; i < nvqs; ++i) {
   707			vqi = &vqs_info[i];
 > 708			if (!vq_info->name) {
   709				vqs[i] = NULL;
   710				continue;
   711			}
   712	
   713			vqs[i] = virtio_ccw_setup_vq(vdev, queue_idx++, vqi->callback,
   714						     vqi->name, vqi->ctx, ccw);
   715			if (IS_ERR(vqs[i])) {
   716				ret = PTR_ERR(vqs[i]);
   717				vqs[i] = NULL;
   718				goto out;
   719			}
   720		}
   721		ret = -ENOMEM;
   722		/*
   723		 * We need a data area under 2G to communicate. Our payload is
   724		 * the address of the indicators.
   725		*/
   726		indicatorp = ccw_device_dma_zalloc(vcdev->cdev,
   727						   sizeof(*indicatorp),
   728						   &indicatorp_dma);
   729		if (!indicatorp)
   730			goto out;
   731		*indicatorp = indicators_dma(vcdev);
   732		if (vcdev->is_thinint) {
   733			ret = virtio_ccw_register_adapter_ind(vcdev, vqs, nvqs, ccw);
   734			if (ret)
   735				/* no error, just fall back to legacy interrupts */
   736				vcdev->is_thinint = false;
   737		}
   738		ccw->cda = indicatorp_dma;
   739		if (!vcdev->is_thinint) {
   740			/* Register queue indicators with host. */
   741			*indicators(vcdev) = 0;
   742			ccw->cmd_code = CCW_CMD_SET_IND;
   743			ccw->flags = 0;
   744			ccw->count = sizeof(*indicatorp);
   745			ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_IND);
   746			if (ret)
   747				goto out;
   748		}
   749		/* Register indicators2 with host for config changes */
   750		*indicatorp = indicators2_dma(vcdev);
   751		*indicators2(vcdev) = 0;
   752		ccw->cmd_code = CCW_CMD_SET_CONF_IND;
   753		ccw->flags = 0;
   754		ccw->count = sizeof(*indicatorp);
   755		ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_CONF_IND);
   756		if (ret)
   757			goto out;
   758	
   759		if (indicatorp)
   760			ccw_device_dma_free(vcdev->cdev, indicatorp,
   761					    sizeof(*indicatorp));
   762		ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
   763		return 0;
   764	out:
   765		if (indicatorp)
   766			ccw_device_dma_free(vcdev->cdev, indicatorp,
   767					    sizeof(*indicatorp));
   768		ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
   769		virtio_ccw_del_vqs(vdev);
   770		return ret;
   771	}
   772	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

