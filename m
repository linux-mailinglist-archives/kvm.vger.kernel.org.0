Return-Path: <kvm+bounces-58913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A5BBA5987
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 08:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C3CB1C0510F
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 06:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC272586C7;
	Sat, 27 Sep 2025 06:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SYB4W/yB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF25227EAA
	for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 06:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758953354; cv=none; b=NUdetwDnGvZiYqN6RUBkvy/BWbVdEXnrHruTCdssplRqoH6g/LwCKF8a+41FUZ8B94dZX4AG0jHjiM0US7gLXGGfzI+d5W0n/nPAjnU8hKIyt8oBN76Ce60zglcKFStZFOeuXwDhNHe/gvhbgexoEeecaAhHnXwFkGDpxm9iO7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758953354; c=relaxed/simple;
	bh=i5zg4+8PUYuhCtP9C0+puXOxNIsz6uy6KOhZFdGIY0E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OlZ0u3YxLULX6UF29RxhGGwT76GS/cadpgLM7Tn/iO35OTBZdqE9jWmhADU+ngMrWMfmIW37rZXr/XFoyFoUr7zoOmYPVpN0hnfTrrl9ydQJMxC8iBL4jQZv5NH5DO+smO6yQMLBkMfEA0ohJknUboaZkFmJAeypHxlxf39I58s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SYB4W/yB; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b55283ff3fcso2102128a12.3
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 23:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758953352; x=1759558152; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92jQdJuxQdR6avb7iv3Qbc3f/OOpWrDHJMr6ZqVAL8o=;
        b=SYB4W/yBiRnnxT2es5BXpTxrnVgDgLxCIyPvBrvkPJY5OdAoUU2KJ49GZW4XcSKcSN
         6pa7qP63bTv7DUdPLhovDFWR/qpP6NGdqONkDYJqLQYhCM9Fam+UoJy84KEaxDyEc2pc
         hDmSZmer9pzZoRLmuKN6dFoQboCuFMejvdVMA3OCIgkoS6vJupFPZXM42Io3XdbsIuDW
         IwsszueGNmCtR/hCcAwBlrdiSEnDkSpiJOgmawZRs/wBHCzL3GafZvzMjrp8pqMD9w9J
         iljdn/8nmBzeoAdXdMe42MtQawjVE1VU+/viBuRT8tLYdm44w5u+MbWUiQ1zmCr6pULd
         fheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758953352; x=1759558152;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=92jQdJuxQdR6avb7iv3Qbc3f/OOpWrDHJMr6ZqVAL8o=;
        b=iRaZc8uJan05W3LYCG3Q45qjfMJC+2vm95JV99cXwThq+Kp9fhX/NChCotjPU0dOZQ
         afRBePXZwSieZOSjmb1lLt+ew8kDIAjH7D6HINvJ07YQPq2tmlp6hWsNn6p4kl2wNFIJ
         6p3G0fYyqQq7eQByjrWc4Fy3WrCQ5watKNRWoIfRyp+dbt16z9DXTZltRDJ3KFdn3Qjm
         nLlxxHHBeUGy7kljzOYPlUA5CZYFc/qZ92rYjMmIqLXmdsdlKTqv5LvTmkVTPtdMgQ6X
         ktB0dqWg4kBdyt1goNeNgIqtuWJnogFTIZTfmkNe8SDs2Q+/QAhFpoTgikocb52g98gw
         Bnvw==
X-Gm-Message-State: AOJu0Yyjz7tqGl7H5CbaKAKiEVzPQRD8tXApa8vOBwdMklQ14UKFytpy
	RMHqWT17U2BzDV1FnqpOPwbrsjGp3pQum4PBi1NCUJQatgv7Di1pxVya+JlP6ez+SCsD4mFrA1F
	DUEEtmw==
X-Google-Smtp-Source: AGHT+IHU6zbrUaVmakUk3kyedknL296gdxZuhglgjKuQKfKwMYOtPpoHQeUQfd/oDKLJtqNSbMf18deX29s=
X-Received: from pjse3.prod.google.com ([2002:a17:90a:77c3:b0:32d:e4c6:7410])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d19:b0:262:22ff:f018
 with SMTP id adf61e73a8af0-2e7c593529cmr12001947637.26.1758953351821; Fri, 26
 Sep 2025 23:09:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 23:09:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250927060910.2933942-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86 pull requests 6.18
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Sorry this is coming in late, it's been a long week.

Similar to 6.17, a few anomolies in the form of external and cross-branch
dependencies, but thankfully only one conflict that I know of (details in
CET pull request).  Oh, and one "big" anomoly: there's a pull request for
guest-side x86/kvm changes (but it's small, hence the quotes).

I tried my best to document anything unusual in the individual pull requests,
so hopefully nothing is too surprising.

