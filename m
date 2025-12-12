Return-Path: <kvm+bounces-65829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CAD67CB9070
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:04:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 069133009113
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D218317711;
	Fri, 12 Dec 2025 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFCQqJa8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vzw75RXm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339C2285CB3
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551889; cv=none; b=Piqqa6az8yOd0Z1yzg2Nb/UWV4kTYpTMGuzpKEujnuYKGqkujGoMnm0NXD+u6haHIMabCsWjsW3hwAiLHVxVdCZcdszyEnG3bq9sXW4mHv+dm9KfOjatYAiVstg5BEbsDSAxShJtnHdHnU2Qce2z3LULMythfWMuNslrc3f6K/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551889; c=relaxed/simple;
	bh=H4hGyE6JGILP96gBceWAnXnp9IwwNeyLG1wb5RMKk7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZCwzJnr5ViaeJ6VFuU3AKMk57kldnw71K2/lejyiQbDjewPbsr3nt0IzrcDYdBvtu7PohiMePPpG7IIIR6UAht3KIjG+0LniSDyn3IHpr2MDJ51xEqD6jChx51UY1N7tfrPei/cTB5wqDit6APzavOr/v/VForHBoXkEW8HFOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFCQqJa8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vzw75RXm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oJX2Vfp3U0oN7mc0xwcEAGTGJFdhzh3zAsgh+2IEEL4=;
	b=QFCQqJa8Znh2NHfUZkquyjbHlvlldxXRPpLQui1IMRDR5hF2TULF83Rq1ZQbymrl7GZm+B
	uABNyPAazQbFwsbnJ3cjmv0i6SH2Ocamyt82Wk4lzSxxujgFEJBhVFzFvDzVKjRofA6khP
	w/AnWuxQsGKehVKCZ77mVMH1d4ViXH8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-1WaGM5XtNPesxirbjTFLeA-1; Fri, 12 Dec 2025 10:04:44 -0500
X-MC-Unique: 1WaGM5XtNPesxirbjTFLeA-1
X-Mimecast-MFC-AGG-ID: 1WaGM5XtNPesxirbjTFLeA_1765551884
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-29f8e6a5de4so3659885ad.2
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551884; x=1766156684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJX2Vfp3U0oN7mc0xwcEAGTGJFdhzh3zAsgh+2IEEL4=;
        b=Vzw75RXmIFdyk7GNgCBpFK/jXEq5AjVu+kdXUlOa8YrXIuPV5TsTbDlb4/kwKH340M
         y+1RNCcN6xOX+3HW5xtoZzVL9JjLxNwrtMFEVwz3Wjuf3vaPNrBO70R6x0DgLCZfhsyd
         KHPDaBPEjyLTTekkKrYg/M5gec+25147/dVERHwm4vVQfacrWJ0Vqw4F+Pma1re18uVx
         q1G7CiwDoI7mii4xV+oxeazJ/QBoSFqHgZLAh3PNYVfNXHPBNnM1XjKR3y+ZuMrjFLuq
         q7/3KUzm0GE1nyg4W6wqGJvKMIWGxRjoHEfVVD5p5IAq3/RqtahMEmlQepszl4AhjmeG
         F8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551884; x=1766156684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oJX2Vfp3U0oN7mc0xwcEAGTGJFdhzh3zAsgh+2IEEL4=;
        b=WKEVisctlCmT4Gl3ckdoX4osSfTe0gByTPJS6MANQCKqTUUWvAKjoO87wnKPhsNSct
         NHRdKIDiagYcXXCH2SapYBv1071XCQ52RteWvsg/ttG8tTdD5zoIuJ54lMcNCJco+bdE
         OX9FNec6vVzvPxCGXnWTSu0PWuquZJHFBHBldlwAV0gcwqYGMTQJ8HXfP6q7DDRHO2XG
         lr8yEzGfzsaaSuCg790ob/qOwvx5pdaS5WZ10MQdAGVVziy63XTU5YEUt0El/njx37hY
         3TZCEvTlz4wa4QopmJZR3PR2fVmLjKm5sgnJ8/+X/2y9hWP72HTfK8lkZLIMeBKTkHwl
         QyKA==
X-Forwarded-Encrypted: i=1; AJvYcCWdFLAtvJwKjcj/k6mRecgAZ/AI9psovk8alGGoscZ7q1o/sKhtVnPUxLmdcwOYQowvLwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOj6EJJULQqj9LT1lxRdmqAEHCzbmUCnp06Rnw9SjaOWly0J+i
	A8WoZjS6tii9HD4wIYSWNHN+i4cmRpFEi99UJn3Kqo+OLA37vdA+49EZpmHrMv8a32dqc92p4is
	vRZBG2ec6ggaQc1TA7HODlSkf2wCrrbThk7RoJ8LmE8ZdsahS7Q76RA==
X-Gm-Gg: AY/fxX5WBx8Dt4r8NmYrFRw3Dh+ywxtv5DbI35Rt9ncCCJxxmUBWqm2VfKRrH1Nzqdy
	OJkhB/Mg39jFQwb1ipQ6c4ZeSlUDkLc6nr/LDlUCqTcV1P7Rnb2C7DEaxPN8brfhWv3as/1VsaY
	B0DLanWWPcvpQLIE5LT9YIAKyIaScMpX+0afsm19SZXZpZu6nYW1IakVgS9R+9xYXwYssPqDu41
	UaMKML1V46WtTOBdT3MjAzKvTafa8M8Uv57F5GXQysDV9quDFHHwshOTdmyL3vrB2znTVmxNTOG
	O+2drwp46WwuXI8MH9+TQL+PhsiKDD2mzwOM2FFmjm4jjLmfLLWfN25r4JnPp7JHxkI7dWPW3Rj
	Iqt6CcvsJA7EZWO4ExPslEi6v84Hko/dOjHG9X8OkWYY=
X-Received: by 2002:a17:902:e943:b0:297:f09a:51db with SMTP id d9443c01a7336-29f23e18ba9mr25217335ad.15.1765551883470;
        Fri, 12 Dec 2025 07:04:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGHr+3Yeke6CZ/UMZxEuq21IFxmSWHsTNUIAGUDU9/pwfuXux37Cj9LYKCOd+ZD6dBE5chS9Q==
X-Received: by 2002:a17:902:e943:b0:297:f09a:51db with SMTP id d9443c01a7336-29f23e18ba9mr25216895ad.15.1765551882964;
        Fri, 12 Dec 2025 07:04:42 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:04:42 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 05/28] accel/kvm: mark guest state as unprotected after vm file descriptor change
Date: Fri, 12 Dec 2025 20:33:33 +0530
Message-ID: <20251212150359.548787-6-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the KVM VM file descriptor has changed and a new one created, the guest
state is no longer in protected state. Mark it as such.
The guest state becomes protected again when TDX and SEV-ES and SEV-SNP mark
it as such.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c9564bf681..abdf91c0de 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2640,6 +2640,9 @@ static int kvm_reset_vmfd(MachineState *ms)
 
     s->vmfd = ret;
 
+    /* guest state is now unprotected again */
+    kvm_state->guest_state_protected = false;
+
     kvm_setup_dirty_ring(s);
 
     /* rebind memory to new vm fd */
-- 
2.42.0


