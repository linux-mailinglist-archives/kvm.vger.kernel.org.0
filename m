Return-Path: <kvm+bounces-47380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE02AC0F1C
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 16:59:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 867275030A3
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 14:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DAD528D8C5;
	Thu, 22 May 2025 14:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lkQi7wtY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11C41F94C;
	Thu, 22 May 2025 14:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747925851; cv=none; b=KMxozXpiKZCkLahMxKHgfrk0P9Jw/3PFHhqmTPzAAFSFkeH/SetNlpqfFMEhHP632UK/gFB9hnSGS37+rn4p9SMeW6A18Xkvc7mJmxneOtvUNV//S+G9vFOTNRbO02kT8KPuigKBilKe76UmuzL8IB0K5u0E8TMPoYPpKt5Q5sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747925851; c=relaxed/simple;
	bh=kruNur/Jjoa2McD4ecCvVnpPDxpW5xiYdISEw8XfiQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j2GC+phATM+TBQJTS7+TFZWWaZrDvFHOb6IdPSEm1Gb1+W1m7Cp1GqqIj0sBNgC6+fhbPZAIomIEm9Ik6BCalxxHoo/gfuHrj5HbHPbjSs/eH/QOmzA/EYIgD1RGPf1LAVtI43Ijl9IRexXgznc1oIKoZzZUnYuPbDvJnmJh7Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lkQi7wtY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54MDo3xk012080;
	Thu, 22 May 2025 14:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=UCEzZooc5j845GMXjKyZHy13dz7CzR
	lmF1GoAsSZHJo=; b=lkQi7wtY6Y00BoSWHRzd7XF+6sZ/GrpPHN1vZet5hfOCYt
	RHQyPbilt122eP4q7Yjre/VhTzbrbGJzsWjvUfgKH2tV5u2X8w6ymrgrmgyC8GNA
	lY6m6YWf+eFWevsRFQr83xEm5xyL+B4IyjocWGozloq7EtIbNNJ0cQXaZY0nmiyV
	+Iq3PEAIR1d+ZZxRNFKEU/QCEphnvqKiZsDO6pj1CTGQ0u6iZGHvlap8Ad5j5r18
	iBAvwn7rN/oIYngcYDCDe1ZO7O9xYUckTBL1dzVAqU7gKCvHdffAc0BmhYi4c+JE
	X8Wa+J/ptr8X3kJdTLYcu/DGxeS7JMDwWH8NTAVA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t5530b66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 14:57:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54MDfSNZ020749;
	Thu, 22 May 2025 14:57:26 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwkq1xbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 14:57:25 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MEvMkU31850968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 14:57:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 130FD2004E;
	Thu, 22 May 2025 14:57:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6B8E20040;
	Thu, 22 May 2025 14:57:21 +0000 (GMT)
Received: from osiris (unknown [9.155.199.163])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 May 2025 14:57:21 +0000 (GMT)
Date: Thu, 22 May 2025 16:57:20 +0200
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, schlameuss@linux.ibm.com
Subject: Re: [PATCH v3 4/4] KVM: s390: simplify and move pv code
Message-ID: <20250522145720.311722-D-seiden@linux.ibm.com>
References: <20250522132259.167708-1-imbrenda@linux.ibm.com>
 <20250522132259.167708-5-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522132259.167708-5-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iHMqyzSPZAPB5dDuN9Udn2bRKONiReWJ
X-Proofpoint-ORIG-GUID: iHMqyzSPZAPB5dDuN9Udn2bRKONiReWJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDE0OSBTYWx0ZWRfX2adNjxHmXMmm u451t3AHzh8ynh772XLMNjCNRs9kLmjJp8lITprXKHcVBr0q0lrQk6A7BrDLwk7Qc8ZxtqQXqUi tk4eh5hRx+qVGhexc5Pynjb2NY201SjKwuGPIdHVDX5HnH/am4DvIxqPqKtnrVMeWcVTlQSC7Bj
 P+8blyA9PzoEz9aVzLWNnr0hGZqKUMwPM0lTuLYjxYm4E7PZW0b2tXom7Qnfo0dSJgBK2GzM9Ub ZuS9SBQSTHdQKDg1HMjTUpzO8zAnczSgdHQhWnf6dBeOHBF/FkeYRiMoH+ak87JwKeDmbhB4Ylo TeIl1gaJ4bXWENXUoKTYatNqncTIVCH9KRum/1nnsUw9gxtco1gbq2aaE25Usbc5IiqQz0s4qoA
 S2OVkhV+i5HYBmGYVtS9+oyUE+utrkVGuibW9hzJVLg9zbUoD1MrneJxp4nz31V+AOdzTcJo
X-Authority-Analysis: v=2.4 cv=BOmzrEQG c=1 sm=1 tr=0 ts=682f3b56 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=G0SGIs7KnoaDR9FhA_UA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_07,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 mlxlogscore=-999
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=100
 suspectscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=100 adultscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505220149

On Thu, May 22, 2025 at 03:22:59PM +0200, Claudio Imbrenda wrote:
> All functions in kvm/gmap.c fit better in kvm/pv.c instead.
> Move and rename them appropriately, then delete the now empty
> kvm/gmap.c and kvm/gmap.h.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>


