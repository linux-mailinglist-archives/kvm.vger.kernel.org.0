Return-Path: <kvm+bounces-55051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E0AB2CFA6
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:14:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9029262693E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:14:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5FFF25BEF1;
	Tue, 19 Aug 2025 23:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RCBAW4m7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2705258EE6
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645185; cv=none; b=hfyCsQ3wzJtydwHMM7jAlH6PFLnYM6x2UdXUnDfL8asw6HER1RYa1mj2bFy/7EwjrgJkRirPAIZraY7fMnLMtVgzE+/yOvG1xlqxOpKVyrYnJYrL0MBUm0+/F4u4S8E38B2QlvowfxfLyuUYxkPrHQQMn0ZKBpn1Fdq5ByxGihs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645185; c=relaxed/simple;
	bh=HMMBzRvAJ4GHOmwM1mf9wYVOiVTmCrz5Tq7aHZz2SG8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LBy7BetB/ZY3DY2y8KATWkDhLa9QREVSFvoqWvmxySQadXcElI03TCU22aUTYMaEYqlCfSfI1aIjY+JwKu5sJCTDxzUdOR8z5WjslDfV5DHciQlk3J5+SuaHyAuZjDrF/qhX9xTHjXILCEzCpOI8bMZN1P10O0qaplyiyLSgFDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RCBAW4m7; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2eaecf8dso4478568b3a.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645183; x=1756249983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LyrkxQfJarShvnZh2Da63aRDAuN8+xMoETzr8D4yZas=;
        b=RCBAW4m7wwJ4c2k1bVjZNuO15J3cxsV8cikOzjrdw2zr6nznBxmEWGhoMuz5T5kyXB
         9Aliqw7APklyA+xK5rzniOifbPBeZ/FnRuPTLMdtSBpKIizN+uYdTKc88X80IpJo38Rp
         qbcH5moH+fa+XB0+/p7iurdsapgUMqIsD4FEwQ1Wm/obFdYbsEeIJTDwdf9bV7fLjDfq
         OZQHyUmlRHljys8v+Y8elespzxmRFB/x7WTs+9Uxi5o5bPa+7MzjEtRdl7G6b1rSEg8w
         zoMopy1J3+QhjEBtjNpxB0mP6ttWwiJkzHGhK9Zh9RGaP9MRAJEolblQjGdl3cLouzpg
         LK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645183; x=1756249983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LyrkxQfJarShvnZh2Da63aRDAuN8+xMoETzr8D4yZas=;
        b=VvMyuaun+wIsXnaAau9wrAPw9WBy8QNN7F/bTQdx+1fu/mUkuTw1BNvInFa4UK6HTq
         jYS7LYbk1bIJEh1MSkoJ5HjpGXcDqQ5DSzt42ZGN8E7OKPT+xPquZUyIrdvziHC5PbqN
         3wzoQxfGJGKoZjCI3ytBYUWOyeKuyOEKRYT3AFtgwcwkxhDcbxtbXdrxSSdofeLuqQ+/
         fDOWmkWrQI6+RIqie+i4jTAaTcmiKdgPDN05w4nraCGhhDNXuD7sGKr2VBzSJHDrYorG
         /4SQLLmkCiMKgS33zepjjtkWgbCMFoXn7ikz/3FZtPeUgPuhmiN1gUQzWHC4ab+S5b30
         ZSpg==
X-Forwarded-Encrypted: i=1; AJvYcCUITFmTJbPHBBLZ8K4QNpFaayStTm7ZRJC8axe9XzXyJd5ftov/A0H34CDEKtU5eV8Xk3Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+axeXNT3hT3VFcD7p8tvr72qxM1Mr+paBh4nZKBeuJq9IIStx
	1NQz90/ZPk654gF5mH2h660AMkiM0bW/yWJOwOAfV2uFM8LxRodHA2lDFlM4Eus6nCE+7Pce/d4
	oCx5d0Q==
X-Google-Smtp-Source: AGHT+IHKZuquoM4sjiq+Vo0RayVOOHdqQExGaAcsphTCeVT6657eJQJVxFce8dvR9aANjj6+E9WPgJs0OZw=
X-Received: from pfbki19.prod.google.com ([2002:a05:6a00:9493:b0:76b:8c3c:6179])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:888a:0:b0:76b:dd2e:5b89
 with SMTP id d2e1a72fcca58-76e8dc398fbmr1136199b3a.6.1755645183024; Tue, 19
 Aug 2025 16:13:03 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:11:49 -0700
In-Reply-To: <20250804064405.4802-1-thijs@raymakers.nl>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250804064405.4802-1-thijs@raymakers.nl>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175555273989.2809268.15028873973130376349.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: x86: use array_index_nospec with indices that
 come from guest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Thijs Raymakers <thijs@raymakers.nl>
Cc: stable <stable@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"

On Mon, 04 Aug 2025 08:44:05 +0200, Thijs Raymakers wrote:
> min and dest_id are guest-controlled indices. Using array_index_nospec()
> after the bounds checks clamps these values to mitigate speculative execution
> side-channels.

Finally applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86: use array_index_nospec with indices that come from guest
      https://github.com/kvm-x86/linux/commit/c87bd4dd43a6

--
https://github.com/kvm-x86/linux/tree/next

