Return-Path: <kvm+bounces-54017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1B80B1B63E
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B90C27A848F
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A3A278173;
	Tue,  5 Aug 2025 14:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bbifF5N6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD50277004;
	Tue,  5 Aug 2025 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754403640; cv=none; b=KJvNcMzcyyLjUwtUt+tAZCnmPu9NhEmMRBSMTbZaedQ6sO2HVOglZlJpSix+LMpfFGmxqQxOZE59GdtyM0nzTH1Li8vARs1pbCgg4lqWyeb+CdPGQJl3bi+8hIB4jfdfUQSxD6prUR63Ezi+pN+SrqCLc7glj7GldZS6GFaLR8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754403640; c=relaxed/simple;
	bh=2XZkvqqYubphZbXQsW21xrCmAVLCaWh+sihxqDD/GIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZPJ+L0sFAiFqmQelM1Qwt3gwTfSrCirhcWyiNuPt/CWCfbmhOJu8c46UqWnYmh1dQN7a3lDBT8gIjbEhwYVxvLptv/Df6rg5tzL5BqwilMw2dK4VjvDBwwlposyHTzhObduK+vJyye9GgLgQb99N2FV56H7ASj7Jd3fOQR0rvPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bbifF5N6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5754tZwj032569;
	Tue, 5 Aug 2025 14:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=8v2vvlGen246KV5BIx6EYWMGjt0dVG
	1M7LiexutSZwg=; b=bbifF5N6JaK65RIxPt7n4JMWRm0mlTZe7friv3E6FRYXQa
	dQpJOp1A9627iOVswYZ2DSRsyfdJNKVYzN9hgclc6XutJ4e05ssCe0scAaOkHwvD
	FJmLik3uZfcyzXuNiSQoAfTyUvWuI1b5Pjc1qLEELvWUo0R2CQIX47ZCdMmXuX+/
	ao8Bx/xD+DxVAyH6xlxMhMrb2g2O157utTfbSsVJDcAze/HiPLnoAOmH32i9Inmp
	O9BeVLts8HD4qjmdFceKO+ol9wRkZP8zkA3Lfh8pLd0HRt+F9/Ay3i8lmWYlq6qq
	BQ55o+479kKX6R1/+/cpSU4s9YXT3tYUhZX0Th8g==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bbbq2fma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 14:20:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 575CjeOX009442;
	Tue, 5 Aug 2025 14:20:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 489w0tjwny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 14:20:35 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575EKVRH20513032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 14:20:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B4E520043;
	Tue,  5 Aug 2025 14:20:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FE9A2004B;
	Tue,  5 Aug 2025 14:20:31 +0000 (GMT)
Received: from osiris (unknown [9.155.199.163])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  5 Aug 2025 14:20:31 +0000 (GMT)
Date: Tue, 5 Aug 2025 16:20:30 +0200
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, mhartmay@linux.ibm.com, borntraeger@de.ibm.com
Subject: Re: [PATCH v2 2/2] KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion
Message-ID: <20250805142030.61286-A-seiden@linux.ibm.com>
References: <20250805141746.71267-1-imbrenda@linux.ibm.com>
 <20250805141746.71267-3-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805141746.71267-3-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7Q5moSioe_-nQgQkCOndKM5Yay8Wf80v
X-Authority-Analysis: v=2.4 cv=M65NKzws c=1 sm=1 tr=0 ts=68921334 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=hKoHGS1yLziZwobD-tEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 7Q5moSioe_-nQgQkCOndKM5Yay8Wf80v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDEwMSBTYWx0ZWRfX68+V3xR9SQlM
 aeOH9dlVsJkqeqA23kLEA6AbG1EfPpQPsC/a9scrgoWz/5IInd6v/FFZjCrhpNL50cejyfjMZd8
 rCugG4mPQVP4+UJKQB6VXge7bAXm5XY+oiaWg3OE9HJ6mbuQfSCzysIhfGSfc5XpuEr9a8VC+RZ
 aeTntrfCgsf7ZfZ9dKSI5xsuNL9deqJf0nfEsWbNFtWYYGFfAjnNYcJ6Oi1xxaw+GKyRrpuc58+
 TSisalXrvgi/a+d03XnkoCPVtqTQqedxA8GKF02vJvVHkshOOPucdA6rkcagwWo0oRR9K8ZnKbE
 FJw4RNmNxkMhVCTuOlc4bide4OtvXSL6EuHjhgcTkUzc6+YPGJ1ph530jDQDql5frdQZ8JeiVPa
 kB03UoKErnN1g6fecjBPgbYiz7QXGDw/BHSBA0sBnn2JwEXSChpONzE9HCAk4jOHuwemYFbZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=665 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508050101

On Tue, Aug 05, 2025 at 04:17:46PM +0200, Claudio Imbrenda wrote:
> Pass the right type of flag to vcpu_dat_fault_handler(); it expects a
> FOLL_* flag (in particular FOLL_WRITE), but FAULT_FLAG_WRITE is passed
> instead.
> 
> This still works because they happen to have the same integer value,
> but it's a mistake, thus the fix.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>


