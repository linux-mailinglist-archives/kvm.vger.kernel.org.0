Return-Path: <kvm+bounces-30633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D2A69BC569
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:29:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C98AB21CD0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B62F1DC074;
	Tue,  5 Nov 2024 06:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Obqczcc3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE69E41C69
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788144; cv=none; b=HzV52mdxZ060peohWf31VGAVS33e0x/XRSdvWBfSTOcVxshfnOSmh2WbqHLbut9WqjlrhtaAhpfsWWLTB2MXChT5JJgmKOpOIWI207YHu+mhu3Q3mswxjv2JgMkOcdTEt0HVAR58iFA2EbTWzsNgWz0NH69NthbeKZOUdDhpN8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788144; c=relaxed/simple;
	bh=gphFqUwd5XcEMAtlB2DmqPCpk350pTAPdtC6c4/+uSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P0N2VC+xzYrhqwhe4WFk/IB0MdP1O3jNbINaDFhbj0hezCuL3xFRPrsd8qJvv6LDaI/u1TrzA0J5tj3ingmcz+e6ItAxRnCZ41f6e4vWiHHxOMhw7QuqFDbrM5V3D9uI48V48rGlJAe14SJv0S3ZTrbkzYrqUdRBz2n5LYzJcf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Obqczcc3; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a4e5e57678so19761555ab.1
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 22:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1730788142; x=1731392942; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQtOen+NbViJr+rRV0Q5OmCOzg2wep+9ZhzpypOP/Zc=;
        b=Obqczcc3obmDzlw0OU759kdMK5+h9ATS3+Ojo00RQQxYlb/qJvQ8ofYMxvZKEhpxpe
         TKVKkoKmqzA6GqxzLk0u8Z1/Feh+kzInTGw7YThz9QTduTh8phbusWNpqs2AbAWfjJzs
         Bl8yIBqy9MnWeO3rc/prH3Kz1SpkK1M6UtssCMtc0tajCLk68BtzvUOyTrXg5+KfMZ7F
         FEWueOfkW+Ihv5yuX5l9Umptm3ZxhZK5qBnoVdEgSXTaWx9Yl/6bafejavKGUnLb1ovC
         xJUXzXgcjPk1zE+31uKBvLzFawDelIa++q4TDJDHKHVbcXg6TXP7btr3h6FI9n6g2k9A
         QDSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730788142; x=1731392942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JQtOen+NbViJr+rRV0Q5OmCOzg2wep+9ZhzpypOP/Zc=;
        b=l6WYDyAtWv1nB96be395UxnXgUwU9GyfBKL1M0PV1cYNjiCNKR+w/U8IyiTP98wOx1
         m0oUN2YSHFaeCNIwvLr8CuHiMNXf8NqSY4WGnFuVnF50G3vZEVwaNoevu86ulp37uu+G
         LU1p36FMFP2K0IFU6MRVZje7tDFkcigT4Ei2Nw7zJWGwiSBdDR3v5uphAm1q7oEXjCC6
         TnUSTYHAuFkTzNfMLRtF1JKDumXLl6qS9WrMNSHZQm/pj+tYvtS9Hqrk4Is7dGEf9+0S
         xHyEmzXvxZw+CbhwszPzzN4jTFEZFszL387rS14QlrYgiqrqW3qSa6HV7m+c5BGAHRsX
         vVfw==
X-Forwarded-Encrypted: i=1; AJvYcCUoc8gxetZ3jLqNiZfNhQVKhbDpKQWhaKvyTuB2L79y+wrrKAU8SgFMcW/InezkavT5Kgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoOE0bLYBROCz3hzfRZQIQHqVCFhEFJqFoOb8rhbbqCUqvWaf5
	vevLpjZqzemdZL3GHklZ4LJ0H7daXye/AO5F8DfPnkVDiSJj9tXjzTazSuoofrGnq1TtdFfqv5q
	rYPlR2qna6quLjkrNtdsYXcQSyGuEVXsuYU+WPw==
X-Google-Smtp-Source: AGHT+IHHjcyYFeTdVr47ib7/5t83JULMux12GPFjUaiweiWwMJfEa28WXKusTfsFvdHf6JwmvF7uMFZhMwNn7TEdrTo=
X-Received: by 2002:a05:6e02:111:b0:3a3:637f:1012 with SMTP id
 e9e14a558f8ab-3a6aff71b31mr120478795ab.12.1730788141919; Mon, 04 Nov 2024
 22:29:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104191503.74725-1-bjorn@kernel.org>
In-Reply-To: <20241104191503.74725-1-bjorn@kernel.org>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 5 Nov 2024 11:58:51 +0530
Message-ID: <CAAhSdy1Z93TyYrFCYw+qOHh05q0FaEPRJ=ZHf4UztUEKXuphYg@mail.gmail.com>
Subject: Re: [PATCH] riscv: kvm: Fix out-of-bounds array access
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc: Atish Patra <atishp@atishpatra.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	=?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 12:45=E2=80=AFAM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel=
.org> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
>
> In kvm_riscv_vcpu_sbi_init() the entry->ext_idx can contain an
> out-of-bound index. This is used as a special marker for the base
> extensions, that cannot be disabled. However, when traversing the
> extensions, that special marker is not checked prior indexing the
> array.
>
> Add an out-of-bounds check to the function.
>
> Fixes: 56d8a385b605 ("RISC-V: KVM: Allow some SBI extensions to be disabl=
ed by default")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
> ---
> Don't know if it matters, but I hit this when trying kvmtool.

Looks like this went unnoticed. Thanks for catching.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.13.

Thanks,
Anup

>
>
> Bj=C3=B6rn
> ---
> arch/riscv/kvm/vcpu_sbi.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 7de128be8db9..6e704ed86a83 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -486,19 +486,22 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
>         struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
>         const struct kvm_riscv_sbi_extension_entry *entry;
>         const struct kvm_vcpu_sbi_extension *ext;
> -       int i;
> +       int idx, i;
>
>         for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
>                 entry =3D &sbi_ext[i];
>                 ext =3D entry->ext_ptr;
> +               idx =3D entry->ext_idx;
> +
> +               if (idx < 0 || idx >=3D ARRAY_SIZE(scontext->ext_status))
> +                       continue;
>
>                 if (ext->probe && !ext->probe(vcpu)) {
> -                       scontext->ext_status[entry->ext_idx] =3D
> -                               KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
> +                       scontext->ext_status[idx] =3D KVM_RISCV_SBI_EXT_S=
TATUS_UNAVAILABLE;
>                         continue;
>                 }
>
> -               scontext->ext_status[entry->ext_idx] =3D ext->default_dis=
abled ?
> +               scontext->ext_status[idx] =3D ext->default_disabled ?
>                                         KVM_RISCV_SBI_EXT_STATUS_DISABLED=
 :
>                                         KVM_RISCV_SBI_EXT_STATUS_ENABLED;
>         }
>
> base-commit: 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
> --
> 2.43.0
>

