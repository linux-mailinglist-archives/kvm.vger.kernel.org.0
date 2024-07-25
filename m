Return-Path: <kvm+bounces-22244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3232393C437
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA4D8286EA1
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307E819DF9E;
	Thu, 25 Jul 2024 14:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HPye91ux"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C2C19D887;
	Thu, 25 Jul 2024 14:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721917870; cv=none; b=GCRSbY/zB+6m4kCzcIlelWYabIMuks2Qu5jEMBkC6Spykvj3/4mEkmDHxXuBlVkEO40ABeAg+Za0VPoOlsVBTCL8Z88kRRm8R9eRMOncOySOvoHV5nVd8mF6x1T3KMfpdxpojIrOM3e5JR4Eqxi50eFlrWv6x4eIyTUtb+5PGRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721917870; c=relaxed/simple;
	bh=qwo34jr+Yqc1IW/n+Q5UmnskrX5+TEZUzdtQoT8D3E8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ly+6MojYftbQ92M+xzMBMUsLw3nWXt6Ctu05okmPAxsp6r0u0EmhFQeiN3IIVxOAU3ZC/wIoXrimXo1CGQ9rV3H9iEV6cbQCYlYqARbaXX6NPcgzc1xbo5bK3cGx3JQZ8CVZB5mOt7k6+u1kW2eORKkwnYkrEUehS7qboFgu72k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HPye91ux; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46PELrvp013427;
	Thu, 25 Jul 2024 14:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	Opvxln9lmMuKAmMXQ0Fm0cbKqtBuGnIdwTG8fQvb/4A=; b=HPye91uxoVX4mxwx
	73qFXzZc1OnvrioN6g9Cdr8qpsdUuM84tuUoHZc5ffNGtFqhaf3Fj2Y+FEdCRj74
	TXRx1CoTjTH/2zZ55zc7es6QHK4m0zWdeKaDhjHIpqGYbmZd0EqDzlFCLZ0GSecy
	aDhYbyaWtpCO9aGNULsl3386j2WbHc/Blqf65TdnfGs+bVKT/mj6shUktih0LogW
	N7YrSDuT6DRvu6w2XuW+V6jVbSYX+CSO36lshTnMoN7hb3xmBP1s12H2tE4BBijL
	t8P76gcc4lLLvQjm4gNiq9Ds5BSb7QQnFKFsdHhzAFNoujy/HdX7ViH0xxoHT6+i
	uXR8vg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kmj3rkxy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:31:04 +0000 (GMT)
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46PEV3Wj029541;
	Thu, 25 Jul 2024 14:31:03 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kmj3rkxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:31:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46PATmQD009100;
	Thu, 25 Jul 2024 14:31:02 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 40gt93pyxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:31:02 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46PEUvIF54919654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jul 2024 14:30:59 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4395F20043;
	Thu, 25 Jul 2024 14:30:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A784620040;
	Thu, 25 Jul 2024 14:30:56 +0000 (GMT)
Received: from darkmoore (unknown [9.179.29.251])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 25 Jul 2024 14:30:56 +0000 (GMT)
Date: Thu, 25 Jul 2024 16:30:55 +0200
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        nrb@linux.ibm.com, npiggin@gmail.com, nsg@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/4] s390x/Makefile: Add more comments
Message-ID: <20240725163055.535daadb.schlameuss@linux.ibm.com>
In-Reply-To: <20240718105104.34154-3-frankja@linux.ibm.com>
References: <20240718105104.34154-1-frankja@linux.ibm.com>
	<20240718105104.34154-3-frankja@linux.ibm.com>
Organization: IBM
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4lAV_9zM3pBkurys5iyvKemRWWRNRjXs
X-Proofpoint-GUID: Nj2YqpA5-Ievt_URXIigYapKRl8_tY_2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-25_13,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=957 impostorscore=0 phishscore=0
 adultscore=0 mlxscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407250099

On Thu, 18 Jul 2024 10:50:17 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> More comments in Makefiles can only make them more approachable.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

