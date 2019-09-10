Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F2BAED4C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731393AbfIJOlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:41:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbfIJOlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:41:02 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 66A2FC04B940
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 14:41:02 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id c188so1435199wmd.9
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 07:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cJrLJhg77HdXITw7W6jWRWxQLFrh8FY3brtGhslg/yU=;
        b=TkviZXdBbfTAZ8YTVa1sFqOkjUp7vt4WMxCA6vxwzHJowm0eUyPc1sGFH+a72kD1pw
         4cIQ4dH30XCh+XOl1EtRtF0EJjAFBYu7TI0dpnUS1BuB+RiTXPgEYM9YMua6MCJVkoUW
         nrWzOMe7YrBBXEB4gRQnoqMsSfYBzWdkg4b5j1/T7dYJ2LkxOuqV7qaJTCxhnp+nxZVg
         t9HgqwBaej7U7uAGTKG4X1rkQlWIaHXxJBdMxgvQdsz8hYj+loCNhhP/69i9x1AWZs+4
         rVBoBWcYHsaQLX7/k0Lgm6miHy6Pjps53mfF3sKSSaWk76tZC6UV9PbysMfAja/3d/x/
         SZBg==
X-Gm-Message-State: APjAAAXdiuQxLMpyfcwnYcHqSpVzQtWsY+asWF5DKHKbTTd7GSwo9ZXd
        MejsNVchvst0fw5K5gkNZYmV//voe5/TNetuSCH4TWZrmr52YpkXKN8HV0XHV4ZbaLLR51dRJlM
        WboofLqvrZr+L
X-Received: by 2002:adf:fc05:: with SMTP id i5mr21459279wrr.134.1568126461120;
        Tue, 10 Sep 2019 07:41:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy7r22ycaiyIAOgheL4k6r1Mn72f2EGSPwZkUVY5WoV3EEGyJTIURDBq8k7n4jtyP6PoMsfpw==
X-Received: by 2002:adf:fc05:: with SMTP id i5mr21459245wrr.134.1568126460876;
        Tue, 10 Sep 2019 07:41:00 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id i9sm3720112wmf.14.2019.09.10.07.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 07:41:00 -0700 (PDT)
Subject: Re: [PATCH v3] KVM: x86: Disable posted interrupts for odd IRQs
To:     Christoph Hellwig <hch@infradead.org>,
        Alexander Graf <graf@amazon.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
References: <20190905125818.22395-1-graf@amazon.com>
 <20190910061554.GD10968@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1cc51fa5-ee1c-88a4-c935-c293c947f240@redhat.com>
Date:   Tue, 10 Sep 2019 16:40:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190910061554.GD10968@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/19 08:15, Christoph Hellwig wrote:
> And what about even ones? :)
> 
> Sorry, just joking, but the "odd" qualifier here looks a little weird,
> maybe something like "non-standard develiry modes" might make sense
> here.

Indeed, folded this into the commit message.  Thanks Christoph.

Alex, I queued the patch but I don't think I'll include it in 5.3.

Paolo

