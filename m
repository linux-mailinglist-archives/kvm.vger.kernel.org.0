Return-Path: <kvm+bounces-21621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14026930D8E
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 07:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 459701C20FF6
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 05:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EFD113B2B0;
	Mon, 15 Jul 2024 05:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oo72ttqV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410D928FA;
	Mon, 15 Jul 2024 05:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721021193; cv=none; b=tdlXpUSkVfliYJvDQ9ZC9oZQ7DBdur2n3TDNsejwsK35AL4ALiDGsAuGRwmhAFCqfaz37rCBfPx8RLIdhpY27aD7bg4OnbcyQKJMM+qX+OmjRv1Sq6uFqN/JETj+6dmarODh6/W2SykdqLHhSO7z4lgEB2REAbDJ0IsO1BxksGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721021193; c=relaxed/simple;
	bh=mj8oN9bEAapDXaDwcOfFZv5+N0Y7B4TxqrVXFF/wcvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNbNSyOEH/A5wW/UgUbAITj+0Q4v3ujnEkObIaSZgdHF/IMFo5p2tZHl5Y7izlsEAKRSaocCnJ7sJzcNyLIi3GYP1XIPk2QgF9L6vTe9p7uX24hCtPf1skbofBE7FBYjuq31QorhE8WBe9H7Yf1IryjcaVYIjg1M8+CiarMKq30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oo72ttqV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46F4TWkt020350;
	Mon, 15 Jul 2024 05:26:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=mj8oN9bEAapDXaDwcOfFZv5+N0Y
	7B4TxqrVXFF/wcvQ=; b=oo72ttqVKquBq3ezSW5maqnfuhxBEJwUEyrTpisYaOg
	Cx/v+BBNbGkkNwfeZSNqPicGECK+IhL67KY0+bs2V15CeT1/8FyRTw8JDgmgbC0W
	VKwatFnXjLN39PlHVgwIIiWXd9pGYRYqtFZgANCmi7RweW1fZrSSIgPj3of5FPJ1
	EN/7DrB8xy4Mh2kNOM4zuYGi6+4xcwNgF4UH1apV2qzJgOj1lEdxHk03bOOpE+2V
	rT2DaUq+mmXTJ+UD0N6+hLmh27BsemddJ6Xp/2W1yz+SOxqCKhELsyza7b7jRDit
	Kvu1iseEBBqwg7Fq3K7ksBd6LCp5pZHohqEAmLozZng==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40cvsc03ty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 05:26:16 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46F5QF0K005585;
	Mon, 15 Jul 2024 05:26:15 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40cvsc03tw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 05:26:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46F2c2Ha028708;
	Mon, 15 Jul 2024 05:26:15 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 40c6m2vwvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 05:26:14 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46F5QBkl55050518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Jul 2024 05:26:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56A742004D;
	Mon, 15 Jul 2024 05:26:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6367820043;
	Mon, 15 Jul 2024 05:26:09 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.43.54.149])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 15 Jul 2024 05:26:09 +0000 (GMT)
Date: Mon, 15 Jul 2024 10:56:03 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/powerpc/kvm: Avoid extra checks when emulating
 HFSCR bits
Message-ID: <fru2vfv3mcfm7c5zn2xwqvqf6b2s2up2k6vam2nm7jc7rhqjay@mkwwkzw4eh7x>
References: <20240626123447.66104-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626123447.66104-1-gautam@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ThvTW9Yx5AzWjC-WTPjQkInG8i6S1Nu2
X-Proofpoint-GUID: o6eZtnXkcO7IRE37LNQu_raRf6eTsCqD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_01,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=402
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 impostorscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2406140001 definitions=main-2407150036

Hello,

Please review this patch and let me know if any changes are needed.

Thanks,
Gautam

