Return-Path: <kvm+bounces-20140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C705A910E16
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05475B27B2A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095551B373D;
	Thu, 20 Jun 2024 17:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Oc8Wh65U"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8748517545;
	Thu, 20 Jun 2024 17:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718903206; cv=none; b=s6xPrZZI9qYXejjOSQcu53ZZZWzzMA53jtXF/jtvO4XH16cS+vpZnFDL/IeMTJ/LPFdwvurLZEeG2qQHMRhGV0kAM8//ZD5Zlsj0/VwM4LAlaSRX13JZZgvEIJWgaeUjV14v27NKF0U+DKlakQrRhwRMcFx5+EXikbbRxy2iG/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718903206; c=relaxed/simple;
	bh=W5bIaj3t01D+OngCirNcbyfM6uH6oLjFO9RCSYUWzKY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YBK0myS0RF3/I3TQ5Jl7rc33hvWSB3Y6IXx8PXY7B7/G1XrXnIh5vZP6i+dNiUhagK7VaE75eCO0+xuTVLSWMWTrfNftyK3GXc4LH45AyDm34PAiZFabRng3nCmg72tSmCh+SUF65JYirbrhSrEC3BYMkISh3mIUSjNGZiXYSfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Oc8Wh65U; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KGvFh9023276;
	Thu, 20 Jun 2024 17:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	iUi5t5v5ms4Pjyoc3YxN+V61ALGrsEwXMdntWJ06Wd8=; b=Oc8Wh65Ul7ivQl5H
	3YqQTCsBZ7FGrmcmQr/rvHy2Sd5Klj3q2asfnrxw2sVMd+CKGcocYyuEDpwAgAcM
	L5kKH0P/VLJVdClFoNZ+h/e3b0Czc3c6oyaTCoOX4PQ8V+SUy/wJwUnPmIJJsx+2
	kzQ4GUDGoR0vDel2B2ndEtKpB8OHiSTqIMnDPC5vhexM2iRihArSebzDxB7OgfeW
	mC1vtf9Ud84ppjlXyy8pyGvauWdycp2mWYTuMJXjWZQ7j/txxd9HZSB5w6AFPgql
	7t+lPQhWsS6oAYC4OZrIUz0L1gpwv+8s6ChCcuc5K2m+ETp9/1OAnfSClWk9Jxck
	iSYvig==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvqymr32f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:32 +0000 (GMT)
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KH6VHF007510;
	Thu, 20 Jun 2024 17:06:31 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvqymr32d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KGG0FW009422;
	Thu, 20 Jun 2024 17:06:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysqgn7xft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:30 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KH6PEf50201044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:06:27 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED26820040;
	Thu, 20 Jun 2024 17:06:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F52E20043;
	Thu, 20 Jun 2024 17:06:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.47.175])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 20 Jun 2024 17:06:24 +0000 (GMT)
Date: Thu, 20 Jun 2024 18:55:44 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>,
        Nico =?UTF-8?B?QsO2aHI=?=
 <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        David
 Hildenbrand <david@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: Add library functions for
 exiting from snippet
Message-ID: <20240620185544.4f587685@p-imbrenda>
In-Reply-To: <20240620141700.4124157-6-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	<20240620141700.4124157-6-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CXey2-QsoffDXP2UMeNL2HdLKeZzHMeg
X-Proofpoint-ORIG-GUID: Rd752exL4rGuCthSitPw1fjpjIJRwTDl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_08,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=714 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200122

On Thu, 20 Jun 2024 16:16:58 +0200
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> It is useful to be able to force an exit to the host from the snippet,
> as well as do so while returning a value.
> Add this functionality, also add helper functions for the host to check
> for an exit and get or check the value.
> Use diag 0x44 and 0x9c for this.
> Add a guest specific snippet header file and rename snippet.h to reflect
> that it is host specific.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>


[...]


> +static inline void diag44(void)
> +{
> +	asm volatile("diag	0,0,0x44\n");
> +}
> +
> +static inline void diag9c(uint64_t val)
> +{
> +	asm volatile("diag	%[val],0,0x9c\n"
> +		:
> +		: [val] "d"(val)
> +	);
> +}
> +
>  #endif

[...]

> +static inline void force_exit(void)
> +{
> +	diag44();
> +	mb(); /* allow host to modify guest memory */
> +}
> +
> +static inline void force_exit_value(uint64_t val)
> +{
> +	diag9c(val);
> +	mb(); /* allow host to modify guest memory */
> +}

why not adding "memory" to the clobbers of the inline asm? (not a big
deal, I'm just curious if there is a specific reason for an explicit
mb())


[...]

