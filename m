Return-Path: <kvm+bounces-34550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52899A0100C
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 23:00:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C8221884714
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 22:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F13541C07E4;
	Fri,  3 Jan 2025 22:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XqGSTniL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0D61BEF9D
	for <kvm@vger.kernel.org>; Fri,  3 Jan 2025 22:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735941607; cv=none; b=rngqvO7pTJDx1h1dWo7X5hAxGhutqHUqYpzTDKD7zk2HJu+UFivgk+dtV0l8ErLOxKY8YcgsKJbtzAA3LwXQ+irEdz/70mFuhERt8Se2EYS47jDn/R+ovxpc8aGnUsL+/6muTRrq84l8eIvR/+VICpWbhUiAAxpFiC/tLlk81xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735941607; c=relaxed/simple;
	bh=CBUuDM25gS/vXuOOyso/PsyOQL0PDPbnfd0g+i1dmGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=intCTndVOfNNUO8akXW6wB84D5vlr5uSEfEkqdInz/Y8NQQBgRGdIVuBZBzMTYS8unen4W8gh0IsuX7HErQyGFnQFoUSwwJn8sUSvXNrFvM+O+kigW2FO1KJv2hGbEh0lEa1wS0j4owJAoSUpzdUD+cWGn9saCjqD9OyXZkaic4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XqGSTniL; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5401af8544bso161e87.1
        for <kvm@vger.kernel.org>; Fri, 03 Jan 2025 14:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1735941604; x=1736546404; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mvAb13sq2N2Qx9NMHm0zKSINIzK22dh5svmzy5MUnw=;
        b=XqGSTniLRV8hyDqR1+GmL8PUKKdkg1MHtgGFVsEYILAxj8BZGBzOBjDNOKaHzozD7T
         K6WJyb0hzPjk2oAzdrCW/q2PX5WfTanmY6DYltODNl3LHQ9kYGB/VswB3dv6/MVAD5+s
         HsKFBJnTNf00nchT4+tKqp5CmTx2rKemKU8qV+H8DRqOAG8PjFBcKpmdn+1kJOoGbYGF
         Dc4mz0qO9FaxJiqU6KdhraRj9z+uz5cws3dXyvFs2e8R/NBj8YmX68/6V4U3tAo3WgZ6
         kkE7Nhq/S0PpuTNVQRlZ3AQtFRjCA1Voxx9Pr/VS6cT9JRrpJkQaklR5oH6nvjT42W9A
         wvug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735941604; x=1736546404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6mvAb13sq2N2Qx9NMHm0zKSINIzK22dh5svmzy5MUnw=;
        b=udH3IaiSE8wvWNxnFDh7+LNJO2PiLJGEN0m3xbv6F8XpebQGqD0chjVoYrfsRQE+WW
         XwXr7oIX8JaBr/vaLw3/xnc/AfyudCFzGquxAqUFJbtf5NXSkWWE2e+ViU721VJJ+0xF
         AKxJDpw6vXwQGGzF26MtZGr8k8mrZBtB7QuhTbXL1uPbgopWFIY0OpykWLaCk/xZdbd0
         mFYb9qvp60tB+az/8nods4CkTzYsQ5nhgCI3IjtMa+1B21I8n6nem1gr7kVK33rUz6l7
         +83FuwBTmBNV4emGrbQ34/NWNtIxDD1Emyxj6t9lnvsFfd5x7gl+G7flCNVRo99NZweC
         UTEA==
X-Forwarded-Encrypted: i=1; AJvYcCUXWGrUDE35zJJFFZLuzqNz/swottXsREqJP7esVgTXlP8Zv0XyEJVUK7JKKU2eI6ASb9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgJIgP4AL/QyeuX0Vchtt6Sel/2YhKK54szUTPYvYxc2TK04cd
	OR8lmowcL9BKAE71GNBDrq6TLheAm66b6uLXqyiu2dOglScM9zBzWkyhlDnJdWsQ5xEVYEC5Lhk
	uUxlM9YG9lnizF+1ZA9tzMsMGBHrMk4KVkHTi
X-Gm-Gg: ASbGncs0vHQVdxqKDk8Uxylh08psCkG+biIZSvpLdy8qXSstu5puDd9lZjUIN0CukFj
	gRnVzgdJ52xnCzuPHZE6KthovWtdPtrRIP0pjUGHRbCnyEEFyQt8MYhRp/Rv/COS8
X-Google-Smtp-Source: AGHT+IHbWhYZMZQkohLCw2u3xciHyZGuZFp74THZMbBT0Z/EKJaz4FMWHIdCeTTMoELd8FaAMpbPmbRKSkplTr0rTl8=
X-Received: by 2002:a05:6512:1327:b0:53d:dcde:395a with SMTP id
 2adb3069b0e04-542701b2678mr35732e87.2.1735941603397; Fri, 03 Jan 2025
 14:00:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com> <20241209010734.3543481-13-binbin.wu@linux.intel.com>
In-Reply-To: <20241209010734.3543481-13-binbin.wu@linux.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 3 Jan 2025 13:59:52 -0800
X-Gm-Features: AbW1kva2tEiWa7B75qtGJrbMFSpdDmI9yiG5r84ZoGde73NaYY3g9_sgrymVhNQ
Message-ID: <CAGtprH9UBZe64zay0HjZRg5f--xM85Yt+jYijKZw=sfxRH=2Ow@mail.gmail.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com, 
	chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 8, 2024 at 5:11=E2=80=AFPM Binbin Wu <binbin.wu@linux.intel.com=
> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Inhibit APICv for TDX guest in KVM since TDX doesn't support APICv access=
es
> from host VMM.
>
> Follow how SEV inhibits APICv.  I.e, define a new inhibit reason for TDX,=
 set
> it on TD initialization, and add the flag to kvm_x86_ops.required_apicv_i=
nhibits.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> TDX interrupts breakout:
> - Removed WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm)) in
>   tdx_td_vcpu_init(). (Rick)
> - Change APICV -> APICv in changelog for consistency.
> - Split the changelog to 2 paragraphs.
> ---
>  arch/x86/include/asm/kvm_host.h | 12 +++++++++++-
>  arch/x86/kvm/vmx/main.c         |  3 ++-
>  arch/x86/kvm/vmx/tdx.c          |  3 +++
>  3 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 32c7d58a5d68..df535f08e004 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1281,6 +1281,15 @@ enum kvm_apicv_inhibit {
>          */
>         APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
>
> +       /*********************************************************/
> +       /* INHIBITs that are relevant only to the Intel's APICv. */
> +       /*********************************************************/
> +
> +       /*
> +        * APICv is disabled because TDX doesn't support it.
> +        */
> +       APICV_INHIBIT_REASON_TDX,
> +
>         NR_APICV_INHIBIT_REASONS,
>  };
>
> @@ -1299,7 +1308,8 @@ enum kvm_apicv_inhibit {
>         __APICV_INHIBIT_REASON(IRQWIN),                 \
>         __APICV_INHIBIT_REASON(PIT_REINJ),              \
>         __APICV_INHIBIT_REASON(SEV),                    \
> -       __APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
> +       __APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED),     \
> +       __APICV_INHIBIT_REASON(TDX)
>
>  struct kvm_arch {
>         unsigned long n_used_mmu_pages;
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 7f933f821188..13a0ab0a520c 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -445,7 +445,8 @@ static int vt_gmem_private_max_mapping_level(struct k=
vm *kvm, kvm_pfn_t pfn)
>          BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |                   \
>          BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |        \
>          BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |           \
> -        BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED))
> +        BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |         \
> +        BIT(APICV_INHIBIT_REASON_TDX))
>
>  struct kvm_x86_ops vt_x86_ops __initdata =3D {
>         .name =3D KBUILD_MODNAME,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b0f525069ebd..b51d2416acfb 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2143,6 +2143,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td=
_params *td_params,
>                 goto teardown;
>         }
>
> +       kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_TDX);
> +
>         return 0;
>
>         /*
> @@ -2528,6 +2530,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, =
u64 vcpu_rcx)
>                 return -EIO;
>         }
>
> +       vcpu->arch.apic->apicv_active =3D false;

With this setting, apic_timer_expired[1] will always cause timer
interrupts to be pending without injecting them right away. Injecting
it after VM exit [2] could cause unbounded delays to timer interrupt
injection.

[1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/lapic=
.c?h=3Dkvm-coco-queue#n1922
[2] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/x86.c=
?h=3Dkvm-coco-queue#n11263

>         vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNABLE;
>
>         return 0;
> --
> 2.46.0
>
>

