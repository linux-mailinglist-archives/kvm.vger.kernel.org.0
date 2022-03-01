Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110E34C913C
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbiCARN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbiCARNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:13:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1B434838C
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646154789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hPN5JwUatfJhVFBiHuO8MPmnVXIce6kUOc4BGm1YEvY=;
        b=d3N22ec8rGS5gq3geyXf8fR+AIjJXtCK8JGU6hB8QvsUQN4QXAG/KuVMaJi465c++mQL0e
        Or4j1P01mw+TIfpjZfyDwugKweT3PpsTSOWULZtqHkj9HyF7kPV4EGiyrDxZQXb7zSEaSj
        vSr1abdHR7FWCjeFdqWuCmGto3jac0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-wm-lAGIKMsiuE7i1ljBKFA-1; Tue, 01 Mar 2022 12:13:06 -0500
X-MC-Unique: wm-lAGIKMsiuE7i1ljBKFA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8B18824FA7;
        Tue,  1 Mar 2022 17:13:04 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59C7E2ED78;
        Tue,  1 Mar 2022 17:13:01 +0000 (UTC)
Message-ID: <2fddbfd6b6e68f3f8e972536c27a87ffadbe1911.camel@redhat.com>
Subject: Re: [PATCH 1/4] KVM: x86: mark synthetic SMM vmexit as SVM_EXIT_SW
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Date:   Tue, 01 Mar 2022 19:13:00 +0200
In-Reply-To: <Yh5KTtLhRyfmx/ZF@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
         <20220301135526.136554-2-mlevitsk@redhat.com> <Yh5KTtLhRyfmx/ZF@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-01 at 16:31 +0000, Sean Christopherson wrote:
> On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> > Use a dummy unused vmexit reason to mark the 'VM exit' that is happening
> > when kvm exits to handle SMM, which is not a real VM exit.
> 
> Why not use "62h VMEXIT_SMI"?

Because VMEXIT_SMI is real vmexit which happens when L1 intercepts #SMI
And here nested_svm_vmexit is abused to just exit guest mode without vmexit.

> 
> > This makes it a bit easier to read the KVM trace, and avoids
> > other potential problems.
> 
> What other potential problems?

The fact that we have a stale VM exit reason in vmcb without this
patch which can be in theory consumed somewhere down the road.

This stale vm exit reason also appears in the tracs which is
very misleading.

Best regards,
	Maxim Levitsky

> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 7038c76fa8410..c08fd7f4f3414 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4218,7 +4218,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
> >  	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
> >  	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
> >  
> > -	ret = nested_svm_vmexit(svm);
> > +	ret = nested_svm_simple_vmexit(svm, SVM_EXIT_SW);
> >  	if (ret)
> >  		return ret;
> >  
> > -- 
> > 2.26.3
> > 


