Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE18029934E
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 18:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1787135AbgJZREx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 13:04:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1762 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1775769AbgJZREV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 13:04:21 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09QH1DYR003742;
        Mon, 26 Oct 2020 13:04:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rIkKZqw4JwCfXVcPcQ2/l4ZZou8Q+qQQCobXbD2a1Sg=;
 b=BFgaRghqFD0rSeJfkydmGya9LkWc2e6zRyi8MOK4F1JsmsI1VWBpFnBYIGQbpzjCH/WF
 o1uJoazVAoAOJNkUFFYix99XP25T6yTjIb8pBRtsXAjvjaaNkQ86hV4XYO0y9rb49jmb
 JG25Lx+EULXBiOrPhNSZo1VlqgdH1pERFSUMM1qIYtZJLk+M63Qm2yNV+k+LwKwf6PS8
 szF8XEVejRLNzdIgbheajYZVo8E3f19lIO3oVkMVf3u6wtDN/LQuD5GzImJYYEdEmsF7
 tnEgmjW6vhM/cII17+oApkWwXYVvRBvWpsyXFUCfZBzzwiM5mSFqtNHpQ2ut+gCGvNwH 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34dbg5pe0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 13:04:18 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09QH22pP010286;
        Mon, 26 Oct 2020 13:04:17 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34dbg5pdyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 13:04:17 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09QH2DDP009673;
        Mon, 26 Oct 2020 17:04:17 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 34cbw8wg6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 17:04:17 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09QH47hd47972702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 17:04:07 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69396136053;
        Mon, 26 Oct 2020 17:04:15 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 463EF13605E;
        Mon, 26 Oct 2020 17:04:14 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.190.62])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 17:04:14 +0000 (GMT)
Subject: Re: [PATCH v11 08/14] s390/vfio-ap: hot plug/unplug queues on
 bind/unbind of queue device
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com
References: <20201022171209.19494-9-akrowiak@linux.ibm.com>
 <202010230422.zcNkhr2n-lkp@intel.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <6f8c339e-3d7e-c8c5-cda3-782ba5e68219@linux.ibm.com>
Date:   Mon, 26 Oct 2020 13:04:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202010230422.zcNkhr2n-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_08:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/22/20 4:30 PM, kernel test robot wrote:
> Hi Tony,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on s390/features]
> [also build test WARNING on linus/master kvms390/next linux/master v5.9 next-20201022]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Tony-Krowiak/s390-vfio-ap-dynamic-configuration-support/20201023-011543
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
> config: s390-allyesconfig (attached as .config)
> compiler: s390-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/0day-ci/linux/commit/aea9ab29b77facc3bb09415ebe464fd6a22ec22e
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Tony-Krowiak/s390-vfio-ap-dynamic-configuration-support/20201023-011543
>          git checkout aea9ab29b77facc3bb09415ebe464fd6a22ec22e
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=s390
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>     drivers/s390/crypto/vfio_ap_ops.c:1370:5: warning: no previous prototype for 'vfio_ap_mdev_reset_queue' [-Wmissing-prototypes]
>      1370 | int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>           |     ^~~~~~~~~~~~~~~~~~~~~~~~

My mistake, need to be a static function.

>>> drivers/s390/crypto/vfio_ap_ops.c:1617:6: warning: no previous prototype for 'vfio_ap_mdev_hot_unplug_queue' [-Wmissing-prototypes]
>      1617 | void vfio_ap_mdev_hot_unplug_queue(struct vfio_ap_queue *q)
>           |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ditto here, but this was reported for patch 01/14 and will be fixed there.

>
> vim +/vfio_ap_mdev_hot_unplug_queue +1617 drivers/s390/crypto/vfio_ap_ops.c
>
>    1616	
>> 1617	void vfio_ap_mdev_hot_unplug_queue(struct vfio_ap_queue *q)
>    1618	{
>    1619		unsigned long apid = AP_QID_CARD(q->apqn);
>    1620	
>    1621		if ((q->matrix_mdev == NULL) || !vfio_ap_mdev_has_crycb(q->matrix_mdev))
>    1622			return;
>    1623	
>    1624		/*
>    1625		 * If the APID is assigned to the guest, then let's
>    1626		 * go ahead and unplug the adapter since the
>    1627		 * architecture does not provide a means to unplug
>    1628		 * an individual queue.
>    1629		 */
>    1630		if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm)) {
>    1631			clear_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm);
>    1632	
>    1633			if (bitmap_empty(q->matrix_mdev->shadow_apcb.apm, AP_DEVICES))
>    1634				bitmap_clear(q->matrix_mdev->shadow_apcb.aqm, 0,
>    1635					     AP_DOMAINS);
>    1636	
>    1637			vfio_ap_mdev_commit_shadow_apcb(q->matrix_mdev);
>    1638		}
>    1639	}
>    1640	
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

