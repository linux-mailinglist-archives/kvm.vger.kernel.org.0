Return-Path: <kvm+bounces-6812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8438683A3E0
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 09:17:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A945A1C24976
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A88D17555;
	Wed, 24 Jan 2024 08:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="lVfdRf/V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B419417543
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 08:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706084216; cv=none; b=fDpbXVMXsYf+K46SJbvQHbtJMjjnn/i7NMzpKC9/4q66iED0lv10rUjLzaUJhSUYdRsKBJ9yuGSjFs3UjO0mygBDxSCE35vlSj1FBUsHx152raW8eTpYIA1RNJArHkfIsN9eKA48tV+vHHS2F+CvZsrmseuRVwkpQ3wgjlS4Ptw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706084216; c=relaxed/simple;
	bh=wQwAysdMYq7R9f4iL6Oq440NlYtvoluMuswmk4iwbX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIamfn6qF2S2yH600TR4vSE6NXfGcdOOGHW1tS3amQLEeiUbOSyqCEQ6ph322vi7W8IkqAQ3TemVXixW+t9Qj2J2kKAM6UH595kjySePZxsldUnas8MayGyDfF5J6hORz9791wQ2p5XnzZz1y/qHR9/0krTuyiE2KPSc7z3lnQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=lVfdRf/V; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a30d2bd22e7so129318966b.0
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 00:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1706084213; x=1706689013; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9sXg36sUep+N61vSnj8FOK4eOgfj23LfuaYjihRPx9s=;
        b=lVfdRf/VO+9X38XYwNnputITzP5CgKeEqqk5FqXE0few14nNM9pR2u/jeUHxbBghhc
         e+dy6ARDiUnVgT5TPmxxDD+zH2wNjBT3YhceFFC/dkUQG3J2JHcxvgYhYnfkYztW9cUt
         Jv0v97KSzWw9RLivfBpmffLvJI2fmm+Oh7K8SGKvLBNSv0Zg+8psMZIx+PlzgqDVJYlL
         xvw9XqCgUci5flAt9lknIK2QvxRaeOTbNZapji59sp2ipiAQ2k4LOU+l+VUvA3AmRKve
         5IXdlSDDKCrVf4HNoZrAefRqFjffEThRX89nUf4E2VuJCNuJDe9li/rnEYpoWiEHKaPc
         tFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706084213; x=1706689013;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9sXg36sUep+N61vSnj8FOK4eOgfj23LfuaYjihRPx9s=;
        b=A6osM4PSXOLOCk++Up8x3AdKs+2GSb51pbKXaz9QLwYEH4SVlMBCccwLPbkkmJVoVH
         kyTxxXnFXHkZMQi6H6d3Rawnf0U/2MZ5edy6GRmtAKULrMaDnijg+epjt+cWa1ZyuNAg
         QTpyojJ0WLyN1tS9MQKrGZoAZ7P6boBMwpS9w5Trrr2S0iEAc/CI99fwexwShLvEjZWx
         i02cCgPsW1q2Kt/gfFVgrwjoBr/1DqBE6SRhGbNgu0rEatTOZTb7GKQKCZQit1KDPN1z
         zog+F9Xv3eyYrGqoDHi7TT4lGLQzgr7ZdfqSrOyqNXPQ7KeBGBD5FRQvR0NwYJ0RPSVo
         h0qg==
X-Gm-Message-State: AOJu0YyX3G+aZWQ2USHQyZB2hQwFZDb8XmYT913+HaLWK24v/2swlNyJ
	jYUCrhzCV6p8Hcgx+Jxvh6RNcQwxQNz9Lxt0qgVvzKgOUUY+lGwfTEt0GE48SQM=
X-Google-Smtp-Source: AGHT+IGDg1ZQqdXZKs3GCQc5JFbRDXhgLr6ZlGiNbTZRR/B1PaEq7yGPv5awPONM0W1s3+iCwea/Kw==
X-Received: by 2002:a17:906:9c91:b0:a31:2905:5dca with SMTP id fj17-20020a1709069c9100b00a3129055dcamr247199ejc.53.1706084212585;
        Wed, 24 Jan 2024 00:16:52 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id mn6-20020a1709077b0600b00a2ccddf9a7dsm13874643ejc.124.2024.01.24.00.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 00:16:52 -0800 (PST)
Date: Wed, 24 Jan 2024 09:16:51 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, 
	qemu-devel@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
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
	Eduardo Habkost <eduardo@habkost.net>, Brian Cain <bcain@quicinc.com>, Paul Durrant <paul@xen.org>
Subject: Re: Re: [PATCH v3 01/21] hw/riscv: Use misa_mxl instead of
 misa_mxl_max
Message-ID: <20240124-3d9bec68bff7ab0057b902b6@orel>
References: <20240122145610.413836-1-alex.bennee@linaro.org>
 <20240122145610.413836-2-alex.bennee@linaro.org>
 <20240123-b8d1c55688885bfc9125c42b@orel>
 <15d2f958-a51e-4b87-9a70-28edf3b55491@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15d2f958-a51e-4b87-9a70-28edf3b55491@daynix.com>

On Wed, Jan 24, 2024 at 12:08:33PM +0900, Akihiko Odaki wrote:
> On 2024/01/23 17:20, Andrew Jones wrote:
> > On Mon, Jan 22, 2024 at 02:55:50PM +0000, Alex Bennée wrote:
> > > From: Akihiko Odaki <akihiko.odaki@daynix.com>
> > > 
> > > The effective MXL value matters when booting.
> > 
> > I'd prefer this commit message get some elaboration. riscv_is_32bit()
> > is used in a variety of contexts, some where it should be reporting
> > the max misa.mxl. However, when used for booting an S-mode kernel it
> > should indeed report the effective mxl. I think we're fine with the
> > change, though, because at init and on reset the effective mxl is set
> > to the max mxl, so, in those contexts, where riscv_is_32bit() should
> > be reporting the max, it does.
> > 
> > > 
> > > Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> > > Message-Id: <20240103173349.398526-23-alex.bennee@linaro.org>
> > > Message-Id: <20231213-riscv-v7-1-a760156a337f@daynix.com>
> > > Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> > > ---
> > >   hw/riscv/boot.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c
> > > index 0ffca05189f..bc67c0bd189 100644
> > > --- a/hw/riscv/boot.c
> > > +++ b/hw/riscv/boot.c
> > > @@ -36,7 +36,7 @@
> > >   bool riscv_is_32bit(RISCVHartArrayState *harts)
> > >   {
> > > -    return harts->harts[0].env.misa_mxl_max == MXL_RV32;
> > > +    return harts->harts[0].env.misa_mxl == MXL_RV32;
> > >   }
> > 
> > Assuming everyone agrees with what I've written above, then maybe we
> > should write something similar in a comment above this function.
> > 
> > Thanks,
> > drew
> 
> The corresponding commit in my series has a more elaborated message:
> https://patchew.org/QEMU/20240115-riscv-v9-0-ff171e1aedc8@daynix.com/20240115-riscv-v9-1-ff171e1aedc8@daynix.com/

I've pulled the message from that link and quoted it below

> A later commit requires one extra step to retrieve misa_mxl_max. As
> misa_mxl is semantically more correct and does not need such a extra
> step, refer to misa_mxl instead. Below is the explanation why misa_mxl
> is more semantically correct to refer to than misa_mxl_max in this case.
> 
> Currently misa_mxl always equals to misa_mxl_max so it does not matter

That's true, but I think that's due to a bug in write_misa(), which
shouldn't be masking val with the extension mask until mxl has been
extracted.

> which of misa_mxl or misa_mxl_max to refer to. However, it is possible
> to have different values for misa_mxl and misa_mxl_max if QEMU gains a
> new feature to load a RV32 kernel on a RV64 system, for example. For
> such a behavior, the real system will need the firmware to switch MXL to
> RV32, and if QEMU implements the same behavior, mxl will represent the
> MXL that corresponds to the kernel being loaded. Therefore, it is more
> appropriate to refer to mxl instead of misa_mxl_max when
> misa_mxl != misa_mxl_max.

Right, but that doesn't say anything more than the original one line,
"The effective MXL value matters when booting."

What I'm looking for is a code comment explaining how riscv_is_32bit()
is always safe to use. Something like

 /*
  * Checking the effective mxl is always correct, because the effective
  * mxl will be equal to the max mxl at initialization and also on reset,
  * which are the times when it should check the maximum mxl. Later, if
  * firmware writes misa with a smaller mxl, then that mxl should be
  * used in checks.
  */

Thanks,
drew

