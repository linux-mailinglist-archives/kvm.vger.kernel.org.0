Return-Path: <kvm+bounces-57693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FA6B58F92
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DBA11BC49C8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED75E2ED144;
	Tue, 16 Sep 2025 07:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DMMJ1TFP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921FE2EB5CF;
	Tue, 16 Sep 2025 07:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758008730; cv=none; b=N3307CYhU2ZepDyj1wUSvoH6HFHr0PiLfBiRhHA9J2Xko8MH1AWQhRxFOtf5FsW6FGt5Uj3+dPe/agG6ln5IZ7jocfhIbkAaP8rhlbPHvw79Xxu1NQttnVV6rNqwpyWIUa1b50PsaW+3Q3F0VFlWZMpIGRN54tYwkxE2ubuhvgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758008730; c=relaxed/simple;
	bh=vNmj0dmhqAiZLl6jAv/0fBmEx/lrw8FFi5w1e3szeYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pUG1yZqUwpUS1kwxKKpz/rq2JW9KaYvfTwBrT/pd4wlhHRlLNcqdbI7obpnqQ2fP3lOILMnyZJUcGgNp1R6x2mXHMDUaNfOEI+CvCR+ONIdgXLipOmRFAIfkZd56Nf1sjL/1dIJvQ1EgnWb/KgyuB7RLRxUM8adU1MJTipD2G7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DMMJ1TFP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G3al91025368;
	Tue, 16 Sep 2025 07:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=7zr4TLcxAyHWJSUszLH+sJCRB1Gg15
	pxFb9hIukfnwg=; b=DMMJ1TFPp3mjrQWodpNVO7UApmasZVh9MgEtyJq0A5ot9M
	C9lFSfaS4JrwLyE7k3KyUfFJVTX/4RputyNKbXkfhC6GfZ935NjNx/2X1ElIzJtO
	i7Ed2fjCM1vdwiKHIlk5CVwmqdkBb1aaxY9atb5dcd6DYVRtJn3ZttBXrgnNf1oZ
	0le3oRupdmM/ECi8FJz2NE/Di/gRgbzKfLmODqS59ViDTLOPUngTdGD2Ny35wL1Q
	knhU3Ni7MlKNJbcAuqUG/CZaZ02TQdW0Op9m0iLj6syAZ9X2ZNtKFZ2m2/3vundS
	YxkeVAfzkTfZcESxHzPaADienN7YXCXXvnD8Rw9A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49509y7t8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 07:45:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58G4M2JV009486;
	Tue, 16 Sep 2025 07:45:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn3aey5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 07:45:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58G7jKVh48365878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 07:45:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 952142005A;
	Tue, 16 Sep 2025 07:45:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DCD9A2004D;
	Tue, 16 Sep 2025 07:45:19 +0000 (GMT)
Received: from osiris (unknown [9.111.25.93])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Sep 2025 07:45:19 +0000 (GMT)
Date: Tue, 16 Sep 2025 09:45:18 +0200
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 15/20] KVM: s390: Stop using CONFIG_PGSTE
Message-ID: <20250916074518.68862-B-seiden@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-16-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910180746.125776-16-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyMCBTYWx0ZWRfXy7TKA/jgh09+
 rck7uztUQqIt5bputnnzb9CgwlR8r1pGsNoN7NTw/3w0MTDhzCwwHA+yqrXR25Kfloocc8/mzQL
 UPKxB3F+02ORpEbdTNNhjp7+HWJjvqjk5KHywRFo/XifBYk9NgRcpESOXk7p80o+eU9OM5+ofro
 7kLElpqavLUYCQrgt4MaRFM4n3wpYsY6rgDqSlESxqkRcD75MFwsu9nceqsUFicAvTnIvNIpM+7
 ikwvc40Dq7jWDt6vr0nakW5SaUPN9AVloi0tNGdscN9ewDgVOTypU/DjEBCdcdg4HcQ7SlbBWTk
 Ty9XtMCkUwxK2KdD9cIfe8+jwzYqa6YELQhKPJ8zb4ezxL8/9jw3W7cK+4E369CzNi1C67etftL
 S0tyFFMh
X-Authority-Analysis: v=2.4 cv=OPYn3TaB c=1 sm=1 tr=0 ts=68c91595 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=QStvAmw2Dl8Wxf5ceJ8A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: nTHmq4E7NyruSjv8HGwLdS4-ihqvpTPW
X-Proofpoint-ORIG-GUID: nTHmq4E7NyruSjv8HGwLdS4-ihqvpTPW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130020

On Wed, Sep 10, 2025 at 08:07:41PM +0200, Claudio Imbrenda wrote:
> Switch to using IS_ENABLED(CONFIG_KVM) instead of CONFIG_PGSTE, since
> the latter will be removed soon.
> 
> Many CONFIG_PGSTE are left behind, because they will be removed
> completely in upcoming patches. The ones replaced here are mostly the
> ones that will stay.
> 

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


