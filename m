Return-Path: <kvm+bounces-30002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 813469B5E94
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 10:19:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 380FA1F21E46
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 09:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73F41E260D;
	Wed, 30 Oct 2024 09:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ki6BJql5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE0F194A73;
	Wed, 30 Oct 2024 09:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730279924; cv=none; b=anYKV3L+cnwaemNXGlpar11eK7T7H+7EpvXC7l8qzAs0ayhELeZ6qTl1liOdIJk1UUU/eP1j2IXMBEH1k9Z6rDlue+lbMa/VNAO7CpgDjcSFBQT2qFmvlhn+P6kKbCx3vCLGvK7W+2vR0jX78N6Nuyh5Xa8Z78ltaUse/tWuPbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730279924; c=relaxed/simple;
	bh=DJlFyUMChjfN+756RIsG2FpiJfCCK2jtO/ZIvH7Yf1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fqSYPGA6VKOn8IPJ0CZw7Ke8UAYaiS8rmts8sBjTMY7rQS27RosL2qeD/rs0ZFG0wkwIZnC+LrG1+Fgk/gnysW/FBzcx6d8hZop9SHDu6bfRLSDzI+e2Gf5AJ/bd8NmwHvQGlP1JYkW75o/yHXvYagZmszk4rFBC0KS1vPM118E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ki6BJql5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U2dBFe012734;
	Wed, 30 Oct 2024 09:18:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=9tutjRh6zL7+xe1qkyCQLpNlLIzQif
	L3eQxFe0J2oJs=; b=ki6BJql58EYlhrXenigJpqKQfmxhcXd+0rUMkfMI/Zm9Mr
	1kbmbjcP5nDY8Khn4OvKTn8/XpuBYY16B5moS0DmwyGQEWdBpmV6CkYNx06jsJPB
	8wqOPu7PtGVfP4XmQPkgyE5v7tmPbnKdCe/yVp6oSoXS9/rFkpmSWOrdOVCYxi0o
	s9Pjmqol96KMfp87xPJvw6/+3qN266GQU8iIwl8HHFJLN/b/CXEg6hMBboJOC+x6
	znbj5dauSfiGP7Avt9+13isgMraeY4RTUwlbn6S6J88Ke7uSNTllu6yY7M0FZlkp
	uQIo2w8cBSg55qt3ZPtP4MiuTb1FP7VM6gE2DdxA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42k6gt2n8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:18:32 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49U9IVDR010789;
	Wed, 30 Oct 2024 09:18:31 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42k6gt2n89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:18:31 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49U6dhaP017353;
	Wed, 30 Oct 2024 09:18:30 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42harsfhvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:18:30 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49U9IRnR5898570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:18:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 425EB20049;
	Wed, 30 Oct 2024 09:18:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0338820040;
	Wed, 30 Oct 2024 09:18:27 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Oct 2024 09:18:26 +0000 (GMT)
Date: Wed, 30 Oct 2024 10:18:25 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 2/7] Documentation: s390-diag.rst: document
 diag500(STORAGE LIMIT) subfunction
Message-ID: <20241030091825.6264-D-hca@linux.ibm.com>
References: <20241025141453.1210600-1-david@redhat.com>
 <20241025141453.1210600-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025141453.1210600-3-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TERox1SULJSWH3x-mpBM4uyLrQJRVoMc
X-Proofpoint-ORIG-GUID: pTrfvejPbNlJcWhqGfOOo6tVWx4DlTaE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 clxscore=1015 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=633 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300072

On Fri, Oct 25, 2024 at 04:14:47PM +0200, David Hildenbrand wrote:
> Let's document our new diag500 subfunction that can be implemented by
> userspace.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  Documentation/virt/kvm/s390/s390-diag.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

