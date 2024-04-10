Return-Path: <kvm+bounces-14057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B36389E6EA
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 02:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55636283FCB
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCA110E3;
	Wed, 10 Apr 2024 00:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hibCLPiE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D2920E3
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709202; cv=none; b=DnrbWn2AZvjcYLPKBNxXGg9StZz5WTL42CicKNws3AryaEdrFim8IJH/Ov4SYOSDKbQmvuILn7n1CBJ57D9/Gm9RS6qxLm8GKrJCjmiibkZvhYDpj0JFmwayE1rARZR2yuoB3UIqWKbHgeMpg+QzGVUG/0GtwFA+snUeLg2yYcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709202; c=relaxed/simple;
	bh=o7l8F1F4TTP9/xnl4PcNkFbGFEt+32ts1j8Yed1fA7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L9nWZa/YFlDVJqWSFsTr2CDmyBgLGzWvJZDdN3jzREuJJcyGKiZZGE7q3riFpDbQec7vYWtfho+/w/PJR375cjQdLsjaOEjqysKfiLj32BnJ1g7r/2br/i1tACfmY82Ir/z1HD8jHbSRpZPMuSwLIhTSHIqAuc+mjEWj0/YD2Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hibCLPiE; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-615073c8dfbso119458907b3.1
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 17:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712709200; x=1713314000; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FwBgX6FnSr9JcMb2UGmWS06d203Zi6FsPJcb8lp1jHw=;
        b=hibCLPiEjyC7JHrJXkPsor87xGkI0ROZhQ6fVaET8t6urhVl5gwO8RDNyUTvdb/jhv
         lDEwnNZ9ufuLYXyvwV2Pv1qGAYu1niRDnVrAgnbqtRYMCM1yLFxWp18g0RwQSt72I8l0
         OeMu7rC9yaieI3QYR/Cx5hR/K+nKGb6MxopOVhx0iF19S5m9V8ic0N5XykY2gZx3GvyI
         Zw/OV6y2+AfY/l8tSQiEK/36g3etMrLo3w4x2WACcCWtcE57CQIvfdBa3UUWXTFe8qRi
         6nbjwhcX3jTRThn7nXalsja2y/KM1jgFeRkHOkwZvucnRfz72ZictRp3V57P9+JBcFHX
         zR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712709200; x=1713314000;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FwBgX6FnSr9JcMb2UGmWS06d203Zi6FsPJcb8lp1jHw=;
        b=PobFJpM61ZnE1WTVMLQiYxjGsSyXfWCWeKjQPybaF/CCrv5wBt2i/ALnWYKAnLUcGE
         5SVOO+UBAGKJX/xp3SJWTSnYVqRlx7PNV/rLhCZ20nbiov/uLuO2KSQNsuknR6W2bWWr
         JOIT1AdinmYwD6kwMsbuTu4XudmW3w2zXv9u5LlvI6YYC3Ezpj72hEgXD3v2gKq6DBW+
         H1JC9q83hpxqKK4rk0+JlS8ThfEhYBgGz/4obD9XTHwUWiZ3SxdQ+7W9PSwazkAwxiJ9
         q0ugYdBxrwa8b2QivcledKinUclR5LRHulzlLijc92ZEXDB4dqTaW8RtRSkj2KRxsAc6
         LCwQ==
X-Gm-Message-State: AOJu0YxDgpwV5gTkaJSNJBfe+ZVTK4Kr6uG/OiFnnAMoDjiYrB7U4o+q
	c0/hHwtt0c4fecN5e2buPjw/w9xh14imbyILo2YuMSYqYhAU35bBF6EKS0Lei/FH7IXNHIg032o
	JLA==
X-Google-Smtp-Source: AGHT+IEnmSg4OBP8CoAP/AZIShB8A9pgb9ncU7J3cSA59Azjxm1baWOT8jEHsLMCvl9mawl9WlFlYagBPJY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:df92:0:b0:615:d7e:ea8 with SMTP id
 i140-20020a0ddf92000000b006150d7e0ea8mr275885ywe.2.1712709199893; Tue, 09 Apr
 2024 17:33:19 -0700 (PDT)
Date: Tue, 9 Apr 2024 17:33:18 -0700
In-Reply-To: <7e0040f70c629d365e80d13b339a95e0affa6d61.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <7e0040f70c629d365e80d13b339a95e0affa6d61.camel@infradead.org>
Message-ID: <ZhXeTvNOByDRTlb4@google.com>
Subject: Re: [PATCH] KVM: x86/xen: Do not corrupt KVM clock in kvm_xen_shared_info_init()
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, 
	Jim Mattson <jmattson@google.com>, Simon Veith <sveith@amazon.de>, 
	Jack Allister <jalliste@amazon.co.uk>, paul <paul@xen.org>, 
	Joao Martins <joao.m.martins@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 07, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> The KVM clock is an interesting thing. It is defined as "nanoseconds
> since the guest was created", but in practice it runs at two *different*
> rates =E2=80=94 or three different rates, if you count implementation bug=
s.

LOL, nice.

> Definition C should simply be eliminated. Commit 451a707813ae ("KVM:
> x86/xen: improve accuracy of Xen timers") worked around it for the
> specific case of Xen timers, which are defined in terms of the KVM clock
> and suffered from a continually increasing error in timer expiry times.

IIUC, there should probably be a "But that's a problem for a different day"=
 line
after this.  I.e. describing 'C' is purely for context, and removing the
KVM_REQ_MASTERCLOCK_UPDATE request doesn't move the needle on eliminating t=
his
flaw, correct?

