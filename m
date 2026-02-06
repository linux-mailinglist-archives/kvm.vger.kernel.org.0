Return-Path: <kvm+bounces-70425-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SOhANEmyhWmbFQQAu9opvQ
	(envelope-from <kvm+bounces-70425-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 10:20:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7183DFBF12
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 10:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F3BA93037D7B
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 09:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEE935CB86;
	Fri,  6 Feb 2026 09:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GsPusBj+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5B431812E;
	Fri,  6 Feb 2026 09:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770369477; cv=none; b=geU/1hItjedC4L2lqor7XQDyYfwKYnJF2zj3ME5t/LmrlftMlaqxPTAfIITT0PICJQ/dQU8d5akgLzw6NJlprXnR5HMHv0pJjvny1W8w8h6ftt95eB4tqrTZPDB64sHYV/buA0vYEM7NtF9QAb3IoSREc4ygrYPqA1YdnWXsOTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770369477; c=relaxed/simple;
	bh=GqD/vZKOrvhwAYc4AgJtxZJK0os97VUYTFCsqdXb+Tc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j2cZy4A0C8LY8lK3iGZUkmvuZWGUqhH09MUOjBMkE8+XBG3cfTteUGEu3GB9Gy1WDeMkyY5Y3tIvaB1enmqapPkumaFtVJx20znLITw6e1f9UvQu/lJK3x67J5BOH76qYkl74z5COoWb2YmnMzXHjWUx27g8jZUsrX4WtqspiHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GsPusBj+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E68DC116C6;
	Fri,  6 Feb 2026 09:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770369476;
	bh=GqD/vZKOrvhwAYc4AgJtxZJK0os97VUYTFCsqdXb+Tc=;
	h=From:To:Cc:Subject:Date:From;
	b=GsPusBj+hBQuSztv5zfRYAGi1LPV5Yekxu0Cs2rQJhh0qqxpUErU0CY5W97lUg2EJ
	 +v8vDX0A2vMGTzQ6iL8H/n/SV3JYMLmfrv2n5TCpYsy2BqIcf7oo4QpPm8XCup/gEe
	 CL3BBXMWRoaK83Bruut5ZeYZX2kLU6ccs/WtLlJ4x+d263PoHfjhcB/flBuma+nb/M
	 tN+tVt+HHqiSW9QZwiI1Pm6xsjPYD6eYWWUoyfhkDhOm7LQ3/aI7k5izhE8XZjle+s
	 XQQdNK5QHl/5ACAhmbtZDCI50+sDtKO9MlEuPwFJJe5p84z5hh9PwRq0dKbkx6O1M8
	 001BIKbVvPFlQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Oliver Upton <oupton@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Anup Patel <anup@brainfault.org>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Marc Zyngier <maz@kernel.org>,
	Jiaqi Yan <jiaqiyan@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: add explicit padding to struct kvm_s390_keyop
Date: Fri,  6 Feb 2026 10:17:30 +0100
Message-Id: <20260206091751.3973615-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
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
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70425-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[arnd@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arndb.de:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7183DFBF12
X-Rspamd-Action: no action

From: Arnd Bergmann <arnd@arndb.de>

The newly added structure causes a warning about implied padding:

./usr/include/linux/kvm.h:1247:1: error: padding struct size to alignment boundary with 6 bytes [-Werror=padded]

The padding can lead to leaking kernel data and ABI incompatibilies
when used on x86. Neither of these is a problem in this specific
patch, but it's best to avoid it and use explicit padding fields
in general.

Fixes: 0ee4ddc1647b ("KVM: s390: Storage key manipulation IOCTL")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I have a long series to add annotations to all existing structures,
but that will take a while. For now, I'm sending fixes when new
instances show up in linux-next.
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a68b1741045c..1225fbd017e5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1255,6 +1255,7 @@ struct kvm_s390_keyop {
 	__u64 guest_addr;
 	__u8  key;
 	__u8  operation;
+	__u8  pad[6];
 };
 
 /*
-- 
2.39.5


