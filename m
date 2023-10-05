Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B84E7B997E
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 03:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244279AbjJEBOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 21:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243808AbjJEBOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 21:14:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF572C1
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 18:14:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8943298013so598130276.2
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 18:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696468466; x=1697073266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Y/+ytNHh3Rx6h0IBirVmq3gWYE0mzaC15X7Izg3qUQ=;
        b=N9E0X7XPJHg/g6QTmOM9jYUYSyCxV62yvBKbbSfznRA+BDWWPTih9gQd536ThTa7tD
         Vgs0NGRdKSJO/VqXXPWnWbM5iTiortuWdND6l/U3RriSNwBZKFxaHhplhJdjKqtPZ+Xx
         DzCwKuzjy+xR7bd51sf0x/4vzm9WvwcarAbWkH0U0kSVQc+BLS22cWlJU5r6sxwIH0M1
         lMfWv8eevquCCHLav0jVVhwNJKLCmYEEiGiNxECUFcxSpo3uKHfZgvRBYju/9JZXK5mv
         jEU4/dDkZ1J81v3XhUePFCYVo+pUBeLnS03pcDYhY1Wio4PNjhGg1ovyd2hDFcO6jfgw
         ukIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696468466; x=1697073266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Y/+ytNHh3Rx6h0IBirVmq3gWYE0mzaC15X7Izg3qUQ=;
        b=sUcpTEzV9bmDbv9PBz2470e4dbWKjcmwSb+1708aEW5LFfz+HclyX2fZgMtk9AyFtk
         REkrk2vexD7ZA4zjhoqSlu1AS81+4jPsf+BqTMLQbfg96Rz1DkgVRYssBFabJuIpF0EA
         F/Yodl5etDINk7w5niPfOYGCF/S3LDZhCzsNjOlBLHv5JjhuhtNkUaIjk8A9+Iq/JNKi
         14y7ZTyw/GGjSliR61V3WLgrBrp7nr5ncJJPNITWyRZd7ZFYPkzGAo9CwU/wPaiKpPZQ
         mEIUfXcWN5F2rJbHae20xM61C8rP4rETaJaKQdtE9SBO3Lz4agp/16hH9QkmKWa5Afpp
         vyww==
X-Gm-Message-State: AOJu0YzpmFtw3q4n5GtzlLi/kIIaqHrbOpGxldUBPeTGjr0dn352iUCy
        tfoFpEnsKDB1ULhnbqXPitvJFDmBmyk=
X-Google-Smtp-Source: AGHT+IE2suCFJ6sEmbTdEgrYVcCKCq2ROOicsKkEhiEVBgiHlmYy2FyPb023AQDl6p5tPFynQv0lyL/d5Q8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:74c2:0:b0:d7b:9902:fb3d with SMTP id
 p185-20020a2574c2000000b00d7b9902fb3dmr63106ybc.0.1696468466603; Wed, 04 Oct
 2023 18:14:26 -0700 (PDT)
Date:   Wed, 4 Oct 2023 18:14:25 -0700
In-Reply-To: <20230908222905.1321305-5-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
Message-ID: <ZR4N8cwzTMDanPUY@google.com>
Subject: Re: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 08, 2023, Anish Moorthy wrote:
> @@ -2318,4 +2324,33 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
>  /* Max number of entries allowed for each kvm dirty ring */
>  #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
>  
> +/*
> + * Attempts to set the run struct's exit reason to KVM_EXIT_MEMORY_FAULT and
> + * populate the memory_fault field with the given information.
> + *
> + * WARNs and does nothing if the speculative exit canary has already been set
> + * or if 'vcpu' is not the current running vcpu.
> + */
> +static inline void kvm_handle_guest_uaccess_fault(struct kvm_vcpu *vcpu,
> +						  uint64_t gpa, uint64_t len, uint64_t flags)

After a lot of fiddling and leading you on a wild goose chase, I think the least
awful name is kvm_prepare_memory_fault_exit().  Like kvm_prepare_emulation_failure_exit(),
this doesn't actually "handle" anything, it just preps for the exit.

If it actually returned something then maybe kvm_handle_guest_uaccess_fault()
would be an ok name (IIRC, that was my original intent, but we wandered in a
different direction).

And peeking at future patches, pass in the RWX flags as bools, that way this
helper can deal with the bools=>flags conversion.  Oh, and fill the flags with
bitwise ORs, that way future conflicts with private memory will be trivial to
resolve.

E.g.

static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
						 gpa_t gpa, gpa_t size,
						 bool is_write, bool is_exec)
{
	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
	vcpu->run->memory_fault.gpa = gpa;
	vcpu->run->memory_fault.size = size;

	vcpu->run->memory_fault.flags = 0;
	if (is_write)
		vcpu->run->memory_fault.flags |= KVM_MEMORY_FAULT_FLAG_WRITE;
	else if (is_exec)
		vcpu->run->memory_fault.flags |= KVM_MEMORY_FAULT_FLAG_EXEC;
	else
		vcpu->run->memory_fault.flags |= KVM_MEMORY_FAULT_FLAG_READ;
}

> +{
> +	/*
> +	 * Ensure that an unloaded vCPU's run struct isn't being modified

"unloaded" isn't accurate, e.g. the vCPU could be loaded, just not on this vCPU.
I'd just drop the comment entirely, this one is fairly self-explanatory.

> +	 */
> +	if (WARN_ON_ONCE(vcpu != kvm_get_running_vcpu()))
> +		return;
> +
> +	/*
> +	 * Warn when overwriting an already-populated run struct.
> +	 */

For future reference, use this style

	/*
	 *
	 */

only if the comment spans multiple lines.  For single line comments, just:

	/* Warn when overwriting an already-populated run struct. */

> +	WARN_ON_ONCE(vcpu->speculative_exit_canary != KVM_SPEC_EXIT_UNUSED);

As mentioned in the guest_memfd thread[1], this WARN can be triggered by userspace,
e.g. by getting KVM to fill the union but not exit, which is sadly not too hard
because emulator_write_phys() incorrectly treats all failures as MMIO.

I'm not even sure how to fix that in a race-free, sane way.  E.g. rechecking the
memslots doesn't work because a memslot could appear between __kvm_write_guest_page()
failing and rechecking in emulator_read_write_onepage().

Hmm, maybe we could get away with returning a different errno, e.g. -ENXIO?  And
then emulator_write_phys() and emulator_read_write_onepage() can be taught to
handle different errors accordingly.

Anyways, I highly recommend just dropping the canary for now, trying to clean up
the emulator and get this fully functional probably won't be a smooth process.

> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index f089ab290978..d19aa7965392 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -278,6 +278,9 @@ struct kvm_xen_exit {
>  /* Flags that describe what fields in emulation_failure hold valid data. */
>  #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
>  
> +/* KVM_CAP_MEMORY_FAULT_INFO flag for kvm_run.flags */
> +#define KVM_RUN_MEMORY_FAULT_FILLED (1 << 8)
> +
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
>  	/* in */
> @@ -531,6 +534,27 @@ struct kvm_run {
>  		struct kvm_sync_regs regs;
>  		char padding[SYNC_REGS_SIZE_BYTES];
>  	} s;
> +
> +	/*
> +	 * This second exit union holds structs for exits which may be triggered
> +	 * after KVM has already initiated a different exit, and/or may be
> +	 * filled speculatively by KVM.
> +	 *
> +	 * For instance, because of limitations in KVM's uAPI, a memory fault
> +	 * may be encounterd after an MMIO exit is initiated and exit_reason and
> +	 * kvm_run.mmio are filled: isolating the speculative exits here ensures
> +	 * that KVM won't clobber information for the original exit.
> +	 */
> +	union {
> +		/* KVM_RUN_MEMORY_FAULT_FILLED + EFAULT */
> +		struct {
> +			__u64 flags;
> +			__u64 gpa;
> +			__u64 len;
> +		} memory_fault;
> +		/* Fix the size of the union. */
> +		char speculative_exit_padding[256];
> +	};
>  };

As proposed in the guest_memfd thread[2], I think we should scrap the second union
and just commit to achieving 100% accuracy only for page fault paths in the
initial merge.

I'll send you a clean-ish patch to use as a starting point sometime next week.

[1] https://lore.kernel.org/all/ZRtxoaJdVF1C2Mvy@google.com
[2] https://lore.kernel.org/all/ZQ3AmLO2SYv3DszH@google.com
