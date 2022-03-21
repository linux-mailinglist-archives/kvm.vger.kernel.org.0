Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32924E3355
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiCUWzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiCUWye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:54:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDD5E3A6BE3
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647901989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RMdmC49b3ZJ1Mqx/y/k2hlufZoUHk8hDl93lzACB4nw=;
        b=OH2CjVlnfYwNhPsJkO8HgCiRedtAJz8zirhavQtP2hZH/TKFvsefWGvvmE02F8m5/9TAym
        jTd774ag9o7Vs6PfOAGJ2Yath6CgHhvPJBvLxT8khBMyNoRirRXoAl1BWnrZ2Mf58SjNrO
        gy3nHc03XwGg0QethseuDUiOLL93Dlc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-wz3tO8UnOc2-hffHDtKRqg-1; Mon, 21 Mar 2022 18:11:28 -0400
X-MC-Unique: wz3tO8UnOc2-hffHDtKRqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 900543C14845;
        Mon, 21 Mar 2022 22:11:27 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F9902026D2D;
        Mon, 21 Mar 2022 22:11:24 +0000 (UTC)
Message-ID: <8071f0f0a857b0775f1fb2d1ebd86ffc4fd9096b.camel@redhat.com>
Subject: Re: [PATCH v3 4/7] KVM: x86: nSVM: support PAUSE filter threshold
 and count when cpu_pm=on
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Tue, 22 Mar 2022 00:11:23 +0200
In-Reply-To: <CALMp9eSUSexhPWMWXE1HpSD+movaYcdge_J95LiLCnJyMEp3WA@mail.gmail.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
         <20220301143650.143749-5-mlevitsk@redhat.com>
         <CALMp9eRjY6sX0OEBeYw4RsQKSjKvXKWOqRe=GVoQnmjy6D8deg@mail.gmail.com>
         <6a7f13d1-ed00-b4a6-c39b-dd8ba189d639@redhat.com>
         <CALMp9eRRT6pi6tjZvsFbEhrgS+zsNg827iLD4Hvzsa4PeB6W-Q@mail.gmail.com>
         <abe8584fa3691de1d6ae6c6617b8ea750b30fd1c.camel@redhat.com>
         <CALMp9eSUSexhPWMWXE1HpSD+movaYcdge_J95LiLCnJyMEp3WA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-03-21 at 14:59 -0700, Jim Mattson wrote:
> On Mon, Mar 21, 2022 at 2:36 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > On Wed, 2022-03-09 at 11:07 -0800, Jim Mattson wrote:
> > > On Wed, Mar 9, 2022 at 10:47 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > > On 3/9/22 19:35, Jim Mattson wrote:
> > > > > I didn't think pause filtering was virtualizable, since the value of
> > > > > the internal counter isn't exposed on VM-exit.
> > > > > 
> > > > > On bare metal, for instance, assuming the hypervisor doesn't intercept
> > > > > CPUID, the following code would quickly trigger a PAUSE #VMEXIT with
> > > > > the filter count set to 2.
> > > > > 
> > > > > 1:
> > > > > pause
> > > > > cpuid
> > > > > jmp 1
> > > > > 
> > > > > Since L0 intercepts CPUID, however, L2 will exit to L0 on each loop
> > > > > iteration, and when L0 resumes L2, the internal counter will be set to
> > > > > 2 again. L1 will never see a PAUSE #VMEXIT.
> > > > > 
> > > > > How do you handle this?
> > > > > 
> > > > 
> > > > I would expect that the same would happen on an SMI or a host interrupt.
> > > > 
> > > >         1:
> > > >         pause
> > > >         outl al, 0xb2
> > > >         jmp 1
> > > > 
> > > > In general a PAUSE vmexit will mostly benefit the VM that is pausing, so
> > > > having a partial implementation would be better than disabling it
> > > > altogether.
> > > 
> > > Indeed, the APM does say, "Certain events, including SMI, can cause
> > > the internal count to be reloaded from the VMCB." However, expanding
> > > that set of events so much that some pause loops will *never* trigger
> > > a #VMEXIT seems problematic. If the hypervisor knew that the PAUSE
> > > filter may not be triggered, it could always choose to exit on every
> > > PAUSE.
> > > 
> > > Having a partial implementation is only better than disabling it
> > > altogether if the L2 pause loop doesn't contain a hidden #VMEXIT to
> > > L0.
> > > 
> > 
> > Hi!
> > 
> > You bring up a very valid point, which I didn't think about.
> > 
> > However after thinking about this, I think that in practice,
> > this isn't a show stopper problem for exposing this feature to the guest.
> > 
> > 
> > This is what I am thinking:
> > 
> > First lets assume that the L2 is malicious. In this case no doubt
> > it can craft such a loop which will not VMexit on PAUSE.
> > But that isn't a problem - instead of this guest could have just used NOP
> > which is not possible to intercept anyway - no harm is done.
> > 
> > Now lets assume a non malicious L2:
> > 
> > 
> > First of all the problem can only happen when a VM exit is intercepted by L0,
> > and not by L1. Both above cases usually don't pass this criteria since L1 is highly
> > likely to intercept both CPUID and IO port access. It is also highly unlikely
> > to allow L2 direct access to L1's mmio ranges.
> > 
> > Overall there are very few cases of deterministic vm exit which is intercepted
> > by L0 but not L1. If that happens then L1 will not catch the PAUSE loop,
> > which is not different much from not catching it because of not suitable
> > thresholds.
> > 
> > Also note that this is an optimization only - due to count and threshold,
> > it is not guaranteed to catch all pause loops - in fact hypervisor has
> > to guess these values, and update them in attempt to catch as many such
> > loops as it can.
> > 
> > I think overall it is OK to expose that feature to the guest
> > and it should even improve performance in some cases - currently
> > at least nested KVM intercepts every PAUSE otherwise.
> 
> Can I at least request that this behavior be documented as a KVM
> virtual CPU erratum?

100%. Do you have a pointer where to document it?

Best regards,
	Maxim Levitsky

> 
> > Best regards,
> >         Maxim Levitsky
> > 
> > 
> > 
> > 


