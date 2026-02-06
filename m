Return-Path: <kvm+bounces-70516-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iM54DS1rhmnwMwQAu9opvQ
	(envelope-from <kvm+bounces-70516-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:29:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 60146103CA5
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BBE89301153F
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 22:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8BDE311955;
	Fri,  6 Feb 2026 22:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X3KstRwu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FC1301001
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 22:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770416924; cv=none; b=ifO04Uj6CxgK6iUIB/WQW8uN0tHLHc658CQLJB3Gw/hAyhlqBmmGVvjd7eabtTFJ5DN4lkjnSln/lVJ5EFL40Xbi/meZrxdYmxSqxNu/zww3ehG57dRLTMhjzETHRX+FdUKPvkHDQKP3ixtz2K9b6UzlREZ83Awf0bPk9ouHLzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770416924; c=relaxed/simple;
	bh=5WlBpXcTHGuxWH4iNnba8FpIkK+3C56TjrsiYnNMy1w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=g4ylO50/av9oleXySoCdRUR7fT3KwI8fgyynwc1PySkik3cieDbVTrufTTLqNyrf//CEVLa3cVknC7Wy4krI0nFngMsEuiD0OZt08OBVrVxaGlz2AEa1ujSvwNTxjLxVFPviPqUIy4jFzLHCSkWOeBov/Ndh4trARVOykFOtTZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X3KstRwu; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7cfd0f357dcso1793484a34.2
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 14:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770416923; x=1771021723; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Io5HDeIklfld3UNsVscq5IsVk6UhJkXyB1ydmVsm80I=;
        b=X3KstRwubBoBnx2jtxVJOH3wiYub5qYsshPgjfk4I9jwSmiSNam49P9E4EwI/czdmC
         FmaOfrKcqEb3bBUHRpcz1UOrR64QmLDIFEOnH6ejc18xcJ+lXJnLZY//N5/Zp4ADqWTh
         krdarFIzlIFfe86SqiD67OW6bmj/d/NymzrCvNPZg2IkV59l5ayc8loC9MuIn3+xeu1y
         N8Vmp7802Yyd8IWTVBLSOlRzX5H9Rj5cv21HxYlfa0ne8FVfk72tSdGrUuV76+Ay7z35
         rsckr+w2xfo4HBQiZdYEovbx9rqW+E//jzL7vokUNqdTXYeUW+IFy8xRpfltwe8nEXDV
         OMUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770416923; x=1771021723;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Io5HDeIklfld3UNsVscq5IsVk6UhJkXyB1ydmVsm80I=;
        b=VCA4LAc3BE7deucIyy7g4zUx7KMd50H753Dui+GqXDGSdd0Y8SuXgr7X5746dSKcYT
         mmSdULmGxOyoVsJAUcVNPGcYWWiukLf6Uh0VkaBxYAYmMwzJUzzCl8eA2CPFBjpLRtWU
         KIN4Jsugg7XNFMwJAeBggkMw3DhOnQ8g55tC+USvYNJEGmGbVUS6KrZngHNm1wHncSDh
         quW1O3S8hqwdEnSiS+Kcm0/RTWaslSfIiNaEAjCvSkeli4mE/OMoN+561x6jG6qvvXk0
         i2yN7Q9S/RIkax31Qui2b0WqYw17L3/DyQ20MsFU3wg4T927ox0j438kLtF4KAAGgqOn
         tRcA==
X-Forwarded-Encrypted: i=1; AJvYcCWjGSVH3Q0ZgzL7eHz8egO9+wmmDiMhGLZok1CfsmiscnelUEwfLlFAwtifwfIZRykBnO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YydFOhEXIJ4mg3cuAv2cHBbCtp0xfOOfBd/qfIZu4wIexi90ida
	34tpU4uVq7aMFtjmA+/+H/cLVq94pzzgEgrp9Dzd8ekJjT6vyDfo1e8nJ6mw9NeQ5UlfRBXTGVV
	GnQ==
X-Received: from jasx4.prod.google.com ([2002:a05:6638:1604:b0:5cb:209d:14f7])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a4a:e911:0:b0:662:e066:7397
 with SMTP id 006d021491bc7-66d0c855e86mr1825095eaf.71.1770416922857; Fri, 06
 Feb 2026 14:28:42 -0800 (PST)
Date: Fri,  6 Feb 2026 22:28:27 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260206222829.3758171-1-sagis@google.com>
Subject: [PATCH v3 0/2] Extend KVM_HC_MAP_GPA_RANGE api to allow retry
From: Sagi Shahar <sagis@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	Michael Roth <michael.roth@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70516-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sagis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 60146103CA5
X-Rspamd-Action: no action

In some cases, userspace might decide to split MAP_GPA requests and
retry them the next time the guest runs. One common case is MAP_GPA
requests received right before intrahost migration when userspace
might decide to complete the request after the migration is complete
to reduce blackout time.

This is v3 of the series, v1[1] and v2[2] were posted as standalone
patches.

Changes from v2:
 * Rebased on top of v6.19-rc8.
 * Updated documentation.
 * Restricted SNP error codes to match TDX restrictions.

[1] https://lore.kernel.org/kvm/20260114003015.1386066-1-sagis@google.com/
[2] https://lore.kernel.org/lkml/20260115225238.2837449-1-sagis@google.com/

Sagi Shahar (1):
  KVM: SEV: Restrict userspace return codes for KVM_HC_MAP_GPA_RANGE

Vishal Annapurve (1):
  KVM: TDX: Allow userspace to return errors to guest for MAPGPA

 Documentation/virt/kvm/api.rst |  3 +++
 arch/x86/kvm/svm/sev.c         | 12 ++++++++++--
 arch/x86/kvm/vmx/tdx.c         | 15 +++++++++++++--
 arch/x86/kvm/x86.h             |  6 ++++++
 4 files changed, 32 insertions(+), 4 deletions(-)

-- 
2.53.0.rc2.204.g2597b5adb4-goog


