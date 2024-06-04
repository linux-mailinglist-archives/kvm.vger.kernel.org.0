Return-Path: <kvm+bounces-18824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BE708FC002
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:39:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFD411C2233B
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28BA914F12F;
	Tue,  4 Jun 2024 23:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E1XX5aqx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3118114D71F
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544326; cv=none; b=sS9iClHMcUrGjQaUL4B2bX6e2aEksUt8N38PCgD+FezUiVEzicgnLeySDTmy+NhLcmpzp0B9QxlNzOpkBs+w5fQgsvLIL/b2yuK2a1EN/0o432xv8FeyTAKOKuu+3tirV0BRW1Ijbjd3fQSOT0pXnFiIHkVQ6foLZ92lkGyCJLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544326; c=relaxed/simple;
	bh=Ws40cFW+LRVUB+5xqOw/6wKhAbbpDDzA3wE9OKow6eA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=keKy5IYe2+6zpaoq4n0FFS5xblCmpSp6Iv2UjFLMetcETDu1xkF1isTCYzdai9AX5VY6he7EgTnMqu+EQDvTaT88IQWVnKDzje8TsVcvlqY7a+WtZT/6btFjYvWro5txaV3Eal63lGqivs6fi7y8ta2RyGWp/7KhB5KBMFWRsHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E1XX5aqx; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7025e68d5b3so1162605b3a.3
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544324; x=1718149124; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0tvN9gLPXAbXBjoJtPu3KLaCljKao/lf5vcd7jzOnSo=;
        b=E1XX5aqx+so4y6AuT4GP0q0hOQMtlQSRPoQ+Wj+njePlGWsE75Ce4q2E9TxUua32yM
         PB+RwQAlujPVy6TuVrfZoiRevz8XZIKezf4G31Cdp8u0gi5tM2M1vxOk0Ek3eYqrER9P
         DAn8WUNF3RYg6xYOheCAI56J3/kWZ9ZjgzDWhQOLN/fk8MZc42aL3/DNcrGWcVJn6Wav
         CuoLs6jyeyDvTUTdcEQkNzimV8WagLiNQBtMUqmY1MzOYl4AMm2J3NXwF0nJdPYINJ0W
         739b5iUjePkvClxR68JZL7rXrQH9yU5ixGPX4cn0w6aRXcAyx4irtiXbPHnduE3xrdag
         7RpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544324; x=1718149124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0tvN9gLPXAbXBjoJtPu3KLaCljKao/lf5vcd7jzOnSo=;
        b=NbJLL4+rzBF8vvoiwBTs+ZVPqsh2KeVhq41ZkKcunWrRmDq86z+iwhklOzEHuB5nt3
         5nu6YlppLO/04YOQA4THdwHbNph/WEYLfAhF1yfz2pZKMDdxweq5SuQEZrNsXAAAFkI/
         G6xJLSVOiWArhSlvv5HS0f1GuyPi5o4bc8cJt+9fcabTjqrI0KDXG/Q/tcZYm9TMBAZ0
         wqzvKIUTTtv1HWuCg5nXxO/ka5+15+7SVOU+kJR6R034NfWqakKvM+P+UEvL5RZbhN62
         Z15pUtc8vpzt3pgmmrydBYs9H4S9Np/+lEF1OSLCr/ns6WKP1KgI27aTtHYFl7+5552/
         yzlQ==
X-Gm-Message-State: AOJu0Yx7v9mPHyT4/d5VpNn3LIboiZfz4hRRVQY7Z//fjM587DwezCMg
	l5674FXMbp6re9Kqd2jFn2coI7GtozXYbB4KoyCWNAMRJi+yS4X5ULeMIpDjk6/5S/FLnAIGq3t
	lhg==
X-Google-Smtp-Source: AGHT+IFXdmDf7NUVR12uIMsECWr32pRzu1vBtWgyLX/uJiv8Sczeim0DfthbljqnpCqcq0qyPBeYVFK+2lY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1401:b0:6f0:b67e:dd0c with SMTP id
 d2e1a72fcca58-703e5acdcbemr2816b3a.5.1717544324185; Tue, 04 Jun 2024 16:38:44
 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:39 -0700
In-Reply-To: <20240517180341.974251-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517180341.974251-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754332415.2779355.10646219038983488074.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Force KVM_WERROR if the global WERROR is enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"

On Fri, 17 May 2024 11:03:41 -0700, Sean Christopherson wrote:
> Force KVM_WERROR if the global WERROR is enabled to avoid pestering the
> user about a Kconfig that will ultimately be ignored.  Force KVM_WERROR
> instead of making it mutually exclusive with WERROR to avoid generating a
> .config builds KVM with -Werror, but has KVM_WERROR=n.
> 
> 

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Force KVM_WERROR if the global WERROR is enabled
      https://github.com/kvm-x86/linux/commit/ab28db6b95ed

--
https://github.com/kvm-x86/linux/tree/next

