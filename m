Return-Path: <kvm+bounces-42482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4CAA79224
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 17:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 736C83B4A52
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 15:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFAD923C8A1;
	Wed,  2 Apr 2025 15:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ONQjd7qF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F0A20E70F;
	Wed,  2 Apr 2025 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743607635; cv=none; b=WvOV5rSxzNQB1PGzMHeRXtZdfZ5uJ2YnQ2SwXb7rDSryA+Dzls/dr7h5rauc5NustCOGQiyuudruw3Tfti2Vdkt7q3iH5ayGto1wmgnNlouLGpazs2vKDtma9DmSYGcJsh2nO41XwqHwk/x/sKEyGx+q2Y7ET6mMnVgu1ywUzgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743607635; c=relaxed/simple;
	bh=xsz+a0w6v7e73F+KbPeTQhB7HVkdZld2TMXDVLVpPzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EMgpVwLbm6hO8rv4jp6NRc77xjZEcbkHoDgRVn/qq+XZiFpH6PH7GiOZFh4ZVWfU7e5eM19uGVjpeohxLC3baPO84ohW7AVq5BwAoiJXKVsBPF4z1uL4UJcYgNSbo3MdZfzH/MnTTofHh1rkbNbDBVF31R0N/wMWpydntVwFlCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ONQjd7qF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 532A1itv030333;
	Wed, 2 Apr 2025 15:27:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=V53uxv
	A71/usjtKHwAYe1dncwLcRRC71/8t4S18TMlg=; b=ONQjd7qF+WYz+vZjLP8mgh
	WMUFuUV2TLf1EFoKZXAerVrJtfBb34Q+3shOq+jdDxCuNd2E7DTAoGeTXLoQOrpz
	2OJu27BYcAjWWQKdzjORRqPfMCtnQUXHOGZPicCH+ZwAPNPXItSOHHi+X3se7m2A
	LkBiPiLDU+42Mdtos9FkWeZEOnv8NvwRNatg49va8FRK7NcE0bTHh8Vaol77o+GW
	5kYwc9tSHiN9AeEWnT5mbb6deDQP1sNwc2RvfFKs8tI+NQuoRRxbuLNaLhSyVK/U
	JNw3vWahFLgt5DHQJYh9hZXZGJ5SO5LIOCGZZvUpAFPFHZUgyjo29NwOUcHd73Ew
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45rqc0mxn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Apr 2025 15:27:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 532BjQsC019410;
	Wed, 2 Apr 2025 15:27:04 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45pu6t8s3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Apr 2025 15:27:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 532FR0u851970510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Apr 2025 15:27:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 990AD2004B;
	Wed,  2 Apr 2025 15:27:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DF2620049;
	Wed,  2 Apr 2025 15:27:00 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  2 Apr 2025 15:27:00 +0000 (GMT)
Date: Wed, 2 Apr 2025 17:26:59 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin"
 <mst@redhat.com>
Cc: stable@vger.kernel.org,
        "Maximilian Immanuel Brandtner"
 <maxbr@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio_console: fix missing byte order handling for
 cols and rows
Message-ID: <20250402172659.59df72d2.pasic@linux.ibm.com>
In-Reply-To: <20250322002954.3129282-1-pasic@linux.ibm.com>
References: <20250322002954.3129282-1-pasic@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: dmdoYNaYsMeuGv-45p-NZvtXGA3aFdTw
X-Proofpoint-GUID: dmdoYNaYsMeuGv-45p-NZvtXGA3aFdTw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-02_06,2025-04-02_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504020098

On Sat, 22 Mar 2025 01:29:54 +0100
Halil Pasic <pasic@linux.ibm.com> wrote:

> As per virtio spec the fields cols and rows are specified as little
> endian. 
[..]

@Amit: Any feedback?

> 
> Fixes: 8345adbf96fc1 ("virtio: console: Accept console size along with resize control message")
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Cc: stable@vger.kernel.org # v2.6.35+
> ---
> 
> @Michael: I think it would be nice to add a clarification on the byte
> order to be used for cols and rows when the legacy interface is used to
> the spec, regardless of what we decide the right byte order is. If
> it is native endian that shall be stated much like it is stated for
> virtio_console_control. If it is little endian, I would like to add
> a sentence that states that unlike for the fields of virtio_console_control
> the byte order of the fields of struct virtio_console_resize is little
> endian also when the legacy interface is used.

@MST: any opinion on that?

[..]

