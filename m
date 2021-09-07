Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD80402949
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 14:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344523AbhIGNAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 09:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhIGNAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 09:00:00 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CB4C061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 05:58:54 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id u16so14316837wrn.5
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 05:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5900lkAEZ/6L9YX3yLKrRhWB8KnYm9l4XpxD5QVCI4Q=;
        b=iffw1HPOAcXeLtwO1sVuWL968Mdc83wMBs5ozkWh4VCd+fsYuUhBqYm6jXqTfFwy46
         Sdt3/+kwMKEzOE2QdpUMnCZv3oU6ZLSApxIor7q6RqRO/Uxus9IEPawyDi7CZcG6NcAE
         wXrPcfEtSLNPqmPKHG2Ulw0Q79UGb2T/zBWFsXLtrOJsDEatNjJHsajKQEaR/jqajxNq
         Ou1R/fpHVu5gCdJ2aYDHl+wV0OcMtsH3jaRktHM8oajEdKGu+wf7AKeEXVkKhPXH3Wr+
         tu9KzjqW+wdl5kKKLOUUnmWpnHJggKY1ZuWQuUNIVUmgsi6fCwu2xNpWeDmjapICFI6e
         sLdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5900lkAEZ/6L9YX3yLKrRhWB8KnYm9l4XpxD5QVCI4Q=;
        b=XhtDjHosJvUXwxVHpIVWdTJM+H38nhfo/FJKlgItoCxomoU1cCQ7vXa2FMo/mhMJ1n
         7HEQ3MKJJxcYZffgLl10lwe8KyAdJEjCXZS3M55FvL4EP6CiOLIdH2SQeaPtvY+BMIMS
         K47wZhV874ZGvWhSFa8+TGex8PAwBnDf5hAqwp6zufX0+6Er42oLCHI0+1sTE4ByoWap
         nOhscBGLQNNG5j/5rIaliKo8syuL3hQ4HcIyJ3e/raM5OyK0t1ikBUBC2IqGNah/qiaL
         z/cR5em8yAicP9UTuvxsFvcHRal4OEYfpi31cr3j86EIyp5cVgCN7fu7sRZ1TsNaI3tF
         RLXg==
X-Gm-Message-State: AOAM530ECjysaMbE4R4dDByOKvM2yk1dGgBEFF+YexC9nMytoKxTqK46
        ZrSSHF8qYhfikieY+NhXJGEZHhTtfAAmwbYGk0dudA==
X-Google-Smtp-Source: ABdhPJyNz9w2xmO4gIGLIjfbsUDdHaw1SCa+g2bW1eVJgnkhUG69BUTuOpNo1cqP8VgHPCzIr+O6woJiQJA3q6jZoNU=
X-Received: by 2002:adf:fb91:: with SMTP id a17mr18062264wrr.376.1631019532386;
 Tue, 07 Sep 2021 05:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210822144441.1290891-1-maz@kernel.org> <20210822144441.1290891-3-maz@kernel.org>
In-Reply-To: <20210822144441.1290891-3-maz@kernel.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 7 Sep 2021 13:58:03 +0100
Message-ID: <CAFEAcA9=SJd52ZEQb0gyW+2q9md4KMnLy8YsME-Mkd-AbvV41Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] hw/arm/virt: Honor highmem setting when computing highest_gpa
To:     Marc Zyngier <maz@kernel.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        kvmarm <kvmarm@lists.cs.columbia.edu>,
        kvm-devel <kvm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 22 Aug 2021 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
>
> Even when the VM is configured with highmem=off, the highest_gpa
> field includes devices that are above the 4GiB limit, which is
> what highmem=off is supposed to enforce. This leads to failures
> in virt_kvm_type() on systems that have a crippled IPA range,
> as the reported IPA space is larger than what it should be.
>
> Instead, honor the user-specified limit to only use the devices
> at the lowest end of the spectrum.
>
> Note that this doesn't affect memory, which is still allowed to
> go beyond 4GiB with highmem=on configurations.
>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 81eda46b0b..bc189e30b8 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1598,7 +1598,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
>  static void virt_set_memmap(VirtMachineState *vms)
>  {
>      MachineState *ms = MACHINE(vms);
> -    hwaddr base, device_memory_base, device_memory_size;
> +    hwaddr base, device_memory_base, device_memory_size, ceiling;
>      int i;
>
>      vms->memmap = extended_memmap;
> @@ -1625,7 +1625,7 @@ static void virt_set_memmap(VirtMachineState *vms)
>      device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
>
>      /* Base address of the high IO region */
> -    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    ceiling = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
>      if (base < device_memory_base) {
>          error_report("maxmem/slots too huge");
>          exit(EXIT_FAILURE);
> @@ -1642,7 +1642,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = base - 1;
> +    if (vms->highmem) {
> +           /* If we have highmem, move the IPA limit to the top */
> +           ceiling = base;
> +    }
> +    vms->highest_gpa = ceiling - 1;

This doesn't look right to me. If highmem is false and the
high IO region would be above the 4GB mark then we should not
create the high IO region at all, surely? This code looks like
it goes ahead and puts the high IO region above 4GB and then
lies in the highest_gpa value about what the highest used GPA is.

-- PMM
