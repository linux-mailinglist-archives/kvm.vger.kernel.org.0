Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C4E4DE823
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 14:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243015AbiCSNZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 09:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240509AbiCSNZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 09:25:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B83C13F88
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 06:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647696252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LAhEbRZv23sg+3l9XeDBt2uA5yTFBx5ccqYfvZx5ss0=;
        b=a97JRUxzg4CE/rQdpZVSkOdC77qOwAwoB7fRaJ27EMkBWl+3ZHKQ1HcugfZL+YYd7UI6Pf
        G30eOgp20DeLLnVWNhoL4+LN0GPZW7I6W+DPgR6YRRhliNh7mCjbkubxMJln48Bnl25vlg
        cKiwazaNyYW0uG8TFd3CN7y0dzVsJ/4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-MXq8IszIPMikZKuHDxBzbw-1; Sat, 19 Mar 2022 09:24:11 -0400
X-MC-Unique: MXq8IszIPMikZKuHDxBzbw-1
Received: by mail-ed1-f70.google.com with SMTP id v9-20020a509549000000b00418d7c2f62aso6503830eda.15
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 06:24:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LAhEbRZv23sg+3l9XeDBt2uA5yTFBx5ccqYfvZx5ss0=;
        b=HDiAWDKPQbj7If1M2njijc5ueGdSeYcqj9grQtkSuULLVZpT9sUDLzj4nRjhr8IPlW
         a8YDN06KhLB8fodHhRQDes3zjs7aTdS+Lh22EMIVX+r1UdGipFIEpES6OQU/GLfbSIak
         trxDpX/PRSNv1fPtazL7smSHpkkAhnKgT1w+L+9cQM7hPuc3SJusf1x9F1BAhJjbBfHR
         gUi2zZYdKXMvHIWqW6hGm1yNZWWSc3HSw4kNpPbZe7RpOb1jPE3aitBy/hZtjGRrHlqD
         O2PuR31tgZg2IbHHHdVCnFspbI7S9fxl1ZWTLdk0jXMXWvj/1/S2TA8jDZh5SOYw+gJV
         vTpg==
X-Gm-Message-State: AOAM532ky8FGi7PqUGWrFXZJrKwU539nODsAqvz1ASQQofocYHt2+EAg
        xO6k9k3ffCrmG30qrtsiaAvXJ3CLIGDi7dpkA+XeID7Lxj41t16Tlfo8c1N/FFJO9lG34gpuQUR
        BVEfDRGbyfizh
X-Received: by 2002:a17:907:7704:b0:6cf:48ac:b4a8 with SMTP id kw4-20020a170907770400b006cf48acb4a8mr13161268ejc.305.1647696249794;
        Sat, 19 Mar 2022 06:24:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8NFkT0ysq1q8SRtiCqUI2HWoJCMvPL0kr0rqzwobrsp24Q4Cv2FXmntZ0YbvOSbdqUcjf6A==
X-Received: by 2002:a17:907:7704:b0:6cf:48ac:b4a8 with SMTP id kw4-20020a170907770400b006cf48acb4a8mr13161251ejc.305.1647696249538;
        Sat, 19 Mar 2022 06:24:09 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id q2-20020a170906144200b006ceb8723de9sm4781578ejc.120.2022.03.19.06.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Mar 2022 06:24:08 -0700 (PDT)
Message-ID: <94df38ce-6bd7-a993-7d9f-0a1418a1c8df@redhat.com>
Date:   Sat, 19 Mar 2022 14:24:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH -v1.2] kvm/emulate: Fix SETcc emulation function offsets
 with SLS
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Cc:     Jamie Heilman <jamie@audible.transient.net>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <YjGzJwjrvxg5YZ0Z@audible.transient.net>
 <YjHYh3XRbHwrlLbR@zn.tnic> <YjIwRR5UsTd3W4Bj@audible.transient.net>
 <YjI69aUseN/IuzTj@zn.tnic> <YjJFb02Fc0jeoIW4@audible.transient.net>
 <YjJVWYzHQDbI6nZM@zn.tnic>
 <20220316220201.GM8939@worktop.programming.kicks-ass.net>
 <YjMBdMlhVMGLG5ws@zn.tnic> <YjMS8eTOhXBOPFOe@zn.tnic>
 <YjMVpfe/9ldmWX8W@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YjMVpfe/9ldmWX8W@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/17/22 12:04, Peter Zijlstra wrote:
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> Depending on what Paolo wants, it might make sense to merge this into
> tip/x86/urgent such that we can then resolve the merge conflict vs
> tip/x86/core with something like the below:

Sorry for responding late, I was sick the past few days.  Go ahead and 
apply it to tip/x86/core with the rest of the SLS and IBT patches.  If 
you place it in front of the actual insertion of the INT3 it will even 
be bisectable, but I'm not sure if your commit hashes are already frozen.

Just one thing:

> -#define SETCC_ALIGN	(4 * (1 + IS_ENABLED(CONFIG_SLS)))
> +/*
> + * Depending on .config the SETcc functions look like:
> + *
> + * setcc:
> + * +0	ENDBR		[CONFIG_X86_KERNEL_IBT]
> + * +4	SETcc	%al
> + * +7	RET
> + * +8	INT3		[CONFIG_SLS]
> + *
> + * Which gives possible sizes: 4, 5, 8, 9 which when rounded up to the
> + * next power-of-two alignment become: 4, 8, 16.
> + */
> +#define SETCC_ALIGN	(4 * (1 + IS_ENABLED(CONFIG_SLS)) * (1 + HAS_KERNEL_IBT))

This might be slightly nicer as (4 << IS_ENABLED(CONFIG_SLS) << 
HAS_KERNEL_IBT.  Or maybe not, depends on your taste.

It might also be worth doing:

#define SETCC_LENGTH (4 + IS_ENABLED(CONFIG_SLS) + 4 * HAS_KERNEL_IBT)
#define SETCC_ALIGN  (4 << IS_ENABLED(CONFIG_SLS) << HAS_KERNEL_IBT)
BUILD_BUG_ON(SETCC_LENGTH <= SETCC_ALIGN);

Thanks,

Paolo

