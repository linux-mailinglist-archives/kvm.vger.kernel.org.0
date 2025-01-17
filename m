Return-Path: <kvm+bounces-35828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4734A15474
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:34:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F24BB162ECE
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E26719CCFA;
	Fri, 17 Jan 2025 16:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NVCBJnJo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51339195980;
	Fri, 17 Jan 2025 16:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131688; cv=none; b=FYtSU6CN1roGZVe+gKi9pUEZDClf9rX4K8wfjUrFN7+fPpWyiTMftnFxH6U+QZik4O6YKkDWuejCbPcXDeO1IxF3kmMMhHaghnRjOZJoYxcKpsXEMMFmmGspcH4KCWhDYqROeRE+ULrib26sJBvRN9qbc1bj3rZBiqxdiUYZ4HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131688; c=relaxed/simple;
	bh=hjTybMnPvhzT7BIED7jvkshpvSrLjI90aEbfMUNCUKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rgp9KHB0T4NQC97s4591QEFH2ySnAqFfHk5k1uHN3q7jInC/NmAI1LcIfGZE7p9yXrydEIBllVak+YEW8XrEUoEhX6qc+AmpX3jvJKtRimwSIryOr+Svax+O1C/1eZb+4m6I4MaELh9yZ87WQ68Y9m5knIFZA/8HJ44h1MpVjA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NVCBJnJo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HBt5vO010691;
	Fri, 17 Jan 2025 16:34:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=bAFnq3X9qi9pspiIgoJaU9knaVCMs8
	tzzlJ4XBU+V5M=; b=NVCBJnJoKl5l+26+QSH0GdsVuGfU5i37kQXSmaRzGPh9Wg
	dq3fE75gquyyCWgd1nPBAJosMz3Qqf3APgm4pUsk3qt9nAxXEIFq3zZqd88xBk19
	VjkoHlmb3zxEJP8w9Y3KjE4emLG9gR5DA+FEZesQTZCl66e3haW+Tjc1Szqag1lj
	R3tjPXCoQOUsk1tc3eJRB5Os2Sibwe8GH2/NMJEtU5XRsaswrXpb2u60E4RKvSG5
	lUj4VAzbq8qjMZxlutFa6DVdX2uR7TjyX69fr6mj6TkUM5bJNmxKSjyCP+LxaWK+
	7ymcQU8KgOO5DLj7cOnscwd7K0TT9y5dZY21/evg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447c8jc1mv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:34:43 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HGVq2Y002039;
	Fri, 17 Jan 2025 16:34:42 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447c8jc1ms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:34:42 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HDiKwH004543;
	Fri, 17 Jan 2025 16:34:41 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4442yt3x0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:34:41 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HGYcCW57082288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 16:34:38 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31C4C2004B;
	Fri, 17 Jan 2025 16:34:38 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7782720040;
	Fri, 17 Jan 2025 16:34:37 +0000 (GMT)
Received: from osiris (unknown [9.171.89.28])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 17 Jan 2025 16:34:37 +0000 (GMT)
Date: Fri, 17 Jan 2025 17:34:36 +0100
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, schlameuss@linux.ibm.com, david@redhat.com,
        willy@infradead.org, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seanjc@google.com
Subject: Re: [PATCH v2 15/15] KVM: s390: remove the last user of page->index
Message-ID: <20250117163436.79512-B-seiden@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
 <20250116113355.32184-16-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116113355.32184-16-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CED2Ca-002Pf86TIyI1zYjbkjRc3oEGo
X-Proofpoint-ORIG-GUID: oPm8V5MXKdOdxWA0G_SteeVunTqUGo6V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=863 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170130

On Thu, Jan 16, 2025 at 12:33:55PM +0100, Claudio Imbrenda wrote:
> Shadow page tables use page->index to keep the g2 address of the guest
> page table being shadowed.
> 
> Instead of keeping the information in page->index, split the address
> and smear it over the 16-bit softbits areas of 4 PGSTEs.
> 
> This removes the last s390 user of page->index.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

