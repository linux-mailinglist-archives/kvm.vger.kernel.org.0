Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA033648AF
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbhDSQ7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:59:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239244AbhDSQ7v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 12:59:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618851561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2yCOAsF2W6pdJQCZiN/BRe+VSsYLOg75hHhxWgADKE=;
        b=iFXr4Sc+ZSe7A+BRT5uvEsxowyCH7S43ZcSfj1SmnHYs3LFFesZdQZ9i/GPuqi6ESS0HT5
        IjtrqYJaI4SQsd8NpySV1PEgkeMUFU/AsSknUuHuG64YgV+712RV0yC2hFALGwPAWpGvKW
        q0XPN/51fDcL4dOWAxxPHu43bZsZF8s=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-C6wsNs8FOBSRVbN265d4qg-1; Mon, 19 Apr 2021 12:59:17 -0400
X-MC-Unique: C6wsNs8FOBSRVbN265d4qg-1
Received: by mail-ed1-f72.google.com with SMTP id bf25-20020a0564021a59b0290385169cebf8so4133587edb.8
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p2yCOAsF2W6pdJQCZiN/BRe+VSsYLOg75hHhxWgADKE=;
        b=X83UPP3oKAmw/LLB6bvUFxIlpR0hZsuqV9VvTJo/kWmznu+xN5rLq08yi48u41awlz
         0sjKiWWD/MBN1Ejf5yH189zJDYBkixFV/7tJd9YZD+03rx5vBr7ohr8uCNnyitSKS2of
         /lXEamNqnLMv3UY22rlMusl8o3I6ipyFltFwrungZ8b4aweO78m29zMcb3KEWS2Vlr3/
         pWQapDQP4o1R7ro+t6q/RaM2UW7n0sQSRXRJb9e0x8Ldza5q+DNnLrMmtP/84Hxzvoei
         sckeqzodDN/dtIS5zGDXAHHgTBak2B3iZQ393SnxX5LM2Epg78Ai+khiizMwNzB25nIR
         pt+Q==
X-Gm-Message-State: AOAM530epBs1xyP0zx+NC1zTbmfhHTaokcCwgiXNReWhevqA5cALjpKd
        T/IQ/+7mVLbQyqOLgDt1BauaEDW81lq30BkqvOfknevEk/d4GWkLiNFCnZmX5l8UZcpUwJo+PFu
        p2wEUX1S1CAD3
X-Received: by 2002:aa7:d284:: with SMTP id w4mr19343353edq.40.1618851555826;
        Mon, 19 Apr 2021 09:59:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyFchJESgw+7UFFi7gMjT2GXURWU1V3gPdrMAkm5hmsQSjuAtxEZt7cFqUHIrt8QbpCDwW0g==
X-Received: by 2002:aa7:d284:: with SMTP id w4mr19343332edq.40.1618851555663;
        Mon, 19 Apr 2021 09:59:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n15sm4006185eje.118.2021.04.19.09.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 09:59:15 -0700 (PDT)
Subject: Re: [PATCH] KVM: Boost vCPU candidiate in user mode which is
 delivering interrupt
To:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1618542490-14756-1-git-send-email-wanpengli@tencent.com>
 <9c49c6ff-d896-e6a5-c051-b6707f6ec58a@redhat.com>
 <CANRm+Cy-xmDRQoUfOYm+GGvWiS+qC_sBjyZmcLykbKqTF2YDxQ@mail.gmail.com>
 <YH2wnl05UBqVhcHr@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c1909fa3-61f3-de6b-1aa1-8bc36285e1e4@redhat.com>
Date:   Mon, 19 Apr 2021 18:59:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YH2wnl05UBqVhcHr@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/04/21 18:32, Sean Christopherson wrote:
> If false positives are a big concern, what about adding another pass to the loop
> and only yielding to usermode vCPUs with interrupts in the second full pass?
> I.e. give vCPUs that are already in kernel mode priority, and only yield to
> handle an interrupt if there are no vCPUs in kernel mode.
> 
> kvm_arch_dy_runnable() pulls in pv_unhalted, which seems like a good thing.

pv_unhalted won't help if you're waiting for a kernel spinlock though, 
would it?  Doing two passes (or looking for a "best" candidate that 
prefers kernel mode vCPUs to user mode vCPUs waiting for an interrupt) 
seems like the best choice overall.

Paolo

