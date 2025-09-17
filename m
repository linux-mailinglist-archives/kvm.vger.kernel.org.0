Return-Path: <kvm+bounces-57820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 452D2B7CF46
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BBB81C0422C
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 07:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D94B3016E8;
	Wed, 17 Sep 2025 07:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gD0JbPxj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5B12F83CF;
	Wed, 17 Sep 2025 07:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758094064; cv=none; b=jX85ksH3LN/nMhjSYphUVRcRVYXk2znTKiXdx3OiYBMmE5nNwGb46393OAJe1WRjZYQLrvXRNYg54Zik+9ljXEDCm5gdNPebQ5zyDM3LYytdc+CwCDHt/GYtBaZrtYuptgQHAKiWiP8CmWy48NTFYgkcY1IJZZt2FNq3yTms0KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758094064; c=relaxed/simple;
	bh=gsFnjHZzx/dM9plsysoI8hGNXgJ+gFtacrmck6z1dc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pB0zCDpSRJgdlfVhhJ0KTAIb0vdQiDdtKqxURNSRAnxzq3XLmzEZ/Js5dtneK4gpIri9QoH0xj51r8NBcraJqdQMby2iI228EnVvbfcGIEk1TqQyks/Rkn4csog7cZpPW2aWNRG9ycBzEIUZ+frjqOe4ievrqXyxwo9j9w32BXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gD0JbPxj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GLnF4r012559;
	Wed, 17 Sep 2025 07:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=m+mHcVZgJeGPTRzDjJv0QtBk8RGIaz
	Ff/BJVf0S4X1U=; b=gD0JbPxjCPNnzIeCRqLpQ4ZfOrJ5w9uXYtnoLk5SQSQbwj
	kbSgLxO4K9wGigeFGelseI8qGU1nKu5LUbXzx5+BWh6YBX495lq/yW9YNrR9DBJr
	hIX86iw43KJHK461QOeEyId06kDLnOPcAfkUdqW+4RfFBWxrdmTXb7NifwX2A4qe
	jnV5iTmpwwOB2FYd6oE2fmZqOaw409wIVQrs7QGh+sqAIBqptwMBx51ooBgj6wGj
	Ccembr+G7D9Zn69ViMtaRtVs+PcboQB6Ysg821MD9JHUO+M47PqBmKzAADOGJMGX
	r8o+TErcq5XCX7MXJUxS7kbvDTClbiBuZnqM+j6A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4n9ypx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 07:27:40 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58H3wWUv008988;
	Wed, 17 Sep 2025 07:27:39 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn3fqq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 07:27:39 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58H7RZOF32375074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 07:27:35 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 74CE72004D;
	Wed, 17 Sep 2025 07:27:35 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0BCAE2004B;
	Wed, 17 Sep 2025 07:27:35 +0000 (GMT)
Received: from osiris (unknown [9.152.212.133])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Sep 2025 07:27:34 +0000 (GMT)
Date: Wed, 17 Sep 2025 09:27:33 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management functions:
 allocation
Message-ID: <20250917072733.7515Af5-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-9-imbrenda@linux.ibm.com>
 <20250916162653.27229G04-hca@linux.ibm.com>
 <20250916184737.47224f56@p-imbrenda>
 <63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
 <20250916190514.1a3082bd@p-imbrenda>
 <15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
 <20250916173644.27229Kcc-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916173644.27229Kcc-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68ca62ec cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=gwvFe6Z11aishqNQkKAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: LwMChsghrR5NP95t40TEukrGCyPeXAx3
X-Proofpoint-ORIG-GUID: LwMChsghrR5NP95t40TEukrGCyPeXAx3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX+/R+iIPj9MD2
 0WXDahAsnm8TOgYELEVPn1o5eXxPPWPwSOhAJ6EL9wj/4AyeeJi+auvQEJdzptF/QAX61mJgB3b
 GSlCyAfzTzrKoV3uu9Y+cbjRmkWPd7p0g7am3L0BCcWAUv+l/Xgh43c8MqkBOvxMd9wY8i7ASYN
 CG86OMBXUInww4+7AIkAYjwulh/wkZJVodQSggCRIZUAlf/hVQPbBECgoCk6RZ9/mAa5p9hi2Ok
 9f+LBfl6q8s7c4B4ZKkZFlgnZ5z/NOFji8OWuWLNhYWDbbirShofWSrFPpOSRlM2nUYT6BKv07v
 GQiDPguKyb4VcGtIJhAxXTR/IwKk5Hov20mF7CvQKj0WtaYjmAcgrKdltYm0S0WivPUK/Vn6aCf
 YEdFwIeU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Tue, Sep 16, 2025 at 07:36:44PM +0200, Heiko Carstens wrote:
> On Tue, Sep 16, 2025 at 07:06:06PM +0200, Christian Borntraeger wrote:
> > 
> > Am 16.09.25 um 19:05 schrieb Claudio Imbrenda:
> > 
> > > > > I think GFP_ATOMIC actually gives more guarantees?
> > > > 
> > > > In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
> > > > are usually the atomic ones.
> > > 
> > > interesting... then I guess I need GFP_KERNEL | GFP_ATOMIC ?
> > 
> > No. ATOMIC always means: can fail.
> 
> So GFP_KERNEL alone is what is needed here. It is undocumented that
> small GFP_KERNEL allocations will never fail (retried for ever):

Another correction: it should be GFP_KERNEL_ACCOUNT instead, like it
used to be before in gmap_alloc_crst() since those page tables should
be accounted to the process which is allocating them.

