Return-Path: <kvm+bounces-67734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6128BD12C36
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:25:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CB6163026F00
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E5933596E7;
	Mon, 12 Jan 2026 13:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N3VvS9En";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TlUtLxjH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5316D3587A1
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224225; cv=none; b=f65IhlWV+31L2zLqLOlcspaTZWhfiV36VHiNur6VufnrJbhn0RDigPPfXGUKpHHW+IfCvFkjO6L7qCbNW4tg2483pW3MxK/1jQIbnuw5DSVicOPZvR63Fpt99XyKkqRWgF97uD/we9scAtGzE9LbX6eWmCX1X/8OQhLXgJcUrR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224225; c=relaxed/simple;
	bh=ovZUpCvarhw1g/xrf8eDesGWqW4RtMqwQyFwRTa0ASg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irnNWvncNrjC6+dbIwE24zRF+EYki+Rj8jXfGiiUAiP5irC1NESJjWYtFzEo3/Zedkw1hI3JbOLQfMGqp92Lx489teQ6BVT0Ulpk12G3eKu9t3KX4BP2kghHQTuOHlCO1babLg73andIYHyxNklEMNAMhtH0GIAbFfSSVW+8xiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N3VvS9En; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TlUtLxjH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9FW+RNoWUNg/DJr0t6Axhc3qYqFhjtvAQISw7/ozuW0=;
	b=N3VvS9EnBkriVjTMrXf7JCK2MdIoBBGv8RGJPKHieaoGdkXh0Dv6sWTpAkD1Iefq+WMasa
	ymGZ7QkDfCb7z4q1mnrN9Vcmkxwic9hTWNghe/wEKkiOD5hzpHyPQgEo9NRhDHaV7Jrj4d
	AGui59h2hbAPUSbYii+lAgPCEuKQp7Q=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-DFbWBxfiM5-hCFx_mBAccA-1; Mon, 12 Jan 2026 08:23:42 -0500
X-MC-Unique: DFbWBxfiM5-hCFx_mBAccA-1
X-Mimecast-MFC-AGG-ID: DFbWBxfiM5-hCFx_mBAccA_1768224221
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso4438650a12.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224221; x=1768829021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FW+RNoWUNg/DJr0t6Axhc3qYqFhjtvAQISw7/ozuW0=;
        b=TlUtLxjHmxX2VjO6RYkXmSVQcVSL5GeFZoSXB6i27irkHx3ssqAQqvFvVIdSgsemw6
         RT6D3/WR5rdsuISdwa6tEhQOgweGqIb3a12wzlCh5K9kKsNny2NrhlX8ShNH9tjMBeQ6
         xZDEbXc6+rXgAjdKLY/MdK1Cs2JPeQkUjxlQGMKwWqQivCF/uVgrVUEIBMJ83qKJqDiO
         RFswxc0FnFKK3KJ9SI10crAUudEQaB6vZBQqpNxQX92zB0/KOk4gPla5up3z6GHcraFd
         JfTEXw6yGbzO+mD1POy7n4dCEOy1mtGOEq8QBvyxkATC6zdvZE2EoBjlj+ihnsFQ39Id
         vONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224221; x=1768829021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9FW+RNoWUNg/DJr0t6Axhc3qYqFhjtvAQISw7/ozuW0=;
        b=gTLbrYUoepVEbswRVRsmPIqg3hGhpqyHAFfn6z0qxe+JgLhLN2I07AsKAqYRB0VE2i
         H5ip48j/9++7qHbscUmMt5ifv8qWGzDa2GY6A1HvaAhK4MqkqN7ZzugRPIv11PysxUGd
         7xC4EDtkmDJJI1reW1sqkpEwbwOXbuFLRqYe++gYJqGQKqfZM9Ap3ItU+j1p/9gIfvcm
         4+F0R3pr2rFAxihW+7vuOFnhSY0Y3fELBQNoQ1/Lh665uHhM0yRTKWW3RC6Px4IyVmGH
         zu4xHjH3psdBbJ+qjZExFOX7SJup2z196pypNALtNOGYMg+joQ0aQg3s0vHqSIC6bz9z
         l3tw==
X-Forwarded-Encrypted: i=1; AJvYcCUCv4VROM/xbyyUUpCHOY33YuOvhNk/Rrn2msoKgfV0JZ+HaYyD4VcRN+8rawUgQHYZvHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzAksCdGCe9wA325v9skeDpS9I9AWF5BfNKSi9z7mxaMmPegf8
	p4MV0YY9FXR1kelWppDm2qXFlQZZO0ohdSsZOwoOPOLWYHovFqFQ+r+yTS25SxNcM0kz5Xd+FyM
	b+qOe6Xh48oRTkxAD/3Hm3Jr0hS/y9fB5xy1dH2Pa/d4gDs54nLKj5w==
X-Gm-Gg: AY/fxX5ZhbQdfS3y0WKQE3fbLKipepHwrKeTTNknHoNNMHII3c2FKP2wxt25xTkGO0G
	HoRP//vYMpXXq14Elq8MYGaFZIK4vEg7fjSUnYwxLGC09t6eXMsdpifvsR7w15RLaHSoQU7rj0H
	3pNxalfwSG0ZrxXnC6JBlbkFq7LbuQ4V2DpG37s98GHBjTm8YfHCBxGp0jCZPtWkmTF+tnAlhee
	W2GNKg6QF24phNS19I8ye3fDXb9vHyKud7X+cCR69Oltq0fd81I9qNDF94D7yn2T3VNV1u+iCqM
	HdscPPh7SU/jRSwY9wBQGwCIb/DFERo7pxXGiCv2iwJpprP1dTbP2q/VwMRpVDoKMQ+jFeR7/DW
	Kvq7Zhuju7d15lSPONAYx4QfCtZX1UJ28kifogQHfUsk=
X-Received: by 2002:a05:6a21:3381:b0:366:14b0:4b04 with SMTP id adf61e73a8af0-3898f97be3emr17859379637.64.1768224221160;
        Mon, 12 Jan 2026 05:23:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEHzg6r/nlFCBwy29+gmS/Y3kVmX1P+W2vycZ7SAs4A65GkTF6SdC04/yGxH3/dD/Nwap7Ysw==
X-Received: by 2002:a05:6a21:3381:b0:366:14b0:4b04 with SMTP id adf61e73a8af0-3898f97be3emr17859363637.64.1768224220806;
        Mon, 12 Jan 2026 05:23:40 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:23:40 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 05/32] accel/kvm: mark guest state as unprotected after vm file descriptor change
Date: Mon, 12 Jan 2026 18:52:18 +0530
Message-ID: <20260112132259.76855-6-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260112132259.76855-1-anisinha@redhat.com>
References: <20260112132259.76855-1-anisinha@redhat.com>
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
index 762f302551..df49a24466 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2650,6 +2650,9 @@ static int kvm_reset_vmfd(MachineState *ms)
 
     s->vmfd = ret;
 
+    /* guest state is now unprotected again */
+    kvm_state->guest_state_protected = false;
+
     kvm_setup_dirty_ring(s);
 
     /* rebind memory to new vm fd */
-- 
2.42.0


