Return-Path: <kvm+bounces-52003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BADC7AFF577
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 01:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2466D5A8447
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 23:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E255A23D29D;
	Wed,  9 Jul 2025 23:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcefPN/G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22A815A8;
	Wed,  9 Jul 2025 23:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752104764; cv=none; b=C3jWHsY51JoF5MeJ2B5dZWKFo38tEcAe880TpYjA5ZmIP1lbAw+F5lxLsup166OTUFg92wlAP4h7b+GHTxjL5I//lV08mXG42eXNkWQ3gZV9SKa3Eca0RagD65/BCcHZa5uc7l5ki/vM+UO/6Q3ql06NC+qppr35LSUuZryb7Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752104764; c=relaxed/simple;
	bh=axC2a76eS0Ecj+bULnHkaTLKbCu8wx/KQo/SFlcpOZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=naN0njqTM80JRb/w5T7ldLtvFrh20rOzgDzEk2AVoevAZj69ZBVbu+TzVuexRj3CACRFhTv+vZvhWFwEEpm9N9GVlaRPCe2aAUKganxY72q2Em1rkFfTyjcaR/LuLdrslh7PDp6rBuz6Gko2vJwURxOphJCqTiYCzMRSuLmqTEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcefPN/G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037D3C4CEEF;
	Wed,  9 Jul 2025 23:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752104763;
	bh=axC2a76eS0Ecj+bULnHkaTLKbCu8wx/KQo/SFlcpOZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lcefPN/GN20LhehDFn6H2UPmeiSGsyhpTVr7kO6OD2/HbaSNwgpJ3E2b9KWH67nyX
	 xb+G1xge9Jf5VA7Icio2NhPU00Ru8z4E/VFtr61miV8+Z3E0e9RddIKkiAOT2oXUYu
	 qTOwBLK6jkY/+ACDo+119X0K8A6QWugk/ZyMGSAUTAeUTCvyGrMZX3ztlXQr3lpXm6
	 w2s9GZu4hhrJAEC7Thi8wzHgkM/4TRdEiuei4U/g7F2qkyQmXuZC1A1LPOiEccBpXh
	 PtgrWJuAPC/RFsPIuj6Bwx4oZ7ERw7GvRMUNwwtEhAWaTFJH/mm79bOGBWtLXj1JwS
	 /DWWMpHLKhP+Q==
Date: Wed, 9 Jul 2025 23:46:00 +0000
From: Wei Liu <wei.liu@kernel.org>
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
Message-ID: <aG7_OCR9jN8j8lFp@liuwe-devbox-ubuntu-v2.lamzopl0uupeniq2etz1fddiyg.xx.internal.cloudapp.net>
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

I applied all patches expect the KVM one to hyperv-fixes. Thanks.

