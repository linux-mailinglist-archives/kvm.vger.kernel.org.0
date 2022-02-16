Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237694B81EE
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 08:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiBPHsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 02:48:06 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiBPHsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 02:48:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E5FF1E8C;
        Tue, 15 Feb 2022 23:47:47 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id w1so1382588plb.6;
        Tue, 15 Feb 2022 23:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JNZGxYeAs+ebgnSneE63ZkZJqPvz5hHBdDJ16ah7/no=;
        b=g0pxtZ/LcPE/VkC8NIHWOab7GsA5PlzOOmyV0w7a3vIHjWyb+39GnPx/hDjBkDBJv1
         oCq9SFr8D3NiXQ+XXjsuY3ut8UXvHUcVG7XSWrugbzw3z+qiEFEGzsf4m32fsVLFMsao
         IbPmYF7IL0c0bhrK6M+keI8w4/FYNfbJf+t2bkwkoZ67JsOO0AYezhuD3JEMNnaWqJ6O
         DdiCG1lItb583sciYzG00ZcoQcR2IwdtKUB04Hk0GWNlGYOo8DcrM0pLF/NnVvqZuDj2
         NmlM6UKM1H5tMErGp3bYHH+6P9ENkBrwkbAQB9fhTuBrC5ORqN+QvraPPAWzfY92GTl4
         VTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JNZGxYeAs+ebgnSneE63ZkZJqPvz5hHBdDJ16ah7/no=;
        b=DrotAgNwdpxwlidpHxREdo7sLweiXdyj8xPB3uZsA2FN1h/82Rrq7opQhL5/J2H+2D
         NIOD3WMNdUFZPAqzkZs6EjAZv8aEAqM9qPfc7BhzwgIS+v0ZSF4qGH2VoV69PnLSrSU2
         pZ3DdLGompUX3Z5bwKKeJsjqHp4uxkQBdVec2ghjdA9YjIph1agN/ukxtLpGaTwScAJn
         deRAcqrAMJtrR2JuY3URYizjsmVYuw59nzpoD27aX1J0oljK7p0RvbRocGf7H+3yhLbD
         67+wFZ8EulIRiftBJt7o/VPr+hw52BRUdsKnIHQNJpK+eBXR0QqvDnSv3NmK7ah3ySrE
         quug==
X-Gm-Message-State: AOAM532HQMfwvISpHebOuaY+06Kyx7hAvBSMBZtuvOiSOuxDdhciDLXF
        HhPGFVSz3RsbkNhhQsOYPPrj8/PHJSt7gQac
X-Google-Smtp-Source: ABdhPJzJDV20aZH2aZdkxUCNUDkxJ7owWjX/WIshNLFlpi4S0dP/BWhdLksIrzEUf6K5EWhLO3YLKA==
X-Received: by 2002:a17:902:f082:b0:14e:e477:5125 with SMTP id p2-20020a170902f08200b0014ee4775125mr1396673pla.104.1644997662542;
        Tue, 15 Feb 2022 23:47:42 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id p27sm6704232pfh.98.2022.02.15.23.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 23:47:42 -0800 (PST)
Message-ID: <dc14c98c-e35a-95c0-83dd-13b5f7cffc03@gmail.com>
Date:   Wed, 16 Feb 2022 15:47:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH] KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln
 register
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211118130320.95997-1-likexu@tencent.com>
 <CALMp9eTONaviuz-NnPUP2=MEOb8ZBkZ7u_ZQBWBUne-i6cRUkA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eTONaviuz-NnPUP2=MEOb8ZBkZ7u_ZQBWBUne-i6cRUkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/2022 4:39 pm, Jim Mattson wrote:
>> -       pmu->reserved_bits = 0xffffffff00200000ull;
>> +       pmu->reserved_bits = 0xfffffff000280000ull;
> Bits 40 and 41 are guest mode and host mode. They cannot be reserved
> if the guest supports nested SVM.
> 

Indeed, we need (some hands) to do more pmu tests on nested SVM.
