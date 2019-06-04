Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5BA34DDA
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 18:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfFDQmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 12:42:09 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43848 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbfFDQmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 12:42:09 -0400
Received: by mail-io1-f65.google.com with SMTP id k20so17844409ios.10;
        Tue, 04 Jun 2019 09:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3JDY6OHGY+NE0N4DeZuVbYe18iFYfWNpGGDsycjMC2g=;
        b=UwpWwJdg390UZHtTns/rfTWthrTcGew4Fy9tGkbLx8KjLIFbnCG9jwC8uKqME2sGrF
         bxK/yRBAq3MGq7d1fhd/UrFby6JZmilGdyMximDEXCMVeehCUbNaUOm8LQT8kJu7s9jl
         1WBXFxHNJq+D35c04YNdcAxDDW5UA3m+yRtaJmCoJDarasrjCIw/srfNIg3AIrVVX2Q+
         jmxRZDxLSIQDXFYJQPRuRboIHhDGSkMXfmW6qRkdZuUFkpAhHgKYEsT5Gqa/rmEtt2/a
         Laf/J7G/1bnGOtKjkGb2owo6yrha7zJpq3OuHs7INOAiXZycoThXwcx5v4X1AIukhP+B
         z5Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3JDY6OHGY+NE0N4DeZuVbYe18iFYfWNpGGDsycjMC2g=;
        b=A8QFD7mR92WJn7zIfFPIO9tHbe/zphCvTX1NIzhve1bpnh0/tK11aNx1VRiTe/Z2ho
         fZtDIe9x0emNGkoZxyEahb17RTSadUnDskAo6nLlu00IscPwBIyzQf21Y0uD6ozDmNR0
         H/cNYJjW8iCTTmLToJsTBYQtljGQGdU4IOuQ6maPcAkZfsrE9lyJJOjszRKILlpNjS/z
         0DV7cgweUaWyrHlSOOf7CHpefjJHbf59DmI/+fsyHh/RBY/YPc4H/VHZJrWqn3BjQhcE
         r92LRVxkpFgxgyFpEBCEIHIbm1L5FQqmZly9W1PQv7eR2CZ1nRF/RnSEvdSWCEzASxbx
         VYTg==
X-Gm-Message-State: APjAAAVCUVT1kRLggMiLsjUJRT5FY9K3Wo2RGiGPr7Z05UOfi5qupHVH
        pTTBHFtWEEux/xSBprUhU8iBa7tfH/axur41t6A=
X-Google-Smtp-Source: APXvYqzcpmp0gznwMtOQmK24TPSREyjaVEIx3jTVWsSszTjRWj0MU/DJg3bP7iAb59r6WIoIIpPgJaT3Hvtj1qgxSog=
X-Received: by 2002:a5d:8f86:: with SMTP id l6mr16490098iol.97.1559666527982;
 Tue, 04 Jun 2019 09:42:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190603170306.49099-1-nitesh@redhat.com> <20190603170432.1195-1-nitesh@redhat.com>
In-Reply-To: <20190603170432.1195-1-nitesh@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 4 Jun 2019 09:41:56 -0700
Message-ID: <CAKgT0UeRzF24WeVkTN2WW41iKSUpXpZbpD55-g=MBHf814RV+A@mail.gmail.com>
Subject: Re: [QEMU PATCH] KVM: Support for page hinting
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 3, 2019 at 10:04 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> Enables QEMU to call madvise on the pages which are reported
> by the guest kernel.
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  hw/virtio/trace-events                        |  1 +
>  hw/virtio/virtio-balloon.c                    | 85 +++++++++++++++++++
>  include/hw/virtio/virtio-balloon.h            |  2 +-
>  include/qemu/osdep.h                          |  7 ++
>  .../standard-headers/linux/virtio_balloon.h   |  1 +
>  5 files changed, 95 insertions(+), 1 deletion(-)

<snip>

> diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
> index 840af09cb0..4d632933a9 100644
> --- a/include/qemu/osdep.h
> +++ b/include/qemu/osdep.h
> @@ -360,6 +360,11 @@ void qemu_anon_ram_free(void *ptr, size_t size);
>  #else
>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
>  #endif
> +#ifdef MADV_FREE
> +#define QEMU_MADV_FREE MADV_FREE
> +#else
> +#define QEMU_MADV_FREE QEMU_MADV_INVALID
> +#endif

Is there a specific reason for making this default to INVALID instead
of just using DONTNEED? I ran into some issues as my host kernel
didn't have support for MADV_FREE in the exported kernel headers
apparently so I was getting no effect. It seems like it would be
better to fall back to doing DONTNEED instead of just disabling the
functionality all together.

>  #elif defined(CONFIG_POSIX_MADVISE)
>
> @@ -373,6 +378,7 @@ void qemu_anon_ram_free(void *ptr, size_t size);
>  #define QEMU_MADV_HUGEPAGE  QEMU_MADV_INVALID
>  #define QEMU_MADV_NOHUGEPAGE  QEMU_MADV_INVALID
>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
> +#define QEMU_MADV_FREE QEMU_MADV_INVALID

Same here. If you already have MADV_DONTNEED you could just use that
instead of disabling the functionality.

>  #else /* no-op */
>
> @@ -386,6 +392,7 @@ void qemu_anon_ram_free(void *ptr, size_t size);
>  #define QEMU_MADV_HUGEPAGE  QEMU_MADV_INVALID
>  #define QEMU_MADV_NOHUGEPAGE  QEMU_MADV_INVALID
>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
> +#define QEMU_MADV_FREE QEMU_MADV_INVALID
>
>  #endif
>
