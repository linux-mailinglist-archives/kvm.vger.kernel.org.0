Return-Path: <kvm+bounces-35803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 555A3A153E8
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:13:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D14E165CD5
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7486819E7D1;
	Fri, 17 Jan 2025 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QF+eXVZz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0558A19994F;
	Fri, 17 Jan 2025 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130324; cv=none; b=qK6d8NsOddckPfyGoXMta51IMGhuHF68045CuwtiiZ4cjhc+4C8Da1keSmAwX/useXh+lrwDYb1dyCfmCrLAZfSVJA/gJuBgQE3a5EXRQnnXEEpw71+FinHOJUtLTWdDXyaAFEqce34w3U7JpcxmxzwST+1ujifeh3/Q9zSlO4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130324; c=relaxed/simple;
	bh=6M1TNWtMtbNZLrvP4hf5DDCTddhHsLn5kUmH1WEI72U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lL1bFnw7fzbw6NmHc6OL42+TIGkuWRIFiGPokO4KmtHEn+Fi+gBbwtuofD9Cpuh2BRSNwuLB58v+qgMFOQ3aDDoviMY/GuMEQu/0St4pb4ZTMlmysxH692b7lNut80bIP/1b9rNRkBtdkPKB/DDbbB1BD3nW/UxE2RFBlz7Szck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QF+eXVZz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HC0JGE019965;
	Fri, 17 Jan 2025 16:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=FN5KNeVYM3PTq/90S8k4IxxJi1g6Qo
	BYJxEqVKhD9aU=; b=QF+eXVZzeM84KjrWI8wbso8fb/pybz3GYI5B71cjTEAwOe
	8hVjGnOjbCD7MUgB+vh5kpX20J8R4e1GySSRfkf9L7IHpwfyvHQCNxlFP+qQHxMb
	oCSYDRlnWXG/b89b49dFVpEF1Ck/GB/v+tTG4bhs7+dSSuvjbB1rf0YKbE6zptJP
	D2XTURlmnDRev2MRRbH/tz7WXXFxJmxiKQiv3r6HTrM6S4XWpyKucpzmk9Cc2HYr
	QFX06lk//XqjaiDHoQ/92JEF/6pAcYn1tkFrJqGmvMhiEvXSLFS8AKFVanATG+Yt
	MsHeLxTxqf/0uSDqGDb7vfGqkXbHbrNbVNNbehYw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447bxb3vab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:11:57 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HG6Vne020104;
	Fri, 17 Jan 2025 16:11:57 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447bxb3va9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:11:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HE49Uw002693;
	Fri, 17 Jan 2025 16:11:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443bykrqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:11:56 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HGBqGV41156878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 16:11:52 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6878C20043;
	Fri, 17 Jan 2025 16:11:52 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5581320040;
	Fri, 17 Jan 2025 16:11:51 +0000 (GMT)
Received: from osiris (unknown [9.171.89.28])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 17 Jan 2025 16:11:51 +0000 (GMT)
Date: Fri, 17 Jan 2025 17:11:49 +0100
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, schlameuss@linux.ibm.com, david@redhat.com,
        willy@infradead.org, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seanjc@google.com
Subject: Re: [PATCH v2 14/15] KVM: s390: move PGSTE softbits
Message-ID: <20250117161149.79512-A-seiden@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
 <20250116113355.32184-15-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116113355.32184-15-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ffS0_7Jco9t9Y48RCuolWKDN0S-4t4x0
X-Proofpoint-GUID: kTwRvBFXwiPuMnddU5Dv414KjIdAx23Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=505
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170126

On Thu, Jan 16, 2025 at 12:33:54PM +0100, Claudio Imbrenda wrote:
> Move the softbits in the PGSTEs to the other usable area.
> 
> This leaves the 16-bit block of usable bits free, which will be used in the
> next patch for something else.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

 

