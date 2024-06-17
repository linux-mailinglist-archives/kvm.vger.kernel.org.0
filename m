Return-Path: <kvm+bounces-19820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C70490BC8D
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 23:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E6261C23702
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 21:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 090C41991AC;
	Mon, 17 Jun 2024 21:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4kjGXkdG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26AA198E7E
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 21:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658280; cv=none; b=fLtjRzD/mLZDRKPWM6k1tWJFQtXSgF7jFiKfa51iehXfnEw3tblUA55yoHSiPMhHxQbakQS7zPhnjzAGtnVi7tXwi8dpHfdBNsJza/Vw9C2/sV+pTuR7zFPEy14VwZYKGQWYjs+/l1FguVygGEZb5A1Ur0Z07c/UVw5j7v93U0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658280; c=relaxed/simple;
	bh=pWJnLgQ5CyW7zdyYTbIpYYJQXPj4mpodnqaGmD0G+z8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RrggJdQx5sUDYOmAuswBwEP9VuBHtCn1Sm8VSYp1D1rLh9BAWYkanKzN2wBegmtxNotPQx/EsxQkljr9CxFLb+V67ZG1Rq6E8KjvlZ+8ByrR9UAUHhjiRrGknFAzcb4tnIeSOvB/WqJ8u+3EDHXdfOnFO3V1loApfXwvCL3Oe0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4kjGXkdG; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dff1eb1c1fcso6377734276.0
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 14:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718658278; x=1719263078; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vqQQg4n2wGinehpZTbiRbcgjjNuzB3R0zyfs+mZXtRQ=;
        b=4kjGXkdGHmTG9f0D8HCELfMV3a5+xFf14Hq7RqM9j7Xma7ZA4EpGNglcDn5LZnNzon
         7Yoi0p/MKTrtKN84cqw87JsNm8pXKJXnUWOZ7KN9urjn7xMVrD7KkxJfi2hgkCHInlRr
         vXQAtpvu2RqhVWgdrcjuAyZs45uLm6SbG+zJEaWCXPdel1YYnmzVy9E/dt00bvhv4VM4
         QFt6SnCTczGJuKLuTjdErP8bQibvT09VGsO9cbwDY01qS9v2dUiGQE3Ek8+d/FW/Ee/S
         fgsvXAD608LkNhYCEMx9Nsl+wSrYcWFOrixQUyhvC9xNTtlminOelvWBHGpWBB4Kn0pP
         99hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718658278; x=1719263078;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vqQQg4n2wGinehpZTbiRbcgjjNuzB3R0zyfs+mZXtRQ=;
        b=mqLosOEZs7MiueO2e6HtFMfph6l59bImekdDW8bEABGZ++6vE/ScVOCtwZEzewjwSH
         NTcM50vmt0bT8nYs9l1BGo8R0hoS5t/E32nteqjySD4CrgsGSQoGU3JheFRTwQpRV+rI
         GMJKSXZXqtI0WeMz18JMDXF1lFfkCBOyuIRnChEmrbv3H/7wbbVvHGt0Tpoz5ZYv9FHU
         rWf3G89jeUDx+MYnlk8cthPWXGPieBIEBlffqdL4DSKlAJqVVo8/HAEqRJR9KsGV0rT+
         7tRl4XOhF9hg1iJHZn5050W2lTpI+ILHYMgO1wVU0m5ish51kp2SIK01Z9bTls9UA01C
         DJVQ==
X-Gm-Message-State: AOJu0YxFQsxTnMIVHIqwm28elIPZwzvYpaMen4kocwrX5ngxc8helu2I
	DZAiv1nSl8gfYrTEssWeScFmP3MwjtxnnWHlJiBW4HHhuITIOjhfecwsVkAF6r4osE5eSzsl/8S
	L5A==
X-Google-Smtp-Source: AGHT+IG7ZyviYZpzzZ4cpoc+Bjch9yUoULp2xMGjOCPRbyycuPImQP6j+8pMjyxrHbU9aZPoT8yi686MQHs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1142:b0:dfa:ff27:db9 with SMTP id
 3f1490d57ef6-e02227597bdmr167689276.5.1718658277746; Mon, 17 Jun 2024
 14:04:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 17 Jun 2024 14:04:29 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <20240617210432.1642542-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: SVM: SEV-ES save area fix+cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"

Fix a noinstr violation with allyesconfig builds due a missing __always_inline
on sev_es_host_save_area(), and tidy up related code.

Sean Christopherson (3):
  KVM: SVM: Force sev_es_host_save_area() to be inlined (for noinstr
    usage)
  KVM: SVM: Use sev_es_host_save_area() helper when initializing tsc_aux
  KVM: SVM: Use compound literal in lieu of __maybe_unused rdmsr() param

 arch/x86/kvm/svm/svm.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)


base-commit: e4e9e1067138e5620cf0500c3e5f6ebfb9d322c8
-- 
2.45.2.627.g7a2c4fd464-goog


