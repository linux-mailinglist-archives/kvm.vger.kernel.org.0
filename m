Return-Path: <kvm+bounces-65153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 169E6C9C292
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:15:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B76903AEA5D
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284D5288C0A;
	Tue,  2 Dec 2025 16:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UCfzE55b";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LUkPleRA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6320527FD49
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691744; cv=none; b=uiv/xQo2GQ4zjWYjIzxL6LS7Xz0uMsiuvX2m2Wf55lePED42sGAm+D/efqhj3QZapcVuT8ZDGTq9aBAb2T1+PuYfjZGGKy1qqvuORM3NtUoLNRhnpMhG+F406Cls2KB1qnWjEauWcA1XIybXF0ZvphD6MygDDriy5QX2+rZI1Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691744; c=relaxed/simple;
	bh=gC6Q+HMpFAJH1tp5fCDIRqEJ1MHUxFI/yXEXmBCtKx0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C0+iItZxItY/2DlMMb+fHLYSXWg8fkqH8cgl4uxQzomlwV1MR+T8oWeJCsJ55ir3zweeFdCuOsRxQ5EhVYuZKXqmjuZ7pnIFaBaRqBCScNyppSMhPsZs3RJyOu8KLA5c0Fh84hlVIgogeQmd4l5UC+I+SIqRAU50nw9h4HW7rvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UCfzE55b; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LUkPleRA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764691741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VN5D96R/t76acLMeIjKxcWybmi4kuwmjRsxRAB7XktE=;
	b=UCfzE55bIOhuT395iNYjQbkKzLXK/VpND2cG2aMfq7CZHJ25UWEJ/7461fWaMVk8h4FTUE
	zFZ6CVQL9lB5I3/MoYgA2PHKQvKoCwe5+6upmHVP3QxxB4Snb9U3gOkOwbTh4e9JmSqIsC
	HxfuJZK1yHTPT733SGNSDKQrE7wpODo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-1FrhImXSOoOvcgzIutpZAg-1; Tue, 02 Dec 2025 11:09:00 -0500
X-MC-Unique: 1FrhImXSOoOvcgzIutpZAg-1
X-Mimecast-MFC-AGG-ID: 1FrhImXSOoOvcgzIutpZAg_1764691739
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b2c8fb84fso3459578f8f.2
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 08:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764691739; x=1765296539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VN5D96R/t76acLMeIjKxcWybmi4kuwmjRsxRAB7XktE=;
        b=LUkPleRA3XV0tht0nK3IaQ46m24LZQF8EsnOfwNpLD9lQhlz+aljMWSivL6LVCdT17
         8Igq+9KJvH6OZDwarwSU5BSebS9PXpVZ9pSNUBO4D+t00rpKRVbqs94WKjP0932oAH55
         UPfsWoJgGtdW6n5UDW/sSW1d4gyVsqxOwEzLWTSjW30SZ+01ooJTwYNQuqwQ1hZLQrUW
         fl2TEJF2HOS+ZlNKki456vp9lJur4AwOgs6adeuXaFfZujkEeewTGntbG33zP6t/W4V7
         i/f6df2FpYgEPd0UGjWpJ4fIKINVBkFSDk2CnrCWsmo64LeYFdonPAh1ciT+MOIQdD99
         kPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764691739; x=1765296539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VN5D96R/t76acLMeIjKxcWybmi4kuwmjRsxRAB7XktE=;
        b=qy2sDsfzjxkowNVTgpLcgk+A1SqdSCue/E7RBk0K/T3j1ufoBsLlQRC+Dm39QJ42bt
         8flA6OFXI4LMjnXrte2hKRDAMNgN01MCS1oYV4uaKp7Q5mboSUT+5DTZ4FOZAy/P2u9m
         5hcKzMJ+2QPXLaxypqpQuom05LL5iBZn4cAeZhgr+YL5a6fLrCP26PGkfFXk8WAL3++2
         shjJevY8Wd94qMNuXef2KxUxRaX6OZr4y7ayP0976jJDHoQm2GG5Wlrwd+WRipgqozQT
         kte5EjyMVYdxGa/2XNYJlA5UXQWUSAFgJHvfQoLQDEzfaqYJmjmNN7RbRh9gNdvpgcYK
         SJGA==
X-Forwarded-Encrypted: i=1; AJvYcCVGHytBF/S80lC4KT7bCRl1gQ7TC7cXHGnBjlc/+gQBdGAzrJGfzkjbT3EoL6Y9zfmEOb4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcFTBB7dLgDUsMMSUt1Zrr5WDozoEi4JpNzRlwpxkRgBQWi3Ym
	Gq4szYhykm1Lv7c1eqfijdixdzyJqp+/DP46TuB/j2m74JU/XcfvTzUwlz90cec8HzMtmNMqX/v
	jG8l1I8HQ7jy439AUH39jD1oesy3iXkB2kr9V3T5T1qEx+5SLyq7o6A==
X-Gm-Gg: ASbGncs1fkRD+7oMUYUafy8ydLjEWbCB6A5KsYznkRM/fHxdzZ03ynNtCCk9Yis0GOZ
	JuS45CRY12tyJM7pFV24ryh4wBgQijBLIJErLhFJFjPhv8L/wE6xQXmadxHQEXD//m469AFp/fa
	X0mXHeTQvGeBZxDmvuu2kVKrTaUlJOSnZXuNMEwsq5uF7g//QtuGehjMCT4VA3ntHRmEe8XDR2n
	6e/tydwxHqEYG3csa+1ZOcl271XMwVbr94kKdz25Q3MFTyuOZorE/iyw6cFCiSsitK3wHW/Sv3Y
	RoIj5tlSe4Cy3zyLw+5J+i5Ulxw+lLQI8E1q+Gt6XEZE5pl4oNj8I1K44Sozt4TQYq8N1Lp+MbK
	sKDOcpc1VHTtWboJg7VTqQz16mhMvnoc1CBKqnwmerwauCq1fcNc1iPRIRZS4rRbmQqvlaO+c
X-Received: by 2002:a05:6000:2307:b0:42b:3bc4:16dc with SMTP id ffacd0b85a97d-42e0f213b9emr32166637f8f.21.1764691738817;
        Tue, 02 Dec 2025 08:08:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlWgvgyCrCdB68a/vDVtdUnY3Hzqt9cNDCyK0z8du3Hyb0hPWF5OXcMS0TvNkdQ42xNIogkQ==
X-Received: by 2002:a05:6000:2307:b0:42b:3bc4:16dc with SMTP id ffacd0b85a97d-42e0f213b9emr32166604f8f.21.1764691738387;
        Tue, 02 Dec 2025 08:08:58 -0800 (PST)
Received: from rh.redhat.com (p200300f6af35a800883b071bf1f3e4b6.dip0.t-ipconnect.de. [2003:f6:af35:a800:883b:71b:f1f3:e4b6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caa767dsm34300899f8f.38.2025.12.02.08.08.57
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
Subject: [PATCH v4 0/2] arm: add kvm-psci-version vcpu property
Date: Tue,  2 Dec 2025 17:08:51 +0100
Message-ID: <20251202160853.22560-1-sebott@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds a vcpu knob to request a specific PSCI version
from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.

The use case for this is to support migration between host kernels
that differ in their default (a.k.a. most recent) PSCI version.

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
Alternatively we could limit support to versions >=0.2 .

Changes since V3 [3]:
* changed variable name as requested by Eric
* added R-B
Changes since V2 [2]:
* fix kvm_get_psci_version() when the prop is not specified - thanks Eric!
* removed the assertion in kvm_get_psci_version() so that this also works
  with a future kernel/psci version
* added R-B
Changes since V1 [1]:
* incorporated feedback from Peter and Eric

[1] https://lore.kernel.org/kvmarm/20250911144923.24259-1-sebott@redhat.com/
[2] https://lore.kernel.org/kvmarm/20251030165905.73295-1-sebott@redhat.com/
[3] https://lore.kernel.org/kvmarm/20251112181357.38999-1-sebott@redhat.com/

Sebastian Ott (2):
  target/arm/kvm: add constants for new PSCI versions
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm-consts.h          |  2 +
 target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
 4 files changed, 76 insertions(+), 1 deletion(-)

-- 
2.42.0


