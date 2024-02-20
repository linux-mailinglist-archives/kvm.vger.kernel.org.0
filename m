Return-Path: <kvm+bounces-9196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D25C885BE92
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 15:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 116A81C21C8B
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 14:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C5DD6BB3A;
	Tue, 20 Feb 2024 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fIWmtA/o"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CFF6A35B;
	Tue, 20 Feb 2024 14:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708438749; cv=none; b=YriPMrucwcSLrq0Cn+AB3RHQy2a7Y0HMWJ0FBzhBjYIB2UIs7r2GOzberXOmMW/VMy8wy8AMc+ROL/HQy+mOoAYeQn29Lt3jppET3K0NFGZKjIjCW82cMRjaX7uelpm8U1HzUa+f7EIkngEncnvkPQjcCjfuMkOP4OysEKfnxGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708438749; c=relaxed/simple;
	bh=vCxLBF+LxDOqOl0qgvAauEYG2QYdT2TKN94lI0gRLw0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a1vUkYZGkrDgygS4xzYsrtGmCI2BxPHrp5xEE6nqRuVtanVL22luBE36EWqL2Pjd3qJRlAh4RKM1RAzXS1IUQg7kLp5/6Tcv987M4aHayYHSDQIvEZ8FL31gQDiHepKJaBIQ2UpmXszRL68Y5NQS10pCeZOsfPPLc98TQrorbPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fIWmtA/o; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41KDV1Hw025709;
	Tue, 20 Feb 2024 14:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=lwg89Fejrts84YeaKU8repsaV4y5Gi7gxXNcjrj4/H0=;
 b=fIWmtA/onYq24esqtZ73ktfPBTnYIpYFXlJDPahdh2CVKpi2f3XFRbRdvVoo8/s/Twg4
 Gugfrif7lC51GwCtxaDT6NUorELWUYRjE7k3f01QR8KyA49d9i2RKOk3orwiBV9xTmGe
 n1KjfGR6Vwu/m7F3FIG8MVapwpw3o9F2pqXNyZB6fFK+9Ucl/+slsOSzeK9EHXBxwrrp
 yQzHgzl7VvPWC9Xmjdfao7dHj0DO5L5WBUq6WDygLhepqV9ES4qXld+TKnxrYVcTs736
 HluvRBPiyKhzCPHYdcGLiVOE3cQ+IRmrOk1PP/IpgW6tphlXdeciCY5IEAkFpStTIop4 pA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wcunmkqgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 14:18:28 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41KE6dH7031572;
	Tue, 20 Feb 2024 14:18:26 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wcunmkqfc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 14:18:26 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41KDjTcI013492;
	Tue, 20 Feb 2024 14:18:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wb7h08ube-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 14:18:24 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41KEIIx511535068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 14:18:21 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC54F2006B;
	Tue, 20 Feb 2024 14:18:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 789E22006A;
	Tue, 20 Feb 2024 14:18:18 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 Feb 2024 14:18:18 +0000 (GMT)
Date: Tue, 20 Feb 2024 15:18:15 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Jason Wang <jasowang@redhat.com>, virtualization@lists.linux.dev,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov
 <anton.ivanov@cambridgegreys.com>,
        Johannes Berg
 <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David
 S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Hans de Goede
 <hdegoede@redhat.com>,
        Ilpo =?UTF-8?B?SsOkcnZpbmVu?=
 <ilpo.jarvinen@linux.intel.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn
 Andersson <andersson@kernel.org>,
        Mathieu Poirier
 <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>, Eric
 Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann
 <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John
 Fastabend <john.fastabend@gmail.com>,
        Benjamin Berg
 <benjamin.berg@intel.com>,
        Yang Li <yang.lee@linux.alibaba.com>, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        Halil
 Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH vhost 07/17] virtio: find_vqs: pass struct instead of
 multi parameters
Message-ID: <20240220151815.5c867cce.pasic@linux.ibm.com>
In-Reply-To: <1706756442.5524123-1-xuanzhuo@linux.alibaba.com>
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
	<20240130114224.86536-8-xuanzhuo@linux.alibaba.com>
	<CACGkMEvb4N8kthr4qWXrLOh9v422OYhrYU6hQejusw-e5EacPw@mail.gmail.com>
	<1706756442.5524123-1-xuanzhuo@linux.alibaba.com>
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
X-Proofpoint-GUID: eUllX_-qgAsmHKd_JgBJQZtujh7cPJYr
X-Proofpoint-ORIG-GUID: RtiekxNRFN2wBWltsYALkmwUnLKUTe6e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 lowpriorityscore=0 spamscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 mlxlogscore=809 adultscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402200103

On Thu, 1 Feb 2024 11:00:42 +0800
Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:

> > > And squish the parameters from transport to a structure.  
> > 
> > The patch did more than what is described here, it also switch to use
> > a structure for vring_create_virtqueue() etc.
> > 
> > Is it better to split?  
> 
> Sure.

I understand there will be a v2. From virtio-ccw perspective I have
no objections.

Regards,
Halil

