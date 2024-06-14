Return-Path: <kvm+bounces-19716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B9590935F
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 22:29:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A369E287EC8
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711201487F4;
	Fri, 14 Jun 2024 20:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="ePScOFnt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E003C1822CA
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 20:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718396947; cv=none; b=mIvp79Q6sjd5UOVMlnnJoFSys0SJjJsEUOMIUt3NLJfl0SZoCSISVAwUZCCW4ca3Bg7P30mo52PBgWcMJM8+Yv/Oy5/wetbL+yF5xZz/7Iq3shepsUcsxFuFA9F2R2rmxVdwwU3wbt9Be5ojwE3eBFOjNf7hnGff4afwLRx2OC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718396947; c=relaxed/simple;
	bh=KIBEghULSZwV2LNMt8Zbz36I3eJCDpO9Yl12yrXumV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fi3tKpDDv2PJB/LZLR4tkkF9Z2H/W5dK+LBGcMiafZp2fyEYpI6ZNRalZmqabacoWMl6++WHvD/B6n8V6aW66HKEwkDYQvhiwKPjGnRDZKEPJ2Vh2656DzvNIwaUl6HP9xWfYPIxGBWK6j/WK0YbtI9YAKVEz8E4dJSQ9nTB0bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=ePScOFnt; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a6efae34c83so341187666b.0
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 13:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718396944; x=1719001744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zCsRmWbd4EwxlQsd0rAbDyCepG9PZwu03LPjZCiCo8=;
        b=ePScOFntQX6wuS18zHkdxwhqEAcTjh8XQaa6Jq3IlxAoDW60yhd/YFrEXeSCC14Lt8
         FSJzwOaHikXjlXUg2iAlUoyOs/c7eHpxI3M/ux1f6W5Ulx8VboCbEGVHBuaEsChsSJU6
         Ga0j27g84ERsY6/N+PawY+I7Xb27w6OqM9b0QUjRGSSsxFwyfG8RD7rPQYjFU16OVU0m
         zcOwFyrbBfcyBDZ7pBfcyz+dcAomO2ZisIVYkdfwnLs7k6WG1IUxwogqbGKcaYInIP5I
         J+PlwR4UlxF7xxsCQ9TwUQ/RZbjYib/a0Ui/CPSXLvo9tLDieZ+uNLAERvPJY5kIUg64
         QwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718396944; x=1719001744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zCsRmWbd4EwxlQsd0rAbDyCepG9PZwu03LPjZCiCo8=;
        b=Lp1fwKEqHp2t3NCHndvT72P+PpwxQ9eyoqIfsp5yHKXWsvhp8jr90weWPb7LqGfgMz
         zJLwOd3bodQLkG7Mtg6gILcgYhg3wxv5mqNmJzfhHASxg2dFlxPUCuC9p/7sITfxYkc0
         5MKKpkb19F81EN3k7Z8kzPR28GqNPK0EL5lToBy9i+71juTilDamIANY25/3tCJL+c+P
         MhkmYGqYDD6WbrZUq7Y8vro6p6jxW9FyfnHb6++UGBI9PaDzTGLOmq2exh+uJY1FmoVh
         5bRkpDOlassC5+RY8NEedhgMBGLNKwMuIKwCae/Fzkqw0ffzm5g2SvfWTLWXT+yFmAlS
         ObNg==
X-Gm-Message-State: AOJu0YxqecxVWC+oq5YXzL1Un/6KTYwRy/rBoaT1CEja9NyyvMWQlF8w
	5fP2xbnrGLshQ+dfkyfC2+IX9IKysGJqVF9TyfC7TpV0Evb1ZfZDGGd8ef6/mO0=
X-Google-Smtp-Source: AGHT+IGCu7l9McEqXuH6/SgA3rnUnBYPHE3nvj5iHFT/5EQNOO1irKYuEFMPxBtPwb7TsRcPCb+zXA==
X-Received: by 2002:a17:906:f2da:b0:a6f:5562:167 with SMTP id a640c23a62f3a-a6f60d42710mr248152366b.38.1718396944105;
        Fri, 14 Jun 2024 13:29:04 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af332a00214df27025e50a49.dip0.t-ipconnect.de. [2003:f6:af33:2a00:214d:f270:25e5:a49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed3685sm217474166b.126.2024.06.14.13.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 13:29:03 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>,
	Emese Revfy <re.emese@gmail.com>,
	PaX Team <pageexec@freemail.hu>
Subject: [PATCH v3 1/5] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
Date: Fri, 14 Jun 2024 22:28:55 +0200
Message-Id: <20240614202859.3597745-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240614202859.3597745-1-minipli@grsecurity.net>
References: <20240614202859.3597745-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If, on a 64 bit system, a vCPU ID is provided that has the upper 32 bits
set to a non-zero value, it may get accepted if the truncated to 32 bits
integer value is below KVM_MAX_VCPU_IDS and 'max_vcpus'. This feels very
wrong and triggered the reporting logic of PaX's SIZE_OVERFLOW plugin.

Instead of silently truncating and accepting such values, pass the full
value to kvm_vm_ioctl_create_vcpu() and make the existing limit checks
return an error.

Even if this is a userland ABI breaking change, no sane userland could
have ever relied on that behaviour.

Reported-by: PaX's SIZE_OVERFLOW plugin running on grsecurity's syzkaller
Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Cc: Emese Revfy <re.emese@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 virt/kvm/kvm_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..b04e87f6568f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4200,12 +4200,20 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
-static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
+static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 {
 	int r;
 	struct kvm_vcpu *vcpu;
 	struct page *page;
 
+	/*
+	 * KVM tracks vCPU IDs as 'int', be kind to userspace and reject
+	 * too-large values instead of silently truncating.
+	 *
+	 * Also ensure we're not breaking this assumption by accidentally
+	 * pushing KVM_MAX_VCPU_IDS above INT_MAX.
+	 */
+	BUILD_BUG_ON(KVM_MAX_VCPU_IDS > INT_MAX);
 	if (id >= KVM_MAX_VCPU_IDS)
 		return -EINVAL;
 
-- 
2.30.2


