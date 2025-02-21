Return-Path: <kvm+bounces-38848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A62AA3F2D9
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 12:21:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1536C7ACC95
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 11:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511F2209F3B;
	Fri, 21 Feb 2025 11:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BG8jRtix"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DDE20767A
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 11:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740136829; cv=none; b=mgKSJERXzKvfWjRjD6346KVJ4hBM7OxUtXSEK3SkUbqXWNxQbI8SUNTGHn/0//QPD8HnwpNIDRjfXPl+9rU2GRSIpsjSB6Nm+tF4uF/Ew1FOLzP5zZByNr1V65ixVuDDyZca2KOqTr8qYE0i+heyWMK9SkZPA7EONaTnEcr2m9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740136829; c=relaxed/simple;
	bh=/pbYDQsdMkkBtnnoTRy7xBhScDSjhEI5StrW7iHtyB0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:From:Subject:
	 References:In-Reply-To; b=EX50R0Hjok0hNibENrfwqjFXMzombYcLTT141tPQ9jrzVUmu9EP2MKyY0TAUoFb1hcLtPnLZxy5vh2WbPI1UmM8zPBtG7BVPf8/E+EUb3cPg9zOwtc4YXtxLvckbhb7ArR1tr3lQm+cBTJuDK9/MX9rqI64EdB5DXnHz0Gl1nYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=BG8jRtix; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-38f54938d1bso96056f8f.2
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 03:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1740136826; x=1740741626; darn=vger.kernel.org;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HVNBNWqXlEkHBpelyjOliwzjP+Z7atB2V59Z13O6URI=;
        b=BG8jRtixo/SwDR5fnTcwKI8QTWUNx1ixK007Hg9fYM1UZnUdjflcaa5+QrE2OWz4he
         TmyY6w60Z4BLfxssVPz5RXqZCgiiCR9Gzmi/6P3b6KKQ52M/dzEnIYgRyKwijaah3YtG
         zx+4/so2nvZ2mMmmomqBTloAcb8jKi4FsuMsYN+GaxPQYaSzLQBFSFNRq2ion9QFjBFc
         Zpx/n5BXmF82B6lFRtlhvuHmeN0tdwb+GomN6BUoakTgIjnwYF14DjkAMlQry+GBgpZ6
         9tPZ4Ov3TwZ8gjvFegyC1HyvGn45kUa3SJMaqNPGBf6T1nbrR1Tmyd1Ief63xKjiVPEA
         YVHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740136826; x=1740741626;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HVNBNWqXlEkHBpelyjOliwzjP+Z7atB2V59Z13O6URI=;
        b=nhKUJqvApDt8c7Ll7FMzAnCQ+nn9z2YviYdOxnQxzjVd37fqA20D2xKWlNuI/vpSP2
         j+wUXk0wYlKfdNFabS2nDbGD3+PP//3y/CIUjDURm836StQQDaIzVIugOcNtaEpXfpo1
         ZYr1pNKsg6miNF4Qn3QFISWyE6oillbU6AfqtGLLahxcFuLR+QEHs5GozMT4Vv9wRx0s
         ww/cH85ml24K3Gn+tOXujrQiCKeTDo/OdGllEyMkJimCAu8sB6B5Tbx9k18qZ7+tE8/R
         pAmZZzSbOwClCkovQc/wu77I48vkzXG65W2AN95MeVhRCMZOWtRt00comUvPm4qPGnxQ
         guLg==
X-Forwarded-Encrypted: i=1; AJvYcCVDRP5NrQyf566V+QSVulGDDDg2dOtKYCXemryiQDbSovvZoCaSGTjnsaEYC6NBKeJ4nK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFAvp1ZnhMQ657N/6PgiSu1Nhc6fx5wTkegAaWffCmypAzYu4b
	s4L83FScLRDZcwCKkTlMnyLSyzJkEH6UcNRn3+KtP8UDmUG6851P/LsitovfjQg=
X-Gm-Gg: ASbGnctaEIzFWP7AR2ei8tZGV/9SgUeWCFNvuNBhs8hB8kG6ksD18N2bpF7xFDL3hBs
	D24s44ucacNQAtPXA1yoF/HxqsaWsAg1gkfKaNam0AGvbK9eJHXok4zHf/CJPMD9oe3hRW0UazW
	3PN5UkxjUDJ24VeBX1jDh0Nz+l+0ctIuPFoU2xsghl5sDUdCKk8/OiEu/ukWkgJkRmw58V9RzJV
	kmwH1ZiM+n6ry91wPbHBFA8irgtT+0fpHv/mGSW1ysacv0meHXkdkWi8217RzplEjGzYEnoB9SA
	6fI3vFWu9JkIFN1UdxyMIKSZSWXpcGqHfMdbuFL8kRf0A68RKqKZ6rlN8G58GWYWyIBonly47Uk
	WsN9/D4th7byQbdM=
X-Google-Smtp-Source: AGHT+IH7K+hzKcKXQTAM1MJlY9T9odHfHdYNa2eoNCcz78onWDZURLkgur4LeY451LSe8tRmqDN2LQ==
X-Received: by 2002:a05:6000:2a0c:b0:38d:cab2:91dd with SMTP id ffacd0b85a97d-38f6e95f74bmr899043f8f.6.1740136825868;
        Fri, 21 Feb 2025 03:20:25 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-c955-d4da-b5fa-7bb3.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:c955:d4da:b5fa:7bb3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d94acsm23492868f8f.75.2025.02.21.03.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 03:20:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 21 Feb 2025 12:20:25 +0100
Message-Id: <D7Y30THD6TSI.113LHMD3DBBCP@ventanamicro.com>
Cc: <ajones@ventanamicro.com>, <kvm-riscv@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <atishp@atishpatra.org>,
 <paul.walmsley@sifive.com>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>
To: "BillXiang" <xiangwencheng@lanxincomputing.com>, <anup@brainfault.org>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH v2] riscv: KVM: Remove unnecessary vcpu kick
References: <20250221104538.2147-1-xiangwencheng@lanxincomputing.com>
In-Reply-To: <20250221104538.2147-1-xiangwencheng@lanxincomputing.com>

2025-02-21T18:45:38+08:00, BillXiang <xiangwencheng@lanxincomputing.com>:
> Remove the unnecessary kick to the vCPU after writing to the vs_file
> of IMSIC in kvm_riscv_vcpu_aia_imsic_inject.
>
> For vCPUs that are running, writing to the vs_file directly forwards
> the interrupt as an MSI to them and does not need an extra kick.
>
> For vCPUs that are descheduled after emulating WFI, KVM will enable
> the guest external interrupt for that vCPU in
> kvm_riscv_aia_wakeon_hgei. This means that writing to the vs_file
> will cause a guest external interrupt, which will cause KVM to wake
> up the vCPU in hgei_interrupt to handle the interrupt properly.
>
> Signed-off-by: BillXiang <xiangwencheng@lanxincomputing.com>
> ---
> v2: Revise the commit message to ensure it meets the required=20
>     standards for acceptance

Nice, thanks.

Reviewed-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>

