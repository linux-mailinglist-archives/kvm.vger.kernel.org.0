Return-Path: <kvm+bounces-35607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14246A12F86
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 01:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 097693A520B
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 00:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8996617C8B;
	Thu, 16 Jan 2025 00:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I4IR8tkE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0554B8BEE;
	Thu, 16 Jan 2025 00:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736986678; cv=none; b=rX1wIbL00OyhJB9tRBEth6Sy0DNciR5MWCG1k2g8qtJYS6oqMIWS30/msVoMQaYsYKS9dinAjRFCJHwC0Zzf/zKyOjTN0aKUsvtQe18v+72mVkTprQsCZMqJw2NoIFEkPATkZa/lhdiS2cKBw/U+pb7vMCmjQYw/5nyHX8Y2b6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736986678; c=relaxed/simple;
	bh=oJ1nymuniDEDyUQCqmXFnJrd75CCZfAon2o4EH5LX38=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RPchTAyZwGABcNIHUYRcW50J5w276TmcqCnoKhprjmy6q/g5XhZxtZti59vBA9PysbVZ3AU6mDvaYRKOWgA4pYQ+rIlDbSiGqcz1JATwaW+FyHs7CKWoBJnPCFJyZRAmlf/6/h75oBrT7aIl2RCbWdgKhnHtfSza0aaz440q8Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I4IR8tkE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FHX4wJ000813;
	Thu, 16 Jan 2025 00:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=CKADGc
	28v4va8ahfu5ciB5QUCv5CjHjmgbq9cDaXjr4=; b=I4IR8tkEqdo/6JiQgpskoM
	4U4fPwY7BcI804Ujr1lrTdIn4tqoqalwoBHyIn5a7Ms9BEjbJg/pHyWNY7S/q1Yb
	tAdfoXtgfn9lqO37D04bjEnu4bIBeFBCtwVVk5uMa0YlGo94csJoL2yQlX2w5rUf
	mVwUJhCWZOZVeJXQBfZPC6zLUsofG1tJakJbjIgv3t/PADTiDskrMesYo/HzHgMl
	1e33artrHqVKJUPiRIRtg8MPtbcjajaZRjfeUm+y3xf++sm3FGHiZFS3Z/bE3DeS
	iolLWsggi7EeXpAsk8e+Yi1UsLjPSvh6pNimVLy729WF/I7nSKkOfeRny7+pj5YQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4465gbw7sk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 00:17:54 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FL6Rgd016976;
	Thu, 16 Jan 2025 00:17:53 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fkb1am-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 00:17:53 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50G0HnAU49152366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 00:17:49 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2014420043;
	Thu, 16 Jan 2025 00:17:49 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7064520040;
	Thu, 16 Jan 2025 00:17:48 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.34.169])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 16 Jan 2025 00:17:48 +0000 (GMT)
Date: Thu, 16 Jan 2025 01:17:46 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Rorie Reyes
 <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hca@linux.ibm.com,
        borntraeger@de.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        jjherne@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
Message-ID: <20250116011746.20cf941c.pasic@linux.ibm.com>
In-Reply-To: <5d6402ce-38bd-4632-927e-2551fdd01dbe@linux.ibm.com>
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
	<20250114150540.64405f27.alex.williamson@redhat.com>
	<5d6402ce-38bd-4632-927e-2551fdd01dbe@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZuQzRs-Mot8nfWElmSTa8QoCEYABMkxX
X-Proofpoint-ORIG-GUID: ZuQzRs-Mot8nfWElmSTa8QoCEYABMkxX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_10,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501150173

On Wed, 15 Jan 2025 14:35:02 -0500
Anthony Krowiak <akrowiak@linux.ibm.com> wrote:

> >> +static int vfio_ap_set_cfg_change_irq(struct ap_matrix_mdev *matrix_mdev, unsigned long arg)
> >> +{
> >> +	s32 fd;
> >> +	void __user *data;
> >> +	unsigned long minsz;
> >> +	struct eventfd_ctx *cfg_chg_trigger;
> >> +
> >> +	minsz = offsetofend(struct vfio_irq_set, count);
> >> +	data = (void __user *)(arg + minsz);
> >> +
> >> +	if (get_user(fd, (s32 __user *)data))
> >> +		return -EFAULT;
> >> +
> >> +	if (fd == -1) {
> >> +		if (matrix_mdev->cfg_chg_trigger)
> >> +			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
> >> +		matrix_mdev->cfg_chg_trigger = NULL;
> >> +	} else if (fd >= 0) {
> >> +		cfg_chg_trigger = eventfd_ctx_fdget(fd);
> >> +		if (IS_ERR(cfg_chg_trigger))
> >> +			return PTR_ERR(cfg_chg_trigger);
> >> +
> >> +		if (matrix_mdev->cfg_chg_trigger)
> >> +			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
> >> +
> >> +		matrix_mdev->cfg_chg_trigger = cfg_chg_trigger;
> >> +	} else {
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	return 0;
> >> +}  
> > How does this guard against a use after free, such as the eventfd being
> > disabled or swapped concurrent to a config change?  Thanks,
> >
> > Alex  
> 
> Hi Alex. I spent a great deal of time today trying to figure out exactly 
> what
> you are asking here; reading about eventfd and digging through code.
> I looked at other places where eventfd is used to set up communication
> of events targetting a vfio device from KVM to userspace (e.g., 
> hw/vfio/ccw.c)
> and do not find anything much different than what is done here. In fact,
> this code looks identical to the code that sets up an eventfd for the
> VFIO_AP_REQ_IRQ_INDEX.
> 
> Maybe you can explain how an eventfd is disabled or swapped, or maybe
> explain how we can guard against its use after free. Thanks.

Maybe I will try! The value of matrix_mdev->cfg_chg_trigger is used in:
* vfio_ap_set_cfg_change_irq() (rw, with matrix_dev->mdevs_lock)
* signal_guest_ap_cfg_changed()(r, takes no locks itself, )
  * called by vfio_ap_mdev_update_guest_apcb() 
    * called at a bunch of places but AFAICT always with
      matrix_dev->mdevs_lock held
  * called by vfio_ap_mdev_unset_kvm() (with matrix_dev->mdevs_lock held
    via get_update_locks_for_kvm())
* vfio_ap_mdev_probe() (w, assigns NULL to it)

If vfio_ap_set_cfg_change_irq() could change/destroy
matrix_mdev->cfg_chg_trigger while another thread of execution
is using it e.g. with signal_guest_ap_cfg_changed() that would be a
possible UAF and thus BAD.

Now AFAICT matrix_mdev->cfg_chg_trigger is protected by
matrix_dev->mdevs_lock on each access except for in vfio_ap_mdev_probe()
which is AFAIK just an initialization in a safe state where we are
guaranteed to have exclusive access.

The eventfd is swapped and disabled in vfio_ap_set_cfg_change_irq() with
userspace supplying a new valid fd or -1 respectively.

Tony does that answer your question to Alex?

Alex, does the above answer your question on what guards against UAF (the
short answer is: matrix_dev->mdevs_lock)?

Regards,
Halil




