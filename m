Return-Path: <kvm+bounces-71239-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uDe2GAumlWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71239-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1FFD155FD2
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 897953020EFF
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D38D930DEA2;
	Wed, 18 Feb 2026 11:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LP2ahFZh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DngRejGw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A632FFDD5
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415048; cv=none; b=f920XxPtibxduQXM44dvO/cFJB60K8iUwW+8b/aEG2ZIyXoD1/P4FjIMrDBbukbCkkjs+ZHOTco20wwo9ZHSa3hlyOKZKQCM1K7yCcAUA4x3rw6zULjHfPDpRJgPgOp4nOKmN4YdNLHeJNejDkc066QqpIlj9bgZ5BwZ8lqq1c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415048; c=relaxed/simple;
	bh=L5P6YVm0yFvVEcJwumeEIft9LTWFtuU1GGj5itvoUlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGegQuBqh4T6s2XxyfphpeXNycdK2ZOu4f0zfWIQ4GnXPQ03YcWvBl+nBc5aO9IOPwVzpcx2cgN8MTL77XeizPYP5XvY3xtnmad0s9fxHc2pmKvBAQwUyAwzdS+KVIIARWw/4kRa4iXyXBDRFL7CONSRccz5tMlH/2rBg/q1WDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LP2ahFZh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DngRejGw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771415046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1p5ZbFdSM+FDKoKqpM0RbDlLtsFLRzSauSxJ1myhHy4=;
	b=LP2ahFZhw/APj5y9MoJ5rvN7jrbiRqOjLz67UpZcvlpHUHZ8kpWaU367VIU5IK77ic9wnN
	BI6As8L9GA+sQjwp6GpjrQSLcJMi+ciXuPvVTgTj6uzAPd33Zr/yEvS2tWu7yKrhdyL0Lb
	psOMkDzeT6XbO6ti/94Qm9Ldl/lWtdM=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-hyG_jAveMr226teeKPa8ZQ-1; Wed, 18 Feb 2026 06:44:04 -0500
X-MC-Unique: hyG_jAveMr226teeKPa8ZQ-1
X-Mimecast-MFC-AGG-ID: hyG_jAveMr226teeKPa8ZQ_1771415043
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2aad6045810so51117105ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771415043; x=1772019843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1p5ZbFdSM+FDKoKqpM0RbDlLtsFLRzSauSxJ1myhHy4=;
        b=DngRejGwpR0ZuUeKhutDl4ZRzg0MbnBsvWMBt0NHu0k2uIirxQ+eNHK1Y/k1MpuSum
         51cYE0CDYEXq10+LhXENCuVzSaVXu+R56zN1peE3YEJQxavoB6+u9in8cNCxYfXGsCPV
         /6IkGlJanckz3yiw3W1wY7N7sx3Xe+44h3kuOyguqriVwYKnHpDYwFzbvoOv9TjtqqT2
         gPffNRtaeGyuYFBoKfZiEbDOIWZwTp52STbQlYPrYWIwCSegBlPayQb0g/iuthoYvNBG
         3LUCO6RwkEnBxsRc6+KDINB4NxO0XF2hyyeUO6jXkfvTSsAG8FeHuZBr7XmJeHSkpPh6
         Yo0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415043; x=1772019843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1p5ZbFdSM+FDKoKqpM0RbDlLtsFLRzSauSxJ1myhHy4=;
        b=J6fg5aUG0nRAedEToBPRmA+oDYQaL6G7e7f58/cTf0BifVmHiYm+RQ2hIbHyn874Tf
         JDo7zAUjH9aYmzlz4877aO3ZSZQClmQxf08FfpdCy+ZMI3iVftZOGAVqtamuZbX0BenE
         F2Io8SlCFSxP7i0KJ0wSh+jq+BOaW9KdjpISchS+Pqx9+f2ch4J6X/xB2FA686af6bi3
         jn0toGs4ATsy4OEqXEIQk72d2QYpT8fi1z8IhF2Z3tHOq8G96Z9nMpup4V+t7+jP+eqJ
         Zt4cexjcDQ4XF+WfDBQ/b33jUQH7HH+dzWgTqAPCS+RxtJwylEj7kzIvkVmKKq0Lafi2
         NwEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlQ7vFER3mvUi5QOkmC2Vav+Ma3MZb824w28eakpknzJ33t3DkT6HIv7vD8O+4ms3k2vA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5pjaP6qVyKLEAOYNX6BDkGFlnclUe7+VMydc7az0/BtDn3E49
	jTV7sdWhOJgHghmIcxr9BGp+UG6jTnIGQ99FvHDrk2hYK/DFKtb5lvNFXtM+cE++J/DkipaBjzW
	YXMFQjkM2ul6EQy2krKFeaU518+i8o1Wgj4QBvr36lvhNY94wFwWS7A==
X-Gm-Gg: AZuq6aLauc5wdRZilyAKB58XvraomeaUFbD5Gk4goeKSYrwCR6PJgU8VP/TayaxAGdG
	ArNEVmknl4YR2+6F61k0pR6MIzh7xR2cGZL/fWVn8f0fl6YB055IlVBbUDTvVi32HqGCIh3aQ15
	xbMpIa6Qm8yDmKmx34Qm5N3s6TffgZtcpbbMHei/HWgja8rLPfoDWnYtcpBH5XgzTMwDF5Vp1g4
	xPKD0q6Yeq8jegugWKrHbPUD+w2annygSY2heCDv8jvQ4O4IKY4m+BX4eE5qxOVaEYt3wKwhBfN
	2RdiorS4Q3YqmRMjUo8OVap+QfgURPmQvoVjYxdvwa5C1Cv8tg/T2lKL3fl1xg4WwSiSitFY3Bl
	Xxo4z4GxgYYkCyB0nYccxZ+qzUxelhiLnL68+W6iH2i5GfnqRN8yN
X-Received: by 2002:a17:902:f681:b0:2a0:fb1c:143d with SMTP id d9443c01a7336-2ad50e74e46mr13383115ad.1.1771415043426;
        Wed, 18 Feb 2026 03:44:03 -0800 (PST)
X-Received: by 2002:a17:902:f681:b0:2a0:fb1c:143d with SMTP id d9443c01a7336-2ad50e74e46mr13382985ad.1.1771415043043;
        Wed, 18 Feb 2026 03:44:03 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:44:02 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 25/34] kvm/hyperv: add synic feature to CPU only if its not enabled
Date: Wed, 18 Feb 2026 17:12:18 +0530
Message-ID: <20260218114233.266178-26-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260218114233.266178-1-anisinha@redhat.com>
References: <20260218114233.266178-1-anisinha@redhat.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71239-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C1FFD155FD2
X-Rspamd-Action: no action

We need to make sure that synic CPU feature is not already enabled. If it is,
trying to enable it again will result in the following assertion:

Unexpected error in object_property_try_add() at ../qom/object.c:1268:
qemu-system-x86_64: attempt to add duplicate property 'synic' to object (type 'host-x86_64-cpu')

So enable synic only if its not enabled already.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 5c8ec77212..ff5dc5b02a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1761,7 +1761,7 @@ static int hyperv_init_vcpu(X86CPU *cpu)
             return ret;
         }
 
-        if (!cpu->hyperv_synic_kvm_only) {
+        if (!cpu->hyperv_synic_kvm_only && !hyperv_is_synic_enabled()) {
             ret = hyperv_x86_synic_add(cpu);
             if (ret < 0) {
                 error_report("failed to create HyperV SynIC: %s",
-- 
2.42.0


