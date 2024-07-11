Return-Path: <kvm+bounces-21416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 728EC92EB78
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 17:17:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D5D8283A27
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 15:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C9616D329;
	Thu, 11 Jul 2024 15:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BNFXJ2PU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FAB16C856;
	Thu, 11 Jul 2024 15:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720710996; cv=none; b=kzSTh35ZKRw63rvQQC5ynhzrvCBjJz7KAstgGbPPGZXgvM+Pi9NRPqC8w5wvNa2je6HyS6BsXt+rElJftC31L9EIfy6/jyflU6QVz3XICJDLC0a6Vc/vj2XNuzKekeeFzelaRZeks5a4r/R0JOoP7ELM3qam/HvHoa/b4b7g5zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720710996; c=relaxed/simple;
	bh=Ua90oyvhkJ7fXkVU8iQVZIBQD3K0jeHo5x0n501jWU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=efN/Q6a610NXV94L7iaQSLtLs51/6xNHc9fFW5hDAwrSpPcB88QAhQDrdDYwuOXIUNRQMpKXZcWOKghBPLaDX7665z9+5Z94aXwTFxZGaO18RB+DBRH+n/NA+ka7rzrfJpEJQA5XsWiZlrM4OOWm16ButTICA7Efyo0uvk7E/vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BNFXJ2PU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BEufMs017913;
	Thu, 11 Jul 2024 15:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=S5FovPlkSodGrIGHHUwATRR3RSW
	5U8mhAO6VtEyqcDk=; b=BNFXJ2PUzu6nD/yguowsCyON6zG9MSEe6PWbdQY2jDk
	YJZo0iXFc0+a0+GhHzhd2qfh35Nwf6f1eY6/ky/5WzfK20UuGej4vMkwC42hseTc
	bW5QgtWJGIw9KBkU6U9CXVp7xi+OTlzFDI0E68Seav05p1r9JJJ+MyfHijj4yX+O
	CY7grzHNXeefOIf4mMdsimb4KWiOCq6kmBNAeln4sZjXRWR6wbDXmKelBO8zOGPd
	frJbs5W7PqGG7lRm6rtsKyNbrOF0hexcpU3//vxYgjf5/7BEiHhn3rjpREmSziQf
	OV/jI2TTOp3Tj6haNa4rDh9P7Vwui2G4718qmOsGejA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40af9s8fvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 15:16:33 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46BFGWfD017844;
	Thu, 11 Jul 2024 15:16:32 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40af9s8fvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 15:16:32 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46BCiTxC024598;
	Thu, 11 Jul 2024 15:16:31 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 407hrn1c20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 15:16:31 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46BFGP4744040614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 15:16:27 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70D2E2004B;
	Thu, 11 Jul 2024 15:16:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D2A12004F;
	Thu, 11 Jul 2024 15:16:25 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 11 Jul 2024 15:16:25 +0000 (GMT)
Date: Thu, 11 Jul 2024 17:16:23 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, svens@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com
Subject: Re: [PATCH v1 2/2] s390/kvm: Move bitfields for dat tables
Message-ID: <Zo/3RzpS2WNssMIi@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240703155900.103783-1-imbrenda@linux.ibm.com>
 <20240703155900.103783-3-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703155900.103783-3-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mbGv_8i8gP508I0f-yMYlZLYfglkGpob
X-Proofpoint-GUID: zGaBPWH748J0629CGRxjkmxGwdCBw4UX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_10,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 spamscore=0 mlxscore=0 clxscore=1011 impostorscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=511 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407110107

On Wed, Jul 03, 2024 at 05:59:00PM +0200, Claudio Imbrenda wrote:

Hi Claudio,

> Once in a separate header, the structs become available everywhere. One
> possible usecase is to merge them in the s390 
> definitions, which is left as an exercise for the reader.

Is my understanding correct that you potentially see page_table_entry::val /
region?_table_entry.*::val / segment_table_entry.* merged with pte_t::pte /
p?d_t::p?d?

Thanks!

