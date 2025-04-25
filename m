Return-Path: <kvm+bounces-44375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3D2DA9D62F
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 01:23:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C2BB4E260C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 23:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A598E297A40;
	Fri, 25 Apr 2025 23:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OddkwAGi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812572973CA
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 23:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745623419; cv=none; b=PFuVjkTzE6CTyUXFm23lkR9frvlkKVZSO2ifElUzWvbzXskX3HHWVKJfeqYkRDo5BDzcJpdulNpFIheHuRuE+DaiWW8RXhbtI4DFjQS83xxjQliMMzQ7RpQDZj7rasI6YJNaX4JGKy8C0MxKXBuLi9KnDizF1TCSqNaeZ24QHIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745623419; c=relaxed/simple;
	bh=GB7sd8MGwtzcKnzQDfwBPT+X+eVPAv+t8OzjGOIvpVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NEjt7ddSE3Ldx/gsrI1lDbF781z4DizWfyA+UpKo3Kp/EyGRU5IaJLutvJWt4s2L0rPIeumXUJy1Vwlv6zWPvT733oJaIXArm0rUkZbTOY87LyIM9LoUnV8hTv7D6gMQyt3ZT8BsPPFrTmxiFheAh9ORrywLDCrlFUn+NpcsbmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OddkwAGi; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b0b2de67d6aso2956828a12.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 16:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745623418; x=1746228218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X0Z5jrWv1CabzXp7vnrRsFuaqojUSR2Bu2m+RsiTvL8=;
        b=OddkwAGi+pfZdtGijzLUEXtkV6Icht3rZCNVVLCS5MEk6IYXeJqg1oaB9Wzju3xgfT
         l+ceWXZpMfSSJEh9vZt8sV2t8GrX4TJLSlMpnz26ydhMZ2DyaDqmEeYiuhqd1Heifg6b
         ER3N7I6CHRdp/PXhWxUbTneEQ34KEw6CfaMD6pbPoK9BTE9Y/Lb+ePYpRbLXARAcq10n
         8MkHuv3QkDmhtlrbrHrs9iGS779y/lGDOV9rGKbweyHa/9wubutXYsP9W1W9c7L+5FdD
         XWL8aCM3Yr7jf6kK+ZNLJT1zj+JO+5fzh2FdkYkGOl/oj79vSzIRNVvnAqiuQ+30MaYj
         VBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745623418; x=1746228218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X0Z5jrWv1CabzXp7vnrRsFuaqojUSR2Bu2m+RsiTvL8=;
        b=UocjsXg5LUvuKpm/v6njEqcCUa7gVnwwWhis4Af6PapRTgaymJSPh35HDyD0bP/XTP
         6BWNZfPCfReqXzE9+2wR+phxEuI8a52dnZFcv2kR+gbnUr9lt+neYICVXNuZofQDV2ia
         tSMn35UYO8muxQFoWtWZ4tthdEaHaVq7v+7UTQXDc9YQJvcRhLdsi9dzAyKQkDsM88if
         VDrZOBr3bibxK2vBNpR4ZdLYR1k4RmVkadtEFg7GHWcHnouJp+5GWwd2tIjUkf+ymWBl
         AWW0e4Stm60xK7PAfM9M7y6Tl0RagmjfP9TP5NUALGvvENAWLZJaiy3txiJwFWp9lP+1
         ikdQ==
X-Gm-Message-State: AOJu0YyjvmJyt4mQRfvedFUkDHfrdFmRJeKCUH/WFaKhAIgituHRvAFV
	BeV9dr8lhdUWzgTJwyIMLGo3GqpYMUB4FS/tDiamWSVbjpEGsEZjBYQUHb3ljTzwROY9YMS5acI
	K5w==
X-Google-Smtp-Source: AGHT+IHVpZWCS/xkKKY2zkJW9wM8MORIqBRP7NgFuMtVxTOmo2kY/V2e2wSLMu/OedKX56XMy5SVQWsLAm0=
X-Received: from pfbjw10.prod.google.com ([2002:a05:6a00:928a:b0:732:2279:bc82])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:78a3:b0:1f5:902e:1e8c
 with SMTP id adf61e73a8af0-2045b9f9791mr5498419637.42.1745623417711; Fri, 25
 Apr 2025 16:23:37 -0700 (PDT)
Date: Fri, 25 Apr 2025 16:23:16 -0700
In-Reply-To: <20250306075425.66693-1-flyingpeng@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250306075425.66693-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174562140120.1000934.7661370031788311289.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: avoid frequency indirect calls
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, flyingpenghao@gmail.com
Cc: kvm@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 06 Mar 2025 15:54:25 +0800, flyingpenghao@gmail.com wrote:
> When retpoline is enabled, indirect function calls introduce additional
> performance overhead. Avoid frequent indirect calls to VMGEXIT when SEV
> is enabled.

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: avoid frequency indirect calls
      https://github.com/kvm-x86/linux/commit/bb5081f4abf2

--
https://github.com/kvm-x86/linux/tree/next

