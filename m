Return-Path: <kvm+bounces-59300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF0DDBB0BE4
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 16:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DC0B1945DE2
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 14:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 020EC263C8C;
	Wed,  1 Oct 2025 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fhwooSsj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF9B21D596;
	Wed,  1 Oct 2025 14:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759329434; cv=none; b=RRn3JjK6dXjUU4WuawBIfNZ2Cz2SeWCHpMPCKCUqf5ewIb3lFsHM31Jz3g2cpRG8Ff2M32+3LMBIME3KH4HWnPxBrzVUhIBX/R+LdrVdWEQuWD4ieZ1tisYQ6tP6sg9fk80/IM89/Sv+Ts8DhcWnGm/nuwPXaCHAtTMhmMfVVWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759329434; c=relaxed/simple;
	bh=Kek1q+MP2da18bK4AByj14NNpFovbpvU03QlUc5+waY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JlYO1BWiOu7E1jcw7unaJkmuBJJ3laEbfqrQkCO1ELMt1OKhGyyp2mgTQX6LBMEZWETGxbN8Yeo3Pk/PksPyqIn3eKC+xfeoYdlqW5ShUwPFdqwdrVVndSetaKfV7w6pQe2OZbrQW2IKnIR7FDQAkf/LES7QUGBuIWLDc7xMs9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fhwooSsj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591CQL7J020920;
	Wed, 1 Oct 2025 14:37:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:sender:subject:to; s=pp1;
	 bh=SuXdHEg0ycX+p5T1xVKQDPHy2Z2CDKaAPscZOpFSlzU=; b=fhwooSsj6a6U
	sYDZMxZBk2nfSRpiNiOH7K4zrL9LQPXt0vhEQMDtHGYgoZ8XpJuP9oQ2DuoXkQrC
	olVzFQYxHJ2bu9JTMnv5p0I1UTjkjGCQZQ4uqz+6PKxsPyksuIBmQLXPBe+SY1m2
	Gqm4Qlapmy6y3unjpAIDhE5IQc8zjOudB5n3WUnFH5QECSi3TSGsPLogtrNVr7Yj
	I+YyNkRZ9kwIuxhYgGRjdRGsGvqoT+kpEzShJLs9vmcQ+hzREeq2vzRAWx05k1Vb
	tQLhF7/BcfVwuDG/QZ3iOyeVLvT/pttrse2cNYOWWUqvAA+qtts7y49URUvUMBb+
	Bg1rBRsnlw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7jwq3ax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 14:37:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 591C0fdi020098;
	Wed, 1 Oct 2025 14:37:07 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49et8s9dsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 14:37:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 591Eb3r855443946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Oct 2025 14:37:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C8D420043;
	Wed,  1 Oct 2025 14:37:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C14A20040;
	Wed,  1 Oct 2025 14:37:03 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.180])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  1 Oct 2025 14:37:03 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.98.2)
	(envelope-from <bblock@linux.ibm.com>)
	id 1v3xx1-00000001iRV-1Mah;
	Wed, 01 Oct 2025 16:37:03 +0200
Date: Wed, 1 Oct 2025 16:37:03 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 02/10] PCI: Add additional checks for flr reset
Message-ID: <20251001143703.GA408411@p1gen4-pw042f0m>
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-3-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250924171628.826-3-alifm@linux.ibm.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfX8eFdpvrKBPm2
 9WWeklkom+tqjLczaLTyLEdhYjiFtcyQMHj8MgCq3bEcfZTpXxxkAjmz46EkDJysGMs/vHg7Z67
 rpVB5yNwWqL7xmaB9tQhyL8/DINiAg4lC7Vc/8WHrzr1+MdAVAOTdS20I4R8jKHvkKMi3fSaTRg
 WZsUKltlhnai92XJFVrMcepj/9sKLde7Svk1EozmZuoNbsa7TA0ekTaCfA/J9rkN0fOAeBhWZA6
 kAzIFrWyYhZvJktTJ0AAgpXn3NTtddlXORzjckKZhr/mY/IVPwXb4ZY3tUBQQ8BWkhzIAwF9Twa
 newtq7ncezoM8wgmi3k+meshdOxinbvg2AQje9qZauzhf4ySkYBpphzKxDEVGiZxQlNs1efeFYd
 WMpqyA6KSxd1nDa4HgwxjJ4q8N2XWA==
X-Proofpoint-ORIG-GUID: V9pV9LbHGNpGils0OyydMlRriS7s15mA
X-Proofpoint-GUID: V9pV9LbHGNpGils0OyydMlRriS7s15mA
X-Authority-Analysis: v=2.4 cv=GdUaXAXL c=1 sm=1 tr=0 ts=68dd3c94 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=8nJEP1OIZ-IA:10 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=OVvMPCSoLlKkTLrhKAMA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025

On Wed, Sep 24, 2025 at 10:16:20AM -0700, Farhan Ali wrote:
> If a device is in an error state, then any reads of device registers can
> return error value. Add addtional checks to validate if a device is in an
> error state before doing an flr reset.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/pci/pci.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

Apart from the discussion about a stable tag this looks good to me.


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294

