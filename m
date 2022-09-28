Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C2D5ED5B9
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 09:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiI1HLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 03:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbiI1HLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 03:11:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F6913CC7
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 00:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664349060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wnwp0ICYi0IL1E+eNZ2+WEbweWyAgkGiqxsj7EWaexk=;
        b=bv0tq9ebrbdH1dZF0bnLRjDeRERs/YPbMSOUt/mz+F6kLmv3rHaBt+XqhQHwRYVl8i2mri
        +AJPy+Km616Rj4RCK3QDvXulNWJ/9iNIH+vwF0upzo+V7VqVAcviEozhO9T6bC25ktU4Ff
        UiB8bOB7i7LxVlj+hgMBoB6K9d917Ns=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-crNMTAxROma0_8wVriaKgg-1; Wed, 28 Sep 2022 03:10:55 -0400
X-MC-Unique: crNMTAxROma0_8wVriaKgg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7202D3C0D188;
        Wed, 28 Sep 2022 07:10:55 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35B681121315;
        Wed, 28 Sep 2022 07:10:54 +0000 (UTC)
Message-ID: <ed74c9a9d6a0d2fd2ad8bd98214ad36e97c243a0.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: disable on 32-bit unless CONFIG_BROKEN
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 28 Sep 2022 10:10:53 +0300
In-Reply-To: <YzMt24/14n1BVdnI@google.com>
References: <20220926165112.603078-1-pbonzini@redhat.com>
         <YzMt24/14n1BVdnI@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-09-27 at 17:07 +0000, Sean Christopherson wrote:
> On Mon, Sep 26, 2022, Paolo Bonzini wrote:
> > 32-bit KVM has extra complications in the code due to:
> > 
> > - different ways to write 64-bit values in VMCS
> > 
> > - different handling of DS and ES selectors as well as FS/GS bases
> > 
> > - lack of CR8 and EFER
> > 
> > - lack of XFD
> > 
> 
> More for the list:
> 
>   - SVM is effectively restricted to PAE kernels due to NX requirements
> 
> > - impossibility of writing 64-bit PTEs atomically
> 
> It's not impossible, just ugly.  KVM could use CMPXCHG8B to do all of the accesses
> for the TDP MMU, including the non-atomic reads and writes.
> 
> > The last is the big one, because it prevents from using the TDP MMU
> > unconditionally.
> 
> As above, if the TDP MMU really is the sticking point, that's solvable.
> 
> The real justification for deprecating 32-bit KVM is that, outside of KVM developers,
> literally no one uses 32-bit KVM.  I.e. any amount of effort that is required to
> continue supporting 32-bit kernels is a complete waste of resources.
> 

I also think that outside KVM developers nobody should be using KVM on 32 bit host.

However for _developement_ I think that 32 bit KVM support is very useful, as it
allows to smoke test the support for 32 bit nested hypervisors, which I do once in a while,
and can even probably be useful to some users (e.g running some legacy stuff in a VM,
which includes a hypervisor, especially to run really legacy OSes / custom bare metal software,
using an old hypervisor) - or in other words, 32 bit nested KVM is mostly useless, but
other 32 bit nested hypervisors can be useful.

Yes, I can always use an older 32 bit kernel in a guest with KVM support, but as long
as current kernel works, it is useful to use the same kernel on host and guest.

Best regards,
	Maxim Levitsky

