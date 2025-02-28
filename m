Return-Path: <kvm+bounces-39743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED524A49FC6
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 18:06:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D437A174CCC
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 17:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398EC2702B2;
	Fri, 28 Feb 2025 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fjm9BZTj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D98189B84
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 17:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740762397; cv=none; b=owNBQNip1iV/j0aBW6Yxt50gElfYroSfc84RccNionh4ecNqy583Q+WftGExB86dAaaq8tl5PCWjACV+f4DW2o9+19uWZT4lF0DL7mwlAO1mupwvSoOaGrf2Y20/DYS4RXn0DGsUpo87VRnLKmcZ/cgINW0sv3AN9qvjukYceRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740762397; c=relaxed/simple;
	bh=ZNlUa3CeezWnmzy7Kq8Of/zcrmreAtTixe78APIx1Wk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SFMcuzPr1ZPnqet6DvhgGezjsRo/9vgfF7nBuT/K6ZPv8xCMZyk2mLSq/HmtY9JLU9+MMN1lKDelWHJhF7H9HSaEaW6mQQpwoJsqftgPqWyXjUkR6fYtfB1jjUcgVgX7t3y2LwIkxNlwu5crPlukz9sBlULbGw8z5n9H2BVEbI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fjm9BZTj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22334230880so33560705ad.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 09:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740762395; x=1741367195; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eWP6D9WOs+e2iJqyvW8XyE8+noGjj4tp3X4+/PvTMxU=;
        b=Fjm9BZTjoKL4MWjNfTKCpPATlu1Y1ri/xaIHV4MwJdVDy3a4/cUcGi+RC6DLFeQLVT
         tPfCDbvgX01C5eRsrooK1IIUIi3z/Y7jUH6eBTGgQvoCI6mEqvotGd1XCxaRTe6iZ+LN
         hyopbZ/afXP/uClLyqJbZwflNiKD2mPjTM8ZP6FzWT5ZGT3LzGjeHqo/Zpmye+IpmmvM
         Jwdcuswg9GjYK/+d7Lwf0bLQdajQanM29W6vqxrJCA8+V+UmaN3WATs8FJ7oj4SB75Vz
         P3c60XqHOFmT4bVEgQ0vLPeOWRI+dn6PeAZ6c5n66r/wP59HlLN6u9RjSjIUhjQmUJJZ
         9cgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740762395; x=1741367195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eWP6D9WOs+e2iJqyvW8XyE8+noGjj4tp3X4+/PvTMxU=;
        b=OZHUL7//90VLDZXE29CrThMzQ5cfVpccNOe0b33C6vAblEmlhTkw9oj/1AB4QecFBa
         0PNoq6Bw+1SniW5Bl+ArwFVSA6H9QEi3CIsgN0aXMTPFMskGI9THUAdpuzfIYBtbNH/l
         PfoiEe6W1ioGTrmmahDT0IC6FxXXG1cjIQduh6h/Z8NiI8jfLjq2AA6IgVZtP/tCQNej
         JZv5DUm9hwr9JSo8k4zPVKzsquO+Entpqq7fUEVKdcKDjWtdFGQWiIPeVNNMjX99rp/Q
         AAeNJcV7bQTfx9502S4Y4pkihsMgCpoU9VMZqZ/x1DvcBOpFNoQdMsSXbUBenI1n89Pu
         fnlA==
X-Gm-Message-State: AOJu0YyIsYwcpBz7c4E+OdPPeCm/MI+xhWPesJM9QH4Z8JnoBa+8dwTQ
	7Jp5/fbWtoN62HIEGA8NgzYqMd40lWxuDewdOGaAXrWBhpkdF0+uxdzCKHmAB2y+2Mk9AqGr5mF
	YGQ==
X-Google-Smtp-Source: AGHT+IEYtxFcEUEnDqSTHAQVrblyfI2oNMubjRZ5e9W9yNRmL4/qhO+F7kELzTtOhO+SWy8SdhbFQmfwcOA=
X-Received: from plfz10.prod.google.com ([2002:a17:902:d54a:b0:223:551e:911c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:17cf:b0:215:89a0:416f
 with SMTP id d9443c01a7336-22368fc97c4mr58635635ad.30.1740762395319; Fri, 28
 Feb 2025 09:06:35 -0800 (PST)
Date: Fri, 28 Feb 2025 09:06:24 -0800
In-Reply-To: <20250215010609.1199982-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215010609.1199982-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174050797060.2702095.3801136360929410599.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix and a cleanup for async #PFs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 14 Feb 2025 17:06:07 -0800, Sean Christopherson wrote:
> Fix an issue with async #PF and protected guests (which really shouldn't be
> using PV asyng #PFs), and clean up naming related to SEND_ALWAYS.
> 
> Sean Christopherson (2):
>   KVM: x86: Don't inject PV async #PF if SEND_ALWAYS=0 and guest state
>     is protected
>   KVM: x86: Rename and invert async #PF's send_user_only flag to
>     send_always
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/2] KVM: x86: Don't inject PV async #PF if SEND_ALWAYS=0 and guest state is protected
      https://github.com/kvm-x86/linux/commit/b9595d1ddef8
[2/2] KVM: x86: Rename and invert async #PF's send_user_only flag to send_always
      https://github.com/kvm-x86/linux/commit/4fa0efb43a78

--
https://github.com/kvm-x86/linux/tree/next

