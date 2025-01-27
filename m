Return-Path: <kvm+bounces-36645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49190A1D386
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 10:34:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A58191635F5
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 09:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23351FCFEE;
	Mon, 27 Jan 2025 09:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iC3iI1qV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C28E28E7;
	Mon, 27 Jan 2025 09:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737970464; cv=none; b=DIhOhpPH98JC2DVm+lpelgTFyJGUblpDNLxW2lqCnSjvYa6ynX0PARrH8+xVf/rI5lXNcq7FDjaVMPozeO6pXjHFle6W10qxhlrtrzVy0F5lAeQ21Drv+vvrCMk3AD9s23l88ga1Nnwbz7fNg8Xhp8dEkBnelabXxe6wBj+YDro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737970464; c=relaxed/simple;
	bh=40mAlmPieqAYpz2MZKGBmry6uNK7XXQ6mnaVMekRPYY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:Subject:From:
	 References:In-Reply-To; b=nOZN5Vg+Ye6aGQ8QfTBW7NtqpmoonwkhSI6TbiBHLem9axudLJIu/X4rB4F0eDimqBM5AmvLUoCpjU/pAYCgJcAiQ71d2uLHn4pyBaqtUMfgiZ3nCvP5GVMCR56e3wkWhE/uryqi84UHDMB7levIa+x3Xi15M/nVW6NHDEFh5yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iC3iI1qV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50R21f5l018493;
	Mon, 27 Jan 2025 09:34:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JZPl4Z
	oPyL3v99sfskpHncvQjc3pCaaFBJ9rGh6uWsA=; b=iC3iI1qVbaRGjtUhUUHJyG
	yGKwZo5HGVa9f6WUKav7m3emHx/vDBweQbcfJBTBDT04imwMc+0cypBLciq+Jhr8
	lQnliqSyivil1rOKO1Z6z5IPLZLn68EBpOnqJZ37eKZLL9z7pSuSmvgyYmU6Erkb
	JG/6lAsA4KKGssXnwBUxI8FiXwSAsD6QTR0E9PsCbvmOhqv88V282jVvfpU4/TbZ
	BQ44alzgq+4USgEf/UNknUm/sqOM8yeHeBRxKdGQpNlKlCS+isTcr/UbjLzFnX4j
	P86J23bpSNPgmfCgO9bf7GCysRh8yQt+jabVcd701VEavxBEsFwC06DdOlpUwaVQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e0yy9hyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:34:17 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50R9C4lC024172;
	Mon, 27 Jan 2025 09:34:17 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e0yy9hyh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:34:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50R92ll5022538;
	Mon, 27 Jan 2025 09:34:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44dcgjdbm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:34:16 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50R9YDxM35586412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 09:34:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE467200A2;
	Mon, 27 Jan 2025 09:34:12 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB7B8200A1;
	Mon, 27 Jan 2025 09:34:12 +0000 (GMT)
Received: from darkmoore (unknown [9.171.61.145])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jan 2025 09:34:12 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Jan 2025 10:34:07 +0100
Message-Id: <D7CR3T7AEARE.30RI8O3LPCVAB@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>, <pbonzini@redhat.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 13/15] KVM: s390: remove useless page->index usage
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
 <20250123144627.312456-14-imbrenda@linux.ibm.com>
In-Reply-To: <20250123144627.312456-14-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sAvqp1fe59cN1Lhc8v5IVUxr1njW6Eh2
X-Proofpoint-ORIG-GUID: iZbzMFND6OqABiXrawUv3S7XkZBKnMAY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 mlxscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 mlxlogscore=960 suspectscore=0 spamscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501270076

On Thu Jan 23, 2025 at 3:46 PM CET, Claudio Imbrenda wrote:
> The page->index field for VSIE dat tables is only used for segment
> tables.
>
> Stop setting the field for all region tables.
>

LGTM

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/mm/gmap.c | 9 ---------
>  1 file changed, 9 deletions(-)

[...]


