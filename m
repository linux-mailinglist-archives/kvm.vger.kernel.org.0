Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998387AF1BA
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 19:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjIZR3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 13:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbjIZR3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 13:29:06 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9537910A;
        Tue, 26 Sep 2023 10:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=2Wn+Oz8+SPbM3gd+kYavU89kl0O459xMQgxgmk/VM0E=; b=PW/4mwwJSkE5uCeJsb1NRLo74E
        c81VBL5z/cVcAbgi+RGrzlAa+sfBbEOk+XCOdtv5imVUZ9Yh+o4UVlhOTj/fN2mO+4fN3lGTRua4G
        /dz3vqXNhQBld8zpXB9KvVhoYDGp0oCdZxTaSBbYoc59imE7aCQ891xEyKfOvFzXDzbrx98NR1Bf7
        mRrkNUZRYHVDiS+oSuUeO38a8ZdAAuFCffZzYqN3QuqidZlerV65faz5IijQ1Li5df0UhqcHwqXr2
        ZNOKfdx7eCTVFu4yiclNf47flHE8ZJeIIeKRmXYfW3XGvyM1h+kKVI8lBYdLTz1niaxdk+P9fJ2lg
        tjn479nQ==;
Received: from [31.94.19.5] (helo=[127.0.0.1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qlBra-002zDy-2y;
        Tue, 26 Sep 2023 17:28:48 +0000
Date:   Tue, 26 Sep 2023 19:28:45 +0200
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.de>
CC:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Griffoul, Fred" <fgriffo@amazon.com>
Subject: =?US-ASCII?Q?Re=3A_=5BRFC=5D_KVM=3A_x86=3A_Allow_userspace_exi?= =?US-ASCII?Q?t_on_HLT_and_MWAIT=2C_else_yield_on_MWAIT?=
User-Agent: K-9 Mail for Android
In-Reply-To: <CABgObfZb4CvzpnSJxz9saw8PJeo1Y2=0uB9y4_K+Cu9P9FpF6g@mail.gmail.com>
References: <1b52b557beb6606007f7ec5672eab0adf1606a34.camel@infradead.org> <CABgObfZgYXaXqP=6s53=+mYWvOnbgYJiCRct-0ob444sK9SvGw@mail.gmail.com> <faec494b6df5ebee5644017c9415e747bd34952b.camel@infradead.org> <3dc66987-49c7-abda-eb70-1898181ef3fe@redhat.com> <d3e0c3e9-4994-4808-a8df-3d23487ff9c4@amazon.de> <CABgObfZb4CvzpnSJxz9saw8PJeo1Y2=0uB9y4_K+Cu9P9FpF6g@mail.gmail.com>
Message-ID: <21C2A5D8-66D9-4EF0-A416-4B1049C91E83@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26 September 2023 19:20:24 CEST, Paolo Bonzini <pbonzini@redhat=2Ecom> =
wrote:
>On Sat, Sep 23, 2023 at 6:44=E2=80=AFPM Alexander Graf <graf@amazon=2Ede>=
 wrote:
>> On 23=2E09=2E23 11:24, Paolo Bonzini wrote:
>> > Why do you need it?  You can just use KVM_RUN to go to sleep, and if =
you
>> > get another job you kick out the vCPU with pthread_kill=2E  (I also d=
idn't
>> > get the VSM reference)=2E
>>
>> With the original VSM patches, we used to make a vCPU aware of the fact
>> that it can morph into one of many VTLs=2E That approach turned out to =
be
>> insanely intrusive and fragile and so we're currently reimplementing
>> everything as VTLs as vCPUs=2E That allows us to move the majority of V=
SM
>> functionality to user space=2E Everything we've seen so far looks as if
>> there is no real performance loss with that approach=2E
>
>Yes, that was also what I remember, sharing the FPU somehow while
>having separate vCPU file descriptors=2E
>
>> One small problem with that is that now user space is responsible for
>> switching between VTLs: It determines which VTL is currently running an=
d
>> leaves all others (read: all other vCPUs) as stopped=2E That means if y=
ou
>> are running happily in KVM_RUN in VTL0 and VTL1 gets an interrupt, user
>> space needs to stop VTL0 and unpause VTL1 until it triggers VTL_RETURN
>> at which point VTL1 stops execution and VTL0 runs again=2E
>
>That's with IPIs in VTL1, right? I understand now=2E My idea was, since
>we need a link from VTL1 to VTL0 for the FPU, to use the same link to
>trigger a vmexit to userspace if source VTL > destination VTL=2E I am
>not sure how you would handle the case where the destination vCPU is
>not running; probably by detecting the IPI when VTL0 restarts on the
>destination vCPU?
>
>In any case, making vCPUs poll()-able is sensible=2E

Thinking about this a bit more, even for HLT it probably isn't just as sim=
ple as checking for mp_state changes=2E If there's a REQ_EVENT outstanding =
for something like a timer delivery, that won't get handled and the IRQ act=
ually delivered to the local APIC until the vCPU is actually *run*, will it=
?
