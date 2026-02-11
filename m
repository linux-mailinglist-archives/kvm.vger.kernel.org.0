Return-Path: <kvm+bounces-70858-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oCiNDsqgjGmPrgAAu9opvQ
	(envelope-from <kvm+bounces-70858-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:31:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A8E97125AF5
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:31:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 46D31301C6F0
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 701DD2FFF9B;
	Wed, 11 Feb 2026 15:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ML4Bygmd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iYrYMTLW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B563EBF3D
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770823863; cv=none; b=Uno5tCEj8QuHsyjJVdBsXheHcd2ns7+9fWj9EVnHRJM5CjhA+aSE2HKbZqOmv2e4A9/wAhDX0sj+KwEp9ENnZupchus6rvYUrw7lqWjkyJkYwa5kkj8fvHeyUFUpwbqjriZjWiUSyocX6AYs8EGkUdoSjV89c4Ba/t4P+5mTF5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770823863; c=relaxed/simple;
	bh=rB75pWAx4bl2HPDkD1L2il0Zdqnq2SU6NSMuJUFdWS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X51u5r0JNzfjEoJ8C5iNZ3kEYF9kzH1LMHTzcWqKCELWnMnXLj99m55LnjLATJpmVOe6TbUNbIpmVJ1Ot5M99iATzq2ds0ZmlutD3zdjdEEQTdrtFo1+u+SUGR028tkc6LkcElDJhUWEvrXA9gfURf68ieQvkP2mVq72HVRAmmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ML4Bygmd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iYrYMTLW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770823861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4uMBqfdZsQbe7YIFKz45QFjnUCRjbkXzgrDvDI+qPJ8=;
	b=ML4BygmdBp7iX8wOsQ3F6MHrutvG2CphHLe2TjV8hPJSLbGe7WfPx/A7mCaxndDREzpXyS
	QlSvB7a8kYq22wXXttK5583xlCc8O7nAnttxVwu/80KzOcpvg3QEtAuO8sGqVoD8JpXsM5
	n47FEw4UwUCSiPxaUR0nvIkLJdL3/PE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-ViWpyp7tMnu6mdwXZe8vBA-1; Wed, 11 Feb 2026 10:31:00 -0500
X-MC-Unique: ViWpyp7tMnu6mdwXZe8vBA-1
X-Mimecast-MFC-AGG-ID: ViWpyp7tMnu6mdwXZe8vBA_1770823859
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47ee056e5cfso61402025e9.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 07:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770823859; x=1771428659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4uMBqfdZsQbe7YIFKz45QFjnUCRjbkXzgrDvDI+qPJ8=;
        b=iYrYMTLWP3KUJJNgLNkcwiVNPUESo4WkYx4mlUDR/ELwTBwmZFwSgMDcbFE0Mg8b9k
         ET8VQf2o1/hRRG/iC23Crd7qm05oqi+ODUH39PcHBT8RCz7V+eJE2fIP4aZCGL2MKG0w
         ytq/sY1Amw625ZdrpAVAEijPFKvIdStpEgR+WUjX9na+dtt1r/eRYv50k63zbU7Xi+b+
         7/iG3GQDD5JdiF0xH6f3d7WcJ9yXROEXHBpzDnE7WPX8FWXKmpKO7GwgngSBG23WhQ+K
         6KlVssmYDvcU1VOG6tpzeVY7NqnzyGaSPbppmBGSFVk2QnRlMzQncmcHpBi8GOXRN57t
         eqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770823859; x=1771428659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4uMBqfdZsQbe7YIFKz45QFjnUCRjbkXzgrDvDI+qPJ8=;
        b=llq5Sdrq3CZbO/xMCoJFYqlCBI91MFr45aSSU9Uo26qJKlBldnBPfARQUxBAqzwqoE
         h/t/DZ8oG9DOepe7jvl2MjQs81EompMg1NjuCnRn/rREWP7RvPV1gmOjoKPOi8GCOjeW
         lAefXe882jW5vsQAB+fBrJZ84N+2lLIMuCNvS/Oxx7o0xbmthv6wCCjG4vpzlG8J0hJN
         Pwa27wsTyt+VGoa2vhs+wETlSu1KPqjtnVu6/2fRlwI8YCotW1X2UuKx6WKEGy2uuiww
         Lp7So9D/i000m51C7tHBsDIbONGj4dpG8xmzK74wUifXlgdKw7sVGeHqGds7qptNR/NU
         FfnA==
X-Forwarded-Encrypted: i=1; AJvYcCW1obS/tvQ9JnYFuZ97P+j1P/u4qEHCpEptTT8oTL2Urg00/HjNgH9EDMIFbo4q10qzWnQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzorM6UkAg6nMk28hYLyxK2XJumvOqDNtRrLIHT1pstvPHPA/Iu
	FHitZReUfGIje1pCs+IsaMK+XHCIefKdaAgD85oyaBv6TkoDKVkXyZtaODJ4NqzeoxJRfzsU5+2
	YMB4hqwXGSgzy+a9ftgeNDO4Rumev2lJDUgh/4O6cYzJ+VdpSU7cdMA==
X-Gm-Gg: AZuq6aKYkFS0GrD5McjlI7+U9bomfPtTfCTcfEdVCKDXQSdQ4njlBThaSCi7TX2l8lu
	vALI6TAfhdES3zX4AjmStpCJc2Jve3bHFH7vGs/kVPeMfq4BzXw8w23TFRrL9QiYO7V0yvEKiHI
	xlURiYdITpMQdlcDWzYPccgaxs8Y4UInRtmlTvgEgzNSl96LanItvgIcN0M4rHfnGbroL0Istff
	MqGEkU0QfIcoOmtDvOtLtlup5kIQPiAFC3FiXWWEKKWYyFR5QOna6/UzgDwWVCeIHIU958vITcj
	6+oxzckvv9Ce2lsbSttm6whhd8HzbjtfZHQUrV/y8sJRyE0fX0wLbioTmgcAhNAtls/PPi3+/Uv
	75cGPm75y1rZDV0VB9RJJVBPST/fPSKvV89Iv7jTnItpPJ2NiZIoGS3wsWtFzC2Of/XNESfVaJ2
	3FcqdItNS/
X-Received: by 2002:a05:600c:46cb:b0:483:ea6:8767 with SMTP id 5b1f17b1804b1-4835e2cd408mr35512055e9.36.1770823858847;
        Wed, 11 Feb 2026 07:30:58 -0800 (PST)
X-Received: by 2002:a05:600c:46cb:b0:483:ea6:8767 with SMTP id 5b1f17b1804b1-4835e2cd408mr35511455e9.36.1770823858114;
        Wed, 11 Feb 2026 07:30:58 -0800 (PST)
Received: from rh.fritz.box (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783d34657sm6448511f8f.6.2026.02.11.07.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 07:30:57 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	Stefan Weil <sw@weilnetz.de>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 1/2] target/arm/kvm: add constants for new PSCI versions
Date: Wed, 11 Feb 2026 16:30:31 +0100
Message-ID: <20260211153032.19327-2-sebott@redhat.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260211153032.19327-1-sebott@redhat.com>
References: <20260211153032.19327-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70858-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sebott@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A8E97125AF5
X-Rspamd-Action: no action

Add constants for PSCI version 1_2 and 1_3.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Stefan Weil <sw@weilnetz.de>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Sebastian Ott <sebott@redhat.com>
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
2.52.0


