Return-Path: <kvm+bounces-29401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1A59AA245
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:39:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 896641C219C3
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB41419DF5F;
	Tue, 22 Oct 2024 12:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HxXalHTQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744F919D887;
	Tue, 22 Oct 2024 12:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729600727; cv=none; b=LKaKdKXL7Tbla7eCLtuOGdhVpkFOYs7C5+0aBtrF28RrIJoZOS9A94/RKQOUv3pzD/Lug/qoQ0sN3B/7oIyq6KmdOINoGv/6LkeDJakxO2SiDPoN27CM6fC9YerTq3gFjKeLBfkj4v/u/TQ28oV6fNNS4yYVF1bU9TUmZuTLUFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729600727; c=relaxed/simple;
	bh=Cab7c8vPZw4U+odLtWat3dNAzUtuxdDYxgTDEJU4Rq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SN2/nN3652T3IMVkyF3KMV7WsCWVb93bNopPbUy2w+Wfuzjr3v3mVUeWrqFyZm9ZTj5d55d7gc5tlQfjOB5NvqnvKi9UngIRkkg1WNuWy70icUvbrPxWyyGKmYBHEfpyzToo57XATgEF25ltNfpmDsCpCGy9fYihJ0rkrbf5wY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HxXalHTQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HB6s029421;
	Tue, 22 Oct 2024 12:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Cab7c8vPZw4U+odLtWat3dNAzUtuxd
	DYxgTDEJU4Rq8=; b=HxXalHTQnaQKRbhWy3zvpmNfeQ5xJaQ+PP5EQN9UmdtI4m
	/DLQOInN/aJHVxvhXGqsjvn7OF7APaVG2xJVL7Rd+9BDD0V/5Gw1TDuJoTGj1UPT
	bcoIOpmTRaA+6T1hkU9rsPOWbEr/sdc+lMQtTlj8bza+m9BpGOpdakheM+jNN5bg
	9ArxeNlSO+nAjMSG2R+r/QKgv6ZwxjEiHAuD/7C3UJTB+N+Q5DEmNjtRfPgdipP0
	zLdmYSTJlQXjRj+uzUR8cOovqawwkOHBYpB2NNKN1qVafpIzid5N1+z7KnqsLcPb
	PjGFJmTfjRxiG+ZQB7bYGlPhpZJAooiVdoUyIMkw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5eudwft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:38:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49MAd8h1023864;
	Tue, 22 Oct 2024 12:38:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42cst12vvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:38:41 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MCcbUr34145008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:38:37 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F2162004F;
	Tue, 22 Oct 2024 12:38:37 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C4A42004E;
	Tue, 22 Oct 2024 12:38:37 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 22 Oct 2024 12:38:37 +0000 (GMT)
Date: Tue, 22 Oct 2024 14:38:35 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [PATCH v4 05/11] s390/mm/fault: Handle guest-related program
 interrupts in KVM
Message-ID: <Zxecy+JcPsw5QxU3@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20241022120601.167009-1-imbrenda@linux.ibm.com>
 <20241022120601.167009-6-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022120601.167009-6-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -D9Glo2RnkpHhiQaDT-GBFytZyavC5lI
X-Proofpoint-ORIG-GUID: -D9Glo2RnkpHhiQaDT-GBFytZyavC5lI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0
 mlxlogscore=604 mlxscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220078

On Tue, Oct 22, 2024 at 02:05:55PM +0200, Claudio Imbrenda wrote:

Hi Claudio!

> [agordeev@linux.ibm.com: remove spurious flags &= ~FAULT_FLAG_RETRY_NOWAIT]

A square-brackets line is for something else ;)
Simply drop it when/if you post a new version, please.
Otherwise I think Heiko could take do that.

Thanks!

