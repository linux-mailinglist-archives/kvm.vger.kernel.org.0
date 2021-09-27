Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44C6419D40
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 19:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237452AbhI0Rrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 13:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbhI0Rrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 13:47:45 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B339C06176E
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 10:33:46 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pf3-20020a17090b1d8300b0019e081aa87bso654490pjb.0
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 10:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QVPOqaNlq7I3lDhzzEE0LSlmqb5BJv1DMZ8alEx/1nI=;
        b=d285SG2vMoj7fWGLcc6kCiR/YbFmwFZ0r8FCUF/olwvOpdIeZoqHfRZvaCPNzDsw+I
         DXfTdpdYvY1o3+xwclpJFqsOx9rx8gXxXILEPFDMXqDFGp4BJoLLTpbwH1u1XP+r1Qam
         5szAUX8Uoct9SyiacXSLIaEMZeN1EKkEAgcpyL12gNGSfsGKRyH2m+hvt+6VnU5P+65Q
         0VTTYCcD9hk6ReQ9O9Swq7+ugPD0ecGhrBD3WfyuwTtr/uZVPNTBMwKAB7m8BgvxcC2+
         1ahXM7yNRUThnsg8QBfYfkaFmzHfumEXxhUu0VeZLeiCqPy+iDDU2pSUPBkNE2SVw6+C
         hGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QVPOqaNlq7I3lDhzzEE0LSlmqb5BJv1DMZ8alEx/1nI=;
        b=Tc165ff2GfAybrFWyjDcS95fF5xfLip87gHTDBPeLuclre9O2DZYPktt3yUALCDo9M
         3A1gtGdnPrTHBYGPoTIQi+J12WTKALhfjLs6ntPPAxd4AzxWnIH1QOV1ujN0b7MTvCoE
         V1+P/dIbYs9YgLQmL70Ag7YSXBDIObmn/taP7Lg6VKz8mWrRyEULggPY83yh+KZsE/iD
         Bp9YN2frE0k38bkNK3MZmhAw1GaMUb8Ua2dy9PxaYFQVxics+/QhOqRkYAdUrx9bXJ4m
         eitF2XJ/bOLN3/U5N94P29KQRmPGewR7utdylKzNx1836YSdhPypBniar0eHmtDofPaU
         DJxQ==
X-Gm-Message-State: AOAM530+UpBrrF6muBxQ7jXotPMgDZoCAr6gkkSvXM5LOJvgHvO8Df8g
        GXxRfCYOSFIrBP0O+DUkJTLkxA==
X-Google-Smtp-Source: ABdhPJyGE9PssoIO8hd/mc9M/bvKl7HfH1PbwL6q6ROscf2AvxLZZUXzLqFUTTNdwUlFUFuHe69vkw==
X-Received: by 2002:a17:90b:224b:: with SMTP id hk11mr253513pjb.231.1632764025351;
        Mon, 27 Sep 2021 10:33:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o17sm18385346pfp.126.2021.09.27.10.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 10:33:44 -0700 (PDT)
Date:   Mon, 27 Sep 2021 17:33:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Matlack <dmatlack@google.com>,
        Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        KVM ARM <kvmarm@lists.cs.columbia.edu>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, kvm-ppc <kvm-ppc@vger.kernel.org>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
Message-ID: <YVIAdVxc+q2UWB+J@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
 <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
 <CABgObfYtS6wiQe=BhF3t5usr7J6q4PWE4=rwZMMukfC9wT_6fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfYtS6wiQe=BhF3t5usr7J6q4PWE4=rwZMMukfC9wT_6fA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021, Paolo Bonzini wrote:
> On Mon, Sep 27, 2021 at 5:17 PM Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
> > > So I think there are two possibilities that makes sense:
> > >
> > > * track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns follow that
> >
> > what about using halt_poll_ns for those VMs that did not uses KVM_CAP_HALT_POLL and the private number for those that did.
> 
> Yes, that's what I meant.  David pointed out that doesn't allow you to
> disable halt polling altogether, but for that you can always ask each
> VM's userspace one by one, or just not use KVM_CAP_HALT_POLL. (Also, I
> don't know about Google's usecase, but mine was actually more about
> using KVM_CAP_HALT_POLL to *disable* halt polling on some VMs!).

I kinda like the idea if special-casing halt_poll_ns=0, e.g. for testing or
in-the-field mitigation if halt-polling is broken.  It'd be trivial to support, e.g.

@@ -3304,19 +3304,23 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
                update_halt_poll_stats(vcpu, start, poll_end, !waited);

        if (halt_poll_allowed) {
+               max_halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
+               if (!max_halt_poll_ns || !halt_poll_ns)  <------ squish the max if halt_poll_ns==0
+                       max_halt_poll_ns = halt_poll_ns;
+
                if (!vcpu_valid_wakeup(vcpu)) {
                        shrink_halt_poll_ns(vcpu);
-               } else if (vcpu->kvm->max_halt_poll_ns) {
+               } else if (max_halt_poll_ns) {
                        if (halt_ns <= vcpu->halt_poll_ns)
                                ;
                        /* we had a long block, shrink polling */
                        else if (vcpu->halt_poll_ns &&
-                                halt_ns > vcpu->kvm->max_halt_poll_ns)
+                                halt_ns > max_halt_poll_ns)
                                shrink_halt_poll_ns(vcpu);
                        /* we had a short halt and our poll time is too small */
-                       else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
-                                halt_ns < vcpu->kvm->max_halt_poll_ns)
-                               grow_halt_poll_ns(vcpu);
+                       else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
+                                halt_ns < max_halt_poll_ns)
+                               grow_halt_poll_ns(vcpu, max_halt_poll_ns);
                } else {
                        vcpu->halt_poll_ns = 0;
                }
