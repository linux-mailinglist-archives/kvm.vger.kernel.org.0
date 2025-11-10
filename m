Return-Path: <kvm+bounces-62523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89AAEC479DA
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:45:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A79E188831A
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561ED320CCA;
	Mon, 10 Nov 2025 15:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pKVhXEMX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EC13203BA
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 15:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789146; cv=none; b=V/4MzKY4bH121gJ5XrAGQ3MMveZVSYYw76RZM6TQI9YUV/dhGBx6Dt/eNYgnQOWEviGd/bQ/LOLdLSlPC4CrL2c2Gj1hPW7Ayb4F0UG0QpFcXHKV/P3dw+JEOhLRYsszoceliMTSIKaWkIIvzBMWIAO9jVUeavknaFGz65b8f4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789146; c=relaxed/simple;
	bh=PPL2SdLK8PmSDvO6BN4piAdIr1VAL+6Gg9dslowyosI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZGES0ZfLuyJNU727ahRSpCHAY5wBI2Bidh7Ffgu2RrcwdSFSqyE97P5JjbSD34pKrcqzalpQvFj8xEBDp9mMDDL9AB68XzayrlrXS//+ofWB0AzdwKR8iPGwoA07kw8vPXU2TIMb20D9HHvO8tWcPNwhZawlYaN3r9Y0T8pOuD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pKVhXEMX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3436e9e3569so4963190a91.2
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 07:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762789144; x=1763393944; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7AEvXYOaN64JItQuWNBgAvlkHv3cc5xwvMT5feppTYs=;
        b=pKVhXEMXE15mnv0+98STna0T60z5ewHVgQc5ouqAVJTe/PjPFajugDnyPSYR0ysyK6
         NWmiLjQYTNlxIQrX59p4CJ1qFn11TxfFgN1vTZ7Sg+59oyw267+HLghMwc3lrIPqIZgG
         HEA3BnMItxazmllBlSUmmRgVEEbRO997cNx1QjvsxdiGi6ZkuvsKfTtmLBmTVi3NyDoK
         ejbkhQHKsGFlgDON/6svDiCS8Mi9R56i8VCXFfgwWxAGN8/amkPFVTtSqUM98vlkmu3z
         p7MgzXG9doczqHBS1DpcqmKxaxS4J4avyDr4dGE7V4d15eAP/4EWzOA8/dEQv0TBlLfC
         Q1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762789144; x=1763393944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7AEvXYOaN64JItQuWNBgAvlkHv3cc5xwvMT5feppTYs=;
        b=kMpPOCOIPCEs1qyI7DV5sKtbmaLxcQ+kuvNGffywXoeYPietcETX8IjCw5qcT878na
         YjYym9Q9AjMLBAcRQ981Z7hzRzByJ1dwbSkSNYzHiuzeF3IvFAySR+WoSFqi1RV/hGUm
         Eob780fRPsSwNt+mCxxoJ9Q/GWpiUESbQ4PTa7BgsHqNmKJVyaCycOFGkrugW4oiI2SR
         rDWsoDDFAceB1C7uWYPw+WGaXGrhhN++FcjzlWvsW3HRkCKM6loMD/eah1K5jinnA/ml
         kgAzRlQOobd9Nr7HPm61MrGP7ZyTw7qQVDA7yKRNhfJxy5KEKCfSly5Gc0A3i9fdAdCg
         NQ+g==
X-Gm-Message-State: AOJu0Yx+ryBCGm99KVcwp/73xh7Fm8Fnss8BTgDUdeuVASfcwx9AgIAn
	nkDBD7CRzV53zG4DlGOi1tWEK0W3tTNjWZiyOH96HdLnkOcwmoynhhgmL5XFXUCXw4byTdmZq2q
	Ad8+tmA==
X-Google-Smtp-Source: AGHT+IEJBxP6dqiRUZf4jx9C4qqYIsuUEh+aRELI5Lvs7Iom2rN6WMbD0iv/Wsu2+Py914cxV3LOn+fxxLQ=
X-Received: from pjboe10.prod.google.com ([2002:a17:90b:394a:b0:33b:dccb:b328])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e707:b0:340:b1b1:3d28
 with SMTP id 98e67ed59e1d1-3436cd0975cmr9112633a91.25.1762789144323; Mon, 10
 Nov 2025 07:39:04 -0800 (PST)
Date: Mon, 10 Nov 2025 07:37:23 -0800
In-Reply-To: <20251021114345.159372-1-kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021114345.159372-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <176278830538.919221.18305930787987749373.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Move the misplaced export of kvm_zap_gfn_range()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, Kai Huang <kai.huang@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 22 Oct 2025 00:43:45 +1300, Kai Huang wrote:
> Currently, the export of kvm_zap_gfn_range() is misplaced, i.e., it's
> not placed right after the kvm_zap_gfn_range() function body but after
> kvm_mmu_zap_collapsible_spte().  Move it to the right place.
> 
> No functional change intended.
> 
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Move the misplaced export of kvm_zap_gfn_range()
      https://github.com/kvm-x86/linux/commit/6422060aa9c7

--
https://github.com/kvm-x86/linux/tree/next

