Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD224254AB
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 15:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbhJGNv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 09:51:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241801AbhJGNvW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 09:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633614568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YV63mS4RpYRoGQSZMwqbE1CRZKLm8qRI0uKOruLtURg=;
        b=i81V86cXVmYstB2kUR6CDyvShggvjV+7y5CE6LT9OIcmWvuTDK99twXtdTY6o7oYef704f
        MXD7s+eTSe3DahlsMXm7UoqsZd7BlODiWOzYPlba5Rm1r4gJO2/8PsXTYjSbOmGevmZu0j
        /Gv5mvJ8LRa2UGqM5SnJgimlvqfmH+A=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-DoCVwvs7NwGMAay1iKxrHw-1; Thu, 07 Oct 2021 09:49:27 -0400
X-MC-Unique: DoCVwvs7NwGMAay1iKxrHw-1
Received: by mail-qt1-f200.google.com with SMTP id 13-20020ac8560d000000b0029f69548889so5226313qtr.3
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 06:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YV63mS4RpYRoGQSZMwqbE1CRZKLm8qRI0uKOruLtURg=;
        b=CqLcdMV58OQA502BLSpTaktkDNBi6EV3wKBFUUKx9auQMFuTR5YjFOoyW7s6SdhC7R
         YWG3Gpsg6qV+SZ/SoLQdkrAis3tGIwaRpDED3d0nFOmOoSlh64VQBE+Z7TUm/PfbU4iJ
         nKz/u76itlF1HoCUvpwk2PMjZMGXeswC2vxgYlLQG/bUMGM5pGjfkvYXeiWLQOO9kzCh
         OC2mBOykxfDIdnD3hS9SpDKZOHu4QbwilmkKinp0JYMbDAOUUvt7tqg7HlK/ecyUioJJ
         n8kmFD6VDCQMQtx3zefbQ/vdV7D+yOtzEubmG8L0/08xbIZTzm9PZVlAi67VZpD1YdGI
         Ym3Q==
X-Gm-Message-State: AOAM532hMnpEM99JQBXia/StjQz7L+tNf+XhVmYy9caRfBLzRsovISG0
        K8nwBN1nPWbbfb6NCIrovNcV43ypXtbi/ncUdYkFWqDYFoFHs8nkjSJzLt91+oGSfd/nI/Gwe8V
        8zqVfbfc/nkmz
X-Received: by 2002:a05:6214:a4d:: with SMTP id ee13mr4121157qvb.6.1633614567253;
        Thu, 07 Oct 2021 06:49:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfq2RpXF9UQXSj5gVtwkRFV+YzKin4ZaeJ2Zs5710CY4R+6CVe48FzPtRwNTqzbSzHN22NJA==
X-Received: by 2002:a05:6214:a4d:: with SMTP id ee13mr4121130qvb.6.1633614567050;
        Thu, 07 Oct 2021 06:49:27 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id n123sm633770qke.36.2021.10.07.06.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:49:26 -0700 (PDT)
Date:   Thu, 7 Oct 2021 15:49:22 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 06/16] KVM: arm64: Force a full unmap on vpcu reinit
Message-ID: <20211007134922.sg3b3egpwc2izbi2@gator>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-7-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004174849.2831548-7-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:48:39PM +0100, Marc Zyngier wrote:
> As we now keep information in the S2PT, we must be careful not
> to keep it across a VM reboot, which could otherwise lead to
> interesting problems.
> 
> Make sure that the S2 is completely discarded on reset of
> a vcpu, and remove the flag that enforces the MMIO check.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/psci.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 74c47d420253..6c9cb041f764 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -12,6 +12,7 @@
>  
>  #include <asm/cputype.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>  
>  #include <kvm/arm_psci.h>
>  #include <kvm/arm_hypercalls.h>
> @@ -180,6 +181,13 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
>  		tmp->arch.power_off = true;
>  	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>  
> +	/*
> +	 * If the MMIO guard was enabled, we pay the price of a full
> +	 * unmap to get back to a sane state (and clear the flag).
> +	 */
> +	if (test_and_clear_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
> +		stage2_unmap_vm(vcpu->kvm);
> +
>  	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
>  	vcpu->run->system_event.type = type;
>  	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

