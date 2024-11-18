Return-Path: <kvm+bounces-32029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A075D9D18A6
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 20:06:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65EAB2829DB
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 19:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0075F1E5005;
	Mon, 18 Nov 2024 19:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nre2bIKL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9E11A08BC;
	Mon, 18 Nov 2024 19:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731956756; cv=none; b=GsbFMQRSMKIgAVJU9oW1qF/LyQaKiXEZcqyczptZ/rC4S+lkU12Rn5dgVLtKF2roMT6V2XgAQQz0p2uNZVR90/tRv262a78hZyc6DnV5HCBSLr2YqITLi9G/R629LeKPoR+RYLU4OB/WEOn3bS2tAgkyPa6XJ0APxiuF42cOAbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731956756; c=relaxed/simple;
	bh=zAg0FED4ncJuY+Q8VOMutwGkYeDVtRLM6e/epe7noEA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hhPXDd/wHu7EmC9qXVZED2/Dl+OTeMQ4tdnzXFPQRoEY/UePzPL9oHpASxVtLkwDXPwqKHmn9zceuLXp4khatbMrlDTzIhdlCr8tmuC1zD2DavizI7sHkT2AINTey2ORdhhgTwAv7MXhe4h+8PpOHm/ZbthuveQ1QhNj5fHrOE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nre2bIKL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AIDIIPo014043;
	Mon, 18 Nov 2024 19:05:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=GJGl4O
	QQ+YxHIWJ46wHkioKho5/6+Hy0SHgLLI7iMXY=; b=nre2bIKLPj9twUM2gDNJTx
	CRBcHSl6E0PwA6LtMSRKzkC6Ior/23Ae+ZU3oj7SyPuLKhADFjz/PM/YXUXwOT2r
	oYF+cGFs1XlSzy+5WYrTCzSHONEZ2B9LDMdSXbj7aDZ8UhgnrGWV5iyamFPU6t1i
	ZlZFyeU0yMne4XRuQKP9nfBZgTymchamIfI6TigCZiKzUe4LTzjIwnJzVFB27Gt4
	UlXQr1hBlnV+crbKBmBd88SZMr25zuodYWlQzCSiabdrF+kyloxpRG8VKZ04yinf
	2o0at2I+kq7Awe4vyvjiWb4ITwruZaLZCY6YnSIOGN+G6+icks3RtQOdnF+bqnJw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xyu1hkya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Nov 2024 19:05:53 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AII51tZ030975;
	Mon, 18 Nov 2024 19:05:52 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42y63y7gac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Nov 2024 19:05:52 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AIJ5mWl19399146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 19:05:48 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64BEB20043;
	Mon, 18 Nov 2024 19:05:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C72920040;
	Mon, 18 Nov 2024 19:05:47 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.80.125])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 18 Nov 2024 19:05:47 +0000 (GMT)
Date: Mon, 18 Nov 2024 20:05:46 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, freude@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@de.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seiden@linux.ibm.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] s390/vfio-ap: remove gmap_convert_to_secure from
 vfio_ap_ops
Message-ID: <20241118200546.7bf584f4.pasic@linux.ibm.com>
In-Reply-To: <20241115135611.87836-1-imbrenda@linux.ibm.com>
References: <20241115135611.87836-1-imbrenda@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zdgl8H0DvE4fzFd7gC1x6KipHTYaOqKf
X-Proofpoint-ORIG-GUID: zdgl8H0DvE4fzFd7gC1x6KipHTYaOqKf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 bulkscore=0 spamscore=0 mlxlogscore=942 adultscore=0 mlxscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411180152

On Fri, 15 Nov 2024 14:56:11 +0100
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> If the page has been exported, do not re-import it. Imports should
> only be triggered by the guest. The guest will import the page
> automatically when it will need it again, there is no advantage in
> importing it manually.
> 
> Moreover, vfio_pin_pages() will take an extra reference on the page and
> thus will cause the import to always fail. The extra reference would be
> dropped only after pointlessly trying to import the page.
> 
> Fixes: f88fb1335733 ("s390/vfio-ap: make sure nib is shared")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

