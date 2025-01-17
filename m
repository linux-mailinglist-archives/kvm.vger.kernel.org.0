Return-Path: <kvm+bounces-35829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 007D3A1547D
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74B0B1888473
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F3B19D080;
	Fri, 17 Jan 2025 16:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="p8bFYINz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4897817FAC2;
	Fri, 17 Jan 2025 16:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131775; cv=none; b=UMr3xqAvn4bDgpXEUgawMqo/PzzAXKsW9RDKdLMHQZqiTEyGtLpcIZJWAMLtmLu8KWz5Xq97cTC28pTCyNWkrfKBXznd/E0bh/YhbFSPmBz0hreZgaqTF0xz1j1JPXEIPI9ng6A243BKAAgewPbHABcDupOD/x533jovbWbFjqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131775; c=relaxed/simple;
	bh=vjYX7am646qIRjJ526D9+Vb3+YT0/+t6fpvkLkfnS14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jW1ZOmmoICX7erqRUaH1hukEIFBA24YcyZBGktXo4YxJhwezxpltb1D7YymhgessESkZ/qyNvjr/qBI+y09sn/LKsgKwuS3MwXPIBa20MPAkkYz391VklG4+SVOQe75rmz3rqp3piquQpLKiMOwQ9Z4mj6PMSAsU/GavZLMj+DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=p8bFYINz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HE6V1g021746;
	Fri, 17 Jan 2025 16:36:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=np6lmLAjcQJBblO0aKCKPvUOqslVT0
	a8PrRWqOIbiXg=; b=p8bFYINzWMI4XVOnHX3sw73t0/ConP3xph0VlK94nHDXXj
	M/rWI+qDt3NTCVNgV0x6LDtF4O+dALv5eGMzLO51Uog98xYAIO2NWTFiuXWZHFVV
	RmhjrrusIAEhnTuWO0DySNvMXYS4sXBP9EYaZwhdvSVGs18J8Jn/CsUy6Tg3c0Gy
	/f0sIiDvARVBoxqx4wHfk+OyIKDZwWw4uoohbvRXrr53fz8W8VpqtHUJKjjzuAsH
	kj9yNPsZwj6q/JVwn3hTIieysX51nt/mfbjJkWJPMwcPKaic6dqj1IP0C/lj7B6K
	d82p6XKseeg6MAwPbOmRU5GPY/rsvFSeB4eQc7nQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447rp58rj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:36:09 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HGXMN3025366;
	Fri, 17 Jan 2025 16:36:09 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447rp58rj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:36:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HF1dK7000874;
	Fri, 17 Jan 2025 16:36:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456kbgs6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:36:08 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HGa5Du58917154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 16:36:05 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D65120043;
	Fri, 17 Jan 2025 16:36:05 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE4B920040;
	Fri, 17 Jan 2025 16:36:03 +0000 (GMT)
Received: from osiris (unknown [9.171.89.28])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 17 Jan 2025 16:36:03 +0000 (GMT)
Date: Fri, 17 Jan 2025 17:36:02 +0100
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, schlameuss@linux.ibm.com, david@redhat.com,
        willy@infradead.org, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seanjc@google.com
Subject: Re: [PATCH v2 02/15] KVM: s390: wrapper for KVM_BUG
Message-ID: <20250117163602.79512-C-seiden@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
 <20250116113355.32184-3-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116113355.32184-3-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xXwi6AgrcfIB121FG2ZA5XO5iRPMwqLK
X-Proofpoint-ORIG-GUID: 8hUbDl36bujF-mDVINcU-gumx-pU_ylQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=502
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501170130

On Thu, Jan 16, 2025 at 12:33:42PM +0100, Claudio Imbrenda wrote:
> Wrap the call to KVM_BUG; this reduces code duplication and improves
> readability.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

