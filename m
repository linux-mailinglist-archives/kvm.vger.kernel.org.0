Return-Path: <kvm+bounces-22242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DFC093C415
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBB1CB20DD7
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D471E19D07F;
	Thu, 25 Jul 2024 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YCFijlhv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DD41993A3;
	Thu, 25 Jul 2024 14:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721917633; cv=none; b=twWBA7TpBBLvTU5mnRKEHnWBFl/3z/tBD0Pm0KInF0PqRcSDtV7DfrIKmzvYCV9p2EK/A2ifNnThFRXYAZEO1OX+4AZiIzXchcGXwhL3FBhnSpLL5w/VBvYwNLZZhy71M74iqLa8F56gCn7WosG6XCm46xfJsMB0utTok1mRyFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721917633; c=relaxed/simple;
	bh=QKFnom4Exd/hMf+EV+8KBwN8RHAnQ1lXaOdTuGOv1dI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R0nagoUJtWMI671gRNqknq13HWaScbJgci1Eu6f/6EiS+BUbnhwBkfqo6K2aNgd+Y4dJCdD5+YmAMgGpweyk7+d9Ket8YDzQwZVO71sbiQoAw/pR0TiGDCVQNmIYrtYk0zIuNsiVGzOM8fBUAWPgM1nmiC9XXFouHi1cYT16+Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YCFijlhv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46PE0hao009832;
	Thu, 25 Jul 2024 14:27:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	IgrxNDBTzjSL/5F9HKCFHRlL9lbnAdSNjfYKlPBjVwI=; b=YCFijlhvg4sdSD+I
	ShU0wHFLW3RN+Kea+HRVzn1sofcN6F6nWhaklA2VxON93bsZtiJSucQOe/bthPZa
	RMq3BikTo7zTx0otUPOBdo/UwlEkhDFmL6MAfTc/IjR/p0IzcxZ6bgpWycw+tDWE
	TEyuhPIisINnjAfb+BxXc37+4d2PyZntteHwLFAiATLPvc/OY0al+FcGO962/ABY
	0norBr1DrZUp3iRwatzPR7Kmr/wtySmPhVCOtyj8V1sX3Ix8tpPTdM9m+Gv73+IN
	n46eIaNVaiYCFlgySPi+0zPmo4woR0ZX28snN5xixShZz6Byp6yJ+znYt+CmXN7I
	jBJGlg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kmm0gjpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:27:09 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46PER94A023531;
	Thu, 25 Jul 2024 14:27:09 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kmm0gjp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:27:09 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46PATmP2009100;
	Thu, 25 Jul 2024 14:27:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 40gt93pyba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:27:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46PER3Zh26673486
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jul 2024 14:27:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1239C2004F;
	Thu, 25 Jul 2024 14:27:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9481B20040;
	Thu, 25 Jul 2024 14:27:02 +0000 (GMT)
Received: from darkmoore (unknown [9.179.29.251])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 25 Jul 2024 14:27:02 +0000 (GMT)
Date: Thu, 25 Jul 2024 16:27:00 +0200
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        nrb@linux.ibm.com, npiggin@gmail.com, nsg@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/4] s390x: Split snippet makefile rules
 into new file
Message-ID: <20240725162700.57f08e82.schlameuss@linux.ibm.com>
In-Reply-To: <20240718105104.34154-2-frankja@linux.ibm.com>
References: <20240718105104.34154-1-frankja@linux.ibm.com>
	<20240718105104.34154-2-frankja@linux.ibm.com>
Organization: IBM
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TA5liSWxUCqkwUzTWwZ3L-qqeFm3H8Yt
X-Proofpoint-GUID: xIVIwQmrko2gMOL1NhWwyYyaJhiL3Mbv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-25_12,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2407250095

On Thu, 18 Jul 2024 10:50:16 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> It's time to move the snippet related Makefile parts into a new file
> to make s390x/Makefile less busy.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile          | 34 ++++------------------------------
>  s390x/snippets/Makefile | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 30 deletions(-)
>  create mode 100644 s390x/snippets/Makefile

IMHO the commit message should start with "s390x/Makefile: Split snippet
makefile rules into new file" for more consistency.

With that fixed:
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

