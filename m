Return-Path: <kvm+bounces-67808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 43FFBD14701
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:42:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D1688307BD0D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9960237E303;
	Mon, 12 Jan 2026 17:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ciyv6xms"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A745021D599
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239703; cv=none; b=BtshRCYlME1X55dVfyPj5JqN07Dj0t/vXg3lh/WZ7MV5FyZ1AYafIAnG+/UqbyblxHACdHIYwUdHAAyGwaKRRkdmrwfqRbt9x15nuGSVu9ItWaUmJo9Whz3wkM4gKCdxKg3si0tPqOhFGeogAcCienx7hU42RwYIMtZjTHYha3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239703; c=relaxed/simple;
	bh=0jDbPcZyTeFfgfs7AiiPO0EDsECLF2ikFzM3ueD4GVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aW/twLTZbyjRGNEox+qWLzcfybcvxPHCYX/aUMuByI0m6RJ1RH75jQn+rYaOHAbWxRH0+j0DB2bOtIdd/arDUclJa0+g+p3M1wBNlp6HNd/WxSWV5EPaesEFgVmz7oTqV2rCs0p5cD5veGwAgCfAMOzZd/7Z05bnojROMy9KMk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ciyv6xms; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c5659f40515so5143229a12.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239702; x=1768844502; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A07SgJ1fsgZRk6pJH2onVqP51GLUJvZFCH58RCFF/AY=;
        b=ciyv6xmsZ1vQDf4ful4X/WPfqEYz3PcU6QYtoftF9i2HFzUoE6hBgwLjvuDhMFTN/J
         INDMe8grl74pXR6Bfvp0mwTp1XyHblY9skH2nmx2ZC//SPSLjGF/030d9fMNkxeEdnry
         ot0fhBkbF/SD4dS7pZfOTaSgw1X42edcNfQoLm8htofBXj68iCRs+1cwb+ulxRwT1AiC
         JC2/1em1b0B3n31eiKiI3pv2Nu+omEHByx3ZKqhBTHKcm3h4mwrlN8812P9ytdy7bVKG
         7Nnxp61ZsBxkbPq2DviKhbqpru4386jownqgIidqEdhk88x3ipCPEvqr5zxr9p5zR5Gm
         z7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239702; x=1768844502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A07SgJ1fsgZRk6pJH2onVqP51GLUJvZFCH58RCFF/AY=;
        b=w9IUWg3yW4plUGA8n8hgjKZFjwM6BKoeJrYaPLMuFHG2cDxHiblN9qoticfP7RgDqD
         qqCSJqifuSql6I5b/5xJYKhXIDy4DNnwC1DrrdErCXBtRe8CJZnMA3li4V1LTZgmK3XF
         LBpAyM/CVcuRRRullLyPaQHFSb/q+BKNIxhcdf8Fy1lfhwIOh1/L8kydI5kUvyVrTjFC
         1+9W0vloPBGy70CcffhAfElIzJPUIcXA7AzaDFmVu2HB5q7QkV4H31ezC38azgfQHXH7
         /q96Ssp+t7k9uztHwZ1Squm+onfVKT/m/JVQ9QGgdKoodXuDIGgN/YjEJn6YSdVsS3hn
         PWRA==
X-Gm-Message-State: AOJu0YxG+AKKk7ByOKJeTAN27ppUCq5dnsVZeGUCzBRPWSSVbLQVgeCA
	2eK77AiLndRVu73V86FiJqyP/GcavU3/udlVAvEoEJs4soGhM6p9QV5B0kCWwEzoZq0DcSFn4+V
	juv+0bw==
X-Google-Smtp-Source: AGHT+IEwGpVANSvTbR9Aipqb0y4/KGX9G/AophtiXifbbe/b5Bc1vNYTpvzP1O3q15q4W4nqFc6poc9R4kg=
X-Received: from plbkp7.prod.google.com ([2002:a17:903:2807:b0:29f:68b:3550])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:939d:b0:384:f573:42b9
 with SMTP id adf61e73a8af0-3898f9dd0a2mr18374473637.67.1768239701885; Mon, 12
 Jan 2026 09:41:41 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:56 -0800
In-Reply-To: <20251113221642.1673023-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113221642.1673023-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823893687.1370888.9283265803166208148.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Add fast MMIO bus writes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 13 Nov 2025 14:16:40 -0800, Sean Christopherson wrote:
> Add support for expediting fast MMIO bus writes in SVM's npt_interception()
> to match VMX's support in handle_ept_misconfig().
> 
> I don't recall what prompted me to write the patches; I suspect it was a
> "well, why not?" situation.  They've been sitting in one of my bajillion
> branches since May, and I rediscovered them while looking for something
> else.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/2] KVM: SVM: Rename "fault_address" to "gpa" in npf_interception()
      https://github.com/kvm-x86/linux/commit/737f2a382f89
[2/2] KVM: SVM: Add support for expedited writes to the fast MMIO bus
      https://github.com/kvm-x86/linux/commit/01cde4eaaeca

--
https://github.com/kvm-x86/linux/tree/next

