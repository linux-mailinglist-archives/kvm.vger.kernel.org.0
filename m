Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAF44E1BF3
	for <lists+kvm@lfdr.de>; Sun, 20 Mar 2022 15:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245219AbiCTOFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 10:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245179AbiCTOFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 10:05:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51D153A5E5
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 07:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647785048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HEnmlDwpyZjcuvzIqjP5JJWtowc3f3ehGNPzqFNCQBM=;
        b=gTpMHy0L0zP9j4qW0CunPMZdY2BnDVNYVAD1JsNz28i+aSpMCtAxmehFKXkLF9KYodzgi3
        263K9OZaNxFKofM+cJRHkTXbtpkZaWTCZzDuhD3gUtHF48q+EEtMVuxpI0kcGX109PTpVF
        1WACXxX5aOIHZO8McQr+l27nZnEIlWA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-Gm3QijdIP02JHTQrE0n3TQ-1; Sun, 20 Mar 2022 10:04:07 -0400
X-MC-Unique: Gm3QijdIP02JHTQrE0n3TQ-1
Received: by mail-ej1-f72.google.com with SMTP id my15-20020a1709065a4f00b006dfd2b16e6cso1242000ejc.1
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 07:04:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HEnmlDwpyZjcuvzIqjP5JJWtowc3f3ehGNPzqFNCQBM=;
        b=Kwmfp9iARGGzkk3vvJcGNUdTg4/ax8gKCiJ224g3v7+4yFJPofr1MST0iYCmDmcIO7
         zqKd9RdMr5x16OJdLlX1K/YqaOgluK0WwzOGGC45L6zVltYrwCrYAw553LPm6onmHrI9
         OTfKMVNKx2KIXaP0jVk1vFOXzun4MNGxpQjQTcfeU3GoS50zHNPyicWFpG3wn9w4iMNh
         itoj/wtFa5jPUqBc54YLn7TmuUr9z87vv+7B2lAAv0nBCOywE6ionpqIZ51/XOmu8TTi
         1fnlUfv8AZKnr8d808ZdY5RFzLUWoh4WwEm6uhya6AHszCMkoBIblhaZlvK4obxWSxGx
         f2eg==
X-Gm-Message-State: AOAM532BmCllDDzq1fbVcdFkBq+LmR4D5hLNfCExf0U0UtFGmCMyn5Ld
        q/eX5DTM7koZXr1Usg5IvJ5aqWOemVSlTpy+SzN1Pg9u3w6y+ZW1BCrLvwAPhK4U/RYQ94m8q0I
        DCqh0EUCPp75P
X-Received: by 2002:a17:907:72c3:b0:6df:91a4:32f4 with SMTP id du3-20020a17090772c300b006df91a432f4mr14980695ejc.638.1647785045902;
        Sun, 20 Mar 2022 07:04:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQGmyirZNe9b6sO0PJWsvv8mPfxVD8wfCRdvfa3DBmcAbh8uwX5f45eC15Bdc86Lph4lJSRA==
X-Received: by 2002:a17:907:72c3:b0:6df:91a4:32f4 with SMTP id du3-20020a17090772c300b006df91a432f4mr14980663ejc.638.1647785045490;
        Sun, 20 Mar 2022 07:04:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id u18-20020a17090617d200b006db07a16cf5sm5863067eje.77.2022.03.20.07.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Mar 2022 07:04:04 -0700 (PDT)
Message-ID: <6970ccc4-1c42-23fa-0b31-99b102ed76c8@redhat.com>
Date:   Sun, 20 Mar 2022 15:04:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH -v1.2] kvm/emulate: Fix SETcc emulation function offsets
 with SLS
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jamie Heilman <jamie@audible.transient.net>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <YjI69aUseN/IuzTj@zn.tnic>
 <YjJFb02Fc0jeoIW4@audible.transient.net> <YjJVWYzHQDbI6nZM@zn.tnic>
 <20220316220201.GM8939@worktop.programming.kicks-ass.net>
 <YjMBdMlhVMGLG5ws@zn.tnic> <YjMS8eTOhXBOPFOe@zn.tnic>
 <YjMVpfe/9ldmWX8W@hirez.programming.kicks-ass.net>
 <94df38ce-6bd7-a993-7d9f-0a1418a1c8df@redhat.com> <YjXcRsR2T8WGnVjl@zn.tnic>
 <ad13632c-127d-ff5a-6530-5282e58521b1@redhat.com> <YjXfgsSZpVVdg0lv@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YjXfgsSZpVVdg0lv@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/19/22 14:50, Borislav Petkov wrote:
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 5719d8cfdbd9..f321abb9a4a8 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -429,8 +429,11 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
>   	FOP_END
>   
>   /* Special case for SETcc - 1 instruction per cc */
> +
> +#define SETCC_ALIGN	(4 * (1 + IS_ENABLED(CONFIG_SLS)))
> +
>   #define FOP_SETCC(op) \
> -	".align 4 \n\t" \
> +	".align " __stringify(SETCC_ALIGN) " \n\t" \
>   	".type " #op ", @function \n\t" \
>   	#op ": \n\t" \
>   	#op " %al \n\t" \
> @@ -1047,7 +1050,7 @@ static int em_bsr_c(struct x86_emulate_ctxt *ctxt)
>   static __always_inline u8 test_cc(unsigned int condition, unsigned long flags)
>   {
>   	u8 rc;
> -	void (*fop)(void) = (void *)em_setcc + 4 * (condition & 0xf);
> +	void (*fop)(void) = (void *)em_setcc + SETCC_ALIGN * (condition & 0xf);
>   
>   	flags = (flags & EFLAGS_MASK) | X86_EFLAGS_IF;
>   	asm("push %[flags]; popf; " CALL_NOSPEC

So this is what I squashed in:

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f321abb9a4a8..e86d610dc6b7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -430,7 +430,19 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
  
  /* Special case for SETcc - 1 instruction per cc */
  
-#define SETCC_ALIGN	(4 * (1 + IS_ENABLED(CONFIG_SLS)))
+/*
+ * Depending on .config the SETcc functions look like:
+ *
+ * SETcc %al   [3 bytes]
+ * RET         [1 byte]
+ * INT3        [1 byte; CONFIG_SLS]
+ *
+ * Which gives possible sizes 4 or 5.  When rounded up to the
+ * next power-of-two alignment they become 4 or 8.
+ */
+#define SETCC_LENGTH	(4 + IS_ENABLED(CONFIG_SLS))
+#define SETCC_ALIGN	(4 << IS_ENABLED(CONFIG_SLS))
+static_assert(SETCC_LENGTH <= SETCC_ALIGN);
  
  #define FOP_SETCC(op) \
  	".align " __stringify(SETCC_ALIGN) " \n\t" \

Paolo

