Return-Path: <kvm+bounces-32461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B5D9D8A2C
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 17:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86F66B2D268
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 695361B4152;
	Mon, 25 Nov 2024 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XhI7D6xO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C332260C;
	Mon, 25 Nov 2024 16:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732551435; cv=none; b=J6+R99MOr+5YN2DddvnQ86VM3dcS4fIPji8WTgnlqfmstRbFoVY2cqPOeupTGks5/fX/K7oicuQtM1OoFlJDYSB+zZV+PA7YB1ZbydopkMMLj8OcKIi4PSMCacUXklIO9xf1X8YyIEbFeVzRNf2qMdheOrBt0f6yOXcTmKrIyQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732551435; c=relaxed/simple;
	bh=g3/f7I7vt/lu5GWy0CMvhOj4kpRJQQ7UcI7DU4ZG+o0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IWvU+jU/hZaaZRTartJ9nrrt1ZAKg95x+WysdpewxZwSxxisrIjzps/zqdnPdcQv+Gdd+eSaVgKxr3BKCZ1YtTC2CWjZoVDsv81FyyF9oapFDfLmOPLAl1dISukS/srL88Spp2BxugXZg8dL5eSsruxd6lkA08coVCeJsDK7Lso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XhI7D6xO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP77m1K018205;
	Mon, 25 Nov 2024 16:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NmP6QP
	p7KoZheOv2+2aCbu2+B7H2dgRV60f5DJCMPgE=; b=XhI7D6xObCBeNY+LZA82hh
	YT8PNalMHW+95o+g/LdbFMFO1NPTU86e/fcR3g6zh/t78rl5SW7Ks66BW3JbliLY
	344sFeMRHCfPkSCofsxp29PXf9oPD9KRR/e5plhxBEE9z2rRz0TOxcGf8q+e5MB2
	QYEE8QDXf0q2v1QzZWP1jpqZuT/VTta2Tkc+qTjpeAfcPMgLrnpufLNlo8SzN3S8
	cykAqgkl5jnLUhDMMgY6GCX18tyzKeNN8RspqD81w78FrQuXJzHq/j5WoNi8iU0y
	3E/xtf8O7QP5xOuwE3ceJNqOO0nt6LpFb8jY/mo0Nl2FEqsknSOEa/EI+XhUvAvQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4338a795b0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 16:17:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP60L2Q026326;
	Mon, 25 Nov 2024 16:17:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 433v30tn7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 16:17:10 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APGH7SY54526278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 16:17:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B8D22004B;
	Mon, 25 Nov 2024 16:17:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82D2420040;
	Mon, 25 Nov 2024 16:17:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Nov 2024 16:17:06 +0000 (GMT)
Date: Mon, 25 Nov 2024 17:17:05 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: s390: Increase size of union sca_utility to
 four bytes
Message-ID: <20241125171705.46e64cef@p-imbrenda>
In-Reply-To: <20241125134022.14417-E-hca@linux.ibm.com>
References: <20241125115039.1809353-1-hca@linux.ibm.com>
	<20241125115039.1809353-4-hca@linux.ibm.com>
	<20241125132042.44918953@p-imbrenda>
	<20241125134022.14417-E-hca@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z7HOYqJOYWv81pBXUawSteucyMhXorT1
X-Proofpoint-ORIG-GUID: z7HOYqJOYWv81pBXUawSteucyMhXorT1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=696 malwarescore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411250134

On Mon, 25 Nov 2024 14:40:22 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Mon, Nov 25, 2024 at 01:20:42PM +0100, Claudio Imbrenda wrote:
> > On Mon, 25 Nov 2024 12:50:39 +0100
> > Heiko Carstens <hca@linux.ibm.com> wrote:
> >   
> > > kvm_s390_update_topology_change_report() modifies a single bit within
> > > sca_utility using cmpxchg(). Given that the size of the sca_utility union
> > > is two bytes this generates very inefficient code. Change the size to four
> > > bytes, so better code can be generated.
> > > 
> > > Even though the size of sca_utility doesn't reflect architecture anymore
> > > this seems to be the easiest and most pragmatic approach to avoid
> > > inefficient code.  
> > 
> > wouldn't an atomic bit_op be better in that case?  
> 
> I had that, but decided against it, since the generated code isn't shorter.
> And it would require and unsigned long type within the union, or a cast,
> which I also both disliked.

fair enough

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

