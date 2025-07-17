Return-Path: <kvm+bounces-52733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53315B08C65
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 14:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20B323B9278
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 12:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE9829E0E5;
	Thu, 17 Jul 2025 12:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="mq3KE43u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4A029CB57
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 12:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753799; cv=none; b=aWM5Uy4Sad4Ew5N1rOVtvtURyb/HY6xQH1j98tT9Mg04riKsDiPjbfSDKTUSdJ69eAMdbQhGiyynzpaOLR58dL9YURAYmuh0irMTkGd7dFy29RDPe81VjvXq70YjugUM7AEYKsMa9UodZQW7PQEe6/0eJdHwmIYXYokHU7+l6/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753799; c=relaxed/simple;
	bh=5sUyuEyDxYzNwvF/7nF2kx8JP8Y5SfRqqnTK/JmhFx4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iJXmJJqcldb1PtNRuyeWqKpUzxcdq8CNB1Qq0LPd/xOc2wSumlGKaMaiwm3JV2Q1qpg7eXOOvRWgXf7BhZvN2mpsjkUz33qqx4JS/o95DL5VZoG9ost627yheKq+tjQhYXg/EF9Z8TE8czbUtuD7s6Kit5fkQudDZyDSsaIo4yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=mq3KE43u; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-87c04c907eeso13645939f.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 05:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752753796; x=1753358596; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MdczZfWBYlBsJGjMXmJfIpSAsQhEzzJLRKIMejj7UJA=;
        b=mq3KE43uyhw1GsptyFTVLpVa9Jhlih+m9VMpEpiZ1xVNhzKR5r+mqARyHz/vzdE2P+
         ox4CXBFfpczlr6eTRnqSRShuXFEeWRoTLohnWWTRcXM7UMwpYHFWoMwbPQWs1K6sT5BC
         hanQdTJmAxibrmv2eib/ckTIROTfzCv6X9zWb/sUXt8wZsOumYV0+240c/kkUq8bTdVI
         4HNB4NTAAR92Hcl1AmQSOALtd4XmK2AqLjKKbtOU0gv4cXK2e50hj+tA/nzmjR8nbS7z
         sCDqqNw+2/PO7RNE74IQZqf94OX92XI9+57mmsfiHx9SuFYTH/xyWhULiIZdJYv99zHn
         kLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753796; x=1753358596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MdczZfWBYlBsJGjMXmJfIpSAsQhEzzJLRKIMejj7UJA=;
        b=u2cqPhn5NAONH2l2Ef79e8W5iOqWSSOdS7qjKl5KqX7tWx/s2F0HOSYFe2YsopixkN
         IVbsNjtNWXr52x2FKFzz9nHQFimW4nyFa23Se1kMRy1u9MDLbl1v40mzuVUozchqwDng
         MHCoXhJ2b+1NT+x2X0znNH4uFx93HQ8w2Mig06WmdrOowTKLN+tJdzbvIFIC4YW6MSmD
         o/wLs2XLFUVhmeaIdu0GYAlg4WcieWybFjdOwEkFCooQCrWu5Yq3L2nW3WjU/HA9tCun
         FUtfKw6V1GnMCMhMEf0m1dU1M/Shto5gajBDpvPWa6W/p0aCdmWGotlJWF2S5EhN9ca1
         5vBQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8dVQ9zGf4c7rajHUS5TJJDM+6NQdWhk+29Z1hzyHJfHDaedVsnk4kDybDwluebe5ffmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqYGfEiIeS5HHMRMjeaEfKLo0j6PcM6IAWMuePbRV2hgQ6lmgz
	zQqflP1wp72SvT2qaLneG3ANgcKN4FBYwuw0kdeAYZ6yXvJ657Z0SPIb632EPWCzeWTKEPfua9h
	XKcYRqRYr+3Zcsk4l7/kg0M0hLAOoNX7djSPeBE1RiA==
X-Gm-Gg: ASbGncuJFIPSLeo3G/idbqn3mZcVeooZOR4KQzeQaX9veVDlsTC4WyL/oaZ2aIq7Q8c
	CcGZ9oF7iGc/Ow2q45PcPebwzDlCe6RjDfxXkCCsRFvpkkowYYy37TDcmm3W1uVzKHRdmr5LfVP
	1NX4vkULzt3YYx9mKdd0FtogJRVOpmVGdeKvBGU+btmsRNHw510cLR528sGn/VSgXgSo+Xq1LC8
	q7Kvc/gTIMrnk8=
X-Google-Smtp-Source: AGHT+IEIPZpywuhs1CvUOSh4UNExbMIYSBBP4YpBBndeSSlxDKRJE4v/uEqa/SeaPqJ739w3Q/p24P3FjwMeUrY6uKw=
X-Received: by 2002:a05:6602:6016:b0:875:bc7e:26ce with SMTP id
 ca18e2360f4ac-879c2519d3amr647026439f.0.1752753796201; Thu, 17 Jul 2025
 05:03:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <50989f0a02790f9d7dc804c2ade6387c4e7fbdbc.1749634392.git.zhouquan@iscas.ac.cn>
In-Reply-To: <50989f0a02790f9d7dc804c2ade6387c4e7fbdbc.1749634392.git.zhouquan@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 17 Jul 2025 17:33:02 +0530
X-Gm-Features: Ac12FXzaP5e6ToyKGdPw9vauuEDoz4G5gaSf7T3TkFpqI1hEBh5Tf1rGli--9AE
Message-ID: <CAAhSdy0BvhZ_TsaKEK3j+0kNQYRekVyfHOFh=eAkj2H7Znrm1g@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
To: zhouquan@iscas.ac.cn
Cc: ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025 at 3:30=E2=80=AFPM <zhouquan@iscas.ac.cn> wrote:
>
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> The caller has already passed in the memslot, and there are
> two instances `{kvm_faultin_pfn/mark_page_dirty}` of retrieving
> the memslot again in `kvm_riscv_gstage_map`, we can replace them
> with `{__kvm_faultin_pfn/mark_page_dirty_in_slot}`.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.17

Thanks,
Anup

> ---
>  arch/riscv/kvm/mmu.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 1087ea74567b..f9059dac3ba3 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -648,7 +648,8 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                 return -EFAULT;
>         }
>
> -       hfn =3D kvm_faultin_pfn(vcpu, gfn, is_write, &writable, &page);
> +       hfn =3D __kvm_faultin_pfn(memslot, gfn, is_write ? FOLL_WRITE : 0=
,
> +                               &writable, &page);
>         if (hfn =3D=3D KVM_PFN_ERR_HWPOISON) {
>                 send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
>                                 vma_pageshift, current);
> @@ -670,7 +671,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                 goto out_unlock;
>
>         if (writable) {
> -               mark_page_dirty(kvm, gfn);
> +               mark_page_dirty_in_slot(kvm, memslot, gfn);
>                 ret =3D gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHI=
FT,
>                                       vma_pagesize, false, true);
>         } else {
> --
> 2.34.1
>

