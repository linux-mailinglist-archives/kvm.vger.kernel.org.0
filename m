Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E96D5692FD
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 22:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbiGFUDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 16:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbiGFUDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 16:03:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3770A1AF38
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 13:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657137809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Sr8k3PDlzkhDfTyq4SLY9EQEej76uPgXlyHbHD1UGE=;
        b=CAEF1nCR19UtIfBniJYnsmBc5VpzU8xPyCDo3bIcxIlpUxxKiAFui71P5xYRKt88bj0tTo
        9P6hFBjNMVgfwKbTLOgt98ho8YgJ+mQ6fyqWA2l5y8MqXSvQpsyfosiTdEdaUHDM05VXE+
        6elpj0FM5OogaKMH87qvL6n1dfYYYhQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-R612zF6dP1aeCwxl0Jr3Ow-1; Wed, 06 Jul 2022 16:03:28 -0400
X-MC-Unique: R612zF6dP1aeCwxl0Jr3Ow-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B159A101A54E;
        Wed,  6 Jul 2022 20:03:27 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61AE6492C3B;
        Wed,  6 Jul 2022 20:03:25 +0000 (UTC)
Message-ID: <bcf100cadb7fccddf8261301d9179a38ba237b06.camel@redhat.com>
Subject: Re: [PATCH v2 13/21] KVM: x86: Formalize blocking of nested pending
 exceptions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 23:03:24 +0300
In-Reply-To: <YsXIJ50adC+TVejy@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-14-seanjc@google.com>
         <cd9be62e3c2018a4f779f65fed46954e9431e0b0.camel@redhat.com>
         <YsXIJ50adC+TVejy@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-06 at 17:36 +0000, Sean Christopherson wrote:
> On Wed, Jul 06, 2022, Maxim Levitsky wrote:
> > On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> > > Capture nested_run_pending as block_pending_exceptions so that the logic
> > > of why exceptions are blocked only needs to be documented once instead of
> > > at every place that employs the logic.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/svm/nested.c | 20 ++++++++++----------
> > >  arch/x86/kvm/vmx/nested.c | 23 ++++++++++++-----------
> > >  2 files changed, 22 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index 471d40e97890..460161e67ce5 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -1347,10 +1347,16 @@ static inline bool nested_exit_on_init(struct vcpu_svm *svm)
> > >  
> > >  static int svm_check_nested_events(struct kvm_vcpu *vcpu)
> > >  {
> > > -	struct vcpu_svm *svm = to_svm(vcpu);
> > > -	bool block_nested_events =
> > > -		kvm_event_needs_reinjection(vcpu) || svm->nested.nested_run_pending;
> > >  	struct kvm_lapic *apic = vcpu->arch.apic;
> > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > +	/*
> > > +	 * Only a pending nested run blocks a pending exception.  If there is a
> > > +	 * previously injected event, the pending exception occurred while said
> > > +	 * event was being delivered and thus needs to be handled.
> > > +	 */
> > 
> > Tiny nitpick about the comment:
> > 
> > One can say that if there is an injected event, this means that we
> > are in the middle of handling it, thus we are not on instruction boundary,
> > and thus we don't process events (e.g interrupts).
> > 
> > So maybe write something like that?
> 
> Hmm, that's another way to look at things.  My goal with the comment was to try
> and call out that any pending exception is a continuation of the injected event,
> i.e. that the injected event won't be lost.  Talking about instruction boundaries
> only explains why non-exception events are blocked, it doesn't explain why exceptions
> are _not_ blocked.
> 
> I'll add a second comment above block_nested_events to capture the instruction
> boundary angle.
> 
> > > +	bool block_nested_exceptions = svm->nested.nested_run_pending;
> > > +	bool block_nested_events = block_nested_exceptions ||
> > > +				   kvm_event_needs_reinjection(vcpu);
> > 
> > Tiny nitpick: I don't like that much the name 'nested' as
> > it can also mean a nested exception (e.g exception that
> > happened while jumping to an exception  handler).
> > 
> > Here we mean just exception/events for the guest, so I would suggest
> > to just drop the word 'nested'.
> 
> I don't disagree, but I'd prefer to keep the current naming because the helper
> itself is *_check_nested_events().  I'm not opposed to renaming things in the
> future, but I don't want to do that in this series.
> 
Yep, makes sense.

Best regards,
	Maxim Levitsky

