Return-Path: <kvm+bounces-53266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 625C6B0F73C
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A91D1643E4
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65581F9F7A;
	Wed, 23 Jul 2025 15:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FnL0di6K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516591F3BAC
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 15:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753285115; cv=none; b=arEskkTb4aKALR4pStZ0CnzDWgH+nsK+u6XCbKzyjKMCLrANaKj9JAakcNF1zVYtE6zdyHP/HYHJcjwsQ7IBnG0Vxi7eEaK9vdayLCTYzY6iHCW/Be+/WCqg6yq149RCrA7/NCu2nRbwlkI66WkZ/8yictHnyhLRIJ3Leh4AISM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753285115; c=relaxed/simple;
	bh=8T9TfCkafV99HUq2TR5S1MsMF69AzVNNy3QhV0IlXps=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TJ1AoMSgZOfLQREQbNHCvcgq/aCRG+BMOtseHJKzD/s5q3ghGaopCaevlfwOzdV23K+QyZhr4V/FsboVcPO4D8ZL3mBZaxC3RZIWE/DEBnVvIE0bfiWCeHrfeqtpz/CEn8Yv76y0MWk+BeEFvTEDI7zC9yULVAmSZdtU7ueWMFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FnL0di6K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753285112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8T9TfCkafV99HUq2TR5S1MsMF69AzVNNy3QhV0IlXps=;
	b=FnL0di6KpPapMrr6g5tynH5AoimAa6fp5xnVWQHEb6PGrME9GRVCO13cMhT3qPbV/V152S
	3CzZRv4Aj6kdw2cvpAjOn1HBN9gRcZTXDZjJv7rtx1SQuMwGU6e7bP4NvVdOmabl0kE9fF
	c5cM8Fh+9QqYWW4MggHfZDeMMVYzJiA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-bIlpTPRnOdy9dVPxBKoGGw-1; Wed, 23 Jul 2025 11:38:30 -0400
X-MC-Unique: bIlpTPRnOdy9dVPxBKoGGw-1
X-Mimecast-MFC-AGG-ID: bIlpTPRnOdy9dVPxBKoGGw_1753285110
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-456267c79deso23490915e9.1
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 08:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753285110; x=1753889910;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8T9TfCkafV99HUq2TR5S1MsMF69AzVNNy3QhV0IlXps=;
        b=WOUN8Njq8X9C9NW8d9AOQuJ925HvsAmxop0HpPikuS9vwrw/XJMcCVvfKEKpAvksN2
         x/Nv/xA6ieHsZb+r0yu1H+8KuSyTENPQXe/JwJS1dl+ZppJgOiJqBoDrWEUc5woZ+YTk
         FLvPCXCm9B/F+SH6bh6st6WlBvBd3WvgomM2Xe73C9QJrhwtFetYksOaHxtHuxUCIJFq
         YOg11jPIg5wtsWfPE1cl64gmihnLQNDk0MLgyqhVXGzp1DY/aLm21lyrdAQXR3WVMyEl
         sDOAx8scG+7+X+176fOJFx+6moTMkMQCfFb1zqkAqDONSjhCjy8U5Ka6Vpr8NmpXjU7r
         NH9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQ2XElCZrnh9cNFKar8S8hgDOkytMJeHCjPB4DIV926mCZXCupxgzxEIP+FJEUjqQJ90s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRNHbnwgT261ZfoMrmP0/Wk01C1hMoeiNhRAPuWz6PnL923Ed5
	jdREyhrFVILRzDbTZgd/tUjwCy3+4H4JAM9aVvIbkl/E17/OHSfCe9TYrXeBUEn2H5k3K2ijOeM
	4lccZis6wFySlYCv1tdRkffAQp5+8r+v+25FTkYRAu5O9rTD46J89Jw==
X-Gm-Gg: ASbGncun9xG8WOwyqPMVhgqxZrNmjnkUD3ZYh12CdK8Lx50BGJe8E1dEo79H4KV25Tv
	3iOpOPuWaEbgTzy8zU/Ds1yQ6u+Syyq9bpDPZ/xPGT81kIZANaUHXyUl1y5vXyNqSceHmMQWRhI
	U1fxiKqYSIG4Gtc+WdqBi8vOibgggZlFYRhN8ISHqjTnuf9RLvKgzplw35/mSvYpLM9Y9K5/206
	s63Ft1Ei/rbv64WmHWv6Qg2e0/1mPmBGTCSCxad0xC/ZDOWrdJuwo/U8OrLvODOfooSuyVKxNn3
	UA4kY9QCitF92Z2LSca8aDuJucIc1BekslFxMvpPuq7TMwEwlORlWMaDTiYkI5SnMMlJZmk22oQ
	kwmjTWmk1qpaf
X-Received: by 2002:a05:600c:80c6:b0:456:1560:7c63 with SMTP id 5b1f17b1804b1-45868ed969dmr23929785e9.3.1753285109548;
        Wed, 23 Jul 2025 08:38:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6wYI6fkFZoIyQMYYcyUTTH4h/csKxFYyTSF+4/JYLoYoXAjDzqJFF0JRN11ufGYAYyBF36w==
X-Received: by 2002:a05:600c:80c6:b0:456:1560:7c63 with SMTP id 5b1f17b1804b1-45868ed969dmr23929625e9.3.1753285109123;
        Wed, 23 Jul 2025 08:38:29 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458693f8dd5sm26144725e9.36.2025.07.23.08.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 08:38:28 -0700 (PDT)
Date: Wed, 23 Jul 2025 17:38:27 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
    kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 1/4] KVM: arm64: vgic-v3: Fix ordering of ICH_HCR_EL2
In-Reply-To: <20250718111154.104029-2-maz@kernel.org>
Message-ID: <b03eacbd-b8de-ce8e-57b6-66207c4b5559@redhat.com>
References: <20250718111154.104029-1-maz@kernel.org> <20250718111154.104029-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 18 Jul 2025, Marc Zyngier wrote:

> The sysreg tables are supposed to be sorted so that a binary search
> can easily find them. However, ICH_HCR_EL2 is obviously at the wrong
> spot.
>
> Move it where it belongs.
>
> Fixes: 9fe9663e47e21 ("KVM: arm64: Expose GICv3 EL2 registers via KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Sebastian Ott <sebott@redhat.com>


