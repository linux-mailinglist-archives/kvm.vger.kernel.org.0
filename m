Return-Path: <kvm+bounces-72318-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SDxDMtz3o2kuTQUAu9opvQ
	(envelope-from <kvm+bounces-72318-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 09:25:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E8AD1CECEC
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 09:25:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ED23130166DB
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 08:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09EB91FE471;
	Sun,  1 Mar 2026 08:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RiI89ZO6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432CC18C02E
	for <kvm@vger.kernel.org>; Sun,  1 Mar 2026 08:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772353152; cv=none; b=LGs14/u7Y5BQsm69HOhJBLe8lkGZTYgN5kazm4fpBMHX3NAGLfEQZ+1ENc/8/hMXOvuz4cuBIqF0t+KgxrsMtX84W3SCqGv2LeIt43e/rLBjdrK6nN3uy88bvL0WhCU8QgzQOjJobkmyDwc2c9NZYKMVGAmYZhleijAiDSUG3lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772353152; c=relaxed/simple;
	bh=HAn8Q0qD46S52DsoD8KOFk0HLdGDwh1bHqGsoxSYe94=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FYI8dgBZfZeRGwXKo6uyve1rWCT6/v8BVdmkey+tB1pTV69DYpsQ2qHnEThyomLsGULh/qOVu7mQqmfmkTvc+A8m+lGgCpur19xF/dUjcVTzXuMCkiUytlcb+qGkVzphNHUHrXeVTCTbLHSNYMN1kmrEXyx+7lWQAMJL5WSL+jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RiI89ZO6; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2aae146b604so27146925ad.3
        for <kvm@vger.kernel.org>; Sun, 01 Mar 2026 00:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772353151; x=1772957951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JXaV9B2nw2SEQzT6yc0N2Gk8LtML7jgrgg7/O8SJR1I=;
        b=RiI89ZO6bf8DdzRa0ALwKekUUjpGzfR6pYCQ0aOfscu91SC4CRDyB089PXvo1eo5c8
         NRniHDOFUbuYgRaXbCfsfNlzlhvhpTeGV7qy43hjxViq9q/1XpL/8ZBNkLMrcHz08DQm
         RbtJUr09nl66HD5LwzD+Erdr7ayw2x7gcjKw7nX38rMTfX2Tzn0SVKyTey9sbnWuVChY
         kL6m7q9X287632eN4HvfjqMDpkE1ZhRQIR57m8lMb27Lc9CFeknSJECgQH3yRG9bMAuH
         XM2mT1SQgcb4DyJat8fZT+PeDhncadqRsBjpURxqWYmrV3JBqJ9+u9ObePwY9pvmUcq1
         LCpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772353151; x=1772957951;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXaV9B2nw2SEQzT6yc0N2Gk8LtML7jgrgg7/O8SJR1I=;
        b=D55aZQVO0kI5uyLiSljkdBw0cqLitsalRZrPgkqVdTUpDxdFWsIDbu4UtBo3szbYcY
         IgVIUDis1qUPhaeolUn9h1dUQpQs7IlkGwroTQW9rWL+yfBAaDoqs7ssZgK2uzVMNpHI
         x9M2wezkKQDUstAcJ1odULVSVs5OPiWfd0YIXPggC8uREHhPEOtdABsLavYY/YhFDpf+
         FsZxQ2yRCZVcgEdATNlpBhg7/jNAgUPf79z4UZunOO3O9XTTAevb+wiLSlJwLFF2RZKU
         9nGjHnAUATXHJJDUXFEOoCsj+ZWma/nTfKj7OddiilFrjasOXikk3y2l38oREjDhic31
         I+Ag==
X-Forwarded-Encrypted: i=1; AJvYcCUa121mHpK0c0jCfAdYcE44tm0Jjo+ZeCqfNZXO+V5h8LILB0JMw8Ot1DS/LH8PdNnmjrg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIoXVo4lkzA04AMiLHiso8w91L9CfnpTvj9R9//DR4zuuv6BDl
	3zJKAuxJeLXDV6iuiljjs/B4fSYjEg9dbzVqY+CmJ1SROk3yOZMRgTrq
X-Gm-Gg: ATEYQzwHEXPktsUlH9AfBEOWyqLWlvseptODhZqzJS6MJkDuxIV1x+kjqQHPMVfGD6F
	+Kr+Qw1Umlv5gQduHw+KmGBYtW4Bn2oU9aJNC9mKL9aN6bhk/VPUCpjlrZh1JZaB8gC/XedYffD
	B+H/Jv8zMgK26PnGsBhblrUTGjo567y3TLFdO/Sy9vgA84xSw9NoulfLuKev+hPtAWsF2FWkPrL
	BxwrZXeKHdAi5QsLkVS1tJcMqKJXN+5tITWkSHfawrZBhtDE9ZsZlKAsNqIKCkQVf8/KQEap373
	8Vyvf+YftZEfKnTx6jVWIT4gzoJoCkBmoaj9/7rwS/GBXuDSV45HeS52CERISYTN0UlqO0djuMW
	W34gfgw1lhWH93TIMi/wtvyefXLMLhx4kgda+hL1XeiVphqMUVMKZLlXJg+e8Vtg1EniWq7mbNz
	lzO+sMiXIgxfIQTc9/1zLDDrf0bjE=
X-Received: by 2002:a17:903:947:b0:2a3:bf9d:9399 with SMTP id d9443c01a7336-2ae2e47fee8mr81583175ad.35.1772353150536;
        Sun, 01 Mar 2026 00:19:10 -0800 (PST)
Received: from linux-dev.. ([104.28.153.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69f277sm137489055ad.55.2026.03.01.00.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 00:19:10 -0800 (PST)
From: Afkari Zergaw <afkarizergaw12@gmail.com>
To: pbonzini@redhat.com,
	corbet@lwn.net
Cc: skhan@linuxfoundation.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Afkari Zergaw <afkarizergaw12@gmail.com>
Subject: [PATCH] Documentation: KVM: fix punctuation for e.g. and i.e.
Date: Sun,  1 Mar 2026 08:18:51 +0000
Message-ID: <20260301081851.11533-1-afkarizergaw12@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [4.34 / 15.00];
	RECEIVED_BLOCKLISTDE(3.00)[104.28.153.21:received];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MAILLIST(-0.15)[generic];
	BAD_REP_POLICIES(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linuxfoundation.org,vger.kernel.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72318-lists,kvm=lfdr.de];
	R_DKIM_ALLOW(0.00)[gmail.com:s=20230601];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	GREYLIST(0.00)[pass,body];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[afkarizergaw12@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-0.793];
	TAGGED_RCPT(0.00)[kvm];
	ARC_ALLOW(0.00)[subspace.kernel.org:s=arc-20240116:i=1];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_SPF_ALLOW(0.00)[+ip4:172.105.105.114:c];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6E8AD1CECEC
X-Rspamd-Action: no action

Add missing commas after "e.g." and "i.e." in the KVM API
documentation to improve readability and follow standard
punctuation usage.

Signed-off-by: Afkari Zergaw <afkarizergaw12@gmail.com>
---
 Documentation/virt/kvm/api.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fc5736839edd..c8500f0e913a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6346,12 +6346,12 @@ A KVM_MEM_GUEST_MEMFD region _must_ have a valid guest_memfd (private memory) an
 userspace_addr (shared memory).  However, "valid" for userspace_addr simply
 means that the address itself must be a legal userspace address.  The backing
 mapping for userspace_addr is not required to be valid/populated at the time of
-KVM_SET_USER_MEMORY_REGION2, e.g. shared memory can be lazily mapped/allocated
+KVM_SET_USER_MEMORY_REGION2, e.g., shared memory can be lazily mapped/allocated
 on-demand.
 
-When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
+When mapping a gfn into the guest, KVM selects shared vs. private, i.e., consumes
 userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
-state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
+state.  At VM creation time, all memory is shared, i.e., the PRIVATE attribute
 is '0' for all gfns.  Userspace can control whether memory is shared/private by
 toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as needed.
 
-- 
2.43.0


