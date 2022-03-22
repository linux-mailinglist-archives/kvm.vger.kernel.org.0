Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48484E3D57
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 12:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiCVLTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 07:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiCVLS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 07:18:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D68307DAA6
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 04:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647947849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H41xAxhmddWJigWYNLoIQApqV9cFykwx5iF2pkoPt5s=;
        b=STf45Yy4MfGsXBxphRmz2jQtAAyLwCSX3k95VXX2CVwGPjuFK1OEXdbu8ZsLa8c20cI0A/
        oZtvYKbO6oFc+XAsNydIf/rnDd33fg18Cag6OA1nrReZINOkxEYG+GVV7iRbZSMDm22nMr
        BadaV31TcqhWdf2khP8RT2iXBdvImm8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-1rSftk1YNRuRWh2eK2P3EQ-1; Tue, 22 Mar 2022 07:17:26 -0400
X-MC-Unique: 1rSftk1YNRuRWh2eK2P3EQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 765EA1C04B68;
        Tue, 22 Mar 2022 11:17:25 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A00ED1121314;
        Tue, 22 Mar 2022 11:17:19 +0000 (UTC)
Message-ID: <58702837572513e99eb859e2fc4d0e60ac27910d.camel@redhat.com>
Subject: Re: [PATCH v3 4/7] KVM: x86: nSVM: support PAUSE filter threshold
 and count when cpu_pm=on
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Tue, 22 Mar 2022 13:17:18 +0200
In-Reply-To: <b81c095a-30b2-95c6-1b5f-dfa102f5790a@redhat.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
         <20220301143650.143749-5-mlevitsk@redhat.com>
         <CALMp9eRjY6sX0OEBeYw4RsQKSjKvXKWOqRe=GVoQnmjy6D8deg@mail.gmail.com>
         <6a7f13d1-ed00-b4a6-c39b-dd8ba189d639@redhat.com>
         <CALMp9eRRT6pi6tjZvsFbEhrgS+zsNg827iLD4Hvzsa4PeB6W-Q@mail.gmail.com>
         <abe8584fa3691de1d6ae6c6617b8ea750b30fd1c.camel@redhat.com>
         <CALMp9eSUSexhPWMWXE1HpSD+movaYcdge_J95LiLCnJyMEp3WA@mail.gmail.com>
         <8071f0f0a857b0775f1fb2d1ebd86ffc4fd9096b.camel@redhat.com>
         <CALMp9eQgDpL0eD_GZde-s+THPWvQ0v6kmj3z_023f_KPERAyyA@mail.gmail.com>
         <b81c095a-30b2-95c6-1b5f-dfa102f5790a@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-22 at 11:12 +0100, Paolo Bonzini wrote:
> On 3/21/22 23:41, Jim Mattson wrote:
> > > 100%. Do you have a pointer where to document it?
> > I think this will be the first KVM virtual CPU erratum documented,
> > though there are plenty of others that I'd like to see documented
> > (e.g. nVMX processes posted interrupts on emulated VM-entry, AMD's
> > merged PMU counters are only 48 bits wide, etc.).
> > 
> > Maybe Paolo has some ideas?
> 
> So let's document them, that's a great idea.  I can help writing them 
> down if you have a pointer to prior email discussions.  I'll send a 
> skeleton.
> 
> Paolo
> 

Things that I know that don't work 100% correctly in KVM:

*  Relocation apic base. changing apic id also likely broken at least in some
   cases, and sure is with AVIC enabled.

   also likely some other obscure bits of the in-kernel emulation of APIC/IO apic/PIC/etc
   don't work correctly.

*  Emulator is not complete, so if you do unsupported instruction
   on mmio, it should fail.
   Also without unrestricted guest, emulator has to be used sometimes
   for arbitrary code so it wil fail fast.

*  Shadow mmu doesn't fully reflect real tlb, as tlb is usualy
   not shared between cpus.
   Also KVM's shadow mmu is more speculative vs real mmu - breaks old guests like win9x.

   Also no way to disable 1GB pages when NPT/EPT is enabled, since guest paging doesn't
   trap into the KVM.

*  Various minor issues with debug based on single stepping / DRs, etc,
   most of which I don't know well. Most of these can be fixed but it low priority,
   and I have seen many fixes in this area recently.
   Also proper support for nested monitor trap likely broken.

*  Various msrs are hardcoded/not supported - not much specific info on this.
   In particular no real support for mtrrs / pat - in fact KVM likes the guest memory to be
   always WB to avoid various cpu erratas.


Best regards,
	Maxim Levitsky

