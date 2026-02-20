Return-Path: <kvm+bounces-71405-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gNp4OxxMmGmaFgMAu9opvQ
	(envelope-from <kvm+bounces-71405-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 12:57:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE62167606
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 12:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8A762303A25C
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 11:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC96340A7D;
	Fri, 20 Feb 2026 11:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dhYNhJal";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tywzrQ56"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D160330657
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 11:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771588626; cv=none; b=W4RiN5w97zgzJkER7wVT+c/+n/incpNVuiB+xf4bqA0dfodMPYtv0i4C8XGTVv94n5Z2g6kHTpBpLfj8o5YyrSBJnhCeNXN3OAy4OsUWG7ZC38s5wm2GlmK6nK54yHBuCIdnXtAe0EY7CT2blZxL02sTvobrCvNkldW6s1+ftso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771588626; c=relaxed/simple;
	bh=LznsEf5nGtAtKYbhk+cxdbpZw1ShTWQcE+HR8zkXmEE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Uujqshs5Vrq1m4Whwh9ngexXWy7phqEpimlxWpnbu7VxD5okV3tk5uWbHe7wZNV6jXxGDdN052I7LQgHDcp7J1JeMXGcLXiFKCm9VrM27azXfC1YSarNNtIf98+NFWoC+O4xUb4wjbr3iTGiCdHGCLNeleo+NzrJx/3RRT8ZNdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dhYNhJal; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tywzrQ56; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771588623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=f9Iq3P1+3CvjmPUgtUDKxrjal3kc2Xn/2NZQuVratlc=;
	b=dhYNhJaluRnpgzMyCZezjlqthdF0MBZkFLUHDqVG9QW5SSRfUD3Al7cCOUvQXc+0MslHwJ
	X8D0wE4A3njO+Oo1rPfRDNWUsXRnAeHSeswmfd8BLNeBuf2Ibh2czn2z3pv0PCe6kltZdx
	mlISc1dJpu5E2rIB2U8LbNPgA3KXIrE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-GqN2EzCoOf-nBXUXlYPlIQ-1; Fri, 20 Feb 2026 06:57:01 -0500
X-MC-Unique: GqN2EzCoOf-nBXUXlYPlIQ-1
X-Mimecast-MFC-AGG-ID: GqN2EzCoOf-nBXUXlYPlIQ_1771588620
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-483101623e9so17577055e9.3
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 03:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771588620; x=1772193420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f9Iq3P1+3CvjmPUgtUDKxrjal3kc2Xn/2NZQuVratlc=;
        b=tywzrQ563phg7zRPddIASK4XnjAClDnOjA/Wh8v/bJSFU3MjqeiTKR5FzVA5ZOKqAI
         loYKibM58HdP0fIzetDcZJ/LKoPWwFeD0rqKAhdIuILluS0L3Fe/0EjPGypsTd2k09HJ
         KMYUinH4gEc8LerxI3cKnDye472rQucevaeB9hAkjhn+xftW4hLM9uQk/Ew3jWLSi6Wd
         tK+sqFckjS91A7MfSqoRSc1nizRXkEtc/ieRkldJfUfUim2TRkfLPdoLHjSM8UvreO86
         Bpt602I27STymTVBDzbjeRR7DQeL1y5t2s6ngaI0d5+qK8nsAiGW+04BdCKC2EPRENFu
         nIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771588620; x=1772193420;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9Iq3P1+3CvjmPUgtUDKxrjal3kc2Xn/2NZQuVratlc=;
        b=rSv3Xx9DUIbXHpKdhUM9Nj793vzkuT6xoM8/14ZVvUZmjjhG60Bm84+ueNgMSLMI6b
         d7qcPAAMzBDxA8FkhXswuL3jCyTLRLnyDSCcQjDf8ZaG/1pFTz2VXeIEHY3UjK23Lze7
         8+EC+VWLMvxHQIYLeQC/y542b+MrvbX8G09ZJNmcOib+gRIs6SUpyh601peR3dSmq7EX
         hml/IkukoWeVrtRkt53NBgc/HWnh49ymzTKlxFjXy8N0/+WlUyb848ddGPoAcOyicF1V
         tFY+SIOOmGBm72C0vx7q3gjcb5GatzLOcTEOx1ETFSzM1yBdOv/DMMlvlXYtkGS76L0s
         y/Ww==
X-Forwarded-Encrypted: i=1; AJvYcCXPfO6LtsTlG03Gpm2nlX/5/vKButAVHYOZZG7hAhB66G9qqKwQX0MkmJIsrIeuC3GraQU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDTm8mqrPLpDD182NSkoRGY91dfpLs6GapYXoSkt8xanl84Bjd
	enCA3wKjaEdrBclPPhSAs12myCYasYyJBI/P9qdSA/z27cLCTVTbBhjjqjQ/ilBTIht3TQE/aqN
	catag6ZYp9dBZAUEvpRVlJvFqurMIuJcMc5zt0tIETK+qG7qHtrnsxg==
X-Gm-Gg: AZuq6aI27ia5T7Ic7tyGoQ3aZpwsF1p4qyw3Sy4c1Ut9iLAgmMAOEpYm5yrCqeYOiVs
	0H5jKADl1YTOkTRp/Z2Rs39Fv0b17hPIW9Q5+yuLEf9LNc+XEKOlvzuZx7De3fmnFTEi9U6Wq5W
	deqDDrW9OKF21zBmCdGaG9cTVqY7ClkgI89scMPlpX0kitsMUhtzTtWIp5R2NmVHHuuqs/w/t0W
	bSSoeccqAAMjqQ393MA4YevBWOaAhLNrh/gh3PJTzrEPAkh4NJ1EQunsxLjM5PJ4paOqCx3/HSS
	T/L4Sb1PfaIhbFUs3EMt7zXWNk0TAGyHXFAzpJ4E7+Kc2Pi5fq+qER56NJbfC+j59a9+kitgXrn
	O2D08+PzwiL6ukEuHylxno92kOrR9EqZ//UWBq2RyI/67ngOtNtdT0BxUdRp7tsN1QL+m6co5zg
	3ih9ewM89T
X-Received: by 2002:a05:600c:4fd5:b0:477:9fcf:3fe3 with SMTP id 5b1f17b1804b1-483989ca4e4mr142430095e9.0.1771588620371;
        Fri, 20 Feb 2026 03:57:00 -0800 (PST)
X-Received: by 2002:a05:600c:4fd5:b0:477:9fcf:3fe3 with SMTP id 5b1f17b1804b1-483989ca4e4mr142429585e9.0.1771588619823;
        Fri, 20 Feb 2026 03:56:59 -0800 (PST)
Received: from rh.fritz.box (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a316c2aasm66102295e9.0.2026.02.20.03.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 03:56:59 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: peter.maydell@linaro.org,
	qemu-devel@nongnu.org
Cc: eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	pbonzini@redhat.com,
	qemu-arm@nongnu.org,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v6 0/1] arm: add kvm-psci-version vcpu property
Date: Fri, 20 Feb 2026 12:56:55 +0100
Message-ID: <20260220115656.4831-1-sebott@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71405-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sebott@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5EE62167606
X-Rspamd-Action: no action

This series adds a vcpu knob to request a specific PSCI version
from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.

The use case for this is to support migration between host kernels
that differ in their default (a.k.a. most recent) PSCI version.

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
Alternatively we could limit support to versions >=0.2 .

Changes since V5 [5]:
* incorporated feedback from Peter
* dropped patch that is already upstream
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
[5] https://lore.kernel.org/kvmarm/20260211153032.19327-1-sebott@redhat.com/

Sebastian Ott (1):
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst | 11 ++++++++
 target/arm/cpu.c                 |  8 +++++-
 target/arm/kvm.c                 | 48 ++++++++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 3 deletions(-)

-- 
2.52.0


