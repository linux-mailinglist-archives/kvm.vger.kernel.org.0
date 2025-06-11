Return-Path: <kvm+bounces-49034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E46ADAD539C
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDB071887085
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 11:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF362E6134;
	Wed, 11 Jun 2025 11:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="rlhglbRt"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B992E6106;
	Wed, 11 Jun 2025 11:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749640359; cv=none; b=A2xwUOwgHKSWRy+DGUPS3UwDl19IvL6Q5Zq9KPM2R2c6JCnS58qIvbGpazxERVSRktkIfMj6bvtIDI+zRRQgGRW4ewArulBdgKfIEW9lI381+WrBZHZ0Vn/6j4VHbjfZi22DGtgmxvFxpjpb5gBaiU6ceZtbKe8RmCI+OtbnML8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749640359; c=relaxed/simple;
	bh=wOLHNC3mM1hvT6HYztFKZ2PDx4KcHzQ0D5Kk5tU14B4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMrYtLGuqYL6Dh/wznWfwEwAqG55qOkyKSupuoh3REf9NAsaTWpCqBgOcPoO2xCjFGFIseHg2eARy5W1h5N9nnBFYKAMu6tfn7vlyuA+/mZSebiRI7WkovgD4KEclIDtlCzi4ljFJ0CGiYTbF9tvHrdn/3lzIZunSnGKR86qnbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=rlhglbRt; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1127)
	id 9DA822115190; Wed, 11 Jun 2025 04:12:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9DA822115190
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1749640355;
	bh=qWcwbrk1B9AwSLw+kibnueNoD1DZ6goIu7GiCM6Qlu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rlhglbRtbt0Hbe+n51t1Jn72RUoWF3RpnwuZftUvtNku2mGleh3PsB7Ete2wnwVQX
	 totONy0JEUXLVQ9Ik1KKGghpirw600tO8i8259mmKIVjMKnnA4WPgd/mExswV1pxYR
	 18e7gfJe3yFADKmvYLOa41ksZ4zFzNef8IiwfWCA=
Date: Wed, 11 Jun 2025 04:12:35 -0700
From: Saurabh Singh Sengar <ssengar@linux.microsoft.com>
To: Naman Jain <namjain@linux.microsoft.com>
Cc: "K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Rob Herring <robh@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>, Long Li <longli@microsoft.com>,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, netdev@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/6] Fix warning for missing export.h in Hyper-V drivers
Message-ID: <20250611111235.GB31913@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20250611100459.92900-1-namjain@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611100459.92900-1-namjain@linux.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Jun 11, 2025 at 03:34:53PM +0530, Naman Jain wrote:
> When the kernel is compiled with W=1 option, a warning is reported
> if a .c file exports a symbol but does not include export.h header
> file. This warning was added in below patch, which merged recently:
> commit a934a57a42f6 ("scripts/misc-check: check missing #include <linux/export.h> when W=1")
> 
> Fix this issue in Hyper-V drivers. This does not bring any
> functional changes.
> 
> The one in drivers/hv/vmbus_drv.c is going to be fixed with 
> https://lore.kernel.org/all/20250611072704.83199-2-namjain@linux.microsoft.com/
> so it is not included in this series.
> 
> Naman Jain (6):
>   Drivers: hv: Fix warnings for missing export.h header inclusion
>   x86/hyperv: Fix warnings for missing export.h header inclusion
>   KVM: x86: hyper-v: Fix warnings for missing export.h header inclusion
>   clocksource: hyper-v: Fix warnings for missing export.h header
>     inclusion
>   PCI: hv: Fix warnings for missing export.h header inclusion
>   net: mana: Fix warnings for missing export.h header inclusion
> 
>  arch/x86/hyperv/hv_init.c                       | 1 +
>  arch/x86/hyperv/irqdomain.c                     | 1 +
>  arch/x86/hyperv/ivm.c                           | 1 +
>  arch/x86/hyperv/nested.c                        | 1 +
>  arch/x86/kvm/hyperv.c                           | 1 +
>  arch/x86/kvm/kvm_onhyperv.c                     | 1 +
>  drivers/clocksource/hyperv_timer.c              | 1 +
>  drivers/hv/channel.c                            | 1 +
>  drivers/hv/channel_mgmt.c                       | 1 +
>  drivers/hv/hv_proc.c                            | 1 +
>  drivers/hv/mshv_common.c                        | 1 +
>  drivers/hv/mshv_root_hv_call.c                  | 1 +
>  drivers/hv/ring_buffer.c                        | 1 +
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
>  drivers/net/ethernet/microsoft/mana/mana_en.c   | 1 +
>  drivers/pci/controller/pci-hyperv-intf.c        | 1 +
>  16 files changed, 16 insertions(+)
> 
> 
> base-commit: 475c850a7fdd0915b856173186d5922899d65686
> -- 
> 2.34.1
>

For the series,
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com> 

