Return-Path: <kvm+bounces-47878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BDD3AC68C4
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 14:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD00F1BA50C3
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 12:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E488283FC5;
	Wed, 28 May 2025 12:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f9epUl2Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36DD215789;
	Wed, 28 May 2025 12:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748433788; cv=none; b=OyMX/tLLT9gYyd+mC+CnbH1oi1hioiRV5sTmwjZKCAv+BnjjaLDrgylgGZEsIbEOy5tooEFe61hBR+GfyKEQI382j6M8irPI2G97IzyPcNSigHsLhS5aZabYzGfcM1Ch+Dv+mAFtF9f8DGpcR7UQEAUx/67ExWMoQMtY5/YebkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748433788; c=relaxed/simple;
	bh=ihLvw4hXOPMGDIvGxQsUVAb12tdAVW6ukAIssdKhEjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WySW3UYNClw5ABq+79wkBbmyWG08JRvEfCroXRpL5c6/My0pXSgCEgazlsRdkyig+eGfFOiDmKIpOeEtds8Ekk9YnvBHA0iXuWJlq586XTQSPEAeyO/RqrPCicaDXpHAuN+h0lhdk8JEFSx1Swhpu574IMz6kDtbsaOqXqPtMPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f9epUl2Y; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S8fCOm003861;
	Wed, 28 May 2025 12:03:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kQpqkj
	owf/aglq8vrseV0Jbz07x2dsu4rDUKQuvDIGM=; b=f9epUl2YRCbFiBgm3n18HC
	wEFvHw+TSZksRshLwjS7reOOfDlNW97WLqHigfBgEOkCMYwd3I8v4t54ffqDVzo8
	zIxX9lghfA/7AzcN22s52eL+7B/pm7OZzGOAKh0t6E8MVmTW+zIwNT0Jy9cbncqt
	dd913Xiay1D2qrQ7su9at7qWwzyRXMvd2FpuMKmfIXzj5lh56sInXcdiTcUHqSW6
	Q5WQLXtGwerKiw0vUuQ2FdkivQb94PgD/YLPkztSamuK82j2MNDAKcSsDkYexkYa
	ER6pyymeu3j4EC1Mn1rWMEAYmbr2vIqiVpuK8MMsEb0bMbmpub3sEqACoSbDcYYA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wy690vqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 12:03:01 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54SAd2IC028915;
	Wed, 28 May 2025 12:02:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46usepyc56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 12:02:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54SC2ode18612600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 12:02:50 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B85F20040;
	Wed, 28 May 2025 12:02:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA77620043;
	Wed, 28 May 2025 12:02:49 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.56.81])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 28 May 2025 12:02:49 +0000 (GMT)
Date: Wed, 28 May 2025 14:02:46 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: diag10: Fence tcg and pv
 environments
Message-ID: <20250528140246.1c32e996@p-imbrenda>
In-Reply-To: <2706494c-a033-4956-bf72-d9acf3b6d89b@linux.ibm.com>
References: <20250528091412.19483-1-frankja@linux.ibm.com>
	<20250528091412.19483-2-frankja@linux.ibm.com>
	<20250528114102.569905dd@p-imbrenda>
	<2706494c-a033-4956-bf72-d9acf3b6d89b@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=UP3dHDfy c=1 sm=1 tr=0 ts=6836fb75 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=2NYhSrEZ8-r_RkwOfc0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: vbeQj8QSVZmWyS820Goe7OZpWathedBj
X-Proofpoint-ORIG-GUID: vbeQj8QSVZmWyS820Goe7OZpWathedBj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEwNSBTYWx0ZWRfX3s1nYfcP2tVf UTpZNL18Q44yYbe+muy+Z6c3FuCT5F+BmTit8T8Mv4W8VdM3l8qiLrFExoBQdoxrUPs11ONVOW4 FAC2hY260KdPgMZ5VlOJ0dcO7KcqDE+uXKh+AZpriPwilRKqSGzF34q2l/Gn9KsTgU214u1qhS0
 lM3z49elrsEMb5gqBYAE6m+zMlo+dlqQIebTOQTygpK5unQmPMG+4g/4sTYAldLfYHQ/MxVC9UP ruhVh/j5VcnWXXhVW6HDTeZGOnTXUTVX1ym0eyi5FjYot42E8ANFIsPwlhA67lK23saYCVo7Ywn rkmdwtQYSDWFoGgoMVQwq6eYwWVWtONsIrKRAenQnCW3OHtN5nv/Y+IBhXBI0mlOfBz9cksMVTe
 ttx5kA04xcUHhnMw0YilnUJYgoZMzn6V+LyBrGKQU1VOSTQJDPhzkYKBZ0ETYi8wOuR/Qb75
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_06,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 spamscore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280105

On Wed, 28 May 2025 13:13:45 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 5/28/25 11:41 AM, Claudio Imbrenda wrote:
> > On Wed, 28 May 2025 09:13:49 +0000
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> Diag10 isn't supported under either of these environments so let's
> >> make sure that the test bails out accordingly.  
> > 
> > does KVM always implement diag10?  
> 
> It was introduced October of 2011 and there's no way of disabling it 
> that I can see.
> 
> > 
> > is there no other way to check whether diag10 is available?  
> 
> The z/VM CP programming services doesn't specify a feature bit or any 
> other way to check as far as I can see.
> 
> > 
> > we could, for example, try to run it "correctly" and see whether we get
> > a Specification exception, and then fence.  
> 
> We could move the content test to the top and bail out if there's a 
> spec. That would allow us to handle the addition of diag10 support for 
> TCG without a test change.
> 
> But:
> How likely is it that we want to implement diag10 in TCG?
> My guess is that adding it to PV is even less likely.
> Not running them under PV and TCG gives us back some CI time although 
> it's likely minuscule.

fair points

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

