Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF9D79B073
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbjIKUsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236226AbjIKKAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 06:00:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B3DE67;
        Mon, 11 Sep 2023 03:00:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E68C433CB;
        Mon, 11 Sep 2023 10:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694426433;
        bh=bcWCI4FNiFHByNekGIUw0xHDkfkjETGpgeQiww3ALp4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=B78JbLi54Na+F8SzmdoH4mkH5gF08PoJ0Sx2ohWoyLwwllWgVe3RmGNFwKeNeDoEt
         0yB7+A5ADCYLt5KY4uBM9zpHzw3T4vgHcum1R8n2a7xgtxQAPLmRcL2vHtVLlHJ2D0
         RpbbXB1rZ5GFFVzz5ybfVk0TSdVhVjFunmJ+pHgIZ0wuxa3eKfboKotpkPmtxQ10nv
         /oHKz2a02J17bmUo6ZTawCjngW0t0cBya9LjF4knpIVhlYM9kNba+C7PXVvifeU/X9
         pE3x9WngUJhISN5RA1Oft8N5lH6yiJfA9X1HFCiBJkZ9q7OSn5V/qBl4ZxXA77LpnD
         JLC66HgrTH/ew==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-9a6190af24aso529072766b.0;
        Mon, 11 Sep 2023 03:00:33 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw09N9oqkzVgfR7JA4UssuQeplmEDok7sC0Hjk04QuMoaAQPinK
        ACb8HeeNt5dEA5i+E5M1jMgDMOccqspEiNxGc6k=
X-Google-Smtp-Source: AGHT+IF3NN+MozHu2Ebc2u75EJA8ysRd2BG2jzPKDQu73v2W3LhQKr7MDH79dwFmiO2zX/f1D8sm7S6c1e12zsim6E4=
X-Received: by 2002:a17:906:53c5:b0:9a1:bf88:b67a with SMTP id
 p5-20020a17090653c500b009a1bf88b67amr7797593ejo.52.1694426431895; Mon, 11 Sep
 2023 03:00:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn> <20230831083020.2187109-17-zhaotianrui@loongson.cn>
In-Reply-To: <20230831083020.2187109-17-zhaotianrui@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Mon, 11 Sep 2023 18:00:19 +0800
X-Gmail-Original-Message-ID: <CAAhV-H497R=B3KaO8Z5ig2Nwst10dm63eiPnDpfNbFCxG4uVKg@mail.gmail.com>
Message-ID: <CAAhV-H497R=B3KaO8Z5ig2Nwst10dm63eiPnDpfNbFCxG4uVKg@mail.gmail.com>
Subject: Re: [PATCH v20 16/30] LoongArch: KVM: Implement update VM id function
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Tianrui,

On Thu, Aug 31, 2023 at 4:30=E2=80=AFPM Tianrui Zhao <zhaotianrui@loongson.=
cn> wrote:
>
> Implement kvm check vmid and update vmid, the vmid should be checked befo=
re
> vcpu enter guest.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/vmid.c | 66 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
>  create mode 100644 arch/loongarch/kvm/vmid.c
>
> diff --git a/arch/loongarch/kvm/vmid.c b/arch/loongarch/kvm/vmid.c
> new file mode 100644
> index 0000000000..fc25ddc3b7
> --- /dev/null
> +++ b/arch/loongarch/kvm/vmid.c
> @@ -0,0 +1,66 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/kvm_host.h>
> +#include "trace.h"
> +
> +static void _kvm_update_vpid(struct kvm_vcpu *vcpu, int cpu)
> +{
> +       struct kvm_context *context;
> +       unsigned long vpid;
> +
> +       context =3D per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
> +       vpid =3D context->vpid_cache + 1;
> +       if (!(vpid & vpid_mask)) {
> +               /* finish round of 64 bit loop */
> +               if (unlikely(!vpid))
> +                       vpid =3D vpid_mask + 1;
> +
> +               /* vpid 0 reserved for root */
> +               ++vpid;
> +
> +               /* start new vpid cycle */
> +               kvm_flush_tlb_all();
> +       }
> +
> +       context->vpid_cache =3D vpid;
> +       vcpu->arch.vpid =3D vpid;
> +}
> +
> +void _kvm_check_vmid(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_context *context;
> +       bool migrated;
> +       unsigned long ver, old, vpid;
> +       int cpu;
> +
> +       cpu =3D smp_processor_id();
> +       /*
> +        * Are we entering guest context on a different CPU to last time?
> +        * If so, the vCPU's guest TLB state on this CPU may be stale.
> +        */
> +       context =3D per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
> +       migrated =3D (vcpu->cpu !=3D cpu);
> +
> +       /*
> +        * Check if our vpid is of an older version
> +        *
> +        * We also discard the stored vpid if we've executed on
> +        * another CPU, as the guest mappings may have changed without
> +        * hypervisor knowledge.
> +        */
> +       ver =3D vcpu->arch.vpid & ~vpid_mask;
> +       old =3D context->vpid_cache  & ~vpid_mask;
> +       if (migrated || (ver !=3D old)) {
> +               _kvm_update_vpid(vcpu, cpu);
> +               trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
> +               vcpu->cpu =3D cpu;
> +       }
> +
> +       /* Restore GSTAT(0x50).vpid */
> +       vpid =3D (vcpu->arch.vpid & vpid_mask)
> +               << CSR_GSTAT_GID_SHIFT;
> +       change_csr_gstat(vpid_mask << CSR_GSTAT_GID_SHIFT, vpid);
> +}
I believe that vpid and vmid are both GID in the gstat register, so
please unify their names. And I think vpid is better than vmid.

Moreover, no need to create a vmid.c file, just putting them in main.c is O=
K.

Huacai

> --
> 2.27.0
>
