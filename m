Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6023322C1CB
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 11:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgGXJNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 05:13:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46462 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726572AbgGXJNA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jul 2020 05:13:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595581978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=q7/A08mRNvKPkpe1O34UkyU7O620zZMdCRx7mxDjxek=;
        b=XJ/cedVRbh5p9kgDs5RDWwIcr3WwDIT6cGKgzzUHYupv+PakzjswMDV6rTOX13ysigWgNU
        V2JscRBsHsTG6TBvgoBfaYWbw5ZQpR0O/KQYof4dK89hgi/VbdR2VjDjrbskZViKMlP96n
        j5a3PoL6gHinazzlHXnpO0dGtDM7/FY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-GgyuooweMZKO-g7prFrdhg-1; Fri, 24 Jul 2020 05:12:55 -0400
X-MC-Unique: GgyuooweMZKO-g7prFrdhg-1
Received: by mail-wr1-f71.google.com with SMTP id t12so1994034wrp.0
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 02:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=q7/A08mRNvKPkpe1O34UkyU7O620zZMdCRx7mxDjxek=;
        b=l7zrFHBSkLlNSs+WkK8J0icrsrMCpZv7jFK7qli6pnQLphc96iAmTCftJbNpTUWZ4r
         Yi0ShSAD4bM7ydwxVSFOduo4t4b09ecFLHqdIOwNmLfRc2VszE3YoxXUIwHI51RR/fhu
         RvfqO1JIPXlFSVYIKsb/LDsxNs/oyl2xPCwi7RBFMKeoZToaoGVI3zPd4Oo4Z6P2rWqx
         PoN3jaxp7vkzvywhJYYF4uYcvD48jTTpcELlB4A37ap8zuO+LJfUJPmIFe3SzRDe8qx2
         iTVDV8ex7sFZUkfmTjv9C44jVmBAaQME7g0MkQCPNG2ubO5LMLSCIQOVGu42Oh1Vt1DR
         oFWg==
X-Gm-Message-State: AOAM532AwSZ2sVvXpP4D4EvVLBevPwNXsFGuGM6gX/F93nyI2pDQNWWL
        QZq6H6wFZ0h23a5WAgyztNYmmdyEanIwDtQ0Bv0QEHuUtGzy9/iX+eC1CXDb6he8cWhMcA8WtDt
        CJdPC2rtiHhwC
X-Received: by 2002:a1c:dd06:: with SMTP id u6mr8226156wmg.39.1595581974791;
        Fri, 24 Jul 2020 02:12:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxd2W5G9f6O76yo0FemnyPQHJKhQnSVHlsnudhiwc25GlPzJNu/DWYy8rwhZkMafSTsQTTdIg==
X-Received: by 2002:a1c:dd06:: with SMTP id u6mr8226134wmg.39.1595581974518;
        Fri, 24 Jul 2020 02:12:54 -0700 (PDT)
Received: from [192.168.1.36] (138.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.138])
        by smtp.gmail.com with ESMTPSA id 14sm6236352wmk.19.2020.07.24.02.12.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 02:12:53 -0700 (PDT)
Subject: Re: [PATCH] pseries: fix kvmppc_set_fwnmi()
To:     Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, npiggin@gmail.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20200724083533.281700-1-lvivier@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <375c9cb8-ec59-9d30-000d-b58d14be0aa6@redhat.com>
Date:   Fri, 24 Jul 2020 11:12:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200724083533.281700-1-lvivier@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/24/20 10:35 AM, Laurent Vivier wrote:
> QEMU issues the ioctl(KVM_CAP_PPC_FWNMI) on the first vCPU.
> 
> If the first vCPU is currently running, the vCPU mutex is held
> and the ioctl() cannot be done and waits until the mutex is released.
> This never happens and the VM is stuck.
> 
> To avoid this deadlock, issue the ioctl on the same vCPU doing the
> RTAS call.
> 
> The problem can be reproduced by booting a guest with several vCPUs
> (the probability to have the problem is (n - 1) / n,  n = # of CPUs),
> and then by triggering a kernel crash with "echo c >/proc/sysrq-trigger".
> 
> On the reboot, the kernel hangs after:
> 
> ...
> [    0.000000] -----------------------------------------------------
> [    0.000000] ppc64_pft_size    = 0x0
> [    0.000000] phys_mem_size     = 0x48000000
> [    0.000000] dcache_bsize      = 0x80
> [    0.000000] icache_bsize      = 0x80
> [    0.000000] cpu_features      = 0x0001c06f8f4f91a7
> [    0.000000]   possible        = 0x0003fbffcf5fb1a7
> [    0.000000]   always          = 0x00000003800081a1
> [    0.000000] cpu_user_features = 0xdc0065c2 0xaee00000
> [    0.000000] mmu_features      = 0x3c006041
> [    0.000000] firmware_features = 0x00000085455a445f
> [    0.000000] physical_start    = 0x8000000
> [    0.000000] -----------------------------------------------------
> [    0.000000] numa:   NODE_DATA [mem 0x47f33c80-0x47f3ffff]
> 
> Fixes: ec010c00665b ("ppc/spapr: KVM FWNMI should not be enabled until guest requests it")
> Cc: npiggin@gmail.com
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

> ---
>  hw/ppc/spapr_rtas.c  | 2 +-
>  target/ppc/kvm.c     | 3 +--
>  target/ppc/kvm_ppc.h | 4 ++--
>  3 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/hw/ppc/spapr_rtas.c b/hw/ppc/spapr_rtas.c
> index bcac0d00e7b6..513c7a84351b 100644
> --- a/hw/ppc/spapr_rtas.c
> +++ b/hw/ppc/spapr_rtas.c
> @@ -438,7 +438,7 @@ static void rtas_ibm_nmi_register(PowerPCCPU *cpu,
>      }
>  
>      if (kvm_enabled()) {
> -        if (kvmppc_set_fwnmi() < 0) {
> +        if (kvmppc_set_fwnmi(cpu) < 0) {
>              rtas_st(rets, 0, RTAS_OUT_NOT_SUPPORTED);
>              return;
>          }
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 2692f76130aa..d85ba8ffe00b 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2071,9 +2071,8 @@ bool kvmppc_get_fwnmi(void)
>      return cap_fwnmi;
>  }
>  
> -int kvmppc_set_fwnmi(void)
> +int kvmppc_set_fwnmi(PowerPCCPU *cpu)
>  {
> -    PowerPCCPU *cpu = POWERPC_CPU(first_cpu);
>      CPUState *cs = CPU(cpu);
>  
>      return kvm_vcpu_enable_cap(cs, KVM_CAP_PPC_FWNMI, 0);
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index 701c0c262be2..72e05f1cd2fc 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -28,7 +28,7 @@ void kvmppc_set_papr(PowerPCCPU *cpu);
>  int kvmppc_set_compat(PowerPCCPU *cpu, uint32_t compat_pvr);
>  void kvmppc_set_mpic_proxy(PowerPCCPU *cpu, int mpic_proxy);
>  bool kvmppc_get_fwnmi(void);
> -int kvmppc_set_fwnmi(void);
> +int kvmppc_set_fwnmi(PowerPCCPU *cpu);
>  int kvmppc_smt_threads(void);
>  void kvmppc_error_append_smt_possible_hint(Error *const *errp);
>  int kvmppc_set_smt_threads(int smt);
> @@ -169,7 +169,7 @@ static inline bool kvmppc_get_fwnmi(void)
>      return false;
>  }
>  
> -static inline int kvmppc_set_fwnmi(void)
> +static inline int kvmppc_set_fwnmi(PowerPCCPU *cpu)
>  {
>      return -1;
>  }
> 

