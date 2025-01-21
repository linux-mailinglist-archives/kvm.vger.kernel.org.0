Return-Path: <kvm+bounces-36084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CAC1A176EB
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 06:20:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D770A3A740A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 05:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21771A76D0;
	Tue, 21 Jan 2025 05:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbkzDqmW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ABAA41;
	Tue, 21 Jan 2025 05:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737436825; cv=none; b=rQPzXzkz3/bhi0+eX+lA/lE/cVbGdPiNeK44nfHtKa/mvTanh7QeZYqQ4jfdCd4VsAkK3axdMzH/b6v+DhYKrg+qLr5OSxsqmaBv9upqY65hZAXrJwb19vtuwAAG4XZtu5OVSp9Xu0y2Y9h6aZ2Ysn3yOyeiM0Jw1t4LWUivUaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737436825; c=relaxed/simple;
	bh=eKOK2EO91ur0UC7MMxZ4derhiPJDvIpQSa4AutwErLQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=cKYAvlFqaFDoR1gOCCqdlhG5OFgCLHYnsK/aLAVrSYCL3ueD+OfHXi5Nq5rCHeQmeuw5++gtzyni/FecY3vE03Wg8oxerA4rX93fKJZe+Z9V5k4rx3ifXk/Kq4fPz+H7PBO3xhZbJMPZHo00ZtwT7BaZYEup2CKdiEurvOfdPu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WbkzDqmW; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2f44353649aso6989565a91.0;
        Mon, 20 Jan 2025 21:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737436824; x=1738041624; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IECYlM40D+zruDOMOUzD+1MoRjtsBCDwEaB3RwH3myQ=;
        b=WbkzDqmWfg5jlxgvf+jUeDC8gbUHrARlzbWZSCDpX7oXrcLp4ktmQsMZU+kOo4SBdu
         qytqnEK6B7Y+sEFzDTcmSxz7mhlrD111a7Cb0mlMVG7HYI3hFrUg++6j8y6XKA3hpUtf
         RJL2Rtn+VnU6lKo5dpvooUO+Z6/HuUnu5+aQrKPZb20yDgs/TJuwzOdx27AedHds+KzR
         bh+/Cd4qayOF8rm4FtBfnRgIMCdnU3zfnK0RGnCBIQj0c7Yfa3tvS+SIJ32dErx6YOge
         NaIId42q45Upt9RMTskCGAF65z0VGKOE/TtTF4RADimYgnTDjiEDcdDmlmpqYPRYTCvO
         zrmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737436824; x=1738041624;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IECYlM40D+zruDOMOUzD+1MoRjtsBCDwEaB3RwH3myQ=;
        b=aAy+qdxG3FSfUg5VnZAL192B5twMQiRAPwyL1pm7AjC5NBSdrtZKeefSLDbM/L1slp
         RW5BQaMsyfg6Jt8slCSi5SypNqb+DGvFfyV3s0Sikzo95Y5NRl9hgXWKFN3oMhUr1Hxa
         dd9P67NsAiHTka8rYNkYVBYyYXzRnax4JPhes0D4ZOZUHuwQVF6AM8nf5bqGD4z/n2S3
         zsG0Fow8JEi79i/RY9JUw6ayMsPvcLrD3Pyk3ULyHqwcoTDTYaTkNyex3TGPHU1g03rk
         AtLBqRn5sOnV13MPjKoekU6NwMg1EwUJE6tFOSJnHSxrPirmewGuzasy+ybUMJ4QDLLf
         R9MA==
X-Forwarded-Encrypted: i=1; AJvYcCV6nfVx//T5VgEeAuvKfllawcsvMW6955QllDHLDmbAHX+LVPr/YtZJliJftQ+WLsY5moWTEFuN@vger.kernel.org, AJvYcCViT75QgJ5scJQU5Qq95/5M4a6UHOwNS+x2qHwYnRdyKg8mFX+t9l6GF3Dy9FUk5JfaPJUN0CWLIky2ppOO@vger.kernel.org, AJvYcCXP11L5zBCTyYcsVfb/7kRhfJcPJEDrOHD1I9IRVdCVmpy9jFr6aFxSskACeoQY8g4w77A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaFuCv+fGhp6ANnDmpkMIXjbuTBCZDzh2QzX/BBIsJhS1fLw1i
	56HOjEG+TQi3G2BBfa4YsyAp8RtUqlhtIDrAufCopiHjEgNyhSECOYTarg==
X-Gm-Gg: ASbGncvedI0AVrfq3Hkdvr7yU2qLFXxOPtkDcgRv6Kcm7BaYEE+GX8wjfjNt9Ltu6R8
	/bVgxo8YeiKef2/lcjOyP6hJG4iu2NVJ7fRqlDCcbXt2P/hQogYtAPwjtB0kfjFPrp67zcwItFL
	TjNXHdnx5+4wG0V3EWwIhhuaQ/WUf4whltP3c7zKTIYXeQrf14AQLx2yXGGIv3SY6rC74Rf0PR7
	tN02CxC0JRUdltfuzb8IR3VCiw/rBYsYLpZT5aJCyxnTaxn4/7GIhoL4wd1Mf9L
X-Google-Smtp-Source: AGHT+IGa3qnJZ7ymaxLp0C027bTDyMwNmCEpA39KybaLiQC4CMLlAIO95Bkd2Ge8d/PPw9qHJOVgMQ==
X-Received: by 2002:a17:90b:3503:b0:2ee:9d65:65a7 with SMTP id 98e67ed59e1d1-2f782d7ff77mr21978137a91.29.1737436823682;
        Mon, 20 Jan 2025 21:20:23 -0800 (PST)
Received: from localhost ([138.44.251.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f72c2bb332sm13067266a91.36.2025.01.20.21.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 21:20:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 21 Jan 2025 15:20:17 +1000
Message-Id: <D77HY793RN09.1HTCXBIUXFKSI@gmail.com>
Cc: <seanjc@google.com>, <linuxppc-dev@lists.ozlabs.org>,
 <regressions@lists.linux.dev>, "Christian Zigotzky"
 <chzigotzky@xenosoft.de>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/5] KVM: e500: always restore irqs
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Paolo Bonzini" <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>
X-Mailer: aerc 0.19.0
References: <20250112095527.434998-1-pbonzini@redhat.com>
 <20250112095527.434998-2-pbonzini@redhat.com>
In-Reply-To: <20250112095527.434998-2-pbonzini@redhat.com>

On Sun Jan 12, 2025 at 7:55 PM AEST, Paolo Bonzini wrote:
> If find_linux_pte fails, IRQs will not be restored.  This is unlikely
> to happen in practice since it would have been reported as hanging
> hosts, but it should of course be fixed anyway.
>
> Cc: stable@vger.kernel.org
> Reported-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  arch/powerpc/kvm/e500_mmu_host.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu=
_host.c
> index e5a145b578a4..6824e8139801 100644
> --- a/arch/powerpc/kvm/e500_mmu_host.c
> +++ b/arch/powerpc/kvm/e500_mmu_host.c
> @@ -479,7 +479,6 @@ static inline int kvmppc_e500_shadow_map(struct kvmpp=
c_vcpu_e500 *vcpu_e500,
>  		if (pte_present(pte)) {
>  			wimg =3D (pte_val(pte) >> PTE_WIMGE_SHIFT) &
>  				MAS2_WIMGE_MASK;
> -			local_irq_restore(flags);
>  		} else {
>  			local_irq_restore(flags);
>  			pr_err_ratelimited("%s: pte not present: gfn %lx,pfn %lx\n",
> @@ -488,8 +487,9 @@ static inline int kvmppc_e500_shadow_map(struct kvmpp=
c_vcpu_e500 *vcpu_e500,
>  			goto out;
>  		}
>  	}
> +	local_irq_restore(flags);
> +
>  	writable =3D kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
> -
>  	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
>  				ref, gvaddr, stlbe);
> =20


