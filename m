Return-Path: <kvm+bounces-3045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDBF80014C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:55:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C2531B2114D
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC4A1842;
	Fri,  1 Dec 2023 01:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2uAaqd9y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA3D193
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:55:27 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5c5e6009b98so65948a12.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395726; x=1702000526; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pMhvVnG1xtueP/HsDnRWK/I1MYO4nqN51Oj+ODgatFE=;
        b=2uAaqd9yZSN2hL5czgo7m5dqLQft1E30C6ao4gy5jTa07sXGvDDQ+h/XR4PadhLClP
         sJphvnO4aE4otECQkYfVPBNZctV3nUwla6KMBKau5KZv0RVRI85Pb/jGbgTSyE8NrWnG
         FcpuTPjAbAjcu0Ub5fWEtoR3aPHUJX+8ZYmL7d0tFd8ajcO6ateI2b7XwQdPil/H3TS8
         4xo4ZQ2cGMKBayaW5mY1qpDjki3sjXS+5eEE3UJeRVBTqKOdZfLuVodwU0xqKfsNmWr0
         dU+O+/YxN4Tr7ooP/Spmpf9S9tWe3rVc7pHopPnm6sRpV5SQNrlI70I/AafHKnGBFVNp
         0LwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395726; x=1702000526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pMhvVnG1xtueP/HsDnRWK/I1MYO4nqN51Oj+ODgatFE=;
        b=RT+i1jhIdBZUD1i2Rsmil5ULiIvdsL+5Wvl31erbWebnP4KSvo7uwRNkzeY3c6n124
         d1yHVm114DQTX5knYMyX+5gAJ/np7bEdS7AYMqwz9HpPK1WSf919kic2sVcdtr3M+iki
         gi47izLIn6sir4MVrMm8IvhhmVZTGgqEkH0o2eI1D29bo8p3L9QOPbbA311KrqrteWsj
         3bkMpF3gxZRJ6pNQF3lNiiOy3zssylO3U51k4vC5gKWIDj0jtInsWDinYLorCzpW30bD
         NxiQeLqclSZ0ODt7Rr8u2xHJzXGhB6IA2H10PVzTxiw2Py9vhwocowdD2qxMp6sjIu4p
         HHDA==
X-Gm-Message-State: AOJu0YxkxH+Y0rJsy7LhLs9bwuohOy8og+C3t7lwHLjrLTUuN26LyldP
	ulJH///v7YcBdHEcTg/7+C0/OQ0EFjI=
X-Google-Smtp-Source: AGHT+IFZDuq2QNjNPRnHN4aVQNGYUElwPt9YjKngMF6v5aNOkCANgF0oTZK/lZARZLlAwxkfL96Likvx8ys=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1143:0:b0:5be:3925:b5b7 with SMTP id
 3-20020a631143000000b005be3925b5b7mr3791544pgr.5.1701395726312; Thu, 30 Nov
 2023 17:55:26 -0800 (PST)
Date: Thu, 30 Nov 2023 17:52:16 -0800
In-Reply-To: <20231031075312.47525-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231031075312.47525-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170137839626.665770.1806442754055441040.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM,VMX: Use %rip-relative addressing to access kvm_rebooting
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Uros Bizjak <ubizjak@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 31 Oct 2023 08:52:40 +0100, Uros Bizjak wrote:
> Instruction with %rip-relative address operand is one byte shorter than
> its absolute address counterpart and is also compatible with position
> independent executable (-fpie) build.
> 
> No functional changes intended.
> 
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: SVM,VMX: Use %rip-relative addressing to access kvm_rebooting
      https://github.com/kvm-x86/linux/commit/15223c4f973a

--
https://github.com/kvm-x86/linux/tree/next

