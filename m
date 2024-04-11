Return-Path: <kvm+bounces-14280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B3318A1D39
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E63941F2437C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FD84AEDA;
	Thu, 11 Apr 2024 16:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="kslvmO+F";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="pM6Es389"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B5B4AEC7;
	Thu, 11 Apr 2024 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712854474; cv=none; b=GOdacvkSME35uHaNIU88jMiOlJkqUDDwM1Z/bC0FgQPz/XcZj9pDX6DzS7qUdETfBXvz7CeLyL4tv1TFGeadHY3nJBYVbfNlAm3xp/4+8B5IIgqblgRp2Ip47DBrcljmNYmi/0uhY8ky4OiVeDUb/+lOJ2qqOlHeyCh4CSQkSQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712854474; c=relaxed/simple;
	bh=o/tmf2oibS7VzJrQxRvlbljTniqkXceSKBc/IFbdGOY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dqZBIeNrphtLzIKNmZBGX9h5cTIWHZAV8V1gtLn4VYqow4lmVpwtl+wQ3wsvJZDR3YA8EYX7+xGEguoLkyTZ+oB9kb5XNpGDwLcVjnEe7xseTo+z2HN9LYMhnM7f3lXLIQ9fRMjFRkmQA8+GZmB49NoBVjrWT+LyWs/TTV/MZvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=kslvmO+F; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=pM6Es389; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1712854470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2wTUqTQtgvQyM18Dhq/k4fpzYZdQqJPvUTC2E4JdRxA=;
	b=kslvmO+FslCXd5W2BFBZX8HpBEnlhhIADzj8HE+DbTVQalyvywrsscrz/UROsFQzCD+xhe
	8I1w8dA2sMA1stfODUUz2OCyV5clkE+t2Ppd+XcF9CQasqBScwNqC41NTtQy92bKWczRsT
	HJkSR5rfnNBbfELVnTTxTiL7DJlUNOyxT5npARyAW0swQuf/S1gPm6mN068M5iCF+Qo71H
	hapoeEn5y04mUxGTb+mn3zoF7yH6aVaEPyMuLxAYbePnpiFCsPy90UtqgscLuXSVOba1Ai
	8rzG3H/5Rb6c3FMwX/w2OnjY1kTKWho9R2X2TL6LYWlXz/JukLXnzDzaIO4jng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1712854470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2wTUqTQtgvQyM18Dhq/k4fpzYZdQqJPvUTC2E4JdRxA=;
	b=pM6Es389nCt1cbDZ319st+cDLEYe7fzoejBOJa3LwYHngJ3SbIKpi4EBig8SxCrS26yQb9
	bzzy/xUomegvtyCg==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
 <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Lu Baolu
 <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, Dave Hansen
 <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>, Dan Williams
 <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jim.harris@samsung.com, a.manzanares@samsung.com, Bjorn Helgaas
 <helgaas@kernel.org>, guang.zeng@intel.com, robert.hoo.linux@gmail.com,
 Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH v2 08/13] x86/irq: Install posted MSI notification handler
In-Reply-To: <20240405223110.1609888-9-jacob.jun.pan@linux.intel.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-9-jacob.jun.pan@linux.intel.com>
Date: Thu, 11 Apr 2024 18:54:29 +0200
Message-ID: <87bk6f262i.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Apr 05 2024 at 15:31, Jacob Pan wrote:
>  
>  #ifdef CONFIG_SMP
> diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
> index fc37c8d83daf..f445bec516a0 100644
> --- a/arch/x86/kernel/idt.c
> +++ b/arch/x86/kernel/idt.c
> @@ -163,6 +163,9 @@ static const __initconst struct idt_data apic_idts[] = {
>  # endif
>  	INTG(SPURIOUS_APIC_VECTOR,		asm_sysvec_spurious_apic_interrupt),
>  	INTG(ERROR_APIC_VECTOR,			asm_sysvec_error_interrupt),
> +# ifdef CONFIG_X86_POSTED_MSI
> +	INTG(POSTED_MSI_NOTIFICATION_VECTOR,	asm_sysvec_posted_msi_notification),
> +# endif
>  #endif
>  };

Obviously lacks FRED support...

