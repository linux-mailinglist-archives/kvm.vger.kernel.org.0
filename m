Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57D3406DA1
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 16:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbhIJOcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 10:32:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233120AbhIJOco (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 10:32:44 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18AE5KdU066051;
        Fri, 10 Sep 2021 10:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=wFa34YwfOzNnf8xZrjNXgk5F3wW7c5BmLVcGAZSC9l4=;
 b=MC7za/WgGPcd/PzshwVuY6lbRD70PpWfjoENozwvmM1m5e6CkzfLmqaPmsbZyv7QhD29
 zq9tGbrXajg5iIF0zpuZlUZ6XHJguacYN+7VusxhKVGVN/rn0IqmzLPKjwlnQtKfxrUQ
 LflH73p5jsBaJu/3/mgt41uBF5pfdrgg937LRxliYqXLRa96nIvBWxI0bxn8AM87I8a8
 ZcvxaABffL3ZM75OOxvH9pHCmoorb/OSliE5mh0bbkPKEWh1eJfkQzQzKiqHbW9y+VeG
 GH189dMA3pZY29B6/WH1fDR8MzRB3y5KAq+aiMc2TnYDj7MyS2HsiGnwndI6hRdGLACv GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b05npw0tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 10:31:28 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18AEVSm0182894;
        Fri, 10 Sep 2021 10:31:28 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b05npw0st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 10:31:28 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18AEHlfj025703;
        Fri, 10 Sep 2021 14:31:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3axcnq26bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 14:31:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18AEVNQs50135536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 14:31:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4BAFA4060;
        Fri, 10 Sep 2021 14:31:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FE10A4054;
        Fri, 10 Sep 2021 14:31:23 +0000 (GMT)
Received: from sig-9-145-77-172.uk.ibm.com (unknown [9.145.77.172])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Sep 2021 14:31:23 +0000 (GMT)
Message-ID: <209614b6553374cef5fd306d4235a98472fc5e4d.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 6/9] s390/pci_mmio: fully validate the VMA before
 calling follow_pte()
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Liam Howlett <liam.howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date:   Fri, 10 Sep 2021 16:31:22 +0200
In-Reply-To: <20210910141221.fuimjijydw57vxjz@revolver>
References: <20210909145945.12192-1-david@redhat.com>
         <20210909145945.12192-7-david@redhat.com>
         <82d683ec361245e1879b3f14492cdd5c41957e52.camel@linux.ibm.com>
         <d9ec2387-2645-796e-af47-26f22516f7fa@redhat.com>
         <20210910141221.fuimjijydw57vxjz@revolver>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3ii816pfzgFPIQEVn8d2Kft3lzvux31m
X-Proofpoint-GUID: pfqh5ouby-FTJSqTcLWxod5zJ1mX_CpX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-10_04:2021-09-09,2021-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 clxscore=1011 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109100081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-10 at 14:12 +0000, Liam Howlett wrote:
> * David Hildenbrand <david@redhat.com> [210910 05:23]:
> > On 10.09.21 10:22, Niklas Schnelle wrote:
> > > On Thu, 2021-09-09 at 16:59 +0200, David Hildenbrand wrote:
> > > > We should not walk/touch page tables outside of VMA boundaries when
> > > > holding only the mmap sem in read mode. Evil user space can modify the
> > > > VMA layout just before this function runs and e.g., trigger races with
> > > > page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
> > > > with read mmap_sem in munmap").
> > > > 
> > > > find_vma() does not check if the address is >= the VMA start address;
> > > > use vma_lookup() instead.
> > > > 
> > > > Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
> > > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > > ---
> > > >   arch/s390/pci/pci_mmio.c | 4 ++--
> > > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> > > > index ae683aa623ac..c5b35ea129cf 100644
> > > > --- a/arch/s390/pci/pci_mmio.c
> > > > +++ b/arch/s390/pci/pci_mmio.c
> > > > @@ -159,7 +159,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
> > > >   	mmap_read_lock(current->mm);
> > > >   	ret = -EINVAL;
> > > > -	vma = find_vma(current->mm, mmio_addr);
> > > > +	vma = vma_lookup(current->mm, mmio_addr);
> > > >   	if (!vma)
> > > >   		goto out_unlock_mmap;
> > > >   	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> > > > @@ -298,7 +298,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
> > > >   	mmap_read_lock(current->mm);
> > > >   	ret = -EINVAL;
> > > > -	vma = find_vma(current->mm, mmio_addr);
> > > > +	vma = vma_lookup(current->mm, mmio_addr);
> > > >   	if (!vma)
> > > >   		goto out_unlock_mmap;
> > > >   	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> > > 
> > > Oh wow great find thanks! If I may say so these are not great function
> > > names. Looking at the code vma_lookup() is inded find_vma() plus the
> > > check that the looked up address is indeed inside the vma.
> > > 
> > 
> > IIRC, vma_lookup() was introduced fairly recently. Before that, this
> > additional check was open coded (and still are in some instances). It's
> > confusing, I agree.
> 
> This confusion is why I introduced vma_lookup().  My hope is to reduce
> the users of find_vma() to only those that actually need the added
> functionality, which are mostly in the mm code.

Ah I see, soo the confusingly similar names are in hope of one day
making find_vma() only visible or at least used in the mm code. That
does make more sense then. Thanks for the explanation! Maybe this would
be a good candidate for a treewide change/coccinelle script? Then again
I guess sometimes one really wants find_vma() and it's hard to tell
apart.

> 

..snip..

