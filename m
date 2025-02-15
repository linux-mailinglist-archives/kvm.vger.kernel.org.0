Return-Path: <kvm+bounces-38242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A151FA36AC1
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F3193B0E8B
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11F03B1A4;
	Sat, 15 Feb 2025 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zhWGplgr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC79D515
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739582308; cv=none; b=bM2rPlKDXoUUO5p9fFSZAgC40dAt5+ugT+tI9mkItcD2VXDbXkopdW/xtkuIYcuj/NVsc/joiKvEQux1l/XKle1V0uGIyd8nUwgl7PIccw7KflwKRgwHR7lVIhftaJpircLvl+x9vd2N8PbOrI/KaC0BZL83eqPFLrcXTLOeaUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739582308; c=relaxed/simple;
	bh=qKDfbSuXufzEEBqCtHrOLMr264SLSFXq5e7mh+uT6KQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nq/gTgz4fLsFqt5f2PWcLI8yseSZtjLdptWmnHXvqri9DlUBYXuJh1c5PiqSxDkZ/afjxVX0bP80EHDdcXzpPLZjwqZtxIg1Wx3RNst2Jyhi9OTVgjOb5AyD0LAh49P8EDT/EaHN++Jb6rjGDsWA4CBigXTIbN5WUgDkjRsZezY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zhWGplgr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc404aaed5so1000545a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739582306; x=1740187106; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IhETc31pPMX6d10pDaCuaihkIgWNidfFyk/wqrnCFkc=;
        b=zhWGplgraTjf7SWdAY021f6LvVin9DE0vQXRX0GiFYQSOsDrvGjjaBgd/WbNZ6OOrh
         x5pycQUeFgW30zHVJeCdPMMIK6EedtzjPhna554fc8uM5QdP0rdt0RZkKc7eGbcIETOE
         zeXhV8uS66ZZm/dV8iHwXGD4kqoy2xeM8ABImIi+6vc3wRTDPvihIbD1nPinxsmYQ/0a
         Tfv7Z0YD0QvVXLbtIONHUn5bFSOHejrvmwuOkMy/JV/r/3lhPjXYDpYs/Ft0qdTyd1y5
         dbYsystKIfnzT/zwcwmpZmkvVpmllmq6JUinDO2RWou24ZSFU2B78fVZETrm5diWl5+C
         StAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739582306; x=1740187106;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IhETc31pPMX6d10pDaCuaihkIgWNidfFyk/wqrnCFkc=;
        b=eu9x91ftrkI+knfJw/OpO9N+2Jk5pb4Sc90PcIMrQo48sGVVNY9/sUdCGnife5N7bA
         lXnRRkK0+NcnEmU5Cf9GZChyTANOoBXUulMg4GNSlinqyTMcceQ5DAfEg2aL5XI112VF
         ACkGV2tA2mroBtl65/e6Juf6m/BHtCy/2FGN4/wwejKvCWO+Sv2hJgwsStD7Z5G1BfGO
         srzxWRisqPG6hunyuU25lcbjHwTXi25DqLZzaXe1m61VLMYcyFmRPo2AWLKuPRv7HbxJ
         D5fqXoSGCGD1dArOqE+qI9lRA2Mx6/pgt+OmSv+VV/xX7EWxHJvQ9IIOTYK781Ewo7uX
         wOpg==
X-Forwarded-Encrypted: i=1; AJvYcCVyc0ng42wX5Ar/pAA6EXYdC3joKkmFXzI+6thGsIYuL2Zs2V0CZWGMXRO3JdhcYfX3gQg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo9sz3fq8PIxstYEfwcpkVTKATuUO3eW731yCsXdtcONOWm8qi
	1fS7wXsl4WlWfCAfIYW9O+38GFCmwzkmdlVtCuSUX6frGr+BIaY53MqnMPGLswwowPyk7y8ZoTr
	Cwg==
X-Google-Smtp-Source: AGHT+IFYN+5IYhfq59TLMoAewKhswKqafONG958OepP5wvMi/15AIeQXg0VyJE/PBX0Ee6n82j6Z2G2ixpQ=
X-Received: from pfih19.prod.google.com ([2002:a05:6a00:2193:b0:730:7a4d:b849])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:258b:b0:1ee:7cc3:f7ae
 with SMTP id adf61e73a8af0-1ee8cbe5011mr2652716637.37.1739582306132; Fri, 14
 Feb 2025 17:18:26 -0800 (PST)
Date: Fri, 14 Feb 2025 17:18:24 -0800
In-Reply-To: <20250214173644.22895-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250214173644.22895-1-nsaenz@amazon.com>
Message-ID: <Z6_rYA-8SJm_aQlY@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Make set/clear_bit() atomic
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 14, 2025, Nicolas Saenz Julienne wrote:
> x86 is the only architecture that defines set/clear_bit() as non-atomic.
> This makes it incompatible with arch-agnostic code that might implicitly
> require atomicity. And it was observed to corrupt the 'online_cpus'
> bitmap, as non BSP CPUs perform RmWs on the bitmap concurrently during
> bring up. See:
> 
> ap_start64()
>   save_id()
>     set_bit(apic_id(), online_cpus)
> 
> Address this by making set/clear_bit() atomic.

OMG, this is arguaby worse than the per-CPU stack/data mess.  *sigh*

I'll grab this, I'm putting together a pull request for a few things.

