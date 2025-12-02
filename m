Return-Path: <kvm+bounces-65154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BD82AC9C238
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:11:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7D8A84E5DB6
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC1928B7EA;
	Tue,  2 Dec 2025 16:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJNLQ7t/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oh03tJsy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0022853F8
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691744; cv=none; b=thJOg525nnoaulhCd/9pBy1/g25uzTIv28bY3OPGrv82SblzQPiDtaedF+X1MF/7qpq2/aJXrYMwAXYXybmPyeEY5NFxFGrRumMxX2qYPUFcWOgglmkOCS6dqF7GGslf2HWEcN4GYQOD8EbG1f9LXefhLFNBBm+YrxVnPsma6Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691744; c=relaxed/simple;
	bh=5Yb3X6PZiKols/sQXmoknfK/pTPbA3jLRfEhVBUsSgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljwJJYmntcE+J7ImLr8fugG2w9aNa0zvmJGUOUcwRs6zrsAdr5V2lCWu6toF9sj52vZqcVUqKLvkMacmy7H6LTzjPoKgQeisGeecq69zAwKEltA2SnM05319RDE6C1GM7s8HJGrW37b8d0uCYuLgJHp5eZOuhIqWn9QoxPeiRJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EJNLQ7t/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oh03tJsy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764691742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U7+Ad1DQku/KL3b7bCdX4+uTWQCvm0tEszy834Ayws4=;
	b=EJNLQ7t/HC9pHk3ZOegIXaOE0LBqz7z9JhyvjOF66wtwuqaYMiDH4u7MnxayNaMvDs5YJp
	OqZS3sxCTRFZ0fEDp08M+Md+C8x+ye7mk8Un8rM5K56ErOGc/YAf+bvnY0RfGhFzLdvheu
	6Ow51DwFplUTPZ5WPNXHIj9w9IcMVFE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-MK0eEaEwMjWi3AqjbWQXZg-1; Tue, 02 Dec 2025 11:09:01 -0500
X-MC-Unique: MK0eEaEwMjWi3AqjbWQXZg-1
X-Mimecast-MFC-AGG-ID: MK0eEaEwMjWi3AqjbWQXZg_1764691740
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477a1e2b372so52402325e9.2
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 08:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764691740; x=1765296540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U7+Ad1DQku/KL3b7bCdX4+uTWQCvm0tEszy834Ayws4=;
        b=Oh03tJsyARuh5Dsl7oBoLvsv7m2r/pjcloY2fsaAWpLyn+lIdSG5Z4JkmFmhoueWlX
         ieVgd4/7z+8Jve625LF5WDVxhQXMA9SJ7706XDzcBIFEhGthdMFJRha8fa1zQcLTiAwz
         t7bR92FDfiFJ5gSEpI7P1+74uTFnwJsYFyDbZSrhAubm6NeLqS5VJTIhn7L6Nw0Y1hd3
         MqBR6ytVcyCBKeD9TKHfXFWPpIq82PKMh9Ql3GjJ4fjOcb6ru2muRzdzzk6VQ7MRABNw
         mQqPuQphGB4TRkEdvOk1jylX3xolE9WvaWJzNml/sNmdnSJaNhuJqiXujrnPJMD7+0qp
         H6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764691740; x=1765296540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U7+Ad1DQku/KL3b7bCdX4+uTWQCvm0tEszy834Ayws4=;
        b=nezo7dy8D1AMOm2n/cX2Eni/KTgXuhKBkhp4kLwmzaGhguFacjMmTSvTjTUwABSOCY
         dj25BK5n0NY9zeUXqVoj5qFTcCD3c7KJdZNE6c9kgebXkb91GaYauHYVo3yrdpw6XgzC
         GlHmikgEzgB922ZUj2D76aHaBT2ceLDmJUeYIUHeVt13JU2g3+3jPfDx7dIhhB1nBFYx
         Gp3l4Tqu3lE7PIibcFr2qx5jTBuGQDWTcWqDqf1nJb+NtnjfA9LlhkbB9XbhdSX0z+oN
         hrxKfJQWAeyLS29BW6CTNUlbnScy6TeszAszwi6VFDqya07jbiW1PPwTtdE2h48Ks4FT
         MeQA==
X-Forwarded-Encrypted: i=1; AJvYcCWTrw/+cblAyG+4Xn/kKHoXrJIiKQ4IRDRE/prLYhqgL2+GNsuQPZOCs+F9x49uTCAKwjg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyGYqOTKKwjJe7kGev/xFpCE5CBgiEqvnH4Z2GCA6KURv8k/l7
	hF3h3LecunjTtNh9wKtt2HAN8hVMV0SD+2jhNOUXCBQN3aQu3kLYaH/09J16ouN2V5cDHhLl5JC
	Nzrh5vSU7UjeYQD76uhPq8BIp4keNLkzQGTFs7+j/hr9t9PFu9NSGSA==
X-Gm-Gg: ASbGncsvwh0sVpIxuzK9r0NjtRVN9o08z5ZSw24dOg+k0UlAaDyoc7sELUY+B7DOENo
	tHa3g/kFOled9eI5ZRWy5urXBxUGhK54wiSil0jjr+/cQ0B16fIc2p7bX5OdryxJj3rCazSlVNG
	qmeaq72H9qlQ4NQR/WTURdGbXEK/RcDf3jqgN8sIeyNCI5lElq7G4vVym4DV98oQtT4fQkUp3LF
	IHZIKyLsrxcpljU0H8pXVYIqYn0NBGvHHE3tGwPAIrmSy6nHE/10srQ+AJNJE5U62te8LPKT3eF
	p9RqRCQvTrmXWKEYHdRj8f934hsSqhk0a0diiO/fhKY2RwUN3ahg9OAJ18cr3DAyRgbErqV3r6a
	+cEKe/k1lAILQ0pl6Q5urQOS7F2gYTn9KAWX56Aw1A9r3ntOXVfMy2ZwtOqEz+oGHd0MESbeT
X-Received: by 2002:a05:600c:1c8a:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-477c01ff636mr474350535e9.32.1764691739638;
        Tue, 02 Dec 2025 08:08:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFCJcOKBkToQRQqCimSXYNAuCA53uuEuTDBUZ/jgsC1gwfTGJxcvlPlmY/zYIMOG9XF+jmUlA==
X-Received: by 2002:a05:600c:1c8a:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-477c01ff636mr474350245e9.32.1764691739282;
        Tue, 02 Dec 2025 08:08:59 -0800 (PST)
Received: from rh.redhat.com (p200300f6af35a800883b071bf1f3e4b6.dip0.t-ipconnect.de. [2003:f6:af35:a800:883b:71b:f1f3:e4b6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caa767dsm34300899f8f.38.2025.12.02.08.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 08:08:58 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v4 1/2] target/arm/kvm: add constants for new PSCI versions
Date: Tue,  2 Dec 2025 17:08:52 +0100
Message-ID: <20251202160853.22560-2-sebott@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251202160853.22560-1-sebott@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add constants for PSCI version 1_2 and 1_3.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm-consts.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index 54ae5da7ce..9fba3e886d 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
 #define QEMU_PSCI_VERSION_0_2                     0x00002
 #define QEMU_PSCI_VERSION_1_0                     0x10000
 #define QEMU_PSCI_VERSION_1_1                     0x10001
+#define QEMU_PSCI_VERSION_1_2                     0x10002
+#define QEMU_PSCI_VERSION_1_3                     0x10003
 
 MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
 /* We don't bother to check every possible version value */
-- 
2.42.0


