Return-Path: <kvm+bounces-58014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ACA6B85533
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C34C07C3914
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 14:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF0E30C34D;
	Thu, 18 Sep 2025 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O0acwUBn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1E21DDE9;
	Thu, 18 Sep 2025 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758206778; cv=none; b=cDMd9VZLMT0enXQ7/DLI4U4Dreo5CzLZQy+jJDaKzVkzB/q+vckayet+WlP6W73ZRBpTX5tHDKfs7DzJC42y5QueJOHZ13HvshVD2GD+ZjoUBP3FN84OUr4nLemDFX6x8bqqxwo+YjU3dP7kuNu0O7+eb38tSpetuv8YDZQjHps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758206778; c=relaxed/simple;
	bh=xe79pSoF9y0bB17+vkfuQpx+knEpBqts0YHwJGy2W9s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gqBA7so/hX/oCExXWx9fj+7cPZITDTnMtctdYnCnPhtIv448P1vbMtew7jcvGaW9NkQBV2ZphS+SQn17BhdD2TMGlNQnTQTjJNzP5aVD7uqSEMzvr3t/IFzt0Aqvyj01zZfkCdEzs1k9xNyOLpHXTNaARso7rw7CNrEj2V8TLaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O0acwUBn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58IDE8SX011481;
	Thu, 18 Sep 2025 14:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OmArRh
	ClilBwFaEQygfNvpGmfBd776L04dQ3MR/AJ1Y=; b=O0acwUBn+pFjROW9e6gU3q
	InED+aoMo4QKAkGQSCSUmB84PDVj4jU/IxQQDUYcKu9x7yLxeX8vjCY3aXiJhT/N
	q09I6x75X9g0J3STyumTJqidnwrPjBwNyWtOkt8XcbVzj9KuFw8BiqcovqOhqHSh
	of40BZoT06WIUFROFbnUe6v5Dtvh7dLfpfckkpd7AB8SS0BzdQy+PZKut0/J5qzP
	M6quv+mtJRFGIvariQtrg2CSEP1pInmFU4BH1+ETL7zmMsTgPlSrjloUshBCn9i5
	jQ0fx9yEXTBWm+hJPkI3PC2wGzZ3qO3uQM5x4OPvSLCItYfQWE5GT7lV5LTWfzQw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4njfqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 14:46:14 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58ID8a0N029468;
	Thu, 18 Sep 2025 14:46:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kb179sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 14:46:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58IEk9n431654436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 14:46:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A8212004B;
	Thu, 18 Sep 2025 14:46:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 325B920043;
	Thu, 18 Sep 2025 14:46:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Sep 2025 14:46:09 +0000 (GMT)
Date: Thu, 18 Sep 2025 16:46:06 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        svens@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 05/20] KVM: s390: Add helper functions for fault
 handling
Message-ID: <20250918164606.6617b516@p-imbrenda>
In-Reply-To: <a4998d82-223f-4894-888d-bf97ef8c78d0-agordeev@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-6-imbrenda@linux.ibm.com>
	<a4998d82-223f-4894-888d-bf97ef8c78d0-agordeev@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68cc1b36 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=JjYjCPlhS_3ndGKMAXYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: u5Pp93egEHxSFYrnwFDPT1yjD7460Hvz
X-Proofpoint-ORIG-GUID: u5Pp93egEHxSFYrnwFDPT1yjD7460Hvz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX4Ea3hYiEq0Tc
 D3XD/2o/uCmctJ7PZMmex7wucMuBR86XEezC3xsznpkY2tiwiPD7hObytcovrgNiE0fUGHEttoV
 LdnkNryIf7mSYAc6KoTvkUBcaWduB+DHtml6FFgoADlgCA8mUS0S3AvItQG6pr3Hx6t4EXOqei7
 vto1pl33z8eJmLZKfWdnzpXeWy3DX7K0kxh3Z706egQz0EsTxBjNkryE5oFcjCCxnS9ZnnhpPlG
 FYiN95j+wm0RIkyrkhADMznNucBy+lI6LXpP8QhsVehdgSLPmcuoAaVq5LGHPdU1zIqhSvDKDyE
 MKc8j/ftkHJYpYxq9dRfxH5p6ZGOzj+OOL3LdZ0rEQbUWxn6iKBZGe9+6Djzyl2lg6qqtudxCmk
 h4q5VWpG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Thu, 18 Sep 2025 16:19:07 +0200
Alexander Gordeev <agordeev@linux.ibm.com> wrote:

> On Wed, Sep 10, 2025 at 08:07:31PM +0200, Claudio Imbrenda wrote:
> > +static inline int __kvm_s390_faultin_read_gpa(struct kvm *kvm, struct guest_fault *f, gpa_t gaddr,
> > +					      unsigned long *val)
> > +{
> > +	phys_addr_t phys_addr;
> > +	int rc;
> > +
> > +	rc = __kvm_s390_faultin_gfn(kvm, f, gpa_to_gfn(gaddr), false);
> > +	if (!rc) {
> > +		phys_addr = PFN_PHYS(f->pfn) | offset_in_page(gaddr);  
> 
>                             pfn_to_phys() is more consistent with the phys_to_virt() below ;)
> 
> > +		*val = *(unsigned long *)phys_to_virt(phys_addr);
> > +	}
> > +	return rc;
> > +}
> > +
> >  #endif /* __KVM_S390_GACCESS_H */  
> ...
> > +static inline void release_faultin_multiple(struct kvm *kvm, struct guest_fault *guest_faults,
> > +					    int n, bool ignore)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < n; i++) {
> > +		kvm_release_faultin_page(kvm, guest_faults[i].page, ignore,
> > +					 guest_faults[i].write_attempt);
> > +		guest_faults[i].page = NULL;
> > +	}
> > +}
> > +
> > +static inline bool __kvm_s390_multiple_faults_need_retry(struct kvm *kvm, unsigned long seq,
> > +							 struct guest_fault *guest_faults, int n,
> > +							 bool unsafe)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < n; i++) {
> > +		if (!guest_faults[i].valid)
> > +			continue;
> > +		if ((unsafe && mmu_invalidate_retry_gfn_unsafe(kvm, seq, guest_faults[i].gfn)) ||
> > +		    (!unsafe && mmu_invalidate_retry_gfn(kvm, seq, guest_faults[i].gfn))) {
> > +			release_faultin_multiple(kvm, guest_faults, n, true);  
> 
> 
> Calling release_faultin_multiple() on the whole range, before all gfns invalidated?

nothing is getting invalidated here, only a check whether the gfns
(may) already been invalidated. in which case we give up and release
the whole range

kvm_release_faultin_page() will return and do nothing if the struct
page * is NULL

I guess the name of the function in common code is misleading, I will
add some comments to explain what's going on here

> Tolerate invalidation of entries that are (!guest_faults[i].valid)? But then why the
> continue above?
> 
> This function is a mistery to me, but that is - I am sure - due to my KVM ignorance...
> 
> > +			return true;
> > +		}
> > +	}
> > +	return false;
> > +}
> > +
> > +static inline int __kvm_s390_faultin_gfn_range(struct kvm *kvm, struct guest_fault *guest_faults,
> > +					       gfn_t start, int n_pages, bool write_attempt)
> > +{
> > +	int i, rc = 0;
> > +
> > +	for (i = 0; !rc && i < n_pages; i++)  
> 
> Unless n_pages could ever be zero, the below reads better.
> 
> > +		rc = __kvm_s390_faultin_gfn(kvm, guest_faults + i, start + i, write_attempt);  
> 
> 		if (rc)
> 			break;

yeah I guess it's more readable that way

> 
> > +	return rc;
> > +}  
> ...
> 
> Thanks!


