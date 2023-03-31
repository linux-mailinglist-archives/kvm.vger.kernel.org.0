Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EB26D2761
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 19:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbjCaR7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 13:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCaR73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 13:59:29 -0400
Received: from out-14.mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EC9DBC6
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 10:59:04 -0700 (PDT)
Date:   Fri, 31 Mar 2023 17:58:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680285523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xYuR5CaoWtccG4OYVultVYDux3DlrlFLpNh35/CX3G4=;
        b=XJG7+yut1C98IkQNgwXi1XxMTErajGM6gMjwoZJ/3DyIZXhDJNucx0g/B0P2SdvDvI7HGZ
        onVVw7pdO28TbrcavpNsicN23hYdQX/A0vpiodTnruX2QkDcAGHKCqhEPboBw2lS8DdNUg
        fAtGDjdmn7tyK+C0EECDcKKq1/LAhy0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Refactor hvc filtering to support
 different actions
Message-ID: <ZCcfQXj+Hs6ccla2@linux.dev>
References: <20230330154918.4014761-1-oliver.upton@linux.dev>
 <20230330154918.4014761-7-oliver.upton@linux.dev>
 <867cuwx38h.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867cuwx38h.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 31, 2023 at 06:03:26PM +0100, Marc Zyngier wrote:
> On Thu, 30 Mar 2023 16:49:11 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > KVM presently allows userspace to filter guest hypercalls with bitmaps
> > expressed via pseudo-firmware registers. These bitmaps have a narrow
> > scope and, of course, can only allow/deny a particular call. A
> > subsequent change to KVM will introduce a generalized UAPI for filtering
> > hypercalls, allowing functions to be forwarded to userspace.
> > 
> > Refactor the existing hypercall filtering logic to make room for more
> > than two actions. While at it, generalize the function names around
> > SMCCC as it is the basis for the upcoming UAPI.
> > 
> > No functional change intended.
> > 
> > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/uapi/asm/kvm.h |  9 +++++++++
> >  arch/arm64/kvm/hypercalls.c       | 19 +++++++++++++++----
> >  2 files changed, 24 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index f8129c624b07..bbab92402510 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -469,6 +469,15 @@ enum {
> >  /* run->fail_entry.hardware_entry_failure_reason codes. */
> >  #define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
> >  
> > +enum kvm_smccc_filter_action {
> > +	KVM_SMCCC_FILTER_ALLOW = 0,
> > +	KVM_SMCCC_FILTER_DENY,
> > +
> > +#ifdef __KERNEL__
> > +	NR_SMCCC_FILTER_ACTIONS
> > +#endif
> > +};
> > +
> 
> One thing I find myself wondering is what "ALLOW" mean here: Allow the
> handling of the hypercall? Or allow its forwarding? My guess is that
> this is the former, but I'd love a comment to clarify it, or even a
> clearer name ("HANDLE" instead of "ALLOW", for example, but YMMV...).

Yeah, I prefer calling it HANDLE as you suggest.

-- 
Thanks,
Oliver
