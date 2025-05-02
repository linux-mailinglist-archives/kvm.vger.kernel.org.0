Return-Path: <kvm+bounces-45265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 068F8AA7BAC
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 23:54:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 375F11B63B89
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD462147E6;
	Fri,  2 May 2025 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EViZSYte"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0186720E703
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 21:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746222791; cv=none; b=J/MGAb1I+aOM62WTxjkWRCL422v93hzbwNIM28KQ4XkqcTyLNMbqkOqFN3K7IDLyT9Xi5DpthHqCIR5XUYsKGU8rUnpdsQzIRv4QbWps5drN40VftXRUidKoAmtKGw/3+kDB3RYT340p9/2n9bTuhWbYkK39XeqRtlMDzHIbrjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746222791; c=relaxed/simple;
	bh=BMZyqcPg5pUE6NegbxKX89FEoIQDZjeKXRKHEG1UT3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QfVD2u8gwx4cXtAhS0PlTflPFC8jpkKnBnrnspjkuPUp7KmP8+duhF71cohvW7QZP/Zs5YD50aDgHpdVwC904zJooRqW547xAiDoDk3rSUHCq5rspA8xa9CBsYkEGlO2D9OWn/oCkxJd4Caf0fWPps1vd7f0Ieo17aYBxx6628w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EViZSYte; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b115383fcecso1576041a12.1
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 14:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746222789; x=1746827589; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nwmb/KQXT0NuwPcVJ6Um7FDhzqrO1+rE2ISwKgu6CGU=;
        b=EViZSYteeaRG5vbFzQli5mIWKjAoCyPOBUc5FHcjyFaCsCC2Eh6fn+RVZUCZfC9e+7
         T+i/pgYaau2LIE8pKwo+7VfAyiephJIk+HNZF/KQ9puooym9AGB9xLJzrs6DscULKdx/
         c2hX5IJOthsGs6jGT5mJtnvJNVAk/9yuyikkPeHoFM9uDJnjI8v6izl5dW8Uflm+6tZU
         Eta3OkbzB2FHUN1SpHM+tLvH6PlHa5NeUW9iF+d9xsyKAXRecZBEiBZfYY4miaimUyWQ
         vJBs+4Ki8ICgxiaT0zKeptKzCMeSB8EFPRKZymSlrzkexCV510MSrMOomZ+yLUJlgXY4
         k9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746222789; x=1746827589;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nwmb/KQXT0NuwPcVJ6Um7FDhzqrO1+rE2ISwKgu6CGU=;
        b=jcqYWiUhtUpL8Vu4iIWqy6MiYNTRT9qFCe0jWJP22QQ5hLgYT1YBbVYg+nM4aYvXkd
         5djuUJUU4RlxUXnn1hUY52X9oRxlfYxE7JLBFnh7LNZ9ma3SF8CK1lB2bCYpoM8uCAty
         osUCoJVzTEhQuqBGYr/kSCHnb2g0yWGVTkoW3GHRU30hVPTX+UYNJxh7WLWrZf5MRhKo
         H+LrjI40DpmsZDN6tqfC2lt8PAcSokdHgpJHMDwwFdb37wbbNgAK5ZTabm2xPMNetTiR
         k2VX57o63zs1fj0ylaB8jAt+yMc5ImqFFuzqO1WGQ3yrBpTRsdNjLUGTsAbQdCZQ1LwA
         TyRw==
X-Forwarded-Encrypted: i=1; AJvYcCVc/v4sSjW3xAe+SgV6Tkjrd+y1+0vYxKjeKw89asrylCt5GIP/34vv4tzpxMZ7Uq+apMk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw710Map0+qK9f5qfFpdpg8c/eJPKTL/j5KVpdpTbwxwMoAgJ6B
	ZldixADNstUXmM64OOUKrMcjzBSeFGyu4FYrPFS3IIPNpcG4OdUnwPRVrcLwPfdNhggK4SPOa0h
	c+g==
X-Google-Smtp-Source: AGHT+IEp9FL/vS1ZkIqGljuqZWqQR+Ft9xvSh9jzolqK/Apw2UN4T6arpa/Bq/Hv1pEMaw2fzKXwn1PyhZg=
X-Received: from pjyp12.prod.google.com ([2002:a17:90a:e70c:b0:308:64ce:7274])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c12:b0:305:2d68:8d91
 with SMTP id 98e67ed59e1d1-30a4e622226mr6559092a91.28.1746222789248; Fri, 02
 May 2025 14:53:09 -0700 (PDT)
Date: Fri,  2 May 2025 14:51:03 -0700
In-Reply-To: <20250324140849.2099723-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324140849.2099723-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <174622245784.882917.5240595687823642720.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 24 Mar 2025 22:08:48 +0800, Chao Gao wrote:
> Ensure the shadow VMCS cache is evicted during an emergency reboot to
> prevent potential memory corruption if the cache is evicted after reboot.
> 
> This issue was identified through code inspection, as __loaded_vmcs_clear()
> flushes both the normal VMCS and the shadow VMCS.
> 
> Avoid checking the "launched" state during an emergency reboot, unlike the
> behavior in __loaded_vmcs_clear(). This is important because reboot NMIs
> can interfere with operations like copy_shadow_to_vmcs12(), where shadow
> VMCSes are loaded directly using VMPTRLD. In such cases, if NMIs occur
> right after the VMCS load, the shadow VMCSes will be active but the
> "launched" state may not be set.
> 
> [...]

Applied to kvm-x86 vmx.  I tagged it for stable, but it's not urgent (I'm 99%
certain it will never cause problems), so I figure I'd give it a full cycle in
-next.

[1/1] KVM: VMX: Flush shadow VMCS on emergency reboot
      https://github.com/kvm-x86/linux/commit/a0ee1d5faff1

--
https://github.com/kvm-x86/linux/tree/next

