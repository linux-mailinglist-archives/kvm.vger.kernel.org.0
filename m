Return-Path: <kvm+bounces-70857-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GEz8NbegjGmPrgAAu9opvQ
	(envelope-from <kvm+bounces-70857-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:31:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 576D1125AE7
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B0E4830071C3
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AD842FFF87;
	Wed, 11 Feb 2026 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oq7vCW/r";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hbzmrkWs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E5920299B
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770823859; cv=none; b=eYceNL5+UmyeDSRApWAK1fKQROUZYhKNCCoaFWvvtgbtyemiItS8o332yct/ZTuKnMMuRZjA8nQ2w6TQGj/xm/fhzQ9LG/oDgFzgaC9ydr0HseTf9tpPn6lLcEuiwyOPufNR7jFVDWipPKge12Q48lNXrqAMwAeJaDrZ5SleAYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770823859; c=relaxed/simple;
	bh=bAROrVJ8MKepFtr2O0oRZmslbw+3MGUWWagMBNa6Q2g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=idgYmor4O1m7XJTDhL12/+Xz2b0/ydsUpB61VPHpJ9gI2rzp5zK9qbBx+c2B2aZ8zAPyBfmOa3H/sJW4irZ4XHmQHND3QYvxuEpPP+R9flRlkXyvAz+BcWHKUCJIV8FgljpcP30+QMt7o0l2xe1Bbbomw5ROSSkVrC2mIcJ0NfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oq7vCW/r; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hbzmrkWs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770823857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x2E0s+P8sKjuC6cwmuu4hJ5r1IkHeeGVxzBUO13i7RU=;
	b=Oq7vCW/riMGw9NIyUpKT/3MONBalnnTLY1v0uh0/TeMkwxxSBGyXzNA6D7lnnHpSShu0qM
	AIoimlEZ85theuWN7+/9TXi2pnb7wYaIxJxzgdrGCtYqOzBVxbjFOIEpSeL/QpG4xoCIMy
	4Wvrkmafi8tj5BJjCt0q1HgspDE/Gj8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-wiizYaPXOoe5UiXMak05ig-1; Wed, 11 Feb 2026 10:30:56 -0500
X-MC-Unique: wiizYaPXOoe5UiXMak05ig-1
X-Mimecast-MFC-AGG-ID: wiizYaPXOoe5UiXMak05ig_1770823854
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43591aacca2so1696791f8f.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 07:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770823854; x=1771428654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=x2E0s+P8sKjuC6cwmuu4hJ5r1IkHeeGVxzBUO13i7RU=;
        b=hbzmrkWsV7VIPtOFvP6zwaoxGaKgS1G/dRXIR3KBeUkwBLWDhHHkhS2BNDQxOTi1Wd
         oaz9sgfXCunorQmQsMbtsU26qecOArWPycqVH6t5nYp0TP5ye9hWNdlZFCe3Vac71mrO
         kfbYFOghKoB04Ae/mzYDlBII1qK6UhbL7sRz1SfJEX9qPYO+Wjr03yaIyETMmGZpitTe
         ZOJXO1jtjC8JST/6xDajP1uiZRXzl+7ylfJHUQb8RFsRbA0IQe61jpu1F2LkKaV4qisI
         ietJqnYBQzvktbMn35sce7v8LCsf/+2AnEIw+9Ef0yI3d99S6qsTRurQAa5Na+CVd4Pb
         CJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770823854; x=1771428654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x2E0s+P8sKjuC6cwmuu4hJ5r1IkHeeGVxzBUO13i7RU=;
        b=YGSPyMpT04/obqwfvaULPYpTFbDPwTJvKBCDZx3wXNtBknAfEcxyn77ePShHWP46Qo
         7z0cqNWCnVIj5vk3GKmhf7GUsx9tSjdIWVHjTXU+MoWxQgEXFhhEoq0t91TIrzRMt+t8
         gGpQ86VAxZ5F9eHTMWOPGiRkx/d2Mfw0+AlCrCnOWwkDaozgMpiw5iUZtmuG9jftOQ4f
         lU/r7B2T9z4L63SCnPpLGTnl3FYa45jOttVCgwYtODKVRU621DFOPUrjtqrxYK/6lZMf
         hy+OBHzgFYTJSSdYCcJCwZrx6vZ503Fmag2VUOadfmLIqbFqRsKuU5dDctk4EnNHRE2a
         zSGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBKA8U/SuvCwXMO6cVj4oqUyKt5TC109wgWAMd+N8gZTtkfTAlo3FxtE1drwpHfcm3foI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzkFdhTy6EwR6mEAIFIeXYOyXh96K2NxBSVZaMrmk9pS6ZVprv
	iq8VgZ6tIHVMQvzMhieJfw51P0Wj4rWovJZOtBFTdhvjlYbveEm/U7AoVSFJAoRPclB+mNr4trr
	nONAvM1H013FN2hWHQ4jBzm6+8AjHL4ZCoQFZHPiRjwvmpEObxrHSgg==
X-Gm-Gg: AZuq6aL0PIasG/IsKwfniKlO3Z4UKt/4mcIIH7yt2e8wvYwFcyQSDNZYPuwc5nLfUWn
	8dGWCxeONTrMi7NIkc8fhH+T+O0EU03X5lBMwODr3TwA+gJj+h47+Vo6kuXDWiP3DKfwsW3Pk6G
	qjbxEpZf8Uw78R0LHyPGpQEJ4eVatLHQVELP3AadoeOo2Rjy00eZQ76L4wo49wZ3Skk/zfqgOLo
	5AwzcQ/In85v/Hc0dyiF7kWHDzWfTBVW4p+3oygga/lgRZTB3cg656F2PTYfrd0VgbZ1kJmFatz
	sDj4sX61t8ddfkor/EB3Wxi72+SMZYdpN2jS2/aLiFeRhWTsrfi1swaXyJmbAAjIQJsB25LpYhk
	g0mP9m399JDPVXM75THZnth03jhu0WAFowsrb2wYC3ZzHlVIhhnwquKuChgY+l6oMfwatPYbRBc
	7tD1QQdqlg
X-Received: by 2002:a05:6000:420c:b0:437:a49:137d with SMTP id ffacd0b85a97d-4370a49155bmr20114270f8f.21.1770823853639;
        Wed, 11 Feb 2026 07:30:53 -0800 (PST)
X-Received: by 2002:a05:6000:420c:b0:437:a49:137d with SMTP id ffacd0b85a97d-4370a49155bmr20114220f8f.21.1770823853091;
        Wed, 11 Feb 2026 07:30:53 -0800 (PST)
Received: from rh.fritz.box (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783d34657sm6448511f8f.6.2026.02.11.07.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 07:30:52 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v5 0/2] arm: add kvm-psci-version vcpu property
Date: Wed, 11 Feb 2026 16:30:30 +0100
Message-ID: <20260211153032.19327-1-sebott@redhat.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70857-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sebott@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 576D1125AE7
X-Rspamd-Action: no action

This series adds a vcpu knob to request a specific PSCI version
from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.

The use case for this is to support migration between host kernels
that differ in their default (a.k.a. most recent) PSCI version.

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
Alternatively we could limit support to versions >=0.2 .

Changes since V4 [4]:
* incorporated feedback from Peter
* added R-B, T-B
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
[4] https://lore.kernel.org/kvmarm/20251202160853.22560-1-sebott@redhat.com/

Sebastian Ott (2):
  target/arm/kvm: add constants for new PSCI versions
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst | 11 ++++++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm-consts.h          |  2 +
 target/arm/kvm.c                 | 65 +++++++++++++++++++++++++++++++-
 4 files changed, 83 insertions(+), 1 deletion(-)

-- 
2.52.0


