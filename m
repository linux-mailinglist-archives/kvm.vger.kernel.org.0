Return-Path: <kvm+bounces-18292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B1E8D361B
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C950B20C9A
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE3F181308;
	Wed, 29 May 2024 12:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WScUpzsK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27FD181BA7
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984893; cv=none; b=QTmmVU4YHums+zOZXPthKKb9WJkp3Gw0/8MxWJ2HEn505kQPAxrwN4PMjBWXihewDkkv7WD0doxtA9zTXOirozvQ6GHgq5NihS15CB6NzIrqZwOFSHujCbKs33zYvJ6cGp7XOSpIedZQmxVCRtx+vfO5FuO0kEFltpH/3ZuReLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984893; c=relaxed/simple;
	bh=WMM5G0N4qiU3hKk5YjCYS3EFswJ4zM88IW8Mlp+DlzQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QMTYOUVAR9R6q0VXKyw+ZY2IBubZIvd2QzTF6Tuo5CCMucG14Ar1oR7zmjPoRU8Jd0fkAo7NHQ+VJ0xUhfsCdnsL6rKSOfZ39rHnXqkPA617TvaMNjoVXwgfFKTR2hn1qUU2gIVypHMIdfLn0JDW1cXkx1WLlF14n26RtTEkZ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WScUpzsK; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-57865139b7dso1201616a12.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984890; x=1717589690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8CshqLHlWDJc+sAJS8Y64z59WBwvQ7VfO+S7UGCs2ew=;
        b=WScUpzsK7gne4n8EhCkDuN4DS2Jb45bmol3C97hzTuY8D8Gu0S569u1JpR4Cc7zXTC
         gW+v+hprtbPD1sYViAqq0J9snNxdNtl9Nn1pBp7Dz3xc7MABO+jZ8Rwpgq8vQNfn0hew
         810Ro9s67GSxXYPS8XZmMX/zmw9lvQuYRRV4hhTCsCuVJmWR+/l07zWB2Yggnd+ir2pL
         5f0zByXgXOwNiPmN7EyjrH7dRLyM1BKRdDfxMgVU7lLQVAmEc9CjDezUJ2igW2U7Ut9R
         hNKx5JN6AtnFjBpo+9cOTpSkkkLG3+qscSaBmuSIf0jQL5tvQvsKryuVy/CBIJgJn/H+
         LGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984890; x=1717589690;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8CshqLHlWDJc+sAJS8Y64z59WBwvQ7VfO+S7UGCs2ew=;
        b=nejW46joFyiUo1G5sd/fO6dRKVpGfFjxQMYR9Ie1Jr1X49nVRhiUVxflLoi8xemISc
         Yz8K/Y4W3tXm2tJSdb95DyRD81lWB2EttE3wPR8Mse/JZBDT3E7aZ1ERbAnvwJAVoKF8
         Q6JFirl8FnfhZ7k+fYwbcFkgr1+kn2qJP85qBthvwiuGffjyEWnlPW4EhUhyYUTzlFqT
         u2S0pvLz8SKFis0Hnl9NnCvxk/HCHskWErvigbF+p7myFoPtP2daLkkm9Ce+s5UgHQQ/
         aZ8w5pt9XiImTyL9vDE0Of0lEVDicXxooL2RuFaYpF9s3FIrb2RI7jxxAinLBRUTNcxj
         BpGA==
X-Forwarded-Encrypted: i=1; AJvYcCVO2LLLxJLxJxMt1bNR23SzUAnEMQCyLQERgd8GNAeDb31NolKJLZvLxfsiR9/cLQ7o4r7qVGAKvVx2eRnyaQZpDnXM
X-Gm-Message-State: AOJu0YwOCw7j5Dbws97/Uqo9D5cbM0NYIORtr0hcE7PpgbyG3cuhNcj2
	K+K5YyAh+ivCobj/iRjV+CtK1IohWYCLHqxs9rcEW4vgDKQ05eet7Wx7gddXS6Cx2z6NoSTBUQ=
	=
X-Google-Smtp-Source: AGHT+IE8phGpuuq3k7TrjskcqmK2dPZ5kpLf85cdSWAkkY4MTdPq3mbXxQAEr7SdzcRt27FdzPre1IagDw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:35b:b0:578:60a0:9995 with SMTP id
 4fb4d7f45d1cf-57a041685b6mr2744a12.3.1716984890481; Wed, 29 May 2024 05:14:50
 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:15 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-10-ptosi@google.com>
Subject: [PATCH v4 09/13] KVM: arm64: Introduce print_nvhe_hyp_panic helper
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a helper to display a panic banner soon to also be used for kCFI
failures, to ensure that we remain consistent.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/handle_exit.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d41447193e13..b3d6657a259d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -411,6 +411,12 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exce=
ption_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
=20
+static void print_nvhe_hyp_panic(const char *name, u64 panic_addr)
+{
+	kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
+		(void *)(panic_addr + kaslr_offset()));
+}
+
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
@@ -439,11 +445,9 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr,=
 u64 spsr,
 		if (file)
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
-			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
-					(void *)(panic_addr + kaslr_offset()));
+			print_nvhe_hyp_panic("BUG", panic_addr);
 	} else {
-		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
-				(void *)(panic_addr + kaslr_offset()));
+		print_nvhe_hyp_panic("panic", panic_addr);
 	}
=20
 	/* Dump the nVHE hypervisor backtrace */
--=20
2.45.1.288.g0e0cd299f1-goog


