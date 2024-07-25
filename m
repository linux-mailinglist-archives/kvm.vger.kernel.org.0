Return-Path: <kvm+bounces-22246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C02993C44F
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9D88B218E4
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347FE19D066;
	Thu, 25 Jul 2024 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QOH5ntOJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B4719A29C;
	Thu, 25 Jul 2024 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918302; cv=none; b=KK2SSmmMz3l/UOUT67PxhcL7knSaA2zmQTh5ziio0eB25/K9iKvuXPr0RYoXm3YuakgIy8i+TMtLkogsdDp4RdONjUjLvtL29QzayTvfW4e/SIJtfnfiOBcyMlfo/08n6sumxlz88nMmXCy/fsPLEQyga/CwUcDyeRsu+zHbJP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918302; c=relaxed/simple;
	bh=NxtZ73jMLiDyIiAN1MUe+pQ4SClf3C8PbhOwJoAqKKw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kFj6l/kY3rkK/CX1sMfhMxdxnaB/2L8+njpF6QiLMFFnUa4JO5ZyqwAjlEA/zWmj193TJMPUhZE0Ck71VqxQzmfK5Ou0uEs7/f0dZQxUa7iPL5eSzL0+L7D4jawY8iboDaywQTtcRh/om9wFQ0hvGJHibgfazTxaN3KALXCzKGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QOH5ntOJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46PEbvUJ005805;
	Thu, 25 Jul 2024 14:38:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	lXv0LFWLv0f0rNslTfeGlGBVJvuyxaXBeFYOO6Bg2Ow=; b=QOH5ntOJQ4eNDDeP
	Ev199YZQgffeCUUscnJ6koTA4rRtwkO7b3+OoKfcQxgOwTt2+L6uZU5U2sXuWEEt
	IgX+RMJe5Grt2utHzjDaiRFUbDO+pmfe8oNtEOV9TO+NxyE8kOIkU4hjyf2nKrSp
	RInXxF+ChJZHM7Z4x9muK2+z/6iDavP1shVGRdyKjMmb3yeBTsqPF6aoCoI4ySpa
	eH60Ut0H52LfO/MjBIfbv4e2EvAbvMjVXrcuky0XHRW+w2hwtRIRXhWeQz5tpUb8
	hDHVMv3pPBlPqjGtmukqGBZx2r+/DIxiM/94jN5Du7ybLtKacI/gZM9ZB7jdnxGA
	Mi/osg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kr2b83ad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:38:13 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46PEcCtv006893;
	Thu, 25 Jul 2024 14:38:13 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kr2b83ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:38:12 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46PE52aT007058;
	Thu, 25 Jul 2024 14:38:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 40gx72x7sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:38:11 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46PEc6Jx58917318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jul 2024 14:38:08 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6743420049;
	Thu, 25 Jul 2024 14:38:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E70A320040;
	Thu, 25 Jul 2024 14:38:05 +0000 (GMT)
Received: from darkmoore (unknown [9.179.29.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 25 Jul 2024 14:38:05 +0000 (GMT)
Date: Thu, 25 Jul 2024 16:38:03 +0200
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        nrb@linux.ibm.com, npiggin@gmail.com, nsg@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 4/4] lib: s390x: Split SIE fw structs
 from lib structs
Message-ID: <20240725163803.2685ed8b.schlameuss@linux.ibm.com>
In-Reply-To: <20240718105104.34154-5-frankja@linux.ibm.com>
References: <20240718105104.34154-1-frankja@linux.ibm.com>
	<20240718105104.34154-5-frankja@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: KROLJovr5t7884vnxipnwzxMl2XJSdK2
X-Proofpoint-GUID: xF3xI_hCHmwPS43P-WVAjEq0_XqGM3Io
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-25_13,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=649
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407250099

On Thu, 18 Jul 2024 10:50:19 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The SIE control block is huge and takes up too much space.
> 
> Additionally sie.h will now only contain sie lib structs and
> declarations so we have a clear divide about which header contains
> which things.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/{sie.h => asm/sie-arch.h} |  58 +------
>  lib/s390x/sie.h                     | 231 +---------------------------
>  2 files changed, 4 insertions(+), 285 deletions(-)
>  copy lib/s390x/{sie.h => asm/sie-arch.h} (81%)

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

