Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B5B4064FB
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbhIJBQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 21:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235275AbhIJBQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 21:16:23 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4009FC094248
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 17:50:47 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 18so347941pfh.9
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 17:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6EzzDQr8yG5LGu5YaQcJ8I2pgkIJnUB9NbZo6MY9NXc=;
        b=c5HRKGzhLdFkDdqEaIAkzI2TMXEXey1oW4MYk1KKgGtbVRwNCS50yLwVApx2ET8oZE
         a08EtNL8Nr9TakKWLixpnMOtjt6TND+WWSSwZtAzso/DATK5EyfEi0bFk3rcAxNtADr/
         X473cN9R3YlbUVxapedTDrJw17TrwvHZXdi4mu5cXsF2bxWh/fkhDVhm3TvgXaYOjWDl
         1y2NmOWQrUik0qHnTeQOABPGH75WGlung4k6tvXcTfROJhET3yUQY66nXwdfDxw81SQ5
         hOvMtNLBJZjhSYGgC6uifXXwVWf2hJKkHq4+Q9Luyf4cyAQCNYvcdTN/qF/6J8y4NNoD
         Ze4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6EzzDQr8yG5LGu5YaQcJ8I2pgkIJnUB9NbZo6MY9NXc=;
        b=qHNsJyWM3joZv6Gb4GPoZ1Q8HB7rALkyOT6Dao271QJh9pTs+yrnabQmUvPoNR9IL6
         Z5r4S6XygA2/eH4GE1RzXX8qtpg5imWXtPpGl8K9ve3aaNR1CkNb33zvlMVFYJfgHtBQ
         BpGcQ9Mqw6pn6mvkJPZvboztvcsm3PdD5pbIGZZtzsCVZ2AsV6W5G73m2dTO/I0/CL9d
         NcSIbBs1DxrLt5D+KU/zy6nrFQW3azJUihpWcmwcTRKqpWXm8SYVfZ9t74FfrTk4DiXd
         hvAVivHb8LFeHFVgrEuA6yKlnjEceCOu/uCCxwwZsOijDgySUK8DHaDYfuyeMbwJnUyx
         gsAg==
X-Gm-Message-State: AOAM533o9aooYiw33o8AciN5eQrMZ7418xL4eY47RRro23fkA93Eohpz
        4jIADGLdpDsADm13ngck2fsWaA==
X-Google-Smtp-Source: ABdhPJwDSECF6phzYbvcSxSRC8ZValgSEZsvTx/p14hy5cqm4bJBZy6SuNYjcaJhTZWtR5jPB+xhxw==
X-Received: by 2002:a63:1e16:: with SMTP id e22mr5012704pge.153.1631235046553;
        Thu, 09 Sep 2021 17:50:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a78sm3407284pfa.95.2021.09.09.17.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 17:50:46 -0700 (PDT)
Date:   Fri, 10 Sep 2021 00:50:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 V7] KVM, SEV: Add support for SEV-ES intra host
 migration
Message-ID: <YTqr4nuXYVFz81kD@google.com>
References: <20210902181751.252227-1-pgonda@google.com>
 <20210902181751.252227-3-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902181751.252227-3-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021, Peter Gonda wrote:
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 8db666a362d4..fac21a82e4de 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1545,6 +1545,59 @@ static void migrate_info_from(struct kvm_sev_info *dst,
>  	list_replace_init(&src->regions_list, &dst->regions_list);
>  }
>  
> +static int migrate_vmsa_from(struct kvm *dst, struct kvm *src)
> +{
> +	int i, num_vcpus;
> +	struct kvm_vcpu *dst_vcpu, *src_vcpu;
> +	struct vcpu_svm *dst_svm, *src_svm;
> +
> +	num_vcpus = atomic_read(&dst->online_vcpus);
> +	if (num_vcpus != atomic_read(&src->online_vcpus)) {
> +		pr_warn_ratelimited(
> +			"Source and target VMs must have same number of vCPUs.\n");

Same comments about not logging the why.

> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < num_vcpus; ++i) 
> +		src_vcpu = src->vcpus[i];

This can be:

	kvm_for_each_vcpu(i, src_vcpu, src) {
		if (!src_vcpu->arch.guest_state_protected)
			return -EINVAL;

	}
> +		if (!src_vcpu->arch.guest_state_protected) {
> +			pr_warn_ratelimited(
> +				"Source ES VM vCPUs must have protected state.\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	for (i = 0; i < num_vcpus; ++i) {

And again here,

	kvm_for_each_vcpu(i, src_vcpu, src) {
		src_svm = to_svm(src_vcpu);

> +		src_vcpu = src->vcpus[i];
> +		src_svm = to_svm(src_vcpu);
> +		dst_vcpu = dst->vcpus[i];

Probably a good idea to use kvm_get_vcpu(), even though dst->lock is held.  If
nothing else, using kvm_get_vcpu() may save some merge pain as there's a proposal
to switch vcpus to an xarray.

> +		dst_svm = to_svm(dst_vcpu);
> +
> +		/*
> +		 * Copy VMSA and GHCB fields from the source to the destination.
> +		 * Clear them on the source to prevent the VM running and

As brought up in the prior patch, clearing the fields might ensure future KVM_RUNs
fail, but it doesn't prevent the VM from running _now_.  And with vcpu->mutext
held, I think a more appropriate comment would be:

		/*
		 * Transfer VMSA and GHCB state to the destination.  Nullify and
		 * clear source fields as appropriate, the state now belongs to
		 * the destination.
		 */

> +		 * changing the state of the VMSA/GHCB unexpectedly.
> +		 */
> +		dst_vcpu->vcpu_id = src_vcpu->vcpu_id;
> +		dst_svm->vmsa = src_svm->vmsa;
> +		src_svm->vmsa = NULL;
> +		dst_svm->ghcb = src_svm->ghcb;
> +		src_svm->ghcb = NULL;
> +		dst_svm->vmcb->control.ghcb_gpa =
> +				src_svm->vmcb->control.ghcb_gpa;

Let this poke out, an 83 char line isn't the end of the world, and not having
the interrupt makes the code more readable overall.

> +		src_svm->vmcb->control.ghcb_gpa = 0;

Nit, '0' isn't an invalid GPA.  The reset value would be more appropriate, though
I would just leave this alone.

> +		dst_svm->ghcb_sa = src_svm->ghcb_sa;
> +		src_svm->ghcb_sa = NULL;
> +		dst_svm->ghcb_sa_len = src_svm->ghcb_sa_len;
> +		src_svm->ghcb_sa_len = 0;
> +		dst_svm->ghcb_sa_sync = src_svm->ghcb_sa_sync;
> +		src_svm->ghcb_sa_sync = false;
> +		dst_svm->ghcb_sa_free = src_svm->ghcb_sa_free;
> +		src_svm->ghcb_sa_free = false;
> +	}
> +	return 0;
> +}
