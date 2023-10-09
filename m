Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBC77BDEE3
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 15:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376485AbjJINYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 09:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346443AbjJINYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 09:24:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD2691;
        Mon,  9 Oct 2023 06:24:16 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 399DF9PA028609;
        Mon, 9 Oct 2023 13:24:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vnZ2wA0ELzlOrQWQXwKJ3p7yUOIDeHTJQvq9Yonxozs=;
 b=emYoOIEi1LpDu3QXh1PoVoNuJ54MgHBSAEur8WL4G1X70DZY6TZyhAC3d7QLsBM9IxDv
 1G5QxM2ikqHinM4DStu2ipgUKDNjkx+3fiX4bhH9Sglxhli57vIxRwO0QjW+9KC0I/fV
 nuz3okakzjUTxjycki2mFpXEP2J8J9+YmKj6337EfM4O/CJg/w/YBHaHTiK8fw9VeR2V
 ODUUVYPeIOIVUKDXsEVpcTMmmWFQLk5SZQy8jgkjXQ3NIPKAuFgyjYTgzuQ/3Ba/ddXc
 gLFIL3AsMyXqi76BMkEPn7n0lAdiMJBW7rZ0bRsBl9f557wocE8h/veufA8qwZJKeqlf ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tmj800j93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 13:24:13 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 399DFHLp028912;
        Mon, 9 Oct 2023 13:24:12 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tmj800fe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 13:24:11 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 399C555Q026364;
        Mon, 9 Oct 2023 13:21:59 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkjnn1418-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 13:21:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 399DLt1f15008274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Oct 2023 13:21:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7AF920040;
        Mon,  9 Oct 2023 13:21:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F7C820043;
        Mon,  9 Oct 2023 13:21:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Oct 2023 13:21:55 +0000 (GMT)
Date:   Mon, 9 Oct 2023 15:20:09 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v4 1/2] KVM: s390: add stat counter for shadow gmap
 events
Message-ID: <20231009152009.2102a545@p-imbrenda>
In-Reply-To: <20231009093304.2555344-2-nrb@linux.ibm.com>
References: <20231009093304.2555344-1-nrb@linux.ibm.com>
        <20231009093304.2555344-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TWH07_tPHcRe8Uht0ccVMCGJ6yBwu_Bv
X-Proofpoint-ORIG-GUID: Md29XTqnhpTQGy3-e3eqKeCbz19-lPvS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-09_11,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 clxscore=1011 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310090109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  9 Oct 2023 11:32:52 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> The shadow gmap tracks memory of nested guests (guest-3). In certain
> scenarios, the shadow gmap needs to be rebuilt, which is a costly operation
> since it involves a SIE exit into guest-1 for every entry in the respective
> shadow level.
> 
> Add kvm stat counters when new shadow structures are created at various
> levels. Also add a counter gmap_shadow_create when a completely fresh
> shadow gmap is created as well as a counter gmap_shadow_reuse when an
> existing gmap is being reused.
> 
> Note that when several levels are shadowed at once, counters on all
> affected levels will be increased.
> 
> Also note that not all page table levels need to be present and a ASCE
> can directly point to e.g. a segment table. In this case, a new segment
> table will always be equivalent to a new shadow gmap and hence will be
> counted as gmap_shadow_create and not as gmap_shadow_segment.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/kvm_host.h | 7 +++++++
>  arch/s390/kvm/gaccess.c          | 7 +++++++
>  arch/s390/kvm/kvm-s390.c         | 9 ++++++++-
>  arch/s390/kvm/vsie.c             | 5 ++++-
>  4 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 427f9528a7b6..67a298b6cf6e 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -777,6 +777,13 @@ struct kvm_vm_stat {
>  	u64 inject_service_signal;
>  	u64 inject_virtio;
>  	u64 aen_forward;
> +	u64 gmap_shadow_create;
> +	u64 gmap_shadow_reuse;
> +	u64 gmap_shadow_r1_entry;
> +	u64 gmap_shadow_r2_entry;
> +	u64 gmap_shadow_r3_entry;
> +	u64 gmap_shadow_sg_entry;
> +	u64 gmap_shadow_pg_entry;
>  };
>  
>  struct kvm_arch_memory_slot {
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 6d6bc19b37dc..ff8349d17b33 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -1382,6 +1382,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>  				  unsigned long *pgt, int *dat_protection,
>  				  int *fake)
>  {
> +	struct kvm *kvm;
>  	struct gmap *parent;
>  	union asce asce;
>  	union vaddress vaddr;
> @@ -1390,6 +1391,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>  
>  	*fake = 0;
>  	*dat_protection = 0;
> +	kvm = sg->private;
>  	parent = sg->parent;
>  	vaddr.addr = saddr;
>  	asce.val = sg->orig_asce;
> @@ -1450,6 +1452,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>  		rc = gmap_shadow_r2t(sg, saddr, rfte.val, *fake);
>  		if (rc)
>  			return rc;
> +		kvm->stat.gmap_shadow_r1_entry++;
>  	}
>  		fallthrough;
>  	case ASCE_TYPE_REGION2: {
> @@ -1478,6 +1481,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>  		rc = gmap_shadow_r3t(sg, saddr, rste.val, *fake);
>  		if (rc)
>  			return rc;
> +		kvm->stat.gmap_shadow_r2_entry++;
>  	}
>  		fallthrough;
>  	case ASCE_TYPE_REGION3: {
> @@ -1515,6 +1519,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>  		rc = gmap_shadow_sgt(sg, saddr, rtte.val, *fake);
>  		if (rc)
>  			return rc;
> +		kvm->stat.gmap_shadow_r3_entry++;
>  	}
>  		fallthrough;
>  	case ASCE_TYPE_SEGMENT: {
> @@ -1548,6 +1553,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>  		rc = gmap_shadow_pgt(sg, saddr, ste.val, *fake);
>  		if (rc)
>  			return rc;
> +		kvm->stat.gmap_shadow_sg_entry++;
>  	}
>  	}
>  	/* Return the parent address of the page table */
> @@ -1618,6 +1624,7 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
>  	pte.p |= dat_protection;
>  	if (!rc)
>  		rc = gmap_shadow_page(sg, saddr, __pte(pte.val));
> +	vcpu->kvm->stat.gmap_shadow_pg_entry++;
>  	ipte_unlock(vcpu->kvm);
>  	mmap_read_unlock(sg->mm);
>  	return rc;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b3f17e014cab..b42493110d76 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -66,7 +66,14 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>  	STATS_DESC_COUNTER(VM, inject_pfault_done),
>  	STATS_DESC_COUNTER(VM, inject_service_signal),
>  	STATS_DESC_COUNTER(VM, inject_virtio),
> -	STATS_DESC_COUNTER(VM, aen_forward)
> +	STATS_DESC_COUNTER(VM, aen_forward),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_reuse),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_create),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_r1_entry),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_r2_entry),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_r3_entry),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_sg_entry),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_pg_entry),
>  };
>  
>  const struct kvm_stats_header kvm_vm_stats_header = {
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 61499293c2ac..02dcbe82a8e5 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -1214,8 +1214,10 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
>  	 * we're holding has been unshadowed. If the gmap is still valid,
>  	 * we can safely reuse it.
>  	 */
> -	if (vsie_page->gmap && gmap_shadow_valid(vsie_page->gmap, asce, edat))
> +	if (vsie_page->gmap && gmap_shadow_valid(vsie_page->gmap, asce, edat)) {
> +		vcpu->kvm->stat.gmap_shadow_reuse++;
>  		return 0;
> +	}
>  
>  	/* release the old shadow - if any, and mark the prefix as unmapped */
>  	release_gmap_shadow(vsie_page);
> @@ -1223,6 +1225,7 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
>  	if (IS_ERR(gmap))
>  		return PTR_ERR(gmap);
>  	gmap->private = vcpu->kvm;
> +	vcpu->kvm->stat.gmap_shadow_create++;
>  	WRITE_ONCE(vsie_page->gmap, gmap);
>  	return 0;
>  }

