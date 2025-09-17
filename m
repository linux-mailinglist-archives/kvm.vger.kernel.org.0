Return-Path: <kvm+bounces-57844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DA0B7D549
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:23:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7245621475
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 12:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EAD3233ED;
	Wed, 17 Sep 2025 12:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oVZZFs1n"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319773233FE;
	Wed, 17 Sep 2025 12:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758111514; cv=none; b=J0qvUfj12lbOf3Nu+G7m5H0VDJdzzLzZltR1/CJLUIMFhNqIIqYsKxDttWC7kYYoQqNpF78vxMuAJl4eZ1IVyNK16a1QWGnCvPSYsd0d2P21zja4ZUK9MJgaescrDjv7oxeY8FiWR0BGyL3JaARMmdLRgtDPFK2Jj4Sy/bC3YQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758111514; c=relaxed/simple;
	bh=YrutmhnjG9GfwSCBgEoc9cXTRufdrh/YcXbtCrUY2TE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xz2wy8Z6/qf7hv0J7W9dVQlhJgCfMZI+o4Gd2WG/5uceUVnRZjVefYj+oUwinhTMJnWk4IB/X1TuVx0YfyWB37+sKXU6OGsbYvJkKrLTj/1X4XwFK/1UEbpSLcM9LGaM9y/wTlrNiCTz9mnhfSYKpyO2QYTYef2OjoCo9bF57Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oVZZFs1n; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HCFggi009402;
	Wed, 17 Sep 2025 12:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=NGuk1haoaF5K5uv2aKq8PoobuYsLgh
	zJpT/MPpqvalg=; b=oVZZFs1nfI6tOLoZu4NhM73PH/szk34rtBGLTDdv9VJ8Al
	mzcmP2agtfG+VXnly9JlmqxwW5eFxDhGTBrazaUpe0KQbzCd0ouZ4k+x1OFc7oOk
	VxByPRvSAZqYm9J9UgGrqRyS+QVjxcFMX0ZMU0H6QHmcYdky7rNg4vlAeUMk8FF4
	vNShaZsRQNb+HzJsEMxWfgFAD7ZDJ33dvv+C80bdtw8B7DKEcfAQmOmf5cKLmUXD
	rnGH/BrPY1hUvjhOAbVu4yTmee5VUj2eVnthZIR0Z+tCGdavlMFelsTmVoDptUpX
	IGXGD/Bx0D8A+iGPoU8P3w8TTwrEvyz7INtFQ0gg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4p3jvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 12:18:29 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HBpKka009395;
	Wed, 17 Sep 2025 12:18:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn3gtkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 12:18:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HCIOCA31588786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 12:18:24 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63CAA2004B;
	Wed, 17 Sep 2025 12:18:24 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AA8120040;
	Wed, 17 Sep 2025 12:18:24 +0000 (GMT)
Received: from osiris (unknown [9.152.212.133])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Sep 2025 12:18:24 +0000 (GMT)
Date: Wed, 17 Sep 2025 14:18:22 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 07/20] KVM: s390: KVM-specific bitfields and helper
 functions
Message-ID: <20250917121822.7515B42-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-8-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910180746.125776-8-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX75dE7ZhwmOYx
 K2QICzOjPZvUQrIjS1eAIs85+3QAvm90UrAhc0lLEKqK+T4wD8WHsC93DM2GmIGIonZNyMTEd4s
 Pof9EP0pNk3gkVRf6GQG72MTCdlsfp8Ml9W3Qwk4boJBxpXgivaQ+t5p+PtUHfe2DtkgfKVL8Td
 6ivcEgrwKuL+VE7ibItgNKdmGVVHXb8c/6Be5F3YiM3m55Gc7re69DD6bpk7sV/SpMPNYmwi2Fa
 MIM4VqpDml/Xq6u2zcb80xBDL3ordaBXkRNi9CKh+ll8dVuvsRGOUveZ882PszTpBUzwgSHeETI
 AFHW80t5CAY0AK0KNfK9jtuM96S5dXNT23MslWdpZQIFQAtNAu+tXjbzt9kVKihDyskY6VdVMjs
 dFI68Hd8
X-Proofpoint-ORIG-GUID: CeBt0Rb9TbrufX28ZYg9YUVObbfZKYMQ
X-Proofpoint-GUID: CeBt0Rb9TbrufX28ZYg9YUVObbfZKYMQ
X-Authority-Analysis: v=2.4 cv=cNzgskeN c=1 sm=1 tr=0 ts=68caa715 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=p2wkX-u-leKPivS2yWwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, Sep 10, 2025 at 08:07:33PM +0200, Claudio Imbrenda wrote:
> Add KVM-s390 specific bitfields and helper functions to manipulate DAT
> tables.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/dat.h | 693 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 693 insertions(+)
>  create mode 100644 arch/s390/kvm/dat.h

...

> +static inline struct page_table *dat_alloc_empty_pt(void)
> +{
> +	return dat_alloc_pt(_PAGE_INVALID, 0);
> +}

This is calling a function which get's introduced with a later
patch. It is not harmful, since all of this code is still unused, but
still odd.

