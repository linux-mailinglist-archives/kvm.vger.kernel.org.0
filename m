Return-Path: <kvm+bounces-13898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F15189C5D8
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 16:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31D131C22B10
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 14:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E08D7F49F;
	Mon,  8 Apr 2024 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="ATMp6C0P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F10C7F46A
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 14:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584859; cv=none; b=HIWNBf7kItnP8cVrXB3K4vhrrmlrTRAtJ3D2rKAKIp3sHik5p8pGlQJ05KWvtHcIZmZAfc+Hw8/GAV1PVdQ/pfBC67CdgjUVTe7uNhend9M2ayFJLYsYlAhaS0nlVI7hxmHh3C0s9Cb1vV9HmSk1xhaYwE7vk8fuQy2SEPuYTSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584859; c=relaxed/simple;
	bh=pmcfq5HWbvOuPZ7ktQYB9L7EjebiET7N8ip2h9xS9rQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sYWCDgmgj2FGO7iAD7cfedR1PNb5AvnHTrkdkRUGlzC8FHkoSWgOt5TAg7h8TwXYQrAUDM1NO9ATLqYg1vmVRVzLwdA2xQjpgVIMN7y76f+Mnn7VILKI6cl75wPOnWm9zYmopw/+h+N2BWzmKPdDbYQZjwCWrIpDi0/8kuVm+Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=ATMp6C0P; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-617d25b2bc4so30754507b3.2
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 07:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1712584857; x=1713189657; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RgX5uLFPvKhCe0/l1qGuqD81V2YeLLzt+zbkFfBro1o=;
        b=ATMp6C0PwraBAkKa0KdnsEiAzvTxU5Zp9hFsmSbNkJSEeHRsISmuuYbvL9jRXjj6rf
         PJdt8b5g5tXBfq5iXFMUvyhQIGcCYX3pLBXXP+dKJAWKfn8LfxxFz4dyClTqOpM142qe
         QkueL1lDlD4RKRZxqHx75Dz70nYuqQIpuxx8qnY1aPKnz8PJyyTLl0/iK2eSN/oCg8lJ
         SASa4MURhi2jNP7yNkYehAD3D0ToqV9TlyVU2J0qLahXpa/LBMe2z2mVfSvsfXIBaaXi
         N5rGMVWtOuksJGntr3c1S0t74qQ5xjRSR6obIOwRlHRs41QegFGf7gWYrTBEPynoQyyt
         7zfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712584857; x=1713189657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RgX5uLFPvKhCe0/l1qGuqD81V2YeLLzt+zbkFfBro1o=;
        b=UWM4G03qGPbYtQqaFAHuoJgaHkUJ+tvNsffwVKN0y5Axamj5MahBsuVFDoV7msIDQK
         Vmrei1++guRLYaqaXlrn4Nn/GI6zH4UFjhxR2op5WmY9XGuqhO9WSv0QqkYzQ2eh3wBx
         qHzER601w4eOQvMNBmARZsGzOwgsPhVXWSAF8qHb20KEIPzp7iRc36PewQ/veILnmygO
         l7pubrD5Y52juPhg3PaNXZdiBZo5DK/cM+jDIOP1kPN8/m6LxUdnQ1KH5qRcDk+/kOAM
         hIazsku764DoxoH54oZZ8bHB0kCKtyseL0wQtkNnXkZoeC4wXqF8JQwAEfNljikJS47s
         QLzw==
X-Forwarded-Encrypted: i=1; AJvYcCUoV+3kViyfFZ8Cra6dRMHr2ZjK0MB0cWFdBlr3FPUfuvbErPwLDZ1jRw8zxYx7/8jh8sZw0ImDUal8OZEle4AidAQU
X-Gm-Message-State: AOJu0YylIMeKYthVDoC0ZPWoFQX0a0Eab5vwp1S7G2f7x2U4cG/tUVMm
	MBTwn+WqpeU0xgHK3Yr7LA8ebY+W1x0Egvsr8TalsRV0o5COlRT2qOtbtLNRiUvjflf+EUf5RDA
	3Xgm1IWtdEuFlAH5y5200185PNWggGB5hrAsZQA==
X-Google-Smtp-Source: AGHT+IH1J5le4Oi7vod9vzqK8bQoLhG5cGS8+C/RdmhV4KOlje2EKS1E8PLOdElKkDbgr8+ieIsxyFLyzQO+RFooQYo=
X-Received: by 2002:a05:6902:1547:b0:dc6:17d2:3b89 with SMTP id
 r7-20020a056902154700b00dc617d23b89mr6556651ybu.61.1712584856879; Mon, 08 Apr
 2024 07:00:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org> <20240403140116.3002809-5-vineeth@bitbyteword.org>
In-Reply-To: <20240403140116.3002809-5-vineeth@bitbyteword.org>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Mon, 8 Apr 2024 10:00:46 -0400
Message-ID: <CAO7JXPi2TkUMyhnfs+A0zSEuax2x_j4ZKm1Tcay0LiYSs6L2Sw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/5] pvsched: bpf support for pvsched
To: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Joel Fernandes <joel@joelfernandes.org>, 
	Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>, 
	David Vernet <dvernet@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Adding sched_ext folks

On Wed, Apr 3, 2024 at 10:01=E2=80=AFAM Vineeth Pillai (Google)
<vineeth@bitbyteword.org> wrote:
>
> Add support for implementing bpf pvsched drivers. bpf programs can use
> the struct_ops to define the callbacks of pvsched drivers.
>
> This is only a skeleton of the bpf framework for pvsched. Some
> verification details are not implemented yet.
>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  kernel/bpf/bpf_struct_ops_types.h |   4 +
>  virt/pvsched/Makefile             |   2 +-
>  virt/pvsched/pvsched_bpf.c        | 141 ++++++++++++++++++++++++++++++
>  3 files changed, 146 insertions(+), 1 deletion(-)
>  create mode 100644 virt/pvsched/pvsched_bpf.c
>
> diff --git a/kernel/bpf/bpf_struct_ops_types.h b/kernel/bpf/bpf_struct_op=
s_types.h
> index 5678a9ddf817..9d5e4d1a331a 100644
> --- a/kernel/bpf/bpf_struct_ops_types.h
> +++ b/kernel/bpf/bpf_struct_ops_types.h
> @@ -9,4 +9,8 @@ BPF_STRUCT_OPS_TYPE(bpf_dummy_ops)
>  #include <net/tcp.h>
>  BPF_STRUCT_OPS_TYPE(tcp_congestion_ops)
>  #endif
> +#ifdef CONFIG_PARAVIRT_SCHED_HOST
> +#include <linux/pvsched.h>
> +BPF_STRUCT_OPS_TYPE(pvsched_vcpu_ops)
> +#endif
>  #endif
> diff --git a/virt/pvsched/Makefile b/virt/pvsched/Makefile
> index 4ca38e30479b..02bc072cd806 100644
> --- a/virt/pvsched/Makefile
> +++ b/virt/pvsched/Makefile
> @@ -1,2 +1,2 @@
>
> -obj-$(CONFIG_PARAVIRT_SCHED_HOST) +=3D pvsched.o
> +obj-$(CONFIG_PARAVIRT_SCHED_HOST) +=3D pvsched.o pvsched_bpf.o
> diff --git a/virt/pvsched/pvsched_bpf.c b/virt/pvsched/pvsched_bpf.c
> new file mode 100644
> index 000000000000..b125089abc3b
> --- /dev/null
> +++ b/virt/pvsched/pvsched_bpf.c
> @@ -0,0 +1,141 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2024 Google  */
> +
> +#include <linux/types.h>
> +#include <linux/bpf_verifier.h>
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/filter.h>
> +#include <linux/pvsched.h>
> +
> +
> +/* "extern" is to avoid sparse warning.  It is only used in bpf_struct_o=
ps.c. */
> +extern struct bpf_struct_ops bpf_pvsched_vcpu_ops;
> +
> +static int bpf_pvsched_vcpu_init(struct btf *btf)
> +{
> +       return 0;
> +}
> +
> +static bool bpf_pvsched_vcpu_is_valid_access(int off, int size,
> +                                      enum bpf_access_type type,
> +                                      const struct bpf_prog *prog,
> +                                      struct bpf_insn_access_aux *info)
> +{
> +       if (off < 0 || off >=3D sizeof(__u64) * MAX_BPF_FUNC_ARGS)
> +               return false;
> +       if (type !=3D BPF_READ)
> +               return false;
> +       if (off % size !=3D 0)
> +               return false;
> +
> +       if (!btf_ctx_access(off, size, type, prog, info))
> +               return false;
> +
> +       return true;
> +}
> +
> +static int bpf_pvsched_vcpu_btf_struct_access(struct bpf_verifier_log *l=
og,
> +                                       const struct bpf_reg_state *reg,
> +                                       int off, int size)
> +{
> +       /*
> +        * TODO: Enable write access to Guest shared mem.
> +        */
> +       return -EACCES;
> +}
> +
> +static const struct bpf_func_proto *
> +bpf_pvsched_vcpu_get_func_proto(enum bpf_func_id func_id, const struct b=
pf_prog *prog)
> +{
> +       return bpf_base_func_proto(func_id);
> +}
> +
> +static const struct bpf_verifier_ops bpf_pvsched_vcpu_verifier_ops =3D {
> +       .get_func_proto         =3D bpf_pvsched_vcpu_get_func_proto,
> +       .is_valid_access        =3D bpf_pvsched_vcpu_is_valid_access,
> +       .btf_struct_access      =3D bpf_pvsched_vcpu_btf_struct_access,
> +};
> +
> +static int bpf_pvsched_vcpu_init_member(const struct btf_type *t,
> +                                 const struct btf_member *member,
> +                                 void *kdata, const void *udata)
> +{
> +       const struct pvsched_vcpu_ops *uvm_ops;
> +       struct pvsched_vcpu_ops *vm_ops;
> +       u32 moff;
> +
> +       uvm_ops =3D (const struct pvsched_vcpu_ops *)udata;
> +       vm_ops =3D (struct pvsched_vcpu_ops *)kdata;
> +
> +       moff =3D __btf_member_bit_offset(t, member) / 8;
> +       switch (moff) {
> +       case offsetof(struct pvsched_vcpu_ops, events):
> +               vm_ops->events =3D *(u32 *)(udata + moff);
> +               return 1;
> +       case offsetof(struct pvsched_vcpu_ops, name):
> +               if (bpf_obj_name_cpy(vm_ops->name, uvm_ops->name,
> +                                       sizeof(vm_ops->name)) <=3D 0)
> +                       return -EINVAL;
> +               return 1;
> +       }
> +
> +       return 0;
> +}
> +
> +static int bpf_pvsched_vcpu_check_member(const struct btf_type *t,
> +                                  const struct btf_member *member,
> +                                  const struct bpf_prog *prog)
> +{
> +       return 0;
> +}
> +
> +static int bpf_pvsched_vcpu_reg(void *kdata)
> +{
> +       return pvsched_register_vcpu_ops((struct pvsched_vcpu_ops *)kdata=
);
> +}
> +
> +static void bpf_pvsched_vcpu_unreg(void *kdata)
> +{
> +       pvsched_unregister_vcpu_ops((struct pvsched_vcpu_ops *)kdata);
> +}
> +
> +static int bpf_pvsched_vcpu_validate(void *kdata)
> +{
> +       return pvsched_validate_vcpu_ops((struct pvsched_vcpu_ops *)kdata=
);
> +}
> +
> +static int bpf_pvsched_vcpu_update(void *kdata, void *old_kdata)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static int __pvsched_vcpu_register(struct pid *pid)
> +{
> +       return 0;
> +}
> +static void __pvsched_vcpu_unregister(struct pid *pid)
> +{
> +}
> +static void __pvsched_notify_event(void *addr, struct pid *pid, u32 even=
t)
> +{
> +}
> +
> +static struct pvsched_vcpu_ops __bpf_ops_pvsched_vcpu_ops =3D {
> +       .pvsched_vcpu_register =3D __pvsched_vcpu_register,
> +       .pvsched_vcpu_unregister =3D __pvsched_vcpu_unregister,
> +       .pvsched_vcpu_notify_event =3D __pvsched_notify_event,
> +};
> +
> +struct bpf_struct_ops bpf_pvsched_vcpu_ops =3D {
> +       .init =3D &bpf_pvsched_vcpu_init,
> +       .validate =3D bpf_pvsched_vcpu_validate,
> +       .update =3D bpf_pvsched_vcpu_update,
> +       .verifier_ops =3D &bpf_pvsched_vcpu_verifier_ops,
> +       .reg =3D bpf_pvsched_vcpu_reg,
> +       .unreg =3D bpf_pvsched_vcpu_unreg,
> +       .check_member =3D bpf_pvsched_vcpu_check_member,
> +       .init_member =3D bpf_pvsched_vcpu_init_member,
> +       .name =3D "pvsched_vcpu_ops",
> +       .cfi_stubs =3D &__bpf_ops_pvsched_vcpu_ops,
> +};
> --
> 2.40.1
>

