Return-Path: <kvm+bounces-53796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1696B17177
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 14:46:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27F513B566B
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 12:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6482BE7BB;
	Thu, 31 Jul 2025 12:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vhil9NDX";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="O/iXZWpl"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B1B5234;
	Thu, 31 Jul 2025 12:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753965950; cv=none; b=oAVqzp/o7faHihRZPXqyNwP1c4H4x6sqi49OHvEArgdh8TlB+CIFDGvWSjVwNvaZmlKuuIpP9hFIjP5UYsi2ezzRFG6HXz38Wulwj5Kz3oO1+sNbmGsowgNZO13L/Ml2frVZcxjH9ZjYJR0PspFmFUdIaQViGPUK0VuaZSNrPDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753965950; c=relaxed/simple;
	bh=mvLxBfnzp62TeBrSuDWYEhbx+qy30ctbgSPN8Gez7SM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TQruTUKNXZK9m2hEIajixtlkTLdLr6kSkL/eatwhHTEq4phgW7oh986drFtA/41gfOnfwH/gYsx57NMMmTZZllPha8CxJsrjhh4R5x3WsJNxpO86/AZL8cNEPMUl2tg6tfacscUT1CAKBNwqrm8YSC6koje8O82iztAtUlz4HDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=vhil9NDX; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=O/iXZWpl; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753965946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r0ZC5v5BjOvnb63T/GZzAxdZh3Zr1Srd+EGiANeZzPs=;
	b=vhil9NDX7pAe3JPZdjn4+FOd171Ju9qHpOZFEyRg3LlWClJbG9a1FTr8nIRw3ofegidC7A
	bInZsL9REdSbsgaAPJnm8cmUcXgwPNdpb0QW6z7xnWrEaCq8fkHXcTbAHEXJn0Aol8M1pq
	jRAZdGefzRfxg8NdGqrPdMqTphs9QSJ8XRfUvWko/rJOzB+WUKatpFGQR9pYAg1OBHryAb
	0kSc/eZbD7qJiYm1JIiM+ShODzuoM+xCoEEpC6WmVjXz4H+TCARPkjBX5qURffPB4bm3ic
	ERa6h7Q0OUsgdTnzLKcTIEIUObsDxfaZTh2Z7z33WinUrYUpidcIWk4EFKRqaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753965946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r0ZC5v5BjOvnb63T/GZzAxdZh3Zr1Srd+EGiANeZzPs=;
	b=O/iXZWplTlN5YCdluyJR0nyjolrNbE+36mpScRKZJPWZhbeDVw8DmMOWL0XL+6ljPKRKGs
	QaPhdupIC/TY4gDA==
To: Hogan Wang <hogan.wang@huawei.com>, x86@kernel.org,
 dave.hansen@linux.intel.com, kvm@vger.kernel.org,
 alex.williamson@redhat.com
Cc: weidong.huang@huawei.com, yechuan@huawei.com, hogan.wang@huawei.com,
 wangxinxin.wang@huawei.com, jianjay.zhou@huawei.com, wangjie88@huawei.com,
 Marc Zyngier <maz@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/irq: Plug vector setup race
In-Reply-To: <draft-87ikjhrhhh.ffs@tglx>
References: <draft-87ikjhrhhh.ffs@tglx>
Date: Thu, 31 Jul 2025 14:45:45 +0200
Message-ID: <87a54kil52.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Jul 24 2025 at 12:49, Thomas Gleixner wrote:

Hogan!

> Hogan reported a vector setup race, which overwrites the interrupt
> descriptor in the per CPU vector array resulting in a disfunctional device.
>
> CPU0				CPU1
> 				interrupt is raised in APIC IRR
> 				but not handled
>   free_irq()
>     per_cpu(vector_irq, CPU1)[vector] = VECTOR_SHUTDOWN;
>
>   request_irq()			common_interrupt()
>   				  d = this_cpu_read(vector_irq[vector]);
>
>     per_cpu(vector_irq, CPU1)[vector] = desc;
>
>     				  if (d == VECTOR_SHUTDOWN)
> 				    this_cpu_write(vector_irq[vector], VECTOR_UNUSED);
>
> free_irq() cannot observe the pending vector in the CPU1 APIC as there is
> no way to query the remote CPUs APIC IRR.
>
> This requires that request_irq() uses the same vector/CPU as the one which
> was freed, but this also can be triggered by a spurious interrupt.
>
> Prevent this by reevaluating vector_irq under the vector lock, which is
> held by the interrupt activation code when vector_irq is updated.

Does this fix your problem?

Thanks,

        tglx

