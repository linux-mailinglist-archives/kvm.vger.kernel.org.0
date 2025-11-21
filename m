Return-Path: <kvm+bounces-64233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A993EC7B68C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:59:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CA28535A5AD
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 575A1301021;
	Fri, 21 Nov 2025 18:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fkuW12tK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B1E2FD1B0
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751396; cv=none; b=W/B1UmfY0GyAEm1OLeThTgZmv2SpWgWpkMcVP7t1ppkOcuYXP6iIrWdj/aoSVOHSnpAfAsyBAuDa5WGKw0kRGoneVA6KtwC5NBo0POuiMGLhocOYsxbyMYJpczfpP65KTZVPRS4sOOn5dIDjUoH+Sj5PFG3KG+z9lo5KbRuNte4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751396; c=relaxed/simple;
	bh=Tbnmmg3uB4vXjgA+fP5zKiTahSFt4i5gcYnpzoE406U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QKpBh5W7egtXNAGtfWC9rFWYlsZKGv4UBHTMtd9S+4D6Cb+ViOmd8V51i1ZjmeJg8jFAs5npvm8oM2YlGaFy+TrmNgJ5WakAhAzNnEVMPX/4yxCHN0oJaZEEYT06NIAgIdj1Fis1LWep1j1ex8aRXqUPZPizlXclilTuN2KmKJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fkuW12tK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3436d81a532so4816932a91.3
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751394; x=1764356194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=46pHJz0KvIBSFd3DM2EpOJSa6qbv6tELf9JfOObMYEA=;
        b=fkuW12tKED3VqKrxo7q+0OUzU9bdkM/wilxsOka/jQCnMC0U/T3I2m77O+ASEAGjQf
         vtaLmdMEOocBlHQLGU8xA+LCXUIuhD9mQOMF5iOlxNlbjjXYJaEByppSmr0qAbLmvSMf
         Qxnq+j2tTU1O1sBz4RKrgs3+xQrWz38cDL8UvKm+JE7MQKi7A/rcjf6Uivd3TqZtoG6v
         yUMVSp+2DlWMpRJKBg6KPp48HzS8Uxmr22qGIrbH4KPE9BxahTMbcNI6PDx8y3KpRU+T
         nqygYVxaxJfoLJ+tKB6KeTiRAmUcMn85VCIJuAyCfFsMpLU8mOfSA3++4J6/GuBZLROb
         QroQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751394; x=1764356194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=46pHJz0KvIBSFd3DM2EpOJSa6qbv6tELf9JfOObMYEA=;
        b=vmQI3MGj0Qdw0MZETrYDqo5J1gRxi5OCq4kMYr+3SG6wzhFu36gBOXBzbsomH1MQ4P
         fPH90g79CLK27SsaVdmA+/3HYyS9tQNz1dt+OKZzRo6mR5Gpg9Ku++d4UiNEADtIy0Ex
         Oj4DBuyTgdUq8WajwHMS3dQvnLuVOhsKG+RatSfXOE8+4XHoI3e+GnijiK6IbepT52iD
         Dy1NsYN655uVX4ZprB2bUtrf0tP7G9GA+0QmCszGQMMHwRxzXpEtLcBDtaAkoUreZMCK
         k7lplR3AKbP4tzNeBENUG1uWnqFszZmFEGaXJ1QYD/8ar9ucNedVSx/Qm26pURcfqNV8
         eacQ==
X-Gm-Message-State: AOJu0Yw/JxrcKju+9u/nvzBy7LlaiJJyPz8M+45GfKhOp3rFVRRnr3Zo
	g81Yz5bMqnOd1/M/VKCYlX5V4EV73ABvp9APSdoUQ013sPIQPZREFqTvE44zSCO9XHzPkxGrREn
	HGmx0/w==
X-Google-Smtp-Source: AGHT+IGvkxgB/2z5coZrXdTspw6VtdtqbO5qmI/1QSPIIS8X1XFAQfm/kfgOS7dUKOH04UZ2p8QDaIfGBHk=
X-Received: from pjis15.prod.google.com ([2002:a17:90a:5d0f:b0:343:1fc1:8553])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f42:b0:32d:d5f1:fe7f
 with SMTP id 98e67ed59e1d1-34733e937bdmr4033132a91.15.1763751394063; Fri, 21
 Nov 2025 10:56:34 -0800 (PST)
Date: Fri, 21 Nov 2025 10:55:35 -0800
In-Reply-To: <20251120120930.1448593-1-yuehaibing@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120120930.1448593-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <176375120338.289143.5293306404466300879.b4-ty@google.com>
Subject: Re: [PATCH -next] KVM: x86: Remove unused declaration kvm_mmu_may_ignore_guest_pat()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, yan.y.zhao@intel.com, isaku.yamahata@intel.com, 
	Yue Haibing <yuehaibing@huawei.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 20 Nov 2025 20:09:30 +0800, Yue Haibing wrote:
> Commit 3fee4837ef40 ("KVM: x86: remove shadow_memtype_mask")
> removed the functions but leave this declaration.

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Remove unused declaration kvm_mmu_may_ignore_guest_pat()
      https://github.com/kvm-x86/linux/commit/c09816f2afce

--
https://github.com/kvm-x86/linux/tree/next

