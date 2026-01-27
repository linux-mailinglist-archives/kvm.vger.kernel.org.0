Return-Path: <kvm+bounces-69191-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wC+WC4NKeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69191-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:17:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AB8319002B
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:17:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03D213036EE2
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52F22DC322;
	Tue, 27 Jan 2026 05:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XoDBVSFi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IUhkw6Ln"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD1B329365
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491020; cv=none; b=mVmxAs5/A/PMkSVWR4FTmHfawqSCwNdvgiP1CZARCcNgE3c8RbPhXZtREHTNU+UChTUb/XZJMm00FRW+R8IVl7wKnxbCHWWwoG/qOxZ4F8znb3xlFYa4NAGtkjNDojwjT3Nb6wtc4TBXDvs9oeHFRcBnZECdbJygUzQTcvnJi1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491020; c=relaxed/simple;
	bh=K9Q3Fx0MpDyU15vgP92BjrsfSkwlKYWWUpNzVS7pY3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sG7Ghzh2uSj2vYrzZvVuw6PJsyB687wCO8hPTcnXbmyKhuajCQ1tiTYL9+bQmYX2ElbU+DvkdO6kh/5QZ2pC/gqf9ag0kuceMsTn7fDWIKVoxKS3jbKBToDr7C0dfSFJ5h38jy6JS/dnkRjddgcJnmNIRlkwqtUoJYV6u9kvvs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XoDBVSFi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IUhkw6Ln; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/lBWdDVebfZe5D0jHJAAfOOk/PomlXvxepzVj2YvU4=;
	b=XoDBVSFiGP1WLSHqqCRoVZnIRN9E5SDjan8NUKzXZci6ojHergmqKLCkLYWfEXDGGTwAzM
	/pKP/KyODrR7gSvVwYViU6wtRRfB7WbX3CWEzCCcvObkj/eNrkhqO9SJgNDdk/eNf7Ingn
	Mnr+6GYDR0M5JCDKFEgAzMLrPniTOJU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-3B4hAAHAPluJQvlkvs1ZmA-1; Tue, 27 Jan 2026 00:16:57 -0500
X-MC-Unique: 3B4hAAHAPluJQvlkvs1ZmA-1
X-Mimecast-MFC-AGG-ID: 3B4hAAHAPluJQvlkvs1ZmA_1769491016
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34c64cd48a8so5491536a91.0
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491016; x=1770095816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/lBWdDVebfZe5D0jHJAAfOOk/PomlXvxepzVj2YvU4=;
        b=IUhkw6LnbfsZ7Xy6zXUQ41gLUYIJnii4NdBQXTWmccPBHxAGyKWVkMbuqaypeUinwW
         lyklQZRSMSKD3Q0ns8MlRj8aMJNyTgfsY16mapTLOq0dm0z9JzuthJMiYrP1KeLm7qSF
         OXOKPFaB8OPaLujaue2LD7SAXwqYEiTVl+819yVI7BaFjzpOSGopN86bG6CxZyX4/MNo
         ZiNsBWXFwAKO3hC48qH2JrHhW+yNm1FlTwFPA4ZUPLosNbCXw0P+I/KjkC4DEYCAtQWS
         MR+l7rXsr4h9aWE1dRWRkS5dViXOBZx42Res/IOS6GWaGcbA96qvpl+PTxN6Fd7Gcmq2
         zdJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491016; x=1770095816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X/lBWdDVebfZe5D0jHJAAfOOk/PomlXvxepzVj2YvU4=;
        b=R9ADkvDSCwbYzPHulgQMmb3ntlPiiIlhBSyMND+3OaXAuVvhaGeikg00nJWHEEON2U
         C5mVM9Y5jpQELuGsBI1XJv2kapZhH2jKDVP40rtiOo/b5bKFokBWUyyCnAlvyzXh1IzX
         n1IfpbtywbQMlyunzOps0EGaz8Wb3uu+LdGe3JoQIcF7R8At9VGyc+etYE1ZmDH/xiKB
         cA0H8l0Ougxi+c2OnibTyHA70khQu2+XsYskRb+Pq5rHZfa9+dWOUBUznGb4pD4m1x5F
         jOimKQ2c2M4t6ew1UZ0Wy3CRHDu9vAOSdeu5ug8J4r6CUmaWv24HYfYevlKUSx9oJKeD
         b/aQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9iIW1ROfhfkzgl13kpeRvL3SNulYEkJeCUsubY7IvnGJhYkotbIAgW8S+mOGE9HbsNSE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2KRvxetABcorotRQe0FA20xLuVWj5x72i1cuOhN3qrmC9RjLD
	oW7alPUnnYYlYo/MyhJ7EfIh8pWcBCXvlg/SZ/ld2+so1OUao+HkHZOPFtn+S+EeedIvMGpAb5V
	hWdrCPWGhxBn7w3PjUbkGCQN5b7J8mQMRNVzcbqoIL+0pfnOWIgvrmQ==
X-Gm-Gg: AZuq6aKbo8zaQCLBsSN4SMmXqimX00j9ejY5C8b4uqFtPx2ecQjXWe3mo6Pcs6BAXFu
	HHkEVsBZgzbL/y+bKiWbBFaC+vZa/Jmn6MNL5Aj2p3XtOhE/dAXRt4StYH19i17Z5487NzVfFa1
	Wf2Hxy/Tu6kbRPWRXrskUx2hebLZVSDrc0C2AH2q//LfTwCaZvf3TRpJRW5GQjPhAg4owdIbRKn
	EJb2NIXgQ7ckbn+b23Xt8EhAthHr0saL7AtAuI4mcwypXKUO+ajf+A84vXaws4LR1mlZD1tBAwy
	MipHTe0PaMcOMilhNdAyvOwWGZ+zxnxSj5aruqT8Bek4UMK0asPVNhja0vU44x0uQ1ykFaBljAE
	+CosSZpmJ2ISMt9jCEZQXz8wS7oclyiF0H/RawxQtvQ==
X-Received: by 2002:a17:90b:3901:b0:32d:f352:f764 with SMTP id 98e67ed59e1d1-353fecd08edmr647582a91.2.1769491015905;
        Mon, 26 Jan 2026 21:16:55 -0800 (PST)
X-Received: by 2002:a17:90b:3901:b0:32d:f352:f764 with SMTP id 98e67ed59e1d1-353fecd08edmr647562a91.2.1769491015535;
        Mon, 26 Jan 2026 21:16:55 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:16:55 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 06/33] accel/kvm: mark guest state as unprotected after vm file descriptor change
Date: Tue, 27 Jan 2026 10:45:34 +0530
Message-ID: <20260127051612.219475-7-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69191-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AB8319002B
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
index 46243cfcf2..834df61c31 100644
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


