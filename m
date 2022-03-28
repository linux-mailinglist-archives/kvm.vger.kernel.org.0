Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAF24E9D83
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 19:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244441AbiC1RaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 13:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiC1RaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 13:30:03 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276241A3A0
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:28:22 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id k11so1871937ilv.5
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A/kbyF3OByUP+w42+tnQ3Zn79Js8xCHKvHas/l5VsPk=;
        b=CJeW9n46j1pLqE+N3dpV2IBk+Ra9GtxT75B4j0S8EE0RzjEkuxGFMT+aSGwLps3QR6
         WsjOt/JktA2KDDgTt/uQUkqiCI+A5XuXCiNyUH+eQ4G4HhielQ7Pj4dWhbb3lOAkYOQW
         KdAvlmSEqGrnvI0T2MELr77aZhadF47qK4WsMEznFuRe5d4PvoUmpR0L9SR6iciBMjcS
         YvzU/r2RyphvvTxxbohcoLdCvt5zyl8c/BjuPCXP8HrVtR+fNJRbfDRp/TgqgElCgyMg
         qHm+Vh2+s4tmjd+i/T5WiSXjO+dV8brZign4nwa84aoSlRCJTQ5ACb0khWZVmERZ1bNV
         AbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A/kbyF3OByUP+w42+tnQ3Zn79Js8xCHKvHas/l5VsPk=;
        b=xdDzBmx7uE7AKBxf6CRsY4xw10fvs00XwpMRlY1N3M1ZanQqPrOiYWQqIaRXvykI3+
         +HnLEbCLowvpUzuPhUkliPz7F0cUt43m3wEk267FFDplgfHkINyLm2u5/LsHBf+UilMP
         0zRLnZttEGS1daWAmgLxLOjbod0P1rDApH+5mBJ4v8fvOkI4vlX7xm52gGdyjFxu5P/s
         nwNc47ycnFO+jD96NlsbXyylWQNJO1qM5Ou5+6v4CJKb7Hos24knnk4U0U4eAA2ogAgW
         JfmEEXZvJiLcW/Msw3dxFaXVYk3/UqElevQjXUwWLAvkyPz5BpTp15GWp09LhHthxbJD
         /tig==
X-Gm-Message-State: AOAM532HARe3jhmGQnQid1WreH6N4/fi+cihPQO68yKlH2dkg22mHEJk
        s9nqrSNbRQzf5JyxuO4iWMBLRA==
X-Google-Smtp-Source: ABdhPJyy0AE86J03JP0GnyAcDwfEEWyLnWttRl8xngjcBc8yu2LHPAc+Em1XRxQk/g4E0ymgl7PiAQ==
X-Received: by 2002:a05:6e02:b4b:b0:2c9:bd4a:2c49 with SMTP id f11-20020a056e020b4b00b002c9bd4a2c49mr2519007ilu.208.1648488501185;
        Mon, 28 Mar 2022 10:28:21 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id e15-20020a92194f000000b002c25e778042sm7504782ilm.73.2022.03.28.10.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 10:28:20 -0700 (PDT)
Date:   Mon, 28 Mar 2022 17:28:17 +0000
From:   Oliver Upton <oupton@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Allow userspace to opt out of hypercall
 patching
Message-ID: <YkHwMd37Fo8Zej59@google.com>
References: <20220316005538.2282772-1-oupton@google.com>
 <20220316005538.2282772-2-oupton@google.com>
 <Yjyt7tKSDhW66fnR@google.com>
 <2a438f7c-4dea-c674-86c0-9164cbad0813@redhat.com>
 <YjzBB6GzNGrJdRC2@google.com>
 <Yj5V4adpnh8/B/K0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yj5V4adpnh8/B/K0@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 25, 2022 at 11:53:05PM +0000, Sean Christopherson wrote:
> On Thu, Mar 24, 2022, Oliver Upton wrote:
> > On Thu, Mar 24, 2022 at 06:57:18PM +0100, Paolo Bonzini wrote:
> > > On 3/24/22 18:44, Sean Christopherson wrote:
> > > > On Wed, Mar 16, 2022, Oliver Upton wrote:
> > > > > KVM handles the VMCALL/VMMCALL instructions very strangely. Even though
> > > > > both of these instructions really should #UD when executed on the wrong
> > > > > vendor's hardware (i.e. VMCALL on SVM, VMMCALL on VMX), KVM replaces the
> > > > > guest's instruction with the appropriate instruction for the vendor.
> > > > > Nonetheless, older guest kernels without commit c1118b3602c2 ("x86: kvm:
> > > > > use alternatives for VMCALL vs. VMMCALL if kernel text is read-only")
> > > > > do not patch in the appropriate instruction using alternatives, likely
> > > > > motivating KVM's intervention.
> > > > > 
> > > > > Add a quirk allowing userspace to opt out of hypercall patching.
> > > > 
> > > > A quirk may not be appropriate, per Paolo, the whole cross-vendor thing is
> > > > intentional.
> > > > 
> > > > https://lore.kernel.org/all/20211210222903.3417968-1-seanjc@google.com
> > > 
> > > It's intentional, but the days of the patching part are over.
> > > 
> > > KVM should just call emulate_hypercall if called with the wrong opcode
> > > (which in turn can be quirked away).  That however would be more complex to
> > > implement because the hypercall path wants to e.g. inject a #UD with
> > > kvm_queue_exception().
> > > 
> > > All this makes me want to just apply Oliver's patch.
> > > 
> > > > > +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN)) {
> > > > > +		ctxt->exception.error_code_valid = false;
> > > > > +		ctxt->exception.vector = UD_VECTOR;
> > > > > +		ctxt->have_exception = true;
> > > > > +		return X86EMUL_PROPAGATE_FAULT;
> > > > 
> > > > This should return X86EMUL_UNHANDLEABLE instead of manually injecting a #UD.  That
> > > > will also end up generating a #UD in most cases, but will play nice with
> > > > KVM_CAP_EXIT_ON_EMULATION_FAILURE.
> > 
> > Sean and I were looking at this together right now, and it turns out
> > that returning X86EMUL_UNHANDLEABLE at this point will unconditionally
> > bounce out to userspace.
> > 
> > x86_decode_emulated_instruction() would need to be the spot we bail to
> > guard these exits with the CAP.
> 
> I've spent waaay too much time thinking about this...
> 
> TL;DR: I'm in favor of applying the patch as-is.
> 
> My objection to manually injecting the #UD is that there's no guarantee that KVM
> is actually handling a #UD.  It's largely a moot point, as KVM barfs on VMCALL/VMMCALL
> if it's _not_ from a #UD, e.g. KVM hangs the guest if it does a VMCALL when KVM is
> emulating due to lack of unrestricted guest.  Forcing #UD is probably a net positive
> in that case, as it will cause KVM to ultimately fail with "emulation error" and
> bail to userspace.
> 
> It is possible to handle this in decode (idea below), but it will set us up for
> pain later.  If KVM ever does gain support for truly emulating hypercall

There was another annoyance that motivated me to sidestep emulation
altogether.

'Correct' emulation (or whatever we decide to call what KVM does) of the hypercall
instruction would require that we actually inform the emulator about nested for
both vendor calls. And by that I mean both {svm,vmx}_check_intercept would need
to correctly handle both VMCALL/VMMCALL. The one nice thing about hypercall
patching is that we could keep L1 oblivious, as we would have already rewritten
the instruction before reflecting the exit to L1.

While I was looking at #UD under nested for this issue, I noticed:

Isn't there a subtle inversion on #UD intercepts for nVMX? L1 gets first dibs
on #UD, even though it is possible that L0 was emulating an instruction not
present in hardware (like RDPID). If L1 passed through RDPID the #UD
should not be reflected to L1. I believe this would require that we make
the emulator aware of nVMX which sounds like a science project on its
own.

Do we write this off as another erratum of KVM's (virtual) hardware on VMX? :)

--
Thanks,
Oliver
