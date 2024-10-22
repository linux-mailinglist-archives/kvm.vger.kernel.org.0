Return-Path: <kvm+bounces-29418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DC29AB127
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 16:45:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7D95284604
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E4B1A0BFD;
	Tue, 22 Oct 2024 14:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aUDEGs4l"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D588042065;
	Tue, 22 Oct 2024 14:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608316; cv=none; b=u37CKxpfLprfdx4jEVp1Rnlulykk5EjsPsfbNRg4xDP0qSZIIFg9KMXYNNEJak8oiHLRH3kUx4t6FnZUOhT82Ntz0VBQ4sM9k6sUq+Tf1BW7FbSKLi0rCZD8hZ21aFlmQhIjeZRUSI99vaxnuVOXIPrvwpgDsBT1/PoYuhQkvqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608316; c=relaxed/simple;
	bh=3rSf6p+Eb338S3jqFz7thCVwdKBWMkoB5j+tB+1HwJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGH63D47iuRnsliTF5CX5ZRK2XmSfMnWU7miIqc5JMimsyZ7m6k0AoZLI6qC2jGWdy+7DfuBysCrxe7s6Axh7bK+3yVLUexqgjngr/p/hI0N6KWlxHYxaCk8MAtqIwdVMhoa5D257EoqxslTtVcWOmHHsHHUXYjG4ZIaXFzVtFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aUDEGs4l; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HIko029688;
	Tue, 22 Oct 2024 14:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=pIsmFpDMFhgpKpzx7/i5ySZCnPjETM
	qgNut5wXDL46U=; b=aUDEGs4lIzBl2L42bzvATNq4ehd8irPjtzukODO2wTiKRL
	qbQrWFu1qwZub/BulXTj2UA6iEdeLF1ODx7tYF0tiRYFWPX3HzCvTF1gAvnJc+3+
	95Hm3+QrSHd0Fg4jg2WSSfRCbY/f6M0bclQfM849+hRVhy4uJSThYyV+wWxzG5Tc
	K65BA/xeVTTlL25xlvqJpS7yrbuQ21EcaXAUS5A6ucuxYZTdIxVrAiaofNerI4jm
	C/5A3WJ6/SAVSeJt9yUwF9L58WX/YZjkXQ5gP7YG/f+dmXcAC9B4ipv1x5atTf76
	EIg3+5aTEWJYlHd3DMRHX3gwvdCCPWGV7+J6Le7w==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5euefs3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 14:45:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49MCjmdD026416;
	Tue, 22 Oct 2024 14:45:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42cq3sbtvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 14:45:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MEj8bS35390078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 14:45:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11F3820043;
	Tue, 22 Oct 2024 14:45:08 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D070F2004D;
	Tue, 22 Oct 2024 14:45:07 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 22 Oct 2024 14:45:07 +0000 (GMT)
Date: Tue, 22 Oct 2024 16:45:06 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [PATCH v4 00/11] s390/kvm: Handle guest-related program
 interrupts in KVM
Message-ID: <20241022144506.13839-B-hca@linux.ibm.com>
References: <20241022120601.167009-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022120601.167009-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -ErL8fIKzmqcf_3B5-B_4LFHoleawTBC
X-Proofpoint-ORIG-GUID: -ErL8fIKzmqcf_3B5-B_4LFHoleawTBC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0
 mlxlogscore=522 mlxscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220093

On Tue, Oct 22, 2024 at 02:05:50PM +0200, Claudio Imbrenda wrote:
> This patchseries moves the handling of host program interrupts that
> happen while a KVM guest is running into KVM itself.
> 
> All program interrupts that happen in the host while a KVM guest is
> running are due to DAT exceptions. It is cleaner and more maintainable
> to have KVM handle those.
> 
> As a side effect, some more cleanups is also possible.
> 
> Moreover, this series serves as a foundation for an upcoming series
> that will further move as much s390 KVM memory managament as possible
> into KVM itself, and away from the rest of the kernel.
...
> Claudio Imbrenda (8):
>   s390/entry: Remove __GMAP_ASCE and use _PIF_GUEST_FAULT again
>   s390/kvm: Remove kvm_arch_fault_in_page()
>   s390/mm/gmap: Refactor gmap_fault() and add support for pfault
>   s390/mm/gmap: Fix __gmap_fault() return code
>   s390/mm/fault: Handle guest-related program interrupts in KVM
>   s390/kvm: Stop using gmap_{en,dis}able()
>   s390/mm/gmap: Remove gmap_{en,dis}able()
>   s390: Remove gmap pointer from lowcore
> 
> Heiko Carstens (3):
>   s390/mm: Simplify get_fault_type()
>   s390/mm: Get rid of fault type switch statements
>   s390/mm: Convert to LOCK_MM_AND_FIND_VMA
> 
>  arch/s390/Kconfig                 |   1 +
>  arch/s390/include/asm/gmap.h      |   3 -
>  arch/s390/include/asm/kvm_host.h  |   5 +-
>  arch/s390/include/asm/lowcore.h   |   3 +-
>  arch/s390/include/asm/processor.h |   5 +-
>  arch/s390/include/asm/ptrace.h    |   2 +
>  arch/s390/kernel/asm-offsets.c    |   3 -
>  arch/s390/kernel/entry.S          |  44 ++-----
>  arch/s390/kernel/traps.c          |  23 +++-
>  arch/s390/kvm/intercept.c         |   4 +-
>  arch/s390/kvm/kvm-s390.c          | 142 +++++++++++++++-------
>  arch/s390/kvm/kvm-s390.h          |   8 +-
>  arch/s390/kvm/vsie.c              |  17 ++-
>  arch/s390/mm/fault.c              | 195 +++++-------------------------
>  arch/s390/mm/gmap.c               | 151 +++++++++++++++--------
>  15 files changed, 281 insertions(+), 325 deletions(-)

Series applied, thanks!

