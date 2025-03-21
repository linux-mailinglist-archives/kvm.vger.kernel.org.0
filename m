Return-Path: <kvm+bounces-41644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF786A6B39F
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 05:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 468DF48812D
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 04:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2651E7C38;
	Fri, 21 Mar 2025 04:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lbitNaSE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644612A1CF
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 04:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742530343; cv=none; b=BNl5r9wdJt0X/HgaY5V/7JbRmNIxKrTZvxz4igk8XyyBl0/Vgw45N7+HXZsUuS4H97uqtUBGP5FU+iVMNp2+T3XHJmWWuwFBZzJ75+c/eaHaMhx2/jtnRxIsmJs8xtRjMXSttdi9yG/293jYaaxYW6LYvpIse8kVsV2zuO8Iq3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742530343; c=relaxed/simple;
	bh=Ua/uPF3SAUNipuK1qwAgitnusRoFar6Z8CGf052VV10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JgIIV3cb7d7+oqdHKZqQs8EevCk8eLNRZf2CDCz1vYUzt3QagmrICobii7HQfPp2LQ5jaScNnMx/65TxYIKe/BoRJt2pij5OhiZha6hoE3xtc0luDnmU53jaksOl9ywP48Z6bKtwBG0t3LUSKBMat4h2p/5vXyY7pxUkftP6l6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lbitNaSE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KHBZKs023432;
	Fri, 21 Mar 2025 04:12:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=e+fdk+
	k6WrHON5G6o36FT1dQELnA6dhapnPxnHohaIU=; b=lbitNaSEC50qSLk0Yw9eBi
	QWtBAc5hP9jNQ+vEECrkciEa+/dNl/ki8+mIuIy5vcxKGEOL1NLsB0JCnh5YPRWb
	n86Ep0MtYArKi45KJlRmxAW+b8HhwZG9Q3sj4e2RcHtfUk6l0afDchaGAZPeGuL+
	3DeulMc515Ju3i7+nDTXqnwSswOvXVk8CrA6NmyCxny8f7nMtUBNVX4o/b3oq6IR
	ROU6GGNFrLeYCq6KHWvKTRI3czTGGrLyASv+TQoRhZzOF7CLIbW+23GiOJj+hBd6
	Zmmz3kMJQil7BXVLSr0lbwPx7JqQpooo856ORZERpAX+PED+CrYD4nfskbvgtP5A
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45gq6w2gh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Mar 2025 04:12:15 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52L19kGE031961;
	Fri, 21 Mar 2025 04:12:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45dkvtuvwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Mar 2025 04:12:14 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52L4CDnH23396722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 04:12:13 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3530F2004D;
	Fri, 21 Mar 2025 04:12:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6084C20040;
	Fri, 21 Mar 2025 04:12:12 +0000 (GMT)
Received: from [9.124.211.232] (unknown [9.124.211.232])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Mar 2025 04:12:12 +0000 (GMT)
Message-ID: <0504d23e-2053-4122-a747-54cd5f571f70@linux.ibm.com>
Date: Fri, 21 Mar 2025 09:42:11 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/pci: Virtualize zero INTx PIN if no pdev->irq
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, kevin.tian@intel.com
References: <20250320194145.2816379-1-alex.williamson@redhat.com>
Content-Language: en-US
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20250320194145.2816379-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fQZoW4zMd6YcwoNbF7kkjuEH5e6Cookn
X-Proofpoint-ORIG-GUID: fQZoW4zMd6YcwoNbF7kkjuEH5e6Cookn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-21_01,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0 mlxlogscore=852
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503210026

On 3/21/25 1:11 AM, Alex Williamson wrote:
> Typically pdev->irq is consistent with whether the device itself
> supports INTx, where device support is reported via the PIN register.
> Therefore the PIN register is often already zero if pdev->irq is zero.
>
> Recently virtualization of the PIN register was expanded to include
> the case where the device supports INTx but the platform does not
> route the interrupt.  This is reported by a value of IRQ_NOTCONNECTED
> on some architectures.  Other architectures just report zero for
> pdev->irq.
>
> We already disallow INTx setup if pdev->irq is zero, therefore add
> this to the PIN register virtualization criteria so that a consistent
> view is provided to userspace through virtualized config space and
> ioctls.
>
> Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Link: https://lore.kernel.org/all/174231895238.2295.12586708771396482526.stgit@linux.ibm.com/
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Thank you Alex!


Tested-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>

Regards,

Shivaprasad


