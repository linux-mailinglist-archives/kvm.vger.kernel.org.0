Return-Path: <kvm+bounces-57738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D48E5B59D77
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C78AB3B5826
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 651EA370593;
	Tue, 16 Sep 2025 16:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b/DvTfVO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25A52E8B95;
	Tue, 16 Sep 2025 16:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758039735; cv=none; b=kxE+wfQzic7ByLjuP45kBvAcfqHAHvEtqa5B8WNJAs3WlXTyT58rCJyDnwnb95baZoaBZfrZI0FZ/va2O6SAzzNeeWHD49L/ZqXKuO+98VmF5zq1gioXHb4oM/io72vjakzjJ3d2QPI7WdbwjBI6eJT83rkphxwPn/a2ENk0Jys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758039735; c=relaxed/simple;
	bh=yDGIMJxPU7mk6/YSDQf0qrHRUhYgYmP/rbM3eW2UUfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rzu23SbOF5yu236MBthxLIOH1N81uYWA8Wm5LJlAhu8Knqond7FQn2gX/D1e4vo2HHEsi8wK41Cy+rmGtU+hMiymwN6MXCrH8mhzTDrCZNkF3Un/1eJfo2TxLByNVMqT4g/ZAULwlFpzP7a2LhgR9At1zCZd+BAETDpTYBw0e+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=b/DvTfVO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GACZp7017396;
	Tue, 16 Sep 2025 16:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Oo5gLB9MlII3sYdO6rkgLJIoLSEEUz
	xdFC7mJJ15sLs=; b=b/DvTfVOVlOUAixfwZXJkleUOl+HQ/E3NVW5zooTleruQ8
	PQk7GoHXqo0siL8t/hn6jV7HKY/rr5gxHuWukLXf5Q4bGIIEhm4mo9QLAgkzujUQ
	40Saz7h/q3h7hNCAlw2QXPMwE+YDFfxrjwbig5VyzNSTvhKUP3Fv4fLjBkzOP1hg
	jZp4cPsGct0uAQEdNNFbmpOhBDVi4O1HFOQtwxXatZ3qHKhHj81hgNQt4BdaopHw
	E3eHMcejjbXH4qlHNAYRdCG3N7wpsRUQNcmSPIIO/Q2kZaTPL4zOZjzlFLKMV74m
	Xnr3g/QuuMeRUG4D2jk9/+7/4Q/44HDCtA81TQfA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496g538c74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 16:22:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GEppJN018821;
	Tue, 16 Sep 2025 16:22:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 495n5mcm8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 16:22:09 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GGM5cQ51380524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 16:22:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3044520043;
	Tue, 16 Sep 2025 16:22:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A03F720040;
	Tue, 16 Sep 2025 16:22:04 +0000 (GMT)
Received: from osiris (unknown [9.111.88.139])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Sep 2025 16:22:04 +0000 (GMT)
Date: Tue, 16 Sep 2025 18:22:03 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 10/20] KVM: s390: KVM page table management functions:
 walks
Message-ID: <20250916162203.27229F62-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-11-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910180746.125776-11-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Bl3z2DP092mhx7q5RE_NCiNEybc1yvS9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDA4NiBTYWx0ZWRfXznlsa9FdsCOg
 /XILgVgAA4JCIMMYHw/5qmdOMtrkJcEJoqwgvT7D3hj07N5kpT3tvLW/M2t9Qul5f6C7fq70zjj
 HUjJmhIb0eUrJymXyBXiviO3ITFI8Z7jxhXfD0fVe2sUiKRqbmHmegRUY9v+ghLnHt72WfNUCUX
 HKfaJbHXjrZQko/T1y6WboheDD2iSKaMHQtgUgXAzzgj9J+pwJOGL4na/q8NblV6D9H6N5YtnhP
 qBlaus+OwLjdCCmiJhIg93vZL5t7oJ16eLK8/KeDjHqKPIr7p0RmplaROXYTL9W3l4hBlu6nClm
 5WhggiDYVFCPG4aHJGdr57MixqekNt9Qn9RKVskGwXGpZbu3XFGa9LY1PbycsI3wKJ3TrBPedQP
 TQY67PpZ
X-Proofpoint-ORIG-GUID: Bl3z2DP092mhx7q5RE_NCiNEybc1yvS9
X-Authority-Analysis: v=2.4 cv=UJ7dHDfy c=1 sm=1 tr=0 ts=68c98eb1 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=uZTgO3oKufSTSZkPMqYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150086

On Wed, Sep 10, 2025 at 08:07:36PM +0200, Claudio Imbrenda wrote:
> Add page table management functions to be used for KVM guest (gmap)
> page tables.
> 
> This patch adds functions to walk to specific table entries, or to
> perform actions on a range of entries.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/dat.c | 351 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/dat.h |  38 +++++
>  2 files changed, 389 insertions(+)

...

> +int dat_entry_walk(gfn_t gfn, union asce asce, int flags, int walk_level,
> +		   union crste **last, union pte **ptepp)
> +{

...

> +	table = dereference_asce(asce);
> +	if (asce.dt >= ASCE_TYPE_REGION1) {
> +		*last = table->crstes + pgd_index(gfn_to_gpa(gfn));
> +		entry = READ_ONCE(**last);
> +		if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_PGD)))
> +			return -EINVAL;

Since I've seen this all over the place: this looks just wrong to me.

This is mixing some random software definition "LEVEL_PGD" with hardware
bits. A "correct" table type compare would compare with TABLE_TYPE_REGION1
instead. Also using pgd_index() & friends here is semantically wrong.

For normal processes the pgd is always the top page table level (present and
used), and lower levels like p4d may be folded. This is not the case with this
code, where pgd, p4d, etc. seem to have a completely different meaning and are
mapped to specific hardware page table levels / types, where the top levels
(pgd, ...) are optional.

Why is this mixed? To me this looks like the potential source for a _lot_ of
confusion and potential bugs.

