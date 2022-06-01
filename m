Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BEA539FAD
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 10:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350908AbiFAIjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 04:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350906AbiFAIjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 04:39:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6700D5E174
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 01:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654072754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QtIf3KbY9OaafutQhHCVWaTK0LuvjzCiWKGIzW1Y3vY=;
        b=UjJUulTZm8o21zv/0is5KT/XgBXiiMJWv/PY4oq76y6eF8FDZCL0YoiRkDM7sUP5fMGsS1
        t1vToAxtTKOltm8PuIE7ojmzrPhcfVqjx8BeJOsKKrMfc7k4DB2NNVnaT98V1LVHjcriXd
        0qdvEvw4w+gfr4H1LX7oomtHNgg+ZSg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-6GTWMFV7MsqHqXUGX83EQg-1; Wed, 01 Jun 2022 04:39:13 -0400
X-MC-Unique: 6GTWMFV7MsqHqXUGX83EQg-1
Received: by mail-ed1-f69.google.com with SMTP id cy18-20020a0564021c9200b0042dc7b4f36fso778330edb.4
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 01:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QtIf3KbY9OaafutQhHCVWaTK0LuvjzCiWKGIzW1Y3vY=;
        b=DPUjeSQHszX8kQvA7cDbDNlnP5XHEKNWKvvyV9QDaL9hY0A6H5CaxbyXvtVhchBa4D
         fWIsvzjeEK6ypA3/liB7ERX4/78d3xxhCdktZvP5ntBUhc01512IisrKkJOvRT1nsLim
         4zf6npsgl5BSIiLPnmdAWMQOMiIFOrRjshjqLTHjD4ljCtAuAHfBspUmrOhCJ2Qvu+8l
         f+7VP5JhAnZ2Dl/rBUbJZCpKJwInOiy3kWAw1ouZWcPSRYfnZ+gXIubifaB/lQvrIpYk
         5cDP/+eZFlYc95Xa687ipNVUXIYnkqBHn39zHOSF2h2ntqx4CsyEtEFtDV2syLgGBO3t
         gwXg==
X-Gm-Message-State: AOAM530B3y/cCNPklmTWaZmxwFzWL6NFSHtztVoimWeRRbtLl5NcSvZD
        u2xjd3UgRY76YZrrWE1FEUI16l9dv476s/DlJt9Z6m0PhAv0L8mEcUIIjBESGtbBTU0SFQEL4oS
        TrHwPKUqMTEsS
X-Received: by 2002:a17:907:8a01:b0:6ff:3eab:9dfa with SMTP id sc1-20020a1709078a0100b006ff3eab9dfamr20580697ejc.467.1654072752024;
        Wed, 01 Jun 2022 01:39:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjUDvptsflZlmEnATV7LNhRKIXP6t0S1OgAvGO5fU2wwcWAFOoBLNlq3tKHCuMQEw6dGIqkA==
X-Received: by 2002:a17:907:8a01:b0:6ff:3eab:9dfa with SMTP id sc1-20020a1709078a0100b006ff3eab9dfamr20580681ejc.467.1654072751795;
        Wed, 01 Jun 2022 01:39:11 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id cq16-20020a056402221000b0042dd022787esm594062edb.6.2022.06.01.01.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 01:39:11 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Robert Dinse <nanook@eskimo.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 8/8] KVM: x86: Bug the VM on an out-of-bounds data read
In-Reply-To: <20220526210817.3428868-9-seanjc@google.com>
References: <20220526210817.3428868-1-seanjc@google.com>
 <20220526210817.3428868-9-seanjc@google.com>
Date:   Wed, 01 Jun 2022 10:39:10 +0200
Message-ID: <87ilpkok0h.fsf@redhat.com>
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

> Bug the VM and terminate emulation if an out-of-bounds read into the
> emulator's data cache occurs.  Knowingly contuining on all but guarantees
> that KVM will overwrite random kernel data, which is far, far worse than
> killing the VM.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/emulate.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 2aa17462a9ac..39ea9138224c 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1373,7 +1373,8 @@ static int read_emulated(struct x86_emulate_ctxt *ctxt,
>  	if (mc->pos < mc->end)
>  		goto read_cached;
>  
> -	WARN_ON((mc->end + size) >= sizeof(mc->data));
> +	if (KVM_EMULATOR_BUG_ON((mc->end + size) >= sizeof(mc->data), ctxt))
> +		return X86EMUL_UNHANDLEABLE;
>  
>  	rc = ctxt->ops->read_emulated(ctxt, addr, mc->data + mc->end, size,
>  				      &ctxt->exception);

The last WARN_ON() is gone, cool)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

