Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BFB420931
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 12:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhJDKRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 06:17:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230086AbhJDKRN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 06:17:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633342524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yDF1c1dqYgH2Cwme9oa02nYdGNUhXjuRR+mKl+EbFaI=;
        b=SuJS+ZUXF3ebZRXrn9KzAkGZZ6JJja6fCJgFJ2x7DtH3byWZcNMyhqeFU3R6jmEqN14lca
        Xwc86DLw5F160QUyeGJStDq0UJYojVqmmUQ1HIQPZEdI7ABAEmNzhb91mPeiG7wulbanLk
        cwbmo/ZUh6YJKitP7AQtj+Yw1ZxBgRc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-sIAMK28CMG-bhjdBrEoE-A-1; Mon, 04 Oct 2021 06:15:23 -0400
X-MC-Unique: sIAMK28CMG-bhjdBrEoE-A-1
Received: by mail-wm1-f70.google.com with SMTP id f12-20020a1c6a0c000000b0030d696e3798so771928wmc.3
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 03:15:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yDF1c1dqYgH2Cwme9oa02nYdGNUhXjuRR+mKl+EbFaI=;
        b=bQKimk76vMwc1G5RhMJa/Ik+VtBLuIuHHDsHb0mzPn061kGmKuVpUCSgWE8IVcZVRz
         uQy8LcHPi+SkxuHXYwaSgYrzl6louYlLgX42BQ0YZzUgKRDwLhcUfhRudfUKU9/UgAo/
         YdBskxhVKfAFIuZqNiEbQaVETOL4m+my6ONJ1jNzktxSMnqYGbDbNMp6n7YN/N7KJGQu
         A7mYYb0TpSOWPrEjqooh9xITmJ5A+AD9RhGrURR0E3qalIMeKr2eXWZWAZ35cZPx80qc
         C8nPjF3UABtrWqUSv36Ie6R6D6lLpIh+5Md5gnppsR1vUc4XcHrYznKfZJJmEUr0daig
         ANzw==
X-Gm-Message-State: AOAM531h1BPXhithFwl1oNf+WUreY0OlbriqnLgQ4MZPmgzAJhIaOBwC
        m6ZVxr29y+DMDXPyAKR99vjkHrgHpSpqbRM716TcrRACW08woAb3rFyPesfiC3uHkZ+a7QgQVKC
        2M1gI725v33Y2
X-Received: by 2002:adf:8b41:: with SMTP id v1mr9713730wra.255.1633342522130;
        Mon, 04 Oct 2021 03:15:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRStbmwZwWa77a0AnUFnuhdU26j6wRpa9Rnhj7K3iPzyC6wV10RHSZQFJAaQQey6pPDse5KA==
X-Received: by 2002:adf:8b41:: with SMTP id v1mr9713703wra.255.1633342521934;
        Mon, 04 Oct 2021 03:15:21 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id v23sm13920203wmj.4.2021.10.04.03.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 03:15:21 -0700 (PDT)
Date:   Mon, 4 Oct 2021 12:15:20 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 4/5] hw/arm/virt: Use the PA range to compute the
 memory map
Message-ID: <20211004101520.6sqx2jubmqd6djhb@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211003164605.3116450-5-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 03, 2021 at 05:46:04PM +0100, Marc Zyngier wrote:
...
> @@ -1662,9 +1665,17 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = (vms->highmem ?
> -                        base :
> -                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
> +
> +    /*
> +     * If base fits within pa_bits, all good. If it doesn't, limit it
> +     * to the end of RAM, which is guaranteed to fit within pa_bits.
> +     */
> +    if (base <= BIT_ULL(pa_bits)) {
> +        vms->highest_gpa = base -1;
                                    ^ missing space here

> +    } else {
> +        vms->highest_gpa = memtop - 1;
> +    }
> +
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;

Thanks,
drew

