Return-Path: <kvm+bounces-57652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1567B5894D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 809811B25CDE
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F7E1C860C;
	Tue, 16 Sep 2025 00:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xzDtOXgv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB6F1B87C9
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982466; cv=none; b=YgOgtG6wy/4fEJ1BWxB6Y300af1ScLZelJ8+4Vx9Re+kvLaBXJq0YoXkzG00ctFwq+cdA5s35vdl2YMtrdsnOO+ekMlFhK9YNShklxvXcwS0SkHv4j5HDtBpI12c2mAVmXejr/cb/esgJSPefLsRqkkFZLVm7vGkDsaHD3woqyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982466; c=relaxed/simple;
	bh=1oJy3t3D9A6U/J4Pp8/Z6t8AcYSf4anlFOYj3n/kmic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z9Z15eXRweOMMhCJWZRpa4Yid74b8BDE+7p066saAm7KT6sZb6jFE5QSxHhpnpzmzUQtOnM7ADtssWpeRXR0CVK2NB/PbkiUed9T5OXdid4UJ6Zkaj7ch+4Af9Qdw9/ws3QxRsOirwlcuCfXYnDFNn47LrelbRh1szUx+bjDPks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xzDtOXgv; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-265b1c650a0so17772905ad.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757982464; x=1758587264; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDbjWcZNzcieNmuA7ISo7ilZYMwwvvd15EIzi1Rs304=;
        b=xzDtOXgvjcIk0P8R4Z+SUpCxaxMai/w+LRQJN4gznvQ/4+LUws5RHz0EuVOSiNJy3y
         dpyz1Mp7tsBoMc9CykRiKfbvn075ojCE6gpKASfUNSjPUncsALYwZabiDvnNF9pciT75
         R4JhAViltttSj7P4qelzICfCvPQ5jCg0gnC2HuekZZGv+MiF19UCaa/awujFeyp82UPY
         Tf+80FNRAbPjN3wDpXC19TPtxT8jEqgRJ0Kr5e/4uS8iJg0Rp1DRRypwK/IdjZlK7Ase
         IQF2TC2pCxsauorpAJ2born0fmeqKmkQOCk33RCvw9MSUsxKEkb/ehyJdSF5WsYbI9G7
         ht3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757982464; x=1758587264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDbjWcZNzcieNmuA7ISo7ilZYMwwvvd15EIzi1Rs304=;
        b=r0TDiKe5CCsU01T1iqz+USwHkuHjSpWr4yCHPFmbfAIJ3u3nY/k6sEzf2xpLG4jmjm
         O1g47IVIbIdqxJin0E3RxIg5VxmmhDsszKSzi5rBVuc5/NXiPkwJtqsrbCiCsGXwxc8T
         yKl7MxveEa8rkH7m8EFkyrvX93o64ngSYKsjj4It3GrEMGKAHUgv2CV7731Qq+jTdPTX
         AT6CsxbQGateGQv3UD9AmJnC/Lyac9HK7qm4CnNqU7sFH7/MZPyH+MtD/VsnZfMb3kOm
         d4BIca6Ljd7YVGs8ft80YLaHsgrVxWXX77P6dsmWY4ru6fpKvl0ML8Svwk6+txHs9NDb
         vVIA==
X-Gm-Message-State: AOJu0Yyj1TcZlezQz/PRxWdCeSOBHUHWfWlbIaBTN85iaUhJskw7m6RW
	eZrew5uTizhIdYWRDEwHBy9pihMXG3RU796fmg6HvNPHBgwAxNBtqFc4Y/NN+wu9w2qvtrh0SKx
	3whvQNA==
X-Google-Smtp-Source: AGHT+IGcLhcUiPZLuLKKgf6Vk/vqvaUj+Rsg3wKEDTuj0TzSmlSBMrE7u2VuuWz1jgCPWuXQEzKnlZuh00A=
X-Received: from pjv8.prod.google.com ([2002:a17:90b:5648:b0:32d:e096:fcd5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db11:b0:24d:1f99:713a
 with SMTP id d9443c01a7336-25d26865e66mr186677515ad.31.1757982464308; Mon, 15
 Sep 2025 17:27:44 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:25:37 -0700
In-Reply-To: <20250729153901.564123-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729153901.564123-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <175798204580.624108.8402197370232306041.b4-ty@google.com>
Subject: Re: [PATCH] x86/kvm: Make kvm_async_pf_task_wake() a local static helper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 29 Jul 2025 08:39:01 -0700, Sean Christopherson wrote:
> Make kvm_async_pf_task_wake() static and drop its export, as the symbol is
> only referenced from within kvm.c.
> 
> No functional change intended.

Applied to kvm-x86 guest, thanks!

[1/1] x86/kvm: Make kvm_async_pf_task_wake() a local static helper
      https://github.com/kvm-x86/linux/commit/657bf7048d77

--
https://github.com/kvm-x86/linux/tree/next

