Return-Path: <kvm+bounces-39774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D3DA4A6A6
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 00:41:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3A84189C93F
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 23:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BCC1DF74F;
	Fri, 28 Feb 2025 23:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="okRC2DRb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E93E1DEFF5
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 23:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740786058; cv=none; b=deR+9nESkiKClNAQviM/rZCVjX2LEzoWTpxnXV4+QTLzReUiFnF2Cj4rufEL+W5WMVmQjKyOwImnbr//yKcrk8AYYyVYmD0YbgkPycPdDGEv5fIXKEtuUjmefJHgyw8c5finxx3czHf8ruZ/vgasvlSdFm9N5VC5W4HP1Y5IhYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740786058; c=relaxed/simple;
	bh=X4fmUz6M9WHs8xbXMrIP+NMrZCQ+OGR4N2wlvwZQDa8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NrJCGMYqRlJXrPHItXFibXrZtv/x43VaD7yBa7xSRhhV3YCljgkY5cUs3T0pP7/Tpu4XPjsF6yCqz4+SAglUlb+J6+yD13maHh26z4jVq/KDtOm8wp9jgbSNYSSLiRueqTDvNzGFZsYkt/iWAaK+AyaGNzGDfkMfo3wbU6TUBL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=okRC2DRb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe86c01f4aso5512543a91.2
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 15:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740786057; x=1741390857; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Y6kdIhbmecG2s6oijg3hrb/HZDz6lI2TUduP2e++VE=;
        b=okRC2DRbgKcWRYvPF7gqxNA3TCSIH26D1yX+2+QgGX9SQUME4zhs6JjKJALsgEXcdk
         HIbCfhmuKupkBekiX5raGgNAhKzmEsIuwCC/PCZ2am/b/yQhDNM5nmKa6cV3Pu5COU2S
         pc3l6LVsFIlLOUh8tC49gkgpkltw0cwveVvbKi7YggMu2x30Y4+gZuJhRypBVkb+lb54
         MLIyPQUZv8q6UmrslpLQou0n5Qbg5McK0Zb6I2wnpi/VT7w2q/QIHZQF1/OLqOnI6s0R
         P9sxkyftuD4GMn8FvJ+XidAlfJ7xlAVuDnF73DJvSsR+D/g2sDvJ2xlrNty8uMRrQK+2
         fpHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740786057; x=1741390857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Y6kdIhbmecG2s6oijg3hrb/HZDz6lI2TUduP2e++VE=;
        b=boS8DjNnZWdHNsY5NGk+j0Wg0tsjIVOdyN2aQYC7nKtwonhrHnEStwow+WrTZWtqZu
         RmmSCr5Kss2M+vifAca5HTflRfNKot1m2lExx6fDOvCAtNWqh+xooA6C/TD5/pGe5zoa
         ++PX/DuL3i/ZseBU4QCl2MK1z9W6+WFJwBlsMsdpFB/ldD+8c4MqikXNoj2bd/RmneDH
         0k3NxgsKov56x9wfctNMUGV6ZAktSDG7B1tWZ0ViZ7hIK4lZ8ikvslTrCGNRT/vT9sBD
         IZ4XoGrNAEbRbmjmif7mD6RUbtjv4ml0Vs592jnhiUQI/s1Ecbn8h8jGlOFC9lMV4lRZ
         ryRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmjgefRd1w8VS4pt7Bxei/srcGOnVm7iXAbtnT1854x72+qlF0Gevw0r+x6y8tAMO6myw=@vger.kernel.org
X-Gm-Message-State: AOJu0YytaI9mxxKXGQFIllkf1crMWQ9iRQmS0eaj/LSO1panl8O6GMCw
	jVnjtlajeRJopNxJtNhnF0gW3b962rn3gCvWwlcZKH7Q+658hZSo5VG1lxm7WkbhQ4Zas1MJV40
	R3w==
X-Google-Smtp-Source: AGHT+IGi1fgzqXBy5vxKuvEo/ZHYsPpv8I4K571iURnu3dRsdMXh/qVkN7umYar1m8IF6nKWFJwTiW+l/DA=
X-Received: from pjbsj5.prod.google.com ([2002:a17:90b:2d85:b0:2f9:c349:2f84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2883:b0:2ee:d63f:d8f
 with SMTP id 98e67ed59e1d1-2febab5ba5fmr8017786a91.13.1740786057156; Fri, 28
 Feb 2025 15:40:57 -0800 (PST)
Date: Fri, 28 Feb 2025 15:40:28 -0800
In-Reply-To: <20250226074131.312565-1-nik.borisov@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250226074131.312565-1-nik.borisov@suse.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174076296192.3737724.4386230620749350319.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Remove tdp_mmu_for_each_pte()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Nikolay Borisov <nik.borisov@suse.com>
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"

On Wed, 26 Feb 2025 09:41:31 +0200, Nikolay Borisov wrote:
> That macro acts as a different name for for_each_tdp_pte, apart from
> adding cognitive load it doesn't bring any value. Let's remove it.

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/tdp_mmu: Remove tdp_mmu_for_each_pte()
      https://github.com/kvm-x86/linux/commit/0dab791f05ce

--
https://github.com/kvm-x86/linux/tree/next

