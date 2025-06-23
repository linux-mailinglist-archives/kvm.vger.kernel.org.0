Return-Path: <kvm+bounces-50417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1DF5AE4E39
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 22:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA4D43AFEEA
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 20:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE1D2D543A;
	Mon, 23 Jun 2025 20:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tSnvRcZf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA872D4B68
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 20:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750711226; cv=none; b=BlMYMCPHz5YvVKLb4tRJ+pWroJbmxeXr7RBTsdRec9AMXER+YFJEWl6Y94jKxA3NXMlmdc6RsdNhsTuSaBh+mUTZXcQtEzA26kxd40CDKx4qROgS7cFqtyrOgAwGSVaG2XWBk6JFlQlONwmKNw0PyjQXsLcgtC2/gab5lXZrcME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750711226; c=relaxed/simple;
	bh=Zhuvl4KnS3oB7uKqYBHpHRfcybkMRxnNYJ+NQXkoFBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AiU9O8hMF3+tNcZnVwkLYsSHxoq8urhl2AYgSY2XsSOv5dEi9TQke/DOqbr9EFHa+iUmVi4yFLT0565D4yjMmPRnb/PypRWbcO9oy7jBmvuCVuIJjwq+2ctfturLYFa7TwSjYyp8GIzG642mk8SR6qH0OdOyTUchpK4GnJJAN9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tSnvRcZf; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-237f270513bso15285ad.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750711224; x=1751316024; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQPU1jwDqaIvFAqHZbhsvjmULs6RRSSTDERPy7mYC/w=;
        b=tSnvRcZf1UYOSdfNDgYvjIr8QqP9/W8ScMdiHp4mjaWsd9PSSaiSEbL5pBk2zdhqPK
         9LJCxrLbnrbx7+WoFWIVt+l3j2V6WKGy1yvCMK8MuJHC7oyIz8GT8qhGfVKTRYEjgznc
         czAxGfl7RvQASP5GJeoaQItK7ZcaRLmAgMAc+OH+mp0LDbEGcP5lnnRzdVmHE40bXRyr
         CMc524T79E+UYhB3Yd+WLgJDHn1dsbLrmQyrLsI0q3RiAj3yZ7rnRacRQoUvPS6RX4EV
         kNOisVN3kCoRdVR/ylfPQUdCfnZQc6JCJHNzY1UJeCz4u9xtoEgsGN1AnEznIdXCGOaM
         OCaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750711224; x=1751316024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HQPU1jwDqaIvFAqHZbhsvjmULs6RRSSTDERPy7mYC/w=;
        b=XAt5vo+PwGBMSYUpVwc+EGuYauZoKhr/Lu+fPy8OpazrreOQGFlHwB+4RmEVZqMeF3
         QFCKvg2ivOo4sqA3LV1T8MLTBocRIKsfaoqV4ymJ7VX7FWICxG/T361rLh3ZluMBA2gM
         4A+h6nO5XtgkANEsVER6xxvfLZP7ZWyjhLWUb2Vbjibwwd98VzFqi7nUQpDtBIwDSCfT
         zNeRn03AfQmhi2ERbhwW4eggYnAkmGdhMPeVctcS83/gjicO/RzijdD9+kEo3XzfTu0S
         CvKPyxeRbYEuJl7JPrYUWF0gDxN+M1IyN+TZzh1KeSK8wEBD6836vN4yNyWG58nJTXXA
         vqFg==
X-Forwarded-Encrypted: i=1; AJvYcCVnd1MAZJQybOdYmjVkssEOzRVmhlhdbJBUUS5JxkNg6kFSt//OMjkeIquvo17btixQJSU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUnvpEFvUc0PUrE/TPbGPx7IZhSVYkYTgl7Dsx+1KRgxx/o2NP
	txVnTZT/yTJqndMnuaOPta25gO6sxm5epUdhQNdcflkXoAPFsz0QV/vp2h7nixXBpNXWI59uDFU
	XJ9GE09JvGAE5PbarFucrKXrBs9rq43cH+A542L8a
X-Gm-Gg: ASbGncsX8PpPkghL3HgynYsRkt/JHKs6Z97tB31U309i2A80dbBgrBjnyWLAEMvIQnQ
	zrGg8kHGf2PjX59CklOT6ek0cSPP5SHrat3OT6JWh+ugOs+t8mz9FF4TRa2vdTaqQWHOEs6vNJ8
	D2oL+h4U//EWldoYHZ8l6xOOHeIEC/X+WKEFu5KYZyWi0joJeRiJ58QHjRu3r7P3jcmTZQtRB7i
	oZv1NpcRD8=
X-Google-Smtp-Source: AGHT+IFUHKxNUZ3MwYjq/wkDI3kUu/0SCAMOAElnU/6pCk2jEVzxFHLOd5NxdmYdVQHL1UJZyG8hqjuVYY6Eb3+e7tY=
X-Received: by 2002:a17:903:1c1:b0:223:ff93:322f with SMTP id
 d9443c01a7336-23802b63e09mr728085ad.2.1750711223886; Mon, 23 Jun 2025
 13:40:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com> <20250611095158.19398-2-adrian.hunter@intel.com>
In-Reply-To: <20250611095158.19398-2-adrian.hunter@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 23 Jun 2025 13:40:10 -0700
X-Gm-Features: AX0GCFuPFZd1yMYIv9481hq8QdvlFhQ_xbq_lUsfcqcvZ9md8c33VovBY0efJaM
Message-ID: <CAGtprH989TDzAyQntYjU8sTC3J_VNbNQg6dx_BzENNqXdRKs2A@mail.gmail.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025 at 2:52=E2=80=AFAM Adrian Hunter <adrian.hunter@intel.=
com> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Add sub-ioctl KVM_TDX_TERMINATE_VM to release the HKID prior to shutdown,
> which enables more efficient reclaim of private memory.
>
> Private memory is removed from MMU/TDP when guest_memfds are closed. If
> the HKID has not been released, the TDX VM is still in RUNNABLE state,
> so pages must be removed using "Dynamic Page Removal" procedure (refer
> TDX Module Base spec) which involves a number of steps:
>         Block further address translation
>         Exit each VCPU
>         Clear Secure EPT entry
>         Flush/write-back/invalidate relevant caches
>
> However, when the HKID is released, the TDX VM moves to TD_TEARDOWN state
> where all TDX VM pages are effectively unmapped, so pages can be reclaime=
d
> directly.
>
> Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
> reclaim time.  For example:
>
>         VCPUs   Size (GB)       Before (secs)   After (secs)
>          4       18               72             24
>         32      107              517            134
>         64      400             5539            467
>
> Link: https://lore.kernel.org/r/Z-V0qyTn2bXdrPF7@google.com
> Link: https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>
>
> Changes in V4:
>
>         Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
>         Use KVM_BUG_ON() instead of WARN_ON().
>         Correct kvm_trylock_all_vcpus() return value.
>
> Changes in V3:
>
>         Remove KVM_BUG_ON() from tdx_mmu_release_hkid() because it would
>         trigger on the error path from __tdx_td_init()
>
>         Put cpus_read_lock() handling back into tdx_mmu_release_hkid()
>
>         Handle KVM_TDX_TERMINATE_VM in the switch statement, i.e. let
>         tdx_vm_ioctl() deal with kvm->lock
>
>
>  Documentation/virt/kvm/x86/intel-tdx.rst | 16 +++++++++++
>  arch/x86/include/uapi/asm/kvm.h          |  1 +
>  arch/x86/kvm/vmx/tdx.c                   | 34 ++++++++++++++++++------
>  3 files changed, 43 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/vir=
t/kvm/x86/intel-tdx.rst
> index de41d4c01e5c..e5d4d9cf4cf2 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -38,6 +38,7 @@ ioctl with TDX specific sub-ioctl() commands.
>            KVM_TDX_INIT_MEM_REGION,
>            KVM_TDX_FINALIZE_VM,
>            KVM_TDX_GET_CPUID,
> +          KVM_TDX_TERMINATE_VM,
>
>            KVM_TDX_CMD_NR_MAX,
>    };
> @@ -214,6 +215,21 @@ struct kvm_cpuid2.
>           __u32 padding[3];
>    };
>
> +KVM_TDX_TERMINATE_VM
> +-------------------
> +:Type: vm ioctl
> +:Returns: 0 on success, <0 on error
> +
> +Release Host Key ID (HKID) to allow more efficient reclaim of private me=
mory.
> +After this, the TD is no longer in a runnable state.
> +
> +Using KVM_TDX_TERMINATE_VM is optional.
> +
> +- id: KVM_TDX_TERMINATE_VM
> +- flags: must be 0
> +- data: must be 0
> +- hw_error: must be 0
> +
>  KVM TDX creation flow
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  In addition to the standard KVM flow, new TDX ioctls need to be called. =
 The
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/=
kvm.h
> index 6f3499507c5e..697d396b2cc0 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -940,6 +940,7 @@ enum kvm_tdx_cmd_id {
>         KVM_TDX_INIT_MEM_REGION,
>         KVM_TDX_FINALIZE_VM,
>         KVM_TDX_GET_CPUID,
> +       KVM_TDX_TERMINATE_VM,
>
>         KVM_TDX_CMD_NR_MAX,
>  };
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b952bc673271..457f91b95147 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -515,6 +515,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>                 goto out;
>         }
>
> +       write_lock(&kvm->mmu_lock);
>         for_each_online_cpu(i) {
>                 if (packages_allocated &&
>                     cpumask_test_and_set_cpu(topology_physical_package_id=
(i),
> @@ -539,7 +540,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>         } else {
>                 tdx_hkid_free(kvm_tdx);
>         }
> -
> +       write_unlock(&kvm->mmu_lock);
>  out:
>         mutex_unlock(&tdx_lock);
>         cpus_read_unlock();
> @@ -1789,13 +1790,13 @@ int tdx_sept_remove_private_spte(struct kvm *kvm,=
 gfn_t gfn,
>         struct page *page =3D pfn_to_page(pfn);
>         int ret;
>
> -       /*
> -        * HKID is released after all private pages have been removed, an=
d set
> -        * before any might be populated. Warn if zapping is attempted wh=
en
> -        * there can't be anything populated in the private EPT.
> -        */
> -       if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
> -               return -EINVAL;
> +       if (!is_hkid_assigned(to_kvm_tdx(kvm))) {
> +               KVM_BUG_ON(!kvm->vm_dead, kvm);
> +               ret =3D tdx_reclaim_page(page);
> +               if (!ret)
> +                       tdx_unpin(kvm, page);
> +               return ret;
> +       }
>
>         ret =3D tdx_sept_zap_private_spte(kvm, gfn, level, page);
>         if (ret <=3D 0)
> @@ -2790,6 +2791,20 @@ static int tdx_td_finalize(struct kvm *kvm, struct=
 kvm_tdx_cmd *cmd)
>         return 0;
>  }
>
> +static int tdx_terminate_vm(struct kvm *kvm)
> +{
> +       if (kvm_trylock_all_vcpus(kvm))
> +               return -EBUSY;
> +
> +       kvm_vm_dead(kvm);
> +
> +       kvm_unlock_all_vcpus(kvm);
> +
> +       tdx_mmu_release_hkid(kvm);
> +
> +       return 0;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_tdx_cmd tdx_cmd;
> @@ -2817,6 +2832,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp=
)
>         case KVM_TDX_FINALIZE_VM:
>                 r =3D tdx_td_finalize(kvm, &tdx_cmd);
>                 break;
> +       case KVM_TDX_TERMINATE_VM:
> +               r =3D tdx_terminate_vm(kvm);
> +               break;
>         default:
>                 r =3D -EINVAL;
>                 goto out;
> --
> 2.48.1
>
>

Acked-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Vishal Annapurve <vannapurve@google.com>

