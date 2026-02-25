Return-Path: <kvm+bounces-71751-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8J29HZpxnmlqVQQAu9opvQ
	(envelope-from <kvm+bounces-71751-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C7C1914B7
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 175A230C1B99
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0092BE029;
	Wed, 25 Feb 2026 03:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ISv8Radf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hFIZXUPW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEED579CD
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991434; cv=none; b=gGcbbRa7WbwgkAfAqmSnVPn2agFRR+zHOUBHI4mEKbN0+kYeQXt504EcNPfBlUMPLdQrHZ+6NvfGDEe3YbCfHamx1nWdH2tdTSYRbJBP/czIU2rLcbUHdPSxFdlHigoiYahoJvB726VtBaf54cNp60Qb240nqTJjL9H3w8xJtnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991434; c=relaxed/simple;
	bh=iQajmY0HxVb1F1qrfWN4H5oIW3Y0fWgRQGu0A4wkAjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1aoVaN4oHibcEd4sOFL1qbux8RNsYGsQthNGAs7LoOYpHAmjAGB3gKdcdh/Ydy5MWpIwbp3PRPDXixG473sVJyLqUbxgL4+zOyHAPprWQ2gwv40tV7Gi9rUEw7ghi9c5NkNGIobuLufDHgoq6q0ZgfWZeDW7RbQ4R9ks58kweE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ISv8Radf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hFIZXUPW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UqlV2b27E+aarYMd02lMV5j2FrXQhhHTUbSjNbHXroY=;
	b=ISv8RadfgV7LRsxl9RY24HwYjQyv/G0OTRUdpo3mcg4VrjtHGRUit2ESSD3KvpUJgFupmw
	yY09w6azYgGPt6WcosyRpWfRC1MI5Iw9BkZ0y74KlyfQdIPCvZsdiBfpoTBZ9vZUpJBfYQ
	sfEeENMjzQLwNDIq9xjaO0JyJTrYhDc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-auvekXEZPLmSZqeDgf1qVA-1; Tue, 24 Feb 2026 22:50:30 -0500
X-MC-Unique: auvekXEZPLmSZqeDgf1qVA-1
X-Mimecast-MFC-AGG-ID: auvekXEZPLmSZqeDgf1qVA_1771991429
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35464d7c539so6092122a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991429; x=1772596229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UqlV2b27E+aarYMd02lMV5j2FrXQhhHTUbSjNbHXroY=;
        b=hFIZXUPWNZRRnvsACen3OPsjFd5UmUkKrj0qSgB9KaItxMVgBH2sYHICYteTmyR4MS
         M4ReFU8iF9r9TGvjmsp7V2td9889yvsMKyd+d/CAv5CwNWOI5Y4pyDs1Mgs4eMuwWu6c
         wHtSnPXisfpW65ZxJAPJAyyG0HQfs99yRXZvNZH5tSE8gKUc+eWtlpCseC71cYsJGufm
         iu7kycdzGZOrr2GWe2+xDuobQUJDWCGg2RMuYLXTuCO0qOVYFQwygjNTtEZ+HBeSU+Ak
         wT9nvdi2FQv+58na9aZAEV0XUfug9jqTB6YpcqL+a7GeLumcPd/vmqlACg8UHMGoNhfv
         AywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991429; x=1772596229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UqlV2b27E+aarYMd02lMV5j2FrXQhhHTUbSjNbHXroY=;
        b=ccrDsqoNz+7hQroUdlznl8ssuX7V/4or9E8+01Tsy3LrJEx3QmwURb06aLAng/za3+
         /XWFeEB8XRKpCZRbt8hEtukm5UE4EtGiy0va0ATszDqkBqTc2668ffj1PBUOn3O+D8Ay
         kQUqKZnkXgbP46IQRSas/L8NHvr6uR5wDpDxduDCYjZAuPSvQRNdi+9uDDdbtMfL/muh
         iObtBl2IEn+a0cNnTC6OlSzJbxSzSsnUJmZYD/0s9lcYQdlxuaCu5SacVpmpwI8ErS3Q
         XLxhZwdhdr0LrhldJKVqsMU+ImtYwgyjUF8EBnDSELUWvWi/LSpsFEpkZ2UgTpjiOPpn
         n1Rg==
X-Forwarded-Encrypted: i=1; AJvYcCX0fz931vOoSFdcLG1urqhoYIdunbQ8DgSumvnaixAE646WpW5napN1LOUTlxlrokZA8/U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFa3QmtFibLAIXhy18e9AIl8lwcMh+c80WKQktvG9jUM76ZR46
	y3bH1s75ffyST9ghdCWbW72N+2dX0ht9cPTVE2GXmbD5i7PA7KXwL/wRcM1rco6NiuNWy6wgDSL
	B2tE+QlZHpGesS32CRmXvU8LNUJBbmz9U2tF6LFJV1/XS3g6aJ5WH36qir9cDsw==
X-Gm-Gg: ATEYQzy2I9OkDk5t84VJpP9W9cxcc/h0/vzN2MupPMmv64bcQHCMdcxoBg07wmBkY1I
	8aHcpRqVMQySaBd0wSJFwT/sSHZ6/OH8QLHH3QXIPaUAXJlp3b7FDLbIH7yjOcDRdLvMM+YyACy
	J2Gp4c33L6LtCOjM5bWLiLgnmFL9e4xmuNPRc8Ycpmhed3xjJpqB8DKjBUvcxcvKc8K0ciVm2bI
	/n7evgKtcaon2iynmM7gdTx/kTD+C4Txm1SOkUCbZ6+OvKMXg+vZEtmP7AaamLDlFzbdECw/iia
	un61+wZukVFjE6on91kSD6XK4XAQClRzCZlhibY3KYUTstS2sO+jRE+y4nbGm2HuncO3JkEXlVv
	1NFZ2ZZqKxFctlbiSkvjRg1AwQgwxIDxHTcqQVI8tw5y6UBunVZBAXoM=
X-Received: by 2002:a17:90b:1f88:b0:354:bd08:4802 with SMTP id 98e67ed59e1d1-3590f27b7fcmr824605a91.35.1771991429154;
        Tue, 24 Feb 2026 19:50:29 -0800 (PST)
X-Received: by 2002:a17:90b:1f88:b0:354:bd08:4802 with SMTP id 98e67ed59e1d1-3590f27b7fcmr824586a91.35.1771991428782;
        Tue, 24 Feb 2026 19:50:28 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:50:28 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 06/35] accel/kvm: mark guest state as unprotected after vm file descriptor change
Date: Wed, 25 Feb 2026 09:19:11 +0530
Message-ID: <20260225035000.385950-7-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260225035000.385950-1-anisinha@redhat.com>
References: <20260225035000.385950-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71751-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 12C7C1914B7
X-Rspamd-Action: no action

When the KVM VM file descriptor has changed and a new one created, the guest
state is no longer in protected state. Mark it as such.
The guest state becomes protected again when TDX and SEV-ES and SEV-SNP mark
it as such.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index cc5c42ce4d..096edb5e19 100644
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


