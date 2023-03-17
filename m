Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F156BF0C3
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 19:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjCQSfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 14:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCQSfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 14:35:38 -0400
Received: from out-29.mta0.migadu.com (out-29.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578F135EE4
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:35:37 -0700 (PDT)
Date:   Fri, 17 Mar 2023 18:35:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679078134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AExwJpbPfzRFABGEzvkzEp6NJ2VaOP/alwL3DpOraDk=;
        b=oS98OM8LAk34WL+HoH19qI0mdouDRxuDU5fEqhX5uHjc26oOGF/9kJHD3Hgz6GYtkVNQQ/
        DsLJnCn51ipO5nq4Q6Rj6ibox/xU1qHVh+rM4rcXzFCLP6zuInbtG4iYczgpsTwtO/GkRO
        xpoKkab33IMYeHvWhFvq5Gg5Nvd7HdQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, jthoughton@google.com, kvm@vger.kernel.org
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
Message-ID: <ZBSy9NpkJA7XDTpn@linux.dev>
References: <20230315021738.1151386-1-amoorthy@google.com>
 <20230315021738.1151386-5-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315021738.1151386-5-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 02:17:28AM +0000, Anish Moorthy wrote:

[...]

> @@ -6172,3 +6181,22 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
>  
>  	return init_context.err;
>  }
> +
> +inline int kvm_memfault_exit_or_efault(
> +	struct kvm_vcpu *vcpu, uint64_t gpa, uint64_t len, uint64_t exit_flags)
> +{
> +	if (!(vcpu->kvm->memfault_exit_reasons & exit_flags))
> +		return -EFAULT;

<snip>

> +	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> +	vcpu->run->memory_fault.gpa = gpa;
> +	vcpu->run->memory_fault.len = len;
> +	vcpu->run->memory_fault.flags = exit_flags;

</snip>

Please spin this off into a helper and make use of it on the arm64 side.

> +	return -1;
> +}
> +
> +bool kvm_memfault_exit_flags_valid(uint64_t reasons)
> +{
> +	uint64_t valid_flags = KVM_MEMFAULT_REASON_UNKNOWN;
> +
> +	return !(reasons & !valid_flags);
> +}
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
> 

-- 
Thanks,
Oliver
