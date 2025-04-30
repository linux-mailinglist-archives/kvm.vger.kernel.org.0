Return-Path: <kvm+bounces-44919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0688DAA4EDB
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A99C618942A0
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B746625FA0A;
	Wed, 30 Apr 2025 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ob4mrwLg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F8821ADC3
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746023941; cv=none; b=J6nvAJQn+TfQPJvLXshLPDIpRBnvmiiOQmWQyFzMWL0gmzJYOr7ENb8Z+6fRLdW90UBKt2GkyNtmt1Wva6Y2m5O+Px6YtmROC1irMxV50qn9fjFyriDGqkv6uxFk/7yabeNsHnaoEeybkxaRJKKojVuqJN76/z2GU/nVppVnhIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746023941; c=relaxed/simple;
	bh=BhYYOz5NlOOegoPQI5hpXU14NXhJBnlFgf+RsnopOZI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=SsiE4+m7/thx4Ft+qGfW8hB30QLNH5MoqwJ0GNnUlVw7uHRWqOI1EVBJMfTW++pIHnPvEO1KS7UMu/Emgt3japYIDyvPX6/k7Ygbu9306sOfWfQ2nVsKsO9c9JKci4U53vuIWuCl+/snXrGyn2R8lndVQVlw/MX1iScf7n0PZ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ob4mrwLg; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43cf825f46bso5459145e9.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746023938; x=1746628738; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BhYYOz5NlOOegoPQI5hpXU14NXhJBnlFgf+RsnopOZI=;
        b=ob4mrwLgHr/TnoJfJXzXsmPz3AP8Lup2cqan3/Ay3JNkV1HTMaDsePKim33PaO3yxV
         cZKSPxCnwCxou6nYUna3AzwUXInpW6AuIfKcZrdmtsVml7pFop9mXLF3GUfo9KQLx5Nr
         aF7q4mQ89CsipQt6MJBYm5XDq9gmDU5f7A/MA72rRpmxDaIaBHa+4iYfFk1I0/Sz8NNM
         I3PkZ70OZ1awdyQU6gtMZZgifxZ0PZp1GdidYilIsFewSdL3bNpInhqcj7znXsTwYqUM
         AXTZZqmwlsU2LcrPURzdrw/Os+jD7M3ZjWakugQYjzJ0EgRkNWPYBxYgEd5z/8DfvCKl
         GVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746023938; x=1746628738;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BhYYOz5NlOOegoPQI5hpXU14NXhJBnlFgf+RsnopOZI=;
        b=Wpl3JBwhU1gsy7EEEDv7EgNBCSY+Br56tJejRp0j5AWIhRRY0qUsbTamTOjjaouHo9
         jh2RYXHtN/MlNDGEkR14+yaTzXS8Y1E25VtkT/eZAKvYPDEmVI9cXZFQ5fbYcx5cEV2e
         kpUpCdGtuGOoPwydT2WIpO9HcXKAYGO0jhwiu2ogHMMd4/fP9Tz6ggqszL3SWOqIPDEg
         ZLqJVtLd4Yp5k5gynSo0r8vLYBDBR7u8kpjmgLzgQB1azNWGnAZLEKQinPJH80tOJOFx
         j4b9C+7NB06f3MglFZKaXeC3uRWx+CVNEp1+cNyzuhwuMSGSnwROGYlFYr0IE0DOKMm1
         piAA==
X-Forwarded-Encrypted: i=1; AJvYcCURLYf0o4kDD320L+f2MMlKmXVNgAdr4AxKK/rEdZBAWK5QgzNar5Rb4FT5iVXlfRlj368=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNU+CTueHcZkO8dugzhMYRj6BfvS8tX4X6kdQWyEyhj2vNQLFl
	P8iqDku0ADVNn+sjswofNKGt3jQ/d/bi40LMyxEXp5t1Qr0Hx20XDd949fCoF+0=
X-Gm-Gg: ASbGnct4APA/6sS3bj1OnJswhMow66MVRaH2CuP6hhLwIgHX2wysHXebvFfX0wJlm6W
	qvXg1M5+PLOzCATiAcItHbeJvUBv1PmUlFwZua2cLMkPLNydXXC9FBtIUOizr1YtPkT/wkOJ5KG
	qsp0h1bafTDyWybiggDQVhZP/UTgjSymxIVkVSVU0pUN5oWEZbQXiRTQ+Xghrn/EAfuEwb4tqt+
	5ouQokw/0LIzizyLC3gfCM7b/8vBiMm4Q0/apTtYJwDTBpUUMqMlZbu0RsV6knUDXsBjNBaS3II
	jc34xTaK1tM0G43rBWIJAi1Bffxcz8BcYbTKkssbfWFRebWyvUjbQrv9arZHzva7iAk1t4JWQ2J
	6
X-Google-Smtp-Source: AGHT+IEI4GADqeHdXAfmffYECZ9pL6Wjw9iSIa7PRhjYESKXYcU7d8boy1B3uio5ziNSls3PXGMoQg==
X-Received: by 2002:a05:6000:2c8:b0:3a0:782f:9848 with SMTP id ffacd0b85a97d-3a08ff6e786mr1015889f8f.4.1746023938369;
        Wed, 30 Apr 2025 07:38:58 -0700 (PDT)
Received: from localhost (ip-89-103-73-235.bb.vodafone.cz. [89.103.73.235])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073ca5473sm17383962f8f.31.2025.04.30.07.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:38:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 30 Apr 2025 16:38:57 +0200
Message-Id: <D9K1TVIG544A.DAEZQAFBUDB4@ventanamicro.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming
 runnable
Cc: "Anup Patel" <apatel@ventanamicro.com>, <kvm-riscv@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, "Atish Patra" <atishp@atishpatra.org>,
 "Paul Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "Andrew Jones" <ajones@ventanamicro.com>, "Mayuresh
 Chitale" <mchitale@ventanamicro.com>
To: "Anup Patel" <anup@brainfault.org>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com>
 <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>
 <D9IGJR9DGFAM.1PVHVOOTVRFZW@ventanamicro.com>
 <CAK9=C2Woc5MtrJeqNtaVkMXWEsGeZPsmUgtFQET=OKLHLwRbPA@mail.gmail.com>
 <D9J1TBKYC8YH.1OPUI289U0O2C@ventanamicro.com>
 <CAAhSdy01yBBfJwdTn90WeXFR85=1zTxuebFhi4CQJuOujVTHXg@mail.gmail.com>
 <D9J9DW53Q2GD.1PB647ISOCXRX@ventanamicro.com>
 <CAAhSdy0B-pF-jHmTXNYE7NXwdCWJepDtGR__S+P4MhZ1bfUERQ@mail.gmail.com>
 <CAAhSdy20pq3KvbCeST=h+O5PWfs2E4uXpX9BbbzE7GJzn+pzkA@mail.gmail.com>
 <D9JTZ6HH00KY.1B1SKH1Z0UI1S@ventanamicro.com>
 <CAAhSdy0TfpWQ-kC_gUUCU0oC5dR45A1v9q84H2Tj9A8kdO0d1A@mail.gmail.com>
 <D9JY52BJEFX2.2S5XL9NOOGBS7@ventanamicro.com>
 <CAAhSdy1xCRocu2uNri4iDm+NQd+VE8JRVeASfYJ8Qspr5aEz8g@mail.gmail.com>
In-Reply-To: <CAAhSdy1xCRocu2uNri4iDm+NQd+VE8JRVeASfYJ8Qspr5aEz8g@mail.gmail.com>

2025-04-30T18:32:31+05:30, Anup Patel <anup@brainfault.org>:
> On Wed, Apr 30, 2025 at 5:15=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrc=
mar@ventanamicro.com> wrote:
>> We can re-use KVM_SET_MP_STATE and add a KVM capability.
>> Userspace will opt-in to reset the VCPU through the existing IOCTL.
>>
>> This design will also allow userspace to trigger a VCPU reset without
>> tearing down the whole VM.
>
> Okay, lets go ahead with a KVM capability which user space can opt-in
> for KVM_SET_MP_STATE ioctl().
>
> Keep in mind that at runtime Guest can still do CPU hotplug using SBI
> HSM start/stop and do system suspend using SBI SUSP so we should
> continue to have VCPU reset requests for both these SBI extensions.

Will do, thanks.

