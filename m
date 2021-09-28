Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B86B41B37B
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241794AbhI1QFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:05:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24170 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241786AbhI1QFr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 12:05:47 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SFCNtb002659;
        Tue, 28 Sep 2021 12:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7KE/l+fn+hjlTv8Mm7K3OhvpVA5YLs9/5BHfIjHaKO8=;
 b=CgcawE+Sl1hzL9SmWK+kibLgv2irfLPv80oxtLEUyIDaPWhzI2BWwz0PZneoGTymkFzq
 pAQahI7FnGjUa5gLreeP78Wa2QmiycGQGMWdcxQMlYRSy/oqoEV/4KqJMuJlf5lqcqfl
 r0HBSV/e5edI0MTkEzhCL8rqXSlDmunE4LzbIwpIcbnqovLv6P2r0rz0KHpUM4hS8Vf8
 JNvI1WZQWPaa7BBqhKRYQaA61JK/6Z+ZTScUlAeCDcC3mGRuSKghTQr5QZqwhenWK+fM
 nC/NW4kGmj6Zs/XCQRRVeML7ogHEwC8CPh/Co9RBfFZjXcSbx/vfe1ebS3kklrmAinZ+ Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbjbn0qrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 12:03:54 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18SG283R007674;
        Tue, 28 Sep 2021 12:03:53 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbjbn0qqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 12:03:53 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SFvrMr004260;
        Tue, 28 Sep 2021 16:03:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3b9ud9yr6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 16:03:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SFwkpV61342166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 15:58:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A92B152051;
        Tue, 28 Sep 2021 16:03:47 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.40.159])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 04ADE52069;
        Tue, 28 Sep 2021 16:03:46 +0000 (GMT)
Subject: Re: [PATCH resend RFC 0/9] s390: fixes, cleanups and optimizations
 for page table walkers
To:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
References: <20210909162248.14969-1-david@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <89c5c267-1299-3c91-465a-c5950d88658d@de.ibm.com>
Date:   Tue, 28 Sep 2021 18:03:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210909162248.14969-1-david@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vB3pLLblhg1B0CygD1Boj2PN2rvMslgS
X-Proofpoint-ORIG-GUID: Bi9WaOFC_I3K05CEVOg2NsEQ3xYkt1Xn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 09.09.21 um 18:22 schrieb David Hildenbrand:
> Resend because I missed ccing people on the actual patches ...
> 
> RFC because the patches are essentially untested and I did not actually
> try to trigger any of the things these patches are supposed to fix. It
> merely matches my current understanding (and what other code does :) ). I
> did compile-test as far as possible.
> 
> After learning more about the wonderful world of page tables and their
> interaction with the mmap_sem and VMAs, I spotted some issues in our
> page table walkers that allow user space to trigger nasty behavior when
> playing dirty tricks with munmap() or mmap() of hugetlb. While some issues
> should be hard to trigger, others are fairly easy because we provide
> conventient interfaces (e.g., KVM_S390_GET_SKEYS and KVM_S390_SET_SKEYS).
> 
> Future work:
> - Don't use get_locked_pte() when it's not required to actually allocate
>    page tables -- similar to how storage keys are now handled. Examples are
>    get_pgste() and __gmap_zap.
> - Don't use get_locked_pte() and instead let page fault logic allocate page
>    tables when we actually do need page tables -- also, similar to how
>    storage keys are now handled. Examples are set_pgste_bits() and
>    pgste_perform_essa().
> - Maybe switch to mm/pagewalk.c to avoid custom page table walkers. For
>    __gmap_zap() that's very easy.
> 
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> 
> David Hildenbrand (9):
>    s390/gmap: validate VMA in __gmap_zap()
>    s390/gmap: don't unconditionally call pte_unmap_unlock() in
>      __gmap_zap()
>    s390/mm: validate VMA in PGSTE manipulation functions
>    s390/mm: fix VMA and page table handling code in storage key handling
>      functions
>    s390/uv: fully validate the VMA before calling follow_page()
>    s390/pci_mmio: fully validate the VMA before calling follow_pte()
>    s390/mm: no need for pte_alloc_map_lock() if we know the pmd is
>      present
>    s390/mm: optimize set_guest_storage_key()
>    s390/mm: optimize reset_guest_reference_bit()
> 
>   arch/s390/kernel/uv.c    |   2 +-
>   arch/s390/mm/gmap.c      |  11 +++-
>   arch/s390/mm/pgtable.c   | 109 +++++++++++++++++++++++++++------------
>   arch/s390/pci/pci_mmio.c |   4 +-
>   4 files changed, 89 insertions(+), 37 deletions(-)
> 

Thanks applied. Will run some test on those commits, but its already pushed
out to my next tree to give it some coverage.
g
