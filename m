Return-Path: <kvm+bounces-53983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36F8AB1B32D
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D80313AAFD7
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 12:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0814F26FD9D;
	Tue,  5 Aug 2025 12:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m36KnNQk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48EF1DFDE;
	Tue,  5 Aug 2025 12:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754396190; cv=none; b=RDZ9xkAXxp3tJc/x+jTRxN/aa4FJMWwDYE0CoA5TQ7DOWH8j/CwPNUetqpn2K1Dk7D6INzhWVj1xUZqhEDPa+bpDIdB9683yCp0KDZAs5HkBJRkWDlELYQmHs242XMd53O1O2LsPDWgp3Q4yur/Bmewg6hoQ7IVeUSrB9Ua3oAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754396190; c=relaxed/simple;
	bh=KFrpmjqJcSzak1HC9W2MECHBSmh0TpqG0WwlqJ/kEmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LghET0JPS98yP26EgqZBbPbfVAQP8YdnD2hBgGWRy6MSEMhGLxBAtz0hlnQlGI6nO/mwgDu6ZG0q8lrHrf55MdVBDiflBSYCh95+c04o8G91dKc2g8RzQsUHuUsueCRMWBnvqn40gc1hVfSNqzPzQoIuaR9mUwhAR1ZWtEFdL48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m36KnNQk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5754uWSP001514;
	Tue, 5 Aug 2025 12:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Y51xMbqWTj2ncKK76hliRTwgibDSl9
	9x17Gk7Vdc1Zg=; b=m36KnNQkh1ZjOl2toGsQOGfLxbYbhx4XUdTitD0HtZMB4V
	KYDBEPv21MSYDtCg4lMNVkz1qEhsentckRgaezp09FUtUQ6d/NVRQe+K4O6ffQK9
	bo7A3yCBsmMpO4IDF6ZUj2mRgeyLm0z+ScXoJ0kmEpaIaery70UMgdDiHJ3rd3Fa
	du0gatdaP4vSCCicJt3glRV5Ppou2dnEatAznnPW5rOyDZq6tikjA9Se4Qx8fbtI
	rouaekhEiAza1Vw9Jlas2sN8rsHhhG4k9vf6jK7liFhSRvsgWb0XuX/0rex1Wxeq
	7t8FDWUeLWNs8jxRBicmYS84teKGT6MWqv+t1u3w==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bbbq1tk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 12:16:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5759ekXO001936;
	Tue, 5 Aug 2025 12:16:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 489y7kt50m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 12:16:25 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575CGLLG52691230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 12:16:21 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5B1620040;
	Tue,  5 Aug 2025 12:16:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92C4920043;
	Tue,  5 Aug 2025 12:16:21 +0000 (GMT)
Received: from osiris (unknown [9.155.199.163])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  5 Aug 2025 12:16:21 +0000 (GMT)
Date: Tue, 5 Aug 2025 14:16:20 +0200
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, mhartmay@linux.ibm.com, borntraeger@de.ibm.com
Subject: Re: [PATCH v1 1/2] KVM: s390: Fix incorrect usage of
 mmu_notifier_register()
Message-ID: <20250805121620.40333-A-seiden@linux.ibm.com>
References: <20250805111446.40937-1-imbrenda@linux.ibm.com>
 <20250805111446.40937-2-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805111446.40937-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WMQjuGt9IewnMUVoGm2uYs9iMyWuKIB5
X-Authority-Analysis: v=2.4 cv=M65NKzws c=1 sm=1 tr=0 ts=6891f61a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=K31ow5K9QUr3fs6wkioA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: WMQjuGt9IewnMUVoGm2uYs9iMyWuKIB5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA4NiBTYWx0ZWRfX98l0a9BTBrvt
 G6+ZQ+ZA9iKFK+ixC4IN1UycxlhCq3vLHvRvpqFO9HdEoDFTjCbdJBwcNR87dAZ0C02di6hQKcO
 5e/wicD6JvW0q/+WzPz9MmbyZhK/TEzTjkIXUh8vDHyFJT+KF1dHJD5jsjDMyrEnFlFHoX7r6O/
 E4d9fw10Mh0SAqjhmGpbjwf+CT55tlSEod0G8Cgrzr11j3KCf4Vp1hPv4BVBNPEwcEbD/iYSoum
 7B1JLgg1BUc9iWToNVptM/VPuh7EGHlATlj7Xer6Tgh3AyaAK07murJkpaDEdcFN4yK7ZvRmnv8
 RW3CScoADwC7hNpl80ud9cjaC+yQcAWiQFosVonuCXNe0Hk1RiYllzEEnewHGM0izJEDu40ozVs
 fUM/BA7/8hUQNAMlXQlt2O49uBDPbXja1djvmPjhp0XGFsLR6i42acrZ5L1+RzZqSZMsMtL0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 mlxscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=882 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508050086

On Tue, Aug 05, 2025 at 01:14:45PM +0200, Claudio Imbrenda wrote:
> If mmu_notifier_register() fails, for example because a signal was
> pending, the mmu_notifier will not be registered. But when the VM gets
> destroyed, it will get unregistered anyway and that will cause one
> extra mmdrop(), which will eventually cause the mm of the process to
> be freed too early, and cause a use-after free.
> 
> This bug happens rarely, and only when secure guests are involved.
> 
> The solution is to check the return value of mmu_notifier_register()
> and return it to the caller (ultimately it will be propagated all the
> way to userspace). In case of -EINTR, userspace will try again.
> 
> Fixes: ca2fd0609b5d ("KVM: s390: pv: add mmu_notifier")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>


