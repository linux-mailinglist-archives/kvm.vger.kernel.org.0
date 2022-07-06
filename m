Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44E0569300
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 22:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbiGFUEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 16:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiGFUEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 16:04:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D7E21C92F
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 13:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657137849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LayklR/S19h1wCQtjwIoLcNMOFevjKh5pX4dbOQsh/M=;
        b=LSu9rTG5hcpHS/z5U2kWXQF3ueKGGpRSHrjmHo7hNOi6kvk03j8ZzS3YyYZjEExcCd4O7N
        K96elf5Q3MztijyazRftkChvC/ybCaEU0d2eR0SIUMatUNphwjXlbiU+isUCOgD0iqq7r8
        fNBJqvfTBJBYMi2MtcjhJmR1ex2Tlqk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-4sLMvAJwP7u0so2ngqNs2w-1; Wed, 06 Jul 2022 16:03:57 -0400
X-MC-Unique: 4sLMvAJwP7u0so2ngqNs2w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 380F9802C16;
        Wed,  6 Jul 2022 20:03:57 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC1112EF97;
        Wed,  6 Jul 2022 20:03:54 +0000 (UTC)
Message-ID: <bffaf01772a42d90512ee4d7240ead253083f23b.camel@redhat.com>
Subject: Re: [PATCH v2 00/21] KVM: x86: Event/exception fixes and cleanups
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 23:03:53 +0300
In-Reply-To: <YsXL6qfSMHc0ENz8@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <7e05e0befa13af05f1e5f0fd8658bc4e7bdf764f.camel@redhat.com>
         <CALMp9eSkdj=kwh=4WHPsWZ1mKr9+0VSB527D5CMEx+wpgEGjGw@mail.gmail.com>
         <cab59dcca8490cbedda3c7cf5f93e579b96a362e.camel@redhat.com>
         <CALMp9eT_C3tixwK_aZMd-0jQHBSsdrzhYvWk6ZrYkxcC8Pe=CQ@mail.gmail.com>
         <YsXL6qfSMHc0ENz8@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-06 at 17:52 +0000, Sean Christopherson wrote:
> On Wed, Jul 06, 2022, Jim Mattson wrote:
> > On Wed, Jul 6, 2022 at 4:55 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > 
> > > 1. Since #SMI is higher priority than the #MTF, that means that unless dual monitor treatment is used,
> > >    and the dual monitor handler figures out that #MTF was pending and re-injects it when it
> > >    VMRESUME's the 'host', the MTF gets lost, and there is no way for a normal hypervisor to
> > >    do anything about it.
> > > 
> > >    Or maybe pending MTF is saved to SMRAM somewhere.
> > > 
> > >    In case you will say that I am inventing this again, I am saying now that the above is
> > >    just a guess.
> > 
> > This is covered in the SDM, volume 3, section 31.14.1: "Default
> > Treatment of SMI Delivery:"
> > 
> > The pseudocode above makes reference to the saving of VMX-critical
> > state. This state consists of the following:
> > (1) SS.DPL (the current privilege level); (2) RFLAGS.VM2; (3) the
> > state of blocking by STI and by MOV SS (see
> > Table 24-3 in Section 24.4.2); (4) the state of virtual-NMI blocking
> > (only if the processor is in VMX non-root oper-
> > ation and the “virtual NMIs” VM-execution control is 1); and (5) an
> > indication of whether an MTF VM exit is pending
> > (see Section 25.5.2). These data may be saved internal to the
> > processor or in the VMCS region of the current
> > VMCS. Processors that do not support SMI recognition while there is
> > blocking by STI or by MOV SS need not save
> > the state of such blocking.
> > 
> > Saving VMX-critical state to SMRAM is not documented as an option.
> 
> Hmm, I'm not entirely convinced that Intel doesn't interpret "internal to the
> processor" as "undocumented SMRAM fields".  But I could also be misremembering
> the SMI flows.
> 
> Regardless, I do like the idea of using vmcs12 instead of SMRAM.  That would provide
> some extra motivation for moving away from KVM's broken pseudo VM-Exit implementation.
> 

For preserving pending MTF, I guess it makes sense to use vmcb12, especially since we own
its format.

Best regards,
	Maxim Levitsky

