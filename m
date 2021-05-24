Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7ED38E895
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 16:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhEXOWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 10:22:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25885 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232882AbhEXOWW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 10:22:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621866054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qWpWyl7mO1aSiMmeBum3aQQBzcxHnspJtGSp5kl6VF0=;
        b=KjfYsW8zkjtiOQSqBpoTQ497BHTdrLYOuvHC8iR4XNeK8oSkoC+q6aohJt81/3ZLI3/FE2
        jMDSQB4hT4pTHWbCt9uIaFn1U/JSDgq7ARPqP3MnTWqFAgc31k91xAlZ3KNDjQedN1Gqlt
        5DJACotZhnpfh5n/i+1OuowKmu7oPAg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-Pg_bssxlMoyQdRIzWDL2gw-1; Mon, 24 May 2021 10:20:52 -0400
X-MC-Unique: Pg_bssxlMoyQdRIzWDL2gw-1
Received: by mail-ed1-f72.google.com with SMTP id q7-20020aa7cc070000b029038f59dab1c5so2227093edt.23
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 07:20:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qWpWyl7mO1aSiMmeBum3aQQBzcxHnspJtGSp5kl6VF0=;
        b=Q/lIbIUOcpVkN0hta9C2Yp1lVIm/2VAnubsH5n4eZbtDoPYoP6v2GLjqwyJm83ZVtG
         79G2SX1MuUnmWbBE/oVTEn2LJL0Lp4LQbxhgMMaPwQZLW2DEtY+hWsRfwVKmgDCCQMrt
         aWO49WoYaYPQR+gCkkKy7qF5jQRfdFonGf4QOfA43sAJgkKP4M6fI+S0eGEbkuxGihIA
         Nr29bqC5tPOcdaJSevzIpTkB4BJfspLZE3ejgXKERGjAapslbzXYfPvSC5AdE1wclw8E
         bmVPBiDGp35ze0WcYQ3zlIoZ6JUsJ0KLhxik0/O75YVotFKpRM2f6bIm/1NJGZXDvOIW
         fC7A==
X-Gm-Message-State: AOAM531h69gE7ki2uMQUztEsMIGsJYNn16zAkDjeKyXNZM4lhTF1+zRq
        k6a8N1Kl/TrR+21HhjElCm7IsQb9qRElEzrCglGCX282krALaPgyIz3pIvXn6J0lRM8iUG6qk1y
        0nNmuYh2PacaP
X-Received: by 2002:a05:6402:684:: with SMTP id f4mr26871636edy.25.1621866051177;
        Mon, 24 May 2021 07:20:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVMF/rSGJrKkgc3jpZ8C8SKICYwMG5+WivdEC6ffRp3YwXe7GwutziyX9f29kyS8loVnQnCg==
X-Received: by 2002:a05:6402:684:: with SMTP id f4mr26871610edy.25.1621866051047;
        Mon, 24 May 2021 07:20:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p25sm7893946eja.35.2021.05.24.07.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 07:20:50 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with
 protected state
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
 <87pmxg73h7.fsf@vitty.brq.redhat.com>
 <a947ee05-4205-fb3d-a1e6-f5df7275014e@amd.com>
 <87tums8cn0.fsf@vitty.brq.redhat.com>
 <211d5285-e209-b9ef-3099-8da646051661@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c6864982-b30a-29b5-9a10-3cfdd331057e@redhat.com>
Date:   Mon, 24 May 2021 16:20:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <211d5285-e209-b9ef-3099-8da646051661@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/21 15:58, Tom Lendacky wrote:
>> Would it hurt if we just move 'vcpu->arch.guest_state_protected' check
>> to is_64_bit_mode() itself? It seems to be too easy to miss this
>> peculiar detail about SEV in review if new is_64_bit_mode() users are to
>> be added.
> I thought about that, but wondered if is_64_bit_mode() was to be used in
> other places in the future, if it would be a concern. I think it would be
> safe since anyone adding it to a new section of code is likely to look at
> what that function is doing first.
> 
> I'm ok with this. Paolo, I know you already queued this, but would you
> prefer moving the check into is_64_bit_mode()?

Let's introduce a new wrapper is_64_bit_hypercall, and add a 
WARN_ON_ONCE(vcpu->arch.guest_state_protected) to is_64_bit_mode.

Paolo

