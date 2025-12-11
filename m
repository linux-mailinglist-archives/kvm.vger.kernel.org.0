Return-Path: <kvm+bounces-65800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A2D68CB7566
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 00:12:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ECCBA3010297
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 23:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44FA296BB5;
	Thu, 11 Dec 2025 23:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lw7bErcr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7501A288C86
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 23:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765494719; cv=none; b=lyZbl1Sh3eR63vW11YabLdN0G8iecKf9WZui3km57VZmPS0u/yt19BJ972Gw2jOBaGbFf09L2q6IrAlDXWAftzSOGCcuAhtITl5gDrbvPIAY6+BIZYI3w0P6esqWuktcYLSoSTwQb/37GHaVbKQU3Y4N8sSJp4oilqtes+gI7a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765494719; c=relaxed/simple;
	bh=iUux6bZ7hnAFop5t3Tc0bV8c3R9kYPw3w500saFOw9I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eYmmzNCk1Ofc5USrtix6FvAMuAbO3kqeSnb0wVbqmiRGIjCQsaYmEYy+f9HBvSi74qyrrl1b/x26FyqhCcm4FWU8Z9rD+z5m0a+LwkyFu/iKuarsCkO1KPGoiT4TCfEHP7BIxbshdoZWoZh8q6lh1sIGqFIB0CCFvq50gJwcfnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lw7bErcr; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471737e673so600281a12.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 15:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765494718; x=1766099518; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X15oZySjJbSCrO2lEvrCvE6Z0EO7LBpy1DdZqpA1W8o=;
        b=lw7bErcrTwg+/M08rHJUhIPOU3jfyeMz5poDqGdEVzeG6f+BRsvVWX5V10btCWc5+H
         9ZGTqLY8BEsc4kuVrPGGB1wVHA+/LSjBCE/IuuUGunY3LgZXq5QuK35gdbcrGZLNuVmB
         0YWMYKdWdaQ0TqGBPUUUm0K3OgT21SnzWUNvJRLltFs8wo8gZ6sauD+h0yy95FCNoKrr
         Gger3yF6QH3fc3pYPDlQ3nrBWEp4ahqq+dPj2BLG2CIuiUtYtrZiDAf02Qtx+VZ3NtbT
         B73S+9Z4gnVdgQO4JE+aT7Ti5Xzgxtgl+ryUPltxDcAykNAjbAji0yOfSasQPEqliDsO
         QA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765494718; x=1766099518;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X15oZySjJbSCrO2lEvrCvE6Z0EO7LBpy1DdZqpA1W8o=;
        b=HfNAqK1Ar8bt1EpAJTTVh3rtQbFGfUJuEPZHEoZ+8vdfKIKMRqC6/oe2Jd4/mOWkfa
         7Xf9WCdUwpZ7B886Y/I4HyKtNnCgCz/O2qEvJVUZy06mVdxKch4lV8EioxlbSexEgJeF
         cCHmIF+V6VLeHm79eKwjnmhOdXXtaSJBpcSqc2dQdV+2zOJyhnV7q0HUFOBTvQijDMPy
         ptMFREDW9XeWKk+m7vZJ/Ew9scZI+03i6Y3c5Fqv091x63fnG1n2T6wD0vrf30YZQ28M
         zPFVVJZC2pvpH4Elrp/NvHgRfEcACHDh4zT1E8sz+GUOByDYEJnYCuNKmkLz540+d85Z
         P8dQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwhM4rgOKN69ICMbNzppZni17/CmUkCiHHOY4Ye00nQTCGqI1Gz9sX3yC/sZ3UTuTBfXY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVrKqijbipuoeT3jzpHGEMm9gfaqLVV1H3zdHqyJZjIVKebOYT
	WtemNRHltYVtLpyapoW5qet2PRg0NYMWgCg6nc2PJYt04rlh76sL/CSCvzob+5o6hBnpa2MnQI9
	7It3fJfLdHDBnp3pFfFYqmw==
X-Google-Smtp-Source: AGHT+IEFcwVXn7FGL9EvmunUtSNjXQc5eStgYun9VoGblvSSr3zWfOpDQBfKsyUjtOAo0oG7RF2K9NdfZSKdlVGW
X-Received: from dycry20.prod.google.com ([2002:a05:7301:1014:b0:2a6:a0f0:d7bd])
 (user=marcmorcos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:40cc:b0:2a4:3593:c7ce with SMTP id 5a478bee46e88-2ac2f8b138bmr226286eec.14.1765494717614;
 Thu, 11 Dec 2025 15:11:57 -0800 (PST)
Date: Thu, 11 Dec 2025 23:11:54 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251211231155.1171717-1-marcmorcos@google.com>
Subject: [PATCH 0/1] Clean up TSAN warnings
From: Marc Morcos <marcmorcos@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Eduardo Habkost <eduardo@habkost.net>, "Dr . David Alan Gilbert" <dave@treblig.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, Marc Morcos <marcmorcos@google.com>
Content-Type: text/plain; charset="UTF-8"

When running several tests with tsan, thread races were detected when reading certain variables. This should allieviate the problem.
Additionally, the apicbase member of APICCommonState has been updated to 64 bit to reflect its contents.

Marc Morcos (1):
  qemu: TSAN Clean up

 hw/i386/kvm/apic.c              | 12 ++++++++----
 hw/intc/apic_common.c           | 24 ++++++++++++++----------
 include/hw/i386/apic_internal.h |  2 +-
 monitor/monitor.c               |  8 +++++++-
 monitor/qmp.c                   |  2 ++
 target/i386/kvm/kvm.c           |  3 +++
 util/thread-pool.c              | 24 +++++++++++-------------
 7 files changed, 46 insertions(+), 29 deletions(-)

-- 
2.52.0.239.gd5f0c6e74e-goog


