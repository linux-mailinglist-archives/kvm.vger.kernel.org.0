Return-Path: <kvm+bounces-16181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA438B5FF2
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 19:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 860EBB21228
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530788664D;
	Mon, 29 Apr 2024 17:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AAj8TifK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE1D83A15;
	Mon, 29 Apr 2024 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411138; cv=none; b=ISO29aPSqwH7d3HHhkbOXBEPTb8nssh+Nhoie0sSoUGvk3XfwOKt/qm6QaeGBGAzr/qg/JOpqFrp0QjgNebKzcOWxlLuDPeJixnobeUoOzjI5+Hi3ljvLURcQU/9t/QrG3gE5Phnbp/A93pCZbtXw/iAIohh2R9s1scJgnAo4lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411138; c=relaxed/simple;
	bh=Dj8vb5pBdqtf1kUdpnUsYPrgIIOInJcYELaOMS29MZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hqfpbb6jvsNRGQ8RPdWm6jhNlq/v7qG4I7l7NW7DF/CZxYELlhVcQbbHmHAXe7MzUxtZJvBpjvEsVNVGLLvS/z+m9zIByqKsEZhX1nbqfZupiBtV8NY9NmwWZiCJnG9ZOa+qL8bSk/IrvXR5KFW/E70LetSHDfCLXVqo79eVRAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AAj8TifK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43TGROqe024814;
	Mon, 29 Apr 2024 17:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=jlueBCwa0Qh/gmIXhJ2+HUi87hbP7Hh98SkXP+GrTqA=;
 b=AAj8TifKKORPQ0pJc/WBKWZe/Qjf33kRDOKl+UHJ+lGnLKgSsw6xeRl7Cznq0Mur+xp2
 Q20Uo0qZgiwYQmiFQwQdKkDYAEMbtGepf733/gT3far5GGEgisQMM32qak5SvKtVKRe0
 nQZ5H0KNKPPp/JvuL5+D5ou9Fmd+F9hMuW8HWmmidUDE2h+RL/u/fK9mbUb4UtfDf8oA
 xtR7QXwwRSImaHcGgteStdMPRLoEpQQwoAuDwlZDTfscaqld+k+hlipp38SXFCnJpWUT
 i5bvnHkCZZfEJNuCh2YN7ctJSSsQY9QBk8xtk19oQS8U0FD+4bZi3JYaazwTFwRxhwKs 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xtf32856n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 17:18:55 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43THIt5U015972;
	Mon, 29 Apr 2024 17:18:55 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xtf32856g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 17:18:54 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43TFqF4U022334;
	Mon, 29 Apr 2024 17:18:53 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xsd6mgcwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 17:18:53 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43THIml330867796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 17:18:50 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F30B22004E;
	Mon, 29 Apr 2024 17:18:47 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C404E20040;
	Mon, 29 Apr 2024 17:18:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 29 Apr 2024 17:18:47 +0000 (GMT)
Date: Mon, 29 Apr 2024 19:18:46 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] s390/kvm/vsie: Use virt_to_phys for crypto control block
Message-ID: <Zi/WdlVbJYkYc7+5@tuxmaker.boeblingen.de.ibm.com>
References: <20240429171512.879215-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429171512.879215-1-nsg@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gfhdZ85qCFg7hWIw_j8VYzWE7ZYsPmH2
X-Proofpoint-ORIG-GUID: FdfNvmLWlD2VqyN9RzTK0IeBKwSYiOmB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-29_15,2024-04-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=682 phishscore=0 clxscore=1015 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404290112

On Mon, Apr 29, 2024 at 07:15:12PM +0200, Nina Schoetterl-Glausch wrote:
> The address of the crypto control block in the (shadow) SIE block is
> absolute/physical.
> Convert from virtual to physical when shadowing the guest's control
> block during VSIE.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  arch/s390/kvm/vsie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>

Please apply and push to devel, preferably using the following commands:

# b390 shazam -t <message-id>
# git push <repository> devel


