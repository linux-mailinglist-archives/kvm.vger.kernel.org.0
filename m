Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B272C4D75E0
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 15:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbiCMOcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 10:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbiCMOcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 10:32:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F29A7A27A8
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 07:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647181865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t0rzllhT4D4HGCll6z8oMQ6VdDNx6HwJabESxTEqvYs=;
        b=U58B7AUtXTHkvJq5eghjQQupn6Q6TCm6JFCEHG0xR8NFIFSE1zYI2yTe+y8ehd7Gcyno8N
        WQzCaAuUuWyID6S3I4UszZDXRlUVSONSWRHtwJ2xcKnAnE1hiEI1I0+QXS+Jrh5xRU87ML
        FcLm4fS1rrIinj7GMovnvmr1DBEGYtQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-e0m0g5JjO8-GX0bOlg_ECw-1; Sun, 13 Mar 2022 10:31:04 -0400
X-MC-Unique: e0m0g5JjO8-GX0bOlg_ECw-1
Received: by mail-wm1-f70.google.com with SMTP id f24-20020a1c6a18000000b00388874b17a8so5678031wmc.3
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 07:31:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t0rzllhT4D4HGCll6z8oMQ6VdDNx6HwJabESxTEqvYs=;
        b=TVKdfB/CI2vMs72tn30d4VvUZTXr5J8KO4grrw7Z47DqEbki87nZUSHItghnxAczus
         BQ4zFryT8XMWTrMepnqmN7rhr7QV9talwygiKN6mRgsQ45GK36mTWerIsrWTsrhcMK48
         66thM2lhSmC6QSpMev04ubrlTg9XfqcjC4f6KfcO64qgUHu3u/SSyG2AF4jiKdTo/48L
         iXzS1pylIkNsxjo8VJFee8zE/nc8vEdBTxpi2WrZnN3kuHBBxCk5423nbKuWHgrzUSmE
         9CGb3db3lr40KgjYmcejzbeo0nWFb/j66ktmAgh1Q8YQnjwhddwxN5FRt6hQ2JbjHMEh
         qNzg==
X-Gm-Message-State: AOAM531LK+L7p6CLlQssRBaFO/PCN8qqqsj1SxaR0QTDKBtpCHrrIIJP
        3ExAUdvC1BEd3VOrhvt/qqCPvnU7aILXMYfLhxxIZ204pl0asq1s50F6yyuc5DOKWHB7D2mMbxv
        UBcEOXvVlj1PF
X-Received: by 2002:adf:dbd2:0:b0:1ea:9382:6bff with SMTP id e18-20020adfdbd2000000b001ea93826bffmr13493655wrj.705.1647181863053;
        Sun, 13 Mar 2022 07:31:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ4Jpoe+1140bikIy2clXHIgGePlOFofwDCd4dlmcojKqgVA2HSN55Fya/v/LGTqMEPxQXYA==
X-Received: by 2002:adf:dbd2:0:b0:1ea:9382:6bff with SMTP id e18-20020adfdbd2000000b001ea93826bffmr13493644wrj.705.1647181862762;
        Sun, 13 Mar 2022 07:31:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id z3-20020a1cf403000000b0037d1f4a2201sm12326593wma.21.2022.03.13.07.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 07:31:00 -0700 (PDT)
Message-ID: <1d35eef3-df9d-ab48-8b36-4d7874b405cc@redhat.com>
Date:   Sun, 13 Mar 2022 15:30:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/2] KVM: x86/xen: PV oneshot timer fixes
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
References: <20220309143835.253911-1-dwmw2@infradead.org>
 <20220309143835.253911-2-dwmw2@infradead.org>
 <846caa99-2e42-4443-1070-84e49d2f11d2@redhat.com>
 <0709ac62f664c0f3123fcdeabed3b79038cef3b6.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <0709ac62f664c0f3123fcdeabed3b79038cef3b6.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/22 17:41, David Woodhouse wrote:
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
> index af2d26fc5458..f371f1292ca3 100644
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -156,7 +156,6 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
>   {
>   	__kvm_migrate_apic_timer(vcpu);
>   	__kvm_migrate_pit_timer(vcpu);
> -	__kvm_migrate_xen_timer(vcpu);
>   	static_call_cond(kvm_x86_migrate_timers)(vcpu);
>   }
> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
> index ad0876a7c301..2bbbc1a3953e 100644
> --- a/arch/x86/kvm/xen.h
> +++ b/arch/x86/kvm/xen.h
> @@ -75,7 +75,6 @@ static inline int kvm_xen_has_pending_timer(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> -void __kvm_migrate_xen_timer(struct kvm_vcpu *vcpu);
>   void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu);
>   #else
>   static inline int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
> -- 2.33.1
> 

Squashed, thanks.  But---sure you want to get rid of timer migration?

Paolo

