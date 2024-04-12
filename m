Return-Path: <kvm+bounces-14527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 310C78A2F57
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 15:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C68201F215C9
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 13:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE93782482;
	Fri, 12 Apr 2024 13:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PWlaWm+y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FA55914B;
	Fri, 12 Apr 2024 13:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712928344; cv=none; b=jTyGSvjHM3wSj9C+rAXz6WhUXq29pilulefaBmD8HOOg3zybso85ho74yh88zoguecKc5TD0/NJR68pidhldnl5XX+K7LtqL4QJL27Kper1IoXI6PCv7LKhFmbuS72Tm/38XoBr5P2OVlCz5Qiqg7HhYa41FQy/adbfh25wTBbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712928344; c=relaxed/simple;
	bh=K/PYnVuBs0NW40S2J0gna2ybcb3BjjN7UycpWMIRUkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHGv8m5uE/wmjuapUCrFCmEA5euvwRf/Akjx99dJYEPaMU3h6TlF6ut1pu17ioBEC5TvDSYE2bo3YUDMhbKl5ZPKUv3Ikemrad7o4XwehCEhVCT9qTc1Dz2UzUG7JA3wqk7l8RaOVMPFeIXws7Ta8Xi/47892stM/kgcxxwqFo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PWlaWm+y; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43CDEigZ029173;
	Fri, 12 Apr 2024 13:25:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=1V3Ezxl7WVDhos2t68PZAZjGKM6z5yy3zHT/ac8+FeM=;
 b=PWlaWm+yJcii3DuGyA6u+KghBCvAsrayUGxgAifIZOQMoSBinQK7vhRRodtD5V9AaWx5
 U93hHTbZdf8pjiT4oXGeoanJ5uSoQqhVCqL8RGXR5ksKAzDyc6RaHKEL6jKbK3xwBPv/
 PsirN4mnjKlZFEeDnqcKlm8FtSrJAW+lxadCmqR4WWdh4FYSGxcbll2hzS+U8L0VlWxc
 swopzkeobPGqr+bJl3L0mdnrzGHWcgwEz6Sq/20T2vZCBBCMLS8z8pGoVKg4oMM/jSXt
 MYSJaqEsDYPT6c+pAZA+JFV0jG2flWSzMDOC5urh9H55x3Bp7+9/Zl9/9BFEYCz6EgZt Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xf5du81yg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Apr 2024 13:25:35 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43CDPZha016327;
	Fri, 12 Apr 2024 13:25:35 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xf5du81yc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Apr 2024 13:25:35 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43CCf2xS017031;
	Fri, 12 Apr 2024 13:25:34 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xbke31kva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Apr 2024 13:25:34 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43CDPS7o50856318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 13:25:30 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCB2A20043;
	Fri, 12 Apr 2024 13:25:28 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C81D20040;
	Fri, 12 Apr 2024 13:25:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 12 Apr 2024 13:25:28 +0000 (GMT)
Date: Fri, 12 Apr 2024 15:25:27 +0200
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
Message-ID: <Zhk2R4UsX4SQCW7R@tuxmaker.boeblingen.de.ibm.com>
References: <20240411161441.910170-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411161441.910170-1-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ul0IUwYd-HCOVsPE5cAk8RWULY_gRTAH
X-Proofpoint-GUID: JODNUjsZTdjuGQ9BHarCbC85GqjBwMpA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-12_09,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 adultscore=0 mlxlogscore=420 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404120095

> David Hildenbrand (2):
>   mm/userfaultfd: don't place zeropages when zeropages are disallowed
>   s390/mm: re-enable the shared zeropage for !PV and !skeys KVM guests
> 
>  arch/s390/include/asm/gmap.h        |   2 +-
>  arch/s390/include/asm/mmu.h         |   5 +
>  arch/s390/include/asm/mmu_context.h |   1 +
>  arch/s390/include/asm/pgtable.h     |  16 ++-
>  arch/s390/kvm/kvm-s390.c            |   4 +-
>  arch/s390/mm/gmap.c                 | 163 +++++++++++++++++++++-------
>  mm/userfaultfd.c                    |  34 ++++++
>  7 files changed, 178 insertions(+), 47 deletions(-)

Applied.
Thanks, David!

