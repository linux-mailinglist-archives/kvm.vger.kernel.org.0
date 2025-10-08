Return-Path: <kvm+bounces-59649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C57BC6067
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 18:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6226D3B35A0
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 16:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B05828D82A;
	Wed,  8 Oct 2025 16:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Rl2cwk8k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD408F49
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 16:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759940954; cv=none; b=o+PfA1M02uO2BwTFKG4arG0yJg3PG2f8RFuMiGnb6s4N3QG5P5MnjsRhY8BmDtcsgrmk7b27EX5r5UxY0dXL4ySBxSa+gycg4dgTHMF2QO7J9StJaWSWJHhLQKrk9E3zETESmePnU9EiZgZ028m14NnCrN7hBhM2YfSohWAmz/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759940954; c=relaxed/simple;
	bh=XWp+yOL/raVNxjXibljA7ZwHFolC544Q9GsymtNIbRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Co7sUpWhlrJGdDzzoKnwkxb/TRCnd054ktzowJPQjLZyDvkslAoCCWU/GQ9LqZYmj3bFyfRcJVts+Zhx5ZZwXVILfYFpF/ZQYM3K1+cyJBgO9TiRZQcNGlbVS3T662Rih3t69YHXTanTznV0cdVzowgQZFY1fNVhyUzinRzdQtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Rl2cwk8k; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-92c4adc8bfeso582999539f.0
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 09:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1759940951; x=1760545751; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SGCrKoZ3SyWimYoZQ8dNyyH+rUrdr46H9MVfr0Ark48=;
        b=Rl2cwk8koquf/Gp/uHAZ2pVIlaNINgagsYcNQuWz2PDeBzi2qF1eCly0FsPdCxDPLd
         tp7ztrNSXq2/1eTes1qqBqeudcoja3TLsl881vP8p6L8MSHMmlDyngK333MuvJorDS3L
         BsSjIlsr1arnYZbRGybbKkZKbL516BjhLn/0XHkWe0bzV9Oei3wa3a2Vt66FY/oaZpfk
         K+AEu4JRC5k9WP+S+wTN2UMParpUIeu+/znxgqNCcFlXwmf9y8NI67JulkoBP30+VSXD
         NA9P4X8B4w9mLNf9oKi523jvTdifS2a3jKyTFviSSMUnkWUFWWvuxjh0minLuqI2k+jo
         sm1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759940951; x=1760545751;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SGCrKoZ3SyWimYoZQ8dNyyH+rUrdr46H9MVfr0Ark48=;
        b=IxyiEra5dSnfL1fMbqjY8dt7EWLG4W4SBuWGQpOOsGB0dXhKv2ehYXQM3MtzcBFGc4
         KgADsoEoNikPjvvzvnBThLX5qHrMUcNxLRfH3O1JUa0yrvUtz0Fsw5fg74/1GPOu3FtC
         AHTBLO2VdZjBM1S0y5wjDTGQa3PttgMyf71Ek+DynkZH2JjG6KYx0hi+Z9pea76mL83L
         psKJLk5ZViHQ9vVisCAeAcNOz0sB9zHYs2USD/cbNAmDmxPGncZnsSAh2Vv5HbFQt8S/
         HK5vsDmDhHp3DpFCtE4aqDmibhyanoUk+oCFJxUsq10TGxExzv4eChm+OkMrzvH/Lb1o
         bIeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBMPm5oTgCM+YPKfRb9UhymRF5wqgQhfAYREH3ebMMvy8Q/9qRBMvlOXBsOqcRy7xQj+o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjJbqYmMEJw5g+Q+AcXE+rN5m1dmAlwebTAF5L0PEKusyHuvyg
	YgqV1c3Uygj1+V6ip7Vk/DDCWbplauaQl7E76PKnuNiTDnzrIi90gj2b9euxgoYCAKA=
X-Gm-Gg: ASbGnctQrUvvALMQdkPV9XBTxqWS/F8XmAp4MS/hl2+LilfRMvsRNU02ZMDwJ2M+7F6
	99PPpDfZRL8PkHMQKuqadkoHqv8ySldUHUJ5aKe/a+uI47YaeOk9zpHHvGu3HlSK8jFEyzmIfRC
	DflRfHFC8HMg4EFJ7ws1WBBN6K7ScA4kn9/EKxVqckVBks+mhI0MDj6Do64lk2Ut+Z3GpPH4Evs
	L+6OxjBH8gmV5ljkThVIUqGIRbKCUtnqRMMqF4CczZTvs4/484woPn/qYzHrpmAVJCg0mHoMc4p
	3DGtv78qX42RQchcUOxvrgKfzMldBnkLhpWupA4TuUVJYCNRF2eFwpGJdfc9HwX6pALeb3TRztk
	zeGXjaYsdVamJucxmcnjjNw4yTC61VCg7MrfTIRahjMI4rGIu
X-Google-Smtp-Source: AGHT+IFnNVr7p4Ri2YprEd6Qzm6yZMtzB1axGPgJVrk5CTzM+uM6dsNRed2Gw/60wJdbFLsVj5viYg==
X-Received: by 2002:a05:6e02:178f:b0:42f:8da6:86c3 with SMTP id e9e14a558f8ab-42f8da68abamr17812185ab.2.1759940950779;
        Wed, 08 Oct 2025 09:29:10 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ea300f7sm7148800173.16.2025.10.08.09.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 09:29:10 -0700 (PDT)
Date: Wed, 8 Oct 2025 11:29:09 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-riscv@nongnu.org, kvm@vger.kernel.org, 
	Aleksandar Rikalo <arikalo@gmail.com>, Chinmay Rath <rathc@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Alistair Francis <alistair.francis@wdc.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, qemu-s390x@nongnu.org, David Hildenbrand <david@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Harsh Prateek Bora <harshpb@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Thomas Huth <thuth@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Aurelien Jarno <aurelien@aurel32.net>, Song Gao <gaosong@loongson.cn>, Weiwei Li <liwei1518@gmail.com>, 
	qemu-ppc@nongnu.org, Huacai Chen <chenhuacai@kernel.org>, 
	Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH v2 0/3] accel/kvm: Cleanups around
 kvm_arch_put_registers()
Message-ID: <20251008-3120f4e8a25446b5a05aaa7d@orel>
References: <20251008040715.81513-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251008040715.81513-1-philmd@linaro.org>

On Wed, Oct 08, 2025 at 06:07:11AM +0200, Philippe Mathieu-Daudé wrote:
> Extracted from a bigger series aiming to make accelerator
> synchronization of vcpu state slightly clearer. Here KVM
> patches around kvm_arch_put_registers():
> - Move KVM_PUT_[RESET|RUNTIME|FULL]_STATE to an enum
> - Factor common code out of kvm_cpu_synchronize_post_*()
> 
> Philippe Mathieu-Daudé (3):
>   accel/kvm: Do not expect more then KVM_PUT_FULL_STATE
>   accel/kvm: Introduce KvmPutState enum
>   accel/kvm: Factor kvm_cpu_synchronize_put() out
> 
>  include/system/kvm.h       | 16 +++++++------
>  accel/kvm/kvm-all.c        | 47 +++++++++++++++-----------------------
>  target/i386/kvm/kvm.c      |  6 ++---
>  target/loongarch/kvm/kvm.c |  8 +++----
>  target/mips/kvm.c          |  6 ++---
>  target/ppc/kvm.c           |  2 +-
>  target/riscv/kvm/kvm-cpu.c |  2 +-
>  target/s390x/kvm/kvm.c     |  2 +-
>  8 files changed, 41 insertions(+), 48 deletions(-)
> 
> -- 
> 2.51.0
> 
>

For the series,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

