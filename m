Return-Path: <kvm+bounces-69201-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLrHAylLeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69201-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:20:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5B590121
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 646F63078CB0
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38145329384;
	Tue, 27 Jan 2026 05:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RMBg4o2S";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bW2TOlkM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16140329395
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491054; cv=none; b=iZ62c0zlkcXBv6818HiEqImmwz+ieAftf51Uah6HhnvEJFwSULd9jlO5rScwzQBGzACLVJp1Ixl5RyzvPd4p1RMnabozLS4eoq6ubPCgOciW8rUSA0ApGTIZEwzp7tFJdK3sNzTBIQQQfk4OWJvkATrR2gcKFcFqBxVc8nm3J80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491054; c=relaxed/simple;
	bh=Ope/x9pOuJXQffyTrHPXd6XF5SUYlEoBJl6EoZYTMy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rc6LZAAeNDZsqeLTvpl6bR8nqIeO8zdY9MetLfHjwkS1lTaMbu4dMq0PhVk3YF46oESqb4PUiBkS1stmiP6CziAw60zcWTOWudtXFbdTqApSyJ1RuSA7eLNn637iB8U62iu5izDoAyu3IxZ1MG4Wb9W5tShqBH4ZISq58g3Hdng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RMBg4o2S; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bW2TOlkM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j8+47Sjna5VFWbMymGn/cKww5NGQWO1KmnHktF7E5FI=;
	b=RMBg4o2Sw8MATQpMM2wO2C9/1loFhU5asMpOSVSEaQZONsBi1vPiMxbPJ5e7INzahqQM0M
	33OEuIHeEwB8dtjnYpHY0A9VfHvYBiCjBo4VR3oItiXI6U6IZpTfGgxb6/laNVo149faZI
	Nv2Wxyt5f9P9S+pxifiJswQFQIqU7qk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-jvuZ62yPPNyZ8XSHnwGkmw-1; Tue, 27 Jan 2026 00:17:30 -0500
X-MC-Unique: jvuZ62yPPNyZ8XSHnwGkmw-1
X-Mimecast-MFC-AGG-ID: jvuZ62yPPNyZ8XSHnwGkmw_1769491049
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34ac814f308so571936a91.3
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491049; x=1770095849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j8+47Sjna5VFWbMymGn/cKww5NGQWO1KmnHktF7E5FI=;
        b=bW2TOlkMkydE2dTyFx80K3sqJFFbBE3kKAplje5fPfigYxQJLjhVItSJ63oH1umHyI
         ZLqaOjgqkFfMVY/hykzJd9khoJGgD7QLN/ibN9ssmAMal3GQk8i7AMki48ALkEjMJ3jh
         2AoLV1+FqaieSH7VjiYolmzYP9SDW7XA0yyNPOW4VWpTeMN9fpNGM6KIWY61q8KkVKej
         qrO7tI89sHO3KsUZewALZCMwSSBCXm55jdCVbwBFLMN1B/dKGtfIGuKvDkYXcFABHnRo
         J/LOCtR55bPqhkOUpW0sIzn8EVq4KRY36CFSbrFxpXD/IOLI2fvXU/STuDTZiZ3Vn0Ad
         FKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491049; x=1770095849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j8+47Sjna5VFWbMymGn/cKww5NGQWO1KmnHktF7E5FI=;
        b=mZV1AFRrUf0HexZMpRhGXC41oFZl8tXB9S+6K8TW04yXgglvcAXuJE1+Dn6Y49DOyP
         uWS1bs8/MGN0AZMvPq4+R4WVixhJ7C/ApR09qeW13/piTjqXRuOvyRYGo+MWXI+6UZWj
         u3KhGHw5ub8BLJJCebrJl6CCbnLUfHv24V+mv4otm7gc+IP8eDaHLx9MweCGq1B76XMV
         +ycdXWv55ysRFxyi+UqV8va4BL6t8wLQyUmQlx+X2SahNXf/4eGiYS3xfMDD7H0qI8qK
         cvNMHAYii8GYSqBp0ZPGrII7P1JPcGdC5flp7iAzT0yUsEpxQi5pTX5dnD1zeeiRID34
         C01Q==
X-Forwarded-Encrypted: i=1; AJvYcCVxt6HojnyVUtM9V7u2Nu0X/kMcsQ269V9fb78K/wMIkwWFAQkqrbI1IS+lxupwqXBja34=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBHh3a61M20QMmk0pxAhF+HovofEa4aLQXoespt8ASRYjWkLbe
	NWI9KrAhRd1CtrjB94ozd1aRQ72fkirU/T6M8+VJcNgzqYpryoPoSDrLmYGG+w4AokxgbnWEo3W
	GxQGa2vwUq/ibDx1TGSiti3S63IACEpLMkklWRxQXQw5qDl/K73Guhw==
X-Gm-Gg: AZuq6aILIbQc3/9wL4X3pEHrVsUYpmyDK5OR+Ssp73BXM5p/NHOBdIegZj/7QCxQrAY
	an1TjSe92y1kBVcMeJNc6kzSFEM0JvfuzubfuOptkJ1YG7EbC0UDLEIIreZkiGIHLBVkvWIa0JA
	aUtOdrQEOSGPzHSL36fuNUNVOR5AxWGXUCl4z29sTZcJ1pnWMJA4obARSaKDzitSc8BxyfU199P
	8MFjJCfWRDOfspDdG3+x7VhFGN7X36lzaOTkgww1ioObI7W8nkLQf9C6PIbIDtXPhI43F65Ovey
	qJubZPfoGr3hZnY2ak8G2EzK/VnM3RJMKgBM4JktzVkmpcSxuOJnbLN/81VPIyHS6RQk/NPeLZF
	qJ/X9Oq29UxHPiWQA1Nr2KkVe0GWgHEitDniLv9tcCQ==
X-Received: by 2002:a17:90b:3a87:b0:353:356c:6840 with SMTP id 98e67ed59e1d1-353fecf4310mr763136a91.14.1769491049491;
        Mon, 26 Jan 2026 21:17:29 -0800 (PST)
X-Received: by 2002:a17:90b:3a87:b0:353:356c:6840 with SMTP id 98e67ed59e1d1-353fecf4310mr763118a91.14.1769491049154;
        Mon, 26 Jan 2026 21:17:29 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:28 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 18/33] i386/sev: add migration blockers only once
Date: Tue, 27 Jan 2026 10:45:46 +0530
Message-ID: <20260127051612.219475-19-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260127051612.219475-1-anisinha@redhat.com>
References: <20260127051612.219475-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69201-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5F5B590121
X-Rspamd-Action: no action

sev_launch_finish() and sev_snp_launch_finish() could be called multiple times
when the confidential guest is being reset/rebooted. The migration
blockers should not be added multiple times, once per invocation. This change
makes sure that the migration blockers are added only one time by adding the
migration blockers to the vm state change handler when the vm transitions to
the running state. Subsequent reboots do not change the state of the vm.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 176329bd07..5524e7142d 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1420,11 +1420,6 @@ sev_launch_finish(SevCommonState *sev_common)
     }
 
     sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
-
-    /* add migration blocker */
-    error_setg(&sev_mig_blocker,
-               "SEV: Migration is not implemented");
-    migrate_add_blocker(&sev_mig_blocker, &error_fatal);
 }
 
 static int snp_launch_update_data(uint64_t gpa, void *hva, size_t len,
@@ -1607,7 +1602,6 @@ static void
 sev_snp_launch_finish(SevCommonState *sev_common)
 {
     int ret, error;
-    Error *local_err = NULL;
     OvmfSevMetadata *metadata;
     SevLaunchUpdateData *data;
     SevSnpGuestState *sev_snp = SEV_SNP_GUEST(sev_common);
@@ -1654,15 +1648,6 @@ sev_snp_launch_finish(SevCommonState *sev_common)
 
     kvm_mark_guest_state_protected();
     sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
-
-    /* add migration blocker */
-    error_setg(&sev_mig_blocker,
-               "SEV-SNP: Migration is not implemented");
-    ret = migrate_add_blocker(&sev_mig_blocker, &local_err);
-    if (local_err) {
-        error_report_err(local_err);
-        exit(1);
-    }
 }
 
 
@@ -1675,6 +1660,11 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
     if (running) {
         if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
             klass->launch_finish(sev_common);
+
+            /* add migration blocker */
+            error_setg(&sev_mig_blocker,
+                       "SEV: Migration is not implemented");
+            migrate_add_blocker(&sev_mig_blocker, &error_fatal);
         }
     }
 }
-- 
2.42.0


