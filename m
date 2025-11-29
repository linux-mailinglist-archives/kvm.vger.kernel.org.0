Return-Path: <kvm+bounces-64951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE38C93B55
	for <lists+kvm@lfdr.de>; Sat, 29 Nov 2025 10:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8DCC3A8377
	for <lists+kvm@lfdr.de>; Sat, 29 Nov 2025 09:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146C9272E63;
	Sat, 29 Nov 2025 09:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oIvkaFC6"
X-Original-To: kvm@vger.kernel.org
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80711A073F;
	Sat, 29 Nov 2025 09:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764408342; cv=none; b=M9I5TnkilXMG6jWFoS61PaLFcR6sxe/8A4ad1lmPEea1O9s7vysR9gB/huoy3X3it9/VMLqCi5WCkIH6R3NbVaFgT4++R28Dsbf9uC1F2rOPQ+nnKoLIMsqmVMS1I43r7VxWAOGafAVKUtm4UF2pZDiiwPwswt4WJv2H0zXbHoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764408342; c=relaxed/simple;
	bh=18rum/pY9Ed+XYcJLfQetzjeK0JKcDWxc6EMLCywlk8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UEOzrrndHtyRbPtkSuSV2s/NMFWzHIn1QB7NFhHYgcjVvg+CTkbR2ozKwOk2t5e2y64tOjCun4bKId2PdHDjbObO+cbN4svIiad+Fphz/+TdPjs492bHw84jVnbqjaGSlTNgQ1zl/qt/aNv5OJNX6fEqzJFHOyDDx7u0VFRSjsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oIvkaFC6; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764408330; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=18rum/pY9Ed+XYcJLfQetzjeK0JKcDWxc6EMLCywlk8=;
	b=oIvkaFC6P3cJ8yIeY+9JaisFJzWRWq+Dpx6Rp2B3If29Nbzo7jK4iOxdJkWurFcSJ3fLHpWG7tdvuhXhQGwYx28tXGKUivGwlZvDx2HEfUWRDiiSfdYmXk0hYvLCk1lVut06zKF/RV2dyWDlU5bEdpHYnnzni78vkd1XH3zrmpM=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0Wtew5QK_1764408328 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 29 Nov 2025 17:25:29 +0800
From: fangyu.yu@linux.alibaba.com
To: rkrcmar@ventanamicro.com
Cc: ajones@ventanamicro.com,
	alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	guoren@kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv-bounces@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	pjw@kernel.org
Subject: Re: [PATCH] RISC-V: KVM: Allow to downgrade HGATP mode via SATP mode
Date: Sat, 29 Nov 2025 17:25:27 +0800
Message-Id: <20251129092527.7502-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <DEHZBIAB842A.1AUCJS0OR923@ventanamicro.com>
References: <DEHZBIAB842A.1AUCJS0OR923@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

>>>> On Sat, Nov 22, 2025 at 3:50 PM <fangyu.yu@linux.alibaba.com> wrote:
>>>> >
>>>> > From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>>> >
>>>> > Currently, HGATP mode uses the maximum value detected by the hardware
>>>> > but often such a wide GPA is unnecessary, just as a host sometimes
>>>> > doesn't need sv57.
>>>> > It's likely that no additional parameters (like no5lvl and no4lvl) are
>>>> > needed, aligning HGATP mode to SATP mode should meet the requirements
>>>> > of most scenarios.
>>>> Yes, no5/4lvl is not clear about satp or hgatp. So, covering HGPATP is
>>>> reasonable.
>>>
>>>The documentation should be improved, but I don't think we want to state
>>>that these parameters apply to both s- and g-stage. If we need parameters
>>>to dictate KVM behavior (g-stage management), then we should add KVM
>>>module parameters.
>>
>> Right, adding new parameters for g-stage management is clear.
>>
>> Or we could discuss this topic, from a virtual machine perspective,
>> it may not be necessary to provide all hardware configuration
>> combinations. For example, when SATP is configured as sv48,
>> configuring HGATP as sv57*4 is not very meaningful, Because the
>> VM cannot actually use more than 48 bits of GPA range.
>
>The choice of hgatp mode depends on how users configure guest's memory
>map, regardless of what satp or vsatp modes are.
>(All RV64 SvXY modes map XY bit VA to 56 bit PA.)
>
>If the machine model maps memory with set bit 55, then KVM needs to
>configure Sv57x4, and if nothing is mapped above 2 TiB, then KVM is
>completely fine with Sv39x4.
>
>A module parameter works, but I think it would be nicer to set the hgatp
>mode per-VM, because most VMs could use the efficient Sv39x4, while it's
>not a good idea to pick it as the default.
>I think KVM has enough information to do it automatically (and without
>too much complexity) by starting with Sv39x4, and expanding as needed.
>

It does seem more reasonable to select the HGATP mode for each VM based
on the actual required GPA range.
I will send an updated patch based on this suggestion.

Thanks,
Fangyu

