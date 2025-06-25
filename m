Return-Path: <kvm+bounces-50760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD60AE910C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:26:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB51517FF56
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 494D42F3C19;
	Wed, 25 Jun 2025 22:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sYyOTAs0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE3C2F3651
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 22:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890404; cv=none; b=ZqxLOfojcZhPfWm1XJWceGXrKtC81FU0kqZ/EhiZ4o10lE+4wKikDiFvER7119ByuObH9aEH0uL+9fXXnGs8NBjU9N+xtRW1KMBGtLXLaYcJ2O9kQ4qCnZAsRu1TLXVE2gXmHtElQoDHXWRSS2b1I+PjPVkZf8fsS6lSQCX6//Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890404; c=relaxed/simple;
	bh=8RVAhAvbsSN4XeQU/Ep59J/eFuvCozVzOpSHDoVBY1U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=doLwbw3SxV5iPxQY+k9wpMPSCM19OsXLUjGDoipusf+ahgWFECwfs+u/w/6QJBjebIFBqNRGgxvcSDcMW1R9EgmK0sjrP3kQLn0Ippc5gkz9YKA9YlCAPuipOq7MmtauU7sYxREDW2xVLNFn7CBVYKzAhQ5oswgQA9UUsICN7Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sYyOTAs0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31202bbaafaso224257a91.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750890402; x=1751495202; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1nHMNckIAGHOB84QksTuLqDGIWhz0BAjF0ykjBJlcXU=;
        b=sYyOTAs0JzwJYT1fZAVXS9yEOtWoObFcaBfoqrSfGiTvgQ6uqOHOLzMxeiLAC0uhv5
         Y8wdRNbMAS3KCJeTHKMJjBtpNQh6FDv52BpiHyYBNodsKIslg3vNrHLPzQqoluNiQ1iu
         dyBTuETYOYQ0NZtm/dixHLFoVFO+gq6DuW5VPCjeS3aM5IJeywhX/NRT/behVxS2NA0I
         X37G0An6OBdJ53hqAJuEwIIqwmGdQaVlsZXG5+orpNAFXkcnlSqOhMfMLk31MA4YESne
         CYWO7ThVgcrrrJmWcFqfZgK5YuANXeKIjUgjfbOMV/R/H+P0RNOG8uoew9tpJzgbHCR6
         JrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750890402; x=1751495202;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1nHMNckIAGHOB84QksTuLqDGIWhz0BAjF0ykjBJlcXU=;
        b=lN//B8VQeMxJ+h9ewM32tyJJeTmkgxxIGYjBLaEAM9BI1ZGAEOxEqLUiygzpwHkQGj
         vIiB64Z5Beu6YBGovPU61cdSsAMSkiOX7FyhxzbJxagEZTgFwTFIcge4f29cUH+0p1NY
         hMK/Sor/AJy747dJBop0q+XnMLzwd4GVTSDnNvWi/9QREFSwq5xLyYheKm9jIYMGa5eg
         0AZ9B+IbOY6+tSP4j3GmdnpQC8tn3biEUZI3OylJHxAlDVPlNCGSRjZO6QAmYwO6mLOz
         XA1Xt6PrXOX7jUnLOjzaUz95osbN91MRq1bDZW9FPV6D299LQrRpbQdkwxDGxhX6jTRu
         IjQw==
X-Forwarded-Encrypted: i=1; AJvYcCXgMEfNrqhPVeUvBOnfRFytX1lDWnZ/gagRUWm+Owqof1KIX74rOKtuRHrLRcNh/uj3rGE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEPGBeMtGYRGHv7WQevCjOFB31elhujNzN+3W6g3fDqkz8qpuB
	/Iqv3rnrw8WDG0SOZxwzOlF1ULn5v7JCttQ1wx14e6hSlpQC/DjRreZZjeP5508UgUSVLR3m0vb
	MIK1Gag==
X-Google-Smtp-Source: AGHT+IEu8YZr3ei2B7qpSy5h5YYyM8djisCuZn2agsNtTkJ5CS8HZjlhYabrZRxjjPWoPZdtn/lKoLhDpsg=
X-Received: from pjbsw7.prod.google.com ([2002:a17:90b:2c87:b0:2fb:fa85:1678])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5288:b0:312:e91c:e340
 with SMTP id 98e67ed59e1d1-315f26c2cd2mr6427092a91.35.1750890402653; Wed, 25
 Jun 2025 15:26:42 -0700 (PDT)
Date: Wed, 25 Jun 2025 15:25:35 -0700
In-Reply-To: <20250612081947.94081-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250612081947.94081-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175088968783.721345.4388004885092486423.b4-ty@google.com>
Subject: Re: [PATCH 0/2] More cleanups to MSR interception code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, dapeng1.mi@linux.intel.com
Content-Type: text/plain; charset="utf-8"

On Thu, 12 Jun 2025 01:19:45 -0700, Chao Gao wrote:
> Deduplicate MSR interception APIs and simplify the handling of IA32_XSS
> MSR. This series builds upon Sean's MSR cleanups series [*]
> 
> [*]: https://lore.kernel.org/kvm/20250610225737.156318-1-seanjc@google.com/
> 
> Note that this series has been tested on Intel hardware only.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/2] KVM: x86: Deduplicate MSR interception enabling and disabling
      https://github.com/kvm-x86/linux/commit/3f06b8927afa
[2/2] KVM: SVM: Simplify MSR interception logic for IA32_XSS MSR
      https://github.com/kvm-x86/linux/commit/05186d7a8e5b

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

