Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA1254AFBF
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356176AbiFNMCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 08:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356088AbiFNMCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 08:02:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E4A248323
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 05:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655208119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o96R2liK/Rw+rA+r9jCufpYDG8GL1tJQ/8vEiFbyM6o=;
        b=WzX++k2nAc/2RHz9J242mTwhddSTaO3k1X7mOUOa5UjIoq7HGniNrHH0aHc24YMcZDITTf
        jcSSjR84ndbH1DbPhdFYB9YiJQNqIhFjKb00zGaA7XJXoGbTHJSAHzLzlXCM62mF1i7Wjl
        SW19+slh2XHpBFra06D0P5o+JzaqhKs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-lPf57nTLMaKlPD5JT6uWZQ-1; Tue, 14 Jun 2022 08:01:57 -0400
X-MC-Unique: lPf57nTLMaKlPD5JT6uWZQ-1
Received: by mail-ej1-f70.google.com with SMTP id gr1-20020a170906e2c100b006fefea3ec0aso2753479ejb.14
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 05:01:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=o96R2liK/Rw+rA+r9jCufpYDG8GL1tJQ/8vEiFbyM6o=;
        b=saSj2Fi0bgTLmmp9WTaLs7e5eAOyHEij/uKZWNcMa9mkirqLut2/ISwQXr45CVcCio
         VkiDX1Rf66iLfF9DwWgVQZRuzrBlpgHyqTn/kbPDepkhNosa5Z2QxPmpusn5875x8grc
         0xC5Ws9yBJHx3XrIAvXNV7xxglPhBTE2jq6ocQaPilLk1nLhD1q7QPJs7m/FKwZ3eQ12
         2PXt6zACYWrQCCDW5CYDGxdlEyRTow8Lw94hgQ9qKhQSNbQm1NDY4yAL+hfxp8ouPgBN
         vcXb0K1M58GWNySlWnE6xt79dhE7nediQKvaHDL/iNEzcfRHSEDSLJoIq+HR1+t2Hzn6
         YrFw==
X-Gm-Message-State: AOAM532vO05Vbf5C5Cpp9qMSTCuOiJUT4PYhYmeEdlQEwqul4gAlUcNG
        PP/fkHuY+U4SZVJZ7Wyd4KmF+I2J2q12YCoIW2WOfjKdyDicXa/dyO1+VdoyjeRvOsy4lWs0CS6
        s1LExQiYG8FmR
X-Received: by 2002:a05:6402:b09:b0:42d:bd80:11ac with SMTP id bm9-20020a0564020b0900b0042dbd8011acmr5697602edb.244.1655208116045;
        Tue, 14 Jun 2022 05:01:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tEtZpjxqfX31iR1J4Bw5cOqOaEdjuVhAslKHGEPsqyrNUbKoaC6+E3Rv9RKO/BWr1fuea/Iw==
X-Received: by 2002:a05:6402:b09:b0:42d:bd80:11ac with SMTP id bm9-20020a0564020b0900b0042dbd8011acmr5697568edb.244.1655208115822;
        Tue, 14 Jun 2022 05:01:55 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v14-20020a056402348e00b0042dc25fdf5bsm7112494edc.29.2022.06.14.05.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:01:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     mudongliang <mudongliangabcd@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: kvm: remove NULL check before kfree
In-Reply-To: <20220614085035.122521-1-dzm91@hust.edu.cn>
References: <20220614085035.122521-1-dzm91@hust.edu.cn>
Date:   Tue, 14 Jun 2022 14:01:54 +0200
Message-ID: <87zgifihcd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dongliang Mu <dzm91@hust.edu.cn> writes:

> From: mudongliang <mudongliangabcd@gmail.com>
>
> kfree can handle NULL pointer as its argument.
> According to coccinelle isnullfree check, remove NULL check
> before kfree operation.
>
> Signed-off-by: mudongliang <mudongliangabcd@gmail.com>
> ---
>  arch/x86/kernel/kvm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 1a3658f7e6d9..d4e48b4a438b 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -236,8 +236,7 @@ void kvm_async_pf_task_wake(u32 token)
>  	raw_spin_unlock(&b->lock);
>  
>  	/* A dummy token might be allocated and ultimately not used.  */
> -	if (dummy)
> -		kfree(dummy);
> +	kfree(dummy);
>  }
>  EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

