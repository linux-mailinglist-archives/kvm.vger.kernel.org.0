Return-Path: <kvm+bounces-35638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F35A137D6
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:27:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C80E47A2090
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 10:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9074C1DE2A6;
	Thu, 16 Jan 2025 10:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="W8DHUTcS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184091DDC20;
	Thu, 16 Jan 2025 10:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737023265; cv=none; b=URSJbb5DOAGqV5N2zcOXkHGRWGF8nK9qbCOQzcuu2hlczoIO5yR/UHygHfWxrLhC+Wc8LVALMD+jjhQ3Ez5jVPZyTd0E41VSnJn0eY/THQ9QidLer1rVgQtCPLWyR+dK16pI3Uk34yvFr8aUonsFTRttUX41EWQvWGy/u4LZhlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737023265; c=relaxed/simple;
	bh=mQ9UBts0hbUxM2dGwYUo8HcEDdN5Pe4O1LspCdVCA+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmJrpl7/J2iVHRF1gK0i2bSecn8j7Gzb3VD99bKdo1s9VLkdlOu68ykOtAPs6VJ6nwe8ohy/CNKAMeZb9AZl4gnGenMEY9r/WKGzlWpmJgx6vluB48cn0+vGSdiANi1GUHZno2P+8Az2GKEHdz5Aww698hvs7kJu/sJ3aSHvXP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=W8DHUTcS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G3rUDI007900;
	Thu, 16 Jan 2025 10:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Q7PqrhVDsLrM1oPbf2UP51Y4f4+Msh
	O+8/bYr5ovi6k=; b=W8DHUTcSU4373XFdJy8P1emOoQfypuQR8nHM2SKlaAkKVx
	7C0mO0p+VmRQGDjDcoEqiZc32kOfr3aV6YJyevkbShMR09nFLS4nxYUZEVDWWeD7
	un7hVqON5MADYnEfktI9zFy8g2l7ZnENlSuwotcEe3Bj+2tq7dG1FrUxpnjKo1y7
	A+Fhwj2rt7QV72wWZufvvU7FQQpMJhFmzfIK+Jf3VB7PK0m+WJHy0n340n7+vGA1
	kpIhzci8loGoUxa1npaWWRtuGCZnz4wf5BEZBABuBV1/z5JuIAFKXokg5kOGSvxB
	oNrV9niUr1DzRQC1IvvusLfOGkdafhQd1e404BOw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkchn2e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 10:27:41 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GAJHAZ030866;
	Thu, 16 Jan 2025 10:27:40 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkchn2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 10:27:40 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50G7ZN57000881;
	Thu, 16 Jan 2025 10:27:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456k50cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 10:27:39 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GARaXR33489432
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 10:27:36 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CA7B2037D;
	Thu, 16 Jan 2025 10:27:36 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 520382037B;
	Thu, 16 Jan 2025 10:27:36 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 16 Jan 2025 10:27:36 +0000 (GMT)
Date: Thu, 16 Jan 2025 11:27:33 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH] kvm_config: add CONFIG_VIRTIO_FS
Message-ID: <20250116102733.7207-B-hca@linux.ibm.com>
References: <20241220-kvm-config-virtiofs-v1-1-4f85019e38dc@google.com>
 <9c04640c-9739-4d5f-aba0-1c12c4c38497@linux.ibm.com>
 <CA+i-1C3ncij1HLKGOdTC2FtpBY2Gajp8_3E3UrvNBYhs9Hu0dQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+i-1C3ncij1HLKGOdTC2FtpBY2Gajp8_3E3UrvNBYhs9Hu0dQ@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8pDSDv_Ak8HRUGnj_O6J7cWwXRZh68Pb
X-Proofpoint-GUID: UbunPGYF27dYYX1oJttmqkEQvLt6TD6n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_04,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1011
 mlxlogscore=356 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501160073

On Thu, Jan 16, 2025 at 11:06:56AM +0100, Brendan Jackman wrote:
> Hi Heiko/Vasily/Alexander,
> 
> I don't see any obvious choice for a maintainer who would merge this.
> 
> On Thu, 9 Jan 2025 at 13:46, Christian Borntraeger
> <borntraeger@linux.ibm.com> wrote:
> > Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> 
> Given that Christian acked it, and it's pretty low-stakes and unlikely
> to conflict, would you perhaps take it through the S390 tree?

Given that this is kvm specific I would prefer if this goes via a kvm
specific tree. E.g. kvm-s390 :) Which means Christian, Janosch, or
Claudio should pick this up.

