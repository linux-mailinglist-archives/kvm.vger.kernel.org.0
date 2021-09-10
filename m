Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE55C406848
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 10:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhIJIYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 04:24:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231666AbhIJIYK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 04:24:10 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18A82xVP059738;
        Fri, 10 Sep 2021 04:22:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=jVxY14ywZqG7Jf4duKhASmJyUCTEy+v+4GH1vFnf6RQ=;
 b=NhTohMXYFJu5EJOqcrxdpdw5pUq7qWPVzsaodVcysGUKZZ0gJZp4cGONJSLjQJQE+iH2
 2lHNTtWNiga0XOLoxTGvzfc2s8XmwXk8FQ1lEbknElHwi+BdsmLPWTB+wF5nyLC2Jukz
 tHWS9S8+sebVrIgstnjh9ifDE6ehLdbLbgYjaddS4WWgsyt31jxvxOdT4lGKMKJCZj9f
 YXQkE6dnSh+IKdo4EKRpnyNj1uRCx1GsxbBGSB78+5rbGAXibcafLTWLF+c0sZQIEmwN
 Y49Lc9vtocWB/xyBdf4+f1XCvbhDvcLcm0R2kXcF1Zft7bz3uk9SRHEyNgiFthVFiDKJ bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ayu419y7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 04:22:57 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18A8C8FN101185;
        Fri, 10 Sep 2021 04:22:57 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ayu419y74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 04:22:57 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18A8HQMh015695;
        Fri, 10 Sep 2021 08:22:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3axcnqe9r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 08:22:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18A8MpbT26673662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 08:22:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A23D3A4065;
        Fri, 10 Sep 2021 08:22:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50858A4066;
        Fri, 10 Sep 2021 08:22:51 +0000 (GMT)
Received: from sig-9-145-77-172.uk.ibm.com (unknown [9.145.77.172])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Sep 2021 08:22:51 +0000 (GMT)
Message-ID: <82d683ec361245e1879b3f14492cdd5c41957e52.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 6/9] s390/pci_mmio: fully validate the VMA before
 calling follow_pte()
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Date:   Fri, 10 Sep 2021 10:22:50 +0200
In-Reply-To: <20210909145945.12192-7-david@redhat.com>
References: <20210909145945.12192-1-david@redhat.com>
         <20210909145945.12192-7-david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sP6U2HhjRzpPKt-WnTURwLFoYc87rO_0
X-Proofpoint-ORIG-GUID: Aty1VeXchEKLqvSS2X_qjh5vNDqqeENk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-10_02:2021-09-09,2021-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1011 impostorscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-09-09 at 16:59 +0200, David Hildenbrand wrote:
> We should not walk/touch page tables outside of VMA boundaries when
> holding only the mmap sem in read mode. Evil user space can modify the
> VMA layout just before this function runs and e.g., trigger races with
> page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
> with read mmap_sem in munmap").
> 
> find_vma() does not check if the address is >= the VMA start address;
> use vma_lookup() instead.
> 
> Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/pci/pci_mmio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> index ae683aa623ac..c5b35ea129cf 100644
> --- a/arch/s390/pci/pci_mmio.c
> +++ b/arch/s390/pci/pci_mmio.c
> @@ -159,7 +159,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
>  
>  	mmap_read_lock(current->mm);
>  	ret = -EINVAL;
> -	vma = find_vma(current->mm, mmio_addr);
> +	vma = vma_lookup(current->mm, mmio_addr);
>  	if (!vma)
>  		goto out_unlock_mmap;
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> @@ -298,7 +298,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
>  
>  	mmap_read_lock(current->mm);
>  	ret = -EINVAL;
> -	vma = find_vma(current->mm, mmio_addr);
> +	vma = vma_lookup(current->mm, mmio_addr);
>  	if (!vma)
>  		goto out_unlock_mmap;
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))

Oh wow great find thanks! If I may say so these are not great function
names. Looking at the code vma_lookup() is inded find_vma() plus the
check that the looked up address is indeed inside the vma.

I think this is pretty independent of the rest of the patches, so do
you want me to apply this patch independently or do you want to wait
for the others?

In any case:

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>

