Return-Path: <kvm+bounces-38685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D5FA3D99A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:14:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 422033BD6ED
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A184D1F4E56;
	Thu, 20 Feb 2025 12:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KGq8p2Sl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100CE1F4626
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 12:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740053678; cv=none; b=Heo3eTUOK3rFYo1N+74ptE1MsYSuwnvLbsafcefv82cIaGhVs54Ke6UETWIlVRSYXXlaXOOCUIXWFCX8To+jUhY/Zf3+b3wWKe0rdjrMKyTyhVGbTn4RlK2m6qqO/57NghjAzcsHaZAYiKRgzqkmsnD9V3c7yY4efKnDv2Xc180=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740053678; c=relaxed/simple;
	bh=ZrSW3WlFsoq4+pWbmw5nXV2YhyzQXMLfxD78lA6xThE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oxyP8rzVZNuINLSYtRqShUUbf0EfottG7Pbfr8ZJzsVqn/KDf1e5tOaUkdyKero1LYinKVvahLSuiVGCxNVCI+YVMGrrDHGSUOTY7AbP0yqmr4GZGajBoge3P/+RNh2+6VY4p16/jbTb91uErSW+L1hDtu40Ve5hhENqV229JVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KGq8p2Sl; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-38f403edb4eso463695f8f.3
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 04:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1740053675; x=1740658475; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hGUCY7fitgab0ytTT0Om1EzRQzqjeCpPDOFA2YcYuWg=;
        b=KGq8p2SlE9lGyKwo4KR4SRbF18g7v3cAIylOvrFSmGGhiDQdq36duUd0DrqygZxipQ
         6C2qnAyWlcroug/Mukv4Nz1dJkFyFZs/IMeReYcLpj9zePqAuK84qIIgxaINYmsRTg/s
         6lGrNZZlzaG1wZHtNVseHA3w5Co6W/POSsYUU9mIsJEdLUlOkXyv4238DhvmNoSzg58X
         E8WqJH7Po2MjJyBz4pcsq6ldyHb/yV+lrEy/ndDwRJXD4t9qJ8E1TKVOG3SLc90WCu/l
         a6l/tvoeaeF2JdQl5/XzmnWmOc2w3ewIMN5hk3Emo9jdiCAxSZVU+F0AZThAMtJlWg/G
         5/DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740053675; x=1740658475;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hGUCY7fitgab0ytTT0Om1EzRQzqjeCpPDOFA2YcYuWg=;
        b=VBa7lDqLc4yxxwTwzPyRYGdTSE/rNzmWkAPpupPOO3IecF4hnajsFDHMi6VEL8SWOR
         Yfb+Ab6XjGbm7MMg+mGDhfp9A9H376Io2jzKgQ6GScfhKNem3GaJkQ5U3CCE+kkm+CLV
         KUW6/UAg9zWyHcOnx/3NvN8yaHFj72iSj0aSXBIAMkOm+7Y/ba8PA54rleD2JFmtgsg+
         uYAVZzTgLOeJi0XckejArZQBBrvmPlnTJ+Ocgg6023ZflLi0gQVRnYV/2ooN7NTSASyk
         hqw6VGgQBTod71ZjZgj0DtMRKwIz1owtn1ue0u9T7+EhcvSv0PpUVFXF5kDPGjvcKrbZ
         U6hg==
X-Forwarded-Encrypted: i=1; AJvYcCU5HhrwuNr4lIgDhXGP/xQcOm6b5WW84FvzJRT1loccFUTKWVJPatnlHGMItbxUOFSlSlg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRAn47Em2WR8TtoIDkLPC09qQ8qopVuZ7L2wk1+enbd5lsgRSs
	Ax2jSqHdePDGhsDglwD7eaxYolEaaCxZvdl6NezkHHff88Aml4z0MoXhLeRmOPA=
X-Gm-Gg: ASbGncvqrCrvUbZnlM/tQ4j2bDAQ/f5ZQjU+ovBpRzQsfq/joS7DzNJ2FoUSDeK509u
	vcYQ1yjyUvDNgz+zxffhSVjxtdsR1ZZrkKrPXa6RH+Gx6BrrWafIyV3VXFOSQAi0UaF/G2WET25
	Sgpo9l+XVJWCaXo01IpYr/ehz4PUzKy5YgJ052RGouw9VaXNSpXfL+CfBcVkoqLlF2uVN6Q9LFa
	28VjPECan8H7ODnTeYETIServddJUxZTZS50Y/VPPmB2uwiJhJU+qD/TTzLXlA1YRWeoqCcoBvq
	LX8=
X-Google-Smtp-Source: AGHT+IEmpbegrxw5t/KNdPkGK27oe1/PS+rd7I9A+5GvQsjNYkwQPD+h7mTbFOVdsQ9qj72tvmQ1qQ==
X-Received: by 2002:a05:6000:188c:b0:38d:d7a4:d447 with SMTP id ffacd0b85a97d-38f33f52ee9mr22748723f8f.34.1740053675184;
        Thu, 20 Feb 2025 04:14:35 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::766e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439ac276ef7sm4896085e9.40.2025.02.20.04.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 04:14:34 -0800 (PST)
Date: Thu, 20 Feb 2025 13:14:33 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: xiangwencheng <xiangwencheng@lanxincomputing.com>, anup@brainfault.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Subject: Re: [PATCH] riscv: KVM: Remove unnecessary vcpu kick
Message-ID: <20250220-1581569f8559049399549cae@orel>
References: <20250219015426.1939-1-xiangwencheng@lanxincomputing.com>
 <D7WALEFMK28X.13HQ0UL1S3NM5@ventanamicro.com>
 <38cc241c40a8ef2775e304d366bcd07df733ecf0.f7f1d4c7.545f.42a8.90f5.c5d09b1d32ec@feishu.cn>
 <20250220-f9c4c4b3792a66999ea5b385@orel>
 <38cc241c40a8ef2775e304d366bcd07df733ecf0.818d94fe.c229.4f42.a074.e64851f0591b@feishu.cn>
 <D7X576NHG512.2HBBO3JLIA1JH@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D7X576NHG512.2HBBO3JLIA1JH@ventanamicro.com>

On Thu, Feb 20, 2025 at 09:50:06AM +0100, Radim Krčmář wrote:
> 2025-02-20T16:17:33+08:00, xiangwencheng <xiangwencheng@lanxincomputing.com>:
> >> From: "Andrew Jones"<ajones@ventanamicro.com>
> >> On Thu, Feb 20, 2025 at 03:12:58PM +0800, xiangwencheng wrote:
> >> > In kvm_arch_vcpu_blocking it will enable guest external interrupt, which
> >
> >> > means wirting to VS_FILE will cause an interrupt. And the interrupt handler
> >
> >> > hgei_interrupt which is setted in aia_hgei_init will finally call kvm_vcpu_kick
> >
> >> > to wake up vCPU.
> 
> (Configure your mail client, so it doesn't add a newline between each
>  quoted line when replying.)
> 
> >> > So I still think is not necessary to call another kvm_vcpu_kick after writing to
> >> > VS_FILE.
> 
> So the kick wasn't there to mask some other bug, thanks.
> 
> >> Right, we don't need anything since hgei_interrupt() kicks for us, but if
> >> we do
> >> 
> >> @@ -973,8 +973,8 @@ int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
> >>         read_lock_irqsave(&imsic->vsfile_lock, flags);
> >> 
> >>         if (imsic->vsfile_cpu >= 0) {
> >> +               kvm_vcpu_wake_up(vcpu);
> >>                 writel(iid, imsic->vsfile_va + IMSIC_MMIO_SETIPNUM_LE);
> >> -               kvm_vcpu_kick(vcpu);
> >>         } else {
> >>                 eix = &imsic->swfile->eix[iid / BITS_PER_TYPE(u64)];
> >>                 set_bit(iid & (BITS_PER_TYPE(u64) - 1), eix->eip);
> >> 
> >> then we should be able to avoid taking a host interrupt.
> 
> The wakeup is asynchronous, and this would practically never avoid the
> host interrupt, but we'd do extra pointless work...
> I think it's much better just with the write.  (The wakeup would again
> make KVM look like it has a bug elsewhere.)

Ah yes, the wakeup is asynchronous. Just dropping the kick is the right
way to go then.

Thanks,
drew

