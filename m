Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC644CA4B9
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 13:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241760AbiCBMWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 07:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241096AbiCBMWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 07:22:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63B125BE7E
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 04:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646223687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WNKkxBchI/c25YADkWlXBfwk9i6taCQEJEVHv51XNSs=;
        b=XsojAqYT27lwbn4pDizlaLojzW90ewG26t+/W6xqoN3zeDopP9FUyQjWvBeUG+4WGJ7neM
        lR1qRxQEZt5s6NBXoGZW8C92Vud/pkeqs77Cc371rc9PIppD68KT8igQWTfFOXi0wpcTae
        dZ2QH3yjL5PRVyf2cz1Do4hKC0Df2Tg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-6S-2ozeJPlGxZgC5HIe0pw-1; Wed, 02 Mar 2022 07:21:26 -0500
X-MC-Unique: 6S-2ozeJPlGxZgC5HIe0pw-1
Received: by mail-wr1-f71.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so574382wrg.19
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 04:21:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WNKkxBchI/c25YADkWlXBfwk9i6taCQEJEVHv51XNSs=;
        b=z0WUDiwyIGqb4qJDzp//eBZVNaR/5NFfDi9+pB/tRnF4OmdTk4HjeQaut6emSuruYl
         sHbuQEUr3q3wIvUssz/dKypMI6aT1qgX8S1PM7PMq0af9skQSPioaGhFkIkUVjKptxWG
         5Hh3u7dWVVe+Q5jKhD1d7E3tHUqiXH19uErYPQQBSdvqRa72juRYFTGf8OGbYsX25gxm
         ZQfUXK8Fwd7PNm6mfGkQKtEge2NKy+nZhG8EJRHmTrzXmEiB8BqFn9DTzUkT3HZHX7/Z
         NbdBQvHZ5zkzdSirZgbjiz7ERaTX7ZyJ3v2gXSH3Nswff+OpEm9NWcjM9po9bFaoxGTK
         kyRQ==
X-Gm-Message-State: AOAM532JfNprjFizwd5OxjlQAOpXnJxfe+IJcls/GmCItqg9gR656UiO
        1c+nu9tgDAs7DmyZAw8oFLB62WTF9z1G4DS3FqbjTCZjGxJiXY9Z7YtCqoA2rT168RQ/Q+rMg3J
        xL+/sgNktiUCt
X-Received: by 2002:a05:6000:23c:b0:1f0:2413:c860 with SMTP id l28-20020a056000023c00b001f02413c860mr3497187wrz.693.1646223684973;
        Wed, 02 Mar 2022 04:21:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuyfoi3FfJLlnHIjrh7ysE0NfjYpokz9Gq1WyY6xrtwGNI1X4vM6L2qrohfqs4gOwQRds7zA==
X-Received: by 2002:a05:6000:23c:b0:1f0:2413:c860 with SMTP id l28-20020a056000023c00b001f02413c860mr3497169wrz.693.1646223684711;
        Wed, 02 Mar 2022 04:21:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id q7-20020adfcd87000000b001e8a4f58a8csm15969078wrj.66.2022.03.02.04.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 04:21:24 -0800 (PST)
Message-ID: <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
Date:   Wed, 2 Mar 2022 13:21:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-2-oupton@google.com>
 <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
 <Yh5pYhDQbzWQOdIx@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh5pYhDQbzWQOdIx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 19:43, Oliver Upton wrote:
> Right, a 1-setting of '{load,clear} IA32_BNDCFGS' should really be the
> responsibility of userspace. My issue is that the commit message in
> commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when
> guest MPX disabled") suggests that userspace can expect these bits to be
> configured based on guest CPUID. Furthermore, before commit aedbaf4f6afd
> ("KVM: x86: Extract kvm_update_cpuid_runtime() from
> kvm_update_cpuid()"), if userspace clears these bits, KVM will continue
> to set them based on CPUID.
> 
> What is the userspace expectation here? If we are saying that changes to
> IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS after userspace writes these MSRs is a
> bug, then I agree aedbaf4f6afd is in fact a bugfix. But, the commit
> message in 5f76f6f5ff96 seems to indicate that userspace wants KVM to
> configure these bits based on guest CPUID.

Yes, but I think it's reasonable that userspace wants to override them. 
  It has to do that after KVM_SET_CPUID2, but that's okay too.

Paolo

