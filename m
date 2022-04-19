Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DA25064CC
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349029AbiDSGro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 02:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349040AbiDSGrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 02:47:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FD4C13D05
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650350695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LefR+GnWqX3MjBts53Y0LYPST2a84sipLAxvttQVcyI=;
        b=G8NIZJ1wVri7bSbyE31UqWR6B+XpIQdtVMUSiN+GwRm2Eyw8WwtBBA9BKlUb6VlydZ/jYu
        J/pkjDZVaopJ7pEhvToMBvdynWn3Nm7wC1lLyFb63BUFA3MsKzrPae4mTCOBvAmGyeZCBO
        0hTKUGKypqCkzCnZ1OjLkZsUapDTKKY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-k1KNzykeP-iWA7oMKLO9tw-1; Tue, 19 Apr 2022 02:44:52 -0400
X-MC-Unique: k1KNzykeP-iWA7oMKLO9tw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 150BE29DD980;
        Tue, 19 Apr 2022 06:44:52 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04C19215CDD1;
        Tue, 19 Apr 2022 06:44:48 +0000 (UTC)
Message-ID: <8b2ff3dc317db18c8128381d5d62057a90f68265.camel@redhat.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Defer APICv updates while L2 is active
 until L1 is active
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gaoning Pan <pgn@zju.edu.cn>,
        Yongkang Jia <kangel@zju.edu.cn>
Date:   Tue, 19 Apr 2022 09:44:48 +0300
In-Reply-To: <Yl2FXfCjvkNgM4w3@google.com>
References: <20220416034249.2609491-1-seanjc@google.com>
         <20220416034249.2609491-3-seanjc@google.com>
         <227adbe6e8d82ad4c5a803c117d4231808a0e451.camel@redhat.com>
         <Yl2FXfCjvkNgM4w3@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-04-18 at 15:35 +0000, Sean Christopherson wrote:
> On Mon, Apr 18, 2022, Maxim Levitsky wrote:
> > On Sat, 2022-04-16 at 03:42 +0000, Sean Christopherson wrote:
> > When L2 uses APICv/AVIC, we just safely passthrough its usage to the real hardware.
> > 
> > If we were to to need to inhibit it, we would have to emulate APICv/AVIC so that L1 would
> > still think that it can use it - thankfully there is no need for that.
> 
> What if L1 passes through IRQs and all MSRs to L2? 

KVM absolutely should inhibit L1 AVIC/APICv in this case if L2 triggers AUTOEOI inhibit via msr write via non
intercepted msr, and I don't see why it won't work.

It should not affect L2's APICv/AVIC though, only L1 can decide that it wants to inhibit it,
and it has all the means to do so without any help from L0.


In regard to APICv, neither vmcs02 nor vmcs01 should need to be touched on a vCPU
that does this though:
 
 
- vmcs02 can't have APICv enabled, because passthrough of interrupts thankfully
  conflicts with APICv (virtual interrupt delivery depends on intercepting interrupts)
  and even if that was false, it would have contained L2's APICv settings which should
  continue to work as usual.
 
- vmcs01 isn't active on this vCPU, so no need to touch it. vmcs01 of other vCPUs
  which don't run nested, does need to be updated to have APICv inhibited, 
  which should work just fine unless there are bugs in KVM's APICv.
 
 
- Posted interrupts that target L1 will be delivered as normal interrupts and cause KVM to 
  inject them to L2 (because of no interception)
 
- Posted interrupts that target L2 can't even happen because APICv can't be enabled in L1

 
In regard to SVM, in theory you can have interrupt intercept disabled and yet have AVIC enabled
in both L0 and L1, but it should work just fine as well:
 
In this case, while running nested:
 
L2 if it has direct access to L1's AVIC, will be able to write there but all writes will
be normal MMIO writes and work as usual but not accelerated.
 
Interrupts that target L1 will not go through AVIC, but be delivered via normal IPIs,
because L1's avic is inhibited on this vCPU locally, and then KVM will inject them to L2.
 
Interrupts that target L2 will go through nested AVIC and land there just fine.
 
AVIC inhibition/uninhibition in this case has 0 effect on this vCPU, as L1 AVIC is already
inhibited locally on this vCPU, and my code will correctly do nothing in this case.

Yes in theory, when L1 doesn't use AVIC for L2, and passes through all interrupts to L2,
I could have setup vmcb02 to use L0's AVIC and let interrupts that target L1 go to L2
via AVIC, but it is just not worth the complexity this adds, and it might not even
work correctly in some cases, since L1 still has its own APIC, even if it doesn't
really receive interrupts while L2 is running.

 
IMHO it all adds up.
 
Best regards,
	Maxim Levitsky



>   L1 isn't expecting a VM-Exit, so
> KVM can't safely punt to L1 even if conceptually we think that it's L1's problem.
> 
> It's a contrived scenario, but technically possible.
> 


