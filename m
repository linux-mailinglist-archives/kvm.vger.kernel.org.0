Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBA4406C77
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 14:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhIJMuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 08:50:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233176AbhIJMuU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 08:50:20 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18ACXD0u036477;
        Fri, 10 Sep 2021 08:48:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=E/DFWdEISJRi/Y1gKRSU/cqGG8eo6W7MV0ZgTlsUblw=;
 b=Smp4JU/RIwYVqOLEa15ydAxZLCFSdRfcRdlcHOSIXOXHR9RpxXa0XaIBcUpn+8H2ny6j
 eVBPWnC4XXHzxCMHoRiq++bvhVbMNDFKHdrbl+2Lx45mdaxoXzIhly6We56pHaSV5mUD
 aOSGs49uI89G3S6bqPsrENtP1EaybKF7lBexKUNkqrdNMJTn6IvvaPCu7iHkK5YpYfQw
 UWpZ7aDb4dCqNcJ8ekH/Rngp/oexrOqHTdtMMoKIkxM6mAf268i2ha5uWZY9F/BIcwlR
 XGpjvRnBCVD6KNyezShV8MAdQmv/EA2g4QGYRfxqx5JCkNKwtJdMDhcSj2jJW0SObaAV yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b01ry81qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 08:48:54 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18ACY3Pi041730;
        Fri, 10 Sep 2021 08:48:54 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b01ry81py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 08:48:54 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18ACfV4Z014871;
        Fri, 10 Sep 2021 12:48:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3axcnp9cc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 12:48:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18ACiUgI51380652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 12:44:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9E8BAE045;
        Fri, 10 Sep 2021 12:48:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E7AAAE058;
        Fri, 10 Sep 2021 12:48:49 +0000 (GMT)
Received: from sig-9-145-77-172.uk.ibm.com (unknown [9.145.77.172])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Sep 2021 12:48:49 +0000 (GMT)
Message-ID: <dc672aa05a596a79c97339c14c09cc22559ffd10.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 6/9] s390/pci_mmio: fully validate the VMA before
 calling follow_pte()
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Date:   Fri, 10 Sep 2021 14:48:49 +0200
In-Reply-To: <d9ec2387-2645-796e-af47-26f22516f7fa@redhat.com>
References: <20210909145945.12192-1-david@redhat.com>
         <20210909145945.12192-7-david@redhat.com>
         <82d683ec361245e1879b3f14492cdd5c41957e52.camel@linux.ibm.com>
         <d9ec2387-2645-796e-af47-26f22516f7fa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WviTXLUXHIM_uory2-CQINhyQJhxlK5t
X-Proofpoint-GUID: 0YIVd7A3BA4CamRB-6ZIuFzXrVl0b_Qw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-10_04:2021-09-09,2021-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109100074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-10 at 11:23 +0200, David Hildenbrand wrote:
> On 10.09.21 10:22, Niklas Schnelle wrote:
> > On Thu, 2021-09-09 at 16:59 +0200, David Hildenbrand wrote:
> > > We should not walk/touch page tables outside of VMA boundaries when
> > > holding only the mmap sem in read mode. Evil user space can modify the
> > > VMA layout just before this function runs and e.g., trigger races with
> > > page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
> > > with read mmap_sem in munmap").
> > > 
> > > find_vma() does not check if the address is >= the VMA start address;
> > > use vma_lookup() instead.
> > > 
> > > Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > ---
> > >   arch/s390/pci/pci_mmio.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> > > index ae683aa623ac..c5b35ea129cf 100644
> > > --- a/arch/s390/pci/pci_mmio.c
> > > +++ b/arch/s390/pci/pci_mmio.c
> > > @@ -159,7 +159,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
> > >   
> > >   	mmap_read_lock(current->mm);
> > >   	ret = -EINVAL;
> > > -	vma = find_vma(current->mm, mmio_addr);
> > > +	vma = vma_lookup(current->mm, mmio_addr);
> > >   	if (!vma)
> > >   		goto out_unlock_mmap;
> > >   	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> > > @@ -298,7 +298,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
> > >   
> > >   	mmap_read_lock(current->mm);
> > >   	ret = -EINVAL;
> > > -	vma = find_vma(current->mm, mmio_addr);
> > > +	vma = vma_lookup(current->mm, mmio_addr);
> > >   	if (!vma)
> > >   		goto out_unlock_mmap;
> > >   	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> > 
> > Oh wow great find thanks! If I may say so these are not great function
> > names. Looking at the code vma_lookup() is inded find_vma() plus the
> > check that the looked up address is indeed inside the vma.
> > 
> 
> IIRC, vma_lookup() was introduced fairly recently. Before that, this 
> additional check was open coded (and still are in some instances). It's 
> confusing, I agree.
> 
> > I think this is pretty independent of the rest of the patches, so do
> > you want me to apply this patch independently or do you want to wait
> > for the others?
> 
> Sure, please go ahead and apply independently. It'd be great if you 
> could give it a quick sanity test, although I don't expect surprises -- 
> unfortunately, the environment I have easily at hand is not very well 
> suited (#cpu, #mem, #disk ...) for anything that exceeds basic compile 
> tests (and even cross-compiling is significantly faster ...).

Yes and even if you had more hardware this code path is only hit by
very specialized workloads doing MMIO access of PCI devices from
userspace. I did test with such a workload (ib_send_bw test utility)
and all looks good.

Applied and will be sent out by Heiko or Vasily as part of the s390
tree.


> 
> > In any case:
> > 
> > Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > 
> 
> Thanks!
> 

