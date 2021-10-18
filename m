Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A374317AF
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 13:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhJRLqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 07:46:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230478AbhJRLqr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 07:46:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634557475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KeixeMV2EogBAUUjIMMzujFC6vH6Vam8STyg+YsaQ90=;
        b=ennZLZ2zbVuqbnU2WQcbpPwlOolFxXU3thLtbvn8IL9tEB4NJK7J+O58ekD8rKNrNNu2Of
        5fDjVO6m042ieOb3QhlHAxXLNZXLvB4RWB5hy0UHbLe7h7nW07NrLwjCHGcGZq0Y0FTETo
        USeApaqyQmUAZvE5XNz7zUz8D5IYo/U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-IZ6AZ-4NOgaE6woDaYVzWA-1; Mon, 18 Oct 2021 07:44:34 -0400
X-MC-Unique: IZ6AZ-4NOgaE6woDaYVzWA-1
Received: by mail-wr1-f69.google.com with SMTP id p12-20020adfc38c000000b00160d6a7e293so8705242wrf.18
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 04:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KeixeMV2EogBAUUjIMMzujFC6vH6Vam8STyg+YsaQ90=;
        b=RLIW0oU6U3NLjNbqVsr3mTEQrfn2O2I9bSgJWWxdNOZheXCesj9IAwfrpjUMSrJAM4
         XqsvIPazsAyUJz2CDCPjtBw2xRvr0cjglQhv106n1VMeIRSkjHjnSDH1Lm3JKKV7mCyp
         9Wjfo3RRJ41Pdi2dNZAfGImcwoII1hf5vM02oTBf9BMDmIdp3jjkjq2zzWheD1LstONM
         wDbcPhkZRCyQDXW5kJjxUlUe7w4Zxklf6//mz4D0CjyNecUjja9qU8npto3X0p3/BUSc
         h/wfXEubK4yDA0OmVWLC5Z1hWaFraiawjlm06Cunyko5Tuhfx53Fa0N6M97h6eLjHjnD
         qfPQ==
X-Gm-Message-State: AOAM533+/U4TGFmB52wFxIpMROcPPVJFBlJ7fFpYjyg4FB8/I3D405zq
        ZkrD7zX5u+sqF0EtPJkgV3vNUQ+VLUYJ7FEGtXLNdPucQKz0KCNRtRz/YixPq8//kKiF23ssSKA
        pX6QV3VnbDVNe
X-Received: by 2002:a1c:9d97:: with SMTP id g145mr29273141wme.78.1634557473027;
        Mon, 18 Oct 2021 04:44:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzM7xblvRzkieqyGQRoyyigfLr3YHi5vClYT5nTsuGDzx7Nn0wiXpFo+D+jMwR3Yhbu5vd0iw==
X-Received: by 2002:a1c:9d97:: with SMTP id g145mr29273114wme.78.1634557472776;
        Mon, 18 Oct 2021 04:44:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k6sm12708013wri.83.2021.10.18.04.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 04:44:32 -0700 (PDT)
Message-ID: <d23aa747-f962-fb5c-7ad7-9dc3277fe83e@redhat.com>
Date:   Mon, 18 Oct 2021 13:44:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH RFC] KVM: SVM: reduce guest MAXPHYADDR by one in case
 C-bit is a physical bit
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Matlack <dmatlack@google.com>,
        linux-kernel@vger.kernel.org
References: <20211015150524.2030966-1-vkuznets@redhat.com>
 <YWmdLPsa6qccxtEa@google.com>
 <eaddf15f13aa688c03d53831c2309a60957bb7f4.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <eaddf15f13aa688c03d53831c2309a60957bb7f4.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/21 09:54, Maxim Levitsky wrote:
> 
> I'll say, a hack to reduce it by 1 bit is still better that failing 
> tests, at least until AMD explains to us, about what is going on.

What's going on is documented in the thread at
https://yhbt.net/lore/all/4f46f3ab-60e4-3118-1438-10a1e17cd900@suse.com/:

> That doesn't really follow what Andrew gave us, namely:
> 
> 1) On parts with <40 bits, its fully hidden from software
>
> 2) Before Fam17h, it was always 12G just below 1T, even if there was
> more RAM above this location
>
> 3) On Fam17h and later, it is variable based on SME, and is either
> just below 2^48 (no encryption) or 2^43 (encryption)

If you can use this information to implement the fix, that'd be very 
nice.  I didn't apply the hackish fix because I wanted to test it on a 
SME-enabled box.

Paolo

