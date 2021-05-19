Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2ABC388B5C
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 12:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347111AbhESKLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 06:11:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbhESKLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 06:11:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JA4uXW023620;
        Wed, 19 May 2021 10:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zBxKpOYS45AX71H4cYakK7LXHH18jWUsDqxQrdJXAR0=;
 b=K8ul7kEHuALw5FaN/VHvkegZRr36gm/BT8MWQb1D8Q8hGZ8jICCgGu42Ay7bUFEOhXJB
 wc9yi4+M0WQdUvtM5+kGIW6zy69LBVNkvSXbFdsFLX8z87Sv9/I4s8aKpqYFvyBhXXlX
 qIBJAg4aGm52RiCDFuRiye3vGoyefzQXFq86bMG4SvqRYE7MsnNUs9BmepJW6Rnr6dWt
 /+fH40EHZoF8Qk8wyEk0+yJAUpI6qbehXVKwbsexRtt80IU5sgP1SFvQQ0/rXnqute9Z
 nXBgO6m23tXiFQOwam/+vwEHGc2Cf6Usy5p5jcVcswfRuliR6Oj/LrsKIwbkDY5CVClf Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38j68mh1xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 10:09:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JA6QUf061734;
        Wed, 19 May 2021 10:09:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 38megkbcy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 10:09:28 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14JA9RFQ066617;
        Wed, 19 May 2021 10:09:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 38megkbcxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 10:09:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14JA9NDS010801;
        Wed, 19 May 2021 10:09:23 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 03:09:23 -0700
Date:   Wed, 19 May 2021 13:09:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH v18 11/18] RISC-V: KVM: Implement MMU notifiers
Message-ID: <20210519100912.GR1955@kadam>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
 <20210519033553.1110536-12-anup.patel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519033553.1110536-12-anup.patel@wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: XBFAJf2Ps2UQMzPRlazN4Iwzcsdu9E1e
X-Proofpoint-GUID: XBFAJf2Ps2UQMzPRlazN4Iwzcsdu9E1e
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 09:05:46AM +0530, Anup Patel wrote:
>  int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
>  			 struct kvm_memory_slot *memslot,
>  			 gpa_t gpa, unsigned long hva, bool is_write)
> @@ -569,7 +643,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
>  	struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
>  	bool logging = (memslot->dirty_bitmap &&
>  			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
> -	unsigned long vma_pagesize;
> +	unsigned long vma_pagesize, mmu_seq;
>  
>  	mmap_read_lock(current->mm);
>  
> @@ -608,6 +682,8 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
>  		return ret;
>  	}
>  
> +	mmu_seq = kvm->mmu_notifier_seq;
> +
>  	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
>  	if (hfn == KVM_PFN_ERR_HWPOISON) {
>  		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
> @@ -626,6 +702,9 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
>  
>  	spin_lock(&kvm->mmu_lock);
>  
> +	if (mmu_notifier_retry(kvm, mmu_seq))
> +		goto out_unlock;

Do we need an error code here or is it a success path?  You would
expect from the name that mmu_notifier_retry() would retry something
and return an error code, but it's actually a boolean function.

regards,
dan carpenter

> +
>  	if (writeable) {
>  		kvm_set_pfn_dirty(hfn);
>  		mark_page_dirty(kvm, gfn);
> @@ -639,6 +718,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
>  	if (ret)
>  		kvm_err("Failed to map in stage2\n");
>  
> +out_unlock:
>  	spin_unlock(&kvm->mmu_lock);
>  	kvm_set_pfn_accessed(hfn);
>  	kvm_release_pfn_clean(hfn);

