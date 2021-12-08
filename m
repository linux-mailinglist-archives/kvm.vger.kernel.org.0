Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4672346D103
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 11:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhLHKd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 05:33:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6734 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230142AbhLHKd5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 05:33:57 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8AR4K7028072;
        Wed, 8 Dec 2021 10:30:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=fvTVLwE/9nsnvXdkLI0gUE5KzjXztLZJg3xlZ7W9kZ8=;
 b=Syv+FhQTRzVPsIOR7yICVKL4S67QtAWVO1PAOiPGwmNquQbmSQToy7M6V7AqdD+J/3rl
 M+MYbDNVCkm/snIh7JimJ20HcsZW4qEVQVTo4nlc0yvt99LfOtWqMy5MGkanx5YkFT6e
 b5QETAkCI6SRwUCNPwU44b7Isf4jYSFXfD0qB63N0rH54nh2wIEW0pDV6dxpCiKropJy
 tjPe8mFEVsMAHBevTWGHTkNuKGW4RO5YlndbZf9tfQxBxvZkIK1MR7zNtKGhl5LpU4T1
 Xg7DndlhadUK8Pe85uCthBYw7F0aet60NMu0HofRNxwN4tMuvTZkKuPbUM8AE/ilsFiI NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cttyd01yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 10:30:25 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8AUOZr009219;
        Wed, 8 Dec 2021 10:30:24 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cttyd01xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 10:30:24 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8AHqIj009815;
        Wed, 8 Dec 2021 10:30:22 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3cqykfw6t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 10:30:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8AUITL22544684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 10:30:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FDF1A406D;
        Wed,  8 Dec 2021 10:30:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2252FA406B;
        Wed,  8 Dec 2021 10:30:17 +0000 (GMT)
Received: from sig-9-145-190-99.de.ibm.com (unknown [9.145.190.99])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 10:30:16 +0000 (GMT)
Message-ID: <fc3c836ccb697a7e7123ab70015bd2a40b7cb5d4.camel@linux.ibm.com>
Subject: Re: [PATCH 23/32] KVM: s390: pci: handle refresh of PCI translations
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 08 Dec 2021 11:30:16 +0100
In-Reply-To: <20211207205743.150299-24-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-24-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -fw4gFnq0n1eBm8ReYBTxcKt8cF2w3kK
X-Proofpoint-GUID: tmmPgweduodehvu1T7JFVrZGU83I_o-M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112080065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-07 at 15:57 -0500, Matthew Rosato wrote:
> Add a routine that will perform a shadow operation between a guest
> and host IOAT.  A subsequent patch will invoke this in response to
> an 04 RPCIT instruction intercept.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_pci.h |   1 +
>  arch/s390/include/asm/pci_dma.h |   1 +
>  arch/s390/kvm/pci.c             | 191 ++++++++++++++++++++++++++++++++
>  arch/s390/kvm/pci.h             |   4 +-
>  4 files changed, 196 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 254275399f21..97e3a369135d 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -30,6 +30,7 @@ struct kvm_zdev_ioat {
>  struct kvm_zdev {
>  	struct zpci_dev *zdev;
>  	struct kvm *kvm;
> +	u64 rpcit_count;
>  	struct kvm_zdev_ioat ioat;
>  	struct zpci_fib fib;
>  };
> diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
> index e1d3c1d3fc8a..0ca15e5db3d9 100644
> --- a/arch/s390/include/asm/pci_dma.h
> +++ b/arch/s390/include/asm/pci_dma.h
> @@ -52,6 +52,7 @@ enum zpci_ioat_dtype {
>  #define ZPCI_TABLE_ENTRIES		(ZPCI_TABLE_SIZE / ZPCI_TABLE_ENTRY_SIZE)
>  #define ZPCI_TABLE_PAGES		(ZPCI_TABLE_SIZE >> PAGE_SHIFT)
>  #define ZPCI_TABLE_ENTRIES_PAGES	(ZPCI_TABLE_ENTRIES * ZPCI_TABLE_PAGES)
> +#define ZPCI_TABLE_ENTRIES_PER_PAGE	(ZPCI_TABLE_ENTRIES / ZPCI_TABLE_PAGES)
>  
>  #define ZPCI_TABLE_BITS			11
>  #define ZPCI_PT_BITS			8
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index a1c0c0881332..858c5ecdc8b9 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -123,6 +123,195 @@ int kvm_s390_pci_aen_init(u8 nisc)
>  	return rc;
>  }
>  
> +static int dma_shadow_cpu_trans(struct kvm_vcpu *vcpu, unsigned long *entry,
> +				unsigned long *gentry)
> +{
> +	unsigned long idx;
> +	struct page *page;
> +	void *gaddr = NULL;
> +	kvm_pfn_t pfn;
> +	gpa_t addr;
> +	int rc = 0;
> +
> +	if (pt_entry_isvalid(*gentry)) {
> +		/* pin and validate */
> +		addr = *gentry & ZPCI_PTE_ADDR_MASK;
> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
> +		page = gfn_to_page(vcpu->kvm, gpa_to_gfn(addr));
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +		if (is_error_page(page))
> +			return -EIO;
> +		gaddr = page_to_virt(page) + (addr & ~PAGE_MASK);

Hmm, this looks like a virtual vs physical address mixup to me that is
currently not a problem because kernel virtual addresses are equal to
their physical address. Here page_to_virt(page) gives us a virtual
address but the entries in the I/O translation table have to be
physical (aka absolute) addresses.

With my commit "s390/pci: use physical addresses in DMA tables"
currently in the s390 feature branch this is also reflected in the
argument types taken by set_pt_pfaa() below so gaddr should have type
phys_addr_t not void *. That should also remove the need for the cast
to unsigned long for the duplicate check.

> +	}
> +
> +	if (pt_entry_isvalid(*entry)) {
> +		/* Either we are invalidating, replacing or no-op */
> +		if (gaddr) {
> +			if ((*entry & ZPCI_PTE_ADDR_MASK) ==
> +			    (unsigned long)gaddr) {
> +				/* Duplicate */
> +				kvm_release_pfn_dirty(*entry >> PAGE_SHIFT);
> +			} else {
> +				/* Replace */
> +				pfn = (*entry >> PAGE_SHIFT);
> +				invalidate_pt_entry(entry);
> +				set_pt_pfaa(entry, gaddr);
> +				validate_pt_entry(entry);
> +				kvm_release_pfn_dirty(pfn);
> +				rc = 1;
> +			}
> +		} else {
> +			/* Invalidate */
> +			pfn = (*entry >> PAGE_SHIFT);
> +			invalidate_pt_entry(entry);
> +			kvm_release_pfn_dirty(pfn);
> +			rc = 1;
> +		}
> +	} else if (gaddr) {
> +		/* New Entry */
> +		set_pt_pfaa(entry, gaddr);
> +		validate_pt_entry(entry);
> +	}
> +
> +	return rc;
> +}
> +
> +unsigned long *dma_walk_guest_cpu_trans(struct kvm_vcpu *vcpu,
> +					struct kvm_zdev_ioat *ioat,
> +					dma_addr_t dma_addr)
> +{
> +	unsigned long *rto, *sto, *pto;
> +	unsigned int rtx, rts, sx, px, idx;
> +	struct page *page;
> +	gpa_t addr;
> +	int i;
> +
> +	/* Pin guest segment table if needed */
> +	rtx = calc_rtx(dma_addr);
> +	rto = ioat->head[(rtx / ZPCI_TABLE_ENTRIES_PER_PAGE)];
> +	rts = rtx * ZPCI_TABLE_PAGES;
> +	if (!ioat->seg[rts]) {
> +		if (!reg_entry_isvalid(rto[rtx % ZPCI_TABLE_ENTRIES_PER_PAGE]))
> +			return NULL;
> +		sto = get_rt_sto(rto[rtx % ZPCI_TABLE_ENTRIES_PER_PAGE]);
> +		addr = ((u64)sto & ZPCI_RTE_ADDR_MASK);
> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
> +		for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
> +			page = gfn_to_page(vcpu->kvm, gpa_to_gfn(addr));
> +			if (is_error_page(page)) {
> +				srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +				return NULL;
> +			}
> +			ioat->seg[rts + i] = page_to_virt(page) +
> +					     (addr & ~PAGE_MASK);

Here on the other hand I think the page_to_virt() is correct since you
want the virtual addresses to be able to derference it, correct? 

> +			addr += PAGE_SIZE;
> +		}
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +	}
> +
> +	/* Allocate pin pointers for another segment table if needed */
> +	if (!ioat->pt[rtx]) {
> +		ioat->pt[rtx] = kcalloc(ZPCI_TABLE_ENTRIES,
> +					(sizeof(unsigned long *)), GFP_KERNEL);
> +		if (!ioat->pt[rtx])
> +			return NULL;
> +	}
> +	/* Pin guest page table if needed */
> +	sx = calc_sx(dma_addr);
> +	sto = ioat->seg[(rts + (sx / ZPCI_TABLE_ENTRIES_PER_PAGE))];
> +	if (!ioat->pt[rtx][sx]) {
> +		if (!reg_entry_isvalid(sto[sx % ZPCI_TABLE_ENTRIES_PER_PAGE]))
> +			return NULL;
> +		pto = get_st_pto(sto[sx % ZPCI_TABLE_ENTRIES_PER_PAGE]);
> +		if (!pto)
> +			return NULL;
> +		addr = ((u64)pto & ZPCI_STE_ADDR_MASK);
> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
> +		page = gfn_to_page(vcpu->kvm, gpa_to_gfn(addr));
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +		if (is_error_page(page))
> +			return NULL;
> +		ioat->pt[rtx][sx] = page_to_virt(page) + (addr & ~PAGE_MASK);

Same as above.

> +	}
> +	pto = ioat->pt[rtx][sx];
> +
> +	/* Return guest PTE */
> +	px = calc_px(dma_addr);
> +	return &pto[px];
> +}
> +
> 
---8<---

