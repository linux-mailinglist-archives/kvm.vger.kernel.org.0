Return-Path: <kvm+bounces-30628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDAF9BC529
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:01:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9809DB2214A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481E81DCB20;
	Tue,  5 Nov 2024 05:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zlWZK+9Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070641B6D04
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786253; cv=none; b=a8PJodknm5B0NmpWngPasKEzQZ90daR+JsTZOJ0G/ZFxBJDfo1of8ClOxmTEFJdUsEdrbz3O1fizv2qEsf6chiOjyLDyS7N2kyl+UAuzgZsTY5sZqZNPFPvlEKmd3v2+CovcyW+7dbom6isLo0m60n53p25t+OvJtTLOb5GbKtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786253; c=relaxed/simple;
	bh=i/u61Y6hRlUZbvtVL432X3tNFdkVbhJ+lBnGpyX96oc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P5T48xGwD56tgcEHm/r1SiI7kW/EHQHEHpnYR5krsC+/L8WuGb4zNjTedg0JInJKETHTaZh0RP+qbY6nuD+oAASKgbDNIBO/Xw115VzD1d4tHn6Q41M8v3c4jqWglKZZ7GFCrXZLeYB9zf6IPOMEBjNlkCaM9fss/9bo2b7uo3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zlWZK+9Y; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e28fc8902e6so9515124276.0
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 21:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730786251; x=1731391051; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VQ3EwtZTnpXCooFm9nqJCTiI+ZBKbnHLrZbVmy/wA4A=;
        b=zlWZK+9Yh9wLHgekWQwOLRNH4twIdZtfjjCZXur0gMbOUiJFl+B1rqS4pyAHt/rRTC
         pR4iYiKcs94VWczcuQgeyG0tTXeCgsd80RBR/wO7LDWfn2jQGENZfbnJ4qqUqYeKTWpN
         Cq//U8TGSgqtZHqY6zhrqYue9hYZSTGqiOCW3/Y85j7Ro++XBTGD3qoBRlS+YfPLhn/9
         iZAxk9FVSDqlrb1xdlwXBve1OKVeIp5493pad8icGbmNN9/E1TwzwUfs3IT87YsbBFBF
         RV/SRfULAYTSXEZs9vgj6gru0ckUWTzGn2wNSoalbUs1CFSFgomx3zWorPwLRmLySOWs
         uVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730786251; x=1731391051;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VQ3EwtZTnpXCooFm9nqJCTiI+ZBKbnHLrZbVmy/wA4A=;
        b=cU8D9klIbUXrSxSMXW2EIXLX5BKdkDSV9Jvd09A+NckkSbRXGDk0IBcFlYu9rEL7Fq
         t7+qaShf2JRk0whob/6800oStcXWIWlOvCb3Uc67MkE1h4pKcj5kNcOn1Sw92kZFYFr0
         wdMHk+1jP9IVMAWHZSYQCj125TH0PnzUBJqJUHOnLLLsRaFmmQJZ3rhJ45gnbh7CUDyY
         OZG6+ZpyfB+QOt6i0sMbNy53vbIT8A1URuuEEvN632rw5SsYD26XR6xDfFwx9Z/9xKWD
         60ApWEBBpvnUP24nFu0FnTUMWuuUWka34fi68x1C+0CmbgDhiQP0jn9HDn3vY6b3YuIX
         t1VQ==
X-Gm-Message-State: AOJu0YyKgYjxFsTY7oBtOh8coqYnCcS8z9NmOp6w2BT/fi8m1TwZYuF6
	VqjePuf4hZKZijzE11EpBQSHOGTcItc0tTfFadE5Tyo0DOeuzqtRM2dY0XjJuiRUT5jZCLOSY83
	kww==
X-Google-Smtp-Source: AGHT+IHd8VtQiU4QOG6WrVGuXgcKCyiP5d+8jxZCVHUQMIIkM1QICkMGUa8ktQd19ZCp8JdYqGS4LHY1Sho=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ba0d:0:b0:e28:fb8b:9155 with SMTP id
 3f1490d57ef6-e3087bfc93amr66018276.9.1730786251034; Mon, 04 Nov 2024 21:57:31
 -0800 (PST)
Date: Mon,  4 Nov 2024 21:56:02 -0800
In-Reply-To: <20241031045333.1209195-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241031045333.1209195-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <173078311649.2041825.11508702248531487348.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Don't force -march=x86-64-v2 if it's unsupported
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 30 Oct 2024 21:53:33 -0700, Sean Christopherson wrote:
> Force -march=x86-64-v2 to avoid SSE/AVX instructions if and only if the
> uarch definition is supported by the compiler, e.g. gcc 7.5 only supports
> x86-64.

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: selftests: Don't force -march=x86-64-v2 if it's unsupported
      https://github.com/kvm-x86/linux/commit/979956bc6811

--
https://github.com/kvm-x86/linux/tree/next

