Return-Path: <kvm+bounces-29466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4BD9AC087
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 09:43:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69CBD28430C
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 07:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB4F155345;
	Wed, 23 Oct 2024 07:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f19CBwJC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5C31CA84;
	Wed, 23 Oct 2024 07:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729669376; cv=none; b=X3A3XVcgb7sHEjpJwCwZmaBREv1STwBdmLS+puzJqNwBIhnJ0siamQ7Yaja+3PJDoM+Eqqheb6t3N9ifeQ1Ww2r4f07rZ8djxzRab37xq8VGX2yUi8ZA9WA6sEOFYIj8LDwzYfipExo7pVhtIyihzaAhFKR059xZqHlUijKy4D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729669376; c=relaxed/simple;
	bh=35cxrIBquTIsbDYEYNBDPA1fYWrjS2NGs2jQmboaUHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H7A8jmGGfbgoAxVFP9oy9sRa7GZjKWrXHeGW8jdKfup9Fj/WqMPrf4ZNHwCCoPbafaC9TkMWc+HCiaQ46Oi9FmOmKVlMpSonDzm9mNNUcIqZrw+/63bY5TorooVoUfDmrCaCuajBfaqslB25f5WiUzlzvHWhE8Vo118L4zRd7qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f19CBwJC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49N0N3UD016719;
	Wed, 23 Oct 2024 07:42:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=wXo43uDtjC7AWD0EX+yzMqBe11KZsQ
	BWpM2baTsQIq0=; b=f19CBwJCe/YpMADqjM8IM4JHazG+LF3ZoULXe9LwM55mTA
	ySSmBfacZFfV7Th2W6cdx2mW286qOrShf+WS/B3jIKsB5VarOYtmJUmVW25aKWTK
	vVhMGzD+xn/NYyTuwUJWZXeNBztZ1dk6qz3EC1xyJGuxgCqujOgm9vMZvx9tSIjU
	v/yAMhMmzGKlB4EfRORrgMzLi79M4N+2bxHTvMFYQQgZbzwgehYkmxQWv0e5+pr+
	vmaqr0SMDtOyJ/5UT8l7L5C6+5Mv/b2dlbVkvW/imNxHItIr0+weJjGtmCvt4NlF
	1CsloGnPisq/tIx//XwtSupHXsla1J6/Ol7uQppA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42emajhug0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 07:42:45 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49N7dkuX031287;
	Wed, 23 Oct 2024 07:42:44 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42emajhufx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 07:42:44 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49N7UPss012603;
	Wed, 23 Oct 2024 07:42:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42emhf9tfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 07:42:43 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49N7geZ334472700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 07:42:40 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48BE42004B;
	Wed, 23 Oct 2024 07:42:40 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2532820043;
	Wed, 23 Oct 2024 07:42:39 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 23 Oct 2024 07:42:39 +0000 (GMT)
Date: Wed, 23 Oct 2024 09:42:37 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Alexander Egorenkov <egorenar@linux.ibm.com>, agordeev@linux.ibm.com,
        akpm@linux-foundation.org, borntraeger@linux.ibm.com,
        cohuck@redhat.com, corbet@lwn.net, eperezma@redhat.com,
        frankja@linux.ibm.com, gor@linux.ibm.com, imbrenda@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, mcasquer@redhat.com, mst@redhat.com,
        svens@linux.ibm.com, thuth@redhat.com, virtualization@lists.linux.dev,
        xuanzhuo@linux.alibaba.com, zaslonko@linux.ibm.com
Subject: Re: [PATCH v2 1/7] s390/kdump: implement is_kdump_kernel()
Message-ID: <20241023074237.8013-B-hca@linux.ibm.com>
References: <87ed4g5fwk.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
 <76f4ed45-5a40-4ac4-af24-a40effe7725c@redhat.com>
 <87sespfwtt.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
 <64db4a88-4f2d-4d1d-8f7c-37c797d15529@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64db4a88-4f2d-4d1d-8f7c-37c797d15529@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kv4ZkB2-Mf5jHWjN5aziPIG7M60YrAaq
X-Proofpoint-GUID: xdOQijmQwUZDsrA_f6jHNlHs_qGV4-Kl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxscore=0 phishscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=643 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410230042

On Mon, Oct 21, 2024 at 04:45:59PM +0200, David Hildenbrand wrote:
> For my purpose (virtio-mem), it's sufficient to only support "kexec
> triggered kdump" either way, so I don't care.
> 
> So for me it's good enough to have
> 
> bool is_kdump_kernel(void)
> {
> 	return oldmem_data.start;
> }
> 
> And trying to document the situation in a comment like powerpc does :)

Then let's go forward with this, since as Alexander wrote, this is returning
what is actually happening. If this is not sufficient or something breaks we
can still address this.

