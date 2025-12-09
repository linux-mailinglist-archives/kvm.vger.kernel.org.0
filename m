Return-Path: <kvm+bounces-65632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3C8CB1724
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 00:50:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B9F8430A7A31
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 23:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9082263F54;
	Tue,  9 Dec 2025 23:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zf8Pl8/L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2481A18DB37
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 23:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765324194; cv=none; b=uhHa/WteJv1LP7GNeM+1CKUALCHi0d8P/Cr8+S9EciMlloG+8aAG3YgzKx2o27uDTUoTN5H6k2eaZrMgkix0lh1/6DETud1/UVz+jZNWGYmQpMQyjJdK2L0pODv8cbHO2JwLqeV1a0SxtkC8OvbzHfMw43zjLF3HWuYeo1YSqww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765324194; c=relaxed/simple;
	bh=SMasYM4VHtyJ/mtVWXDJCQKYpFZVQuKhpSUHR985WSw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AZF5GG6tgrmbAai5lEOx89gntkQRPJQ6UYBagvu9L2oijobBKt0L4UWLHwtStI5xAUnIKV2ldCl7Kfus7fGeYllT2PsBicgnzJt7c4JDbhgVWShoRCMxxQG5T9LGgWKyHs3iuPloDqx7Er7hqlJJh/EeoagrX+Cw7IZKiJxd4rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zf8Pl8/L; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-644fbd758b3so5032a12.0
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 15:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765324190; x=1765928990; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KfhMj7u7RcZT+CWna1LSZAdEj7zgRpHjv6lSF8Cdtbk=;
        b=Zf8Pl8/L6PkzLdJiFrg/8ucgZNM5ElTTPz4NNv6jmVJklyfScdoNAoxmwcSKdJLDfS
         tTpyO+D0cSysUUnQLUxrmTYsv/Cc5V4fDggFSh7yX4o9AJ7XTzUJfIriUQPvmkCsSgs9
         RZlbZDCizqpi3t8kYVDz76MPOe4G+N1GTzE5AixYO4Tf1ArfvzqedTdL2fBAl8XzO3Re
         ysFdxjzcPXexlAz9imMxaiLTWvy0WHxDd+xI4dFMZzt0OmDUU3pwCMTeVgwJfTDyqtbG
         07gWp+6DxmRaeO52cqQoXnaOwHmAf+3lmYe2+QMdKCTpv9SaCnG4/WjN6FLf4euaBrVa
         a9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765324190; x=1765928990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KfhMj7u7RcZT+CWna1LSZAdEj7zgRpHjv6lSF8Cdtbk=;
        b=AcogE3F1H1RemiJBG8DW9Xot/0bzDM1wIND80BEWVk78uacnz2uLKHKy0aVeW7vR9z
         NYkgC1b4dobYcV0tx03M/Z3gF6RvwAoTZ3TwU9g2zPSP5yCA3sY5s19zbePrX2y2bjfQ
         M1TfLmJ3bqQgfKNwep2cwyJZqfp/BJZcom4twCrbVeJJ7cJxJQX5cpec5maMw3rJSQGm
         cC/HSRXncuGBbPFTLKKuUaoPcOUHLSk3d2+twurAVdo1h9DdHSUNueiP7uuoZth7y1nA
         pBBpZx3GgC/VPW2WMxF/qA9O6yK2qvqSryqQ4f4KwIEcijBeDgxPGwblQ4oVggXH8gIk
         Jv6A==
X-Forwarded-Encrypted: i=1; AJvYcCXxg5qCbZDScLv6jcza2kOZ43QiRi7qkOwFfoX8WIjOx5JW/yoGykI5qsXlNZpNcN0d7Dg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHF9AnSPq4/tJfqI/DUKva9c45jj9AzMSQhBUpBdvrlHuRL+gN
	No1wjc2h4Pm9Ed/i1znsIV7SQ0Il0vMhjTbZr7KXuxyMnbbyBOw51i1vm9HhuRjAjF6XUpuT6SB
	BijkgY/b9SoFeJi1taPySpDtMW+tFljCucFOxiytf
X-Gm-Gg: AY/fxX7FUFcpqojZDHGeJjbex6AJbfX3IauAeEf5SvQBFu1M9qXxMI6D9OPpsVdKi05
	tgQ7txVgYkGFiODlrUtxjizgauYqfXnv0vuQGVhvTfkVKeHO0cU6dQnCqVCayqlDi5C5KZ3HDNe
	1Cy6jJVIUUsvF4HzGU9kR99HtmwczmUR8S5En7pUSYjcyKdQmXrR2ZdJraPL5Fuq0j1m1gqayKZ
	5tgSANyxRR8+0+cxm/n4CaAcWnDgHQ7qdEY1DgUBxZ1liqbQHumV2MkK+pWn+UBWgRu0420ww/V
	jsKd7TaasQkZgGtrkvvTau28xbk=
X-Google-Smtp-Source: AGHT+IGwCmZ3pScrAeXOzfY1hBr894O4gg1Ot3tiaCX2WS8gGUikFmrG0hQlUfryRFHi1HRtfAXGIZmDKngUx0DyRaI=
X-Received: by 2002:aa7:d58e:0:b0:645:21c1:97e1 with SMTP id
 4fb4d7f45d1cf-6496c43155bmr18281a12.18.1765324190201; Tue, 09 Dec 2025
 15:49:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094333.4579-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094333.4579-1-yan.y.zhao@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 9 Dec 2025 17:49:37 -0600
X-Gm-Features: AQt7F2r1b6zmH25HxCtVpdaDNbAR8PSU_BuyaxYk58kz61fg948Nf68OnM2D1Pc
Message-ID: <CAAhR5DGNXi2GeBBZUoZOac6a7_bAquUOzBJuccbeJZ1r97f0Ag@mail.gmail.com>
Subject: Re: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kas@kernel.org, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vannapurve@google.com, vbabka@suse.cz, 
	thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com, 
	fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 7, 2025 at 4:44=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> Implement the split_external_spt hook to enable huge page splitting for
> TDX when kvm->mmu_lock is held for writing.
>
> Invoke tdh_mem_range_block(), tdh_mem_track(), kicking off vCPUs,
> tdh_mem_page_demote() in sequence. All operations are performed under
> kvm->mmu_lock held for writing, similar to those in page removal.
>
> Even with kvm->mmu_lock held for writing, tdh_mem_page_demote() may still
> contend with tdh_vp_enter() and potentially with the guest's S-EPT entry
> operations. Therefore, kick off other vCPUs and prevent tdh_vp_enter()
> from being called on them to ensure success on the second attempt. Use
> KVM_BUG_ON() for any other unexpected errors.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> RFC v2:
> - Split out the code to handle the error TDX_INTERRUPTED_RESTARTABLE.
> - Rebased to 6.16.0-rc6 (the way of defining TDX hook changes).
>
> RFC v1:
> - Split patch for exclusive mmu_lock only,
> - Invoke tdx_sept_zap_private_spte() and tdx_track() for splitting.
> - Handled busy error of tdh_mem_page_demote() by kicking off vCPUs.
> ---
>  arch/x86/kvm/vmx/tdx.c | 45 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 376287a2ddf4..8a60ba5b6595 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1915,6 +1915,50 @@ static int tdx_sept_free_private_spt(struct kvm *k=
vm, gfn_t gfn,
>         return 0;
>  }
>
> +static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
> +                                       enum pg_level level, struct page =
*page)
> +{
> +       int tdx_level =3D pg_level_to_tdx_sept_level(level);
> +       struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> +       gpa_t gpa =3D gfn_to_gpa(gfn);
> +       u64 err, entry, level_state;
> +
> +       err =3D tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
> +                                 &entry, &level_state);
> +
> +       if (unlikely(tdx_operand_busy(err))) {

I was trying to test this code locally (without the DPAMT patches and
with DPAMT disabled) and saw that sometimes tdh_mem_page_demote
returns TDX_INTERRUPTED_RESTARTABLE. Looking at the TDX module code
(version 1.5.16 from [1]) I see that demote and promote are the only
seamcalls that return TDX_INTERRUPTED_RESTARTABLE so it wasn't handled
by KVM until now.

I added manual handling for it and it's working correctly. Note that
my change is on top of a rebase to the latest version:

@@ -1989,9 +1989,16 @@ static int tdx_spte_demote_private_spte(struct
kvm *kvm, gfn_t gfn,
        struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
        gpa_t gpa =3D gfn_to_gpa(gfn);
        u64 err, entry, level_state;
+       int i =3D 0;

-       err =3D tdh_do_no_vcpus(tdh_mem_page_demote, kvm, &kvm_tdx->td, gpa=
,
+       while (i < TDX_SEAMCALL_RETRIES) {
+               err =3D tdh_do_no_vcpus(tdh_mem_page_demote, kvm,
&kvm_tdx->td, gpa,
                              tdx_level, page, &entry, &level_state);
+               if (err !=3D TDX_INTERRUPTED_RESTARTABLE)
+                       break;
+               i++;
+       }
+
        if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_DEMOTE, entry, level_state, kvm)=
)
                return -EIO;

[1] https://github.com/intel/confidential-computing.tdx.tdx-module

> +               tdx_no_vcpus_enter_start(kvm);
> +               err =3D tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level,=
 page,
> +                                         &entry, &level_state);
> +               tdx_no_vcpus_enter_stop(kvm);
> +       }
> +
> +       if (KVM_BUG_ON(err, kvm)) {
> +               pr_tdx_error_2(TDH_MEM_PAGE_DEMOTE, err, entry, level_sta=
te);
> +               return -EIO;
> +       }
> +       return 0;
> +}
> +
> +static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum p=
g_level level,
> +                                     void *private_spt)
> +{
> +       struct page *page =3D virt_to_page(private_spt);
> +       int ret;
> +
> +       if (KVM_BUG_ON(to_kvm_tdx(kvm)->state !=3D TD_STATE_RUNNABLE ||
> +                      level !=3D PG_LEVEL_2M, kvm))
> +               return -EINVAL;
> +
> +       ret =3D tdx_sept_zap_private_spte(kvm, gfn, level, page);
> +       if (ret <=3D 0)
> +               return ret;
> +
> +       tdx_track(kvm);
> +
> +       return tdx_spte_demote_private_spte(kvm, gfn, level, page);
> +}
> +
>  static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>                                         enum pg_level level, kvm_pfn_t pf=
n)
>  {
> @@ -3668,5 +3712,6 @@ void __init tdx_hardware_setup(void)
>         vt_x86_ops.set_external_spte =3D tdx_sept_set_private_spte;
>         vt_x86_ops.free_external_spt =3D tdx_sept_free_private_spt;
>         vt_x86_ops.remove_external_spte =3D tdx_sept_remove_private_spte;
> +       vt_x86_ops.split_external_spt =3D tdx_sept_split_private_spt;
>         vt_x86_ops.protected_apic_has_interrupt =3D tdx_protected_apic_ha=
s_interrupt;
>  }
> --
> 2.43.2
>
>

