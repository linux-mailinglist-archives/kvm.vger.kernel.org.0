Return-Path: <kvm+bounces-69994-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBJTDTDkgWmDLQMAu9opvQ
	(envelope-from <kvm+bounces-69994-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:04:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49DF7D8BBA
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:03:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C22DB3008C8A
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 12:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B2F33D502;
	Tue,  3 Feb 2026 12:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eNQ9YyGm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3BD313546
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 12:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770120233; cv=none; b=pNKvt2uvqIPAiNFIcpHuPRtKCiyXBIKyNXD6OEXxZjRXBgOnB/mE2c1up1pHxkVKFhsDz7NtrSQXKHMxRprZkjna8Z2xJMGWjZccrep1AmTVyUv+taij2q978JDNNFXjrqRZmg8zEoRH7b8XPdnRM4zrV+6cINgme7jk1yPc+7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770120233; c=relaxed/simple;
	bh=sWPvwkIb6HJFsCfdpPfRQbqOzSRIPVlnwZZVmzZTgY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzY3Sinfv4wmMDX53mmj9jErBAuhoh5fZAzjc8D4svNquRo+SP1qzrfMyRNCwlkKvKg4EAGVSdvGdnGSsA3Y0gZUqa1hCIDicCSXrWsDAu84aCKsc9u63ZKThyU6gV6nLyAowX/Wb1bR0w97Z542IDhNC8RYP1QglUueMJHO94k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eNQ9YyGm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770120231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=50eLgHjC/pRtKcjo/0ngsF0jANwn8Iv9jNM2r9PWzZQ=;
	b=eNQ9YyGmZyehmDDG7pI56L/hjqocm4IKSS+LLajcKcxUcG0aCFtQ7SSeGuZajD53/znwAN
	juFCAm8tgVQ0QxGvbjbTimYH/aEqELD9QEersJZrTYkOIc47BI5r3fTcCKSLxjJGtuNpe4
	hYTMcvnDqDbwgBRWid92h+EM9qEZ2Ho=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-CzjAfwm1MqCbnoxzsYSuWw-1; Tue,
 03 Feb 2026 07:03:48 -0500
X-MC-Unique: CzjAfwm1MqCbnoxzsYSuWw-1
X-Mimecast-MFC-AGG-ID: CzjAfwm1MqCbnoxzsYSuWw_1770120226
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD98F1954B0B;
	Tue,  3 Feb 2026 12:03:46 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.34.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D31E19560B2;
	Tue,  3 Feb 2026 12:03:45 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 7828718003B5; Tue, 03 Feb 2026 13:03:43 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ani Sinha <anisinha@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	Jim MacArthur <jim.macarthur@linaro.org>,
	Luigi Leonardi <leonardi@redhat.com>
Subject: [PULL 01/17] docs/system/igvm.rst: Update external links
Date: Tue,  3 Feb 2026 13:03:26 +0100
Message-ID: <20260203120343.656961-2-kraxel@redhat.com>
In-Reply-To: <20260203120343.656961-1-kraxel@redhat.com>
References: <20260203120343.656961-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69994-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kraxel@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,gitlab.com:url,amd.com:url];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 49DF7D8BBA
X-Rspamd-Action: no action

From: Jim MacArthur <jim.macarthur@linaro.org>

* Fixes link to AMD64 Architecture Programmer's
Manual and bumps version to 3.43.
* Updates link to buildigvm to new home on GitLab.

Resolves: https://gitlab.com/qemu-project/qemu/-/issues/3247
Signed-off-by: Jim MacArthur <jim.macarthur@linaro.org>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Message-ID: <20260119-igvm-documentation-fix-v2-1-b2f6174e3f4f@linaro.org>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 docs/system/igvm.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/docs/system/igvm.rst b/docs/system/igvm.rst
index 79508d958802..9db8ae43d21d 100644
--- a/docs/system/igvm.rst
+++ b/docs/system/igvm.rst
@@ -166,8 +166,8 @@ References
 ----------
 
 [1] AMD64 Architecture Programmer's Manual, Volume 2: System Programming
-  Rev 3.41
-  https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24593.pdf
+  Rev 3.43
+  https://docs.amd.com/v/u/en-US/24593_3.43
 
 [2] ``buildigvm`` - A tool to build example IGVM files containing OVMF firmware
-  https://github.com/roy-hopkins/buildigvm
\ No newline at end of file
+  https://gitlab.com/qemu-project/buildigvm
-- 
2.52.0


