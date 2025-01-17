Return-Path: <kvm+bounces-35777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C995FA14FC5
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 13:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00DEB163EF2
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 12:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 343761FF7A0;
	Fri, 17 Jan 2025 12:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QfIJila0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E3D1FECA4;
	Fri, 17 Jan 2025 12:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737118725; cv=none; b=F87MLdqflZnjzWUwwtWueS4jInRnY/8I4A9r6+iMAnO4nB1SRHkcurNlh4X/PY6ZCBd8eIVeMduZoAwo6PBOPbq2lvy4TQKCaD3+qim1OoHjuvFI2I/W3R/7bcC+Uyufq/FzbrVpxvUe2LorYFXpABhNJqmIvKkXP3UxSGz75k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737118725; c=relaxed/simple;
	bh=YD19YxXNRRMHBrmLorteT0D7/wsERKYK0L6r8ikq5NI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ErqLdRr0ml9rPamKIxZMrBg23qS42gdSTyZJIqnWg+KOlnNT/PJqlZzk7OQqD+xPyjPJAx9ppqVGaB7419sSaGq8RfBd8jzpArbWsHKv02TnX4kvlq4AMDLZT9wJBNGwpWTqva/6hAbhqZGHyk3AN6CAii3Np9/2iblONfxdLEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QfIJila0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50H2aXhT025432;
	Fri, 17 Jan 2025 12:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=t7yjvVA8UYu3p7vVY0XCQB5vKiTBDf
	GEHD2VFpRcVZw=; b=QfIJila0kijgtTcI3zxJ5Vsy0v70UDpATHnXR1YWTFbGcn
	yZOKzOLbR7BixVoWoVCyHRpjuNlxhx5P3WTCwXoitutKUbkviaAi8eO538lVBxkP
	Zl8QnxPIai8YRA88ncsaf9pxWM6xHvFodyXOElegmWSFg12zXbi+SXJu3odHs6JN
	rtPtGDvzKvxmQiqO2K0wUt4KWLqIs7EJGOf29VrZC0r7X+bWS/xJiYNZ7Yj43I27
	wEfuwLHTto4GikI8j2c6EkmQZsQTyYo1ZZ0hpq/VJcqWFTsfrtda4rHe4b73ZEAC
	0oN0/dGSHo48mWMtg+dD8o9OwGgKQ7R0Yr7hAqFA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4473k5dfbe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 12:58:37 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HCqZUd023285;
	Fri, 17 Jan 2025 12:58:36 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4473k5dfbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 12:58:36 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HA5EK4016991;
	Fri, 17 Jan 2025 12:58:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fkjw47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 12:58:35 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HCwWg846596442
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 12:58:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 01B332004D;
	Fri, 17 Jan 2025 12:58:31 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A7172004B;
	Fri, 17 Jan 2025 12:58:31 +0000 (GMT)
Received: from osiris (unknown [9.171.89.28])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 17 Jan 2025 12:58:31 +0000 (GMT)
Date: Fri, 17 Jan 2025 13:58:29 +0100
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, schlameuss@linux.ibm.com, david@redhat.com,
        willy@infradead.org, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seanjc@google.com
Subject: Re: [PATCH v2 12/15] KVM: s390: move gmap_shadow_pgt_lookup() into
 kvm
Message-ID: <20250117125829.35597-A-seiden@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
 <20250116113355.32184-13-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116113355.32184-13-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8i4Spq3ran7A_3RHMERtefliSMYmIe6P
X-Proofpoint-ORIG-GUID: 3enH76_vxFsdFLMe4hQePoqT7GXAO3Vs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxlogscore=629 impostorscore=0
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170100

On Thu, Jan 16, 2025 at 12:33:52PM +0100, Claudio Imbrenda wrote:
> Move gmap_shadow_pgt_lookup() from mm/gmap.c into kvm/gaccess.c .
> 

+1 for the replacement of BUG_ON with KVM_BUG_ON

> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>



