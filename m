Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89217D791B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 16:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733039AbfJOOtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 10:49:12 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36709 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732599AbfJOOtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 10:49:06 -0400
Received: by mail-oi1-f196.google.com with SMTP id k20so17040876oih.3
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 07:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/kwSlXh6iJx2O0gCfEtXXAa4F2WK8uIGGEOp4n92JOM=;
        b=LkjWXU/fZpk5VVnZObAdiPhF8A1Ozh6Fl7p+l0J7kmC3t20Uh+d+oCGGy3oF3r6NLe
         hEMsy2Wbsoy88zOrL45mi3wV5z9sQOIlnfWr49WcGTrBZZFV2BGwb3FveDziPpo2JDHn
         kpfwm1CHlRPfu67CpYnsHA+1wpF0ME1e5MUbXx5mtN+kOdrNVrNnJDBrZ1EIU+mV5Pdc
         tzOgjKPkaHhXJTvyHhOC488MgyE1HprVgxyht758wl7rSo7bBSglCnMNh6dlHJRqWz03
         BJmurMMAc0G60/VAehe5JtgYrsbOa1fAHAfsIw8/AbrFpjs06sppNhC+IkGXs5ZWKzIv
         V3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/kwSlXh6iJx2O0gCfEtXXAa4F2WK8uIGGEOp4n92JOM=;
        b=I5ldSUxhB4H8BOutVwAq/FvsOMMTnKuROuIgpj7DLNfpAXZxTduwN71Qo37TmSYV4n
         abhpoOLgx02BVNLd1lndAvPh74HMnT6B8epXsiv2glmc9kSotkznzcCW1DfQUVu/vA8Y
         bk4YuT0uKEegkXAYx4TGTMkHzNl1ov6D7+vgaHfFX0JPCueJ7epmwNukzIIqsHaEn1oF
         +bjT+os0jyK5UZwAofENWeldoKx6+wbleA1FVnJl7FVdGOVN+DKBFF10yDOY2F49LAfC
         ZMQVFLk1eidp3f2Wb345cSYUyzN+1y0rwzjknHiWeQBUUTyV6oodjBd8pt8kkbsaOfZj
         C1dg==
X-Gm-Message-State: APjAAAU8+0DNa/mjY7gcL3Bqi+9QM8I713gLXrQID+ErubvFWguYxOWp
        m2enGT4QwEOHQuAsDAL99N7Oho9lUlWJVpB8qU+Z5Q==
X-Google-Smtp-Source: APXvYqxulgZJq7+EMr7REicShnKhm+CUfM2qlJR9cQM8gDJsBL49U+8xBNQAEvwouzHYF6STEw9GWU7u1fqNxMz29Vg=
X-Received: by 2002:aca:49c2:: with SMTP id w185mr29667804oia.163.1571150945480;
 Tue, 15 Oct 2019 07:49:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191015140140.34748-1-zhengxiang9@huawei.com> <20191015140140.34748-6-zhengxiang9@huawei.com>
In-Reply-To: <20191015140140.34748-6-zhengxiang9@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 15 Oct 2019 15:48:53 +0100
Message-ID: <CAFEAcA-92YEgrBPDVVFEmjBYnw=keJWKUDnqNRakw-jKYaxK5Q@mail.gmail.com>
Subject: Re: [PATCH v19 5/5] target-arm: kvm64: handle SIGBUS signal from
 kernel or KVM
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        gengdongjiu <gengdongjiu@huawei.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>,
        wanghaibin.wang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Oct 2019 at 15:02, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>
> From: Dongjiu Geng <gengdongjiu@huawei.com>
>
> Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
> translates the host VA delivered by host to guest PA, then fills this PA
> to guest APEI GHES memory, then notifies guest according to the SIGBUS
> type.
>
> When guest accesses the poisoned memory, it will generate a Synchronous
> External Abort(SEA). Then host kernel gets an APEI notification and calls
> memory_failure() to unmapped the affected page in stage 2, finally
> returns to guest.
>
> Guest continues to access the PG_hwpoison page, it will trap to KVM as
> stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
> Qemu, Qemu records this error address into guest APEI GHES memory and
> notifes guest using Synchronous-External-Abort(SEA).
>
> In order to inject a vSEA, we introduce the kvm_inject_arm_sea() function
> in which we can setup the type of exception and the syndrome information.
> When switching to guest, the target vcpu will jump to the synchronous
> external abort vector table entry.
>
> The ESR_ELx.DFSC is set to synchronous external abort(0x10), and the
> ESR_ELx.FnV is set to not valid(0x1), which will tell guest that FAR is
> not valid and hold an UNKNOWN value. These values will be set to KVM
> register structures through KVM_SET_ONE_REG IOCTL.
>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>

> +static int acpi_ghes_record_mem_error(uint64_t error_block_address,
> +                                      uint64_t error_physical_addr,
> +                                      uint32_t data_length)
> +{
> +    GArray *block;
> +    uint64_t current_block_length;
> +    /* Memory Error Section Type */
> +    QemuUUID mem_section_id_le = UEFI_CPER_SEC_PLATFORM_MEM;
> +    QemuUUID fru_id = {0};

Hi; this makes at least some versions of clang complain
(this is a clang bug, but it's present in shipped versions):

/home/petmay01/linaro/qemu-from-laptop/qemu/hw/acpi/acpi_ghes.c:135:24:
error: suggest braces around
      initialization of subobject [-Werror,-Wmissing-braces]
    QemuUUID fru_id = {0};
                       ^
                       {}

We generally use "{}" as the generic zero-initializer for
this reason (it's gcc/clang specific whereas "{0}" is
in the standard, but all of the compilers we care about
support it and don't warn about its use).

> +    uint8_t fru_text[20] = {0};

Clang doesn't mind this one because it's not initializing
a struct type, but you could use "{}" here too for consistency.

thanks
-- PMM
