Return-Path: <kvm+bounces-35661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29CEBA13A2B
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 13:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CFB31677F0
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852441DE89B;
	Thu, 16 Jan 2025 12:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qZCIV2cd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5230D1862;
	Thu, 16 Jan 2025 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737031591; cv=none; b=GrPmvdW7jT0x9N47owjaUjYpURnG9GRjR9zwINXaqbzfxGhisYK+6CXdOLkTpFOIAXuz1vuPoomDqyoENKIf7AjBnAEKEomMz8PJIN0D7hVRw1RKR7dlW9wJ8jiM/eQXYghF+5PJ71P2vbI36yq/daUAucFbtT8E4ezEP7nT7J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737031591; c=relaxed/simple;
	bh=CSZi2vuSwVAuEMKgEUD1yq79UGp0rUX0nY6XcGzVHuA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q8tXhxRDc+J8wPmTSEgYOOAM5u5IsFLm565VHcC7UWHAKKJNEOs1s3BP8Or+uFNcEuvaJvwwX+8xmiE1Hjrynib+2SZXkaW1jPBrbcaH1rPhKtkYodVdtL0zs6eeB9u+R8/xJUK/11wW5A4ikG/nYqXn/xR8jDpw7isMgmlYdRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qZCIV2cd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GC0DEJ024474;
	Thu, 16 Jan 2025 12:46:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=r4MsKn
	w7exanSMf5ImFTCKudH90P9LRAoegjqoMX0zQ=; b=qZCIV2cdrlz25YznaRJdu/
	w6Wm6woJafe38GtAHiIuRO7FF1RRtao2A+lcCLTA9TpCGIR9CM7ouLGZP7JRh+wI
	1KH7P3WfN3awZX2wy1Poeh3oqPC+zw8vhS+RFlE79X7BYwaEdP3QIa7jGJb+43PE
	7PxhAYWzTPpery1HaCoFPHO9Gf4crR0TSYj1RI2CsAZJADEKPeTb+xrMZUFZtl7x
	5fIzhgzto5GjPizeE6SEQL8nwbwrQSSSmwVkR4JKmOZemAczBQq4pKtJ/3M5njHV
	tA10jzZgvjP83Oee/PTfKn4Fx4FFMdeK0WB7Vg7psVUIG8PCX2T3gfRDpOwIRyXA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446pub32x5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 12:46:25 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GChnXd017491;
	Thu, 16 Jan 2025 12:46:24 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446pub32x3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 12:46:24 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GATfU8017003;
	Thu, 16 Jan 2025 12:46:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fkdsj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 12:46:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GCkKER61407670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 12:46:20 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 186C920043;
	Thu, 16 Jan 2025 12:46:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1A1020040;
	Thu, 16 Jan 2025 12:46:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 12:46:19 +0000 (GMT)
Date: Thu, 16 Jan 2025 13:46:18 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: Re: [PATCH v2 04/15] KVM: s390: fake memslot for ucontrol VMs
Message-ID: <20250116134618.1fdbcbef@p-imbrenda>
In-Reply-To: <044e5980-e297-4b24-b19a-c257a845097a@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
	<20250116113355.32184-5-imbrenda@linux.ibm.com>
	<044e5980-e297-4b24-b19a-c257a845097a@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dd4jS2nQqwSCAD1JFtxcSXE_MpjXfdfF
X-Proofpoint-ORIG-GUID: JiKHqj1zIlxy4mIoicMdyhkSee9TTKcC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=897 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501160094

On Thu, 16 Jan 2025 13:42:50 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/16/25 12:33 PM, Claudio Imbrenda wrote:
> > Create a fake memslot for ucontrol VMs. The fake memslot identity-maps
> > userspace.
> > 
> > Now memslots will always be present, and ucontrol is not a special case
> > anymore.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> You'll need to update the Documentation because of the ucontrol 
> EINVAL/EEXIST return change.

ufff that fell off my brain cache; I'll fix it

> 
> I don't like having EEXIST as a return value but I also don't see a lot 
> of gains in changing common code just so we can return the correct rc.

