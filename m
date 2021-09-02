Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7583FF410
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 21:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347257AbhIBTWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 15:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243832AbhIBTWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 15:22:44 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBD4C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 12:21:46 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id c17so3084099pgc.0
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 12:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bTPb2LtwY0BuCTlFiP191M1j/fLfSg4VVRY2NYVbQM8=;
        b=S/7EM5Sy//hkeACCvKyqm5sVVqBrQaqsdvxj8V+pqH+VLsMswwElPvPODqMd7fVjBQ
         5i230e6v/OtvAgnS/CLoAsXnvILeltliV0s92h56yoUA0fUf11fzBxIPynn5EMbuXXRb
         gl5wjP5M2Lau95yABeHZjPjOapP29zLMK0IS+/+ygST5fVXgaJPDUEEdyNeVz93uhZ/d
         85dVXSxIWc3ixj4OrK1qCnh5UqmWozTZAXAk8AOj9Av8RLaDEsT6WgMig+7/yc9yTAd0
         QUPr4LbBjx9ibxnCt7BKdmJvrZfo0aFFeURS5oDPX3mGs2EAYO6KWacDYmpbuNM4tQl0
         b25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bTPb2LtwY0BuCTlFiP191M1j/fLfSg4VVRY2NYVbQM8=;
        b=MlfeSw2rKDF8XDvcAeFUk6pHHOXZjByXGCS56c57N83ob/f/Xwj0xt1r4hMNpreNF7
         P5R8oCZSPq6q6J3IcuQbwaSoZIGEjrVZ/AQ/fMdbsllJiU4NriKTXDhq7oToGAdqHl24
         01DcY7F0ekuEMPRsvv+hbbMnrRuhPvMZQhj+Y4ttwS3j7qUKmL7RRdcq4k2zRFppejqN
         oKNVLaKT8YE5b55ilbDB8I3dyrXZgOwU8l7883dZPGjAwlWoIuf1r3CRNQ/8eBLfFdYv
         Z9njqBAuhPeOmXJfqX57v4jwzb6t2vEmfGSKwCyQSy+g6cT+u1wbiESkd/nTD2mjLbT5
         D2dQ==
X-Gm-Message-State: AOAM531AtXk74z2dyPtmQaJ+WOas4SCn1nynTg9L+eWPbPfhuuV7S/YP
        p0hgWW/10qahei0UX/vRwdcDAg==
X-Google-Smtp-Source: ABdhPJyHmQYfdDfH5nHCWTHDLHiMkKrNuJmjtl34uxM72CrPEH11VQku3MHYEgMhSvkmPIwPWS9zAg==
X-Received: by 2002:aa7:85d8:0:b0:408:78f4:a5fe with SMTP id z24-20020aa785d8000000b0040878f4a5femr4725944pfn.2.1630610505325;
        Thu, 02 Sep 2021 12:21:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 6sm3086990pjz.8.2021.09.02.12.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:21:44 -0700 (PDT)
Date:   Thu, 2 Sep 2021 19:21:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 5/6] KVM: x86: Refactor tsc synchronization code
Message-ID: <YTEkRfTFyoh+HQyT@google.com>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-6-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816001130.3059564-6-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021, Oliver Upton wrote:
> Refactor kvm_synchronize_tsc to make a new function that allows callers
> to specify TSC parameters (offset, value, nanoseconds, etc.) explicitly
> for the sake of participating in TSC synchronization.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
> +	struct kvm *kvm = vcpu->kvm;
> +	bool already_matched;
> +
> +	lockdep_assert_held(&kvm->arch.tsc_write_lock);
> +
> +	already_matched =
> +	       (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
> +

...

> +	if (!matched) {
> +		/*
> +		 * We split periods of matched TSC writes into generations.
> +		 * For each generation, we track the original measured
> +		 * nanosecond time, offset, and write, so if TSCs are in
> +		 * sync, we can match exact offset, and if not, we can match
> +		 * exact software computation in compute_guest_tsc()
> +		 *
> +		 * These values are tracked in kvm->arch.cur_xxx variables.
> +		 */
> +		kvm->arch.cur_tsc_generation++;
> +		kvm->arch.cur_tsc_nsec = ns;
> +		kvm->arch.cur_tsc_write = tsc;
> +		kvm->arch.cur_tsc_offset = offset;
> +
> +		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
> +		kvm->arch.nr_vcpus_matched_tsc = 0;
> +	} else if (!already_matched) {
> +		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
> +		kvm->arch.nr_vcpus_matched_tsc++;
> +	}
> +
> +	kvm_track_tsc_matching(vcpu);
> +	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);

This unlock is imbalanced if matched and already_matched are both true.  It's not
immediately obvious that that _can't_ happen, and if it truly can't happen then
conditionally locking is pointless (because it's not actually conditional).

The previous code took the lock unconditionally, I don't see a strong argument
to change that, e.g. holding it for a few extra cycles while kvm->arch.cur_tsc_*
are updated is unlikely to be noticable.

If you really want to delay taking the locking, you could do

	if (!matched) {
		kvm->arch.cur_tsc_generation++;
		kvm->arch.cur_tsc_nsec = ns;
		kvm->arch.cur_tsc_write = data;
		kvm->arch.cur_tsc_offset = offset;
	}

	spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
	if (!matched)
		kvm->arch.nr_vcpus_matched_tsc = 0;
	else if (!already_matched)
		kvm->arch.nr_vcpus_matched_tsc++;
	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);

or if you want to get greedy

	if (!matched || !already_matched) {
		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
		if (!matched)
			kvm->arch.nr_vcpus_matched_tsc = 0;
		else
			kvm->arch.nr_vcpus_matched_tsc++;
		spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
	}

Though I'm not sure the minor complexity is worth avoiding spinlock contention.
