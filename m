Return-Path: <kvm+bounces-55599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B7EB3385D
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 09:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 070F3189615B
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 07:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D6B29AB03;
	Mon, 25 Aug 2025 07:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MDak/p70"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A461299943;
	Mon, 25 Aug 2025 07:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756108747; cv=none; b=sQ+5eEOEmV7APQ2TXCqRjp0J99/5ej8NbeJd0y1/JAIKNDVYcqdnE7Ki7NhJcr+BGHTHBUK+7xY5eOuh1y0F9+XuMPXxK8sV2rYGzh9pxZT8tK6GcBFgd/y/ZCeiJVt32XvlJLsV6Ankz7XDTLxFTiP5A3SqN7NFCWbQfjIwwnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756108747; c=relaxed/simple;
	bh=7LCQFks4hMexpSXOFIoo+iH2Rh4kkXuCoo92zMiwUj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZmVbNV4C4e8avWQ/oaJh8O1i1MoeQw2UNvWqh2FEdc2/y5rD4C7hg+soDvNiyIDoRM+NOU0sJcvC8ly/AVMPaWdWPkHNcB6fgracQb+LRoA0wQ/musSyad4bCdV9kqcGKuTrRr0vcTRdrNaeV+v/PCpn4FpaEPeIght/PQotUCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MDak/p70; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57P3uq6I025621;
	Mon, 25 Aug 2025 07:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Zf6dsK
	CvZqImi5w4uJYMKsuJntcugfcozvUzZHtxbZI=; b=MDak/p70L3VYD6S31i9eiu
	WIZIqy/qWwz7zyKG7/V6axE5oK96HO3eY+feDBpxyfjz5iqND1f3BH8MvyBW6N/S
	vjMOvNG/JuOOL0sszPuJiXxfcVJ5rLFtVsZzn1qVD67QFztMXsiCeJPcvifBSDcI
	er8vDHDaHqqRq4sU52AtZ9OGmUF0c5kwR1KXjkMWHRVmPHZ6lMCKMdUsqPe5Lwz6
	wrsMiOxCnxwWoTxlOBkXNBG68lEmc5oepYfN/eTImV8jcsWD/C7OsUEy6Vsv3rxW
	yiWQCRhIxsWevdZaHyOEjfSvQRQ2wh7gTAyCA+BxfosoKoh/OSTbDfWT5KJsLDPw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5av7pqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 07:59:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57P5YFHF002520;
	Mon, 25 Aug 2025 07:59:01 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48qrypctwc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 07:59:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57P7wvhX52494728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 07:58:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 65C4C20043;
	Mon, 25 Aug 2025 07:58:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0F8620040;
	Mon, 25 Aug 2025 07:58:56 +0000 (GMT)
Received: from [9.111.41.71] (unknown [9.111.41.71])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 07:58:56 +0000 (GMT)
Message-ID: <b172da07-692c-4462-bbd0-ef61073326a4@linux.ibm.com>
Date: Mon, 25 Aug 2025 09:58:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: Fix access to unavailable adapter indicator
 pages during postcopy
To: Thomas Huth <thuth@redhat.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>,
        kvm@vger.kernel.org
Cc: Peter Xu <peterx@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20250821152309.847187-1-thuth@redhat.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 xsFNBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6
 qLqYr+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv
 15mH49iKSmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZe
 zuMRBivJQQI1esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzb
 lDbbTlEeyBACeED7DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoL
 Esb8Y4avOYIgYDhgkCh0nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk
 0m3WJwvwd1s878HrQNK0orWd8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0S
 cITWU9Rxb04XyigY4XmZ8dywaxwi2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsU
 Z+/ldjToHnq21MNa1wx0lCEipCCyE/8K9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNj
 HTOLb2g2UT65AjZEQE95U2AY9iYm5usMqaWD39pAHfhC09/7NQARAQABzSVKYW5vc2NoIEZy
 YW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+wsF3BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUI
 CQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQALjkdj5euJVI2nNT3/IAxAhQSmRhPEt0
 AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxTdSNSAN/5Z7qmOR9JySvDOf4d3mS
 bMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmjGhe2YUhJLR1v1LguME+YseT
 eXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwhfPCCUK0850o1fUAYq5p
 CNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEjOxu3dqgIKbHbjza
 EXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprAY94hY3F4trT
 rQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJVrweMub
 UscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK15k/
 RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNq
 dq2v0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPL
 jJbazsFNBFubpD4BEADAcUTRqXF/aY53OSH7IwIK9lFKxIm0IoFkOEh7LMfp7FGzaP7ANrZd
 cIzhZi38xyOkcaFY+npGEWvko7rlIAn0JpBO4x3hfhmhBD/WSY8LQIFQNNjEm3vzrMo7b9Jb
 JAqQxfbURY3Dql3GUzeWTG9uaJ00u+EEPlY8zcVShDltIl5PLih20e8xgTnNzx5c110lQSu0
 iZv2lAE6DM+2bJQTsMSYiwKlwTuv9LI9Chnoo6+tsN55NqyMxYqJgElk3VzlTXSr3+rtSCwf
 tq2cinETbzxc1XuhIX6pu/aCGnNfuEkM34b7G1D6CPzDMqokNFbyoO6DQ1+fW6c5gctXg/lZ
 602iEl4C4rgcr3+EpfoPUWzKeM8JXv5Kpq4YDxhvbitr8Dm8gr38+UKFZKlWLlwhQ56r/zAU
 v6LIsm11GmFs2/cmgD1bqBTNHHcTWwWtRTLgmnqJbVisMJuYJt4KNPqphTWsPY8SEtbufIlY
 HXOJ2lqUzOReTrie2u0qcSvGAbSfec9apTFl2Xko/ddqPcZMpKhBiXmY8tJzSPk3+G4tqur4
 6TYAm5ouitJsgAR61Cu7s+PNuq/pTLDhK+6/Njmc94NGBcRA4qTuysEGE79vYWP2oIAU4Fv6
 gqaWHZ4MEI2XTqH8wiwzPdCQPYsSE0fXWiYu7ObeErT6iLSTZGx4rQARAQABwsFfBBgBCAAJ
 BQJbm6Q+AhsMAAoJEONU5rjiOLn4DDEP/RuyckW65SZcPG4cMfNgWxZF8rVjeVl/9PBfy01K
 8R0hajU40bWtXSMiby7j0/dMjz99jN6L+AJHJvrLz4qYRzn2Ys843W+RfXj62Zde4YNBE5SL
 jJweRCbMWKaJLj6499fctxTyeb9+AMLQS4yRSwHuAZLmAb5AyCW1gBcTWZb8ON5BmWnRqeGm
 IgC1EvCnHy++aBnHTn0m+zV89BhTLTUal35tcjUFwluBY39R2ux/HNlBO1GY3Z+WYXhBvq7q
 katThLjaQSmnOrMhzqYmdShP1leFTVbzXUUIYv/GbynO/YrL2gaQpaP1bEUEi8lUAfXJbEWG
 dnHFkciryi092E8/9j89DJg4mmZqOau7TtUxjRMlBcIliXkzSLUk+QvD4LK1kWievJse4mte
 FBdkWHfP4BH/+8DxapRcG1UAheSnSRQ5LiO50annOB7oXF+vgKIaie2TBfZxQNGAs3RQ+bga
 DchCqFm5adiSP5+OT4NjkKUeGpBe/aRyQSle/RropTgCi85pje/juYEn2P9UAgkfBJrOHvQ9
 Z+2Sva8FRd61NJLkCJ4LFumRn9wQlX2icFbi8UDV3do0hXJRRYTWCxrHscMhkrFWLhYiPF4i
 phX7UNdOWBQ90qpHyAxHmDazdo27gEjfvsgYMdveKknEOTEb5phwxWgg7BcIDoJf9UMC
In-Reply-To: <20250821152309.847187-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d3_Sz99F3zTh9VJAhpUpbZjJiwTa6YWR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfX3urjkaXzKH/a
 ijwfMZtgEm+EVN/Om7jBPITedQ1syhFS79QSzIdvaaLtZS9eanJwtMT/vh7+1H/QvY+gIeIa0ij
 pptOBu4XiEsYAfAnfmWWfF/vzoNyMKRoJxh7zqo9wG75Fz7rFvJ5H1vULXTg+Up7qLLn4Na2cSn
 ZPHxSllZWPWYjRN5MClj+pyXK5oK0KcTmKSKQo1JuVmG+U1OWEfAowcr3DHZwnQreYXsXhhIrAu
 PuldRpeYYSB/d/3uK+gNfHjS1jWMKMX42RMwk3WmnyCDUGyZGznLPscreAhpbZTNvTuSD4lnevm
 caLbHGH7BpvSlTZdS8AjStgTX9yb1S1ESCtiroU3+ZxlmnW/CqVUDt8o345iCLEZdxRwPp6Nt+u
 wEwJZWO7
X-Proofpoint-ORIG-GUID: d3_Sz99F3zTh9VJAhpUpbZjJiwTa6YWR
X-Authority-Analysis: v=2.4 cv=SNNCVPvH c=1 sm=1 tr=0 ts=68ac17c6 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=btW-XHHgg9hxShBi8oQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508230021

On 8/21/25 5:23 PM, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> When you run a KVM guest with vhost-net and migrate that guest to
> another host, and you immediately enable postcopy after starting the
> migration, there is a big chance that the network connection of the
> guest won't work anymore on the destination side after the migration.
> 
> With a debug kernel v6.16.0, there is also a call trace that looks
> like this:
> 
>   FAULT_FLAG_ALLOW_RETRY missing 881
>   CPU: 6 UID: 0 PID: 549 Comm: kworker/6:2 Kdump: loaded Not tainted 6.16.0 #56 NONE
>   Hardware name: IBM 3931 LA1 400 (LPAR)
>   Workqueue: events irqfd_inject [kvm]
>   Call Trace:
>    [<00003173cbecc634>] dump_stack_lvl+0x104/0x168
>    [<00003173cca69588>] handle_userfault+0xde8/0x1310
>    [<00003173cc756f0c>] handle_pte_fault+0x4fc/0x760
>    [<00003173cc759212>] __handle_mm_fault+0x452/0xa00
>    [<00003173cc7599ba>] handle_mm_fault+0x1fa/0x6a0
>    [<00003173cc73409a>] __get_user_pages+0x4aa/0xba0
>    [<00003173cc7349e8>] get_user_pages_remote+0x258/0x770
>    [<000031734be6f052>] get_map_page+0xe2/0x190 [kvm]
>    [<000031734be6f910>] adapter_indicators_set+0x50/0x4a0 [kvm]
>    [<000031734be7f674>] set_adapter_int+0xc4/0x170 [kvm]
>    [<000031734be2f268>] kvm_set_irq+0x228/0x3f0 [kvm]
>    [<000031734be27000>] irqfd_inject+0xd0/0x150 [kvm]
>    [<00003173cc00c9ec>] process_one_work+0x87c/0x1490
>    [<00003173cc00dda6>] worker_thread+0x7a6/0x1010
>    [<00003173cc02dc36>] kthread+0x3b6/0x710
>    [<00003173cbed2f0c>] __ret_from_fork+0xdc/0x7f0
>    [<00003173cdd737ca>] ret_from_fork+0xa/0x30
>   3 locks held by kworker/6:2/549:
>    #0: 00000000800bc958 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x7ee/0x1490
>    #1: 000030f3d527fbd0 ((work_completion)(&irqfd->inject)){+.+.}-{0:0}, at: process_one_work+0x81c/0x1490
>    #2: 00000000f99862b0 (&mm->mmap_lock){++++}-{3:3}, at: get_map_page+0xa8/0x190 [kvm]
> 
> The "FAULT_FLAG_ALLOW_RETRY missing" indicates that handle_userfaultfd()
> saw a page fault request without ALLOW_RETRY flag set, hence userfaultfd
> cannot remotely resolve it (because the caller was asking for an immediate
> resolution, aka, FAULT_FLAG_NOWAIT, while remote faults can take time).
> With that, get_map_page() failed and the irq was lost.
> 
> We should not be strictly in an atomic environment here and the worker
> should be sleepable (the call is done during an ioctl from userspace),
> so we can allow adapter_indicators_set() to just sleep waiting for the
> remote fault instead.
> 
> Link: https://issues.redhat.com/browse/RHEL-42486
> Signed-off-by: Peter Xu <peterx@redhat.com>
> [thuth: Assembled patch description and fixed some cosmetical issues]
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

