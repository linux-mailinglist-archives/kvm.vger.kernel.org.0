Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB14F812D8
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 09:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfHEHOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 03:14:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46989 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfHEHOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 03:14:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so83234700wru.13
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 00:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xXNzFDoqWDF3bFjncF2L5fOVNU1OQ5j5piUBIWBmL0I=;
        b=EVRRFzZLiIia/XW6EDQFecM1zvc6R0Jt6uu8Bk/g8CFWyzIrMAhbRW6ywQjOF6zeTe
         O/3vaP9us8CRzDry9bUlHjwpD/2pBa0+z0p2pqJm7GOFipZ43/t47l8wWI/D+Ml4DWHs
         M1C4/FqnC1EZM475eCXqXxj6RBY+MlYzKFpfefaDwJy6Y7y0LTRiAZuJMCefzvBpdgb5
         FGUgLJRjsADO9OWV5m7vMMGfOkiF0m5Iytc8+6Wv140XXAK477CWdixTpYtZZp1y9lR7
         yf+idnqdpHpPoPjn2gIlwmXkUIaZaABKxuCj+fE++60+AZCWujpu+qAcRae+HW4lB6j6
         MX/w==
X-Gm-Message-State: APjAAAWJBgvtwN3hF7rkQcp5ZQusQKM8h4zaAprYXzFt7JbmZDsWu6i3
        mv8HcJMBpcofvZs6U6Q183TTEQ==
X-Google-Smtp-Source: APXvYqx5xT03XMyZCDbDAzBfRBcUMD25ISn8anlFxox0BiwSgKaltwaTiYWfWbosNFrA3zbrZE2mOg==
X-Received: by 2002:adf:eb49:: with SMTP id u9mr42305386wrn.215.1564989285989;
        Mon, 05 Aug 2019 00:14:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id g11sm79705061wrq.92.2019.08.05.00.14.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 00:14:45 -0700 (PDT)
Subject: Re: [RFC PATCH v2 10/19] RISC-V: KVM: Handle WFI exits for VCPU
To:     Anup Patel <anup@brainfault.org>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190802074620.115029-1-anup.patel@wdc.com>
 <20190802074620.115029-11-anup.patel@wdc.com>
 <5b966171-4d11-237d-5a43-dc881efb7d0a@redhat.com>
 <CAAhSdy0BVqagYTTnaG2hwsxxM51ZZ2QpJbZtQ21v__8UaXCOWA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <458f6b85-cdb2-5e6b-6730-4875f0e4cdba@redhat.com>
Date:   Mon, 5 Aug 2019 09:14:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy0BVqagYTTnaG2hwsxxM51ZZ2QpJbZtQ21v__8UaXCOWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/19 09:12, Anup Patel wrote:
> On Fri, Aug 2, 2019 at 2:33 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 02/08/19 09:47, Anup Patel wrote:
>>> +             if (!kvm_riscv_vcpu_has_interrupt(vcpu)) {
>>
>> This can be kvm_arch_vcpu_runnable instead, since kvm_vcpu_block will
>> check it anyway before sleeping.
> 
> I think we can skip this check here because kvm_vcpu_block() is
> checking it anyway. Agree ??

Yes, but it's quite a bit faster to do this outside the call.  There's a
bunch of setup before kvm_vcpu_block reaches that point, and it includes
mfences too once you add srcu_read_unlock/lock here.

Paolo
