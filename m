Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F147BA356
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 17:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbjJEPyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 11:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbjJEPvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 11:51:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD59F4DF49
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 07:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696514409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eB/s9Y6w4YeBVavpvimiNB3pmiRKF4zEjUazPrN+Ua0=;
        b=SlMKc1w64vgDEVNpFpcRRDXHO368VfDZK2KvWbuYoc/zW70xXYIzgFuozTgpegGwX+IPIc
        mid0RDL2VVGARZ0BapAYoy2QmN7xW1vszraUK5Hk87mJj+DGTevMX4GbY7LpZvkDGeaQo6
        ohXccogWL4gYar0NJHyDIPZHBNkXCcQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-75ayLmXiNo-lUyIvCqWJuA-1; Thu, 05 Oct 2023 08:59:46 -0400
X-MC-Unique: 75ayLmXiNo-lUyIvCqWJuA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-327cd5c7406so670502f8f.3
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 05:59:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696510785; x=1697115585;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eB/s9Y6w4YeBVavpvimiNB3pmiRKF4zEjUazPrN+Ua0=;
        b=GjPhO1diggbEC+JEhrDxwP5waZFhWTDUdihsOENi++iVG/eLEPVBY6zl2pVCOIZZ3S
         92Y6viFrMPysVtYWBVe0uy2UJoF7JjaKp7/jn4P1H24WiJHP4ieyHcxeM/00qz9SFBpN
         VPuFwE5QVVEiICF8cUTJlKUOmGT4gr81dLTLgdp3mps8K5jsPxKoSa8Pp2slJQy1muNW
         mrg5SnP5baUUp2udyv/MmdKfoi8cGFv6acrXFoq9JpXWsxXPVUXDYjfKI7VpMCFau8JP
         ssOLYM9m7aiccxxlQ6Uhm2Jt3akn1/5JetufPbwq95UJQy7+f1cGK8Q6zoUb03jbgVzy
         Q/+A==
X-Gm-Message-State: AOJu0Yxnx5P57gjWUHOhVbwkKhECkB/zGUC0si6ud7im8Bu5fJyrYXYq
        EYXpA19JCXG9EJQIhJQ33VCO/CiivwuRisS+JPMrcj5NS+L7tQkQhwDapL5d5U1VSZBGYUA06tQ
        u8TmB6dK5DnxV
X-Received: by 2002:adf:cd0a:0:b0:31f:f72c:df95 with SMTP id w10-20020adfcd0a000000b0031ff72cdf95mr4843460wrm.21.1696510785509;
        Thu, 05 Oct 2023 05:59:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvEI5pQfZk4ZhyDAwt1LECiXblBVoH3ImmjiThxEXrj19IR2Tsvu0M7XCB7fYKnjR2dSYpvA==
X-Received: by 2002:adf:cd0a:0:b0:31f:f72c:df95 with SMTP id w10-20020adfcd0a000000b0031ff72cdf95mr4843445wrm.21.1696510785139;
        Thu, 05 Oct 2023 05:59:45 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id z2-20020a5d6542000000b003196b1bb528sm1752733wrv.64.2023.10.05.05.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 05:59:44 -0700 (PDT)
Message-ID: <b52c3e6a5df217b529565eae6e15c3fe246e2c5d.camel@redhat.com>
Subject: Re: [PATCH 10/10] KVM: SVM: Rename "avic_physical_id_cache" to
 "avic_physical_id_entry"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Thu, 05 Oct 2023 15:59:43 +0300
In-Reply-To: <20230815213533.548732-11-seanjc@google.com>
References: <20230815213533.548732-1-seanjc@google.com>
         <20230815213533.548732-11-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-08-15 у 14:35 -0700, Sean Christopherson пише:
> Rename the vCPU's pointer to its AVIC Physical ID entry from "cache" to
> "entry".  While the field technically caches the result of the pointer
> calculation, it's all too easy to misinterpret the name and think that
> the field somehow caches the _data_ in the table.

I also strongly dislike the 'avic_physical_id_cache', but if you are refactoring
it, IMHO the 'avic_physical_id_entry' is just as confusing since its a pointer
to an entry and not the entry itself.

At least a comment to explain where this pointer points, or maybe (not sure)
drop the avic_physical_id_cache completely and calculate it every time
(I doubt that there is any perf loss due to this)

Best regards,
	Maxim Levitsky

> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 10 +++++-----
>  arch/x86/kvm/svm/svm.h  |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6803e2d7bc22..8d162ff83aa8 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -310,7 +310,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
>  	WRITE_ONCE(table[id], new_entry);
>  
> -	svm->avic_physical_id_cache = &table[id];
> +	svm->avic_physical_id_entry = &table[id];
>  
>  	return 0;
>  }
> @@ -1028,14 +1028,14 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	if (kvm_vcpu_is_blocking(vcpu))
>  		return;
>  
> -	entry = READ_ONCE(*(svm->avic_physical_id_cache));
> +	entry = READ_ONCE(*(svm->avic_physical_id_entry));
>  	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
>  
>  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
>  	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
>  	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
>  
> -	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
> +	WRITE_ONCE(*(svm->avic_physical_id_entry), entry);
>  	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
>  }
>  
> @@ -1046,7 +1046,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  
>  	lockdep_assert_preemption_disabled();
>  
> -	entry = READ_ONCE(*(svm->avic_physical_id_cache));
> +	entry = READ_ONCE(*(svm->avic_physical_id_entry));
>  
>  	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
>  	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
> @@ -1055,7 +1055,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
>  
>  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
> -	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
> +	WRITE_ONCE(*(svm->avic_physical_id_entry), entry);
>  }
>  
>  void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8b798982e5d0..4362048493d1 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -261,7 +261,7 @@ struct vcpu_svm {
>  
>  	u32 ldr_reg;
>  	u32 dfr_reg;
> -	u64 *avic_physical_id_cache;
> +	u64 *avic_physical_id_entry;
>  
>  	/*
>  	 * Per-vcpu list of struct amd_svm_iommu_ir:


