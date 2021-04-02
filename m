Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD0E3528E7
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 11:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbhDBJfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 05:35:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235031AbhDBJfn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Apr 2021 05:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617356141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pp7i/Rq4quxGmDckgflEr0uWdxRmtTCzqRhgMxNYmVI=;
        b=HVPYN/Au8+htd9ozI7CJcI37JaDjISuq37mWdtpqa/zOK42jRLGj6Si29q4dCiWzSg4mpJ
        agh6jnX3ATyM4dITwS+yl74k8eyMBbJRSuQmjNkz59f7zy0WsDAbRon3UxIgMNSXQTIPlR
        +XIDXvb4p63KP5XM53tgVgWNchAkt8o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-R_sIYBrONriTM2w6et0PsQ-1; Fri, 02 Apr 2021 05:35:39 -0400
X-MC-Unique: R_sIYBrONriTM2w6et0PsQ-1
Received: by mail-wm1-f70.google.com with SMTP id k132so2020696wma.1
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 02:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pp7i/Rq4quxGmDckgflEr0uWdxRmtTCzqRhgMxNYmVI=;
        b=C5y/AuGLGmE9wL08PGuAhOy93sIqqqjZILSp2lEPEjdN/Eb57itiSBupGPxtx5O5uM
         szC46Uhj8nGNIOIigH659ikE/230FjZG//SAI4Bz1tqnz8M5LdIlUOjjyMZu+xYSt2aP
         4HCsZoAXVVP8EJ6yqN8fyfgG2e4onBpBDCEPeeG3cfPKjlBiWxzUE8ftnVKoVwm/eGJA
         tyt1BxR90UryjtEBZ703sLROeAYNfCrs12X1iCT3HOrR01xge0igiRpnEXJUBwhLhT98
         icwkitVISnYT4Um8GS89hyp9+82tMJX2a0CfY3oUF8Iez3J3QaRqrAthGvyAsLKVd+Oa
         /0/A==
X-Gm-Message-State: AOAM533laMQNBB1GTSZ9FLz9l2vmpAqPQmE1KkABVhJfmoumIJzsm0DH
        AveczPxz1ZIgIv/kpbdXcZUNXBBygYJFPW7rQWo/SoQ82WEWHWfFmlQnHE5w9PDVHFhBJlkCtSo
        VHwo9Tz+Tj9CT
X-Received: by 2002:a05:6000:1a8a:: with SMTP id f10mr14051202wry.232.1617356138339;
        Fri, 02 Apr 2021 02:35:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3IM+fWBMIWWC0dXiX9SYqbGiBYCoQN4BHK3a4+s4pude6jmvmdlBwOmMacbQNHjcYC5pL4Q==
X-Received: by 2002:a05:6000:1a8a:: with SMTP id f10mr14051180wry.232.1617356138121;
        Fri, 02 Apr 2021 02:35:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id x6sm11605403wmj.32.2021.04.02.02.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 02:35:37 -0700 (PDT)
Subject: Re: [PATCH v2 07/10] KVM: Move MMU notifier's mmu_lock acquisition
 into common helper
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-8-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a30f556a-40b2-f703-f0ee-b985989ee4b7@redhat.com>
Date:   Fri, 2 Apr 2021 11:35:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210402005658.3024832-8-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/04/21 02:56, Sean Christopherson wrote:
> +		.handler	= (void *)kvm_null_fn,
> +		.on_lock	= kvm_dec_notifier_count,
> +		.flush_on_ret	= true,

Doesn't really matter since the handler is null, but I think it's 
cleaner to have false here.

Paolo

