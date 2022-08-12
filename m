Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB669590BF6
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 08:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbiHLG0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 02:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbiHLG0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 02:26:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 454C18A6F4
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 23:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660285574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IPdDqhne4x6G2lLU0p73M/Ml6BV2ff81inMt9zmg0oQ=;
        b=G1fXtyVJQEcI+3X2xwtS2vkOdIcPFkYa7wjYRHiGfPXm7hpfAUUHAi5MJELPq9S9FnSvmn
        XXgm3n0ow37Uh9ynofRxeqOckYv9HhVEsK8Na4cDAjW7jyqjYhBV9QbvNPW8FV8s3EdoTz
        XohNeG97tvAYOaFQmKLCFN3b9RfMD9k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-kHfKNj6uOxy9b1DVKnYDhw-1; Fri, 12 Aug 2022 02:26:08 -0400
X-MC-Unique: kHfKNj6uOxy9b1DVKnYDhw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F8B0296A62F;
        Fri, 12 Aug 2022 06:26:08 +0000 (UTC)
Received: from starship (unknown [10.40.192.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76A7D492C3B;
        Fri, 12 Aug 2022 06:26:03 +0000 (UTC)
Message-ID: <084f4de105d24f22513c14a83c2254add31f5928.camel@redhat.com>
Subject: Re: [PATCH v3 03/13] KVM: x86: emulator: introduce
 emulator_recalc_and_set_mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <2e191acd-0b71-784a-2c14-6e78351788cc@intel.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
         <20220803155011.43721-4-mlevitsk@redhat.com>
         <2e191acd-0b71-784a-2c14-6e78351788cc@intel.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Fri, 12 Aug 2022 09:25:04 +0300
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-08-11 at 23:33 +0800, Yang, Weijiang wrote:
> On 8/3/2022 11:50 PM, Maxim Levitsky wrote:
> > [...]
> > +static inline int emulator_recalc_and_set_mode(struct x86_emulate_ctxt *ctxt)
> > +{
> > +       u64 efer;
> > +       struct desc_struct cs;
> > +       u16 selector;
> > +       u32 base3;
> > +
> > +       ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
> > +
> > +       if (!ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PE) {

Ouch, thanks for catching this!!

I wonder how I didn't catch this in unit tests....
(I'll check on this Sunday)


Best regards,
	Maxim Levitsky

> Shouldn't this be:  !(ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PE) ?
> > +               /* Real mode. cpu must not have long mode active */
> > +               if (efer & EFER_LMA)
> > +                       return X86EMUL_UNHANDLEABLE;
> > +               ctxt->mode = X86EMUL_MODE_REAL;
> > +               return X86EMUL_CONTINUE;
> > +       }
> > +
> [...]
> > --
> > 2.26.3
> > 


