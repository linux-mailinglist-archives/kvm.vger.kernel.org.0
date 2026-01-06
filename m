Return-Path: <kvm+bounces-67097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5381ECF6B69
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 05:58:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6DE01306F8EB
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 04:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3DF2C08AC;
	Tue,  6 Jan 2026 04:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Ss7ckk8R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B9D2BF002
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 04:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767675408; cv=none; b=WfUmQIgiB35Bgmj5A/JnymjQLEPl3hdFOciSJSsH6sZ9yCC+1TstKHG8CcgnJgoqtPDnzannOEppMlu/nHaqeznc84j5vJEVB0DVkzfksuPAzw8p8IN6QPKLJSFPJSo5EIaEKRiQHFnnKB+8q0UTp7qD6Z7V8kBUFmmqinZlVJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767675408; c=relaxed/simple;
	bh=bPMuOyUg+pCFEpuN7CwHcwhs5rNIMbrQeGA0HQmyckk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nd9rCv63PHB/EnEXS+kcorLB2lScediOAR+Q6DOAPED1WUJrIOu+PLTCjbmhnk0Ex2LQ1oHcHVQaxjQq+dB1+s/k25YIg6Ii1aw76F0cxjCof0HL8mQerJpdeY3hQS3X2UZSDr1sxoxPD+ofw5Haaw19uxOJ4UU/sr++NAFlTGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Ss7ckk8R; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-65ec86c5e70so373962eaf.3
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 20:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1767675406; x=1768280206; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bXCgyGXdfFw2jhIVzlU19gmITjYf/onAsSkhutvgS3M=;
        b=Ss7ckk8RVUlxwrFyuqelWPLqIIJuk2Uj4IEjWUM8dXuPOkWWm+lixB4Muz12tiyLpz
         mH4Vap32W+6b6n/STLcTzIjbzDLaNbuiPZCTCRxGrpbFOQJCn1ZCkEZ7UbWgPQhtnw8B
         oXpSumQ1Yeu/eSGxc5lYEgzDskB7hoTS0SMh5PbOGqICGpJP6+kmy0264h1lfjUv10B8
         qA62nRtRXUYA/ElO5yxDxVyWo2HgxNSGMFKoMiTrA9jAeoe5mjKnHjy41nFUnD1Df5/N
         aIdq/HaNUaJJ62hgsfOMcg+OWc5Xva5wuuO5pfe4/OfigXsOFHkOEuO8NTE04Fv8SXyG
         8QFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767675406; x=1768280206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bXCgyGXdfFw2jhIVzlU19gmITjYf/onAsSkhutvgS3M=;
        b=Pqt/yyp7PhEVaD0vVacIcdzmpLcENxT/CA6AIgM6ofUlGlOleHgOryfx7PxCekRWMp
         Xi9Ys96vd3R9APXRIzL5hMIA7NEyX/11EFXYWS9S4fZlsPs0Qv41GcIr21HV1yRhO9+v
         12DTTegFLvCRPZaS1jbr4G3N1KfH+Z1rXYVePADPESAeJ+hudU11VyLZvqr2X37CjXt+
         8uxpNf0mmpyau2etQ8QHtAwzNcZ7TEdnCtv+xoUHO8Rh6pdr3fiO0suNQ76wgCIB09nr
         KwOg5WSGt721VCwFwSN6/dNqvXKXBNhgH45Worhq1TWd2ZoJClZ82i36PYYPiqUouT7J
         b3Pg==
X-Forwarded-Encrypted: i=1; AJvYcCWgNCfXXhpQndNMHucL6xZ0L2YqePRRB0Yfj1Ur2RK5O4G/uk7TgHQoLHlLfPMWZCy8HNo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0Rl5pOdQsffIO0TrBsi8Kro4QEe3GylnBNJWLwF7vjaagqNVj
	VfK1NyNAqtEz0ZGPiJ39UDLl7wUEB7go9SxsmX47bNHcY27hM9tM2Z4EmyuX3b+7yBZSVR60SIj
	VI86S3ZkmYGSH+h7cnNh9a2Lnw2hqlakzHikbQWrrMg==
X-Gm-Gg: AY/fxX7WAtF26KaPsJB5EsH+rlIIyBDko9wIR187nP0eFi5Q46fPJDKbuDunOoq+DGW
	ADb/5XlMMM2sQR6KiM9iT3sgjK4pO8i+PcM+qkal0/DkgBSz62IeYO9PR9imxnARVdEjN5tlpLo
	NqRFNeBo9G7erSTWWRMxamhRlrCbFLzbOf0zBygkzI1T/cRbQ2w+U5CgFWO2DW8DHl4onWbpbJk
	Ptns4P07gt4fquJVoBpCKWXW31Wy+MzU/3nJWy9rroKA0siEjmA2gytOrSIQ3gHT7l0G7SfhQ3C
	kpALKaWK+UWNm6ZA6XNYyXYmflY+SZTVmlLa9r2mNUlxOuh0aVIsWoFOEA==
X-Google-Smtp-Source: AGHT+IGq83xsWiBnk8S8Wan7SqZp6GnFrv0pdr0Nor1LjDGkvPMfuowdAk7rc0hTsmwGhsAqXr8Xk0551qnx4JMiq/Y=
X-Received: by 2002:a05:6820:2202:b0:65e:f37f:93a4 with SMTP id
 006d021491bc7-65f479d332fmr1135768eaf.8.1767675405972; Mon, 05 Jan 2026
 20:56:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020042904.32096-1-luxu.kernel@bytedance.com>
In-Reply-To: <20251020042904.32096-1-luxu.kernel@bytedance.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 6 Jan 2026 10:26:34 +0530
X-Gm-Features: AQt7F2rV_3WZCrB_VJwYGn79psT6Smtly97t591oPSUibomNxLFKeK19i9dMZfQ
Message-ID: <CAAhSdy3M8NMF0ojJdoSvtate6FRjS5hno2Wc5i=TeCF84yOK3Q@mail.gmail.com>
Subject: Re: [PATCH v4 10/10] RISC-V: KVM: selftests: Add Zalasr extensions to
 get-reg-list test
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: corbet@lwn.net, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, robh@kernel.org, krzk+dt@kernel.org, 
	conor+dt@kernel.org, will@kernel.org, peterz@infradead.org, 
	boqun.feng@gmail.com, mark.rutland@arm.com, atish.patra@linux.dev, 
	pbonzini@redhat.com, shuah@kernel.org, parri.andrea@gmail.com, 
	ajones@ventanamicro.com, brs@rivosinc.com, guoren@kernel.org, 
	linux-doc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	apw@canonical.com, joe@perches.com, lukas.bulwahn@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 9:59=E2=80=AFAM Xu Lu <luxu.kernel@bytedance.com> w=
rote:
>
> The KVM RISC-V allows Zalasr extensions for Guest/VM so add these
> extensions to get-reg-list test.
>
> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.20

Thanks,
Anup


> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/tes=
ting/selftests/kvm/riscv/get-reg-list.c
> index a0b7dabb50406..3020e37f621ba 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -65,6 +65,7 @@ bool filter_reg(__u64 reg)
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZAAMO:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZABHA:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZACAS:
> +       case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZALASR:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZALRSC:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZAWRS:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZBA:
> @@ -517,6 +518,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg=
_off)
>                 KVM_ISA_EXT_ARR(ZAAMO),
>                 KVM_ISA_EXT_ARR(ZABHA),
>                 KVM_ISA_EXT_ARR(ZACAS),
> +               KVM_ISA_EXT_ARR(ZALASR),
>                 KVM_ISA_EXT_ARR(ZALRSC),
>                 KVM_ISA_EXT_ARR(ZAWRS),
>                 KVM_ISA_EXT_ARR(ZBA),
> @@ -1112,6 +1114,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(svvptc, SVVPTC);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zaamo, ZAAMO);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zabha, ZABHA);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zacas, ZACAS);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zalasr, ZALASR);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zalrsc, ZALRSC);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zawrs, ZAWRS);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zba, ZBA);
> @@ -1187,6 +1190,7 @@ struct vcpu_reg_list *vcpu_configs[] =3D {
>         &config_zabha,
>         &config_zacas,
>         &config_zalrsc,
> +       &config_zalasr,
>         &config_zawrs,
>         &config_zba,
>         &config_zbb,
> --
> 2.20.1
>

