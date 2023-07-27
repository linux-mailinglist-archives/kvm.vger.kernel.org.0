Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02ACE76492D
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbjG0HpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbjG0Hob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:44:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8BA6E92
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690443446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i+Jnc+rT3BXIaXZlSYwcqCAr80wt35FnztCS9ZztEBw=;
        b=f8cfxx+7V1NTSNxNRcr3YBggV1qfP+PCq1KYUsyPRcWLk+b1vaaXFT+D9yKnt3dY0/Dumc
        SwJs25RYKoJgdp5xF5JdfiwBzrlqS20+sObGRiG7z5fFZKeclbX0y5MxOb/tKECLyOwjEV
        QnGIzzJmG3Aqp20hVkdF3U5Njw9bykA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-kOTG3GGnOuutiKrBdK-XtQ-1; Thu, 27 Jul 2023 03:37:24 -0400
X-MC-Unique: kOTG3GGnOuutiKrBdK-XtQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30793c16c78so382598f8f.3
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690443443; x=1691048243;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i+Jnc+rT3BXIaXZlSYwcqCAr80wt35FnztCS9ZztEBw=;
        b=Qg7DejYhcqt7MsCQrb6Zq1GI9QAJ6trxsZ0oygWkfW0G9IZx0INEnwqfVGy2DLraM2
         FKpy9SueFbZmA1dDufZNTcg+ygYhCLgqSPEg0ENRU/WUrRgnUl5NqFBX/jsg78x3BZfG
         6fWFwqOqRlKJQHH4wOC8Ck4cX16TyOQU/ptUBmQdbQ383cVha2XWwK9pR9Q6IRZB4vZS
         UgCrDQgPCzXvwpPIKh8LfoD3lg4JcWWK8mpk2xNmFgBSMRZOTGfkcYHt2oiCdJDizwRZ
         3lN3/SZSkyALIw6sJumUHl3fquu7E7hyTRChHRwYGA+gISaNs/M5FqrQo/754ad9dsuB
         W0bQ==
X-Gm-Message-State: ABy/qLajv5pcTOlabireNiOQGaetVlj5QI1ZS3gKckMEmIOoi2JcnINr
        qNeXjTyAGAOrpzTsk4Z1a9jF2DjaLFt4yrHdhn2DrHm7F/g6ZhlQC262aYvwSJWUqwTMWBo9Oc+
        PYbFIagXJVKm3
X-Received: by 2002:a5d:694f:0:b0:317:5686:e4b9 with SMTP id r15-20020a5d694f000000b003175686e4b9mr1240170wrw.56.1690443443415;
        Thu, 27 Jul 2023 00:37:23 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGYDSPpa6V4QDGpGtic7yIC96GWW29cQg8OcFyuzEjTuLUTMCZfzKMdg4BfuySMZVfyuqRRcQ==
X-Received: by 2002:a5d:694f:0:b0:317:5686:e4b9 with SMTP id r15-20020a5d694f000000b003175686e4b9mr1240146wrw.56.1690443442962;
        Thu, 27 Jul 2023 00:37:22 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id z1-20020adfd0c1000000b0031424f4ef1dsm1221190wrh.19.2023.07.27.00.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 00:37:22 -0700 (PDT)
Message-ID: <e0b2195a-6f60-6a49-cf3f-4a528eb2df43@redhat.com>
Date:   Thu, 27 Jul 2023 09:37:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 1/2] KVM: s390: add stat counter for shadow gmap events
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230510121822.546629-1-nrb@linux.ibm.com>
 <20230510121822.546629-2-nrb@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230510121822.546629-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.05.23 14:18, Nico Boehr wrote:
> The shadow gmap tracks memory of nested guests (guest-3). In certain
> scenarios, the shadow gmap needs to be rebuilt, which is a costly operation
> since it involves a SIE exit into guest-1 for every entry in the respective
> shadow level.
> 
> Add kvm stat counters when new shadow structures are created at various
> levels. Also add a counter gmap_shadow_acquire when a completely fresh
> shadow gmap is created.
> 
> Note that when several levels are shadowed at once, counters on all
> affected levels will be increased.
> 
> Also note that not all page table levels need to be present and a ASCE
> can directly point to e.g. a segment table. In this case, a new segment
> table will always be equivalent to a new shadow gmap and hence will be
> counted as gmap_shadow_acquire and not as gmap_shadow_segment.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h | 6 ++++++
>   arch/s390/kvm/gaccess.c          | 7 +++++++
>   arch/s390/kvm/kvm-s390.c         | 8 +++++++-
>   arch/s390/kvm/vsie.c             | 1 +
>   4 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 2bbc3d54959d..d35e03e82d3d 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -777,6 +777,12 @@ struct kvm_vm_stat {
>   	u64 inject_service_signal;
>   	u64 inject_virtio;
>   	u64 aen_forward;
> +	u64 gmap_shadow_acquire;
> +	u64 gmap_shadow_r1_te;
> +	u64 gmap_shadow_r2_te;
> +	u64 gmap_shadow_r3_te;
> +	u64 gmap_shadow_sg_te;
> +	u64 gmap_shadow_pg_te;

Is "te" supposed to stand for "table entry" ?

If so, I'd suggest to just call this gmap_shadow_pg_entry etc.

>   };
>   
>   struct kvm_arch_memory_slot {
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 3eb85f254881..6f4292ad0e4a 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -1382,6 +1382,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   				  unsigned long *pgt, int *dat_protection,
>   				  int *fake)
>   {
> +	struct kvm *kvm;
>   	struct gmap *parent;
>   	union asce asce;
>   	union vaddress vaddr;
> @@ -1390,6 +1391,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   
>   	*fake = 0;
>   	*dat_protection = 0;
> +	kvm = sg->private;
>   	parent = sg->parent;
>   	vaddr.addr = saddr;
>   	asce.val = sg->orig_asce;
> @@ -1450,6 +1452,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   		rc = gmap_shadow_r2t(sg, saddr, rfte.val, *fake);
>   		if (rc)
>   			return rc;
> +		kvm->stat.gmap_shadow_r1_te++;
>   	}
>   		fallthrough;
>   	case ASCE_TYPE_REGION2: {
> @@ -1478,6 +1481,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   		rc = gmap_shadow_r3t(sg, saddr, rste.val, *fake);
>   		if (rc)
>   			return rc;
> +		kvm->stat.gmap_shadow_r2_te++;
>   	}
>   		fallthrough;
>   	case ASCE_TYPE_REGION3: {
> @@ -1515,6 +1519,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   		rc = gmap_shadow_sgt(sg, saddr, rtte.val, *fake);
>   		if (rc)
>   			return rc;
> +		kvm->stat.gmap_shadow_r3_te++;
>   	}
>   		fallthrough;
>   	case ASCE_TYPE_SEGMENT: {
> @@ -1548,6 +1553,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   		rc = gmap_shadow_pgt(sg, saddr, ste.val, *fake);
>   		if (rc)
>   			return rc;
> +		kvm->stat.gmap_shadow_sg_te++;
>   	}
>   	}
>   	/* Return the parent address of the page table */
> @@ -1618,6 +1624,7 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
>   	pte.p |= dat_protection;
>   	if (!rc)
>   		rc = gmap_shadow_page(sg, saddr, __pte(pte.val));
> +	vcpu->kvm->stat.gmap_shadow_pg_te++;
>   	ipte_unlock(vcpu->kvm);
>   	mmap_read_unlock(sg->mm);
>   	return rc;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 17b81659cdb2..ded4149e145b 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -66,7 +66,13 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>   	STATS_DESC_COUNTER(VM, inject_pfault_done),
>   	STATS_DESC_COUNTER(VM, inject_service_signal),
>   	STATS_DESC_COUNTER(VM, inject_virtio),
> -	STATS_DESC_COUNTER(VM, aen_forward)
> +	STATS_DESC_COUNTER(VM, aen_forward),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_acquire),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_r1_te),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_r2_te),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_r3_te),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_sg_te),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_pg_te),
>   };
>   
>   const struct kvm_stats_header kvm_vm_stats_header = {
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 8d6b765abf29..beb3be037722 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -1221,6 +1221,7 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
>   	if (IS_ERR(gmap))
>   		return PTR_ERR(gmap);
>   	gmap->private = vcpu->kvm;
> +	vcpu->kvm->stat.gmap_shadow_acquire++;


Do you rather want to have events for

gmap_shadow_reuse (if gmap_shadow_valid() succeeded in that function)
gmap_shadow_create (if we have to create a new one via gmap_shadow)

?

-- 
Cheers,

David / dhildenb

