Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4E2697890
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 09:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbjBOI72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 03:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjBOI71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 03:59:27 -0500
Received: from out-16.mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA3523320
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 00:59:26 -0800 (PST)
Date:   Wed, 15 Feb 2023 08:59:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676451563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dbB0ckIbZFCpwnM6lAhqCrJ4bQqVbSxKfGb2OqNB+g4=;
        b=v+pnXQVZQROwLC0VbADhFlMrQQ2oodKK9cnmYE5E+HEw8ZYb97acdHbaUQ0AtZqx7Ftt5W
        6cYdi0BMSqTHE1g07ss0Nfqkj8GifY95Y+t6lQYnuFVcwLb7fg/rsTdHRmNWMBVAqNM91X
        wZO3lYGPfPsZDKSvMPLVIdnW1hOWJN0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
Message-ID: <Y+ye5yV2/ifCkxYJ@linux.dev>
References: <20230215011614.725983-1-amoorthy@google.com>
 <20230215011614.725983-6-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215011614.725983-6-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 01:16:11AM +0000, Anish Moorthy wrote:
> This new KVM exit allows userspace to handle missing memory. It
> indicates that the pages in the range [gpa, gpa + size) must be mapped.
> 
> The "flags" field actually goes unused in this series: it's included for
> forward compatibility with [1], should this series happen to go in
> first.
> 
> [1] https://lore.kernel.org/all/CA+EHjTyzZ2n8kQxH_Qx72aRq1k+dETJXTsoOM3tggPZAZkYbCA@mail.gmail.com/
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> Acked-by: James Houghton <jthoughton@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 42 ++++++++++++++++++++++++++++++++++
>  include/linux/kvm_host.h       | 13 +++++++++++
>  include/uapi/linux/kvm.h       | 13 ++++++++++-
>  tools/include/uapi/linux/kvm.h |  7 ++++++
>  virt/kvm/kvm_main.c            | 26 +++++++++++++++++++++
>  5 files changed, 100 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9807b05a1b571..4b06e60668686 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5937,6 +5937,18 @@ delivery must be provided via the "reg_aen" struct.
>  The "pad" and "reserved" fields may be used for future extensions and should be
>  set to 0s by userspace.
>  
> +4.137 KVM_SET_MEM_FAULT_NOWAIT
> +------------------------------
> +
> +:Capability: KVM_CAP_MEM_FAULT_NOWAIT
> +:Architectures: x86, arm64
> +:Type: vm ioctl
> +:Parameters: bool state (in)
> +:Returns: 0 on success, or -1 if KVM_CAP_MEM_FAULT_NOWAIT is not present.
> +
> +Enables (state=true) or disables (state=false) waitless memory faults. For more
> +information, see the documentation of KVM_CAP_MEM_FAULT_NOWAIT.

Why not use KVM_ENABLE_CAP instead for this? Its a preexisting UAPI for
toggling KVM behaviors.

>  5. The kvm_run structure
>  ========================
>  
> @@ -6544,6 +6556,21 @@ array field represents return values. The userspace should update the return
>  values of SBI call before resuming the VCPU. For more details on RISC-V SBI
>  spec refer, https://github.com/riscv/riscv-sbi-doc.
>  
> +::
> +
> +		/* KVM_EXIT_MEMORY_FAULT */
> +		struct {
> +			__u64 gpa;
> +			__u64 size;
> +		} memory_fault;
> +
> +If exit reason is KVM_EXIT_MEMORY_FAULT then it indicates that the VCPU has
> +encountered a memory error which is not handled by KVM kernel module and
> +which userspace may choose to handle.
> +
> +'gpa' and 'size' indicate the memory range the error occurs at. Userspace
> +may handle the error and return to KVM to retry the previous memory access.

How is userspace expected to differentiate the gup_fast() failed exit
from the guest-private memory exit? I don't think flags are a good idea
for this, as it comes with the illusion that both events can happen on a
single exit. In reality, these are mutually exclusive.

A fault type/code would be better here, with the option to add flags at
a later date that could be used to further describe the exit (if
needed).

-- 
Thanks,
Oliver
