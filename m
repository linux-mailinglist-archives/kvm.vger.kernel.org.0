Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B84743699F
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbhJURry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:47:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232391AbhJURrF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 13:47:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634838289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1EZ4owsWiZMNv5daeu40VXnvf5cZ9TsE7Nppy1IiXJY=;
        b=RqSUmF1rc61xqv7ncKru/LGqKV68Rg6iKCGzJ19Uo4wISbTbzdYOeUr1Bt46fl/GHZqOjS
        svIUpmOF7LjqncDvmAPp/KypJ6hA6Fchl9lUuUNhgqkMpyf1nPMDAvUyZGKBlgaIN4pIUl
        dLKOzyoqinjqGjfJ+GsI79ZKq+G9iDY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-byg_3onrMWKUDjl6XCLq5w-1; Thu, 21 Oct 2021 13:44:48 -0400
X-MC-Unique: byg_3onrMWKUDjl6XCLq5w-1
Received: by mail-ed1-f71.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso1088851edj.20
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:44:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1EZ4owsWiZMNv5daeu40VXnvf5cZ9TsE7Nppy1IiXJY=;
        b=UCmC2GVhZmhE5cQde3V+yqsLxVqAqNNwXvMPpXx5xRKisjeaKqiM+XoLq6M5zaWNJr
         cyHVKDywG42idJjHSiCAOZZ6OqLw/Vu4T1N9Q/1iGQ+Q8fEoH8WJ0fnURk4HBq2y9KJk
         GJZ7TRvzK/onEuiHLJkV7Q05+ty3CJZQmtyHdq+G85KWEMoMoVW2lWa1glPH8KahC1gc
         xR9hTfvaDRp6kmqXdU3hf7yJXPI6AUVqz/SXKAP60HQdH8QwzmitIckiX4cbvTuTfh6F
         o3/Ot9IE0Zl65Z1MfWGQP/QhK0LetiTWP6Fp7n7qga5G2ApdinA9xkU2MQoIY84CRe0l
         MBzg==
X-Gm-Message-State: AOAM531m3uIZzhz6jnA7QhkczcL7H2KDowtYfAyd3ITYWvvOjZw/wGbg
        Kj7dpB/bLnObOEdYpZEy45c53sjsMM8bkxf5jq0HlNxqxQzYRu0BXShEQE/mkRDAYKZ3TeRAiLb
        +RaWkMU2zdCSw
X-Received: by 2002:a17:906:c18c:: with SMTP id g12mr8997378ejz.458.1634838286726;
        Thu, 21 Oct 2021 10:44:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzmn6F9sw1Bbc/Myp0RL4CO+uvgDZnkcI99MTmxM0wkTKs6gjRYNBkVSPdMzU3BAfpHd/8+Q==
X-Received: by 2002:a17:906:c18c:: with SMTP id g12mr8997336ejz.458.1634838286507;
        Thu, 21 Oct 2021 10:44:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id p26sm3115926edu.57.2021.10.21.10.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 10:44:45 -0700 (PDT)
Message-ID: <7d97ff98-96c5-7699-7b32-36651ebf173d@redhat.com>
Date:   Thu, 21 Oct 2021 19:44:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 3/4] KVM: X86: Use smp_rmb() to pair with smp_wmb() in
 mmu_try_to_unsync_pages()
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
 <20211019110154.4091-4-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211019110154.4091-4-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/21 13:01, Lai Jiangshan wrote:
> From: Lai Jiangshan<laijs@linux.alibaba.com>
> 
> The commit 578e1c4db2213 ("kvm: x86: Avoid taking MMU lock in
> kvm_mmu_sync_roots if no sync is needed") added smp_wmb() in
> mmu_try_to_unsync_pages(), but the corresponding smp_load_acquire()
> isn't used on the load of SPTE.W which is impossible since the load of
> SPTE.W is performed in the CPU's pagetable walking.
> 
> This patch changes to use smp_rmb() instead.  This patch fixes nothing
> but just comments since smp_rmb() is NOP and compiler barrier() is not
> required since the load of SPTE.W is before VMEXIT.

I think that even implicit loads during pagetable walking obey read-read 
ordering on x86, but this is clearer and it is necessary for patch 4.

Paolo

