Return-Path: <kvm+bounces-22313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF60293D1DB
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 13:14:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87E78281D13
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 11:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4863317A58A;
	Fri, 26 Jul 2024 11:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D9/hNaTY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1D61EF01;
	Fri, 26 Jul 2024 11:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721992482; cv=none; b=ZRP9We0Awq5kwSkoih6/r8N7uWhSSS6yXR/Ohlv7nTnZMIUmo4PJBI6BNTkfftzzzTz6VRBU0gzvz8cvmncOKiKpA91b3c/WjmOF4hJO7mlcs+AO+BEw2SKk0KJFObOK0MnSwzfvMXpVJcjnS2mBPQ5vCD7U5v83VJS4DRP+CMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721992482; c=relaxed/simple;
	bh=nq7UpSRWHcqF6uFM4jUqHpH6ZGUkj46anBoNsddMUnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HSllAZaoGKO0z/SG0I9/odcfE1il17Lwg+eWBhDTZHDUOtNjamlF+s17ivZHx9udD/3uAN545UF2Pq+VY9P5PuX0gUImSHPdgc+ouDHNNjmlVOpnlrh3vKADiPa7ryFmyDvi7xkowUhxILD1HC0yMO6aOekGw+VmE1s6nanNO7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=D9/hNaTY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QAHlA3003321;
	Fri, 26 Jul 2024 11:14:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=pp1; bh=RyOFNbu/oCj90l0px/Bn+OUwEu/
	+PEk8SRsUJ69RLM4=; b=D9/hNaTY61aM1LxlR7WvyP3xZSmhCNhjARYZhPD336o
	QVEWdwCPVpRde7p0Mcl7grITuif7+vPlLhYoJlAassbs2poyMwJae5iyl4H27Q2i
	pkop3CXu7HD7QwUf2jK0cp0ESN7pmM4OFcSy9xlngfHl3knxe60VScQzlQbCc8eY
	C1HC8hfKklnVn/Ic3eSoPOQRdQksrwv/+Sm+m6EqqgT5TrKjsfAMeURKFy0jYFyP
	6vM3au16CHFNR9GsCIluDAaFM+JlYcW3vM69yk05+A9Svhcc+VUXbV3IPw27epAi
	kmd4Ux8I0cyk7OVPpt5tgeYxCrfZ+YQcq14bY1Kroqg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40m2kv91yc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Jul 2024 11:14:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46QAEmj3006741;
	Fri, 26 Jul 2024 11:14:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40gxn7tncv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Jul 2024 11:14:35 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46QBETCB20841062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 11:14:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 929F42004F;
	Fri, 26 Jul 2024 11:14:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0233220040;
	Fri, 26 Jul 2024 11:14:29 +0000 (GMT)
Received: from localhost (unknown [9.171.57.197])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 26 Jul 2024 11:14:28 +0000 (GMT)
Date: Fri, 26 Jul 2024 13:14:27 +0200
From: Vasily Gorbik <gor@linux.ibm.com>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] s390/cio: add missing MODULE_DESCRIPTION() macros
Message-ID: <your-ad-here.call-01721992467-ext-6555@work.hours>
References: <20240715-md-s390-drivers-s390-cio-v2-1-97eaa6971124@quicinc.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240715-md-s390-drivers-s390-cio-v2-1-97eaa6971124@quicinc.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cq9JifpQ1w_724O1FBr6BmHfBcQYbGui
X-Proofpoint-ORIG-GUID: cq9JifpQ1w_724O1FBr6BmHfBcQYbGui
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_09,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 spamscore=0 malwarescore=0 mlxlogscore=704 mlxscore=0 priorityscore=1501
 adultscore=0 bulkscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2407260072

On Mon, Jul 15, 2024 at 08:58:51AM -0700, Jeff Johnson wrote:
> With ARCH=s390, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/s390/cio/ccwgroup.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/s390/cio/vfio_ccw.o
> 
> Add the missing invocations of the MODULE_DESCRIPTION() macro.
> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
> I hope this can get into the 6.11 merge window.
> I originally had almost 300 patches to fix these issues treewide, and
> this is one of only 13 left which have not landed in linux-next
> ---
> Changes in v2:
> - changed CCW Group to ccwgroup in ccwgroup.c description
> - removed "Physical" in vfio_ccw_drv.c description
> - applied Reviewed-by tags from Eric Farman & Vineeth Vijayan since these edits
>   seem to be aligned with their comments
> - Link to v1: https://lore.kernel.org/r/20240615-md-s390-drivers-s390-cio-v1-1-8fc9584e8595@quicinc.com
> ---
>  drivers/s390/cio/ccwgroup.c     | 1 +
>  drivers/s390/cio/vfio_ccw_drv.c | 1 +
>  2 files changed, 2 insertions(+)
 
Applied, thank you!

