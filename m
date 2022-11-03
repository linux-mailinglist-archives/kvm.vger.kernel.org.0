Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9D3618CCF
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 00:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiKCXcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 19:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiKCXcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 19:32:32 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883F01F601
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 16:32:30 -0700 (PDT)
Date:   Thu, 3 Nov 2022 23:32:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667518348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AkuOT4cCm8lWPlDD69OJU/NZeThANLz0iL3yJQqkzEM=;
        b=eakihLoa2JvOPxYFnYcGM0hY1jxnCOWluKCc1dZ0RkPrPRsMNBjJQzuhHHYe1QxPaAk064
        34n10Zy7oa+KLbGIc+AGP1eXp4xdGGlsFO9mmFVIDrkbj/c9/Rwh894OV92TW3AklfSEko
        xHEBvMLeSuNFrx8AghKRUwx3bqpS86M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
        catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
        pbonzini@redhat.com, peterx@redhat.com, seanjc@google.com,
        james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2RPhwIUsGLQ2cz/@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031003621.164306-5-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 08:36:16AM +0800, Gavin Shan wrote:
> ARM64 needs to dirty memory outside of a VCPU context when VGIC/ITS is
> enabled. It's conflicting with that ring-based dirty page tracking always
> requires a running VCPU context.
> 
> Introduce a new flavor of dirty ring that requires the use of both VCPU
> dirty rings and a dirty bitmap. The expectation is that for non-VCPU
> sources of dirty memory (such as the VGIC/ITS on arm64), KVM writes to
> the dirty bitmap. Userspace should scan the dirty bitmap before migrating
> the VM to the target.
> 
> Use an additional capability to advertise this behavior. The newly added
> capability (KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP) can't be enabled before
> KVM_CAP_DIRTY_LOG_RING_ACQ_REL on ARM64. In this way, the newly added
> capability is treated as an extension of KVM_CAP_DIRTY_LOG_RING_ACQ_REL.

Whatever ordering requirements we settle on between these capabilities
needs to be documented as well.

[...]

> @@ -4588,6 +4594,13 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  			return -EINVAL;
>  
>  		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> +		    !kvm->dirty_ring_size)

I believe this ordering requirement is problematic, as it piles on top
of an existing problem w.r.t. KVM_CAP_DIRTY_LOG_RING v. memslot
creation.

Example:
 - Enable KVM_CAP_DIRTY_LOG_RING
 - Create some memslots w/ dirty logging enabled (note that the bitmap
   is _not_ allocated)
 - Enable KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
 - Save ITS tables and get a NULL dereference in
   mark_page_dirty_in_slot():

                if (vcpu && kvm->dirty_ring_size)
                        kvm_dirty_ring_push(&vcpu->dirty_ring,
                                            slot, rel_gfn);
                else
------->		set_bit_le(rel_gfn, memslot->dirty_bitmap);

Similarly, KVM may unnecessarily allocate bitmaps if dirty logging is
enabled on memslots before KVM_CAP_DIRTY_LOG_RING is enabled.

You could paper over this issue by disallowing DIRTY_RING_WITH_BITMAP if
DIRTY_LOG_RING has already been enabled, but the better approach would
be to explicitly check kvm_memslots_empty() such that the real
dependency is obvious. Peter, hadn't you mentioned something about
checking against memslots in an earlier revision?

--
Thanks,
Oliver
