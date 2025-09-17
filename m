Return-Path: <kvm+bounces-57888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A29AB7F34F
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:24:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E7687B385B
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26552275B1F;
	Wed, 17 Sep 2025 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h+J/0QKY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7941E1E00;
	Wed, 17 Sep 2025 13:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115470; cv=none; b=PERgSVGgNRs6AoQn3MdUS1aMKrmISkX+8OpynXWjruBtu9/o862bzEpJu3Ruunq6WjsMakGVA/gRkQpCdZMyOnVS7UOAfmPPnzhHYGf77hH4L4rp7fxKgoJpp2ViB9XRRDi38jLquoF5snhKJkA63vmPIZVWXAb79k9glow49WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115470; c=relaxed/simple;
	bh=BHPjlWNAv/+b8k4p2T1rR6lchfks3iroKHSZC1kIvQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mS2ewl3COR1oXGuQjWldSOXY8vwz567J6RLzFAn20AQT9vSe6A6AxM0feImGzKoayPrMdIGO/j4fvLIY+etk/7OsG+7Q/b55eFb+8nrZxgaiGjHTDw/OmscaRMSGWRFX1KGF1p66Tiu8T/auyrUegMvGHAjR9JnlbYa3Rrzl4IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h+J/0QKY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H3V0uo006031;
	Wed, 17 Sep 2025 13:24:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KxQ5Xz+NC/DILasqGWSjuN/h8ICPEa
	KLncDjz2PtgFE=; b=h+J/0QKYuSnHJPLERTFMIPqePckuiJTcLBg0YZsxcrsEQj
	oXMiQ3l6zDY6ZZCVV5d6waEe2wWpySHE/RKmz40Qd8/28XRBnR6mtKTr6L/ftL9K
	S6mAFZtFWLXKtQmCTSq2JMdfYOU5cO8X9rpFL0R/R1LYw47cx1O5fvXsH9/vMtpk
	9VvLWuObjWZ8v66f6dvJZrvyQr8e7vOWckWV3346QkWvS3ximsQKkMz+FWhrYGEn
	GF8GMDWGuwO3SJRkHHZ4278iLmsZcuhwDG451BOOkWL2J34CZuD/dBzEKVtQOR3M
	3YAGRxrf0+JcLyEarfQSOwv5pCVnCXlVX9DZbmUw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4nbqp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:24:26 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9m7pX029484;
	Wed, 17 Sep 2025 13:24:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kb11kc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:24:25 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HDOLVs47841598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 13:24:21 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BDF320043;
	Wed, 17 Sep 2025 13:24:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 22D7C20040;
	Wed, 17 Sep 2025 13:24:21 +0000 (GMT)
Received: from osiris (unknown [9.152.212.133])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Sep 2025 13:24:21 +0000 (GMT)
Date: Wed, 17 Sep 2025 15:24:19 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 10/20] KVM: s390: KVM page table management functions:
 walks
Message-ID: <20250917132419.7515F61-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-11-imbrenda@linux.ibm.com>
 <20250917125529.7515Df6-hca@linux.ibm.com>
 <20250917151344.75311b9d@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917151344.75311b9d@p-imbrenda>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68cab68a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=P3GBcywSR8f11hdwqmkA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: xrqs_JC4jpaODsEFO6CIHPn4FGKVhZRh
X-Proofpoint-ORIG-GUID: xrqs_JC4jpaODsEFO6CIHPn4FGKVhZRh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX1W4xnEnA9AHz
 mRNoRAYHE2TrtY+rtiycmNnaygF/87uM9K/jPve6UEvBsZD3b8+gIEr7jmNeC3J0EXi5/6BOTnk
 PvEGZGPy4bRaxyihoD8fQfFzwJj4JmgLEu0ZBoNhzCnwsQ7SNSvmgR3GBirig/4/6afCk45lsIS
 puk1FnXuol1P9W0hFbTeBCLn3PfGjakjrUs2dPrDFi4Ml1QXS3bSPkaSOvfhvq0m3o9mRSJkcG7
 +cxuR3BYyHjSrOBScDtUsjdky7qCnGkEUPTAY9aq9bknOsvE0erYo+OMQKGD0BgcxaBhKiVHNO6
 XBzFcYbZ4Z5T22vFHO1U6DUCc7TcG3uxJaqcgbCINUBgUsMlDQeJ7zZ26vtcHmrLHcTj6fuN5XD
 Z2+WDsws
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, Sep 17, 2025 at 03:13:44PM +0200, Claudio Imbrenda wrote:
> Heiko Carstens <hca@linux.ibm.com> wrote:
> > > +	if (continue_anyway && !entry.pmd.h.fc && !entry.h.i) {
> > > +		walk_level = LEVEL_PTE;  
> > 
> > Hm, ok, there is no TABLE_TYPE for this level. Invention required :)
> 
> yes, this is why I have the LEVEL_* macros :)
> 
> do you think I should instead  #define TABLE_TYPE_PAGE_TABLE -1  ?

Yes, I think we can go with this, plus a comment what this
(impossible) TABLE_TYPE is good for.

