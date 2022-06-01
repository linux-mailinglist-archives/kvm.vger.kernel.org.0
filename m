Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DD2539F8A
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 10:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350820AbiFAIcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 04:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349408AbiFAIb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 04:31:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F9042FE51
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 01:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654072313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BRjRy4QuDv/Sqz+aOic6CcbjAuVweriyEvX/LgyeBJs=;
        b=IiM7frZFMjNnG0Z4up9XPhLOcPSVGzVYxYF2rqi52C3KIn47hRbrAn1VV5XKXOTQyGqvOh
        ASzp1IOFtoB/Ai9FTLkanTT5F2WmLIBht0KTRZmIezb803EG7nDhYYkasM+1ayRDfyZHos
        RwjsC0RnDifvOv0Nna1khWGzIdJiEVs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-J3xqC7zJPy2Zn_-LJwA0Vg-1; Wed, 01 Jun 2022 04:31:52 -0400
X-MC-Unique: J3xqC7zJPy2Zn_-LJwA0Vg-1
Received: by mail-ed1-f70.google.com with SMTP id cy18-20020a0564021c9200b0042dc7b4f36fso764583edb.4
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 01:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BRjRy4QuDv/Sqz+aOic6CcbjAuVweriyEvX/LgyeBJs=;
        b=bJrK3bgmQu76p5yQD5SO42oJG3ZFt9uaDVXNtncfAL2KHdYBVJvWSdpQ29Sr2Ujt1k
         cgV5vLjgTEPkycAGGjJMhjwqSC1Y9B+hYsR0geoXqC16/2EKnfPEKwyZkMa7I6S0d4xr
         GuwJ+GkFAl74Dyy1gYL1weSbBlLIU/XYfVN9zLkcu1+sBld8MIEjPIGd8YzZdcL4fl7j
         lAEWhGefrdBQ1HOuc2K+ANkTHz7hN+BarZ6YJ4w9mKycxlziu1WLyQHsGURyzXIh7+iX
         TzllLhVEePfH1wd0ueu5e0D/NOqh2+gcW2VRqu+qJRXgxdcGpE7UPxpHBTQYQuTailKQ
         Gjag==
X-Gm-Message-State: AOAM5320mCgsN6bZ42izXXlfT5C517ICCY2IKWEyq2qAr5RioIaqSTyY
        Z8nzaVqIwaYsdsD4UqCOT6qohAqTsdjPZadVWBgkW1XjF6tflzwlsXpMN5NvmRg6CgUw1+Zyfh/
        HBJJ5B+3ITJiK
X-Received: by 2002:a17:907:3e84:b0:6fe:8c5f:d552 with SMTP id hs4-20020a1709073e8400b006fe8c5fd552mr55954430ejc.710.1654072311202;
        Wed, 01 Jun 2022 01:31:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9DVJ6FqBpWGxY5tywdmZKsQoJj4ojxDb7NQ24EnoFYJieuekNxE7gt4GgF856Cxw6TXTg4g==
X-Received: by 2002:a17:907:3e84:b0:6fe:8c5f:d552 with SMTP id hs4-20020a1709073e8400b006fe8c5fd552mr55954411ejc.710.1654072310968;
        Wed, 01 Jun 2022 01:31:50 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 4-20020a170906310400b00705976bcd01sm415340ejx.206.2022.06.01.01.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 01:31:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Robert Dinse <nanook@eskimo.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 7/8] KVM: x86: Bug the VM if the emulator generates a
 bogus exception vector
In-Reply-To: <20220526210817.3428868-8-seanjc@google.com>
References: <20220526210817.3428868-1-seanjc@google.com>
 <20220526210817.3428868-8-seanjc@google.com>
Date:   Wed, 01 Jun 2022 10:31:49 +0200
Message-ID: <87leugokcq.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Bug the VM if KVM's emulator attempts to inject a bogus exception vector.
> The guest is likely doomed even if KVM continues on, and propagating a
> bad vector to the rest of KVM runs the risk of breaking other assumptions
> in KVM and thus triggering a more egregious bug.
>
> All existing users of emulate_exception() have hardcoded vector numbers
> (__load_segment_descriptor() uses a few different vectors, but they're
> all hardcoded), and future users are likely to follow suit, i.e. the
> change to emulate_exception() is a glorified nop.
>
> As for the ctxt->exception.vector check in x86_emulate_insn(), the few
> known times the WARN has been triggered in the past is when the field was
> not set when synthesizing a fault, i.e. for all intents and purposes the
> check protects against consumption of uninitialized data.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/emulate.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 70a8e0cd9fdc..2aa17462a9ac 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -624,7 +624,9 @@ static unsigned long seg_base(struct x86_emulate_ctxt *ctxt, int seg)
>  static int emulate_exception(struct x86_emulate_ctxt *ctxt, int vec,
>  			     u32 error, bool valid)
>  {
> -	WARN_ON(vec > 0x1f);
> +	if (KVM_EMULATOR_BUG_ON(vec > 0x1f, ctxt))
> +		return X86EMUL_UNHANDLEABLE;
> +
>  	ctxt->exception.vector = vec;
>  	ctxt->exception.error_code = error;
>  	ctxt->exception.error_code_valid = valid;
> @@ -5728,7 +5730,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  
>  done:
>  	if (rc == X86EMUL_PROPAGATE_FAULT) {
> -		WARN_ON(ctxt->exception.vector > 0x1f);
> +		if (KVM_EMULATOR_BUG_ON(ctxt->exception.vector > 0x1f, ctxt))
> +			return EMULATION_FAILED;
>  		ctxt->have_exception = true;
>  	}
>  	if (rc == X86EMUL_INTERCEPTED)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

