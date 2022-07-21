Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AA057CA04
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 13:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiGULyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 07:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiGULyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 07:54:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15FB183225
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 04:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658404471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qjKQO5bCX/n98rTOch+pgDyqvg19SaZPcZ8G5j+ZIvk=;
        b=Av7O/WGLRSsNxlrOYMTtTzUMwXVrcpnOcI2ID1AhZA7m3UF8bFVTx8544/C6LMdVhkRoZN
        ZQoqm4zMZftEb3vb89TtCGbtzE0dR1JDLN1BDI4JcDdIGa7p4phIWSaBl/g4/2d6/57+ve
        lngdAoXb6CtcBw/LrTiZ6K7TeAYzFzA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-h4RXzRdwNr661wtG4LeZPQ-1; Thu, 21 Jul 2022 07:54:20 -0400
X-MC-Unique: h4RXzRdwNr661wtG4LeZPQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AD2685A587;
        Thu, 21 Jul 2022 11:54:20 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2F701121314;
        Thu, 21 Jul 2022 11:54:16 +0000 (UTC)
Message-ID: <e84d46e860bf2575564bb144eeb57230405ad36e.camel@redhat.com>
Subject: Re: [PATCH v2 09/11] KVM: x86: emulator/smm: use smram struct for
 64 bit smram load/restore
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 21 Jul 2022 14:54:15 +0300
In-Reply-To: <YtigALu4ccTi4/v0@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <20220621150902.46126-10-mlevitsk@redhat.com> <YtigALu4ccTi4/v0@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-21 at 00:38 +0000, Sean Christopherson wrote:
> On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> > Use kvm_smram_state_64 struct to save/restore the 64 bit SMM state
> > (used when X86_FEATURE_LM is present in the guest CPUID,
> > regardless of 32-bitness of the guest).
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> > @@ -9814,7 +9805,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
> >  	memset(buf, 0, 512);
> >  #ifdef CONFIG_X86_64
> >  	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
> > -		enter_smm_save_state_64(vcpu, buf);
> > +		enter_smm_save_state_64(vcpu, (struct kvm_smram_state_64 *)buf);
> >  	else
> >  #endif
> >  		enter_smm_save_state_32(vcpu, (struct kvm_smram_state_32 *)buf);
> 
> Hrm, I _love_ the approach overall, but I really dislike having to cast an
> arbitrary buffer, especially in the SVM code.
> 
> Aha!  Rather than keeping a buffer and casting, create a union to hold everything:
> 
> 	union kvm_smram {
> 		struct kvm_smram_state_64 smram64;
> 		struct kvm_smram_state_32 smram32;
> 		u8 bytes[512];
> 	};

Great idea, will do in v3.

> 
> and then enter_smm() becomes:
> 
>   static void enter_smm(struct kvm_vcpu *vcpu)
>   {
> 	struct kvm_segment cs, ds;
> 	struct desc_ptr dt;
> 	unsigned long cr0;
> 
> 	union kvm_smram smram;
> 
> 	BUILD_BUG_ON(sizeof(smram) != 512);
> 
> 	memset(smram.bytes, 0, sizeof(smram));
> #ifdef CONFIG_X86_64
> 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
> 		enter_smm_save_state_64(vcpu, &smram.smram64);
> 	else
> #endif
> 		enter_smm_save_state_32(vcpu, &smram.smram32);
> 
> 	/*
> 	 * Give enter_smm() a chance to make ISA-specific changes to the vCPU
> 	 * state (e.g. leave guest mode) after we've saved the state into the
> 	 * SMM state-save area.
> 	 */
> 	static_call(kvm_x86_enter_smm)(vcpu, &smram);
> 
> 	kvm_smm_changed(vcpu, true);
> 	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, smram.bytes, sizeof(smram));
> 
> and em_rsm() gets similar treatment.  Then the vendor code doesn't have to cast,
> e.g. SVM can do:
> 
> 	smram->smram64.svm_guest_flag = 1;
> 	smram->smram64.svm_guest_vmcb_gpa = svm->nested.vmcb12_gpa;
> 
> That way we don't have to refactor this all again if we want to use SMRAM to save
> something on Intel for VMX (though I agree with Jim that that's probably a bad idea).
> 

Best regards,
	Maxim Levitsky

