Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8B34D2F99
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 14:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbiCINBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 08:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiCINBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 08:01:11 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B51171ED7;
        Wed,  9 Mar 2022 05:00:08 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id c20so2711721edr.8;
        Wed, 09 Mar 2022 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hlZVxTy+86SbOAVLGCYTSaw6Wf0zgBIqfORipJxlDgE=;
        b=mZTbq6hFSrBOapvcUwha/bkyRPZS9a7kTqxYN4Kl9oOYfdpNiRuc8kBxyI+fjaCwsh
         eBTca8o/IZZ1ZvpMtC0fC61BsCMIrDBslZKsExYKwBkl8sIXS8F/DoMKtvikvIZ8ywkj
         4z1gOEn2r8txByucnTivZ5AUpxa98iBYHfVGCNVfsh/3OP7Pwq4/CHk1m38xboH0M4aA
         R/9cl2H13RpaDTFb+VgDknPKscyT7dQRUXwcf6Q2Bs0ZtZQA9VRP8GMo3Xb+tkaDFfYo
         IJ+6BNTXSZIPClla7NDMDzal5JQfQ3i/UskeptOsvL7rGLtXi9NLxJIGNF0lfPtTKtik
         q9XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hlZVxTy+86SbOAVLGCYTSaw6Wf0zgBIqfORipJxlDgE=;
        b=7Gf0heVgvYlLsdgMQ3WTq4RUqoUPnlP9LDtMsXqb8YzC7JGyn3PGl65v4uWZvjqcZK
         zfQn/qJug/2ddoFBqc0CvY5yktzo/s8ZRGXzgQo30MmYB3nk6XhvWvL1M5eR/k+DxT7h
         0D+WRjSryXXyrUjJWRA6Wx75lYHolkpCWz2vV266+yUjNqBl6saur1yF4Ua6LlbGZRLN
         F0wriRg5qnerTSzI+yCG1NTZeDMw3z+MeqGdZ4E+IknltEOJ6eS/A1Psg/nbh8ERKedu
         BY//yeXB3hvtS1iMCK/T2lKOyT0Q3C2SY5GiB8TFR+80cEteBn+5r3/dMePode0pf/g7
         H83Q==
X-Gm-Message-State: AOAM533By1rdNqmwuHYqe9tslarx3Jg0f/tSS/lCVcJBxPrJb9klxy+l
        a/w5Z2//wzn9ZW2YBEhE87c=
X-Google-Smtp-Source: ABdhPJzDWHNKtbKkLVRUCZyZhiPbrtYHK5xO1sygw3PqigE5Y7v0wRiEXkel3ULFlN/xLIQI4SgyOw==
X-Received: by 2002:aa7:d1c8:0:b0:415:c61a:8ec8 with SMTP id g8-20020aa7d1c8000000b00415c61a8ec8mr21076345edp.390.1646830807407;
        Wed, 09 Mar 2022 05:00:07 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id p4-20020a50d884000000b004128cf5fe2asm790079edj.79.2022.03.09.05.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 05:00:06 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e38f0d14-419d-7b3d-4ce4-bd37200ba232@redhat.com>
Date:   Wed, 9 Mar 2022 14:00:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 1/7] KVM: x86: nSVM: correctly virtualize LBR msrs when
 L2 is running
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
 <20220301143650.143749-2-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301143650.143749-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 15:36, Maxim Levitsky wrote:
> +void svm_copy_lbrs(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
> +{
> +	to_vmcb->save.dbgctl		= from_vmcb->save.dbgctl;
> +	to_vmcb->save.br_from		= from_vmcb->save.br_from;
> +	to_vmcb->save.br_to		= from_vmcb->save.br_to;
> +	to_vmcb->save.last_excp_from	= from_vmcb->save.last_excp_from;
> +	to_vmcb->save.last_excp_to	= from_vmcb->save.last_excp_to;
> +
> +	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
> +}
> +

I think "struct vmcb *to_vmcb, struct vmcb *from_vmcb" is more common 
(e.g. svm_copy_vmrun_state, svm_copy_vmloadsave_state).

Paolo
