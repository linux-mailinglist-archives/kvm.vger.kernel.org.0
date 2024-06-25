Return-Path: <kvm+bounces-20459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0AE491623A
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 11:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D30A01C209A7
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 09:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1DC11494D7;
	Tue, 25 Jun 2024 09:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dRa7qmGQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174AD145B3F;
	Tue, 25 Jun 2024 09:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719307307; cv=none; b=ULwxWct4ZnVAulTWwqMQ1NZasPB/75kJwUE8qk5X/MQ5Sxdp9wP8B5bDm0S/MyNdWxI9BFpbcbUgZLYCmL7dTaOTc+wjMNExmMz6k+bRzFbyWEA5j/PvQFIK15W19r7/CgyH1jIR7g+xUGR9fFmEy+kmWuBRyzkMoL99kaLnBtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719307307; c=relaxed/simple;
	bh=hnU3omZlmMZh1vhpWt2+NMDB8KMPZOwFnj7OHHhsABg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E8VZRlhMyvbyVcBKUeqVq3nUNGWkA7r3kgDyk1+WuaJ8AX96DWu1B++ctFSA0Y+IMSR+RsXDUOs3o5+QosHWgjP+bBfec8ilK0Vh3rgF277RyC6CRslqC3FeA6Ldu97lJa1B5yKPmJ0H8CrN+Yg7vLtitpIt0hlk1rqBRg8vAQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dRa7qmGQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45P8wpTi026719;
	Tue, 25 Jun 2024 09:21:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	ufmEsx1UviyHkEKREuD0vhSCbri5jiZaKQiIDgfjJ1o=; b=dRa7qmGQ4UlDlvx/
	F60znFJeCVDud4lZKBEO7Y036bESKTkjl4WHQNEy0aHMofP0+WgVtQGgJpaXMNeB
	YxHxK80FU7SCFbQwzY9lvFYwN6qeuI6G51WreUEkadXZ5ALApt80H/VyVw/ygOdi
	NC+Y/NICaVqi8aOnBlHItPGI0YxnC/g/Rsf4GD1PXAYmjI9P2wWVUyTNBjQFR1Se
	eLIid+1DwlbDV9QiH6HznVaLTEog8J83Ef9wvDt7Cy0pOyHLouZYCDGJw8qe/394
	w/8/yL2p1V8VHkvFWYS7IDXxZAY4QMvDDRzMkam8CIBsUJv7Wqj+94xUflBVYjjz
	hSxhMg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yytur01wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Jun 2024 09:21:36 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45P9LZ3s029394;
	Tue, 25 Jun 2024 09:21:35 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yytur01wp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Jun 2024 09:21:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45P6OcwT018115;
	Tue, 25 Jun 2024 09:21:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yx8xu5tmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Jun 2024 09:21:35 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45P9LTuM49807774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 09:21:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D5DB2004E;
	Tue, 25 Jun 2024 09:21:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6593B20043;
	Tue, 25 Jun 2024 09:21:29 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Jun 2024 09:21:29 +0000 (GMT)
Date: Tue, 25 Jun 2024 11:21:27 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Nicholas Piggin" <npiggin@gmail.com>
Cc: "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>,
        "Thomas Huth"
 <thuth@redhat.com>,
        Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        "Janosch
 Frank" <frankja@linux.ibm.com>, <linux-s390@vger.kernel.org>,
        "David
 Hildenbrand" <david@redhat.com>,
        "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: Add library functions for
 exiting from snippet
Message-ID: <20240625112127.094b20c8@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <D28RE8616U75.1D66ANONJOCI6@gmail.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	<20240620141700.4124157-6-nsg@linux.ibm.com>
	<D28RE8616U75.1D66ANONJOCI6@gmail.com>
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
X-Proofpoint-ORIG-GUID: XSjvIR57HtNqz89Z_stxqVswDIQWe5GK
X-Proofpoint-GUID: ngCVK7BhH2TvgvImkEQ6I8OKx-SiB5fw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-25_04,2024-06-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=670 adultscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406250064

On Tue, 25 Jun 2024 12:57:11 +1000
"Nicholas Piggin" <npiggin@gmail.com> wrote:

[...]

> Hmm, you have a nice instr struct that you made earlier and now you're
> back to mask and shift... What about exposing that struct and add a

this is actually a nice idea, we could make a union of the structs for
the instruction formats we need, and then we can do what you propose
here

> function to create it so you could do grs[sblk_to_instr(sblk).r1]

probably something like _INSTR(sblk).${FORMAT}.r1 

> here... Just a thought.

and maybe we could do this for the kernel as well

> 
> Thanks,
> Nick


