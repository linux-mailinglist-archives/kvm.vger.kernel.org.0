Return-Path: <kvm+bounces-18498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E0188D59D9
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 07:25:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D517228366B
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 05:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 049637BB19;
	Fri, 31 May 2024 05:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZOS5Mbfp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFFB2595;
	Fri, 31 May 2024 05:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717133129; cv=none; b=TtnGOHvYfi0F2Darg9CW7PykX3QKlMe8BAG1o5pr9Hj5EVQqOimz2cLmpZarg3Ee1+ZnZt5JJ30ZyjhrxHtTBSgAfxSbzy8BbOWCjORZBi892kH4bI5e7CsIWyRayv3LmDFIWZFaQEPeHeojUrN3Qop5QLxp+SbHBq5zC7Olel0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717133129; c=relaxed/simple;
	bh=mj8oN9bEAapDXaDwcOfFZv5+N0Y7B4TxqrVXFF/wcvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qj4U6CdqeZWqCqhHa5OXpmfI+qFdLIsdoVT66Mn9HyVN+g918AJGeiXHeBNrmDq1pMHF6ZPZr/KRW3ECN6UICd/ifYHZdnVhUh26Qo1Lgs54piOPYiwP8y9XB4uf1X5yLv46nWtpzFfrHd90TQ4UWiIfhY0gbe51Aju7/z5OuO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZOS5Mbfp; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44V5MwI4023888;
	Fri, 31 May 2024 05:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc : content-type : date
 : from : in-reply-to : message-id : mime-version : references : subject :
 to; s=pp1; bh=mj8oN9bEAapDXaDwcOfFZv5+N0Y7B4TxqrVXFF/wcvQ=;
 b=ZOS5MbfpwaNiS2N3jUER+YiipPb7nHIN8QRCcIJvFstsPhiT5NYV3xz/3CuPVgZfr34u
 Ej6vw2JGx8tnERVhVYythyftZG7w/i/UO2LbDFrwS1jh80tvzBdslqHEObTIYYnjOjwP
 Cl9fiJkZiuZYDx8HuTEY4v3YUTqNyXnUWfoFXhzljEdL9BMD42qh66WuNWhh6ECyDFn5
 lFxwrlJqpU4wjwmmlFaPrYSUCcIjl0QCh7BB5pKJMJXXx7NE7SNEmPtpe+0p139HhrLK
 P2zDCZTF5PTz4FC6q2Co40DNv5fgMNDl9ZHldVXujKNVVK3Wug3GIvoxOHpVUvNXkfhP MA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yf8bf806g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 05:25:12 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44V5O9hB025008;
	Fri, 31 May 2024 05:25:11 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yf8bf806d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 05:25:11 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44V1kCJ8002364;
	Fri, 31 May 2024 05:25:10 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ydpb0x4ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 05:25:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44V5P64W19857912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 05:25:08 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA2C520049;
	Fri, 31 May 2024 05:25:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 09EE520040;
	Fri, 31 May 2024 05:25:02 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.43.42.14])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 31 May 2024 05:25:01 +0000 (GMT)
Date: Fri, 31 May 2024 10:54:58 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, corbet@lwn.net
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] arch/powerpc/kvm: Fix doorbell emulation by adding DPDES
 support
Message-ID: <rrsuqfqugrdowhws2f7ug7pzvimzkepx3g2cp36ijx2zhzokee@eitrr6vxp75w>
References: <20240522082838.121769-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522082838.121769-1-gautam@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: B1f1c0U5Pdf1h3JI0erExRon9cSNCckm
X-Proofpoint-ORIG-GUID: 8SqppJ-_-U2dybLyRKebIywVWbo9HptW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_02,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1015 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=454 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405310040

Hello,

Please review this patch and let me know if any changes are needed.

Thanks,
Gautam

