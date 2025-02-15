Return-Path: <kvm+bounces-38233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F51A36AA2
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BB247A1C4E
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C9F82D98;
	Sat, 15 Feb 2025 01:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0VCz6vGf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD2D74E09
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581791; cv=none; b=lyttXXj5xFQe4hd/X1F84J8vaHtEwVAB5mifGylnWMSTw9i4uAOiv1oId1w0FULlYy1DSmf2KscE7gc/fvXV4LC3jQNQn64kLdZyCHjUGj/DtZerER/yL78jT8tHhY7FETc0oaPxLqwjTOcWFF0L2GLME8IUNywt1kN9a0Iqzlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581791; c=relaxed/simple;
	bh=5SqsxFyjoWcxFNf6Hg/LiMYgjTxlgCTtPvOJjWXlJU4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=txc0SzItrYmwKHoOK/gvAESw+9nk3UcqrqbqYWUDhVfqFPBwkK1Ej7BcOjpfB6H2FDXFh7JSIC+cHt63J2Feqkj1nHm7tSJovtePw0RMCah7YcT2wNif/2rzX1VbVpez7fl7EGEM6V4DkTgJ71iDjKddh8PBVxAfmgCzYBU9dYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0VCz6vGf; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc0bc05b36so8383717a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739581789; x=1740186589; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ft9NGbA4u44DYHGMH78+t9Ma1QvHtYydU6iA2plJOxw=;
        b=0VCz6vGfF5kQjUNsBQcEq6tvV1exF5P2GnfZ0E5cQRUcWUtdl7so7voW8KacIsc6Vv
         9QJQPOJQlno+dPKJx7x3XI800DWOsucr2PCtusVZH+QwWbEKyXUnH+q/NqQth7I5m1Lu
         NuPxD87Ma8qkQuBa7SscjqGztHwmT7MQRP9gxqBbntZZObMmpoKop32+ywgm5F6RXO5D
         95Q9ZLtuzBe0yhJOceuf4a4dtLJsxY5tYExcqsT59iYmJICdnBaTUy+fA2MJKaK0/HIZ
         Yt69auBAo+tG6x3CTGcY4cVYhxDp8qpM+QxXXk9NqJ4I2M05dJJp0zQUPpE++j98ZSNi
         dDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739581789; x=1740186589;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ft9NGbA4u44DYHGMH78+t9Ma1QvHtYydU6iA2plJOxw=;
        b=SKN+S55EDRpTA87B/XS1ND+L1AyXzQ3lSiW72+cEzJWuVZSpK62j4YGxcUXNJTo9qf
         tojPxvRYqCTQQWQJIHtSKKzHDn7uN2ZclnvY1ba0641LWDTCuX0adUzgVxa/DNEAMfuE
         JJFxQAWPFOV9B1OCyMYEhpjYm0KDLqsO+lE9tnVH/QLA+kXytvVZeaLpOOGJxT7t/+7S
         uIUyzvCRwheQ4iQQ717kwoHP/C/O2EmqLehenAziw6wBVELzZfHIdQYW/LPKpC58cG0i
         1ItMd+U+0/G7H9rOEt02cGtT5j7RDvtYp+Pm/lUl0IrMRNcPYiUvWiS8GLUxXvzcnHzb
         A7Pw==
X-Gm-Message-State: AOJu0YxcEXbx0mKhcAbP47z/y3wJvonf90YkA6VVJxxQq20JAn2z29mw
	jiVwNuCRpYFd1Cqrc2sa5ZJYg8IeYslUUorV+5MYP5is8MBbwO/YvUGPzu7ItSkNzpEEtKXttn/
	QEA==
X-Google-Smtp-Source: AGHT+IGPReR8yPKp90g7iQv7Dwmt4gM4UA2F5Uz0fqd4eIZOb7XvKt0R/RDgOGVTmzaTTFl3g4BgUfRVtwE=
X-Received: from pjl14.prod.google.com ([2002:a17:90b:2f8e:b0:2fb:fa85:1678])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2789:b0:2ee:e945:5355
 with SMTP id 98e67ed59e1d1-2fc40f21c9bmr1729152a91.19.1739581788933; Fri, 14
 Feb 2025 17:09:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:09:44 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215010946.1201353-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: SVM: Fix an STI shadow on VMRUN bug
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Doug Covelli <doug.covelli@broadcom.com>
Content-Type: text/plain; charset="UTF-8"

Fix an amusing bug where KVM puts VMRUN in an STI shadow, which AMD CPUs
bleed into guest state if a #VMEXIT occurs before completing the VMRUN,
e.g. if vectoring an injected exception triggers an exit.

Sean Christopherson (2):
  KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN out of the STI
    shadow
  KVM: selftests: Assert that STI blocking isn't set after event
    injection

 arch/x86/kvm/svm/svm.c                             | 14 ++++++++++++++
 arch/x86/kvm/svm/vmenter.S                         | 10 +---------
 .../selftests/kvm/x86/nested_exceptions_test.c     |  2 ++
 3 files changed, 17 insertions(+), 9 deletions(-)


base-commit: f0f0cbf3b767935abcfdb36649ab626fb2ab5ae7
-- 
2.48.1.601.g30ceb7b040-goog


