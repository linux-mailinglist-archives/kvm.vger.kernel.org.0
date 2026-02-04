Return-Path: <kvm+bounces-70173-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kAJsEKAag2l9hwMAu9opvQ
	(envelope-from <kvm+bounces-70173-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 11:08:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D87DAE4462
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 11:08:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE06E303C4FE
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 10:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084CC3A7F75;
	Wed,  4 Feb 2026 10:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJwk8MMN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126FB36E472
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 10:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770199666; cv=none; b=mJNm3MLLd0eOfggmbRReHaa4gFHg+KKdn7+DTb94aeTncT/jW9NMFtvF2eKqTCdWgp38mEarIRTTsZTuw1kp6gGq71I0AgNgCwcJD+tbO6fT+9IGJ8hoSV8w9oKlAtA6wbvMn0OPhm4xboTurL0CpzQt4QL4kyoIJbG5qF7jX4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770199666; c=relaxed/simple;
	bh=h236uaeZwZJDOEONAtD4/bubBcFrIgIRs2z0DE/y7as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YvVC0TBbvObrSNIY7dLH6T1jVcfip75V8svTb8n82X/NwANjf+SM+CY9Ou6R+Ljz1Mj0yqyfPX71BDm4OnC4T5kpEh6LjLVGZtK12C0mWAD2ZZBGkMdZT3xNMjIqjjk9f5rYvPNILYtU5O2GM/eZi4ICgR3X1RJv97jrstlzkGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJwk8MMN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770199665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mizg/dgdD1DY/jcPXclyntH039bzzdaewQLJZPncsmk=;
	b=aJwk8MMNWHJ8MH5S7WmF1OeLel4j63bxjPYxggGmg1DWLsmZWHTeTai1BGuaa7sjTgBczr
	3vjDuBtUzuAJ6RCSjG/ZwG32/AyIHovRhAIe19nP8oPf2wTe6XjSKdMFpjlSKmD+k0Yfv7
	kziB8klqHkyX9mkb7xcuj6jhorGL42A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-314-j9g_IonDO1uAip7CeuoIYg-1; Wed,
 04 Feb 2026 05:07:40 -0500
X-MC-Unique: j9g_IonDO1uAip7CeuoIYg-1
X-Mimecast-MFC-AGG-ID: j9g_IonDO1uAip7CeuoIYg_1770199659
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEAF719560B3;
	Wed,  4 Feb 2026 10:07:38 +0000 (UTC)
Received: from localhost (unknown [10.45.242.6])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C148E18003F6;
	Wed,  4 Feb 2026 10:07:36 +0000 (UTC)
From: marcandre.lureau@redhat.com
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Fabiano Rosas <farosas@suse.de>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mark Kanda <mark.kanda@oracle.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 04/10] system/memory: minor doc fix
Date: Wed,  4 Feb 2026 14:07:00 +0400
Message-ID: <20260204100708.724800-5-marcandre.lureau@redhat.com>
In-Reply-To: <20260204100708.724800-1-marcandre.lureau@redhat.com>
References: <20260204100708.724800-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70173-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D87DAE4462
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/system/memory.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index be36fd93dc0..a64b2826489 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -574,7 +574,7 @@ struct RamDiscardListener {
      * new population (e.g., unmap).
      *
      * @rdl: the #RamDiscardListener getting notified
-     * @section: the #MemoryRegionSection to get populated. The section
+     * @section: the #MemoryRegionSection to get discarded. The section
      *           is aligned within the memory region to the minimum granularity
      *           unless it would exceed the registered section.
      */
-- 
2.52.0


