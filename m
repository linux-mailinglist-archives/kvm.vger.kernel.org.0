Return-Path: <kvm+bounces-12546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CE5887784
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 09:15:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBE2A1F21FAD
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 08:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625A4DDB7;
	Sat, 23 Mar 2024 08:15:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F65D2E5;
	Sat, 23 Mar 2024 08:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711181734; cv=none; b=eZEcl0oxJPV1NUTZqMSjBJNxc3SybwNltMwYxkzehVVdvL3+yiLkq0gSiySlUGjARYxDJOSB1Liv0pQF+xnfv//rzgJJ7CjMcgeZhNbmqhS8rpXWsg6fuIGPXFXUdkVsh/UPo9Ek/Pq7dlrJ1dYqeiPaB28Vl4Brvvm9suLXGx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711181734; c=relaxed/simple;
	bh=Ny2z/INP7b+0ECBQtSpvYw7XT10zbyoaHaX6trX1qh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uyCt7JigI6jP5KyQV/vQQPn0M74xtHr/qxcEBMJTWFSJ5HGeNr+t4kzZTNrxDcsdH7Y4E4JCZ7S03E4t+0rPEFvyKXKcwWi/xDDtd8ruysV1TzBqYT563nUbUnYkRYNT7s8dHlYy9bXjn59GPtHzMSN2XDibUdAYdRVUeLuYMFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.224] (unknown [95.90.237.163])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id D0C7361E5FE36;
	Sat, 23 Mar 2024 09:14:53 +0100 (CET)
Message-ID: <c5a4ce3a-6c0e-43c8-a3f8-1b291acb114d@molgen.mpg.de>
Date: Sat, 23 Mar 2024 09:14:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: VMX: make vmx_init a late init call to get to init
 process faster
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
Cc: Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240323080541.10047-2-pmenzel@molgen.mpg.de>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240323080541.10047-2-pmenzel@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

[CC: Update Colin’s address.]

Am 23.03.24 um 09:05 schrieb Paul Menzel:
> From: Colin Ian King <colin.i.king@intel.com>
> 
> Making vmx_init a late initcall improves QEMU kernel boot times to
> get to the init process. Average of 100 boots, QEMU boot average
> reduced from 0.776 seconds to 0.622 seconds (~19.8% faster) on
> Alder Lake i9-12900 and ~0.5% faster for non-QEMU UEFI boots.
> 
> Signed-off-by: Colin Ian King <colin.i.king@intel.com>
> [Take patch
> https://github.com/clearlinux-pkgs/linux/commit/797db35496031b19ba37b1639ac5fa5db9159a06
> and fix spelling of Alder Lake.]
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
> ---
>   arch/x86/kvm/vmx/vmx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c37a89eda90f..0a9f4b20fbda 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8783,4 +8783,4 @@ static int __init vmx_init(void)
>   	kvm_x86_vendor_exit();
>   	return r;
>   }
> -module_init(vmx_init);
> +late_initcall(vmx_init)

