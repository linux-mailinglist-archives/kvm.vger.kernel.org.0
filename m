Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDBB4E94AC
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 13:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241506AbiC1Lbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 07:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241443AbiC1Lav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 07:30:51 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB4556C02
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 04:24:21 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id o5so25415876ybe.2
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 04:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xmOofWXPDOZiFtpjDyUYyMlgL0oxxk8dYXPeAiOLviQ=;
        b=Zgz2ilLvTSiR0eGyvyuCcsc6wgeDI7hcj5K316U+DlfEhZWtGLtjS5uJfYPdEkS4af
         gWoHcRMGR8lFRKgx7x6GDmq/rzR5HObeRun5RUq5ZMphJaZ7D4SjCjxLNwCb0moJPaRI
         ZicVa5YnXpAUAMNfzb1uJLERuW0utOEsKnnDgR9LOizI6WrgAzJbhWUzPLNv+g3f4YWO
         GlBk6m/r9Bh1aEz5dXbgX4PWWSofMhnJBujYA2vE80pxoQ5a7tN72kOlCgKq/KKmnl4b
         TiLUPfrYSu5lNka0xz+lK3wSKWKY9MlKCS2zjgfI50PKGEda3No65xvfeQG5ep+BJHXf
         RmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xmOofWXPDOZiFtpjDyUYyMlgL0oxxk8dYXPeAiOLviQ=;
        b=4Ol0RogTl8YzT/USv3jxWs278CpJS0HL4nNlfE61pc2Eom38zETRMVgYgE1ap22C+n
         49+L/XGMbUjJf5yH/645ipOYYK5MKvWzxaXbXm+2hSjQnUzkH2OMGvR3HqqbG8uqg6qW
         ry/8jNGIAd4T4ldEulkBbsHK2DDhOqMBHtPpklOSIP8bMdpDh6ZOj548nY0dZE7/D1/4
         cprEPT6qG392gOhE5SGhlbYl3zZcywr036LqdjuWTEXnt+G7BrJ+ooCoI3cPxC+KH9vp
         1D+RDPxcgIbZ56pQ0PuqCxYne7YW2J7MVEuRx1IseWD3A0EFDMicnRJYs7rKhDNUya7H
         vR3A==
X-Gm-Message-State: AOAM533ndDmyqADiAHeT3z8f1cylh8jW6YQkObZWP74rUbzAR+f0bywv
        xaJGKlD+miPBZ3R//Zvv2/HQqjNioEGLms35ewgK+A==
X-Google-Smtp-Source: ABdhPJyhARaz0zB0XWC2DwGU6wSO/IqjixjS3s3LvBF5QV0n1cWGYTbiHYLWfvgRDRW+dS9wjQ1aPbqbu2e+dFomcuY=
X-Received: by 2002:a5b:6c1:0:b0:633:b5c7:b9b7 with SMTP id
 r1-20020a5b06c1000000b00633b5c7b9b7mr22215825ybq.67.1648466660275; Mon, 28
 Mar 2022 04:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <mw2ty4ijin-mw2ty4ijio@nsmail6.0> <CAFEAcA_xpi2kCdHK-K=T3-pbHjWS47xyCzG47wg3HBSKFo4z8w@mail.gmail.com>
 <de27054a-900b-d1fc-69be-82cb6c893c44@kylinos.cn>
In-Reply-To: <de27054a-900b-d1fc-69be-82cb6c893c44@kylinos.cn>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 28 Mar 2022 11:24:06 +0000
Message-ID: <CAFEAcA8MbzCvEWL0eu41-hPBTs9OZf1WV168RQCb9K3ZHC-pqw@mail.gmail.com>
Subject: Re: [PATCH] kvm/arm64: Fix memory section did not set to kvm
To:     Cong Liu <liucong2@kylinos.cn>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Mar 2022 at 10:42, Cong Liu <liucong2@kylinos.cn> wrote:
> On 2022/3/25 23:00, Peter Maydell wrote:
> > This is correct behaviour. If the memory region is less than
> > a complete host page then it is not possible for KVM to
> > map it into the guest as directly accessible memory,
> > because that can only be done in host-page sized chunks,
> > and if the MR is a RAM region smaller than the page then
> > there simply is not enough backing RAM there to map without
> > incorrectly exposing to the guest whatever comes after the
> > contents of the MR.
>
> actually, even with fixed 8192 qxl rom bar size, the RAMBlock
> size corresponding to MemoryRegion will also be 64k.

Where does this rounding up happen? In any case, it would
still be wrong -- if the ROM bar is 8192 large then the
guest should get a fault writing to bytes past 8191, not
reads-as-written.

> so it can
> map into the guest as directly accessible memory. now it failed
> just because we use the wrong size. ROUND_UP(n, d) requires
> that d be a power of 2, it is faster than QEMU_ALIGN_UP().
> and the qemu_real_host_page_size should always a power of 2.
> seems we can use this patch and no need to fall back to "treat
> like MMIO device access".
>
> >
> > For memory regions smaller than a page, KVM and QEMU will
> > fall back to "treat like MMIO device access". As long as the

> I don't understand how it works, can you help explain or tell me
> which part of the code I should read to understand?

The KVM code in the kernel takes a fault because there is
nothing mapped at that address in the stage 2 page tables.
This results in kvm_handle_guest_abort() being called.
This function sorts out various cases it can handle
(eg "this is backed by host RAM which we need to page in")
and cases which are always errors (eg "the guest tried to
fetch an instruction from non-RAM"). For the cases of
"treat like MMIO device access" it calls io_mem_abort().
In io_mem_abort() we check whether the guest instruction that
did the load/store was a sensible one (this is the
kvm_vcpu_dabt_isvalid() check). Assuming that it was, then
we fill in some kvm_run struct fields with the parameters like
access size, address, etc (which the host CPU tells us in the
ESR_ELx syndrome register) cause an exit to userspace with
KVM_EXIT_MMIO as the reason.

In QEMU, the code in kvm_cpu_exec() has a case for the
KVM_EXIT_MMIO code. It just calls address_space_rw()
using the address, length, etc parameters that the kernel
gave us. If this is a load then the loaded data is filled
in in the kvm_run struct. Then it loops back around to do a
KVM_RUN ioctl, handing control back to the kernel.

In the kernel, in the arm64 kvm_arch_vcpu_ioctl_run()
we check whether we've just come back from a KVM_EXIT_MMIO
exit, and if so call kvm_handle_mmio_return(). If the
faulting instruction was a load, we read the data from
the kvm_run struct, sign extend as appropriate, and write
to the appropriate guest register. Then we increment the
guest program counter. Finally we start execution in the
guest in the normal way.

> the test code appended.
> it works with some differences between arm64 and x86. in x86, it
> printf rom_test->magic and rom_test->id correctly, but in arm64.
> it printf rom_test->magic correctly. when I try to print the
> rom_test->id. I get "load/store instruction decoding not
> implemented" error message.

You don't show the guest code, which is the thing that matters
here. In any case for the QXL ROM we already have the fix,
which is to make the ROM as big as the host page size.

-- PMM
