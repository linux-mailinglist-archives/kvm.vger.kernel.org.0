Return-Path: <kvm+bounces-23134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73D21946463
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97C581C20DA5
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08497A15B;
	Fri,  2 Aug 2024 20:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rC8AP7hD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D0546B91
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722630586; cv=none; b=fBZRf4KhtIYw6hRd0+199ZR1LkumtWRDoycKfcUfuS0S2AEklPggTKA+g40l6xCbrLVWV7v/tgk0W3+HZgMyuiDq56voukzqzdJj0jgXX+jDXC2g4/QcD3GKqkuxWayHgmHcAwDRgy0ITtutZRM/tLjyb763wKstoWtE5LC8xzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722630586; c=relaxed/simple;
	bh=l2pw4PqSYTqENlQeojQEIlKcrxUVCty1cPi4OYAbveA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dkQFxjX3RG8gDUymaP6yLhTRfq6Cv6Hyzb8lN5IDxzWsKJ4nV/NQkDkCQ+wRNWXpwBOg+1BtqFSKX2ojW4rgbKKMKPi1ORboNlwdo9EfbK7bno0QaGQU66pbkGts9T4dRmsFl6MqcNTDr3TcTrG/GhVTPrNL1EEBAMuIkPNKUOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rC8AP7hD; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6886cd07673so48105957b3.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722630584; x=1723235384; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OpWX4VZCbnXKP6XhT+I6JbMrTYPhaOiN05VsWUmHsfs=;
        b=rC8AP7hD+o2iSJ0uU8ZgNHScyu0RVA9Z2FwHRlh8bSiGePRgJfRDf/+xVXy6LFEetx
         jNn2TtIw+Cmwz2xQKeJQGxMnlA95O7tuCdNhKWTfTdUdsXtu14hmMWwdjDpAk61qPdW0
         jKVzz7bxkwMfzehgsUKj0ronf7qfBs/pz26F+30cjXYj/u+9CCMTfLWuBqYu16c4G99D
         FRxUBzLNlG831h3cJvL6fH2KZpaX43mPrMSaAwGH9OAVeXlStRJp/3q7P2aSuj7Zjrk0
         FpPr61J8f8hZB5pf/0UAlf8aP5lKK1ROqKphk9HSugxyY0G6Ms+2M4klnKBdgwOcNqnW
         cH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722630584; x=1723235384;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OpWX4VZCbnXKP6XhT+I6JbMrTYPhaOiN05VsWUmHsfs=;
        b=dC/xSt85unQAw9IBNUAvDDVBmURAWaUjCbJHtspMXJDEGp/Cxn6Suo+XUrKJFlOv2Y
         axn2FXc2l1uOctD3eaUUmwonXsAuz8KQgUiq4BJXjAzq517lv8caOng2dcM2/L2GkYvp
         UEDcYVFs1gqlsTLHluwJKe0geCf3WBeU/wqRNKT1wS7ME/OEQeF/cPgEWaJcsum9TcpB
         9wBlR1S5sVckHYK2BLNBOxYASKmu9ouMjfpD4m36T99rCmEP3AHpVovsP5zrXbCKfcZR
         wxcBi+D6NFo+wugjQXQQW5a27e6MDJq0KLsJMWtUL+SpJFPvB+Mb4KFsjMboMFKH9hsd
         GQDA==
X-Gm-Message-State: AOJu0Ywbt8y/nD88KkfmUE5j/4ZONMmzMo1yBIpT30tg36GrlmGr2fMh
	p071cJrFKPTUUFDOacsDlwlDIkjlMNlCmaH28UOj3kfgybpK4SDB71D+ZAgnSCsDpAdA4SIZWX4
	6Zg==
X-Google-Smtp-Source: AGHT+IGgFlKdqMHR7BL18rAEWzUIwmbuzm/DOyuEivSn1SzJj5+EN1uFdD7r0ZBjP/F0caZ+UNRhm2lPg9o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b84:b0:e0b:bafe:a7ff with SMTP id
 3f1490d57ef6-e0bde264493mr8422276.6.1722630583760; Fri, 02 Aug 2024 13:29:43
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:29:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802202941.344889-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: Disallow changing x2APIC ID via userspace
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Luczaj <mhal@rbox.co>, Haoyu Wu <haoyuwu254@gmail.com>, 
	syzbot+545f1326f405db4e1c3e@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Silently ignore userspace attempts to change the x2APIC ID via
KVM_SET_LAPIC.

I've been hunting for this series since January[*], and *finally* stumbled
across it while tidying up my (too) many git trees.

[*] https://lore.kernel.org/all/ZbPkHvuJv0EdJhVN@google.com

Michal Luczaj (1):
  KVM: selftests: Add a testcase to verify x2APIC is fully readonly

Sean Christopherson (1):
  KVM: x86: Make x2APIC ID 100% readonly

 arch/x86/kvm/lapic.c                          | 18 +++++++++---
 .../selftests/kvm/x86_64/xapic_state_test.c   | 28 +++++++++++++++++++
 2 files changed, 42 insertions(+), 4 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog


