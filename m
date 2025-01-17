Return-Path: <kvm+bounces-35710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 761D5A14752
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 02:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C2C01694B7
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 01:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 383903FB3B;
	Fri, 17 Jan 2025 01:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l7qu9AXi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155EB2D613
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 01:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737076044; cv=none; b=kPF/xArUc7m8VcYqdO8rENDsJfG9H74N+oRElXjODKUJVZ73zz2DVMsEi2wLenjU/39NySHb+feQrOoB08DZkrNkNaH78f2Eq3gXh7zf7C7Ec2yT/zrpZJF+3aboBpdxzvZDK2Fb3aDoyVqxe9mVRshXrF4NI/olJl3MAgI3wZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737076044; c=relaxed/simple;
	bh=0V3dRkQNq+cjCYNla7McZI8lwDuOc69qsASu1ao4qMY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=iedFkKxTRq0e9bo1spUfbxUCW5F2ZeV/FgtMrsz22/2jaWBaxUWK7gZuDYhyQ16ULYHuPX5oR4fJv3atqsfd70Aft1b5PAl0XdNxKQgaJmTBlyhTTHaAz+3eMmgbcKparXrUR6W6UgPIK4tpM4xG9bjbqCzCIARZApcKhJBV26I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l7qu9AXi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efa0eb9cfeso3135816a91.0
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 17:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737076042; x=1737680842; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQB+B9+1IJSPf1hUEzGWEixGpxR+RyLEY+Ykpaxcq6s=;
        b=l7qu9AXimkHluSl1p2GvMsBuJ4C8Oi8japbPNVuFgwAo2TzCrXhrZS+imoWwhAN5Ul
         sZV8rvp3THZogV8SerVIoznn+P5m0wT0EjG8DYX8QDyXYy+NDQ9qtWrdYFyHe9QAFJEY
         FXCW7Rqmzpm/I0YFnKwQ0yknE/vE+zJpZw9zTnaRcsdj5dZQdAuVNBFS0tw7Y6Db4RZ4
         22QBZ2Ezbhv3AO50mFONXscrtvqBXOpr30TVnLBqGn4Z2OIybDLrNn+bbmQ2sNmap9yQ
         BzNcuv2XhrpZZYf8sFBm8VLyayIwsB9139jR6MBxg8e2nL/OrC4EAWZcghIhmB7mamVG
         hrlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737076042; x=1737680842;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sQB+B9+1IJSPf1hUEzGWEixGpxR+RyLEY+Ykpaxcq6s=;
        b=i5dVai9ay/ZBGUB76FxsR3BiW1JjZRWRIx2YaDC5AGkKusD3zgLdKEg1IrRTc4kavY
         DIlzxDRO/AxbzCOitifSrqHNTKVVa6mKWhNx62mtxp9HHnPaLyhHUrexW7tZNEK79EeO
         K89WtWLo7xKFLHkKcdhICotlOT5dGljqP3wzNFWS2fIh15NKazxAI5Xhke0WyZfa7J67
         ZoGLLG1VQClhGuhxzVN5RjbRw0cpMhK9vlbAitSNGk8/6pCRlQBee5SfcdLGK3eXFf6+
         bcCov+LFi01MUWV8+nwpmUg1tWHNOZsQb26iJZmfT3o+T/uQdEE7AlyHDl0MhZrXICFF
         Xhag==
X-Gm-Message-State: AOJu0YyMWHJHJrpJ6V4z+DLqLR3YJjjQH7mTpzBfHIywNXltToTIR7HX
	gMORa5RGgUzrfFbSFcg+VlNLHqQJQ/NArqI871xct42WNr6yVF9nyknlHm75GjSe3AkJTpl1Sdz
	i0g==
X-Google-Smtp-Source: AGHT+IFm7H34XL0ks3Bb3m52imGrghhMfBSzw0xeDDutOCeKv+Vl6g88gEDo3jz3wC8Ff3irEoI5cJBhrqU=
X-Received: from pjbse16.prod.google.com ([2002:a17:90b:5190:b0:2e0:aba3:662a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a81:b0:2ef:7be8:e987
 with SMTP id 98e67ed59e1d1-2f728e4841cmr13784198a91.12.1737076042394; Thu, 16
 Jan 2025 17:07:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Jan 2025 17:07:11 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117010718.2328467-1-seanjc@google.com>
Subject: [GIT PULL] KVM x86 pull requests for 6.14
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The "misc" pull request has a conflict with the tip tree[*].  It's ugly, but
not super complex, and it's trivially easy to verify the result.

There are also two single-series topic branches, "vcpu_array" and "memslots",
but otherwise nothing out of the ordinary.

[*] https://lore.kernel.org/all/20250106150509.19432acd@canb.auug.org.au

