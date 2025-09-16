Return-Path: <kvm+bounces-57649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A14DB58936
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8983F4E261E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D381B0420;
	Tue, 16 Sep 2025 00:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ustimBcy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF0C19F43A
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982357; cv=none; b=Zfem9FgXpYCzlXXB/dyRWtV721WLkHCFDij4hlJ2Syao6hylpjNHhpHoOl38MI1Lsj5mUEaeP8ilIWjHdEs34VCjFQon5gmpO9+va83BGfgsbO9twW9Py8NsWuZb4z13Tqi3wzI9qfFwZOwnP7X9PkYzGKT0E9lwsNR2D3SD9NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982357; c=relaxed/simple;
	bh=E/de48skkARmukqAoxeQ9dfDPu/mldn9SPasCaWg59M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VtqAGRZ1P8evgy8iuBr9mcMT3aGD48sW/YJ8SolbHDH5WSheRoaq5lHecpvHM+CL4IeSmCHQCj3+csEBh3IP6UAYdaCXarUYRLASI+HQ/9+bGdRZ53wZ83eG5jDgJJ0aveFdo4qImiRS8MgnGmWUrsVaJA4GnLzLQqbWIbqD5S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ustimBcy; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24458345f5dso57136565ad.3
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757982354; x=1758587154; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BaSliU/Qp9/+sHRYKq5VI0MpnDs5e9LG+HbU1FTeWqM=;
        b=ustimBcyJL9fQImvXMEQHuPEFgtCSifF3ERbSQYLHS8zfbVFBV1KQ73Rtsla7KWezI
         4IuOgYtHzKXmkDXw0vRxfClvmCDizCiE4rRj9i/t58uBQ8YOIR5HzLDByiVXA1LjVpnB
         OMlEpglBrkK/YFfs/rxJqnnolZZSNAPL++3/osZRgp4Sv9TUrwcpyuD3f4ifLApv8rlg
         Ftwo1YILY8MxEAUghBLc6jq6wDWq3UsPpy+LJKAvGoUOrXFtppMmKLqR5xJO21cRjNB+
         RApWmMvy8vMHEJEouXpxcoyzDhtH7NWjjm76F0UC4joXWUqzPRSvbqtTSBIHv1FxMfkI
         W3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757982354; x=1758587154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BaSliU/Qp9/+sHRYKq5VI0MpnDs5e9LG+HbU1FTeWqM=;
        b=MgIm+GyGhjUvuCvber8xx04cqSG1UTtHPdFt9osCW5awx+1ChSgpfV+c520G3ehKcZ
         tNsxVVJQcJQnICs6h7qZn6nXbcuuyISelE3uRw18Iue+cDaWo3SdQSMKL/Ev7HcPdryQ
         t3Xct5VwChZ4h3sBlV9ZXRfHObFp4dM9XXG7BkeuEz5sh3H+CYtnAuJ1Fmj6WqK/ehsX
         lCe2LWuHZjhyDp3dTW6ekC+geQkPg5eiwrh2i2NBvQweA8bYI8FYNmKc+kVKidubvCmQ
         oAY8ALRR3Oou4perkqmwjpqTVeDG8M/D0l/0efVpVaf6mEGZZcOLzKbCurtLfXIl7fHK
         kl0g==
X-Forwarded-Encrypted: i=1; AJvYcCUA9c2uzeRrM8CGy6wMDMgy6qpt6f2n0iblR1MwEXsCYfrKzjMtCD34MAOZ3ZppPyiC7Qs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB9wZEiCHOUyQOyb4vqpoO09I92pGP+1FzAB0y0bF+pAujKFo7
	UrYm3rFZ8p1uoYPT/+fqlUljU/dX35cULmiatk5S78nL7LuIYctexDX95We/CzVXd8GtAgu1EQB
	5JbEGgg==
X-Google-Smtp-Source: AGHT+IHOQzoWratRa3KzsT8Q/5SHJa6zw6V9nFNlvLqY74TjeW9ZR9cvV4jCcml3ZPsjaO73z8IOeS9HoRM=
X-Received: from pjbsq6.prod.google.com ([2002:a17:90b:5306:b0:32e:834b:ea49])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c2c:b0:24b:2b07:5fa5
 with SMTP id d9443c01a7336-25d26663dcamr173825965ad.29.1757982353968; Mon, 15
 Sep 2025 17:25:53 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:25:31 -0700
In-Reply-To: <cover.1756139678.git.maciej.szmigiero@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756139678.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <175798189623.622616.15058554259906842549.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: SVM: Fix missing LAPIC TPR sync into
 VMCB::V_TPR with AVIC on
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, 
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, Naveen N Rao <naveen@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 25 Aug 2025 18:44:27 +0200, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> This is an updated v2 patch series of the v1 series located at:
> https://lore.kernel.org/kvm/cover.1755609446.git.maciej.szmigiero@oracle.com/
> 
> 
> Changes from v1:
> Fix this issue by doing unconditional LAPIC -> V_TPR sync at each VMRUN
> rather than by just patching the KVM_SET_LAPIC ioctl() code path
> (and similar ones).
> 
> [...]

Applied patch 1 to kvm-x86 fixes (will get a PULL request sent out shortly).

Thanks!

[1/2] KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active
      https://github.com/kvm-x86/linux/commit/d02e48830e3f

--
https://github.com/kvm-x86/linux/tree/next

