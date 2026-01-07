Return-Path: <kvm+bounces-67212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 06480CFD137
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 11:03:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 671C63065279
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 10:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67FFE2F7AD6;
	Wed,  7 Jan 2026 10:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="GrcXUEzq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFE42749ED
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 10:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767780099; cv=none; b=RRA6mJA5/yDYMiomBMkh0xzhkEYj0z9kBn7PKdR1y8MLGhUFEQTq9JzJhMcUMta56NZDov/83J13Hid9+jb38WIsae9d5yIfPx7VCQN80G2VZupI5HuDYp3a0ymeil1KmXuHSgC+kfPOA8QBtnyuQvF380uuMvxEu0UOOD1IAQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767780099; c=relaxed/simple;
	bh=1e7HzwoffI5S/6V5SheLWTLvf9f05N/KDUwstam8N0k=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=JKZbyPkN6LiZWmZ9jpVdvAvhs5LLTMq57dM/gPJvtDnxsN3OD/1jbGpFljDeZK1ww4VEzr230LT/4QkisQJIHZlP0Jg4tHHPtSljGuut8LTn+HtBlw+sqEMJGbNQTmyEA8LEBcIo9dn3nYVd4I/j0u+grSNfnJuR0ieOOp6UEv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=GrcXUEzq; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5ec8781f5c9so393459137.1
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 02:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1767780097; x=1768384897; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1e7HzwoffI5S/6V5SheLWTLvf9f05N/KDUwstam8N0k=;
        b=GrcXUEzqOZmycz8CfevPhs3f7GWw2PiJuj0u9/7TlSo+WF+94bTSFo3nmDbTgUoiYQ
         mg8b1cZCFXAYEkzm5YftH8pTbNvcEv2v5RcMcY0UNxpc59yOY9WFkNdLO23pS1VR1+t3
         h3x0yi5KIG//3inRy4L2iK6e6xyvmAZhHfD/fjadZB149iJPbY8oGSl5rJtdE3rNkytu
         RNd2ngI5Ij7xv3gOaGKB1gSDV0yKl16Lyg45jsAqVOrZUUy08T31ZgyDQm/9PE11P4b/
         i45eHaw0Y2SZf6HcZwL0KRIG843vol79vl+b5anJehS547/zPT8eVw5SuqiiZGOz5gjk
         cZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767780097; x=1768384897;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1e7HzwoffI5S/6V5SheLWTLvf9f05N/KDUwstam8N0k=;
        b=UJimipDcOq961+fqcbXTfOi+qSetVrbsjQrQDwFd6HDGgk49aEip6IUkqgItO4LcAs
         Jmqbyq5ZIHLi3wj5A6C9qNaRpWpHO6uiOMSEyawTT7s/MGFVChGxJFXnl1SFj0MbKx/i
         1a5LNefopr2D6Gj2cHs6p9W6iOlQePL3sj4rmZvszkB3UVzkQQ9a2uUsCAMLlyGHyY2U
         VnBmA20+e0VyFHer4XePZGqlycD0pXgK34XeHYJ6G5i/kKTJejdvXB21b1R5yMOpTOXW
         wNx0bLWAwOaWJLUcngJAS9YpNrR9Jbp9DRTBtCGX87L6ACZrjZXNNXzWYX15D2RZny6z
         5ZvA==
X-Forwarded-Encrypted: i=1; AJvYcCXO4DqNbWEU3AkQiiZba7p3RIS7oGRa0z7S3yxJ2L6J5357aDljLh/L6ThlYvJtDJVruUI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaRoTa89rSwH+d+iHRmPb1Q/rR69UqxMBBXZX5oPeHNAlV8Jzz
	3TEImOlAfGadrhRNt+yafzQwD0oxxmcIe/h6Nl5K7PsAuVib6LCrWrUJbgFn/s4S7B64gFZTXd9
	Rqk+Fd5ya/OfLEcxDrsN60pdTsBFDbTZ0W1QongOTOw==
X-Gm-Gg: AY/fxX7NmJ4+l8nJqxUeoWTHh0gYKvSe4lMnvnV1RuOFsQoSQ6BoQpS2FYxF0WDfFge
	/4qUL0Y+wugH/VmKOYn40gWJ9HWmXFTi+7cMniEeD4mGSosoJAv4iCFV2WxORGBW7TPY1/NcwaL
	3tH+/0FMOQSjwurL6+CsuG+YrQwsOowIDsSqRnm/72q9Qvx0vq8mrOmQyCDqZzYY7Z+okObGAP5
	cTXfdHB0t2I28LcS4NChlDlrUzELxLAfNJEnjjwvi/yEZP/8dJYeYHbzoV/JiRBeTxBlObI1FaX
	sVyQO+z0
X-Google-Smtp-Source: AGHT+IFY9o6LoBGhJfHFhrwQmRjYbAjez+97Fc8MV2H/JqEGQGgiF+2CT3xNTtCeZryZYDcntgXs7hAyuiU8xea9t8Y=
X-Received: by 2002:a05:6102:534f:b0:5db:34b5:318c with SMTP id
 ada2fe7eead31-5ecb6955532mr709984137.45.1767780096723; Wed, 07 Jan 2026
 02:01:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Wed, 7 Jan 2026 18:01:26 +0800
X-Gm-Features: AQt7F2okIYDpNGyBgdlwrVkXSKzrOvkkA7_TMkO--kZnCCpAAR9jkMnVcWZBt1o
Message-ID: <CAPYmKFscKJ1ff470d6YmuMxLdJPSZ-ZmuGMMAFO83TT-vvV2JQ@mail.gmail.com>
Subject: Question about RISCV IOMMU irqbypass patch series
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Zong Li <zong.li@sifive.com>, 
	Tomasz Jeznach <tjeznach@rivosinc.com>, joro@8bytes.org, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Anup Patel <anup@brainfault.org>, atish.patra@linux.dev, 
	Thomas Gleixner <tglx@linutronix.de>, alex.williamson@redhat.com, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, iommu@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv <linux-riscv@lists.infradead.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Andrew,

Thanks for your brilliant job on the RISCV IOMMU irqbypass patch
series[1]. I have rebased it on v6.18 and successfully passed through
a nvme device to VM. But I still have some questions about it.

1. It seems "irqdomain->host_data->domain" can be NULL for blocking or
identity domain. So it's better to check whether it's NULL in
riscv_iommu_ir_irq_domain_alloc_irqs or
riscv_iommu_ir_irq_domain_free_irqs functions. Otherwise page fault
can happen.

2. It seems you are using the first stage iommu page table even for
gpa->spa, what if a VM needs an vIOMMU? Or did I miss something?

[1] https://lore.kernel.org/all/20250920203851.2205115-20-ajones@ventanamicro.com/

Best regards,
Xu Lu

