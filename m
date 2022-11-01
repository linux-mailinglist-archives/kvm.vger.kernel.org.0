Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09FF61526F
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 20:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiKATjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 15:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiKATjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 15:39:31 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC311A386
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 12:39:30 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f9so14312943pgj.2
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 12:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tnEODX2baOxy8d43W9uFCYaWlAQWT5w4AwPUA+Xic0c=;
        b=NWg9Qf4jep8QtwAzp6LlGIBZ9WQD30RO5yMyObW05gSJG0RMgAVotBdXfDg/PFd7xS
         wCgCLMtq5WSobjNO9MYRFanOAIe42cCUImyWBJwXI8lQ1IxIx07DZtoRY54cUC4l3g5S
         UG9dDF1oqM0F4NJQBNPBytpWImiAMW/09OKcI+od9oiV/Khh+0eTOsRQ/FXclq4kKpE4
         IdLvAE1X9Umsd54HDWZuQPvjoOdvKQ+0x3WcG/43TeY0YpKQrcpZVVnrmUlXN6EoA1/J
         VNt0Oux+EbMueltF5UC/wafegmCKmhF/wOFdvOcmi+hzEKeFg9bK6RlnOmaRXyMP/fN+
         T/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tnEODX2baOxy8d43W9uFCYaWlAQWT5w4AwPUA+Xic0c=;
        b=QqC6fsAKpIG9TxqRFU3oAvvlWLgfDwWENvwHWbusSrU6hud6o46UVnh9gwlsKvYvIu
         IJyV/pIkO9YKLsPOQFbmmXRFq1w5RJIw7QEkK4VIrlbirXIaYfRSsDBnywWk8MGl+rvs
         9CPiF4MVyOnoEn6ZWLYd4SnAYuibZo7AoIojN0A5dKM5iBHcmXhpfw83NaFuw67YbG1h
         L/Em3rnvc9RNW035DBVJ6mfEJA9Cl6/881TVdMaN8IjQ82CJ2lOf9HnkBhPWpHOcBbhS
         ztip463HSBKE6a252tUgxfprmq9bf/IsKFMdwpwi57Zox0fOaLNMXFXfFsCCDPfSSaka
         QHzw==
X-Gm-Message-State: ACrzQf1XX/PCXlCi6jxRzVO6wEOHwP+mU8ouFc93EUuVXeZAObTAZwzo
        pNImyPWBUBkGhjxMEXlahhAIGr5rAm5IPQ==
X-Google-Smtp-Source: AMsMyM7y1Oh83Y/hQ+zELq6lqCQy6nyQlUDKZUw2/ZCPUhQWvl3BJiU2S+q1OeuYAM5aix2PbSxXSQ==
X-Received: by 2002:a63:89c3:0:b0:46e:d2d9:a960 with SMTP id v186-20020a6389c3000000b0046ed2d9a960mr18383448pgd.329.1667331569800;
        Tue, 01 Nov 2022 12:39:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b7-20020aa78ec7000000b0056262811c5fsm6862296pfr.59.2022.11.01.12.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 12:39:29 -0700 (PDT)
Date:   Tue, 1 Nov 2022 19:39:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
        catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
        pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
        james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2F17Y7YG5Z9XnOJ@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031003621.164306-2-gshan@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022, Gavin Shan wrote:
> The VCPU isn't expected to be runnable when the dirty ring becomes soft
> full, until the dirty pages are harvested and the dirty ring is reset
> from userspace. So there is a check in each guest's entrace to see if
> the dirty ring is soft full or not. The VCPU is stopped from running if
> its dirty ring has been soft full. The similar check will be needed when
> the feature is going to be supported on ARM64. As Marc Zyngier suggested,
> a new event will avoid pointless overhead to check the size of the dirty
> ring ('vcpu->kvm->dirty_ring_size') in each guest's entrance.
> 
> Add KVM_REQ_DIRTY_RING_SOFT_FULL. The event is raised when the dirty ring
> becomes soft full in kvm_dirty_ring_push(). The event is cleared in the
> check, done in the newly added helper kvm_dirty_ring_check_request(), or
> when the dirty ring is reset by userspace. Since the VCPU is not runnable
> when the dirty ring becomes soft full, the KVM_REQ_DIRTY_RING_SOFT_FULL
> event is always set to prevent the VCPU from running until the dirty pages
> are harvested and the dirty ring is reset by userspace.
> 
> kvm_dirty_ring_soft_full() becomes a private function with the newly added
> helper kvm_dirty_ring_check_request(). The alignment for the various event
> definitions in kvm_host.h is changed to tab character by the way. In order
> to avoid using 'container_of()', the argument @ring is replaced by @vcpu
> in kvm_dirty_ring_push() and kvm_dirty_ring_reset(). The argument @kvm to
> kvm_dirty_ring_reset() is dropped since it can be retrieved from the VCPU.
> 
> Link: https://lore.kernel.org/kvmarm/87lerkwtm5.wl-maz@kernel.org
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> @@ -142,13 +144,17 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>  
>  	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>  
> +	if (!kvm_dirty_ring_soft_full(ring))
> +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
> +

Marc, Peter, and/or Paolo, can you confirm that clearing the request here won't
cause ordering problems?  Logically, this makes perfect sense (to me, since I
suggested it), but I'm mildly concerned I'm overlooking an edge case where KVM
could end up with a soft-full ring but no pending request.

>  	trace_kvm_dirty_ring_reset(ring);
>  
>  	return count;
>  }
>  
