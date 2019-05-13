Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983C31B668
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 14:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbfEMMwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 08:52:19 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38665 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729572AbfEMMwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 08:52:19 -0400
Received: by mail-ot1-f68.google.com with SMTP id s19so11584994otq.5
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 05:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/h7YDU+P6MUHl6sVj0WLp+MoxyBRTBEzmvX8oGYQxPw=;
        b=HIV6Xgt0hlwXHD88KEhJy0PqeRJraTxBfxR2EpWUqn7bD/MeMl+qPLfovJYIfQlXUH
         BKJMP7+97uiq3Sr1Jp5kVTSvFBqmtBv8vKN9ijEX0gtHlHTaOPcxijD/NevmbmDRkp54
         hsj5T93JiqUv5kV0a2dNDqrk7iUOHjoOYjT36htvtDJUwnyrqR2ew0OiHD7YtdZSQ0o/
         NVC+WITkg5D1YjYGKsfgnWdj9YvqukCY4z4QKhdpKiaLiekXV1oc07yjdUahfPkf2N08
         Y9ojpNQiS5gvxBxhv+ysFu3dXqPbJddhbNScx/bcQ70HfiU0IfoCQcBhQSb24S4Pg0BH
         BGyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/h7YDU+P6MUHl6sVj0WLp+MoxyBRTBEzmvX8oGYQxPw=;
        b=Sf+xVch3yezck0oM0qzD9LoRy8cMLKhUd7Lj/uD3gX0+mRcF6dThksxx+vQwKaSO7X
         +aG4/GwzUibVZWDwdf6FjSB5/ZXvBbRYN/N+CunD5hK6iN3iuq1yUsybHC59Vm5votf3
         SwxuT/UaaQtzrEFcEQZdp2zpQiRTQkvd/5GpbcdUB7/xo5orDUm3JB9jOpcrQc8pxEck
         hT6rAokMPWvM+N9d5S/4o95cu23m1yhNGDfWyfaQNp4MCOJrbyY7WIzWPrNll6r/Dx/t
         RYD/H8wQ8untTw0ieNx3fpOvbi6xBLoGb9dLUL9IJqSAd7l5nzM0vKP5rI1o3GBUMFt4
         7LVQ==
X-Gm-Message-State: APjAAAXN4I9HGiXMcyItM9kpBpOeMJ2OoQzwWgVg4uTZ5eQF1yXqBz/9
        hTnYpKJ6VbmkEk8Ai1cJCQsGhT7d5lg6QkoxgWGvOw==
X-Google-Smtp-Source: APXvYqzU1KagDuT8cYSQvW6nJUrBFKBgehNsCEbpnaW4NclGbCz1NWGRZC8o9SUsmJnUBwuuLvv5/OMp+Rgu8aGJhEM=
X-Received: by 2002:a9d:4793:: with SMTP id b19mr12407690otf.238.1557751938700;
 Mon, 13 May 2019 05:52:18 -0700 (PDT)
MIME-Version: 1.0
References: <1557751388-27063-1-git-send-email-gengdongjiu@huawei.com> <1557751388-27063-11-git-send-email-gengdongjiu@huawei.com>
In-Reply-To: <1557751388-27063-11-git-send-email-gengdongjiu@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 13 May 2019 13:52:07 +0100
Message-ID: <CAFEAcA81nMkHdCvQTcv2ixNB7sg+3Qx+9mpNgF0XLaBPY7-PNQ@mail.gmail.com>
Subject: Re: [PATCH v16 10/10] target-arm: kvm64: handle SIGBUS signal from
 kernel or KVM
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Zheng Xiang <zhengxiang9@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 May 2019 at 13:46, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>
> Add SIGBUS signal handler. In this handler, it checks the SIGBUS type,
> translates the host VA delivered by host to guest PA, then fill this PA
> to guest APEI GHES memory, then notify guest according to the SIGBUS type.
>
> If guest accesses the poisoned memory, it generates Synchronous External
> Abort(SEA). Then host kernel gets an APEI notification and call memory_failure()
> to unmapped the affected page for the guest's stage 2, finally return
> to guest.
>
> Guest continues to access PG_hwpoison page, it will trap to KVM as stage2 fault,
> then a SIGBUS_MCEERR_AR synchronous signal is delivered to Qemu, Qemu record this
> error address into guest APEI GHES memory and notify guest using
> Synchronous-External-Abort(SEA).
>
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>


> +void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
> +{
> +    ARMCPU *cpu = ARM_CPU(c);
> +    CPUARMState *env = &cpu->env;
> +    ram_addr_t ram_addr;
> +    hwaddr paddr;
> +
> +    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
> +
> +    if (addr) {
> +        ram_addr = qemu_ram_addr_from_host(addr);
> +        if (ram_addr != RAM_ADDR_INVALID &&
> +            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> +            kvm_hwpoison_page_add(ram_addr);
> +            /* Asynchronous signal will be masked by main thread, so
> +             * only handle synchronous signal.
> +             */
> +            if (code == BUS_MCEERR_AR) {
> +                kvm_cpu_synchronize_state(c);
> +                if (GHES_CPER_FAIL != ghes_record_errors(ACPI_HEST_NOTIFY_SEA, paddr)) {
> +                    kvm_inject_arm_sea(c);
> +                } else {
> +                    fprintf(stderr, "failed to record the error\n");
> +                }
> +            }
> +            return;
> +        }
> +        fprintf(stderr, "Hardware memory error for memory used by "
> +                "QEMU itself instead of guest system!\n");
> +    }
> +
> +    if (code == BUS_MCEERR_AR) {
> +        fprintf(stderr, "Hardware memory error!\n");
> +        exit(1);
> +    }
> +}

This code appears to still be unconditionally trying to
notify the guest of the error via the ACPI tables without
checking whether those ACPI tables even exist. I told you
about this in a previous round of review :-(

thanks
-- PMM
