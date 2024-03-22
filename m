Return-Path: <kvm+bounces-12479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C008886A23
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 11:22:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D61502822A2
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 10:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC32836AF3;
	Fri, 22 Mar 2024 10:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OCumWId4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CDF39AC5;
	Fri, 22 Mar 2024 10:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711102950; cv=none; b=qYtJ3u2Rj386j7gmsPnHdzFI+Aoa5w+SyhY2lufc+/L+1tQiuQJwDHKdGwkZVMPHgOVz1kbuiU6m/um8v1IXi++A4wZpQUx81YdbjS+4pKF8O/zbpdqXqE3qE4x9p6UMGsPk8LOTL8R1zBv8IQ5DxACkWn5c0hJycFbKQnaYBiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711102950; c=relaxed/simple;
	bh=vMwYb4avxUZsb6Vz24fjsEAOtzod3kHSa/OcSBljTCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WJG/2ful8/knSRCOb4wjRU3toYRCy50kp3jGStHAIHyZsjETcjnzngE9RZ8jGuXpGXy4xVDR3cr3011J+EeVOpW773Klpd3YWqYD2BgZDf+T4YzEFAtDlooJ3dk7IAhGZPp0UPoIO9KWqbnlFMOQ5p8ikGkD/HmLY2RzTcCnz9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OCumWId4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42M7D0oO029705;
	Fri, 22 Mar 2024 10:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=t4EtCupj1AZsWtQ2aOS+eqQ4iFxWWbTe9gpwh+nYbgo=;
 b=OCumWId4GftXCC+x8XAN+4LzM5nfQc2Vt/51ofVBaheILkrNgywAF5nxxOT3ugMMfwbA
 1j5by1l1X8hD/dPcSokAsNhZQLcXz8nqpLC+Cu9zYl0eS1zXrKF4DX7eTP2hP4jZOhlx
 o1dJkNZqgSVbr4Ls/DqVHnLHaHi16bwnPxADpGBOxYuNj2PuyOuROQrTgkRAByE28Erw
 oTIUczGUPaIVhc+8YtXnQkXdcDeqTeLiLoc8RaopVRYflvAYekQkr+c+ijVVQ1lpoUAl
 njxfj2pDb7jDT7OCs/USg4OVicIPam4oA9xB1eNAGfqoXjxMcH3Oy0ne/uQchOaBQKIP AA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x15d30c1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Mar 2024 10:22:21 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42MAMLB0015406;
	Fri, 22 Mar 2024 10:22:21 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x15d30c1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Mar 2024 10:22:21 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42M8kq8w015722;
	Fri, 22 Mar 2024 10:22:20 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x0x15k3nh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Mar 2024 10:22:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42MAMEqP47382980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Mar 2024 10:22:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EE7620067;
	Fri, 22 Mar 2024 10:22:14 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DC812004F;
	Fri, 22 Mar 2024 10:22:14 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 22 Mar 2024 10:22:14 +0000 (GMT)
Message-ID: <ed0f05de-0e17-41ec-85b2-be8603b0556a@linux.ibm.com>
Date: Fri, 22 Mar 2024 11:22:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] s390/mm: re-enable the shared zeropage for !PV and
 !skeys KVM guests
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20240321215954.177730-1-david@redhat.com>
 <20240321215954.177730-3-david@redhat.com>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240321215954.177730-3-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ztFlzz80v3ERALXfSy3FTl3bPX6Bi31k
X-Proofpoint-ORIG-GUID: 3N0heez5LomRZyHLGJD7rvjWaDPGsK2B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-22_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 clxscore=1011 priorityscore=1501 impostorscore=0 bulkscore=0 adultscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403220074



Am 21.03.24 um 22:59 schrieb David Hildenbrand:
> commit fa41ba0d08de ("s390/mm: avoid empty zero pages for KVM guests to
> avoid postcopy hangs") introduced an undesired side effect when combined
> with memory ballooning and VM migration: memory part of the inflated
> memory balloon will consume memory.
> 
> Assuming we have a 100GiB VM and inflated the balloon to 40GiB. Our VM
> will consume ~60GiB of memory. If we now trigger a VM migration,
> hypervisors like QEMU will read all VM memory. As s390x does not support
> the shared zeropage, we'll end up allocating for all previously-inflated
> memory part of the memory balloon: 50 GiB. So we might easily
> (unexpectedly) crash the VM on the migration source.
> 
> Even worse, hypervisors like QEMU optimize for zeropage migration to not
> consume memory on the migration destination: when migrating a
> "page full of zeroes", on the migration destination they check whether the
> target memory is already zero (by reading the destination memory) and avoid
> writing to the memory to not allocate memory: however, s390x will also
> allocate memory here, implying that also on the migration destination, we
> will end up allocating all previously-inflated memory part of the memory
> balloon.
> 
> This is especially bad if actual memory overcommit was not desired, when
> memory ballooning is used for dynamic VM memory resizing, setting aside
> some memory during boot that can be added later on demand. Alternatives
> like virtio-mem that would avoid this issue are not yet available on
> s390x.
> 
> There could be ways to optimize some cases in user space: before reading
> memory in an anonymous private mapping on the migration source, check via
> /proc/self/pagemap if anything is already populated. Similarly check on
> the migration destination before reading. While that would avoid
> populating tables full of shared zeropages on all architectures, it's
> harder to get right and performant, and requires user space changes.
> 
> Further, with posctopy live migration we must place a page, so there,
> "avoid touching memory to avoid allocating memory" is not really
> possible. (Note that a previously we would have falsely inserted
> shared zeropages into processes using UFFDIO_ZEROPAGE where
> mm_forbids_zeropage() would have actually forbidden it)
> 
> PV is currently incompatible with memory ballooning, and in the common
> case, KVM guests don't make use of storage keys. Instead of zapping
> zeropages when enabling storage keys / PV, that turned out to be
> problematic in the past, let's do exactly the same we do with KSM pages:
> trigger unsharing faults to replace the shared zeropages by proper
> anonymous folios.
> 
> What about added latency when enabling storage kes? Having a lot of
> zeropages in applicable environments (PV, legacy guests, unittests) is
> unexpected. Further, KSM could today already unshare the zeropages
> and unmerging KSM pages when enabling storage kets would unshare the
> KSM-placed zeropages in the same way, resulting in the same latency.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Nice work. Looks good to me and indeed it fixes the memory
over-consumption that you mentioned.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
(can also be seen with virsh managedsave; virsh start)

I guess its too invasive for stable, but I would say it is real fix.

