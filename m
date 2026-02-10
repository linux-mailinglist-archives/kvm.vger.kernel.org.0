Return-Path: <kvm+bounces-70791-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QCl5MTGSi2n/WAAAu9opvQ
	(envelope-from <kvm+bounces-70791-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4137A11EF71
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F3A4D306CF72
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0BAC3321B0;
	Tue, 10 Feb 2026 20:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oIMxsuQ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC83E32E745
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754553; cv=none; b=qbFOLIx7lKCjst3BnyWmO++qB9le27dnIW4Dg1ugAAlLc393Q+XEwjuBc1Dfu91wSqmb2rCjCcgLMmM0ygZF4h5vJYTWfFERqT/wO9pPJxbiTXw42lfvrXAIPd8KsgUJSA6YrXh/ty/SS9gN8vWF1spmzx2qxK2k1M76c20+W5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754553; c=relaxed/simple;
	bh=tT/CuCsRSc2uOTz4AKCkWxc+wP8cAH7QNfgKlYH8ZhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3YPYhMxOsd8yln/U5J/KKQnxpOnlqmv1WuPlxMYamuy461ND917mxmaOMu3k2TkLY9qnU5t02f5XlTUotG2r1ZRuOmS5djwF2MvdxAyFLGSfKR66ahD1LN4QtsnL50sa7H7YxeYqBpPK7e//CmWzVDtDtOWpJXVJwG4RZhoDVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oIMxsuQ3; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8220bd582ddso870643b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754552; x=1771359352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GM4hRM+kWCtJL3aHlm91z/yjeKpryvOkWyfDNo2+duQ=;
        b=oIMxsuQ311Gu1TgEPDdMA6qrDw72VmuGp36nfkWMHKFIRdunMxNGFqiWj/3mOglK3Z
         gokyytPnLd7Vnw4uDiT0G/3yGWSQeqzwPjGurAoZWjXDiQV0xpGhkHASzHlQFHJByE48
         FES115pOLOpZPQiFKD0t6sEfcXHipazJeb+aFdDWA1AA/8Bnxu9JjHJjzrITtlMI4Ewj
         fMV1BIMJbeVsbNKYxlUTgJv8KRT4sZ+MVTPQ+FU7Mo28VifWh4L2bSNa9QOXI2TwcVaa
         UUiA1f6MJuwvXr7TFlBjNmRcx/vTCNCnIAAtGYapmO1scF8DvNG2r28e3hBf9H1AhT1F
         22gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754552; x=1771359352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GM4hRM+kWCtJL3aHlm91z/yjeKpryvOkWyfDNo2+duQ=;
        b=kRvcQinrjtb17ue02KBnluK0/rJ/X3JCiLICqa1FZSGe1eEG7R1g5oOrrvUD8VUQQG
         iLl0o7wa+L3laTkAtupDSrl3NcTRwNyGJ+aTyZEr4kP7FMy8p9zfQze2h0YvEriqNXaU
         THeB2mC5tRjB7ythwjXM5NhxQOR3HXNZ07dzRrJFob82qOHSxI7K2mVxrS/Hv1e6/og4
         sXtIp3znATD6agvgFQPz4V1umzVl3v68zOMcw+DleZ/nnSu2FJsVWCRs5JXqJ1xDBrNg
         xlrasqp17yh0tlTLFfWZS+mKHqKmmTldQYIr4Y2ONPoa2vi/5YY7X6uQoTGEs6w31vc6
         zKmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFEnsNAggm+OvDYIAw4Pf4WROLbz/tZa9CCpKLx3isvuX17Lzkfyo4ugRF4rq74t79SZI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8n8ncR8cHdnCecG3qBiiUu3i4227qJ9AxxCzb7rFy56s6Y7Df
	R5P1ccGeop/Jaef1+spvGoT9dgJpPOsuSQdMHTIYUM9xcp44p1zR+Uc5p49xLC1NlBY=
X-Gm-Gg: AZuq6aIJEn2RDjZDgJpA/dU9k2Dl43R2n+5bG/8QL0UFb3QK6qssyZ+baBNqrqgmhQm
	AX4KONzrSr/NRADG60r3KASXz/hxQ44JatJDjDvfCsy1UNKkXoD7ZTguUnpnSteDgVrnZ+0UgaB
	1N/mRI4VTN7434Pj+GzO3FOrb00SSdzxfJQe0uprqJfgD5zAAOzZB4H7zq90dZfsmsqDqdO52+3
	o9pdd8d9+cE4oafiGyILvSxVoNhwD+Pz94/uETlujGhQ0R5olJSRnvxKC0zcnUwoZHCLw2qFPZn
	7Z4wey7IzMtDUaXQwbfXNrgNgdsSMNYIl55Q3Qe8ZFFXer07AyvDLZRjH3aSDlmVquJmog7TDRR
	xl7FU+KwrCBzAkjuk7uPxKmbAaE0aXcNdlVoIlG+JSLVxQh1oIxRFFVRF2gcjynOJ0SfOeNyzzB
	O/GjzQ3hVEJgfNBiKxUPszW7BAw2lmQmcXQ9xDEFIJy+KrktlHS0kQxP+MZe8Z9K0sr9eVXLuy4
	l06
X-Received: by 2002:a05:6a21:6e4b:b0:38d:f8e6:fc62 with SMTP id adf61e73a8af0-393ad374010mr15253847637.61.1770754552010;
        Tue, 10 Feb 2026 12:15:52 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab0b392cb5sm38523225ad.70.2026.02.10.12.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 12:15:51 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Jim MacArthur <jim.macarthur@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 08/12] target/arm/tcg/cpu-v7m.c: make compilation unit common
Date: Tue, 10 Feb 2026 12:15:36 -0800
Message-ID: <20260210201540.1405424-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
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
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70791-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: 4137A11EF71
X-Rspamd-Action: no action

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 144a8cd9474..08ac5ec9906 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -49,7 +49,7 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'sve_helper.c',
 ))
 
-arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
+arm_common_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 
 arm_common_ss.add(zlib)
-- 
2.47.3


