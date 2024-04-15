Return-Path: <kvm+bounces-14672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02BA78A56AD
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 17:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 341761C20BEA
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7996279B8E;
	Mon, 15 Apr 2024 15:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JLbYSGiw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EA329414
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 15:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713195784; cv=none; b=Pi/+7qciDl0xV7ipGSLhkcTAA3EK4xvTaUeC/IyYLq5bMV97mfqPP1Ao3sIEsTIAR+VPDSvnXV/xZUh7MCkTOzjidOXXM3qSxopX7iqRfLPsLaRrSshJPFFZZOlSTivvA2MZwddr9UJOFEwPnR1abbgsqTumSTrO9SSUNK/nXIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713195784; c=relaxed/simple;
	bh=Z9r8D9QSl3GEE4ORyYCOGlRGYhJ98pS5X7jHyKbvH5o=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rPtmCP2LJiWL4ev7RzYOLyI1eRhDCpWf4LfKNOe50OiVhAu8MOTwbVIZ3kDlCkrtwtwRlTkkrXNJDXjdiqKJ6mLYj3grtlvryGiUUBLTTlhgL1RtE1KC2W6mnRYO0TQjJxKqcxN9QfUcc7kDzxfFMW/SFj6n3O0kNeAJkzN3Jbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JLbYSGiw; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3455cbdea2cso1933698f8f.0
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 08:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713195781; x=1713800581; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m0OYIHwqPcppppuX9RC9m/x15KEmaGZ0889FlyZcUI4=;
        b=JLbYSGiwCTRQhPV9qgXLDIJ373A7kYEx0YnLnOpnHa3lGrlko5zYEPaI8NsPwLu6bz
         29IoKevWyIgghFzpO44ilner8DGd3Qg7zr7A5xak041AnS6fUplWOsF8JG+TFhhoO0JN
         qppy7PEOqOU9ny3Kfcb0/wrQp1tbaU1JFV1nsW27C0atZR1XqmuhhWkqdZfpdmeyptGg
         DS2JO6YJiKwmmp7NrlId5SkfyfIeTDQPkoyz0DGCxOsFCFc5f7/KACp/Shxv0QJydi0T
         JE5JjMtBHyH/Sz8n2KY1rhnFY0U9zsgErgpwlNgykLGZwurvoJHo0/quYHNShm7pIfSg
         Slow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713195781; x=1713800581;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m0OYIHwqPcppppuX9RC9m/x15KEmaGZ0889FlyZcUI4=;
        b=Ow8KOFyMXcRcP6A5lolq6RLgAw2LFO/6OBOfngpwftTyBqsi28xfzhoK32mmJ7Jwtk
         A3ZkR7U4bFlF6hGaPsHAPCDqL9EdAYqZOAvqBAMoB3cbmDyrvvq/a8LyGqLyz4OtvDg4
         fbhBU2bssLKkOmXYxu+b5TxvtEIal5TmWNEEQnNujcMtKeq7qAqrJeOLY1NdPGjqerDr
         eHNU7hG2bHllCzqN6wRkL5yFXX9tSwiznrYyK6By49DcDwrEAxraWUq8ZLqNg30t9NFi
         KSBtp37HmigLOKS1/dDmD9YSBOpoOm72Itgjr5KPutV6bmVNDrCBqYX6BnXz30UACvV4
         SbDA==
X-Gm-Message-State: AOJu0Yzm7WQa2Y9UtfPyqrM1+uJk9bJwZeYQUL/MKKgG1B2O85fGHHH5
	BCfEe8VmE7Ofmemst8J/JuILbHf/1lSmOHkX0XZbSoOUweApYFHO4LyRQWmtr9zY5XGYyObS+98
	yyA8B/pw2X6bomIcvyXmYBE3cSe3kuKixeip1TphcVE7UCawD1oyxyQG+5854jousD92C1Wq4zr
	q+sKep5unZ1n2UOec4u/JBe92Gayd3gTx8OZDfg8Q=
X-Google-Smtp-Source: AGHT+IH3wHTcFh8t4CYIixNM2WAEVJ+dSslThVNddcYC/kU8IoCnIv8ooiJdqhiAXZxQoE6qj6miMrtxxk/P6g==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a5d:55d1:0:b0:343:b2b9:245c with SMTP id
 i17-20020a5d55d1000000b00343b2b9245cmr61wrw.4.1713195781128; Mon, 15 Apr 2024
 08:43:01 -0700 (PDT)
Date: Mon, 15 Apr 2024 15:42:44 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240415154244.2840081-1-jackmanb@google.com>
Subject: [PATCH kvmtool] x86: Fix PIT2 init
From: Brendan Jackman <jackmanb@google.com>
To: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, 
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

KVM docs[1] for KVM_CREATE_PIT2 say:

	This call is only valid after enabling in-kernel irqchip support
	via KVM_CREATE_IRQCHIP.

This was not enforced technically, until kernel commit 9e05d9b06757
("KVM: x86: Check irqchip mode before create PIT"). Now I get -ENOENT.

To fix it I've just reordered the ioctls. Doing this fixes the -ENOENT
when running a nested VM on VMX.

[1] https://www.kernel.org/doc/Documentation/virtual/kvm/api.txt

Signed-off-by: Brendan Jackman <jackmanb@google.com>
To: Will Deacon <will@kernel.org>
To: Julien Thierry <julien.thierry.kdev@gmail.com>
To: kvm@vger.kernel.org
---
 x86/kvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/kvm.c b/x86/kvm.c
index 328fa75..09127c2 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -150,6 +150,10 @@ void kvm__arch_init(struct kvm *kvm)
 	if (ret < 0)
 		die_perror("KVM_SET_TSS_ADDR ioctl");
 
+	ret = ioctl(kvm->vm_fd, KVM_CREATE_IRQCHIP);
+	if (ret < 0)
+		die_perror("KVM_CREATE_IRQCHIP ioctl");
+
 	ret = ioctl(kvm->vm_fd, KVM_CREATE_PIT2, &pit_config);
 	if (ret < 0)
 		die_perror("KVM_CREATE_PIT2 ioctl");
@@ -171,10 +175,6 @@ void kvm__arch_init(struct kvm *kvm)
 		die("out of memory");
 
 	madvise(kvm->ram_start, kvm->ram_size, MADV_MERGEABLE);
-
-	ret = ioctl(kvm->vm_fd, KVM_CREATE_IRQCHIP);
-	if (ret < 0)
-		die_perror("KVM_CREATE_IRQCHIP ioctl");
 }
 
 void kvm__arch_delete_ram(struct kvm *kvm)
-- 
2.44.0.683.g7961c838ac-goog


