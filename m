Return-Path: <kvm+bounces-18988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC328FDD0B
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 04:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACEDE284971
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 02:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CAA81E51F;
	Thu,  6 Jun 2024 02:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVLH2zpI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB341C69A;
	Thu,  6 Jun 2024 02:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717642784; cv=none; b=ECc2CplLSx/XTzWrVrbUndTDAFELe50J8+7x7nbTlGFUfBCJdfQ9NQ2I6d7p1X6e4fE3dbdsdJJCzIzNbg5G9+RhJ6btYQdUelCs6hvR7Tvi/ABNw9uC9G1qOqY/va3iJAbgzS1LRkJOw71OaMPTBx98qWJLaO1QUSkMf31XoG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717642784; c=relaxed/simple;
	bh=dmH5V+cKL2wu81gjyiWlJg3dRjq8qDUh4x3UsIopgjk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Tj19bQuuPBdfgP7RNpJ7CkarElVnTrzwH5SIcWikSsEuLTbWSK/Z5JN0/v0qJYRHhPkMBkaymYYDSiSW2qUedqY/bvw/zuWV5riraYH88bJC9c6M89R4DL8jpfacRhiEfnqP/J3oj7h1Y3DJbOaxv3xgKpVpdhxzC75qkf4QWTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVLH2zpI; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-702442afa7dso422559b3a.2;
        Wed, 05 Jun 2024 19:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717642782; x=1718247582; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vz1XSlT9oUSSTzN4cS11/Lx6KgX+Uz7+KxDJeBD1O6M=;
        b=AVLH2zpIadRd/dzV19usykX5tg2f5NHHkHhBOoAFFP90RFzIC8sHuoakaHy7rVLeht
         4xUintGCzcEwIHfCtiwgSfjE+p8zaYSVozuit7DuiLi8GwkVQSBY53hQP0IAybxcpW+Z
         gHwZQmbrFhQmDtANeMvld0l92pO2XFj9nJGmP2ROWVMrTSyN7Gk2LG+DxwlX3Fiskg3+
         H6tTK8XII8bx0tsOC/cazru/wpZ3qKaoeDo9vtNndjPS+q8CHsQ/184q9MqXiuV+UowR
         G0JphjwzuK6kQ/Yc7U9eMfNF2X7a1pafk4Ns9P/VQgtwrr9Ja/9KTEwHvwN5Uf5UjZ2L
         R76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717642782; x=1718247582;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vz1XSlT9oUSSTzN4cS11/Lx6KgX+Uz7+KxDJeBD1O6M=;
        b=ihaTeR6wynKM4PnK7V7lfPDFbxx7anZ4MHq/mSVHVeR+F4sJX/jRBFl6dh3uz5dMRz
         /OEKwVK9R/GfrWWXH9No1sk8GyRrE05hZ8wXvBO+3aqmYMW4NMVufU/BMDQBnz56vWXF
         VzZmpOeaxquGaazsrji2Bq13y42es5v3GDfxRjMedbLq1zXrA4D8R+LqHmXYiEmSzOIK
         FkcG432D/+Yh+L9O/Hqq/q3l9zMpZvvMBoYKDmw8PhHnInR+2UXIugD9O00eGDbr6RhK
         ZcTOfpRrjAuouXY9XmfaeQTv2Wu9ULSx7q29JowvxTmQSd+DoiZ9l7VbJ802b5iqKgk2
         1xGw==
X-Forwarded-Encrypted: i=1; AJvYcCXa7fOK/lTZprZydf2QmJ0sKABsNL9Kv3pHpFW3SYgK1VZ+aD/VK1Jbg+AKuv9j2WcP07d1z1I9/6ydpIfr7sxwS/gNRbuwnsx9TQjWy82yTWk7T4yjEI3oBdB/NqFc0npmXqHcFoO3AIy3rDmjUWugZaQEIRgv4VW5a4WutWZjmobJjoXDdKY5peoIxkbG7Um2Umzo
X-Gm-Message-State: AOJu0YzAMKufRSh7bR1YBFnrPz842bTFnvAEA7uYiNsGtvKnGX7TqMi9
	bcueNRocwTErMvVp7qY+ejl1rC4DKF0hnO2UnGcHcsEaiRvq5CHhveyKrA==
X-Google-Smtp-Source: AGHT+IEqs9EFID6KLRdH9JJgQcWIVOz6IZJBIwvKeto3Qx5Yrb/TMfE+Sb8RlX8Xf8sRjAx27+M+Ig==
X-Received: by 2002:a05:6a00:a27:b0:6ea:afdb:6d03 with SMTP id d2e1a72fcca58-703e59824efmr4635464b3a.19.1717642782042;
        Wed, 05 Jun 2024 19:59:42 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703fd39a806sm205312b3a.80.2024.06.05.19.59.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 19:59:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 06 Jun 2024 12:59:34 +1000
Message-Id: <D1SLJP7L3EAY.2RKINBPUUGM5A@gmail.com>
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
 <kvm@vger.kernel.org>, <stable@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] arch/powerpc/kvm: Add DPDES support in helper
 library for Guest state buffer
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Gautam Menghani" <gautam@linux.ibm.com>, <mpe@ellerman.id.au>,
 <christophe.leroy@csgroup.eu>, <aneesh.kumar@kernel.org>,
 <naveen.n.rao@linux.ibm.com>, <corbet@lwn.net>
X-Mailer: aerc 0.17.0
References: <20240605113913.83715-1-gautam@linux.ibm.com>
 <20240605113913.83715-2-gautam@linux.ibm.com>
In-Reply-To: <20240605113913.83715-2-gautam@linux.ibm.com>

On Wed Jun 5, 2024 at 9:39 PM AEST, Gautam Menghani wrote:
> Add support for using DPDES in the library for using guest state
> buffers. DPDES support is needed for enabling usage of doorbells in a=20
> L2 KVM on PAPR guest.
>

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> Fixes: 6ccbbc33f06a ("KVM: PPC: Add helper library for Guest State Buffer=
s")
> Cc: stable@vger.kernel.org # v6.7
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
>  Documentation/arch/powerpc/kvm-nested.rst     | 4 +++-
>  arch/powerpc/include/asm/guest-state-buffer.h | 3 ++-
>  arch/powerpc/include/asm/kvm_book3s.h         | 1 +
>  arch/powerpc/kvm/book3s_hv_nestedv2.c         | 7 +++++++
>  arch/powerpc/kvm/test-guest-state-buffer.c    | 2 +-
>  5 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/arch/powerpc/kvm-nested.rst b/Documentation/ar=
ch/powerpc/kvm-nested.rst
> index 630602a8aa00..5defd13cc6c1 100644
> --- a/Documentation/arch/powerpc/kvm-nested.rst
> +++ b/Documentation/arch/powerpc/kvm-nested.rst
> @@ -546,7 +546,9 @@ table information.
>  +--------+-------+----+--------+----------------------------------+
>  | 0x1052 | 0x08  | RW |   T    | CTRL                             |
>  +--------+-------+----+--------+----------------------------------+
> -| 0x1053-|       |    |        | Reserved                         |
> +| 0x1053 | 0x08  | RW |   T    | DPDES                            |
> ++--------+-------+----+--------+----------------------------------+
> +| 0x1054-|       |    |        | Reserved                         |
>  | 0x1FFF |       |    |        |                                  |
>  +--------+-------+----+--------+----------------------------------+
>  | 0x2000 | 0x04  | RW |   T    | CR                               |
> diff --git a/arch/powerpc/include/asm/guest-state-buffer.h b/arch/powerpc=
/include/asm/guest-state-buffer.h
> index 808149f31576..d107abe1468f 100644
> --- a/arch/powerpc/include/asm/guest-state-buffer.h
> +++ b/arch/powerpc/include/asm/guest-state-buffer.h
> @@ -81,6 +81,7 @@
>  #define KVMPPC_GSID_HASHKEYR			0x1050
>  #define KVMPPC_GSID_HASHPKEYR			0x1051
>  #define KVMPPC_GSID_CTRL			0x1052
> +#define KVMPPC_GSID_DPDES			0x1053
> =20
>  #define KVMPPC_GSID_CR				0x2000
>  #define KVMPPC_GSID_PIDR			0x2001
> @@ -110,7 +111,7 @@
>  #define KVMPPC_GSE_META_COUNT (KVMPPC_GSE_META_END - KVMPPC_GSE_META_STA=
RT + 1)
> =20
>  #define KVMPPC_GSE_DW_REGS_START KVMPPC_GSID_GPR(0)
> -#define KVMPPC_GSE_DW_REGS_END KVMPPC_GSID_CTRL
> +#define KVMPPC_GSE_DW_REGS_END KVMPPC_GSID_DPDES
>  #define KVMPPC_GSE_DW_REGS_COUNT \
>  	(KVMPPC_GSE_DW_REGS_END - KVMPPC_GSE_DW_REGS_START + 1)
> =20
> diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include=
/asm/kvm_book3s.h
> index 3e1e2a698c9e..10618622d7ef 100644
> --- a/arch/powerpc/include/asm/kvm_book3s.h
> +++ b/arch/powerpc/include/asm/kvm_book3s.h
> @@ -594,6 +594,7 @@ static inline u##size kvmppc_get_##reg(struct kvm_vcp=
u *vcpu)		\
> =20
> =20
>  KVMPPC_BOOK3S_VCORE_ACCESSOR(vtb, 64, KVMPPC_GSID_VTB)
> +KVMPPC_BOOK3S_VCORE_ACCESSOR(dpdes, 64, KVMPPC_GSID_DPDES)
>  KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(arch_compat, 32, KVMPPC_GSID_LOGICAL_PV=
R)
>  KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(lpcr, 64, KVMPPC_GSID_LPCR)
>  KVMPPC_BOOK3S_VCORE_ACCESSOR_SET(tb_offset, 64, KVMPPC_GSID_TB_OFFSET)
> diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/boo=
k3s_hv_nestedv2.c
> index 8e6f5355f08b..36863fff2a99 100644
> --- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
> +++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> @@ -311,6 +311,10 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_g=
s_buff *gsb,
>  			rc =3D kvmppc_gse_put_u64(gsb, iden,
>  						vcpu->arch.vcore->vtb);
>  			break;
> +		case KVMPPC_GSID_DPDES:
> +			rc =3D kvmppc_gse_put_u64(gsb, iden,
> +						vcpu->arch.vcore->dpdes);
> +			break;
>  		case KVMPPC_GSID_LPCR:
>  			rc =3D kvmppc_gse_put_u64(gsb, iden,
>  						vcpu->arch.vcore->lpcr);
> @@ -543,6 +547,9 @@ static int gs_msg_ops_vcpu_refresh_info(struct kvmppc=
_gs_msg *gsm,
>  		case KVMPPC_GSID_VTB:
>  			vcpu->arch.vcore->vtb =3D kvmppc_gse_get_u64(gse);
>  			break;
> +		case KVMPPC_GSID_DPDES:
> +			vcpu->arch.vcore->dpdes =3D kvmppc_gse_get_u64(gse);
> +			break;
>  		case KVMPPC_GSID_LPCR:
>  			vcpu->arch.vcore->lpcr =3D kvmppc_gse_get_u64(gse);
>  			break;
> diff --git a/arch/powerpc/kvm/test-guest-state-buffer.c b/arch/powerpc/kv=
m/test-guest-state-buffer.c
> index 4720b8dc8837..2571ccc618c9 100644
> --- a/arch/powerpc/kvm/test-guest-state-buffer.c
> +++ b/arch/powerpc/kvm/test-guest-state-buffer.c
> @@ -151,7 +151,7 @@ static void test_gs_bitmap(struct kunit *test)
>  		i++;
>  	}
> =20
> -	for (u16 iden =3D KVMPPC_GSID_GPR(0); iden <=3D KVMPPC_GSID_CTRL; iden+=
+) {
> +	for (u16 iden =3D KVMPPC_GSID_GPR(0); iden <=3D KVMPPC_GSE_DW_REGS_END;=
 iden++) {
>  		kvmppc_gsbm_set(&gsbm, iden);
>  		kvmppc_gsbm_set(&gsbm1, iden);
>  		KUNIT_EXPECT_TRUE(test, kvmppc_gsbm_test(&gsbm, iden));


