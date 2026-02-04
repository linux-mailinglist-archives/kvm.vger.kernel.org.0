Return-Path: <kvm+bounces-70265-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AIiJFiWYg2lxpwMAu9opvQ
	(envelope-from <kvm+bounces-70265-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 20:04:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD6DBEBD61
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 20:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4B66C3007513
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 19:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20043427A18;
	Wed,  4 Feb 2026 19:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ftg3QrPa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ngKkEg4V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0D02367B5
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 19:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770231839; cv=none; b=NESPCVxzKCrrpAELR9F4gI3ZdBjKfdogtSKyHABspK9RnUOnHhUM5Uwd4VGSqTEuOI18W1wpQuKn9esIPr1/0ZUUD3nWLmDaIVZT6MniEKCM87iq4EOnlF62TXEMU6LIGTRLSNp1YZVZAgqQ3aVOovFJo3i+JxS6/0ptcZTCxxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770231839; c=relaxed/simple;
	bh=p1/8tRPDBRxjaZ/FYRPf1N/r6QoZibLt8wE30YSDp7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrVpRAphUeTbEC8JpnF2iIalwxOq68ZNNsne4sf5pVDdlCmtPa3KNBlQNpTb8ntt3Twkqe0v3kZuY+rgh/Uw9LdAyQmRv4iUjHJx6lIjRKEekdGq83CrkAjioWB3oO9FC75ElbZeGvvbBIoLouAsZiQPC3gUyyU0TtAnnuZ1GLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ftg3QrPa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ngKkEg4V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770231838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pDLl0CipBDb5NTwlLQHww8+blGdI/WR9oxHWsPKmF9s=;
	b=ftg3QrPaXVNc76sM+ow0Ap0aXXe6fmnFtpxC18fwRe3C33YaSLrIy3xJVNUreFEokr5Vg5
	N92eSJw7skaiVnhYrPyr15QwLX+Tqtra2/w6xoXB+7yOwxqIzuU4e9yxvz24fNj2ivfDkN
	MN4QiOjZKXpo1TJ1hHg8vA554W3rxss=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-ApYZh5WJP_SdY-hZgSgNrg-1; Wed, 04 Feb 2026 14:03:56 -0500
X-MC-Unique: ApYZh5WJP_SdY-hZgSgNrg-1
X-Mimecast-MFC-AGG-ID: ApYZh5WJP_SdY-hZgSgNrg_1770231835
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4830e7c6131so1252855e9.2
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 11:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770231835; x=1770836635; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pDLl0CipBDb5NTwlLQHww8+blGdI/WR9oxHWsPKmF9s=;
        b=ngKkEg4VDSwGyrVdWIzvf94advzwiE7Bzr7OwXxS/nHoWwLlpDZ9jq9S+hRys4MgOP
         kBDLvX3yx1ghUg7cbWUN5o0ZEosjwLlCrwr551g5H88jh8MZk18S+/o9adDff611BI+T
         mbRBIu5Sd5RNqlevr73L9Tl2nK8XNxhXUrCDJ81lwDZd0hzv3XWw0YJkzS4XGwSkp2z7
         yqNl/6+xfeYIEZnlrUHMo+P2N6yNYGnH63mdDPAtr84RBCIYY3/VRSl7DnnGyExhq1dj
         fi1wz7MLYVtndm3dxWtLPmYdkmyk9S2kHurPptaWsEcb27LkvwozuNeEbnTUYFPsGtwf
         77rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770231835; x=1770836635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pDLl0CipBDb5NTwlLQHww8+blGdI/WR9oxHWsPKmF9s=;
        b=wvMmztGbsfRxIQAuWwIBK4HDVjfqWm3ZWyws8TyVfsCSQYYcQQF6C4FvfiuZBhPZiM
         Mvz5paza1QQsF4JZnq6YOoIIwsxeK7gxjtV7WGtqIbzrXmeW7Mc4Knm4lGuaTVpofWMU
         jZReBCVgHdTaPcMARXO3ngr3cdUZ1/bdqFnOleWrEFwTZEzRfgM0vbPu8aWy+su8Y525
         j4kXp25+OdKy9GRQf+9KrFaNCZzyDUMPvZkz5H3fzf8X9FAvWIGs7Uw/cO7UEsN+fouj
         12W8f5yM26t/YF2cgXZWROmueT4QSYuoEovGaOtxSyIZMCsVbQm+vhr1juxyUQZW3ScF
         uK/Q==
X-Forwarded-Encrypted: i=1; AJvYcCURbj9RueiIVeUI5pCjxm4r2fP0alkLizm5R3G0Jyxh9uL2zR4SuWFfCgBSJZX4rKvCFKk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy65gB6qyh8tM9MdbTkz7ZdrB/airVf3G+aV9Ga50BMKk0F1Pn7
	f64nub/AgpkqPTnaZV2SqHjJUqTBLrsIApz6Rdu0xYz9AGrrbAWjyXsQ3Miiqs03RMOmB5O3V00
	wnaq+GnD2h/0XQUS7OuED13qhCay2iT1XO6j1S17kGjTrLMdQIIZmbQ==
X-Gm-Gg: AZuq6aLlBnBTrYJL/crpfpVNLH/DINey6eYfXBLdfuFOYPFZ4m4Oo4+U4kVl5nxRqF9
	Ri6jElQGygdFI0uynKhY137yLkCN/WkhLn5vvtY8fG1Xaft69Lw8F6pcGCr6NV5AO0sV/v9AZft
	4qVUQBifhn6K7P9CFjKUp3L7kEJrENiqfV7KOS7LO/qsr9TArGB8Pw0JrOs6qqlAWgUx/xZe2Nm
	REnpxbmXeLjOpka748Bg9IRBWry7L3ClRSqaJa8ueTgzsCyEvNTX2V5AQoJWjh4VLQ5NyvZGuZe
	7mjqGq5SvfrnjJarynPIsBgMiTVjMQvjpTN0WgBcoYRzAlwMlLaoroN89WUMduoYd2zeje9s2Q7
	5O7SNBgnLuCkoqOma8tMTmKPeeKxVRfjUBw==
X-Received: by 2002:a05:600c:6087:b0:483:a21:7744 with SMTP id 5b1f17b1804b1-4830e977f1cmr52879815e9.26.1770231835314;
        Wed, 04 Feb 2026 11:03:55 -0800 (PST)
X-Received: by 2002:a05:600c:6087:b0:483:a21:7744 with SMTP id 5b1f17b1804b1-4830e977f1cmr52879395e9.26.1770231834923;
        Wed, 04 Feb 2026 11:03:54 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4361805fec6sm7965375f8f.32.2026.02.04.11.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 11:03:54 -0800 (PST)
Date: Wed, 4 Feb 2026 14:03:52 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Gavin Shan <gshan@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
	kvm@vger.kernel.org
Subject: [PULL 28/51] target/arm/kvm: Exit on error from
 acpi_ghes_memory_errors()
Message-ID: <afabd70d34547ea812cf2094917cef83dae85843.1770231744.git.mst@redhat.com>
References: <cover.1770231744.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1770231744.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-70265-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm,huawei];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DD6DBEBD61
X-Rspamd-Action: no action

From: Gavin Shan <gshan@redhat.com>

A core dump is no sense as there isn't programming bugs related to
errors from acpi_ghes_memory_errors().

Exit instead of abort when the function returns errors, and the
excessive error message is also dropped.

Suggested-by: Igor Mammedov <imammedo@redhat.com>
Suggested-by: Markus Armbruster <armbru@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20251201141803.2386129-4-gshan@redhat.com>
---
 target/arm/kvm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 0828e8b87b..b83f1d5e4f 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2477,8 +2477,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
                                              paddr)) {
                     kvm_inject_arm_sea(c);
                 } else {
-                    error_report("failed to record the error");
-                    abort();
+                    exit(1);
                 }
             }
             return;
-- 
MST


