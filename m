Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F4B40BF7B
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 07:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbhIOF41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 01:56:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236429AbhIOF41 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Sep 2021 01:56:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631685308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xA4ByGlEfEieWx2EOyrJAeS2vRhXErE4knQ2GkX8GRQ=;
        b=C3mYO9dS5MIk8ay23dzigrjpe/uBoQRmyejNgDBWf938KO0n+Fcri8cdiseovSTohuL4NO
        Dcs4FW88TTGw5BggUK62ok9IcYRSMnF9vcNwO4iWW4zZAOwat5jmTm4+Jeupq03Yt/WBdm
        krlPOT7syGOEON/jtwmoN6rA1DdZKUU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-RPhe1IqmPXO5scLiW9GsoQ-1; Wed, 15 Sep 2021 01:55:01 -0400
X-MC-Unique: RPhe1IqmPXO5scLiW9GsoQ-1
Received: by mail-ed1-f70.google.com with SMTP id h15-20020aa7de0f000000b003d02f9592d6so923330edv.17
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 22:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xA4ByGlEfEieWx2EOyrJAeS2vRhXErE4knQ2GkX8GRQ=;
        b=4U31B+68O/EXUdlSJ3iulr7jGVQVVcdrAi1Ii1auXY5f4W6zNNFm9HQRYKnlVtXJ56
         7f6m477qgNsrwq/0LjROD+pzLGG4TWX3X8URCsCAYdpd6kKw3Miv+UoeXXNhSetLZVb5
         8RJotGD7jPppfOE9/xI9uQYXZX2WivkMdUbXWwxuPbqZgiaogLLfhYex4n0qmH/JPXyA
         gAfXVoB50Ln/PxaS+ret1XXdcBoqdRzrJzg3MmigzGMWl/rriAwguW5PEga9KQulX5jS
         eawKbnVrEFqHwJOB8vCIt4Fl0KMXRCNJ53ibjnEAOWUofeMYCLRruBacPO3tKfqHDOC8
         Jf4w==
X-Gm-Message-State: AOAM533vtIi1TvD6sFY36a3Cfd1wtC98Aucck2Fb7VOXwzLQXwIYWLu1
        wAuv7AjK+zjGv2BE2YYVjkHtbD3wytrrl/nB5Ciad0150fPp45wpImt5X4BvU8Hc3JZdyjc/TRr
        WpRP69C0z+oCH
X-Received: by 2002:a17:906:e105:: with SMTP id gj5mr22935864ejb.408.1631685300680;
        Tue, 14 Sep 2021 22:55:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmQFNRGGALDgSXECb7+CrH4Fm9yKRXtMUcjRCgpoUKc0xeyaWdPjESYb6S0eyWptweOgXupA==
X-Received: by 2002:a17:906:e105:: with SMTP id gj5mr22935848ejb.408.1631685300500;
        Tue, 14 Sep 2021 22:55:00 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id ba29sm5086767edb.5.2021.09.14.22.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:55:00 -0700 (PDT)
Date:   Wed, 15 Sep 2021 07:54:58 +0200
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
Subject: Re: [PATCH v7 09/15] KVM: arm64: selftests: Maintain consistency for
 vcpuid type
Message-ID: <20210915055458.tek6piqjyswxlvfv@gator.home>
References: <20210914223114.435273-1-rananta@google.com>
 <20210914223114.435273-10-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914223114.435273-10-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021 at 10:31:08PM +0000, Raghavendra Rao Ananta wrote:
> The prototype of aarch64_vcpu_setup() accepts vcpuid as
> 'int', while the rest of the aarch64 (and struct vcpu)
> carries it as 'uint32_t'. Hence, change the prototype
> to make it consistent throughout the board.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/include/aarch64/processor.h | 2 +-
>  tools/testing/selftests/kvm/lib/aarch64/processor.c     | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 515d04a3c27d..27d8e1bb5b36 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -63,7 +63,7 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint
>  	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &reg);
>  }
>  
> -void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init);
> +void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init *init);
>  void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
>  			      struct kvm_vcpu_init *init, void *guest_code);
>  
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index db64ee206064..34f6bd47661f 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -212,7 +212,7 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  	}
>  }
>  
> -void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init)
> +void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init *init)
>  {
>  	struct kvm_vcpu_init default_init = { .target = -1, };
>  	uint64_t sctlr_el1, tcr_el1;
> -- 
> 2.33.0.309.g3052b89438-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

