Return-Path: <kvm+bounces-57662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E47D9B58978
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:31:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0562116032D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 155BC1DB377;
	Tue, 16 Sep 2025 00:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n4aTSkGX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3611FCFFC
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982566; cv=none; b=fWQNdjqIX888dd0dp7IBH4yGQY4lwD3t+HtoGA7qRiGDJewu23A/5+nagFCBbBtAyKUdB9e34Q9pZH1jbyxKdbZAjcbFQsWPM/kKcQwUpZiQJX3ZSNNu/j/NdIOOSwifHVHglk6JE1fenQiGdm+OGI6cw2pWCxMc1WrRRIBG/gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982566; c=relaxed/simple;
	bh=fZMcGOq8pzFqzBnyHPQZyj8sd8INTo/alNIKN/HnQlY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C2Z27QVd1TrVZTJdOYogGPBDSG8wszs1uHNCvgCdPtHovGFDLbZ/g5dNbLASJlSjzhaRBZ7fEaDuu65WM2R/qY9GVMH19qIJKHQUubhY22gfy4aovehmTxZOF13iXJ7rlI2ghMlc7Mh5tkfraJrNf+JWIAVXAwT6QvE5norn7fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n4aTSkGX; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-248d9301475so71231585ad.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757982564; x=1758587364; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=59afqtQ1ZW4R1cwGm0JEKyCwHwkB3xWI6A7bm2gudqM=;
        b=n4aTSkGXoc/GlinVw9BLDYsvwuGIGuD/7aef/LYWBhsmhKyUF++oDLXmhhJzLIxOAi
         nU7znwjhnMvsNuOz/O/HkaM9mjgAAK4eboT2K6w9ie8Wi6cLNd9gslMLuqgzFsPmJFyR
         DNEilqhBVN5cuOkcyqVVpu57gQw2vW0O0sGqxs2FFW9fyocsNuSYOkAC7XeIrbu5AO12
         nNrDx2cDbtozMlQ18b0sxnljvn5qZBtwh02vSVq3BiTz3xo5XUuqQm7DH8YHtqrqhXlz
         bqJdGZ1M/4Si+lZa6NcW3US/KPmO11pND5wEDrB0JA8vvxrTUaZ++ZNLW19pi7yTiNpY
         v3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757982564; x=1758587364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=59afqtQ1ZW4R1cwGm0JEKyCwHwkB3xWI6A7bm2gudqM=;
        b=jAGKVvWGsVahv4MNxoBuIM20QyhlSJcI41TUigluo4noeviBxXkQNVbx0NuORvOGdI
         mpXgUFlc4NcQPxekrfWCsSTb6qTBw4c52SvR1Unh2JsebFlgeCUx3aabPjf2KG3FXjPH
         97okmMILlcxZLTYlSRPDx9zwWHVkejiXF40S9NNMLM8/2ZskdMOXGMLiL5ee5m30a260
         yI+IZQjs+CHJ6ag9qQrEjeFBMY3B5okMqvzqsukBADD8qdlzCIJUg6FKUf0nOqDlgez6
         oKm+MDGto8BY2zQ5pLaISfS7lQMlxuk5AFV6weKOrXkw1QWcaK21JiXjCBBpa8oIed7Z
         2mRQ==
X-Gm-Message-State: AOJu0Yw856hamxlKvabSrXxyLnF5pHHxx1BafLJCWrh+lwkGPjOTY83j
	nBiAP6MLOj52+UCKv2bASZiMrHGGTSdKzO4YF1qutKgpEnLpi4vgSRPhgGVRfmXGnUn2QkE6wnK
	RBWueug==
X-Google-Smtp-Source: AGHT+IHdRyVQ1cTTutce6si835oernHf1LkOFl/hzxk2zcb+YDP6Cz1iCOnHtPpotb8+e4+NPdghVuEgiw8=
X-Received: from pjbsp14.prod.google.com ([2002:a17:90b:52ce:b0:32e:9dc1:de9e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cecf:b0:246:cf6a:f00f
 with SMTP id d9443c01a7336-25d2647015dmr196452855ad.31.1757982564063; Mon, 15
 Sep 2025 17:29:24 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:25:57 -0700
In-Reply-To: <20250903002951.118912-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250903002951.118912-1-thorsten.blum@linux.dev>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <175798208020.624679.16533836332687059035.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Replace kzalloc() + copy_from_user() with memdup_user()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Thorsten Blum <thorsten.blum@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 03 Sep 2025 02:29:50 +0200, Thorsten Blum wrote:
> Replace kzalloc() followed by copy_from_user() with memdup_user() to
> improve and simplify svm_set_nested_state().
> 
> Return early if an error occurs instead of trying to allocate memory for
> 'save' when memory allocation for 'ctl' already failed.
> 
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Replace kzalloc() + copy_from_user() with memdup_user()
      https://github.com/kvm-x86/linux/commit/fc55b4cda00a

--
https://github.com/kvm-x86/linux/tree/next

