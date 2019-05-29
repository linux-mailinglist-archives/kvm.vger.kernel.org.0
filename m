Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769242D349
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 03:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfE2B0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 21:26:39 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42973 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfE2B0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 21:26:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id l2so432672wrb.9
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 18:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rmRCqN5V69njNKzXqsufXyHQFr1ecAJaoY5I9r8Jg/A=;
        b=W+lq4R8lCZkozZenxFVIKWivD6ljFxUf4XUewK+CnEbQI9affXBzQNxomnOHcvjDFw
         VXbHbCyLIw7SZN4Mad89eUV2NIGZ94BGF5joo8OkfAXQo3lbTLn5kkTbserJlOM2bdY7
         YK29yvfZOOAIrs6aSz971m/OrE52tpLgpijHoHwCeh1lwkuqOgMv9F3i4ghVjRWzV6cz
         /Q4hiy+A0CJRfEAf7QANORE7M0ZBZlm7kC1wdwRtQ17K8ePVYz9m/MFP2a+iayoO386Z
         SbzvFrpnVq4nr9k0Yb90PyW/AZDHafdc4nA6EPZTNh/s4m+Yf+5GPLHOj7SYf3uxNTho
         8J/Q==
X-Gm-Message-State: APjAAAX/KPSV/KorYCePD4iSbkp8qdlSEofJTSiOGIdcUlgARVijxSoR
        jbeBmVxZxTw0IEI1pfpf6Cui1Q==
X-Google-Smtp-Source: APXvYqwX1usmVw6q1CDoi4OTK+z6UWAWXKZZFyXo6pMfhnLF9gUifvkPOsRu9b8SygmMeO8p8Yt+mQ==
X-Received: by 2002:adf:ba47:: with SMTP id t7mr18702012wrg.175.1559093197515;
        Tue, 28 May 2019 18:26:37 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id d26sm3816595wmb.4.2019.05.28.18.26.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 18:26:36 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] KVM: x86: add support for user wait instructions
To:     Tao Xu <tao3.xu@intel.com>, Wanpeng Li <kernellwp@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, jingqi.liu@intel.com
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-2-tao3.xu@intel.com>
 <20190527103003.GX2623@hirez.programming.kicks-ass.net>
 <43e2a62a-e992-2138-f038-1e4b2fb79ad1@intel.com>
 <CANRm+CwnJoj0EwWoFC44SXVUTLdE+iFGovaMr4Yf=OzbaW36sA@mail.gmail.com>
 <072dd34e-0361-5a06-4d0b-d04e8150a3bb@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f1d739ba-8499-1f41-5515-c53c6dd7f3d2@redhat.com>
Date:   Wed, 29 May 2019 03:26:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <072dd34e-0361-5a06-4d0b-d04e8150a3bb@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/19 09:19, Tao Xu wrote:
> 
> Thank you! This information really helped me. After I read the code in
> KVM/QEMU, I was wondering that with qemu command-line "-cpu
> host,+kvm-hint-dedicated", then in KVM,
> "kvm_hint_has_feature(KVM_HINTS_DEDICATED)" will be true, am I right?

Yes, but it doesn't matter for this patch series.

Paolo
