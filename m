Return-Path: <kvm+bounces-14962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1AB8A8358
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A4041C21896
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 12:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0992A13D285;
	Wed, 17 Apr 2024 12:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cgIPe3xp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A6013CFBD;
	Wed, 17 Apr 2024 12:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713357984; cv=none; b=lLnGotsw8pgGWUzntfOff6gxjR7TkBqhXG8SKT9oE078SOZ64pkzqizVg0EMN+cx206WF1AWGAL2OWZl4RJDTyzDapoT6juhMvsZmZD8AlbW16OV8M9QK9rusyOpF68QkLWmCK2G4o7olMDydrU3OykKLgXaMTgQ+WgVEMpFOeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713357984; c=relaxed/simple;
	bh=fiavUOvWZVE5pmBDnmjK1riI/G3q7OCzJP2xW2NEEg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LV4OfEsWTGfG/zahM/5tgWGueCI0pt4jkvhsJQ9Q3UicA2H8fzVRwx9asVlH3pAnY+nm8sZBfSuJflewwI5V2crxde4OKj1zb9H4kqg9aHxdIqILQPiWWepqx8SQMrJ6wULvBUu/Q3es4oIdX/cW0hRH/KrI5BWGUy3T8SQGgGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cgIPe3xp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43HC5rn3011335;
	Wed, 17 Apr 2024 12:46:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=fiavUOvWZVE5pmBDnmjK1riI/G3q7OCzJP2xW2NEEg4=;
 b=cgIPe3xpoTIrAKgl6UmWHPMcuN/H+jVwdE7EDyOfXoRFRcv7hpdIcaybO3g0+bDktiuP
 C43Uvft7mYulucB+rRAzmbeMxQUTXKRaiFcxuuJSBIGxOpnWCHDJP868Z8qUKN1y5GEL
 ad1H0FP5ZmCSTdMX6w0TO4LPn3S0zWmmxBakTNbobUWTUnrar8tO245odV6t/mZrYH7B
 vOYq9DP9+h1iQ4NHATAW88Gh84cAkN49eJx3rPXbF/GOr5EoLw0on9pgLk9IUSvLbavE
 ecVr9sPLTdTevCtxbjbFKfWAzfGLwoFKYDg3HHsgw8JcwGpikq/3tSQsfnkjDs9oHd3i pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xje4cr31s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Apr 2024 12:46:16 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43HCgsqu001129;
	Wed, 17 Apr 2024 12:46:15 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xje4cr31m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Apr 2024 12:46:15 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43HAX5k0021366;
	Wed, 17 Apr 2024 12:46:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xg6kkm3sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Apr 2024 12:46:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43HCk9Cb14811424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Apr 2024 12:46:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B1E3220043;
	Wed, 17 Apr 2024 12:46:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6AF5620040;
	Wed, 17 Apr 2024 12:46:09 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Apr 2024 12:46:09 +0000 (GMT)
Date: Wed, 17 Apr 2024 14:46:08 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 0/2] s390/mm: shared zeropage + KVM fixes
Message-ID: <Zh/EkOPBRS1q0ru2@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240411161441.910170-1-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411161441.910170-1-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DiMi4inaKsPPHwYi2zSjQpD6kQB3mZz4
X-Proofpoint-ORIG-GUID: HRLfBySLDHbhCMwMIzRcmBKuqE6JUE-a
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-17_09,2024-04-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxlogscore=587 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2404170086

On Thu, Apr 11, 2024 at 06:14:39PM +0200, David Hildenbrand wrote:

Hi David,

> Based on s390/features. Andrew agreed that both patches can go via the
> s390x tree.

I am going to put on a branch this series together with the selftest:
https://lore.kernel.org/r/20240412084329.30315-1-david@redhat.com

I there something in s390/features your three patches depend on?
Or v6.9-rc2 contains everything needed already?

Thanks!

