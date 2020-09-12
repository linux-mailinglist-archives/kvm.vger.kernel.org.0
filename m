Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CD7267B6E
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 18:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgILQdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 12:33:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37081 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725854AbgILQcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Sep 2020 12:32:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599928364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EK4xJPsh4BhceCSwLT4jgkMuWU9xmiKAZ+DxkU1RVGg=;
        b=bojpxdleevSKg1iRoQ+8sODe6Vqe6wIf24ZORDAX61jb9eOQ2ccCtPbmSP63FOkDZV2/M8
        7xB07R45LNOT44twYcMIYuP4nONnn1MbdLkWOv58Yf0eCM7BSzVYt7WRuVfUlRaZqMxGk5
        sPv43c8sPLHkM8U12GjNDLq1mEj/FyU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-4wDTwQDRP_upkztReiL2gw-1; Sat, 12 Sep 2020 12:32:41 -0400
X-MC-Unique: 4wDTwQDRP_upkztReiL2gw-1
Received: by mail-wm1-f71.google.com with SMTP id d22so2506283wmd.6
        for <kvm@vger.kernel.org>; Sat, 12 Sep 2020 09:32:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EK4xJPsh4BhceCSwLT4jgkMuWU9xmiKAZ+DxkU1RVGg=;
        b=mJr5RgDciFMAsjE8xJts8qr6X2ZjCvLCIEBYc73SALdrMhR34h7rHCbKICOzJ0PNKk
         /M298tVm1MHm8tZhtUqZDVZsvZ2I1ojUhkAhEVRjaTIlU0G/PfDZOh5x5M3GOMWgdx/h
         Mfaow+mm/9uloUOl8J6YrNznXP1eegoy7VuVcGObGNpUxQZXgxABxDLhbulg/HNNPQMH
         rOHu1jtVZcB2Pqw4Rhkok/+T/E9icE+50vHGG6CkdmdqFiMwk2iEwJAV74a+yx/HvWAI
         XW74ThxDK7l27WH6HAb2nkmBGjCcg7tt0fpNodTYz+nyAtkFGmHPfo2U9BMcsP//5va3
         0qyg==
X-Gm-Message-State: AOAM533PpLFVBNjb7/8mpT/XIu3Kw0ftsosLTNMvw4ucB2UPywq8Xl4Y
        FzP1tSVaOVSuqjsyVwF4ealTkfI/Rv6HscE/vCnhPgfRvyB7foB/JeEFGINcIU+uDYand6rJTQU
        540GYICYs2tYB
X-Received: by 2002:a7b:c40b:: with SMTP id k11mr7348207wmi.135.1599928359713;
        Sat, 12 Sep 2020 09:32:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQ8ErPq1soTPFPFNDyx/hnkdzJNTqFCkhMamm4NqW9NBzAIUIa8XXAsxSqT2QvCl9HSsbA0A==
X-Received: by 2002:a7b:c40b:: with SMTP id k11mr7348183wmi.135.1599928359503;
        Sat, 12 Sep 2020 09:32:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9fd9:16f2:2095:52d7? ([2001:b07:6468:f312:9fd9:16f2:2095:52d7])
        by smtp.gmail.com with ESMTPSA id d6sm11141635wrq.67.2020.09.12.09.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2020 09:32:38 -0700 (PDT)
Subject: Re: [PATCH v3 8/8] KVM: nSVM: implement ondemand allocation of the
 nested state
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20200827171145.374620-1-mlevitsk@redhat.com>
 <20200827171145.374620-9-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <58f9d2c1-0739-5b72-ee21-285474666c58@redhat.com>
Date:   Sat, 12 Sep 2020 18:32:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827171145.374620-9-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/20 19:11, Maxim Levitsky wrote:
> +	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!hsave_page)
> +		goto error;
> +

I think an error here should be just an internal error userspace exit,
or a -ENOMEM from KVM_RUN; not a #GP in the guest[1].  However, that's
difficult to plug into KVM.  Can you instead allocate nested state if
KVM_SET_CPUID2 sets the SVM bit?  Returning -ENOMEM from KVM_SET_CPUID2
is more likely to be something that userspace copes with.

I queued patches 1-5, and 7 for 5.9-rc.

Paolo

[1] Though in practice an order 0 allocation will never fail

