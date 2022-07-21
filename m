Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37EA57CA01
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 13:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbiGULyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 07:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiGULyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 07:54:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CB7E8323A
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 04:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658404450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ACGAphSl/uVPr1NVbyl0dQBpAKoxUqxXzVyjqeviado=;
        b=NtLQe67UJE1oqZalt8J4aQKdoxe6x4rlujLd4v/8VSd6FoWeWTLe02RN+v2P2aEfcDkIUd
        KPzw5ifadk95JgoiboDED4Zqsf6aoFJHCCxzFRDFxE4nzGAOd2qmsdJVgZNbgPtwtAs171
        76ChEEjsaknRXz37p1e3iYl+JXsFl1M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-llrGzIv2OZuu4LcOLJHx-A-1; Thu, 21 Jul 2022 07:54:06 -0400
X-MC-Unique: llrGzIv2OZuu4LcOLJHx-A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 323501C288C6;
        Thu, 21 Jul 2022 11:54:06 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A60AF18ECB;
        Thu, 21 Jul 2022 11:54:02 +0000 (UTC)
Message-ID: <8c28efac8fc9a8f27b21df7bfafe48a7e652d8dd.camel@redhat.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: emulator/smm: add structs for KVM's
 smram layout
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
Date:   Thu, 21 Jul 2022 14:54:01 +0300
In-Reply-To: <YtigjIgWj40QSsMA@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <20220621150902.46126-8-mlevitsk@redhat.com> <YtigjIgWj40QSsMA@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-21 at 00:40 +0000, Sean Christopherson wrote:
> On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> > Those structs will be used to read/write the smram state image.
> > 
> > Also document the differences between KVM's SMRAM layout and SMRAM
> > layout that is used by real Intel/AMD cpus.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/kvm_emulate.h | 139 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 139 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> > index 89246446d6aa9d..7015728da36d5f 100644
> > --- a/arch/x86/kvm/kvm_emulate.h
> > +++ b/arch/x86/kvm/kvm_emulate.h
> > @@ -503,6 +503,145 @@ enum x86_intercept {
> >  	nr_x86_intercepts
> >  };
> >  
> > +
> > +/*
> > + * 32 bit KVM's emulated SMM layout
> > + * Loosely based on Intel's layout
> > + */
> > +
> > +struct kvm_smm_seg_state_32 {
> > +	u32 flags;
> > +	u32 limit;
> > +	u32 base;
> > +} __packed;
> > +
> > +struct kvm_smram_state_32 {
> > +
> > +	u32 reserved1[62];			/* FE00 - FEF7 */
> > +	u32 smbase;				/* FEF8 */
> > +	u32 smm_revision;			/* FEFC */
> > +	u32 reserved2[5];			/* FF00-FF13 */
> > +	/* CR4 is not present in Intel/AMD SMRAM image*/
> > +	u32 cr4;				/* FF14 */
> > +	u32 reserved3[5];			/* FF18 */
> 
> Again, I love this approach, but we should have compile-time asserts to verify
> the layout, e.g. see vmx_check_vmcs12_offsets().
> 

No objections, will do.

Best regards,
	Maxim Levitsky

