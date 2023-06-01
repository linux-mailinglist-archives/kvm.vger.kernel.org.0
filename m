Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A020271F2E4
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 21:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjFAT30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 15:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjFAT3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 15:29:25 -0400
Received: from out-58.mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C59186
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 12:29:23 -0700 (PDT)
Date:   Thu, 1 Jun 2023 19:29:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685647762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=suBQTpSxH1G3pSl5ff+0g5WsTk1KtKVAVirQrCqi6oI=;
        b=WAqzCUAfnnkYf2qFyQckg+U183CgeSu4lzkfoVhYXmExAq5WhTixQoNCprJR4BDabtCQq5
        gyt8VkFwhVJ25fZM0Qd6E3TjYKmLfepUTiOit0utpQmce40yzLyAx5RaNvNlw/EswiHWpM
        isVhno6+jQrdftQVVzfWaynSb/5TuaY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com,
        maz@kernel.org, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT
 without implementation
Message-ID: <ZHjxjcj4AVTRV2A2@linux.dev>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-18-amoorthy@google.com>
 <ZHjhSZFwEc+VfjGk@linux.dev>
 <ZHjqkdEOVUiazj5d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHjqkdEOVUiazj5d@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 11:59:29AM -0700, Sean Christopherson wrote:
> On Thu, Jun 01, 2023, Oliver Upton wrote:
> > How do we support a userspace that only cares about NOWAIT exits but
> > doesn't want other EFAULT exits to be annotated?
> 
> We don't.  The proposed approach is to not change the return value, and the
> vcpu->run union currently holds random garbage on -EFAULT, so I don't see any reason
> to require userspace to opt-in, or to let userspace opt-out.  I.e. fill
> vcpu->run->memory_fault unconditionally (for the paths that are converted) and
> advertise to userspace that vcpu->run->memory_fault *may* contain useful info on
> -EFAULT when KVM_CAP_MEMORY_FAULT_INFO is supported.  And then we define KVM's
> ABI such that vcpu->run->memory_fault is guarateed to be valid if an -EFAULT occurs
> when faulting in guest memory (on supported architectures).

Sure, but the series currently gives userspace an explicit opt-in for
existing EFAULT paths. Hold your breath, I'll reply over there so we
don't mix context.

> > It is very likely that userspace will only know how to resolve NOWAIT exits
> > anyway. Since we do not provide a precise description of the conditions that
> > caused an exit, there's no way for userspace to differentiate between NOWAIT
> > exits and other exits it couldn't care less about.
> > 
> > NOWAIT exits w/o annotation (i.e. a 'bare' EFAULT) make even less sense
> > since userspace cannot even tell what address needs fixing at that
> > point.
> > 
> > This is why I had been suggesting we separate the two capabilities and
> > make annotated exits an unconditional property of NOWAIT exits.
> 
> No, because as I've been stating ad nauseum, KVM cannot differentiate between a
> NOWAIT -EFAULT and an -EFAULT that would have occurred regardless of the NOWAIT
> behavior.

IOW: "If you engage brain for more than a second, you'll actually see
the point"

Ok, I'm on board now and sorry for the noise.

-- 
Thanks,
Oliver
