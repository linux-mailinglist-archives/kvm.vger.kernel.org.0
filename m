Return-Path: <kvm+bounces-30146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6EE29B73EE
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 05:53:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86FB5286172
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 04:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC62013C8F4;
	Thu, 31 Oct 2024 04:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="opstZuTz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E3212BF32
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 04:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730350418; cv=none; b=B4DlaQTaWU0REbePDJCG3kg8otjcLUmbpBm+ihcBDUHUez101J7AjMTQl8Pqx8zKoGvmaRmwvTf35mUMM7EmPfWdcGQu3utZzupGglyKPlHOCZ9PwWpcgpkfgCyGiyZVMN1oVGhKGUplG32FlGyvERIh7dHeVQm/wAiAnsuffF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730350418; c=relaxed/simple;
	bh=z1iWKrL0iGzDxEXyphps5/T+K15nDZVwxoo6gFUzZdI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=CpHA6fmR4rDn2Q6TrpAzDz8gWTQSeMZ/up9JTRnqPPKJqvahEeTZwNsKBlYqwiOSok0+B+b1OyFFlcf8r0S38o03JNAYRK1vcNozX0zIhEaLqr7qwZ+ptrCejJDgooUdYRkV78w75oqrSmb8qiVYFMq794Mr8u6rPWqtzz3CAQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=opstZuTz; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e2954ada861so875049276.3
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 21:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730350416; x=1730955216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wiY79yFUfgtheDtsdvwfegGiXXODeuQyPTQtmiFfHDk=;
        b=opstZuTzh5BWegHNlf25S0DM8TpzwesrjOwdubP3CxeWlz5A7fN/XaBNrxUzqihn+G
         uXPW96yR/g20Yt12FjgQ4dPqeurSwnlsnyHRpLAiZWuprTLaoq0R7xtAw2qXe2v2c4Ov
         fkX1v1WzuWxQ1MVIbOuLudvtvdHEj+eGPSQPcm6MD/v6DX2KwAhAtICrkAt/SqQ2DCbX
         z7f0W7OQzgSiVzmAiTdvLMaawGbXon2syStsWilAVUkYRczWFO2wCWD+zubGo5k6mYAK
         JRIWhg/60GsUqSj9TSpG/i4YkiqHurFbfdviS1oKiokfptExq6zmNlBtggRA0QfkpHZB
         vUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730350416; x=1730955216;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wiY79yFUfgtheDtsdvwfegGiXXODeuQyPTQtmiFfHDk=;
        b=poOSycbd8rl04FygMRXgpT2Zjp/qHoEjE1rwhbK6P6SqCsiFiu4xZTdUpbDsMAyA7J
         AqObqpDdGasdfLUsDENKLIaf+rz1RPeOszJZk77uNlPrbXkxu/vI6iSdz8pAsRFT6eqR
         8qayzWihxjaLBcHY2IAUcZoWf+fZLJCpQboesz1bDmtgRsexVLW288nnCJUJOAdmZMXv
         5TopdSWilJdWp0Hoxqxpift7w908Ov16UW20kUIeqzxYeg4TeRIzBus6d3qrw82FcTjM
         RD3RnCvZvqOzP5oxyq4bN+JSUxzI7nqf5fVaxFVwcJ9+60XOskyUakRMWPIjatUNvtAv
         Cgig==
X-Gm-Message-State: AOJu0YxKiT5w0EGVVwA9v6QI+KQqokWkBdmyh3UcKkr7laA3PQqxify4
	l9pJ5xNzJ/abFP44S8ZppAsn2KevvaxRj3NeX9ZfFJmqQtqNZvTqWMr8gHpTAegGj0xu7A8df8U
	Vtw==
X-Google-Smtp-Source: AGHT+IHxjuV8TEM897E1NxoVuaOigtFAlzfKpVOG+ymJPAy9gjdsiAwT5dYX/hzyI2oKlKf9cypUwWpVNzQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:8186:0:b0:e0e:4841:3a7e with SMTP id
 3f1490d57ef6-e3087bd6059mr59225276.7.1730350416233; Wed, 30 Oct 2024 21:53:36
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Oct 2024 21:53:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241031045333.1209195-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Don't force -march=x86-64-v2 if it's unsupported
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Force -march=x86-64-v2 to avoid SSE/AVX instructions if and only if the
uarch definition is supported by the compiler, e.g. gcc 7.5 only supports
x86-64.

Fixes: 9a400068a158 ("KVM: selftests: x86: Avoid using SSE/AVX instructions")
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

My big ol' AVX enabling series ain't looking so bad now ;-)

 tools/testing/selftests/kvm/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 156fbfae940f..5fa282643cff 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -249,8 +249,10 @@ ifeq ($(ARCH),s390)
 	CFLAGS += -march=z10
 endif
 ifeq ($(ARCH),x86)
+ifeq ($(shell echo "void foo(void) { }" | $(CC) -march=x86-64-v2 -x c - -c -o /dev/null 2>/dev/null; echo "$$?"),0)
 	CFLAGS += -march=x86-64-v2
 endif
+endif
 ifeq ($(ARCH),arm64)
 tools_dir := $(top_srcdir)/tools
 arm64_tools_dir := $(tools_dir)/arch/arm64/tools/

base-commit: 81983758430957d9a5cb3333fe324fd70cf63e7e
-- 
2.47.0.163.g1226f6d8fa-goog


