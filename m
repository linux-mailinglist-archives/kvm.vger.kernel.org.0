Return-Path: <kvm+bounces-36101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D9FAA17C5C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 11:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 498D41885980
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 10:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85ECF1F12E9;
	Tue, 21 Jan 2025 10:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gUDWESFE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F198C1E9B0D;
	Tue, 21 Jan 2025 10:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737456938; cv=none; b=W7vDWthpPcqTcpDW/ZNtStx0oVy96bxMla4mkz+v4x7/gnK0VuZvwz0QnJRMqoUp2BkB1RokFShjW2TcLvI3cdHL4nwIVLvKi5sGIEaiACbJbeqCoMZbzR8FPzsbDcOELetwhhkYztiG41a3odGmiaIm1fAGX7dXFimOzQsW4/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737456938; c=relaxed/simple;
	bh=2j811sYQgN40V9LO//OIKRb1REOWnFO+AmXAbTsUreA=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=tnHJGZcv4k4l/Ksb3LLE0MluhT9eW8q+NCyVPHDxX5rhJZp8TCA1rrQKUMTbLasNi4HIhsG7ylDnry99xmr1uTcrWshCXbKnD1F2HRiyYU9Hyapy6Hz5sQaB+N8BPQEBMDeVjuVXtKpQgW3/Q4ATb9BhTzNmaKIBWZU1toxLFzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gUDWESFE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50L20ZNI002891;
	Tue, 21 Jan 2025 10:55:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pDPpVh
	cYWabcEzJl4bH2xE3+BDMZ4KIDQjdWIyrlxDs=; b=gUDWESFElr8Re6nALQ+W8y
	t0VA0BFevfhnb2Xo/qVlJGiwXYzJRn0/syTKzNzm9ZznCzbtzf59HuAPxsE/MYWE
	WjMteawoMnAIeOA86chRCaF9VtLouBLUfYATO1nVTgGQNpAyJcJrx719v0ZQkRRp
	Q1Vg7qHWARJAaVdWkD2Emv9MXnVoxOVCLVRKu9SMrM4uwmDJIwBmUOGiEZd+3Uyi
	m+TYZP8jDl2BC9KwEOHx+P0qq/EsVItqX4dSgc+Y74vQ5xm2bkMAJdFiY9DNbdqu
	lxrAuTMcHSEk9XymmS96HVBL/wf9mqGM8/1FyXs4Hn7RbJkp2d/n56/sMGHSk+OQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44a2dya369-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 10:55:32 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50LApkDt024775;
	Tue, 21 Jan 2025 10:55:31 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44a2dya362-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 10:55:31 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50L90T5X024252;
	Tue, 21 Jan 2025 10:55:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448q0y2xur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 10:55:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50LAtRpN35848674
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 10:55:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00EA320084;
	Tue, 21 Jan 2025 10:55:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D062D20085;
	Tue, 21 Jan 2025 10:55:26 +0000 (GMT)
Received: from darkmoore (unknown [9.179.17.46])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Jan 2025 10:55:26 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 21 Jan 2025 11:55:21 +0100
Message-Id: <D77P2QTIMIMM.1GYJ277JWT4R6@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 05/15] KVM: s390: move pv gmap functions into kvm
X-Mailer: aerc 0.18.2
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
 <20250117190938.93793-6-imbrenda@linux.ibm.com>
In-Reply-To: <20250117190938.93793-6-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rE4EgWArfkhzETVCh3xo31fC1o7KQIVv
X-Proofpoint-ORIG-GUID: ISqlmgnpdian93RODzf_MOt_CVaDK783
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_05,2025-01-21_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxscore=0 phishscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 mlxlogscore=597 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501210086

On Fri Jan 17, 2025 at 8:09 PM CET, Claudio Imbrenda wrote:
> Move gmap related functions from kernel/uv into kvm.
>
> Create a new file to collect gmap-related functions.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/gmap.h |   1 +
>  arch/s390/include/asm/uv.h   |   6 +-
>  arch/s390/kernel/uv.c        | 292 ++++-------------------------------
>  arch/s390/kvm/Makefile       |   2 +-
>  arch/s390/kvm/gmap.c         | 206 ++++++++++++++++++++++++
>  arch/s390/kvm/gmap.h         |  17 ++
>  arch/s390/kvm/intercept.c    |   1 +
>  arch/s390/kvm/kvm-s390.c     |   1 +
>  arch/s390/kvm/pv.c           |   1 +
>  arch/s390/mm/gmap.c          |  28 ++++
>  10 files changed, 288 insertions(+), 267 deletions(-)
>  create mode 100644 arch/s390/kvm/gmap.c
>  create mode 100644 arch/s390/kvm/gmap.h
>

LGTM

Acked-by: Christoph Schlameuss <schlameuss@linux.ibm.com>


