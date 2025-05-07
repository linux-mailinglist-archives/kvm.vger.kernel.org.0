Return-Path: <kvm+bounces-45673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BD520AAD20B
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 02:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00B1E7AEC0A
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 00:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A43F9D9;
	Wed,  7 May 2025 00:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rg/k8MZ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13004B1E4B
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 00:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746576969; cv=none; b=kxXUvin2TwFmEP62S+Hu/+oEmWgtlkW2EWwNHW72dNOtwsOKh7s/kH35Mqg1Lqom2/a/ak7SykBNzJxlcD2oidGsXEV1F5R85GBqMuzLqDpF2LYE+bf8l/0tdZPJXJIsBY6OaHR0zxgna4O8fHneZS1C7wo4CktWGGs8Y03khA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746576969; c=relaxed/simple;
	bh=7be0/2LE++Ckek26lvbdY7EmcP9hl10SUMNHHpogdAY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qL9mmQKwPT3+UPYSN4KyXyFn40f/CvLvZzCI7YNtTSOrKUJWdhBtrXvTjtjMYJ1hlqvO6TMSRtubGjqDxIeJPoimJ3Ql76j5UhXglrZKILMjAJPIOlNefZghEP+KvsuR35RcVf7XIjrGO5W7RnnbPB6KGTin10OlACMcJ/03ZyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rg/k8MZ7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22e40e747a3so10202535ad.0
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 17:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746576967; x=1747181767; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vEfRZPC7A6O+MNC8gvc2UAGXPdHnkovUWHJGbcAaarU=;
        b=rg/k8MZ7CECjIQLhMHS9mSae5THKFADYEuLyeuTJLiZFhVP+TBt5zyUO+wJwvxYPLS
         1pRvfKbliUuDOaPcD3pOTcBIVavY89C4+vwJhLL39ZGpzeEqX8BbTwdJO+YlN1YIosrI
         xc3v0a5FQIVcTnLz/Ubyg1WA6x1HXJEd1346adSBZ9w6N60KFLGX46jzCJJsH/ok/ycj
         4S523iH8/eClT23qKoZlz2EZrdaTwMymQcxZ6K3xPWtPWm98KNnVWn8wDxouxmkpVyte
         h93JoUH7hXxYOkDlMCgoOb09WPn+rBm5RL+7ugTiFdjwBKc3EE7ih0t3x3STu72xC3bd
         ri1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746576967; x=1747181767;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vEfRZPC7A6O+MNC8gvc2UAGXPdHnkovUWHJGbcAaarU=;
        b=wNRh+SQs12RPia/DPf5/lDvkPmOTkHnyHGTzfsrDV9TyGvHmzRtRQxgswS7ZAzs4XX
         jzvkXkcH3ULmNhjAdwdR3S+eo2vuZzvP+f+cc0VY5byo/4TcjLTR+wL0/U3DhUS7Qul0
         DJmcxCG7tvMLKPtqc8WzmzX9jyEU80gdi9uASEpxS142wnOQrJtlF04b7k15PRQcHn8s
         ikTdAyJzmRsJbYVt5aHCmUiC/XkRBbLVGFvgv+ESN53rWMMrdSWlowuDlyIyYiY9Yuwd
         k6dkjky6zHw/QIT1w0SuwA+dVOzToyaUkVh23REcKMQqq48a23QAp8zZ4QklIcglflvx
         FdJw==
X-Gm-Message-State: AOJu0YzXtv9a5PubKpUezylaiSgXBkuwdJDqMeM57M7dJ+IfUVmpDVBa
	fe+0IeMHQg7/gP2/GhRTzRB7t9bOd3eNXwODg/bM1Kz1k9Kv5c+56BQsO9P9wOMuLhvG/p5B3tu
	unQ==
X-Google-Smtp-Source: AGHT+IF8JF04aIaURb+TMdlY2QffSZ0v5To8N2ID4w81qBfaHvIcmyhuSKw9WurVeHu2raGCu51Dk0mMk44=
X-Received: from plbjd9.prod.google.com ([2002:a17:903:2609:b0:224:efa:ef21])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54c:b0:224:13a4:d62e
 with SMTP id d9443c01a7336-22e5ece3e71mr17636175ad.35.1746576966995; Tue, 06
 May 2025 17:16:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  6 May 2025 17:16:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250507001604.1254877-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2025.05.07 - No Topic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No topic for tomorrow, but I'll be online.  The tentatively planned guest_memfd
conversation was taken care of in the guest_memfd call.

