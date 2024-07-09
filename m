Return-Path: <kvm+bounces-21176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2D792B960
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 14:25:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB837281768
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 12:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C175B158D78;
	Tue,  9 Jul 2024 12:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WJPu+V8j"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB690155A25;
	Tue,  9 Jul 2024 12:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720527940; cv=none; b=HSrW15xOT1oUZtGDu262awf0u2ySuJkujfdmy63h9I9VgE9CO90pQrUKZt+SfSiWSk7N9J+lvrWhjjIvH26eCSWMHPshTgCfjApzvovohCzs7+03hX4pBG+vc85BfsgaFsMJL9mZTTQCbpuGp+ad31c367BgpAHRmcJsiiOgwt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720527940; c=relaxed/simple;
	bh=gUKj+NjshzelXaKZ1J+KcA7wp9Ubf12um0LnUEOCHHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iha9+n2HrxfZm1X3uvo6AJDyHDoaNvuTgs+6KCY7wjiZplG+PsEETD/zOqiV9YilWyjNej6XSYe8RYqAfrzFFzk3LtT3jwF2idFRIrsT8Ai+I0sVMkhoQMVmjWRZa7NQndbc0DVm98RqlGBlZBVzOpnywip+GjZkCaAqOEE6Xjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WJPu+V8j; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469CDvi2011166;
	Tue, 9 Jul 2024 12:25:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=C5bcJNbIOQWgGnln63ilWf7JC8l
	xchQCYjIzUrQmc5Y=; b=WJPu+V8josYQs6NsSBKCwB2TWLdDwwIzdoMYBbaTF7T
	tHpaLbooAKOB+aFUsRuELkRLd17JgDEX3/v0RCzzEIVD5gsUlovzpnaEHICYnSmf
	i36dYQeEpvDepMcuItfNtk2oB5E/Ru3035AM5VaDkAkbbPYrDSmUjUVwKqQ004tM
	a2zvA3buEQr01M1WPw1RkRqL7YJuxcEkn8CPrtS7qBw/M6ycg1lNDD9KolPyxaI/
	i2tDLgWBY3bAGbyY/J6gODHP2O5elLRgu561dJLWMG62hKV3nLE0kZ88ErGO+8If
	COiJ2IQAZlJ7kAYoPfTfWNMLbp99QeBBfTlWVGaSpHg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4093x9079p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 12:25:35 +0000 (GMT)
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 469CPZ6o030113;
	Tue, 9 Jul 2024 12:25:35 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4093x9079m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 12:25:35 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 469BgtUV014020;
	Tue, 9 Jul 2024 12:25:34 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 407h8pme0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 12:25:33 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 469CPS3d50921856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Jul 2024 12:25:30 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36BA320043;
	Tue,  9 Jul 2024 12:25:28 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF2C020040;
	Tue,  9 Jul 2024 12:25:27 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  9 Jul 2024 12:25:27 +0000 (GMT)
Date: Tue, 9 Jul 2024 14:25:26 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seiden@linux.ibm.com, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        david@redhat.com
Subject: Re: [PATCH v1 0/2] s390: Two small fixes and improvements
Message-ID: <20240709122526.7263-B-hca@linux.ibm.com>
References: <20240703155900.103783-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703155900.103783-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wsd8-mZpTnnbG9AT6HS-y50vBHOSlmFg
X-Proofpoint-ORIG-GUID: ebFbWw6DuboRLUMCw1eA8k78Ehn7ED5E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-09_02,2024-07-09_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 spamscore=0 mlxlogscore=390 lowpriorityscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407090080

On Wed, Jul 03, 2024 at 05:58:58PM +0200, Claudio Imbrenda wrote:
> The main goal of this small series is to do some clean-up and remove some
> paper cuts (or at least clear the way for papercuts to be removed in the
> future).
> 
> Heiko: this can go through the s390 tree, as agreed.
> 
> Claudio Imbrenda (2):
>   s390/entry: Pass the asce as parameter to sie64a()
>   s390/kvm: Move bitfields for dat tables
> 
>  arch/s390/include/asm/dat-bits.h   | 170 +++++++++++++++++++++++++++++
>  arch/s390/include/asm/kvm_host.h   |   7 +-
>  arch/s390/include/asm/stacktrace.h |   1 +
>  arch/s390/kernel/asm-offsets.c     |   1 +
>  arch/s390/kernel/entry.S           |   8 +-
>  arch/s390/kvm/gaccess.c            | 163 +--------------------------
>  arch/s390/kvm/kvm-s390.c           |   3 +-
>  arch/s390/kvm/vsie.c               |   2 +-
>  8 files changed, 185 insertions(+), 170 deletions(-)
>  create mode 100644 arch/s390/include/asm/dat-bits.h

Applied, thanks!

