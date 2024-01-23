Return-Path: <kvm+bounces-6722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 219388388BB
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 09:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 981342844FA
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 08:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E46357307;
	Tue, 23 Jan 2024 08:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="aUJt7b1y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A851F60F
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 08:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705998024; cv=none; b=Z7ldLPMtdh0OrsMYFeYOT+sshnnYAdGzvCvLKtAApl+AOjr8EAwqdvSI+PwQyZzwmIbuRVVh9w8Gc9flydsOTm83QlNlODrDqdS/FS6Q2uhRZcKggVR5mcV8TEkg2lxb4RGRxDsNrK0UqBtCFB6ze5NrVZ4becPHS5XQuH/7xzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705998024; c=relaxed/simple;
	bh=IoBeLyCVS6w0i5+hrsVibh6Saqs6bSQtuS2gxTFQiLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TtTpTZ7c6+T+mY3E+gNcPpqoJ9oV2Be+sSQ/8fW9bbAH2DW5uUJkbVt9hd2g3XLbFyzM2Vz9MeMq9uRZ92bnwRZ4T/+cAUqTBOMcDHnlVYYICaf4GJnAjhFxi836OTdFK+EHaumWshJ9LOjy2UNUQLjmFDmNRov42sN8DNrpJw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=aUJt7b1y; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-55c932f7fcbso45456a12.3
        for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 00:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1705998020; x=1706602820; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jUV2ETur/YHhD2L9r2syN08M+wLYBj7G/QeHONE9k4A=;
        b=aUJt7b1y1Cv3xDD60JSrcbqpTEx6OPR0yppyAI6SyacSbrlHZCBOnFnQhFiN9IGg6L
         UodjB6q+kLfgPcIA6+knP//TGfcT4mywo+chwiFzN1lAu5ayIgU911bziC0GJzqN+7RJ
         CboiR29AChINL5pqIAEQtWcLFiEJuStPrSrf1BHwCRvcUSysb4MF0TnDHdjc+NDfZZSM
         ZHsXLf4zhTnwrqOEzdNNUym7y+PtO7yBI2YYoCVuwotxcIEGukVOIQdBzVu3TuuuRglj
         HrxRX7mn7hMCB+INEIQgnWTkHkkfyG5QNbBIgj3+TTDx7wc0qp1TTwhyaG2UvVfMz0OQ
         ZVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705998020; x=1706602820;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jUV2ETur/YHhD2L9r2syN08M+wLYBj7G/QeHONE9k4A=;
        b=VjzfaFBG2pAziMZFZCQKo9+ITOxXhejXu2dCIMnVTPXb5VNTARhAOIGSPEYVhLW/pX
         900eEpDjFNpqWL6UilC255nkK5XsXdrLTABlSvgy0JWsweTNW9+P42FTneGb+6qsuAPZ
         HJenK2Pyu3D6g/4XIe7fcDB96a7RqHXwhv/G6T/FifdarvjtrAfTDwHBCS/1EqwjjR61
         bHYt7OsjopMZSsZ7f2sd9LmAmP4cxZK8ry6QFjTNCmiHGDsfvBCoc1/O/2ngVXiSoxUg
         /4kdjsVP+EldbSP6ipG96J/BF08OI3xqwrKz7npehlR7SIgKQUv3BiNdkATK0u+JBYvs
         Xjkw==
X-Gm-Message-State: AOJu0YwU/U2sjvqk93RzccCLJ5Tzqfa/SRYLIDfVikguiQqE8jLU0Ffm
	uK7Tf2eW7rLrj7Ic8izOaFKD7Ffq4z41csueE+2h/h64+Nm7SflrUoIAriuQn7g=
X-Google-Smtp-Source: AGHT+IHrnFo96kFqXrbmtDTaJ16lW2vZWFoc71DDaTGvlSuwCuKmyi9E4Xkwwz9HfBbRN5oWg8OMmg==
X-Received: by 2002:aa7:c982:0:b0:559:3583:bb6d with SMTP id c2-20020aa7c982000000b005593583bb6dmr667767edt.32.1705998020528;
        Tue, 23 Jan 2024 00:20:20 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id ec32-20020a0564020d6000b0055c4c97b1f2sm1716628edb.91.2024.01.23.00.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 00:20:20 -0800 (PST)
Date: Tue, 23 Jan 2024 09:20:18 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, 
	Michael Rolnik <mrolnik@gmail.com>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, 
	Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Laurent Vivier <laurent@vivier.eu>, 
	Yanan Wang <wangyanan55@huawei.com>, qemu-ppc@nongnu.org, Weiwei Li <liwei1518@gmail.com>, 
	qemu-s390x@nongnu.org, =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>, 
	Peter Maydell <peter.maydell@linaro.org>, Alexandre Iooss <erdnaxe@crans.org>, 
	John Snow <jsnow@redhat.com>, Mahmoud Mandour <ma.mandourr@gmail.com>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Alistair Francis <alistair.francis@wdc.com>, 
	David Woodhouse <dwmw2@infradead.org>, Cleber Rosa <crosa@redhat.com>, Beraldo Leal <bleal@redhat.com>, 
	Bin Meng <bin.meng@windriver.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Aurelien Jarno <aurelien@aurel32.net>, Daniel Henrique Barboza <danielhb413@gmail.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Thomas Huth <thuth@redhat.com>, 
	David Hildenbrand <david@redhat.com>, qemu-riscv@nongnu.org, qemu-arm@nongnu.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Song Gao <gaosong@loongson.cn>, 
	Eduardo Habkost <eduardo@habkost.net>, Brian Cain <bcain@quicinc.com>, Paul Durrant <paul@xen.org>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: Re: [PATCH v3 01/21] hw/riscv: Use misa_mxl instead of misa_mxl_max
Message-ID: <20240123-b8d1c55688885bfc9125c42b@orel>
References: <20240122145610.413836-1-alex.bennee@linaro.org>
 <20240122145610.413836-2-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240122145610.413836-2-alex.bennee@linaro.org>

On Mon, Jan 22, 2024 at 02:55:50PM +0000, Alex Bennée wrote:
> From: Akihiko Odaki <akihiko.odaki@daynix.com>
> 
> The effective MXL value matters when booting.

I'd prefer this commit message get some elaboration. riscv_is_32bit()
is used in a variety of contexts, some where it should be reporting
the max misa.mxl. However, when used for booting an S-mode kernel it
should indeed report the effective mxl. I think we're fine with the
change, though, because at init and on reset the effective mxl is set
to the max mxl, so, in those contexts, where riscv_is_32bit() should
be reporting the max, it does.

> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> Message-Id: <20240103173349.398526-23-alex.bennee@linaro.org>
> Message-Id: <20231213-riscv-v7-1-a760156a337f@daynix.com>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  hw/riscv/boot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c
> index 0ffca05189f..bc67c0bd189 100644
> --- a/hw/riscv/boot.c
> +++ b/hw/riscv/boot.c
> @@ -36,7 +36,7 @@
>  
>  bool riscv_is_32bit(RISCVHartArrayState *harts)
>  {
> -    return harts->harts[0].env.misa_mxl_max == MXL_RV32;
> +    return harts->harts[0].env.misa_mxl == MXL_RV32;
>  }

Assuming everyone agrees with what I've written above, then maybe we
should write something similar in a comment above this function.

Thanks,
drew

