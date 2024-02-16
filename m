Return-Path: <kvm+bounces-8890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 832FE858403
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23AF81F29EBB
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 17:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70CE613175D;
	Fri, 16 Feb 2024 17:22:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998FB12FB1E
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708104122; cv=none; b=iRE+XklbiCk+30dFKc/ScyZ8cYblfIQd0J+kqjVuiQCVfcDAXLz/Q+/uyobnDBKKV8ey3WT/A004INJrfjDtGfHgUYaSO3imvyFCLytrq2K/Zdt5/CWNcL3UzYc2HukKR4di0OfDxPzYxhZLZmFIIzQTzpHqrOt8xMbSc0H2bzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708104122; c=relaxed/simple;
	bh=Ed30OCZAdoF8Up2WZYZxw1FU204rfgcdQDiBi0TzIS8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BEMyKWa4Ebd51MWnMRNSfczBx6sD5IBPj38blxII5Zq6PseKTixSG9Q74yL1vbOEiEVw1RO5PIEqcqw7MT2oeJWd/QCqCeMT6CvA1SeJi75Z9QiNTp11A7SYZWSq9yP9ss0NHGX7hlKhn0dNrnKBEqxLGbKVAt1UKlR8AMAYgr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 5C6E74E602C;
	Fri, 16 Feb 2024 18:14:30 +0100 (CET)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
	by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id EYdyYLLXg6O4; Fri, 16 Feb 2024 18:14:28 +0100 (CET)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id 5FF054E601F; Fri, 16 Feb 2024 18:14:28 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 5AD457456B4;
	Fri, 16 Feb 2024 18:14:28 +0100 (CET)
Date: Fri, 16 Feb 2024 18:14:28 +0100 (CET)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>
cc: qemu-devel@nongnu.org, 
    =?ISO-8859-15?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>, 
    Eduardo Habkost <eduardo@habkost.net>, qemu-arm@nongnu.org, 
    kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
    Igor Mitsyanko <i.mitsyanko@gmail.com>, 
    "Michael S. Tsirkin" <mst@redhat.com>, 
    Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, 
    Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH 1/6] hw/arm: Inline sysbus_create_simple(PL110 / PL111)
In-Reply-To: <20240216153517.49422-2-philmd@linaro.org>
Message-ID: <bcfd3f9d-04e3-79c9-c15f-c3c8d7669bdb@eik.bme.hu>
References: <20240216153517.49422-1-philmd@linaro.org> <20240216153517.49422-2-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3866299591-368854593-1708103668=:41653"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--3866299591-368854593-1708103668=:41653
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 16 Feb 2024, Philippe Mathieu-Daudé wrote:
> We want to set another qdev property (a link) for the pl110
> and pl111 devices, we can not use sysbus_create_simple() which
> only passes sysbus base address and IRQs as arguments. Inline
> it so we can set the link property in the next commit.
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
> hw/arm/realview.c    |  5 ++++-
> hw/arm/versatilepb.c |  6 +++++-
> hw/arm/vexpress.c    | 10 ++++++++--
> 3 files changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/hw/arm/realview.c b/hw/arm/realview.c
> index 9058f5b414..77300e92e5 100644
> --- a/hw/arm/realview.c
> +++ b/hw/arm/realview.c
> @@ -238,7 +238,10 @@ static void realview_init(MachineState *machine,
>     sysbus_create_simple("pl061", 0x10014000, pic[7]);
>     gpio2 = sysbus_create_simple("pl061", 0x10015000, pic[8]);
>
> -    sysbus_create_simple("pl111", 0x10020000, pic[23]);
> +    dev = qdev_new("pl111");
> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
> +    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
> +    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[23]);

Not directly related to this patch but this blows up 1 line into 4 just to 
allow setting a property. Maybe just to keep some simplicity we'd rather 
need either a sysbus_realize_simple function that takes a sysbus device 
instead of the name and does not create the device itself or some way to 
pass properties to sysbus create simple (but the latter may not be easy to 
do in a generic way so not sure about that). What do you think?

Regards,
BALATON Zoltan
--3866299591-368854593-1708103668=:41653--

