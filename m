Return-Path: <kvm+bounces-67811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 802BBD1476D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 031D4307D578
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C0B37F0E1;
	Mon, 12 Jan 2026 17:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KM+rI03t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8DE364046
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239748; cv=none; b=KklANALpQGnF2oBzXa6agsua18CuxFXjTWQwQTmEmxH89OZQd4HDW/YUxVw9nTcI05IZSFPz8/LKjiSX9xZhZKI7OYkSM56yK/C+8lq4GgoLYKk0GRUyHrtnJLknucspYr6cH5S/lfIwOIySh/3k9N0J8upYVSAO3rRqSgiMjJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239748; c=relaxed/simple;
	bh=nLzC59QVg5wxNjld3JJPj0J8pqqhVkwuWatN4BGrdJI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tf1Z9nHc896DSHvWRPzNTfOkIKDzg+51uNAM7FP7aD0tKwDjkD/wLbVnLIK/T5gUfcuR+gzCOrZ9yjfbxVUIpJqne64NPSBJErG5wWN2VnzcMNPYqj75A1QYSU7rCtogrf9YMJV0OaFsVwErgRRcdIhdqUkios5zYvULzVToIlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KM+rI03t; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f25e494c2so57920515ad.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239746; x=1768844546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Duc3I+pOD/chbIn6Qhm2ZICCw8a+HZxM0oXYju10wy4=;
        b=KM+rI03tJhbJzGlelVBcFd2LOAPfnTJ+aV9LBSAl1ByCkE4twrZgoqUVxqGG77CiYb
         Li8dbn7qqaYBRc9Hy6OuvAWG4ZpmC2HZwcdJx0Tnj6u1PDin7RSvnAvDWfYYJi7lAAR8
         pVrCVTzTx1Izeg5DCvD1RDZ369YYym/vtCHtKLts7Fln8meOdJ0Be29V0/7FelAZ2JlP
         /g/T9LhlLCT3Bh9srAU85rFSvAwKIsgWYQwiwbJqJPzeMKqeQWHCaDoTr5MrJ1n00KfD
         xFyE1oOA4z7DjWBfdn3ke8fp72NTGI9PmWu+dIJNZ3cMRr8HvXT0Qpn9FT7FGUni+HfQ
         FFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239746; x=1768844546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Duc3I+pOD/chbIn6Qhm2ZICCw8a+HZxM0oXYju10wy4=;
        b=YDTOsIGEBl0RzDWJ6veyMcLT0pXsQqCgPCtdaAL64AglgH6RvEROoZA8Ku7gsYMZNd
         QHF7bgpN21Xtf8DzvG4IPasslBKks6R9xIoHnCN42PmxWop0VLOVp3kqlcN7zmVJHtuP
         z32cvKpF+6oD4+DxLiHzu2C/uOoRrdmc7HU3mUW+bD6ZnIrry6LSjNejKO6ahM1U32yC
         Jo6jLTEDXAzHcFvju2xz1kMpO2QhSZHQACRV6IirYbdkrjbOnu9Cjt1Di9wZGTcOpczi
         C2stvbA1GvqquqGAf4wiwIo46P1kNIue3ZM4oMT7ehYubI60gwDgPk7GLovsUcvT0Jh8
         eXTQ==
X-Gm-Message-State: AOJu0Yw1B2GDg9LmA5fk7dHxe0vHMjNKegpmgZL6Zq62oz9keCYhtc+q
	+WHkpOamuS34G2hyc/vvG+2aboPIOJ+TbM8M2UX7eRKMFoWOSEL/5iHgfoDAj9SEaFUz3Sytr79
	Y6k/6sA==
X-Google-Smtp-Source: AGHT+IFn8ZPY20Auyud2qiTlPihGQBoA1f0v3MRk46Zm+KFu7Pytwkzlw4T3eS2LOGX1ToTFS0cu89UxGI8=
X-Received: from plor8.prod.google.com ([2002:a17:902:8bc8:b0:29d:5afa:2d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c5:b0:295:28a4:f0c6
 with SMTP id d9443c01a7336-2a58b414e07mr1772975ad.0.1768239745880; Mon, 12
 Jan 2026 09:42:25 -0800 (PST)
Date: Mon, 12 Jan 2026 09:39:04 -0800
In-Reply-To: <20251121222018.348987-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121222018.348987-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823901501.1371726.15879387751613608587.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Always reflect SGX EPCM #PFs back into the guest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 21 Nov 2025 14:20:18 -0800, Sean Christopherson wrote:
> When handling intercepted #PFs, reflect EPCM (Enclave Page Cache Map)
> violations, i.e. #PFs with the SGX flag set, back into the guest.  KVM
> doesn't shadow EPCM entries (the EPCM deals only with virtual/linear
> addresses), and so EPCM violation cannot be due to KVM interference,
> and more importantly can't be resolved by KVM.
> 
> On pre-SGX2 hardware, EPCM violations are delivered as #GP(0) faults, but
> on SGX2+ hardware, they are delivered as #PF(SGX).  Failure to account for
> the SGX2 behavior could put a vCPU into an infinite loop due to KVM not
> realizing the #PF is the guest's responsibility.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Always reflect SGX EPCM #PFs back into the guest
      https://github.com/kvm-x86/linux/commit/ff8071eb3aa5

--
https://github.com/kvm-x86/linux/tree/next

