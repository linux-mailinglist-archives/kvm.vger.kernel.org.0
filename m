Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8FAD7A94D
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 15:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbfG3NTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 09:19:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43922 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729351AbfG3NTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 09:19:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so65731287wru.10
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 06:18:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4T+N5rDWzyUqBCwwe6XKAKGnNik0HfsnLC/oOFv9Yvo=;
        b=s/BpIKT5TK45B+o/yHm2zZDIXPhP7PP2sUutAQaC55tHJDfZ+6myp9m6cibhRuB4PN
         Z0ekhh/ulgOK4a7dLbgzbXZZpmUAazlPOa8K09ArQO01IuTbilwgIzrb53xlGhU22hOM
         GJrRVlRf3R8T5jU4Z5RCxWuY2op00dIgwNVNSwgtv8aeY6TONgqS7eu+DnFxe8uiFPwT
         DQ3zFlJOJuIzhXP8nmZukW9c2GPN8lEdigOCNJHg893be2Gp0Gm5YCLcQ57gw6aJ+Cnw
         yHGLPfeaHxxc59ro7ppgbhceeGbvQlshx2p3lZArJQkRr6oUHl3Zy0xErW89qUud1riM
         Y75w==
X-Gm-Message-State: APjAAAVrC8XlyksN6IqqqSh4Kc2fI78Xv4JXkS0oFsH9sYrYTr+Cp8k5
        ms8nvZOt/nWC4ATjbXsSfoRfvw==
X-Google-Smtp-Source: APXvYqxH5jMUMQZRjTvBj61yj3IX+c8QpeNllhHi+YlYGKDbWnFDORisbT652uSyoJl02SGXzGJpZw==
X-Received: by 2002:a5d:4212:: with SMTP id n18mr5731078wrq.261.1564492738582;
        Tue, 30 Jul 2019 06:18:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id a8sm51401838wma.31.2019.07.30.06.18.56
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 06:18:57 -0700 (PDT)
Subject: Re: [RFC PATCH 05/16] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
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
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <20190729115544.17895-6-anup.patel@wdc.com>
 <9f9d09e5-49bc-f8e3-cfe1-bd5221e3b683@redhat.com>
 <CAAhSdy3JZVEEnPnssALaxvCsyznF=rt=7-d5J_OgQEJv6cPhxQ@mail.gmail.com>
 <66c4e468-7a69-31e7-778b-228908f0e737@redhat.com>
 <CAAhSdy3b-o6y1fsYi1iQcCN=9ZuC98TLCqjHCYAzOCx+N+_89w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <828f01a9-2f11-34b6-7753-dc8fa7aa0d18@redhat.com>
Date:   Tue, 30 Jul 2019 15:18:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy3b-o6y1fsYi1iQcCN=9ZuC98TLCqjHCYAzOCx+N+_89w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 14:45, Anup Patel wrote:
> Here's some text from RISC-V spec regarding SIP CSR:
> "software interrupt-pending (SSIP) bit in the sip register. A pending
> supervisor-level software interrupt can be cleared by writing 0 to the SSIP bit
> in sip. Supervisor-level software interrupts are disabled when the SSIE bit in
> the sie register is clear."
> 
> Without RISC-V hypervisor extension, the SIP is essentially a restricted
> view of MIP CSR. Also as-per above, S-mode SW can only write 0 to SSIP
> bit in SIP CSR whereas it can only be set by M-mode SW or some HW
> mechanism (such as S-mode CLINT).

But that's not what the spec says.  It just says (just before the
sentence you quoted):

   A supervisor-level software interrupt is triggered on the current
   hart by writing 1 to its supervisor software interrupt-pending (SSIP)
   bit in the sip register.

and it's not written anywhere that S-mode SW cannot write 1.  In fact
that text is even under sip, not under mip, so IMO there's no doubt that
S-mode SW _can_ write 1, and the hypervisor must operate accordingly.

In fact I'm sure that if Windows were ever ported to RISC-V, it would be
very happy to use that feature.  On x86, Intel even accelerated it
specifically for Microsoft. :)

Paolo
