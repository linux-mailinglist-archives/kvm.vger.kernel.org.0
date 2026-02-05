Return-Path: <kvm+bounces-70309-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGAANFZHhGk/2QMAu9opvQ
	(envelope-from <kvm+bounces-70309-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 08:31:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 94ED6EF6FE
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 08:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3C1D83019443
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 07:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63ED335771D;
	Thu,  5 Feb 2026 07:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FxSNuemR"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9EA3EBF0E;
	Thu,  5 Feb 2026 07:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770276681; cv=none; b=CTGJuFgfLN8C2TMhtcHFZ3yZFCvd/ByYG0hbZ2I6WNn2g/CzVBSDflR3E1wLXbEBXjnF3dTJtp5IOaS/p5+1MmNMMjIeifKW7aDTZmPuFO31TzW9ycG743a0mC/ANXz6NYNSyL0GyYLfMupI8TF7q1TkqOyu8rPxByybmjnRf1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770276681; c=relaxed/simple;
	bh=gmnXir8a0Af905VCHGr3Turgp544D4Y/HL7wc/XJ26Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mTtNhoB0SC/juLiYSo7XOnzN8i0VnP/nRHaXvbW9VopeBHcKBnDkUbCEqmGmzucpR3Z1yTB/J4iQxSvpUxOB+WjGj4hdCF/2vgwKo6DaQ4L+pXPdFlRV7uxgNk6hzBzSD4q5EGxHlF6lKvGuqxn2tVol4+WRs3A2En1Dfn+aC2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FxSNuemR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=HzpHbgQPEOE/OZ8ppEkUfABhIP7OOPHs+lKkLu7Tvz0=; b=FxSNuemRDOlySafxufHByfKh0q
	yCo5qVwZqnZHwqH1HyXsrsp+V7lpjxLK2hJG1X2BbxW+INFdnFv1kkRzThUHu7VNjr7ehLX48Dtin
	VPqWEzrb4xpdLpLuNzOhm6VbsrbQfXyrVHsbtVGepmLghrhr0/3ETVo5NL4QyS9BFA8zBzTSuRGfz
	FPADV1Hj3qq9eAhRi2h3PuEyB+G/kXrLLXXcUhJWYKIpQw211aTJ0f99kUf4gbT9CWxMQ4bWjVmFl
	yOlmaWJXNHBOvm5wy58v7k4CGyb1LZiNKlkfWQZKl+kFUcVfIf22T3LaWWpmB4o0mWjiIsSTVBhIc
	b8X+UrOg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vntpg-00000009Ydn-2Hjq;
	Thu, 05 Feb 2026 07:31:20 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	kvm@vger.kernel.org,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-s390@vger.kernel.org
Subject: [PATCH v2] s390: remove kvm_types.h from Kbuild
Date: Wed,  4 Feb 2026 23:31:19 -0800
Message-ID: <20260205073119.1886986-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70309-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rdunlap@infradead.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,infradead.org:email,infradead.org:dkim,infradead.org:mid]
X-Rspamd-Queue-Id: 94ED6EF6FE
X-Rspamd-Action: no action

kvm_types.h is mandatory in include/asm-generic/Kbuild so having it
in another Kbuild file causes a warning. Remove it from the arch/
Kbuild file to fix the warning.

../scripts/Makefile.asm-headers:39: redundant generic-y found in ../arch/s390/include/asm/Kbuild: kvm_types.h

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: add more Cc:s

Cc: kvm@vger.kernel.org
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: linux-s390@vger.kernel.org

 arch/s390/include/asm/Kbuild |    1 -
 1 file changed, 1 deletion(-)

--- linux-next-20260202.orig/arch/s390/include/asm/Kbuild
+++ linux-next-20260202/arch/s390/include/asm/Kbuild
@@ -5,6 +5,5 @@ generated-y += syscall_table.h
 generated-y += unistd_nr.h
 
 generic-y += asm-offsets.h
-generic-y += kvm_types.h
 generic-y += mcs_spinlock.h
 generic-y += mmzone.h

