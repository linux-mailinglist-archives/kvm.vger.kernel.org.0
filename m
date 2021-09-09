Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F624056FB
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 15:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354408AbhIIN1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 09:27:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355427AbhIINVf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 09:21:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631193624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IPz8rCaG1n5gmzRfNCxWNsl8VhshhGe4oboIWdB5nfY=;
        b=KSZCZ0hko8hs84noG+nqXvOscbfUG75oiireZPmg2dNDLY2HcvscyJlnnCLOGcWb9gmxt8
        +jGq6lib6Yu4r8aGoxvL2fk7ykm5n9mhcWBNNMFDQDJrqhf2NvVtlPBAY231jrTCRhTYqG
        WmqD6VGuu3j7TBG0ty6k0YoYW4yTMlc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-nr9tsYgJOXWNJtSVPSqcHw-1; Thu, 09 Sep 2021 09:20:23 -0400
X-MC-Unique: nr9tsYgJOXWNJtSVPSqcHw-1
Received: by mail-ed1-f72.google.com with SMTP id b8-20020a056402350800b003c5e3d4e2a7so970080edd.2
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 06:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IPz8rCaG1n5gmzRfNCxWNsl8VhshhGe4oboIWdB5nfY=;
        b=sWKl0dMT6WDXcAQSCub1jrd9zugK/2MrauqXKYwJim1ouq/jIrWtHrfCf6nUXGPagc
         vfBjTCDiScvA0V96oTY8WQzC1kUlevP05zYXxCMwSj8S8qq4xFeBEd0dFDAHL5fCzWsq
         WkpasMYNQbKrxAooktqLS/RWJYAPFxcj2hAhIN9z/GzqzoD0F7jhTTU67KX3WuzUCIn9
         6DZBt6OENM64/dmNjnwbkIbOI4zBqIyqOB2HfM937LSphsZwd+X20HwQAScjuvtkSdTu
         Ek/zPygB8aZP564D4OLZetly6pGkOF5UFEa6hH6uctYMDbkkLV1o3QBOwmqY6TdrPUDb
         VC9A==
X-Gm-Message-State: AOAM532lkyBTsido083bPuxYY8LrKIm7bVeENwAvlzv+A6EA+ba678bz
        dIWH5N2yL1oQctr72h5r8cYCmNph+sqidu+iw1zkJraNA6aWDI2nCU8Eb5hmrrs+J5H/vwwwLjy
        S5FF9aBsLE0I3
X-Received: by 2002:a17:906:1510:: with SMTP id b16mr3523486ejd.332.1631193622102;
        Thu, 09 Sep 2021 06:20:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxltN+LLKBsItVnHF6jboBkL7BG/4gKE6eUK2+syXfEg8esfR9/Hha6iEqkMhy0wQUkBEbcyQ==
X-Received: by 2002:a17:906:1510:: with SMTP id b16mr3523459ejd.332.1631193621929;
        Thu, 09 Sep 2021 06:20:21 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id l16sm999043eje.67.2021.09.09.06.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 06:20:21 -0700 (PDT)
Date:   Thu, 9 Sep 2021 15:20:19 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 12/18] KVM: selftests: Keep track of the number of
 vCPUs for a VM
Message-ID: <20210909132019.etrlz2t7pes7bc2o@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-13-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-13-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 01:38:12AM +0000, Raghavendra Rao Ananta wrote:
> The host may want to know the number of vCPUs that were
> created for a particular VM (used in upcoming patches).
> Hence, include nr_vcpus as a part of 'struct kvm_vm' to
> keep track of vCPUs as and when they are added or
> deleted, and return to the caller via vm_get_nr_vcpus().
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h      | 1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 7 +++++++
>  tools/testing/selftests/kvm/lib/kvm_util_internal.h | 1 +
>  3 files changed, 9 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 010b59b13917..d5d0ca919928 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -399,5 +399,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>  
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
> +int vm_get_nr_vcpus(struct kvm_vm *vm);
>  
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 10a8ed691c66..1b5349b5132f 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -594,6 +594,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
>  
>  	list_del(&vcpu->list);
>  	free(vcpu);
> +	vm->nr_vcpus--;
>  }
>  
>  void kvm_vm_release(struct kvm_vm *vmp)
> @@ -1143,6 +1144,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
>  
>  	/* Add to linked-list of VCPUs. */
>  	list_add(&vcpu->list, &vm->vcpus);
> +	vm->nr_vcpus++;
>  }
>  
>  /*
> @@ -2343,3 +2345,8 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
>  
>  	return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
>  }
> +
> +int vm_get_nr_vcpus(struct kvm_vm *vm)
> +{
> +	return vm->nr_vcpus;
> +}

nr_vcpus looks like useful library internal information, since the only
other way to get the number is to iterate the vcpu list. I'm not sure
if we need this vm_get_nr_vcpus() accessor for tests yet though. Maybe
it'll be more clear to me when I see how it's used.

Thanks,
drew

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> index a03febc24ba6..be4d852d2f3b 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> +++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> @@ -56,6 +56,7 @@ struct kvm_vm {
>  	unsigned int va_bits;
>  	uint64_t max_gfn;
>  	struct list_head vcpus;
> +	int nr_vcpus;
>  	struct userspace_mem_regions regions;
>  	struct sparsebit *vpages_valid;
>  	struct sparsebit *vpages_mapped;
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

