Return-Path: <kvm+bounces-32047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F8259D24C2
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 12:25:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10F7AB25F1B
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 11:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E511C6F47;
	Tue, 19 Nov 2024 11:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NfUmzgml"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11521C57B2;
	Tue, 19 Nov 2024 11:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732015506; cv=none; b=Rl2Mg49/W9jFymtg6kizmZj0Ld3UW8AdNtvhTMam722YUE96sZyaXspNymexj/uLnJN4T2nR6fjhhcoxuSgN51yjjJb50PcSoLuTO/a4Q9ACB3jCYsc3Tcpna26Z5xarzGB5J9QQn1p5G6H9W4xbZurLZFbt53612nmKYUbN4fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732015506; c=relaxed/simple;
	bh=aGay1b7C9KZbtOlF//OXpBhGzGGg9ML9kjl3w9RQhkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVHvjQDmyjU9NKG+AghB9r+R8RcD25p2x4Z9jFwoO0nrtKOhmfKRdisFMPqZsGlzPthx29bGA08C8mMoNy5AxlD97JD7dEwwm9FKSCkwavz6RSyRNDyrl8wJHYzsioANQs7aWNgRFe47gRPY/5739uA8nEj+Tb+iS7qytqEu9qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NfUmzgml; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ9HWvL003093;
	Tue, 19 Nov 2024 11:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=XZ+fs20bLn+FqoXyeUspaiUAzwWxkx
	dd9aJr+bvkh0k=; b=NfUmzgml3RfRfUyiD3AxhUrPhUCxREPxzXbNffzZDmYius
	8xt8sprjA98ImAk0QaBduajCogbPm7eI0Hi2vJ2LC+06Yd4DiqiH7iIrupWff6jN
	Iq4JXQT2jgwZR4b9HNFzi3cd6WCnlNdm/oC8yNGslzG9yflYH3bkmXwOqyHYoVMY
	lyk4r32SIsTGmv+6BCA8RNfM1wuk6XJmVeb8HEi+CFgS5YuYX0qz3eUFTMl8gBnk
	ncGQg6nEblK9HCSjslBVRqEc7v4JFEPc7TqJ9TCU7uIvL9l00SdhGbF5TDd7w/BD
	Y+ih89n9OCadceIEo7YuFJ7lH7ufuvhR7EAANDPQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xgtt72bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 11:25:03 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJB7bct031189;
	Tue, 19 Nov 2024 11:25:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42y5qscgdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 11:25:02 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AJBOxAS47907214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 11:24:59 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B7B220043;
	Tue, 19 Nov 2024 11:24:59 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6268C20040;
	Tue, 19 Nov 2024 11:24:58 +0000 (GMT)
Received: from osiris (unknown [9.171.28.30])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 19 Nov 2024 11:24:58 +0000 (GMT)
Date: Tue, 19 Nov 2024 12:24:56 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, akrowiak@linux.ibm.com,
        pasic@linux.ibm.com, jjherne@linux.ibm.com, freude@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@de.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [PATCH v1 1/1] s390/vfio-ap: remove gmap_convert_to_secure from
 vfio_ap_ops
Message-ID: <20241119112456.10387-H-hca@linux.ibm.com>
References: <20241115135611.87836-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115135611.87836-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0min60zad3DpyFZIeDTr7ZhJaforEFJp
X-Proofpoint-ORIG-GUID: 0min60zad3DpyFZIeDTr7ZhJaforEFJp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=914 adultscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411190079

On Fri, Nov 15, 2024 at 02:56:11PM +0100, Claudio Imbrenda wrote:
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
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 32 +++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)

Applied, thanks!

