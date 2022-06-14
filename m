Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C065154B051
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 14:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356864AbiFNMQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 08:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240713AbiFNMQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 08:16:04 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8195926D1;
        Tue, 14 Jun 2022 05:16:03 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x17so11023079wrg.6;
        Tue, 14 Jun 2022 05:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xWqP97KiAJDxiZtnK2LJEZYJu6FuzCpbf5J8wQ1l+A8=;
        b=LtgPRQh2VSOKYrwUorW93/iyjS2VmL687On0wH0Vzz5Lp1tJCeEC8nJYA0hVSu+CKd
         Ic4LgHppcJ8kB3NPc+iefq3EABGG3grvmIM1Se8RK2ac9IOLTXKg0WcRo87boB3fL7Ns
         wbie2Hn2e2hhuJ+J4Y+0AdpNSxsQPa6b97u8rn313apb348/opGB+SK3odI+oxp70p9+
         65gitqZwukfiiSIPJFWZ5EeInwg8EsXh+Blbv5EuupqNqLpjVT7ydilYgDKulwxTk/6o
         01jxOAHdPPwl0yhp+rvsE9kRMXtRXoD8qMrb3qodj+SngGWb10u32g5gYk8WV+lemUWI
         jJYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xWqP97KiAJDxiZtnK2LJEZYJu6FuzCpbf5J8wQ1l+A8=;
        b=U9di2qA2N3m46ehgaU+T7Wzr2dKzIRlaXpnFmCA3uLFyH/V3dDfX27m5dPdk02itzz
         abTMTNAL+/LMzgixEn/rJBw3vWRiQQgv+eJ9Dljc9MkZeLjG6KS0cf5V0phLiiOaOgHx
         dAwhwuFWEbJSUzor5ZPgIX02ram+Vtwz9lZeDnJ9iMZCK7Pqjcz6eaTWHGQ15m1kmmPO
         640/KGNwB4m5YxsWlqAo4OBMwBozmn+38AA8qik4SBQS9vD+D3+YriTpil0AANGwJDc+
         RpIvoNZFzchC9VVGumZmWx5IkuIXMoN2o7zXFSfamKcQM/ZxeTnc/A0rg62k2GVAe1aQ
         uG5A==
X-Gm-Message-State: AJIora94/4KyG4iRVzeYNX1LuBlyDIXsdEjS1c7xJjksxMGkzGINFCub
        lhOUJo8Szk1ZQT4OPwxAPpg=
X-Google-Smtp-Source: AGRyM1ug1V2kWjRUGXEmwuPwLLXsKwhPQsqu+35nXnftUg5oz8d5JDj0nITfFzJs7cuQBKb66LAjXg==
X-Received: by 2002:a5d:6da3:0:b0:211:3597:62b1 with SMTP id u3-20020a5d6da3000000b00211359762b1mr4732785wrs.660.1655208961985;
        Tue, 14 Jun 2022 05:16:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id u7-20020a05600c19c700b003973b9d0447sm21416366wmq.36.2022.06.14.05.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 05:16:01 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <75bdc7ee-bac5-ae05-dffb-cb749c9005e1@redhat.com>
Date:   Tue, 14 Jun 2022 14:16:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
Content-Language: en-US
To:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
 <YqgU2KfFCqawbTkW@anrayabh-desk>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YqgU2KfFCqawbTkW@anrayabh-desk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/14/22 06:55, Anirudh Rayabharam wrote:
>> That said, I think a better implementation of this patch is to just add
>> a version of evmcs_sanitize_exec_ctrls that takes a struct
>> nested_vmx_msrs *, and call it at the end of nested_vmx_setup_ctl_msrs like
>>
>> 	evmcs_sanitize_nested_vmx_vsrs(msrs);
> Sanitize at the end might not work because I see some cases in
> nested_vmx_setup_ctls_msrs() where we want to expose some things to L1
> even though the hardware doesn't support it.
> 

Yes, but these will never include eVMCS-unsupported features.

Paolo
