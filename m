Return-Path: <kvm+bounces-32026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF109D1781
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 19:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18052B2508B
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 18:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E861F1D0E28;
	Mon, 18 Nov 2024 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NGH+4lbx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A4D1D0E11;
	Mon, 18 Nov 2024 18:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731952849; cv=none; b=SD6N5RbMc2CtZPWsZy+acIqSxOqwflAopp2aSGYBR6cdtiu+70x/doM6j+r13cSicijBmh9XS8W8IIeRMqXire4fox2RLszPpKL2FLPXBqzBbsb4SVh97Rz6BqrhE7v5oj77q4iATYWOl4AZwz+De/kzwW3+ZTbJ9oV3YurMKYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731952849; c=relaxed/simple;
	bh=9Sv8G9r52JNkf1syADECEpjGLTAjt6/932P/i13XHBY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=g+SKjiVNAWQmG55LcRpUasTTafJ7BgywykEqw6wOZQysUQ3aEkMbqYvOYFl5gxLiOhx6JTtCprQ0S6Y3JOzMREKzyY3hFdufm67zVlo8CyCkHG0Z2OtTgLeJjlqpzbPyZJVH3WzXgW9mPB7EP/Vl4Rz/IhmWkS/NgGm9IDG4+d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NGH+4lbx; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2fb3c3d5513so31067811fa.1;
        Mon, 18 Nov 2024 10:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731952845; x=1732557645; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DaFxbALhld5UZUpLSSfak/ozdMC8pLVVrDQJkwsEPqs=;
        b=NGH+4lbxMLcLy7vCxZD0NnIgWUBk3SR0RdfOnaNfddNl6EticVb1t7MN1jHoW/63d0
         +KVWFKuIVhm73v7fyOCe6/MKWD2SGjWJ94+KZvaHOtjhONacv5/c67jX87QLiHXnC0nF
         myCpe/vGpF/Qwg7pnfuTbtY4nXgEYvo6c/M34VuewVMOgeZBXmga4LbBL2t6Li0m7H9V
         IKds+SxVg9TxssZbXaDbIXyCyT1aF2DQPk5P2LjA0oO/l4uiodmctUEdohRE+sdwNq13
         H1oEs9FVlb1R3aEPSaJPCguYMCfvY4Nc8acM/v0OCEnYC+DjH/MITWFvuTF93BeZzfn6
         KSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731952845; x=1732557645;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DaFxbALhld5UZUpLSSfak/ozdMC8pLVVrDQJkwsEPqs=;
        b=gmCO1nBf0VpAJpX4kCuXm6I3DrKHgNwOs4TUwmAu/LHFavOKXQYZ+7DL8BZxgvkkfr
         DzHiHs5OgHRjtTy4LxzMSUzMbBUMa7jeX1E+mB4+J0MmHo3BAIkcfFIXWGL7VscK6T/V
         z9E7VgH6UET2EUikqUs4BAEL5Jh6s9yQo0l9FC9DE/iqeg3gvnSSavCpPeg5g+d2BaiN
         SLFsteaF1naQ4iw/+zykZHtpEy3SxSwAaIXFWInJLQhwtH0M4sSnF/qosoM30IQYoTpV
         0qaINvjpABYmBK+9hfMn01mPUK69f2/1mr/vfWfhsPdAQxTafo97pnRMdihRwuR2NRTj
         PyrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfK9WhzEBMAHP/r4EZg4JPFfwfKtLCf/hD5CHxaWPTGf0oyCrkfEqizWTKiMevgiNEB2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdbwIx6caKOlJnDXbH4MVsGFOn5A1kd7lT2duTBB5Y1PD6CWxy
	5GPWez9g+oCvO6MleT5GUkvTImcNV9ST81mrRqSDutNO7Ox1OtqpoNYlPGm0PQd7mejMicsvS7W
	cVgTCuVskgB6yfSodlv+/VWA4ROvXKw==
X-Google-Smtp-Source: AGHT+IERD+l6Qr6J2S5605UuPiCiMcftraa9jRU70etne+wWJmsgybVfSfST3MV8N0dT1RzxzjB3D97djZCg9uFGd0I=
X-Received: by 2002:a2e:b88a:0:b0:2ff:55a0:91ff with SMTP id
 38308e7fff4ca-2ff6064e115mr51444081fa.3.1731952843968; Mon, 18 Nov 2024
 10:00:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ajay Garg <ajaygargnsit@gmail.com>
Date: Mon, 18 Nov 2024 23:30:32 +0530
Message-ID: <CAHP4M8VxL3GJx0Ofhk4_AToD-J0X+_20QmfZpq06DuN4CKc15w@mail.gmail.com>
Subject: Queries regarding consolidated picture of virtualization and SPT/EPT/IOMMU/DMAR/PT
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, iommu@lists.linux-foundation.org, 
	kvm@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

Hi everyone.

I understand in a para-virtualization environment, VMM maintains a
shadow-page-table (SPT) per process per guest, for GVA => HPA
translation. The hardware/MMU is passed a single pointer to this
shadow-page-table. The guest is aware that it is running in a
virtualization environment, and communicates with VMM to help maintain
the shadow-page-table.

In full-virtualization/HVM virtualization, the guest is unaware that
it is running in a virtualized environment, and all GVA => GPA are
private. The VMM is obviously aware of all HVA => HPA mappings; plus
GPA => HVA is trivial as it's only an offset difference (Extended Page
Table, EPT). The hardware/MMU is passed three things :

        * Pointer to guest page-table, for GVA => GPA.
        * Offset, for GPA => HVA.
        * Pointer to host page-table, for HVA => HPA.

In both the above cases, DMA is a challenge (without IOMMU), as
device-addresses would need to be physically-contiguous. This would in
turn mean that all of  GPA needs to be physically-contiguous, which in
turn means that the host would need to spawn guest-process with all of
memory (HVA) which is physically-contiguous - very hard to meet
generally.

*_Kindly correct me if I have made a mistake so far at conceptual level._*


Now, enters IOMMU, providing the ability to DMA with non-contiguous
device-addresses.
Now, my queries are simple :

*
Is IOMMU DMA-Remapping mode (DMAR) analogous to a para-virtualization
environment (as per previous brief context)?

*
Is IOMMU Pass-through (PT) mode analogous to a HVM environment (as per
previous brief context)?


Many thanks in advance for your time; hopefully I have not been a
complete idiot ..


Thanks and Regards,
Ajay

