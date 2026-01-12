Return-Path: <kvm+bounces-67802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D1BD146E7
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:41:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A0DB23019BF4
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F7D737E2F9;
	Mon, 12 Jan 2026 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iJmbeRXA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81511376BDD
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239627; cv=none; b=HP5ENdKs9V1NhxTcIgfS4WjmWkgWU3kf2YnTXFMq12+B1Ju9/CCSP6c7TIZu7b+DqvFPRROELTUXp3xcae8Q6JbaYSBVhxp4a7KmarcNo/+1/QyN5dHiwdgINiZd1m8WPIZLzqxOHcEpZGwxUrZyQjiPgwyrtyd7q38l2wPpa0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239627; c=relaxed/simple;
	bh=e465do8mTCSq6jCcBPw82MmLIgs8TWi8DhwOetVjcuk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r4vwqbY+6Lrz6XMTR3ZjO6OSStITE8elLqDzQQxZiqcROvENjo6zhOpdOtwaraPKiaAPC+HhW2rYlnUoDAdaGGi4YN85ZGXxppTcfOT8CuHD5E00el4yzSeNtQAhqH6gOZAT48xr/l/v/eO4obIo3nI4boW6UbklnEf6G26O+kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iJmbeRXA; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c337cde7e40so3682999a12.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239626; x=1768844426; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QA8lrtEsLeAJYV3cxgMyR5xiZ5dk8thBjeZcy3q6xNM=;
        b=iJmbeRXA9XanKOvF8OF3S6JyuZRyAkY8XkALItbasTu/Iqdj+CKUa1Life6cFdlxta
         Qs+pyRbXl5ZWW1k/uAD6qy7V18uniUlz2wWXj04vJmDf54IOWuJbYNovPhZ5HIOdOm22
         19F8QzjAs2TUNMvKVJf4vt4XIJDyoSEBvAswj7aT3OCMBavwqUpQg8+CpDwhnOg++wTb
         nH3F10tWYuzmIsMIA3OtyaLqQkA99ZC4E4f5X5uoVMGkVn7tELIxfE8QrLyVuLJ7mh8H
         /MeejwjoKtYH/Rkn+eovWQr5HjwGULbKs7N5NXEd32ti5zuC0qRpVbKfA2ycDKXJuJpk
         myMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239626; x=1768844426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QA8lrtEsLeAJYV3cxgMyR5xiZ5dk8thBjeZcy3q6xNM=;
        b=BK/R1pKn6RIeOLzcBeykI+QSTFZKcdPAVk/BPT2fsQBNRQPC/czPORj4WD86WbwLyr
         ss94MD2mk/MHWSKWuVVn5XxDxKHlzaVYU6ai3MLX/7Pw84szrstb4Y3vbBTmveI7KYL0
         DCiz0fQecgAVQwX0Tr1edlJrJ3pGkeC2CnHKwViyX9l4yJk+6ep9hZwqnRQTCXcNzL15
         Rdq4myQhKfu4b18/i4X7psxz09QepRRiEEHNeYiOMWM550oVfqdP52BseQ4jycvImf9X
         bil08C0l8UmrVg6/BiWED2/ewWGT6iMn+LEUZMhTJujKxmxxhj61J5XuT5t1RTiB952O
         2KVQ==
X-Gm-Message-State: AOJu0YyBdpGE5WvsNWShOasBiVfiu1yr3YRtbDoac+3+xBgAX5/LR07v
	8yBZT05cMZkxiWdXwiXs/kJrp9NrHyzGPHnaHdgjd7gUdAsKmBUpopuI8LcIPCItYsUhDpxmrCs
	BZGjDcQ==
X-Google-Smtp-Source: AGHT+IGlKf57XaO5h7Wqp/jcsHy/f04+Z8QyhdclzNa9x+ohD4YNMeq4TjEPmB09McrkcVJued0fiiORTYo=
X-Received: from plbaz12.prod.google.com ([2002:a17:902:a58c:b0:29e:fe54:8944])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2450:b0:35c:dfd6:6acb
 with SMTP id adf61e73a8af0-3898f91cec4mr16610770637.30.1768239625788; Mon, 12
 Jan 2026 09:40:25 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:44 -0800
In-Reply-To: <20251121190514.293385-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121190514.293385-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823924074.1374169.120221674826221123.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: Enforce use of EXPORT_SYMBOL_FOR_KVM_INTERNAL
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 21 Nov 2025 11:05:14 -0800, Sean Christopherson wrote:
> Add a (gnarly) inline "script" in the Makefile to fail the build if there
> is EXPORT_SYMBOL_GPL or EXPORT_SYMBOL usage in virt/kvm or arch/x86/kvm
> beyond the known-good/expected exports for other modules.  Remembering to
> use EXPORT_SYMBOL_FOR_KVM_INTERNAL is surprisingly difficult, and hoping
> to detect "bad" exports via code review is not a robust long-term strategy.
> 
> Jump through a pile of hoops to coerce make into printing a human-friendly
> error message, with the offending files+lines cleanly separated.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Enforce use of EXPORT_SYMBOL_FOR_KVM_INTERNAL
      https://github.com/kvm-x86/linux/commit/fc4d3a6558af

--
https://github.com/kvm-x86/linux/tree/next

