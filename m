Return-Path: <kvm+bounces-57900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 500A9B7FC14
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 16:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FCA02A2A8B
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795D02367C4;
	Wed, 17 Sep 2025 14:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sq8/+Xli"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DE722C339;
	Wed, 17 Sep 2025 14:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758117710; cv=none; b=Bt79wgqJ+dpAzWO+DVLkXDbaIpWR53ErLtguRXNBCPesz+vztV4Bp7S6eVgV/C/jpyAU4F3qAt9Fg43/4iPVwd00T5PMXthfHINWi2hAqZJFs5fA+wPWoNjArZ8KZATEFlN1c6Tb2WDREfUP43mTKUX2+8uhaZmnro22NdunBYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758117710; c=relaxed/simple;
	bh=Wh6ibDN0mAUHz19qYOtErQivX/ntAUj2Afr6xCQMtH4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AXm4fKQakV0wMfyByBKyRD7pcS9ieBzSXR27aQSBMiv1ZMWO7VEiBp7rVRmUeYuIrlv8AsmLUVZyJEkk6MaFGtockiSnxChUKEp4e6hZ33EtmxUU6JztLy7rzEZA3/1wz0RBjyGIdzPCI9jSQHrhXGyH/yLbKDY9Joh53PMmMGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sq8/+Xli; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9EXuU031254;
	Wed, 17 Sep 2025 14:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2HaR6X
	0NmhdFPT8aqoeT1o6hwOKLhiCuKgS7akTUIfk=; b=sq8/+XliNz5/7pDBZcP6IK
	+5VtxAGqWCr3u0CouZOj/0k3MPH1QqP+s/GoA2OGLvUFlt0LP9UckmxDWhfwYHvT
	njyNeGQ4Oe6qsBXqOYa7+wzyIOyRniheSbPJcxqtFT68Jo2BsL4lea9Eoj5eOSjF
	xaupShJV8fcCWQIt7pdFr5xqG8vA0QqpDuTaKiqSHkH6YQJRCxo2GadGnUg1ia7U
	B/yONChmUJGdkM1RUGX7WhqdXL55payN9weoU4WeXgsWLJh4t3x8Sp27SBN2qSpZ
	LQJtmQTHSs/9512jBdYwmr8vwP0PxxSnK9Hf+Vhd+0MVgfEqgWt/pYw8DGv54RAw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4hm5d0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:01:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HDWKHI029817;
	Wed, 17 Sep 2025 14:01:39 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kb11rdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:01:39 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HE1ZvS31457638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 14:01:35 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B0F3320040;
	Wed, 17 Sep 2025 14:01:35 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 763492004D;
	Wed, 17 Sep 2025 14:01:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 14:01:35 +0000 (GMT)
Date: Wed, 17 Sep 2025 16:01:34 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 10/20] KVM: s390: KVM page table management
 functions: walks
Message-ID: <20250917160134.0a2349c9@p-imbrenda>
In-Reply-To: <20250917132419.7515F61-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-11-imbrenda@linux.ibm.com>
	<20250917125529.7515Df6-hca@linux.ibm.com>
	<20250917151344.75311b9d@p-imbrenda>
	<20250917132419.7515F61-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 9zquPg0PhCxFwtT_g8iC0ZE0ELU-Wswl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfXyPM/635tU9G0
 p6URQ4xyob3FRWNbpCBZzDWrQQt0H+FevxsOrijK1E5kTCpawltCtvqladhI/X8cP/ZGSaOwHQN
 YeL6o8Qk/wB5ytasSvDr20SfsXXQ/hjJEZNV4prxnKwwkDwWR92/SRH6CK/Fgzk7u/Cpj0MklXL
 NZrknm2R/GgLBvVk8ZwdvHGa5rT6ignCJ5u7AG5gpZo9hftD4COhwxU0DAk6iL2C0HCvoBAh523
 YVeNS3xJ0kvqjJ61PcV3plQdCuTd+oJ4aPwIhK1AdQsHYBvt99kuTmBdeO9VxtPUL8Tx0wq03Ve
 OV+o1VL8oyqa8kIEdRh
X-Proofpoint-GUID: 9zquPg0PhCxFwtT_g8iC0ZE0ELU-Wswl
X-Authority-Analysis: v=2.4 cv=co2bk04i c=1 sm=1 tr=0 ts=68cabf45 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=zXP18i69eeS23WoAEjoA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2509160204

On Wed, 17 Sep 2025 15:24:19 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Wed, Sep 17, 2025 at 03:13:44PM +0200, Claudio Imbrenda wrote:
> > Heiko Carstens <hca@linux.ibm.com> wrote:  
> > > > +	if (continue_anyway && !entry.pmd.h.fc && !entry.h.i) {
> > > > +		walk_level = LEVEL_PTE;    
> > > 
> > > Hm, ok, there is no TABLE_TYPE for this level. Invention required :)  
> > 
> > yes, this is why I have the LEVEL_* macros :)
> > 
> > do you think I should instead  #define TABLE_TYPE_PAGE_TABLE -1  ?  
> 
> Yes, I think we can go with this, plus a comment what this
> (impossible) TABLE_TYPE is good for.

ok

