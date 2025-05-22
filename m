Return-Path: <kvm+bounces-47377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF076AC0EB2
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 16:50:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 633CE7A9028
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 14:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 466E628D83D;
	Thu, 22 May 2025 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FDg1R4ZM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D5128CF68;
	Thu, 22 May 2025 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747925390; cv=none; b=JuA3AytzU2ujM0Ocs3kUi8qRs6RGJHhfUF3yKfuFjVvbAS/23oV7yv5oqxJXTHsyHakGa2kJjLKnm15K/UO0/klO0p42sA7N8KeCzIQAnrhWorQbvWgSPZvRKQeIVKbxuNUwZ7Z7NNtxU0vy7lpVC51YeukEcpAq2PvGNFsCVCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747925390; c=relaxed/simple;
	bh=HFymLVImnEcNAKIV/TlpK1W/DN4hwzhVfTQAET8d+00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4vggKkLNmYzBRE9rhA5zC9VPoqCSgFA8DrTQCX8YWHmfjHRenRy7lQ+YSLPpYjcXzwN9ajV8Ayi116pTtNa36K4BYp0T7WiSGSW3p7DKaqQNCPmItSEtXdeOuyNs8DXRrXavqwWK7ROjn6I0uEzgCR9evJeJhnsV6960l1jLyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FDg1R4ZM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M7XUKJ003165;
	Thu, 22 May 2025 14:49:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=3+xi4Q1NrRy5+I/Q+gWFXxJF9KfUYW
	CSTDlT3QV3Bzg=; b=FDg1R4ZM+aQOb/3qjXxLl0vtnvY8i7k6ifoEDmYIrN57yE
	mOY3zEob6XNdVwXIH5SSf6UJZ03bckBE0Z/69b4BUchAr/cCmCXZBZit8MRORNMY
	axnd7Z7cuTZXnJmWaWdJEcG03JKNhvrlfrYdnHICCq/KNlcqtqMMxCGJ6AiQaL5N
	VVF57TgPOBIkIjZXdhs2Ni+fSxBFwVnWdjqxoGtGP7hPHIPxN0gcdPms1c9UTVeo
	3na2MAxZLZFwA8ePC0BEBWvuQwqqRZ0PGQV2onaZbywfYZP3iln7Ct45SbKdyMHJ
	xA9N5lbmS2mdcPCYUqegXKWDciBsjRDyezA/TY1A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smh74rp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 14:49:46 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54MDrOMp010630;
	Thu, 22 May 2025 14:49:45 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwnmhw92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 14:49:45 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MEnf9e19530158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 14:49:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BEAE2004D;
	Thu, 22 May 2025 14:49:41 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12EB220043;
	Thu, 22 May 2025 14:49:41 +0000 (GMT)
Received: from osiris (unknown [9.155.199.163])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 May 2025 14:49:41 +0000 (GMT)
Date: Thu, 22 May 2025 16:49:39 +0200
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, schlameuss@linux.ibm.com
Subject: Re: [PATCH v3 3/4] KVM: s390: refactor and split some gmap helpers
Message-ID: <20250522144939.311722-C-seiden@linux.ibm.com>
References: <20250522132259.167708-1-imbrenda@linux.ibm.com>
 <20250522132259.167708-4-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522132259.167708-4-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDE0MyBTYWx0ZWRfX+Y7mkMcnqBfA l1DZQR+MwFqcZiFAgsiFRtAVFA9cZ42AGenI0d4pLBCS942fOml7L0F1TG9Iumks0zVqE1vD8NO BDZ83hwnuleWiz5n/frnULAMhBujaRwOID2uaBsKp2s1i2iQeItcJG3v+TkJuxH+vsuf9sWbba1
 xU8HCbubHzdGmSPq78yRDAeeIlyqY1E5akxobOjNXIXohG+sU4S5WxWyKR7H+IuENmy6rKlN7Nb 89S95nLR+/8S16Yrq8wef6Mh41XzYNFZArvbin0g31EbU6tZeKu0RrRJYhmtr3gHM3jdcWvCcQl 2U8U4ZtFE9LCeq3fLnYXWofBidvNqcaTOodiUkLSelH3CeoS8uBP5S4OSivhk/TVakE49hrtB83
 GGVDEBG13WFy4hKYoqh2NoRWV/ux0sIDVmgoQKm0I2Z3E7SsjXcm0WRqvZmiaAS+Te8wscdb
X-Proofpoint-GUID: dFBhf303j1fsEBbB08K5N8BNWFOxZ5af
X-Proofpoint-ORIG-GUID: dFBhf303j1fsEBbB08K5N8BNWFOxZ5af
X-Authority-Analysis: v=2.4 cv=EdfIQOmC c=1 sm=1 tr=0 ts=682f398a cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=5Nf8KAiPOa145nv64qUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_07,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 impostorscore=0
 suspectscore=0 adultscore=0 mlxscore=100 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=-999
 spamscore=100 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220143

On Thu, May 22, 2025 at 03:22:58PM +0200, Claudio Imbrenda wrote:
> Refactor some gmap functions; move the implementation into a separate
> file with only helper functions. The new helper functions work on vm
> addresses, leaving all gmap logic in the gmap functions, which mostly
> become just wrappers.
> 
> The whole gmap handling is going to be moved inside KVM soon, but the
> helper functions need to touch core mm functions, and thus need to
> stay in the core of kernel.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>


