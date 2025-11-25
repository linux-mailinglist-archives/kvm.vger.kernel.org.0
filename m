Return-Path: <kvm+bounces-64536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 30B91C86879
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 116444E54E4
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19A332D0C3;
	Tue, 25 Nov 2025 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="G5GcE2Qx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB6627510E
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 18:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094567; cv=none; b=KgvB1kxQPkyOJQ0H0uobfQvxKqGDNoChF+8GG/A98MhgY+y64JB+ez0Ity0KGZZFw+X1jLpdR0IMjVOtlP/w8DaLKF9pItJLgyTDN+JZjHB4824GQFTn0t0I9Z3m6UDnlXvB60wJPinr9ng6ttNVv19naNGn/peSgF34gW5i0ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094567; c=relaxed/simple;
	bh=9v97D+9PLT0uMLapviF3SmaxxpgNNwzI4R+kSRfUcm4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=l/LM8R05bXIlYHJt705ZWe1B2B1Qmu3shkAlsCYOmIx4zqeph13h2/ifJsaBpAKY9BKbMDqT3jMiDQZ+Yof2FQ6udfCKS1ZNklpbhHlg4FYACmoNl04cQC349QB+7Ue5pcdtsWzcOQGAdbFAq14IeZVBmOj4DR8qNAAZuZsUxJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=G5GcE2Qx; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-477aa91e75dso5286395e9.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 10:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1764094563; x=1764699363; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9v97D+9PLT0uMLapviF3SmaxxpgNNwzI4R+kSRfUcm4=;
        b=G5GcE2Qx3SKRcoh5RVS668k5kb8SkFvM+M1VVTsF+Jy9VypF8crlueLDTlBJbcD/oy
         Ga8J+AV+dwGNwlKny5rU+dIqMsnTogcUym0Bi1P+WS3IR34ye0//kcttgr2pZZWL1c5B
         oo57reYox9rmGpRw0G6s+Vph4cFFaJLGQqo3BGPMCkE8N69qtRe239hcM0S8Du0mIjlN
         LTsrrZEDvq1MdtQASuX9MJV98KBNRt36lSNejerO19is/o6K5Kpdk3UmC36YZxBrbNn7
         9MOcCjvbo4SACK3TRlSK7RUbmU04wrhVsqQE7TJYc8MDTHOe53+LxWSwE2tr8/iOz4vc
         Yu4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764094563; x=1764699363;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9v97D+9PLT0uMLapviF3SmaxxpgNNwzI4R+kSRfUcm4=;
        b=ntMTq2JECmlGW81GAX3WAlNaEvMJfvrmLHqdXcmEagsGQXXkrXZTOtQjgevwfiAufo
         jc+N79NHUnxhfeOoflS6qScnDGXcW4WpOYciPRhK8VhIyEQAVrP0g/FGXuZYyTPLeUZS
         /HXQIhnqEzO/MAfeF4z/N77TJjGd18BpnjXbP+zRDuSX8t8fy1cBDRNaewT/fb8PdtE6
         CY1r8leJIpR5NLC6PmzguK3lrO0Sk3mCh8mr7SqUkhbROxYRtQRlcP3BOo9i0ejRRCbJ
         evMCaEVU72KsYK5QY2oS5ZeyonzMkyreE+O3gnVsSxhXXEIw8u9D3Y4yv/t9ooR8qNbs
         Jnvg==
X-Forwarded-Encrypted: i=1; AJvYcCVlkgpoAoGH2O+NZZsHnKHYYoAIairWeerMpoXXaVPHQ/nhCZI4ThwOj95jSXllOxzKJgg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRYeHXpPEh88uiSlZmBG2peBi5GwTfhFby1AREMOG+tWty4jh/
	siv78voKY+XENlmpZJ9RlnGczTVr/Jjta2XzczHCB8NRIQErrP/HkopsbPr2NcqOchUyno6H2fU
	YHpwiSb4=
X-Gm-Gg: ASbGncus7H4Ojo14QLodzUPYu7HkoaggIQU4XiG1vVZmXyp4lTtFvR0Cn+IBixFPCoK
	pi7bG9QiMtr5NaCG0a5spdkAtvHiUzx67CjEhOxe6S7FVTEB8WZZ7MK7ZtVniHFq9h4gErvmrwk
	zaSOTKqBr9tgzgSlw/adH2fl6xKT8FB2LanjF8vsdznGSqDiY5RdDOCuS0Jo1sP4PazSswDiwB3
	zZwo1OByDzsWd6sB+ZRkbMh3CaeWskktdXCipdYdc9Iwgt6fujo4fgIjyvGslxTlu4r9AYo9Cam
	UORuxskqsa67c5Qhw28QlcXLkCGRYZDjZnDWv6czqtww3i2nf1y1+USh5TP88xy18oFcIRWsQ68
	ThNejznVX1MoPvTNomvsVe/bDkuW3BFVNW3U+1Yac6DqBqV4GU/VcFVR08MmySVWRNQSpKryL4q
	4=
X-Google-Smtp-Source: AGHT+IFoy5K/jbEe3lAZa+6Mn4nHERrUuG7oU2Mf+OYZ+BYbMR2pW+d1vv3kWbQEl+fQTgVqW0Ju2A==
X-Received: by 2002:a05:600c:1552:b0:477:9c9e:ec6c with SMTP id 5b1f17b1804b1-477c01f4ed3mr85974315e9.8.1764094563308;
        Tue, 25 Nov 2025 10:16:03 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::3052])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-42cb7f3635bsm36230521f8f.17.2025.11.25.10.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 10:16:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Nov 2025 19:15:28 +0100
Message-Id: <DEHZBIAB842A.1AUCJS0OR923@ventanamicro.com>
Subject: Re: [PATCH] RISC-V: KVM: Allow to downgrade HGATP mode via SATP
 mode
Cc: <alex@ghiti.fr>, <anup@brainfault.org>, <aou@eecs.berkeley.edu>,
 <atish.patra@linux.dev>, <guoren@kernel.org>,
 <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
 <palmer@dabbelt.com>, <pjw@kernel.org>, "linux-riscv"
 <linux-riscv-bounces@lists.infradead.org>
To: <fangyu.yu@linux.alibaba.com>, <ajones@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20251124-4ecf1b6b91b8f0688b762698@orel>
 <20251125141811.39964-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20251125141811.39964-1-fangyu.yu@linux.alibaba.com>

2025-11-25T22:18:11+08:00, <fangyu.yu@linux.alibaba.com>:
>>> On Sat, Nov 22, 2025 at 3:50=E2=80=AFPM <fangyu.yu@linux.alibaba.com> w=
rote:
>>> >
>>> > From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>> >
>>> > Currently, HGATP mode uses the maximum value detected by the hardware
>>> > but often such a wide GPA is unnecessary, just as a host sometimes
>>> > doesn't need sv57.
>>> > It's likely that no additional parameters (like no5lvl and no4lvl) ar=
e
>>> > needed, aligning HGATP mode to SATP mode should meet the requirements
>>> > of most scenarios.
>>> Yes, no5/4lvl is not clear about satp or hgatp. So, covering HGPATP is
>>> reasonable.
>>
>>The documentation should be improved, but I don't think we want to state
>>that these parameters apply to both s- and g-stage. If we need parameters
>>to dictate KVM behavior (g-stage management), then we should add KVM
>>module parameters.
>
> Right, adding new parameters for g-stage management is clear.
>
> Or we could discuss this topic, from a virtual machine perspective,
> it may not be necessary to provide all hardware configuration
> combinations. For example, when SATP is configured as sv48,
> configuring HGATP as sv57*4 is not very meaningful, Because the
> VM cannot actually use more than 48 bits of GPA range.

The choice of hgatp mode depends on how users configure guest's memory
map, regardless of what satp or vsatp modes are.
(All RV64 SvXY modes map XY bit VA to 56 bit PA.)

If the machine model maps memory with set bit 55, then KVM needs to
configure Sv57x4, and if nothing is mapped above 2 TiB, then KVM is
completely fine with Sv39x4.

A module parameter works, but I think it would be nicer to set the hgatp
mode per-VM, because most VMs could use the efficient Sv39x4, while it's
not a good idea to pick it as the default.
I think KVM has enough information to do it automatically (and without
too much complexity) by starting with Sv39x4, and expanding as needed.

Thanks.

