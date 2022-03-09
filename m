Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4844D3890
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 19:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbiCISPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 13:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbiCISPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 13:15:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 221E3C24B0
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 10:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646849652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BiL4ATUz1KNDAzAGSlQ9x7yx5LofUJYOal186YuSgkA=;
        b=UEgCCK67+ipGeg+ZmQv1JkhCZtbc2Qnt9zx+w027cH4Y5wxAcIxx3DxnlVtTXinr2k8uU2
        WrhQ+GfBsuvPuYRoQ7oDVdbxeIyt/6mDIs/Hr8gn84rGU62WfSrfL6o+5ku42764PamK8F
        zKwYopUb4e8mGewwxC9EEzmTTE/MS1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-RyZsAxO9PRiLijzr435wWA-1; Wed, 09 Mar 2022 13:14:09 -0500
X-MC-Unique: RyZsAxO9PRiLijzr435wWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EED8880205C;
        Wed,  9 Mar 2022 18:14:06 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B98FF7F0DB;
        Wed,  9 Mar 2022 18:14:01 +0000 (UTC)
Message-ID: <ff76ebe610fd46c1e6d7f3eee436426056961747.camel@redhat.com>
Subject: Re: [PATCH v3 7/7] KVM: x86: SVM: allow AVIC to co-exist with a
 nested guest running
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Wed, 09 Mar 2022 20:14:00 +0200
In-Reply-To: <bdb527f3-9281-1f25-c6c7-a8538455bfa3@redhat.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
         <20220301143650.143749-8-mlevitsk@redhat.com>
         <bdb527f3-9281-1f25-c6c7-a8538455bfa3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-03-09 at 14:50 +0100, Paolo Bonzini wrote:
> On 3/1/22 15:36, Maxim Levitsky wrote:
> >   	bool activate;
> > @@ -9690,7 +9695,9 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
> >   
> >   	down_read(&vcpu->kvm->arch.apicv_update_lock);
> >   
> > -	activate = kvm_apicv_activated(vcpu->kvm);
> > +	activate = kvm_apicv_activated(vcpu->kvm) &&
> > +		   !vcpu_has_apicv_inhibit_condition(vcpu);
> > +
> >   	if (vcpu->arch.apicv_active == activate)
> >   		goto out;
> >   
> 
> Perhaps the callback could be named vcpu_apicv_inhibit_reasons, and it would
> return APICV_INHIBIT_REASON_NESTED?  Then instead of the new function
> vcpu_has_apicv_inhibit_condition(), you would have
> 
> bool kvm_vcpu_apicv_activated(struct vcpu_kvm *kvm)
> {
> 	ulong vm_reasons = READ_ONCE(vcpu->kvm->arch.apicv_inhibit_reasons);
> 	ulong vcpu_reasons = static_call(kvm_x86_vcpu_apicv_inhibit_reasons)(vcpu);
>          return (vm_reasons | vcpu_reasons) == 0;
> }
> EXPORT_SYMBOL_GPL(kvm_cpu_apicv_activated);
> 
> It's mostly aesthetics, but it would also be a bit more self explanatory I think.
> 
> Paolo
> 

This is a great idea, I will do it in next version.
Thanks!

Best regards,
	Maxim Levitsky

