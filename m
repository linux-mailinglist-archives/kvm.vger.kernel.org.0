Return-Path: <kvm+bounces-18989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59EEE8FDD10
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 05:00:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B5141F23C5F
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 03:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D25D1E511;
	Thu,  6 Jun 2024 02:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fmoYsWao"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742B12576B;
	Thu,  6 Jun 2024 02:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717642796; cv=none; b=KCNzcWd4sluMje6sLYsUgDvxNbi50y6p5n7IIn9R/lslokbcmRUi89NkcGfDfCvKDNy5NHVZtN0t0oRyX/bfyQL5Eht9oFnQepnYw/awgZxXetmO7hIAQK+ushos/Hodr5LxRci9/7VgV6wbyuW1XR+VG7/b8AgONdKGxYPja8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717642796; c=relaxed/simple;
	bh=D+PM1z6q2o+RyHBZzRoCPsjCo6+cTA7evQ37yDCdMG8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=kaYk6vgFX9mfv3+jCrgdEiyb2hLDg/Z58bz8LsD/dq5Z5CmVIrSQ46dXn06ILp81pF3UdTPmJ7HuOGSgRobX46ID+t1cnv4BiFFMGm3WPihQd+5F+QmqvfCIpi0W8KX1t7cIPQC6fzFDOmn3IIWWxWxBfJbLRcGMKXuuWM1YCCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fmoYsWao; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70260814b2dso330870b3a.1;
        Wed, 05 Jun 2024 19:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717642795; x=1718247595; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3jY8+afNtmmEPFoRIaL0b/lBynaGm0xDlwOzJjMBvuA=;
        b=fmoYsWaocvLgUQGYopu+/qnxEm3Vrr+Gkiz21W8hc5UbYp+9P1R/0Lc+UGzhN/YS2Y
         kOzhZNoikDqpjUb8ZCd+QXtDwC8U0SxWG2nrUMsxc4dPHSfkTGTDxSzZBVB2K2Y03HJJ
         wB/myxhLi6iePYhcnO0O+9H3i52pMCjKFZ7dCdb/0ytd2uy48qbZCSH52RuVWizQCWEF
         UgFRy/xIuZqh6QvCimocP1uZ4Dj8hi7me2IZ0im7uD0XJotyYWh9kCiJZ/azkKe024qu
         zR9FRZ3k3cMI/6rqKBSSIG907zS11Rkmjvw0AlJkQrqjY3t1QM4tGi7WGlp1qxP0TaUr
         UK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717642795; x=1718247595;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3jY8+afNtmmEPFoRIaL0b/lBynaGm0xDlwOzJjMBvuA=;
        b=asW3k4T9QYURqEaeSYS8NbW71EKhNy3iA30KaztnLNXbtzsm8nFJ25kAhDklfjTPIU
         VO7Hx4ByKPVnQf1mpc6ODQhmQ83+xYAhyI7YZ0W4YskTLBez27o/hMeO+yYzfFUIPTX8
         1+UWi7TLXHdxz/7EhIbwQu4mndi8eMpFQG5VlwLRpR1Aj0TiFLv0fIPuih5tbFc1Iknu
         QGgocDvbU89kg5GxBlMA083YMYrJQsuBhln4h7RCZyi/ERI21bcnR9GCUKu9Bt3Vh4Hz
         snMrLJsZNP0riJmdhd96OX+fVVsnBHyECNs7rwf9WazDqiS7PXUvHQZP52eioW9Bj7Qa
         08cQ==
X-Forwarded-Encrypted: i=1; AJvYcCWV+4Hcgte5ljPEStC6JW/X9hWs3ABYWofK1dyRaIlXdB8F7LJtaokgdEMQtSDIvf0VhQgNSZeRcAumKShgHFWQcOozodNjx/d42rtQNIt9r1zRqARc9EkjUJvXDK0+qOi+5Qupoip/E3+I01/ZaYJQ+X9dCRqJVv/ZV1WirCvzjctPdoaInCJI+Tr9ytvs6OdTD+vm
X-Gm-Message-State: AOJu0YwwuGu0zAjbc2lGvTfLUdPgklAsv0yWwpbuS7t4O5Y7OL04G+oX
	dKiNSmL5NoQ2XEhjEfh/sQTDowi0lOOJ+ovODxv5HU5CtnO6BpGt
X-Google-Smtp-Source: AGHT+IGeGxReLLjv1l3xAEtRa/uUc17W33egwyWHjtx8sqJk8zXcVB18rtTKncsYBiCgii3UKOKbhA==
X-Received: by 2002:a05:6a20:3952:b0:1b2:c995:d1a0 with SMTP id adf61e73a8af0-1b2c995d2bbmr503189637.17.1717642794569;
        Wed, 05 Jun 2024 19:59:54 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703fd3727casm214120b3a.18.2024.06.05.19.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 19:59:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 06 Jun 2024 12:59:47 +1000
Message-Id: <D1SLJVD2W76U.3974CEMY2E585@gmail.com>
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
 <kvm@vger.kernel.org>, <stable@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] arch/powerpc/kvm: Fix doorbell emulation for v2
 API
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Gautam Menghani" <gautam@linux.ibm.com>, <mpe@ellerman.id.au>,
 <christophe.leroy@csgroup.eu>, <aneesh.kumar@kernel.org>,
 <naveen.n.rao@linux.ibm.com>, <corbet@lwn.net>
X-Mailer: aerc 0.17.0
References: <20240605113913.83715-1-gautam@linux.ibm.com>
 <20240605113913.83715-3-gautam@linux.ibm.com>
In-Reply-To: <20240605113913.83715-3-gautam@linux.ibm.com>

On Wed Jun 5, 2024 at 9:39 PM AEST, Gautam Menghani wrote:
> Doorbell emulation is broken for KVM on PAPR guests as support for
> DPDES was not added in the initial patch series. Due to this, a KVM on
> PAPR guest with SMT > 1 cannot be booted with the XICS interrupt
> controller as doorbells are setup in the initial probe path when using XI=
CS
> (pSeries_smp_probe()).
>
> Command to replicate the above bug:
>
> qemu-system-ppc64 \
> 	-drive file=3Drhel.qcow2,format=3Dqcow2 \
> 	-m 20G \
> 	-smp 8,cores=3D1,threads=3D8 \
> 	-cpu  host \
> 	-nographic \
> 	-machine pseries,ic-mode=3Dxics -accel kvm
>
> Add doorbell state handling support in the host
> KVM code to fix doorbell emulation.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

>
> Fixes: 19d31c5f1157 ("KVM: PPC: Add support for nestedv2 guests")
> Cc: stable@vger.kernel.org # v6.7
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 35cb014a0c51..21c69647d27c 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4116,6 +4116,11 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vc=
pu *vcpu, u64 time_limit,
>  	int trap;
>  	long rc;
> =20
> +	if (vcpu->arch.doorbell_request) {
> +		vcpu->arch.doorbell_request =3D 0;
> +		kvmppc_set_dpdes(vcpu, 1);
> +	}
> +
>  	io =3D &vcpu->arch.nestedv2_io;
> =20
>  	msr =3D mfmsr();


