Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534FA37479C
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 20:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbhEESBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 14:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbhEESA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 14:00:58 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A76C04BE42
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 10:34:49 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t2-20020a17090ae502b029015b0fbfbc50so1255046pjy.3
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 10:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pTTuRgK8OZ5vlAlZOqM9k9U/8/bnkECtvXImRJXjECI=;
        b=UvDbR6z5QHQ+Oj8rENsLCDbKe84pyj5ZgNVJdWMahQ66wPRVa06l//z2k28asdg2dc
         CYFS1J7JwsiDBOs2FNsM27LnCVp0xOXjP9UkZVOrArrLbTbEonWPzGN3bqonqU1QNxUu
         CIRSVGeW4q0vmxZ0BYZxObbMmubbgS8OItPeHFj/4/66o1xuGioBMmGU28qwhm+43pzH
         iP4MoRQOKJmfrjpUpnWpXc5ZkbQYeVE77UwItBNsSqw8M0bQ5kITmvYc8MBp4SGB3Vs5
         dy+Qq04/z8tFm0rJTRxhLUFFapUMzro4wR+Ik1+BEFSIgNUIvjwn26DdUeIPv1/PiXX7
         5OXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pTTuRgK8OZ5vlAlZOqM9k9U/8/bnkECtvXImRJXjECI=;
        b=QmJoV1r6w7Je7cwKIa69Dy7m2GwiWbHHKk3fkC/rHXujhPvB4aN4hOcQuk9GW0AKiW
         7HNch+GtHF4MQp2gldHxlwA72Fuq+a59/zldSnFO28r6yIIbTfufu99DH6oIPUWGgutZ
         R6uH2r6FqbuDkwnCsOd5RxmZRw3RQAywSflTI3D4T5GZuEmrJxhYT7VKH1bxLBdKbmJp
         a5aAHy06RGx+Qwk4OUbitm7MLN9KXqrmVGPsZtArmAE6bWmUYFheUL3UIvkCLoC+m0IR
         eHkszJ/CBQTLxA9MTg7QrfkFp4wLS2m/16rvA9jsT0VOb0rV9Be/Wyf1YvkKCq/cjem9
         gBXA==
X-Gm-Message-State: AOAM532JjjQj7RVplJXVa6fEdxfHDXSYuQnaltoi4RgYz099VSkZyyj8
        h6MMNb4Rv5Wi1u/iTg5cDgAxKg==
X-Google-Smtp-Source: ABdhPJxdMe1aYGDhkaGP/IYqbPqgfe6PvzQKMIOMp0ynpLP7lMMzD4NQiTkY3vSnPiRxo80fVW3P2g==
X-Received: by 2002:a17:902:9a08:b029:ec:bef1:4ea1 with SMTP id v8-20020a1709029a08b02900ecbef14ea1mr32413393plp.78.1620236089271;
        Wed, 05 May 2021 10:34:49 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h3sm14747997pfc.184.2021.05.05.10.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 10:34:48 -0700 (PDT)
Date:   Wed, 5 May 2021 17:34:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: nVMX: Properly pad 'struct
 kvm_vmx_nested_state_hdr'
Message-ID: <YJLXNZtaWL3LKGjn@google.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
 <20210503150854.1144255-3-vkuznets@redhat.com>
 <ff72dc0172cfdef228e63d766cb37e417cc4334d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff72dc0172cfdef228e63d766cb37e417cc4334d.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021, Maxim Levitsky wrote:
> On Mon, 2021-05-03 at 17:08 +0200, Vitaly Kuznetsov wrote:
> > Eliminate the probably unwanted hole in 'struct kvm_vmx_nested_state_hdr':
> > 
> > Pre-patch:
> > struct kvm_vmx_nested_state_hdr {
> >         __u64                      vmxon_pa;             /*     0     8 */
> >         __u64                      vmcs12_pa;            /*     8     8 */
> >         struct {
> >                 __u16              flags;                /*    16     2 */
> >         } smm;                                           /*    16     2 */
> > 
> >         /* XXX 2 bytes hole, try to pack */
> > 
> >         __u32                      flags;                /*    20     4 */
> >         __u64                      preemption_timer_deadline; /*    24     8 */
> > };
> > 
> > Post-patch:
> > struct kvm_vmx_nested_state_hdr {
> >         __u64                      vmxon_pa;             /*     0     8 */
> >         __u64                      vmcs12_pa;            /*     8     8 */
> >         struct {
> >                 __u16              flags;                /*    16     2 */
> >         } smm;                                           /*    16     2 */
> >         __u16                      pad;                  /*    18     2 */
> >         __u32                      flags;                /*    20     4 */
> >         __u64                      preemption_timer_deadline; /*    24     8 */
> > };
> > 
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> >  arch/x86/include/uapi/asm/kvm.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 5a3022c8af82..0662f644aad9 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -437,6 +437,8 @@ struct kvm_vmx_nested_state_hdr {
> >  		__u16 flags;
> >  	} smm;
> >  
> > +	__u16 pad;
> > +
> >  	__u32 flags;
> >  	__u64 preemption_timer_deadline;
> >  };
> 
> 
> Looks good to me.
> 
> I wonder if we can enable the -Wpadded GCC warning to warn about such cases.
> Probably can't be enabled for the whole kernel but maybe we can enable it
> for KVM codebase at least, like we did with -Werror.

It'll never work, there are far, far too many structs throughout the kernel and
KVM that have implicit padding.  And for kernel-internal structs, that's perfectly
ok and even desirable since the kernel generally shouldn't make assumptions about
the layouts of its structs, i.e. it's a good thing the compiler pads structs so
that accesses are optimally aligned.

The padding behavior is only problematic for structs that are exposed to
userspace, because if userspace pads differently then we've got problems.  But
even then, building the kernel with -Wpadded wouldn't prevent userspace from
using a broken/goofy compiler that inserts unusual padding and misinterprets the
intended layout.

AFAIK, the C standard only expicitly disallows padding at the beginning of a
struct, i.e. the kernel's ABI is heavily reliant on existing compiler convention.
The only way to ensure exact layouts without relying on compiler convention would
be to tagged structs as packed, but "packed" also causes the compiler to generate
sub-optimal code since "packed" has strict requirements, and so the kernel relies
on sane compiler padding to provide a stable ABI.
