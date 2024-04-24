Return-Path: <kvm+bounces-15783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D19808B07D4
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 12:58:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0025B1C2132F
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 10:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9DE915991A;
	Wed, 24 Apr 2024 10:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YUy1Mr1J";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="J/cQvrL5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YUy1Mr1J";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="J/cQvrL5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A4313DBB6;
	Wed, 24 Apr 2024 10:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956281; cv=none; b=YeSWrLmRjAFVEVbZrKbBkihhSkmTuq8J2Cmoek3XkhOsPWjSF7XVFyuc00cfazLkCtfKliyB0Bn/WfO7j5XjSoTt/CPTqMef7IGeVtzKv6JzqfRogokoVP4G3EjmNrs9pD5XOp1OpzjOZRWLDGgChBwrlS7UpzPUqwL/EoXu0ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956281; c=relaxed/simple;
	bh=tRS2Dc6k4cHvFQvqwEyy6MnuweR/Dsimsz7u5sHttWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6TAr+mpUMTlT+sepVyt2QliRnw4TO9y2xuP3kD7HIvwy25yJFQvPAS0l58NFqWWJbmfXVcJ040Cfa6c7lWAffK3TLs1NY9pqstwtX/PfYknEfBlWghAny/STRVPiObXNcli9rXZjsLN/tMNF2UW163V08SWG/IQAvtah87Ou2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YUy1Mr1J; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=J/cQvrL5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YUy1Mr1J; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=J/cQvrL5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 286216144C;
	Wed, 24 Apr 2024 10:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713956278; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zepJMi+/FmAphXDQSDExadHqtRjvIFiQoMCvNpYvve8=;
	b=YUy1Mr1JRvB2R7AR3ds8ByBJDyF+FV0oRRvwl7d1HhfNOTk7mRICDX83XeVD+0a+7jT3Ka
	uzvaIZYBtWtu4yjYvhyQ/jfY3D4mlMbZWbfkwi5BElrYbEfa2iWCo5Xy3TE8ovMZkB61e9
	3tKqjS2MklBlR/Ws/B44uzqq/axYiqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713956278;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zepJMi+/FmAphXDQSDExadHqtRjvIFiQoMCvNpYvve8=;
	b=J/cQvrL5Q5gRvCcb0IN9BRmKlbN9EwB0hEysYf72sKbbHcxMMJVXuWGXk0qzN7pTIgH4xC
	GwJ1Q8YrxLdlp7Cw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713956278; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zepJMi+/FmAphXDQSDExadHqtRjvIFiQoMCvNpYvve8=;
	b=YUy1Mr1JRvB2R7AR3ds8ByBJDyF+FV0oRRvwl7d1HhfNOTk7mRICDX83XeVD+0a+7jT3Ka
	uzvaIZYBtWtu4yjYvhyQ/jfY3D4mlMbZWbfkwi5BElrYbEfa2iWCo5Xy3TE8ovMZkB61e9
	3tKqjS2MklBlR/Ws/B44uzqq/axYiqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713956278;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zepJMi+/FmAphXDQSDExadHqtRjvIFiQoMCvNpYvve8=;
	b=J/cQvrL5Q5gRvCcb0IN9BRmKlbN9EwB0hEysYf72sKbbHcxMMJVXuWGXk0qzN7pTIgH4xC
	GwJ1Q8YrxLdlp7Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9AE6D13690;
	Wed, 24 Apr 2024 10:57:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sWGSIrXlKGYiUwAAD6G6ig
	(envelope-from <clopez@suse.de>); Wed, 24 Apr 2024 10:57:57 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: seanjc@google.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3] KVM: X86: improve documentation for KVM_CAP_X86_BUS_LOCK_EXIT
Date: Wed, 24 Apr 2024 12:56:18 +0200
Message-Id: <20240424105616.29596-1-clopez@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231116133628.5976-1-clopez@suse.de>
References: <20231116133628.5976-1-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email]
X-Spam-Score: -3.30
X-Spam-Flag: NO

Improve the description for the KVM_CAP_X86_BUS_LOCK_EXIT capability,
fixing a few typos, grammarm and clarifying the purpose of the ioctl.

Signed-off-by: Carlos López <clopez@suse.de>
---
v3: Added Sean Christopherson's suggestions
v2: Corrected the name of the KVM_RUN_X86_BUS_LOCK flag

 Documentation/virt/kvm/api.rst | 52 ++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..a1d78e06a1ad 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6416,9 +6416,9 @@ More architecture-specific flags detailing state of the VCPU that may
 affect the device's behavior. Current defined flags::
 
   /* x86, set if the VCPU is in system management mode */
-  #define KVM_RUN_X86_SMM     (1 << 0)
+  #define KVM_RUN_X86_SMM          (1 << 0)
   /* x86, set if bus lock detected in VM */
-  #define KVM_RUN_BUS_LOCK    (1 << 1)
+  #define KVM_RUN_X86_BUS_LOCK     (1 << 1)
   /* arm64, set for KVM_EXIT_DEBUG */
   #define KVM_DEBUG_ARCH_HSR_HIGH_VALID  (1 << 0)
 
@@ -7757,29 +7757,31 @@ Valid bits in args[0] are::
   #define KVM_BUS_LOCK_DETECTION_OFF      (1 << 0)
   #define KVM_BUS_LOCK_DETECTION_EXIT     (1 << 1)
 
-Enabling this capability on a VM provides userspace with a way to select
-a policy to handle the bus locks detected in guest. Userspace can obtain
-the supported modes from the result of KVM_CHECK_EXTENSION and define it
-through the KVM_ENABLE_CAP.
-
-KVM_BUS_LOCK_DETECTION_OFF and KVM_BUS_LOCK_DETECTION_EXIT are supported
-currently and mutually exclusive with each other. More bits can be added in
-the future.
-
-With KVM_BUS_LOCK_DETECTION_OFF set, bus locks in guest will not cause vm exits
-so that no additional actions are needed. This is the default mode.
-
-With KVM_BUS_LOCK_DETECTION_EXIT set, vm exits happen when bus lock detected
-in VM. KVM just exits to userspace when handling them. Userspace can enforce
-its own throttling or other policy based mitigations.
-
-This capability is aimed to address the thread that VM can exploit bus locks to
-degree the performance of the whole system. Once the userspace enable this
-capability and select the KVM_BUS_LOCK_DETECTION_EXIT mode, KVM will set the
-KVM_RUN_BUS_LOCK flag in vcpu-run->flags field and exit to userspace. Concerning
-the bus lock vm exit can be preempted by a higher priority VM exit, the exit
-notifications to userspace can be KVM_EXIT_BUS_LOCK or other reasons.
-KVM_RUN_BUS_LOCK flag is used to distinguish between them.
+Enabling this capability on a VM provides userspace with a way to select a
+policy to handle the bus locks detected in guest. Userspace can obtain the
+supported modes from the result of KVM_CHECK_EXTENSION and define it through
+the KVM_ENABLE_CAP. The supported modes are mutually-exclusive.
+
+This capability allows userspace to force VM exits on bus locks detected in the
+guest, irrespective whether or not the host has enabled split-lock detection
+(which triggers an #AC exception that KVM intercepts). This capability is
+intended to mitigate attacks where a malicious/buggy guest can exploit bus
+locks to degrade the performance of the whole system.
+
+If KVM_BUS_LOCK_DETECTION_OFF is set, KVM doesn't force guest bus locks to VM
+exit, although the host kernel's split-lock #AC detection still applies, if
+enabled.
+
+If KVM_BUS_LOCK_DETECTION_EXIT is set, KVM enables a CPU feature that ensures
+bus locks in the guest trigger a VM exit, and KVM exits to userspace for all
+such VM exits, e.g. to allow userspace to throttle the offending guest and/or
+apply some other policy-based mitigation. When exiting to userspace, KVM sets
+KVM_RUN_X86_BUS_LOCK in vcpu-run->flags, and conditionally sets the exit_reason
+to KVM_EXIT_X86_BUS_LOCK.
+
+Note! Detected bus locks may be coincident with other exits to userspace, i.e.
+KVM_RUN_X86_BUS_LOCK should be checked regardless of the primary exit reason if
+userspace wants to take action on all detected bus locks.
 
 7.23 KVM_CAP_PPC_DAWR1
 ----------------------
-- 
2.35.3


