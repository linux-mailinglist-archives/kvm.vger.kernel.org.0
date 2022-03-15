Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B4D4D9E0D
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349435AbiCOOtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238359AbiCOOte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:49:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D976540E65
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 07:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647355700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZnF7RElcuXdfPSzWNjGS7zFij6QjXShEfRCK1+fTBZY=;
        b=GRSZzwge4845oO5iCiK09MUHP6MZboJ3AcuRsRKePb02FuoLzUJSOIqyugqIIARNfCOinO
        fiiiOIBV0KEqrZG0H4Ne5TRUU43UJRvBpPIxFoEiSzDmnIS/7VYzQWYt3ABaWrKU/SDo6G
        4TjWbFG++Fevbk3n2LnXZVecAm4mtbI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-5xNwKlzZNH2YhHZEef272w-1; Tue, 15 Mar 2022 10:48:17 -0400
X-MC-Unique: 5xNwKlzZNH2YhHZEef272w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C48DF101AA52;
        Tue, 15 Mar 2022 14:48:16 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FEDC401B28E;
        Tue, 15 Mar 2022 14:48:14 +0000 (UTC)
Message-ID: <57c2d5d64f9d65e442744fa8b7f188ed3fd37c1c.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: Trace all APICv inhibit changes and
 capture overall status
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 15 Mar 2022 16:48:12 +0200
In-Reply-To: <20220315144249.GA5496@gao-cwp>
References: <20220311043517.17027-1-seanjc@google.com>
         <20220311043517.17027-4-seanjc@google.com> <20220315144249.GA5496@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-15 at 22:42 +0800, Chao Gao wrote:
> On Fri, Mar 11, 2022 at 04:35:17AM +0000, Sean Christopherson wrote:
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9053,15 +9053,29 @@ bool kvm_apicv_activated(struct kvm *kvm)
> > }
> > EXPORT_SYMBOL_GPL(kvm_apicv_activated);
> > 
> > +
> 
> stray newline.
> 
> > +static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
> > +				       enum kvm_apicv_inhibit reason, bool set)
> > +{
> > +	if (set)
> > +		__set_bit(reason, inhibits);
> > +	else
> > +		__clear_bit(reason, inhibits);
> > +
> > +	trace_kvm_apicv_inhibit_changed(reason, set, *inhibits);
> 
> Note that some calls may not toggle any bit. Do you want to log them?
> I am afraid that a VM with many vCPUs may get a lot of traces that actually
> doesn't change inhibits.

I also think so.

Best regards,
	Maxim Levitsky

> 
> Anyway, this series looks good to me.
> 


