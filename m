Return-Path: <kvm+bounces-59134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A27BAC660
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:03:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5EAA3BE629
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2062F6171;
	Tue, 30 Sep 2025 10:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s+YO5Euq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961202144C7;
	Tue, 30 Sep 2025 10:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759226613; cv=none; b=AXhr8g8cX8bb+t+86xvvRt+eHDF9yKHF4sn656Kw63TaT1CUzjT36h0KnRe0SH9u6Kn82pCbq65Pgq76450iiMivBo5yqMq0mt4SuX65J9K/fh9uDI/09psnEueC+n2hHbkfvuS6AFaT2y/sjoFiNjc1wv2LARjZMB3by14IJyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759226613; c=relaxed/simple;
	bh=C+uDptFGPX/XX4u4uX2laDXbZLRztM/wuZjt8KMmf5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hCgChOxpDRjsBqbq8TsCb6+qc0+9rdVliLd4ymTMEBlzdor84iVpyrzxdE8Xhya2r3yNbUCzZydEx6Q6PO5j3aPc0GD37gAtMZk/KJMZwRhpn7QPrLVyObRKJJN9Eka6Hm2uYXmg9znTAWHHYBdIWE2c1kzkyXjRChG+7ICi2LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s+YO5Euq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58TLfT63030414;
	Tue, 30 Sep 2025 10:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:sender:subject:to; s=pp1;
	 bh=MMjnW8ZGY5JsHDTDmnnEqn4fKP+OrNKDNH+uh8F2tUM=; b=s+YO5EuqJV6A
	jVerq/WC5ng0P43OgyRV6NWlC2S6jF0BaCIOtkasYLn9mBTyiZOz8h2Xd99A/C13
	n00B0b17MIwkqbShKIauba2S38l7eN7XceUx7lJfwpcLIsv96X4QqT4JI3ZcCW91
	2OijYGI7zPX6Uxy0Y8XeELSW4WKOu8xqyRjFb9eJluc4YSFtR2xHwiWo4WQufyHi
	/x37E2xvQd2Szl503rh6xjoVFO/9/YO2bY6/GKAEXXr4aCyPh9s789c3RPM5/XB0
	jmFyXzYYeffor633ExkuE3sCfqPKbBQIm92qt9P/oX3lQKABoQuAdnkf0bNoydop
	w8jcBTBZOQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e6bhfqka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 10:03:26 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58U7v1Of020064;
	Tue, 30 Sep 2025 10:03:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49et8s2yu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 10:03:25 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58UA3MR840763648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 10:03:22 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F68A20067;
	Tue, 30 Sep 2025 10:03:22 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0ECC920063;
	Tue, 30 Sep 2025 10:03:22 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.180])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 30 Sep 2025 10:03:22 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.98.2)
	(envelope-from <bblock@linux.ibm.com>)
	id 1v3XCb-00000000m9T-3RZ6;
	Tue, 30 Sep 2025 12:03:21 +0200
Date: Tue, 30 Sep 2025 12:03:21 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 02/10] PCI: Add additional checks for flr reset
Message-ID: <20250930100321.GB15786@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-3-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250924171628.826-3-alifm@linux.ibm.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Se/6t/Ru c=1 sm=1 tr=0 ts=68dbaaee cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=8nJEP1OIZ-IA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=2Qdhaze4vaRhrbKc8xAA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAxMCBTYWx0ZWRfXwOnINJ1dUPG6
 rzozq1J9kNxyzuL+TWL+XBQ30Ym8MbuPfLi/2O46LtF76sJW0P8byyLTrrWvxzmYR1MM8ogeG2i
 IshuVSXujzD6+bXhj8ZoMYg1Y34+g1auQwVQEgBBrri+w5AdlJf0UvVOJy2dsAwjOObD7iADVPk
 DJgb+E9dG1p0UncWzCV85a1oosxbcNsBJCMw5AmBUlxP0wCM9Atz4OTMeGQoSYfzsGvzMs4M/lv
 vSMyRVHIMBejKZZeTqDYUNNsMkFmBiBYpmG0kzgS+aUtqil4TC3ttMG165gY3QP/sQ29r8qSb3C
 +Qi5HyyQeeXpOj6W+ZrYPeu/kfixYbsi3ngbyhe6h5B1Ut1HcOIypJclPzq4iTF20LDcUoLzRBl
 ugJ8AjhoHVpJ/MWd07WIOn9gOqbpuw==
X-Proofpoint-GUID: 3QCoety8nuQyFRoJJfZ-pCKRmkH81s2D
X-Proofpoint-ORIG-GUID: 3QCoety8nuQyFRoJJfZ-pCKRmkH81s2D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_01,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1011 phishscore=0 priorityscore=1501 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270010

On Wed, Sep 24, 2025 at 10:16:20AM -0700, Farhan Ali wrote:
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index a3d93d1baee7..327fefc6a1eb 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4576,12 +4576,19 @@ EXPORT_SYMBOL_GPL(pcie_flr);
>   */
>  int pcie_reset_flr(struct pci_dev *dev, bool probe)
>  {
> +	u32 reg;
> +
>  	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
>  		return -ENOTTY;
>  
>  	if (!(dev->devcap & PCI_EXP_DEVCAP_FLR))
>  		return -ENOTTY;
>  
> +	if (pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &reg)) {
> +		pci_warn(dev, "Device unable to do an FLR\n");
> +		return -ENOTTY;
> +	}

Just thinking out loud, not sure whether it make sense, but since you already
read an up-to-date value from the config space, would it make sense to
pull the check above `dev->devcap & PCI_EXP_DEVCAP_FLR` below this read, and
check on the just read `reg`?

Also wondering whether it makes sense to stable-tag this? We've recently seen
"unpleasant" recovery attempts that look like this in the kernel logs:

    [  663.330053] vfio-pci 0007:00:00.1: timed out waiting for pending transaction; performing function level reset anyway
    [  664.730051] vfio-pci 0007:00:00.1: not ready 1023ms after FLR; waiting
    [  665.830023] vfio-pci 0007:00:00.1: not ready 2047ms after FLR; waiting
    [  667.910023] vfio-pci 0007:00:00.1: not ready 4095ms after FLR; waiting
    [  672.070022] vfio-pci 0007:00:00.1: not ready 8191ms after FLR; waiting
    [  680.550025] vfio-pci 0007:00:00.1: not ready 16383ms after FLR; waiting
    [  697.190023] vfio-pci 0007:00:00.1: not ready 32767ms after FLR; waiting
    [  730.470021] vfio-pci 0007:00:00.1: not ready 65535ms after FLR; giving up

The VF here was already dead in the water at that point, so I suspect
`pci_read_config_dword()` might have failed, and so this check would have
failed, and we wouldn't have "wasted" the minute waiting for a FLR that was
never going to happen anyway.


-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294

