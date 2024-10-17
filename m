Return-Path: <kvm+bounces-29080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6AC89A2520
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 16:34:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7351A1F273BF
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 14:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2A01DF26C;
	Thu, 17 Oct 2024 14:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oPVXLRa4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DA61DE4EA;
	Thu, 17 Oct 2024 14:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729175545; cv=none; b=GFuPepQ0zsEXJIX18HkDG1e5t0EO6NsaFFiREqr0T30uvsKmx1d5aJPMiJ7ZmobNuV49qO4xg4mi+duSYmhXgyQi1cFFeT2ExHtQNQ7RmqHcjS9uVaETLuj88pVyoU5ieoRh1R2uFpseRk+qSDyOW6RgGD5/Nc1AiBXbMVcEx34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729175545; c=relaxed/simple;
	bh=lqwk6LYhIvZ4BuQ+y9qMS+/LMg+fUflKiZ7c5mJ07yM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBdnFC4xJtv6PPFYZKLPN0eJQ2LqjvQcqijCBiStdFalveLFtf6j8H744eWG14bFSbIJmu6VlJ84Dg6pmGie7ks6r3+99Q8GIlpQdX075NCqxAhiHLiUTwdWfAGs0dPxJ46HYeda2PkUJyq4HBi74MmFeEV2wE849WD2nOf140Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oPVXLRa4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49HBnpDp030939;
	Thu, 17 Oct 2024 14:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=x9M7OqCmvYwJLYp7viWiXrPFfxDnW3
	xZHfW7zLFJR0w=; b=oPVXLRa46MOc6Sf+5LBNZDM0qkdDCDe2W+Ef2UqLTdqR1R
	mt1HSka4pBPv67fk3O7RPoDXwiupI6N4Ex7naatzPHyjB+GL/9aW6uBfHEug5GvN
	ZH6RAyI6rrA7u5ESXRlf5vwelKAC/D+mw4kYd5X5Yzzvf10eDW5zEUuFDHSbpG/0
	a59f9iyZn1Xq8L0f851CeK/LHvCRORqZPnr2OMo9Ap6sweb9Ghig8N8TQItzoVsO
	47ssd8S4GR87Rgt0oubL3bfNteAlYdBl9EUCY1kORvH1DxLHAQRSvu3xBOuppg38
	V1taPJrS9eJx1nwkM6b1f4OjDKAzMk1hgqWA1meg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42asbd3a3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Oct 2024 14:32:16 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49HERF9H018368;
	Thu, 17 Oct 2024 14:32:15 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42asbd3a3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Oct 2024 14:32:15 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49HDr3Bj005377;
	Thu, 17 Oct 2024 14:32:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4285njf5dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Oct 2024 14:32:14 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49HEWAhP48628210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 14:32:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A8B7B20049;
	Thu, 17 Oct 2024 14:32:10 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C59BF20040;
	Thu, 17 Oct 2024 14:32:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 17 Oct 2024 14:32:09 +0000 (GMT)
Date: Thu, 17 Oct 2024 16:32:08 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v2 4/7] s390/physmem_info: query diag500(STORAGE LIMIT)
 to support QEMU/KVM memory devices
Message-ID: <ZxEf6NOs1hDFZd1E@tuxmaker.boeblingen.de.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-5-david@redhat.com>
 <ZxC+mr5PcGv4fBcY@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <04d5169f-3289-4aac-abca-90b20ad4e9c9@redhat.com>
 <ZxDetq73hETPMjln@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <1c7ef09e-9ba2-488e-a249-4db3f65e077d@redhat.com>
 <45de474c-9af3-4d71-959f-6dbc223b432b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45de474c-9af3-4d71-959f-6dbc223b432b@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cHhgOMeaziZtns-QiP2HmAZDEba7eikD
X-Proofpoint-GUID: 2uY6DRZW2AitsKuflnkKSDREZnezK4Ep
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 mlxlogscore=512
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410170100

On Thu, Oct 17, 2024 at 02:07:12PM +0200, David Hildenbrand wrote:
> On 17.10.24 12:00, David Hildenbrand wrote:
> > Well, DIAGNOSE 260 is z/VM only and DIAG 500 is KVM only. So there are
> > currently not really any other reasonable ways besides SCLP.
> 
> Correction: Staring at the code again, in detect_physmem_online_ranges()
> we will indeed try:
> 
> a) sclp_early_read_storage_info()
> b) diag260()

So why care to call diag260() in case of DIAGNOSE 500? What about the below?

void detect_physmem_online_ranges(unsigned long max_physmem_end)
{
	if (!sclp_early_read_storage_info()) {
		physmem_info.info_source = MEM_DETECT_SCLP_STOR_INFO;
	} else if (physmem_info.info_source == MEM_DETECT_DIAG500_STOR_LIMIT) {
		unsigned long online_end;

		if (!sclp_early_get_memsize(&online_end)) {
			physmem_info.info_source = MEM_DETECT_SCLP_READ_INFO;
			add_physmem_online_range(0, online_end);
		}
	} else if (!diag260()) {
		physmem_info.info_source = MEM_DETECT_DIAG260;
	} else if (max_physmem_end) {
		add_physmem_online_range(0, max_physmem_end);
	}
}

> But if neither works, we cannot blindly add all that memory, something is
> messed up. So we'll fallback to
> 
> c) sclp_early_get_memsize()
> 
> But if none of that works, something is seriously wrong.

Ok, thanks for the clarification.

