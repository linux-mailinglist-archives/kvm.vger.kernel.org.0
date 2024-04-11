Return-Path: <kvm+bounces-14250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC6EC8A1559
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 15:14:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A83F2283DAE
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 13:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530D214D29C;
	Thu, 11 Apr 2024 13:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aaQaIiX6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B14C1EB26;
	Thu, 11 Apr 2024 13:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712841230; cv=none; b=cI/XKI2LVcbg3y+VpkW2RIqShGwu60/n09xUtEyYdHroP8GBHHAdYDFjoKPoGcsbp24EnHoTRiMmZRKCwkoqX9AFhoGdpLy0u26233d1bCtwNNTzHsJ4keFIh2iuQxJ8h+oYanz/kbSeQ91JfWsO3S11ZtTIQ0nLZjUQ7Aiaje4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712841230; c=relaxed/simple;
	bh=xYKRnU8aOM8TF+MV61TVLYuU1636UekHg3sEM42a8Go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R/4E849v2B8hy0s9kTxImDGxSAbRsXcccpz78wIAVTmX5EajBFq+g5Ak5MhN/M1yPUj58RgJTZP0ItO/gBgLOAqyuOWq5tpdKHpqTBGl3uFN64R7I8AloLj0FlxiTI9eHCBpPZbEvZjT5AbGismPTZ0ZlgAwlK5UV56mlVL8hrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aaQaIiX6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BAxQor024252;
	Thu, 11 Apr 2024 13:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=n38Thl8pnQJDOXNyW6qsfYn3wnZKegsAGh9jLryh8ws=;
 b=aaQaIiX6Yo4cvMUuvNAwrVA/9S//HhGkyzwLMOit4gtENzaOKo4srMo35IcA/YJ4eDc+
 pgzqOmJ2O5cDUhdlGIj5aAaHZfRMTRT3qb/UmgrnpgBeR4sFB6KvPcphSvUpaR79py/5
 EyzVZMIoSqg3xkACTOY/8nUZsrg5dhhkTZ203BiUpMw+i3QdnKAuRuGD4kwYNkqvC1+s
 hsWBE4crZoJCJH6gj6k8o/RGRTxgjOu0dS8DQ6p748EHAmCkeilp/Px8VHiJM2I1cl0R
 EZQP8Hpteg5TGI6TO2TnY19vboxPrpir5/j2M6BjhvLQMlV28uaZ1taDAsIvVcFkJQBK Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xeegar9th-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 13:13:34 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43BDDXpR025251;
	Thu, 11 Apr 2024 13:13:34 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xeegar9td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 13:13:33 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43BCpK1x022573;
	Thu, 11 Apr 2024 13:13:33 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xbhqpb9fm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 13:13:33 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43BDDR7645285866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 13:13:29 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F2E92004B;
	Thu, 11 Apr 2024 13:13:27 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4521620040;
	Thu, 11 Apr 2024 13:13:27 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 11 Apr 2024 13:13:27 +0000 (GMT)
Date: Thu, 11 Apr 2024 15:13:26 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v1 1/5] s390/uv: don't call wait_on_page_writeback()
 without a reference
Message-ID: <Zhfh9m200e0Lz6od@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240404163642.1125529-1-david@redhat.com>
 <20240404163642.1125529-2-david@redhat.com>
 <20240410192128.2ad60f9b@p-imbrenda>
 <63f39394-380a-4817-8d5b-f5d468b0092e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63f39394-380a-4817-8d5b-f5d468b0092e@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 71cSxIvAPIM5a1Va6TsrQFdb9gmX2mI2
X-Proofpoint-ORIG-GUID: xmJTjyn2SelvuiZ8qBB9ZINXrftMPhbN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_06,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=694
 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110096

On Thu, Apr 11, 2024 at 10:24:23AM +0200, David Hildenbrand wrote:
> Thanks! I'll rebase this series on top of the s390/features tree for now,
> where Willy's cleanups already reside.

Yes, rebase it on to of s390/features, please.

> If maintainers want to have that fix first, I can send it out with Willy's
> patches rebased on this fix. Whatever people prefer.

Many thanks!

> -- 
> Cheers,
> 
> David / dhildenb

