Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE28B7A6DE
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 13:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfG3L0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 07:26:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35280 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfG3L0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 07:26:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so56279135wmg.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 04:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zRulNL5qCAi/81YynxGrimpN6FxyJ33F7yQYkhCyZlk=;
        b=EUvq7T8sAtr86oxLuRH+3ZqqG3DGuxOkuMIyyHeLdcw+lRld4l3vC306VF5gHb1E+3
         P40LEJocVTsw2M30J6M3BH80UtK87sijQ/VRBO3KsJXMyayS6WhQfOrSocvweQZu+T/d
         gggHYARZfBHYXjfaGp05WF8HJ624q16vO1RlyDHx8XV941a1CPOYJRMI4wm2f/8K8Kkj
         mabr+/EPOUaCs0fqH3hDNpB4m26wtvpbsTGx0/4RPe0phtm44qXtv0dFJdVvXZMMwfck
         9vd+fvcHZ0uoLrVdtd1amjmD0TIjx1wmqTIyJVvS/A8H+wNo2WAC3cnelyUZS6OGjzQK
         9Sog==
X-Gm-Message-State: APjAAAWXBT01jemXIcPdiRUvKIcKKyrSgFjEYPStAAlYtkCt8n/+Rfug
        UQAiAoKKBnBmtQRgpJmWVysJUg==
X-Google-Smtp-Source: APXvYqxo5UHLG3tyCvJ9QKdkC6ZVQFG9DiXwMjRxFm5zOjg0AFUbgZKXZO3dtvVP5tdG02WNBFwMlQ==
X-Received: by 2002:a1c:e009:: with SMTP id x9mr103306392wmg.5.1564486001151;
        Tue, 30 Jul 2019 04:26:41 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 4sm146590471wro.78.2019.07.30.04.26.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 04:26:40 -0700 (PDT)
Subject: Re: [RFC PATCH 13/16] RISC-V: KVM: Add timer functionality
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <20190729115544.17895-14-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <abedb067-b91f-8821-9bce-d27f6c4efdee@redhat.com>
Date:   Tue, 30 Jul 2019 13:26:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729115544.17895-14-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 13:57, Anup Patel wrote:
> +	if (delta_ns > VCPU_TIMER_PROGRAM_THRESHOLD_NS) {
> +		hrtimer_start(&t->hrt, ktime_add_ns(ktime_get(), delta_ns),

I think the guest would prefer if you saved the time before enabling
interrupts on the host, and use that here instead of ktime_get().
Otherwise the timer could be delayed arbitrarily by host interrupts.

(Because the RISC-V SBI timer is relative only---which is
unfortunate---guests will already pay a latency price due to the extra
cost of the SBI call compared to a bare metal implementation.  Sooner or
later you may want to implement something like x86's heuristic to
advance the timer deadline by a few hundred nanoseconds; perhaps add a
TODO now).

Paolo

> +				HRTIMER_MODE_ABS);
> +		t->is_set = true;
> +	} else
> +		kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_S_TIMER);
> +
