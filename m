Return-Path: <kvm+bounces-57847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3FADB7EB1A
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61C474629AD
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 12:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4426732896D;
	Wed, 17 Sep 2025 12:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FKs0E6nk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DAA29B76F;
	Wed, 17 Sep 2025 12:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113522; cv=none; b=SFj/gAiAUiMqwcGtdLvxy3GmvZ3PJL8jWULirAfqrlHK5V/44hLErMq+jjX+PBVvaSq134GD/L3vS2SAyi+H1xo1govYNe8rtlqIIk3sn+ytw8eKEweDovLUZR0/3JLzUmc9IiElVM0lwml6OZzIKKJaTqinFqFX7q/QvbE+wW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113522; c=relaxed/simple;
	bh=EYyukG4hL5ZsjhQVNbRXyPJJVDil0rQq7t6BadTNwgc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UV3YfJ0792Y7P4akHAqHKy1Y4/U2gCgKv/DHKk6l/lM3du01LPVmLqxpIn3scQxxDNzAFL7uTFLN2BNOknYerLIu8uFKND+YqkYgFOzhOFNyrFcTsMUCsiMiVD4cK/BSBXOGV9ePvJURJH8PgGdodJGcKmaad4arITKGWWK0sPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FKs0E6nk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9QaBA003223;
	Wed, 17 Sep 2025 12:51:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Uo/fSy
	w5fpkYvgmvJIJMhCwCnZ73bhp6FrdpiBVMGNU=; b=FKs0E6nkJJ4Q76cF2hKR8T
	b6X7FxQ4346A4xu9jTyuRl039dw7drzmlP/wvtTwR/CtcVqd4SD8FWnUlfaoCNh3
	Uxlma1pc2AjuRS7lJuHw73RoJxVWrYQ4TAHjAchjUIG30BQAvKH+2aLv6aFi2CIK
	tfSrHMhCtWhHENW+Rd4WsuS2LA86mpsDGM/Jm3OTuBs4waA9x2xVY/X6slKrbSkB
	jeAcNP4oJAEXEP3VXcSg39wf/jWQkU06uGx1U8tCmakRxiwcnlkDYaev6Tjy8kki
	vwgBhZt3W0FNN4LBU/ojrFHW3YbGob/3DMpTJyQ4jR7fYbTbQIrPFp0bbrijgKZw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4hkr2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 12:51:57 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HBA6bq018632;
	Wed, 17 Sep 2025 12:51:57 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 495n5mh2d7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 12:51:56 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HCprCP46268710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 12:51:53 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3710920040;
	Wed, 17 Sep 2025 12:51:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 03DE120043;
	Wed, 17 Sep 2025 12:51:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 12:51:52 +0000 (GMT)
Date: Wed, 17 Sep 2025 14:51:51 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 07/20] KVM: s390: KVM-specific bitfields and helper
 functions
Message-ID: <20250917145151.76f9b57d@p-imbrenda>
In-Reply-To: <20250917121822.7515B42-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-8-imbrenda@linux.ibm.com>
	<20250917121822.7515B42-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: JFMSZ5FSUluAFQBM4TeE231t6GlZzlfz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX6cMJ3jxcKa2o
 G0PIo8kimdxHf/q65z+QNZEqgRQBRQrw+yEtF67V76PMnxyJHV3F+l5Q7k4kiwaWjoGxZV9ujHl
 3CxpfpQkTxa5v/qZA51V12ODmEhyFr7q0F9Thc+77WpYR5iOq4Vzfl9VTZDiIrlAl14Pn+Zl47R
 KTFbV49cpoZvYZS3D6uteeiHvq5LyAI+So7p8K7Dfbuy1zLS/qUqeyX0OnaLuzRhErZ2R3btBfy
 AK7eDqSJXOLuUnMHh5Qwygf2gYXN+aDwbr0yl1fIEJ/GoFJSpr0Ep9FYGbfKSnzW5EFNd/3+Vt6
 +dvhrc6K7wZ3uFh8rq3iZXngmOcYPWbG2rBjeAtd7q3+8OWOghJvwFA5V4qXXRC3cer5k4riphB
 oBqbM1/2
X-Proofpoint-GUID: JFMSZ5FSUluAFQBM4TeE231t6GlZzlfz
X-Authority-Analysis: v=2.4 cv=co2bk04i c=1 sm=1 tr=0 ts=68caaeed cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=fBYi-ClNYaykXQuJeRMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, 17 Sep 2025 14:18:22 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Wed, Sep 10, 2025 at 08:07:33PM +0200, Claudio Imbrenda wrote:
> > Add KVM-s390 specific bitfields and helper functions to manipulate DAT
> > tables.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/dat.h | 693 ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 693 insertions(+)
> >  create mode 100644 arch/s390/kvm/dat.h  
> 
> ...
> 
> > +static inline struct page_table *dat_alloc_empty_pt(void)
> > +{
> > +	return dat_alloc_pt(_PAGE_INVALID, 0);
> > +}  
> 
> This is calling a function which get's introduced with a later
> patch. It is not harmful, since all of this code is still unused, but
> still odd.

yeah but this should not be here, I'll move it to the appropriate patch

thanks for spotting this

