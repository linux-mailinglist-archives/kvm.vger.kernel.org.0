Return-Path: <kvm+bounces-36022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92492A16F09
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:10:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3147169889
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 15:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3237D1E570E;
	Mon, 20 Jan 2025 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iMD+A/0H"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B455B1B4F02;
	Mon, 20 Jan 2025 15:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737385838; cv=none; b=Nq0vxXuic2vFkWcfjrrPO0b9Q9rRhjTEWbLpdGbogtZvy+/r9emWbFWhLVgNjLmhk20/O/x0qHO0g6IcLaVmjQKBEyAAvqR4Fs3Wwg1DMfbyWU5R1pFwnsBIaYBzW2u4iDuB/mp1ec6MnGzUuNQWFzQCpdk4s421Dc5XSrXC2OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737385838; c=relaxed/simple;
	bh=y1so/jEzwKU/seIiP0oviKnOIntAuEfwUZWk/5UpRo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a0MyVtltVuRmMTElcLQR6YMhhPTXB1YhzuBJFuHj3weCpgHcpXRoo0UGXshA1padGO7smsir9FPiSoFm0VaZTd4YHK/WWoQx4W9O0+uIPhIZFTZxi1KdM3ob8moYQVFOM4QQxPoTw6oJz+3idNeg1ZoPwYthoKx/HCDUMc9gPcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iMD+A/0H; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50K7Wnsd010695;
	Mon, 20 Jan 2025 15:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UxNByE
	MiyMVWtOS2zo6pFMhBhLh14Lv3K3eCk0sv8g8=; b=iMD+A/0HQ0VjfpWFI6dEyc
	ZWdaQuIoVw6K4nfq4kQMNqV3Ur17efLQildUi1s87L5A2RHFlyf3nhe0LNwWV2UN
	BEUkwDwWeiLGYRm5sZbFHpb3lzA0rbywspuC7l1IWE4ARHZwfd3HXwhGkMTYlbF8
	fK8yNzzplneKpcW/SSTBviUk2VBEqFGkIjWlfHnrKYgy0MEWnrIAdS7kP2qyx157
	PP0ezB3POlCn53vJAv3BtbkpUx+afwZVk1joq438dN5yH0fWb024qvnbsbQWrEv9
	2Oa1C03VqWkWltLIZyL5CNIRw5SNgCSKrPYvqCMWqrBz1ld6q2Bh1GDtGLu8tVrQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 449j6na04k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:10:29 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50KEq3eK028165;
	Mon, 20 Jan 2025 15:10:29 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 449j6na04h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:10:29 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50KF7HXC019252;
	Mon, 20 Jan 2025 15:10:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 448pms71vd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:10:28 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50KFAP3T34341372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jan 2025 15:10:25 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 07AC020043;
	Mon, 20 Jan 2025 15:10:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9D9120040;
	Mon, 20 Jan 2025 15:10:24 +0000 (GMT)
Received: from osiris (unknown [9.155.199.163])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 20 Jan 2025 15:10:24 +0000 (GMT)
Date: Mon, 20 Jan 2025 16:10:18 +0100
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, schlameuss@linux.ibm.com, david@redhat.com,
        willy@infradead.org, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seanjc@google.com
Subject: Re: [PATCH v3 11/15] KVM: s390: stop using lists to keep track of
 used dat tables
Message-ID: <20250120151018.49918-B-seiden@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
 <20250117190938.93793-12-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250117190938.93793-12-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7CuDk4EY-ts_INsG0Wht8zdNAbKmJfXB
X-Proofpoint-ORIG-GUID: 9sIssm25EhBeG-EdOIFdkaATyzlKXvVr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_03,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=807 adultscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200125

On Fri, Jan 17, 2025 at 08:09:34PM +0100, Claudio Imbrenda wrote:
> Until now, every dat table allocated to map a guest was put in a
> linked list. The page->lru field of struct page was used to keep track
> of which pages were being used, and when the gmap is torn down, the
> list was walked and all pages freed.
> 
> This patch gets rid of the usage of page->lru. Page tables are now
> freed by recursively walking the dat table tree.
> 
> Since s390_unlist_old_asce() becomes useless now, remove it.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Acked-by: Steffen Eiden <seiden@linux.ibm.com>

Nit:

You missed one `ptdeѕec->pt_list` reference at

arch/s390/mm/pgalloc.c
	unsigned long *page_table_alloc(struct mm_struct *mm)
		INIT_LIST_HEAD(&ptdesc->pt_list);



Steffen


