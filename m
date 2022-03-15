Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAD64D9B2D
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 13:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348251AbiCOM3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 08:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbiCOM3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 08:29:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEF76532F6
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 05:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647347266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QZj/j3mujpkHpYXJfMpqznpHbCKC+8ZpMC/lUI9cO/E=;
        b=JY5CPncxgKXYAEqzN3HuzJUoc+5dT7r6DRcE1w+kkEYVxJ9/ClU0JB3+/sJhPCWr1lJPry
        xyyAzVYxR3IJyjdk+SpqvwY+zQU91VzXoh1tZ7vh9FKylszc2FSVjrHxgwxZgZ4USQ2jc3
        rdyKTwHljHSyN74RDf+GDFHy0ZQg11w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-Mjj8FLqdMHqKdxErlIq-vQ-1; Tue, 15 Mar 2022 08:27:45 -0400
X-MC-Unique: Mjj8FLqdMHqKdxErlIq-vQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22A723C02B6B;
        Tue, 15 Mar 2022 12:27:45 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35579401E36;
        Tue, 15 Mar 2022 12:27:42 +0000 (UTC)
Message-ID: <74fdb7e9d29af948d6ddaa7755b3c8bf7577f9c7.camel@redhat.com>
Subject: Re: [PATCH 3/4] KVM: x86: SVM: use vmcb01 in avic_init_vmcb
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Date:   Tue, 15 Mar 2022 14:27:41 +0200
In-Reply-To: <7b1999d1-4fd7-1b59-76f7-4287ad2c2a99@redhat.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
         <20220301135526.136554-4-mlevitsk@redhat.com> <Yh5H8qRhbefuD9YF@google.com>
         <603d78c516d10119c833ff54367b63b7a66f32b3.camel@redhat.com>
         <7b1999d1-4fd7-1b59-76f7-4287ad2c2a99@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-03-09 at 16:48 +0100, Paolo Bonzini wrote:
> On 3/1/22 18:25, Maxim Levitsky wrote:
> > > I don't like this change.  It's not bad code, but it'll be confusing because it
> > > implies that it's legal for svm->vmcb to be something other than svm->vmcb01.ptr
> > > when this is called.
> > Honestly I don't see how you had reached this conclusion.
> >   
> > I just think that code that always works on vmcb01
> > should use it, even if it happens that vmcb == vmcb01.
> >   
> > If you insist I can drop this patch or add WARN_ON instead,
> > I just think that this way is cleaner.
> >   
> 
> I do like the patch, but you should do the same in init_vmcb() and 
> svm_hv_init_vmcb() as well.

I will do this.
Thanks!

Best regards,
	Maxim Levitsky
> 
> Paolo
> 


