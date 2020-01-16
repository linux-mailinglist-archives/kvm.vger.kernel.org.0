Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D702A13E013
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 17:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgAPQ2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 11:28:46 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41817 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgAPQ2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 11:28:46 -0500
Received: by mail-ot1-f67.google.com with SMTP id r27so19878729otc.8
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 08:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8WJbhTsTM0l8OxSV/uIB4OR8tInBfjFfl18OnoFr1k8=;
        b=CZIpFWNKSSkddyHn0xfkX3f+epSDDAvMbHfRBWgvdlTV3XTp32GimGfWhltlCnH5dg
         zwNWVLC8ODcUw0hnJ7BUb6N/6WFyzmvmTI4fxkj6+kAucL0VINZBHy/ZQPRa5LDRCIFg
         5tTMkPMIYlWcxAD/Fa1hh4uMi7e5Dzy7Tmgd0XWPEWSa8yrwHLIxEBAUGYLzgCZmU2MD
         o7p5q+c1i/Pv/OHbR9HGRgLomkRrfxiEjzMOZ6xHSbvpdYxzsDEO+Unn7aisMtITaPVf
         j0KgID6jEvnxsROKVz3yvnET9ScJc4RjaFDEsB2os6A93rD2YXDjXzFxcqBIp/2HRM2v
         Kn5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8WJbhTsTM0l8OxSV/uIB4OR8tInBfjFfl18OnoFr1k8=;
        b=WCNR2WP+Wcq8baqWavwGBcuSYCg9NdnN9frW86toVsEKRatMGB0hKRqoweOZ6IQqqt
         2dCViQoK0kekkKkCsnqMxi1OPHdD5IqTq4O9jn2lcxgl9+ma+qxRi+gLRZx5stRhpnhA
         1/bt5BbuoHYtceLJFjXfBwkZ3d/gGy7ptSPk8Pt75wIUp9kr0BJFkFsVuCS+eDGIirPl
         Q0jRBoB0Dt/ngSmou4CIIQD2E5iyJOlsyrcWYu4oJ/rkMJf4TyoYmBcU2ufDM1BJS5pZ
         BAMlKU+iKyw6K5l1u32VmAallsY6hNpPThiMRozhjdVC8kRG59dGlFilQyRoswHB0TXM
         NsUg==
X-Gm-Message-State: APjAAAVayntZjaRRE5iBQzdJkkMcP1Lp5rX/E2dWZft2GZHtQAJ9oYBB
        l/lIyxIb0OgldYAfmGnGIKvHNvDKWhtIroQ3+TmW3Q==
X-Google-Smtp-Source: APXvYqzVRHK6rAR/t7eQ6rK72kuegcol5aP6HpRQ6XN1d8kQUY49Ip/TiPMoQmY8K+2LVdsvUCVlgzE6SjuScdy75g4=
X-Received: by 2002:a05:6830:1586:: with SMTP id i6mr2528446otr.221.1579192125156;
 Thu, 16 Jan 2020 08:28:45 -0800 (PST)
MIME-Version: 1.0
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com> <1578483143-14905-9-git-send-email-gengdongjiu@huawei.com>
In-Reply-To: <1578483143-14905-9-git-send-email-gengdongjiu@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 16 Jan 2020 16:28:34 +0000
Message-ID: <CAFEAcA_=PgkrWjwPxD89fCi85XPpcTHssXkSmE04Ctoj7AX0kA@mail.gmail.com>
Subject: Re: [PATCH v22 8/9] target-arm: kvm64: handle SIGBUS signal from
 kernel or KVM
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Fam Zheng <fam@euphon.net>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        James Morse <james.morse@arm.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Zheng Xiang <zhengxiang9@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jan 2020 at 11:33, Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> +void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
> +{
> +    ram_addr_t ram_addr;
> +    hwaddr paddr;
> +
> +    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
> +
> +    if (acpi_enabled && addr &&
> +            object_property_get_bool(qdev_get_machine(), "ras", NULL)) {
> +        ram_addr = qemu_ram_addr_from_host(addr);
> +        if (ram_addr != RAM_ADDR_INVALID &&
> +            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> +            kvm_hwpoison_page_add(ram_addr);
> +            /*
> +             * Asynchronous signal will be masked by main thread, so
> +             * only handle synchronous signal.
> +             */

I don't understand this comment. (I think we've had discussions
about it before, but it's still not clear to me.)

This function (kvm_arch_on_sigbus_vcpu()) will be called in two contexts:

(1) in the vcpu thread:
  * the real SIGBUS handler sigbus_handler() sets a flag and arranges
    for an immediate vcpu exit
  * the vcpu thread reads the flag on exit from KVM_RUN and
    calls kvm_arch_on_sigbus_vcpu() directly
  * the error could be MCEERR_AR or MCEERR_AO
(2) MCE errors on other threads:
  * here SIGBUS is blocked, so MCEERR_AR (action-required)
    errors will cause the kernel to just kill the QEMU process
  * MCEERR_AO errors will be handled via the iothread's use
    of signalfd(), so kvm_on_sigbus() will get called from
    the main thread, and it will call kvm_arch_on_sigbus_vcpu()
  * in this case the passed in CPUState will (arbitrarily) be that
    for the first vCPU

For MCEERR_AR, the code here looks correct -- we know this is
only going to happen for the relevant vCPU so we can go ahead
and do the "record it in the ACPI table and tell the guest" bit.

But shouldn't we be doing something with the MCEERR_AO too?
That of course will be trickier because we're not necessarily
in the vcpu thread, but it would be nice to let the guest
know about it.

One comment that would work with the current code would be:

/*
 * If this is a BUS_MCEERR_AR, we know we have been called
 * synchronously from the vCPU thread, so we can easily
 * synchronize the state and inject an error.
 *
 * TODO: we currently don't tell the guest at all about BUS_MCEERR_AO.
 * In that case we might either be being called synchronously from
 * the vCPU thread, or a bit later from the main thread, so doing
 * the injection of the error would be more complicated.
 */

but I don't know if that's what you meant to say/implement...

> +            if (code == BUS_MCEERR_AR) {
> +                kvm_cpu_synchronize_state(c);
> +                if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
> +                    kvm_inject_arm_sea(c);
> +                } else {
> +                    error_report("failed to record the error");
> +                    abort();
> +                }
> +            }
> +            return;
> +        }
> +        if (code == BUS_MCEERR_AO) {
> +            error_report("Hardware memory error at addr %p for memory used by "
> +                "QEMU itself instead of guest system!", addr);
> +        }
> +    }
> +
> +    if (code == BUS_MCEERR_AR) {
> +        error_report("Hardware memory error!");
> +        exit(1);
> +    }
> +}
>

thanks
-- PMM
