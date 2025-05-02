Return-Path: <kvm+bounces-45263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 513D2AA7B9E
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 23:53:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EECC9E18BA
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0992206B1;
	Fri,  2 May 2025 21:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V8igox5Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37EF213E6B
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 21:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746222718; cv=none; b=GHbkTE0se5WGOJxq1kt/yGI+lBbczoUtFx8COCC1cqall9pU8BEiKkXeVSDB3lr5mFhZAjPpkxCHSPvkkl1MOl5HHWwJYf0u8z3FE4tWYEPPsqNHa8zpMZiOsifQVFFF2jxZZHZ2m7ayNHcuXc+SCYDEw9I8wBMUryI2vp00ieU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746222718; c=relaxed/simple;
	bh=t0srD1L9u4P2v6/M1d6XMcAm3mk88fpVP7WvFeZ7tWA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ISY8G+Mdb9kTgil0Jd8rUIOTWyKHX+ptW3fp/+zy8ZoC90WxXm/gKupO5nPMd2+L+tRjc+VYwCTdeOhS2U/Xp3NkxqUpZ8Y6h+M2Rf4uCfdL4tbpqdyd06QyzdhYoXw9r3/Eh+U8YO955dmqvq89OaY8ybV9QHOl2delHo/jKwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V8igox5Y; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b048d1abbbfso2297190a12.0
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 14:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746222716; x=1746827516; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4a/Khuya/BSBpKYNsqy1jJpBLMTdoWPEQMAY+4XPHVQ=;
        b=V8igox5Y+F7t2YP9ZnRcYispxff9S/z72/LkBpQA9l5EdZax/qhJ4dwBtM7OVd2Eja
         RLVbKCjuIvyPgGUm6fXp+BSbZIseW3DMnji3xzqhHB8X0exGCKi6ZqzLz/UusmUDYSpp
         /Py9YtXxX5b2bo4csTtCxlKxGOjgjrTaE5RPbqGAAGH0hJgYKyT3DJHmmw6dHYtHy8i3
         IVu0eaZwtJCZOXsX2e6fXoQ/uLE6V94ORavrfFodT+lA/7JyiAOxjio+FQseclELVaco
         LM/ulC0uVY9VsWrCdw9ywVFswvKV7rzDqM2iMvGIGUg51sJrrNnfvWPCe3MOMcUgPWTI
         1JWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746222716; x=1746827516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4a/Khuya/BSBpKYNsqy1jJpBLMTdoWPEQMAY+4XPHVQ=;
        b=TZLZYZiZbanjuCDG8uX361wW9u3WObS9LXDm7jlG9XrIa4jRxlLQfEjJkVXTuDWEoV
         j+VQq80E6NXk3mQV3xmv6dAtoADcIaaG9cWvQXk+OoX+kTEnnsZqzklBGtlXnhlWjfvz
         oR+lkrHQk/FKkm4Gz5SI2wX9zZ8vxMl5H4eq9e41enY3IpLZWuPjyPYAKJMDiIRIeENP
         mcEqvZFlJQmC2HkMP7EY231nmED4fO3/y4pHJ9cRuceV2GZR9QfEj2VemPEFA0pQkyDv
         3160vjEV9UiwNowzbya8GAN44wj97EDHb6bJ8sTClKvfz+bknFu+dNwIjR0oQzBVAr9U
         iKjA==
X-Gm-Message-State: AOJu0Ywu4NRersKt14nWEVIpj5KU6ERR+jD79Pz4eI9CZjWy3OqqNAMU
	0IQbbf+usRHnY4vYxqfNZkpxeI3D0526pXqlJxHLtEOWUnqELsuTkcA6VT5XudOTfH7QAkgrvbU
	/Yw==
X-Google-Smtp-Source: AGHT+IEyVRTIezKeBRzOebiat8MYUPgDKfnomEsVO3RqA6J4/k9ASQm3y681CjFIJMSf3uZ/B9+SuAbFi7E=
X-Received: from pfhp37.prod.google.com ([2002:a05:6a00:a25:b0:740:813:f7bb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1fc1:b0:1f5:9175:2596
 with SMTP id adf61e73a8af0-20cde952c49mr6897772637.13.1746222716141; Fri, 02
 May 2025 14:51:56 -0700 (PDT)
Date: Fri,  2 May 2025 14:50:59 -0700
In-Reply-To: <20250428063013.62311-1-flyingpeng@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250428063013.62311-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <174622239020.882389.4889943356461960692.b4-ty@google.com>
Subject: Re: [PATCH] x86/sev: Remove unnecessary GFP_KERNEL_ACCOUNT for
 temporary variables
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, flyingpenghao@gmail.com
Cc: kvm@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 28 Apr 2025 14:30:13 +0800, flyingpenghao@gmail.com wrote:
> Some variables allocated in sev_send_update_data are released when
> the function exits, so there is no need to set GFP_KERNEL_ACCOUNT.

Applied to kvm-x86 svm, thanks!

[1/1] x86/sev: Remove unnecessary GFP_KERNEL_ACCOUNT for temporary variables
      https://github.com/kvm-x86/linux/commit/e0136112e99d

--
https://github.com/kvm-x86/linux/tree/next

