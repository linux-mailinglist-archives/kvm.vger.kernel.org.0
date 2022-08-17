Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D5B596D49
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 13:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiHQLDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 07:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbiHQLDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 07:03:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AAF3A4AE
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 04:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660734208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+oHzrnSobrf/PDAKZW2BwHO7DEjrgXoFW+o9PeSHgQQ=;
        b=GhPma5nIi4JEjGops/ekjM4ND5RugwwpyThvrRkUL3xfS0ueHzGNDR9vEFjuqaaYjtijW8
        njRQGtabMigkLxbeXf9XyjhQEWukIgtGIZXKHKDUeUA4o8tLJTjJzf6Dn1ky34HVr1RnHm
        6JA9R/L62s5TdInBZt9RXpwbrEbU/Ew=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-658-G0uqIfJNOfmqev6yaJjI6Q-1; Wed, 17 Aug 2022 07:03:26 -0400
X-MC-Unique: G0uqIfJNOfmqev6yaJjI6Q-1
Received: by mail-wr1-f72.google.com with SMTP id g11-20020adfa48b000000b002250d091f76so1619512wrb.3
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 04:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+oHzrnSobrf/PDAKZW2BwHO7DEjrgXoFW+o9PeSHgQQ=;
        b=KexZivHJHLTrTSChy4L8bIR6Qk/S1RTUcNuVp5SEVIaiAvLgZVbuX+/cARa/+lSu5v
         3xtSzhlENUO0zHNllbZFDbH2/4bFqxG7tw9Vjj0L3bbZnFtQ7SL6wYka4873sVrt0k2h
         5vOsQ68dyb34Y1tyqTmoe8+2dna/DOJAndlB0NfudrrWr8FbNT7THZN1WlGhenoTFtLe
         JJyPhZJ/t5jlxv5k0grEHZQbw3FGOLh/6t/8vVOZ+0tqodv+if7ySsA+ed5euEgKcJTS
         XZPzjVO2GUWplzhterFQ23Yx2GK8bOI8+nWWGCjdljGlM1GkvPpoJ+u4phtENWp50Eo1
         JTEQ==
X-Gm-Message-State: ACgBeo1EbjxZrgNSeeq6TbzT86xz0vaYlk7Ov5kU8zMOFRRt2S9kgAAe
        96+4XA8Cyy0jgrRsPxLvCHdQKMXyQxXnFQCKEP0AIKaB8ZYpe+yWs/8LmWD2/P6O1a+R6z+kcnI
        xLtUShgSXr4uL
X-Received: by 2002:a05:6000:10c3:b0:21f:15aa:1b68 with SMTP id b3-20020a05600010c300b0021f15aa1b68mr14393754wrx.693.1660734205697;
        Wed, 17 Aug 2022 04:03:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7f/6FSyCzhmKmYAxPtMGwdT+ZMb0RSD+z+6ln2oWTMLQ+1duQhASjQ4+5CmMoa9i+kByKpRA==
X-Received: by 2002:a05:6000:10c3:b0:21f:15aa:1b68 with SMTP id b3-20020a05600010c300b0021f15aa1b68mr14393735wrx.693.1660734205443;
        Wed, 17 Aug 2022 04:03:25 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id a9-20020a056000100900b0021e42e7c7dbsm12370138wrx.83.2022.08.17.04.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 04:03:24 -0700 (PDT)
Date:   Wed, 17 Aug 2022 12:03:22 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de,
        leobras@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org
Subject: Re: [PATCH] KVM: x86: Always enable legacy fp/sse
Message-ID: <YvzK+slWoAvm0/Wn@work-vm>
References: <20220816175936.23238-1-dgilbert@redhat.com>
 <YvwODUu/rdzjzDjk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvwODUu/rdzjzDjk@google.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Sean Christopherson (seanjc@google.com) wrote:
> On Tue, Aug 16, 2022, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > A live migration under qemu is currently failing when the source
> > host is ~Nehalem era (pre-xsave) and the destination is much newer,
> > (configured with a guest CPU type of Nehalem).
> > QEMU always calls kvm_put_xsave, even on this combination because
> > KVM_CAP_CHECK_EXTENSION_VM always returns true for KVM_CAP_XSAVE.
> > 
> > When QEMU calls kvm_put_xsave it's rejected by
> >    fpu_copy_uabi_to_guest_fpstate->
> >      copy_uabi_to_xstate->
> >        validate_user_xstate_header
> > 
> > when the validate checks the loaded xfeatures against
> > user_xfeatures, which it finds to be 0.
> > 
> > I think our initialisation of user_xfeatures is being
> > too strict here, and we should always allow the base FP/SSE.
> > 
> > Fixes: ad856280ddea ("x86/kvm/fpu: Limit guest user_xfeatures to supported bits of XCR0")
> > bz: https://bugzilla.redhat.com/show_bug.cgi?id=2079311
> > 
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index de6d44e07e34..3b2319cecfd1 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -298,7 +298,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  	guest_supported_xcr0 =
> >  		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
> >  
> > -	vcpu->arch.guest_fpu.fpstate->user_xfeatures = guest_supported_xcr0;
> > +	vcpu->arch.guest_fpu.fpstate->user_xfeatures = guest_supported_xcr0 |
> > +		XFEATURE_MASK_FPSSE;

Hi Sean,
  Thanks for the reply,

> I don't think this is correct.  This will allow the guest to set the SSE bit
> even when XSAVE isn't supported due to kvm_guest_supported_xcr0() returning
> user_xfeatures.
> 
>   static inline u64 kvm_guest_supported_xcr0(struct kvm_vcpu *vcpu)
>   {
> 	return vcpu->arch.guest_fpu.fpstate->user_xfeatures;
>   }
> 
> I believe the right place to fix this is in validate_user_xstate_header().  It's
> reachable if and only if XSAVE is supported in the host, and when XSAVE is _not_
> supported, the kernel unconditionally allows FP+SSE.  So it follows that the kernel
> should also allow FP+SSE when using XSAVE too.  That would also align the logic
> with fpu_copy_guest_fpstate_to_uabi(), which fordces the FPSSE flags.  Ditto for
> the non-KVM save_xstate_epilog().

OK, yes, I'd followed the check that failed down to this test; although
by itself this test works until Leo's patch came along later; so I
wasn't sure where to fix it.

> Aha!  And fpu__init_system_xstate() ensure the host supports FP+SSE when XSAVE
> is enabled (knew their had to be a sanity check somewhere).
> 
> ---
>  arch/x86/kernel/fpu/xstate.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index c8340156bfd2..83b9a9653d47 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -399,8 +399,13 @@ int xfeature_size(int xfeature_nr)
>  static int validate_user_xstate_header(const struct xstate_header *hdr,
>  				       struct fpstate *fpstate)
>  {
> -	/* No unknown or supervisor features may be set */
> -	if (hdr->xfeatures & ~fpstate->user_xfeatures)
> +	/*
> +	 * No unknown or supervisor features may be set.  Userspace is always
> +	 * allowed to restore FP+SSE state (XSAVE/XRSTOR are used by the kernel
> +	 * if and only if FP+SSE are supported in xstate).
> +	 */
> +	if (hdr->xfeatures & ~fpstate->user_xfeatures &
> +	    ~(XFEATURE_MASK_FP | XFEATURE_MASK_SSE))
>  		return -EINVAL;
> 
>  	/* Userspace must use the uncompacted format */

That passes the small smoke test for me; will you repost that then?

Thanks,

Dave

> base-commit: de3d415edca23831c5d1f24f10c74a715af7efdb
> --
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

