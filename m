Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453043DFDBF
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 11:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbhHDJPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 05:15:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235495AbhHDJPL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 05:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628068498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tTIjprUhEDbhjonUuP4pIFp+Z7bPyJe6jb/7RK3byQs=;
        b=NxjQ0Oq/AqSgMNL9cPDZeeZrvKeEK0d0dhWIqlBrsEnbS2JI0N4hNWEisGhHYURWm9PuuQ
        sYNnDJMqov4WvVTVwIjWMxbvJCPV3BlyAD2a8JN8U7tvW9M0AW7peEd5DT3QffWYGu7tPD
        9phetDmgdmDs8+v07q4veAp7yD7L7Qs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-6upWPqkVMVqfk8Liav5BgA-1; Wed, 04 Aug 2021 05:14:57 -0400
X-MC-Unique: 6upWPqkVMVqfk8Liav5BgA-1
Received: by mail-ej1-f71.google.com with SMTP id qh25-20020a170906ecb9b02905a655de6553so502022ejb.19
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 02:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tTIjprUhEDbhjonUuP4pIFp+Z7bPyJe6jb/7RK3byQs=;
        b=kMe2iPjOQCZR81Ev5OXBnBvf49KpJPWPza7Q/MmKz0gkZTyNIrL2I2HrOYjCjZMC/g
         o/nu1MBP8DoOvrL6RLackZD5hkZL6SqDeKTAY7d53oCKjSjCrrmsdORXD7vcSsUtfJEg
         Y1qsJ6MH5xCAJfL2C+GimcGRJnKL2mWdW7nfJcNDvhkrM5yTIByRow0hLP19vn0OxW8l
         GpLWnaMdYWlGOxk/a/7JOt/YcoF53czOIl9aR4ODw37qQDN5LTinzL/JnPwsAPr1/r+l
         ixXmqlbyLu+mHbwBiOez/7Ruv7ZTsuLKK7oPHD05+jpLanvEogYXpf2sX8BTZfQ9Bwtq
         Pk9g==
X-Gm-Message-State: AOAM530eJw9Y4QrgS/0Q7UMIbSVelp6Wx2+imbfe3xvHdGm+7VJRnfvN
        N+LBzC0XWuhdjI7PJoHUnKmR8d2Dpy1nAtsL+2egNllDKd46YBoqmBdIA4uQbUKTjxLRIA0YzMI
        Uljl+1pawuC6s
X-Received: by 2002:a05:6402:40c7:: with SMTP id z7mr2271212edb.193.1628068496555;
        Wed, 04 Aug 2021 02:14:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzq8BjCcunO2gxZ/evsJ4buvf+QSwB0JER9NnDit3gYvyU1ktgpjUANRe5hzZ0BF++uILOjA==
X-Received: by 2002:a05:6402:40c7:: with SMTP id z7mr2271190edb.193.1628068496402;
        Wed, 04 Aug 2021 02:14:56 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id i14sm690894edx.30.2021.08.04.02.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 02:14:55 -0700 (PDT)
Date:   Wed, 4 Aug 2021 11:14:53 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 14/21] selftests: KVM: Add helper to check for
 register presence
Message-ID: <20210804091453.u4bf75pfeyldowt5@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-15-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804085819.846610-15-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 08:58:12AM +0000, Oliver Upton wrote:
> The KVM_GET_REG_LIST vCPU ioctl returns a list of supported registers
> for a given vCPU. Add a helper to check if a register exists in the list
> of supported registers.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 19 +++++++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 1b3ef5757819..077082dd2ca7 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -215,6 +215,8 @@ void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
>  		  struct kvm_fpu *fpu);
>  void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
>  		  struct kvm_fpu *fpu);
> +
> +bool vcpu_has_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t reg_id);
>  void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
>  void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
>  #ifdef __KVM_HAVE_VCPU_EVENTS
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 0fe66ca6139a..a5801d4ed37d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1823,6 +1823,25 @@ void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
>  		    ret, errno, strerror(errno));
>  }
>  
> +bool vcpu_has_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t reg_id)
> +{
> +	struct kvm_reg_list *list;
> +	bool ret = false;
> +	uint64_t i;
> +
> +	list = vcpu_get_reg_list(vm, vcpuid);
> +
> +	for (i = 0; i < list->n; i++) {
> +		if (list->reg[i] == reg_id) {
> +			ret = true;
> +			break;
> +		}
> +	}
> +
> +	free(list);
> +	return ret;
> +}
> +
>  void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
>  {
>  	int ret;
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

