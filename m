Return-Path: <kvm+bounces-8493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B211484FF69
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:08:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52FFE1F23087
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13322E647;
	Fri,  9 Feb 2024 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wJ8w88xb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905872E646
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707516475; cv=none; b=HmHa2mmaH5U7aYONA8+BOKJkLvszpmucgHsrM9GSdYpo6XPVQxnivi7LV2FgkmE9RCvsjJBsxgOiXTAHo1CW2zjs7MNgL5Q8mJEvhpzY6Emk9a1c97UPyUTM7wbtxcrpLyYIWPpCqW/NTZtv9leMwOqHAQpPKjRs8l45PIDlzTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707516475; c=relaxed/simple;
	bh=8XTkEQ6LYwg5FS5OHdChXniWfwTkJDHlQuODzLRJI10=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jDmbmqasOOL0FE/G9FlXuYwjfS6mr9NVb6hnWBwC96lkypJhwN2b8q0g4+Qu2CeQZTixIm/RdzOI0lzb3P5It217ZYWWqdthryRQ9YPsNIlsGujqZEaiRWN/YjuOONYgqhvwYOMqG0vHro3wcR0GJtNklkIrnmAdvtZLIyB7/NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wJ8w88xb; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1d9765ce40fso16703525ad.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707516474; x=1708121274; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XgDgnWq7Lrk26+EQn5hdWDLpi21lwuFWEvrXKhI43Hc=;
        b=wJ8w88xbGhAtr7vGZJqu9gAFcNp7X+fk/+L6Doyx5AU620NT3lzrG3aETdT9GvxYLG
         05NefKGxb1bLS0H40NQvkLjZBvDXy4d+LvpFxfPh+QOea2ileP99nykEnk7XkV9yy6t2
         US5SlxqHa14yMnpgkg0IPif1kUXpKj6Ufzinu6oZ7KTQrNkOQgoMWdwIFZfWJSZdAp8w
         yLm90SWo/sq3+ES5nQK6o1COqxggIRkfz1noENi9+4O6Bhe7vzwr7MYtoYJGUeUUnmPt
         X0W9AAC0ZJXASj+L5rHeUEEQYos8wBDaO+i/P2djkoeDYpKWv2FAmvHXhfep5rC+p3Hr
         VnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707516474; x=1708121274;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XgDgnWq7Lrk26+EQn5hdWDLpi21lwuFWEvrXKhI43Hc=;
        b=tYPoIvPPL5b/29hitPpuAEFASTO/HaXGi1dZnL3vAJuo2efFlJfigp2WvQQUOgkhvy
         7p3KsNmr+r2soBoNT46gy6MuECgEFzMvBBtsUhcGByyrxLncN0JkClOLJfpf3tSqa+Q0
         TBbk7PGu+UfK8Qkf22DYV3FEUVSUSpvAb81ixfpCQdWneox3hmR7SWv68wnWbv+a9NDC
         PTUoA+5Dfg+aE4/Cp/8T35GfvAfSdNwN+J6OkA+Bu5tu3spFuiejAmlnrJw3OPcx/EIg
         KcwE7nXEe+dN2M5jqHXCsq3c85P70QXhTi4WwtjOcGMTBnMRMn/Bm9AQ7CYRa4Pq3QAw
         ztDA==
X-Gm-Message-State: AOJu0YyX/YLasp8t2usKXGh5iMng6hKihmHGP/lsOg4lEIareaYiN9TR
	j8I0T52JJu8ucdyt+NV2bDLAKj/O5sWVLp7Myo0IuI6p/UYd2J702YtYR9TKUQUO3x7JrDB36gd
	cVw==
X-Google-Smtp-Source: AGHT+IEliXel1SnNoxT0eG+1eKElg0b7qF23gUhPgKufZbY+7KaHxRUia0V73Nhmm8xP/iAFuQKH+kqeun4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e494:b0:1d9:6e09:dd3c with SMTP id
 i20-20020a170902e49400b001d96e09dd3cmr1378ple.13.1707516473822; Fri, 09 Feb
 2024 14:07:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:07:50 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209220752.388160-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: Cleanup kvm_get_dr() usage
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

Make kvm_get_dr() use an actual return instead of a void return with an
output, which led to a _lot_ of ugly code, and then open code all direct
reads to DR6 and DR7, as KVM has a goofy mix of some flows open coding
reads and some flows bouncing through kvm_get_dr().

Sean Christopherson (2):
  KVM: x86: Make kvm_get_dr() return a value, not use an out parameter
  KVM: x86: Open code all direct reads to guest DR6 and DR7

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/emulate.c          | 17 ++++-------------
 arch/x86/kvm/kvm_emulate.h      |  2 +-
 arch/x86/kvm/smm.c              | 15 ++++-----------
 arch/x86/kvm/svm/svm.c          |  7 ++-----
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  5 +----
 arch/x86/kvm/x86.c              | 20 +++++++-------------
 8 files changed, 21 insertions(+), 49 deletions(-)


base-commit: 873eef46b33c86be414d60bd00390e64fc0f006f
-- 
2.43.0.687.g38aa6559b0-goog


