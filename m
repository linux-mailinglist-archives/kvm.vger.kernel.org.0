Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BABC625CEB
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 15:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbiKKOYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 09:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiKKOYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 09:24:10 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EC043863;
        Fri, 11 Nov 2022 06:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=Sb7rhzFRTTVumBbHTQESASP2OPrWEPxQZs1Su9jVIS0=; b=k7bnVmG5wpWVyC1+0eVzQvuOPX
        MQhjYm/BIy+ccLdUF+xyA/giCUzSMkBXuC59bUHm2ZcizyQSJtaOKDVV6kRk8+sWsPOXy6marMMgP
        0PDuJ/m1cJK5WwGYpZM7u3jjdVBR10VtQ5FmcaihgGNHYKQLtxqDVh689CbJpdjZIPOq/Rz4qeBJh
        gT4jzJparsbJHfYofxho2RCagrUoEPpFBULfHBKoTeJCN/Q53TOvfyL74CUkWAJWddiAazhYilwbP
        14gHE55QmeZbHUZlxGxGT278Zqcjw0PC7WNHby0gwvf5KBH11F292rNAepWnRw2KDzBImyPdp9VLj
        jWSk7/Og==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1otUw6-0003qY-NW; Fri, 11 Nov 2022 14:23:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7DBFA30036B;
        Fri, 11 Nov 2022 15:23:13 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6593D2016A1E7; Fri, 11 Nov 2022 15:23:13 +0100 (CET)
Date:   Fri, 11 Nov 2022 15:23:13 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Message-ID: <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 01:48:26PM +0100, Paolo Bonzini wrote:
> On 11/11/22 13:19, Peter Zijlstra wrote:
> > On Fri, Nov 11, 2022 at 01:04:27PM +0100, Paolo Bonzini wrote:
> > > On Intel you can optionally make it hold onto IRQs, but NMIs are always
> > > eaten by the VMEXIT and have to be reinjected manually.
> > 
> > That 'optionally' thing worries me -- as in, KVM is currently
> > opting-out?
> 
> Yes, because "If the “process posted interrupts” VM-execution control is 1,
> the “acknowledge interrupt on exit” VM-exit control is 1" (SDM 26.2.1.1,
> checks on VM-Execution Control Fields).  Ipse dixit.  Posted interrupts are
> available and used on all processors since I think Ivy Bridge.

(imagine the non-coc compliant reaction here)

So instead of fixing it, they made it worse :-(

And now FRED is arguably making it worse again, and people wonder why I
hate virt...
