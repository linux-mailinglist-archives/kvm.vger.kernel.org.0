Return-Path: <kvm+bounces-69037-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJIJFtR/dGkq6QAAu9opvQ
	(envelope-from <kvm+bounces-69037-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 09:16:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B3B7CF60
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 09:16:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5EFDA30059A2
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 08:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169CA29BDB0;
	Sat, 24 Jan 2026 08:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MUr3LwQI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="srVPLF3Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA408F7D
	for <kvm@vger.kernel.org>; Sat, 24 Jan 2026 08:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769242571; cv=none; b=eU6QHOJJNuEYa+wwz06xibgnJiag6bDQlRSesei3ygHmlqnuOUoGzX5e8/0jwQYezj0+k7Hv3AC5Doofg/a8Z660A5/tNPYHYLTobb8BGGkFA0sEbMfjj1UjjAyjwJHRhpjVjxd5TXhJM5LZrmXQ4+FujqkBAR43B8rBmZwRs6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769242571; c=relaxed/simple;
	bh=lZXAiMHp9ByqhG+GxwWfWy+5V5bbf7B3TNRJqXAsf9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tnp2LSC3ggkRoS3W3x+hAXA6sLhIqgCMcB881vHYZrGffw3xkCPXGG/+6DojgYaGTfVp8U+uKFUqaC7CW7FeFb0I/57NIHgB9c7cFczXqE3cl/Lyxqa/MqFkvwR94WP2kuSGaoHGdGUXfv8N5qPsUlaPk1GUXF2iz5QuVjnzSeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MUr3LwQI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=srVPLF3Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769242568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vOYX5u22UBSevqKjFqwz6TkRwJRLr7HTUzKPczWQ9rI=;
	b=MUr3LwQI09UFK2g77jUsZ+z4URRxZsFFtE1F/FG4YbisNKZimjoRg0Roi9ENSi4PpVvVpJ
	XWirrN4OTFurmMLMqh7odkoJAgNvUSyDp1qBWSY4qOiMGtwygVJbRTfLwjh27y5MOExMO+
	3L8izj8BBG8BDEpExa0w1ZBeKjCqBwA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-TN-1stvKPmWZOI9ejuHA8w-1; Sat, 24 Jan 2026 03:16:05 -0500
X-MC-Unique: TN-1stvKPmWZOI9ejuHA8w-1
X-Mimecast-MFC-AGG-ID: TN-1stvKPmWZOI9ejuHA8w_1769242564
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4359d70faa2so1721807f8f.1
        for <kvm@vger.kernel.org>; Sat, 24 Jan 2026 00:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769242564; x=1769847364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vOYX5u22UBSevqKjFqwz6TkRwJRLr7HTUzKPczWQ9rI=;
        b=srVPLF3QzvfDNCRsvnZ0YdBnB2u9XEB1vCqIUDe0rw7REIUeqbgPl/iOqtmH3iPbj+
         Yf5OejdI++UrTtnhxOjhaUCaJ2/VH7RbT2OQKB5jOZ8EMvioXykHHbsnLpNt7IDNoARe
         Ub8Tq/PBO25vBQeS1DAa0jBOHDr/94Z9JCz95bd1Iqsessy2h67vC9O087pzjN67K0QM
         FHr6n+FrDZomElibLCThdb7/Xh95GZO+sCPayciRvQ47sdi35meuxA0o9DPayI+gwMTI
         Rn3hX+hNTzv+P+LDWv1jyeV0HlKOEgYNGs9iG+lv/GyAge4FVPeys5vethBDSHxkjTaB
         d9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769242564; x=1769847364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOYX5u22UBSevqKjFqwz6TkRwJRLr7HTUzKPczWQ9rI=;
        b=EqbDiYUCKdMYqp0UxRZCOb2ezAo/0q+nFC1k4aXjiM1xDEClmpIOZju7HF3vlOTdnx
         rkrjWOz2h8Oz2tHQ+KeLdBToJ+WqAklHvynQ0s+5VDB1F+9ebU46XB3HJFBEx2ewTzmx
         5+a+L8QSxEy/K+f1W/5ThXc5S6noa5z+AF3wSThhkRMTt7BNl3zxIlIanIpYhY4kN5hU
         Vrg4U7ueiXh2co++OSV9+NnolNdw7jV7sibHSXtm5O0G+8UF5Kjr4e7rGHjU5Q/XTy4B
         WqEuyqEYw9DtYYlM++QUE0gar3RRD46s1nz1rwdYoy56aglxbkSCeYBx+OULSsbzCr/p
         xn4w==
X-Forwarded-Encrypted: i=1; AJvYcCXYypHrkc9e9+EErG40v5yMRNWmBBFxOuTMSVcWNNNVyWarOE2r5nh2OsfdBTXmZPEcG/c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp4U2JCBtwp0X4ifnX/ECQWebDjthdYqD+SlEVedeEHlUjQUlA
	x98NKzN7ny9R0QTWzCdSEvgw7++ZpLQGNZKtUgj9aaInx4GplaVH2ktAIl3NFNHQ9R2oN5S3Ne5
	i64o6g/zL2OMVLVE7Go58PIeuCPoctlnrkKqghXttb3tgglmQHUq0Ug==
X-Gm-Gg: AZuq6aKYv3cP0oTO48x/ZaOJzHDg3IeoNAhgwPYw+UG/1GL7wy2U12Z9v669H651U+W
	zv5v3oJgQjx1SUn79/Hi1Vn/YloH8pi7JRbu9cabnoIsBhXfD2pCIkLhkmZD5/0I5HqAUwHGCGb
	9K2+HNKM2STSkleQq3lnYRhSGuNI4cFFGQ7w3ro5xFux/xIIv0siTrnSbzWFy+gmuvgO2t2VL2f
	oruOF6TPxLBse0cIVftuF2aYLKdTrEgb/Z/9Yzq3Hzcv+VOxDSKaabcVpOFCDl2IHKaP6Jer0K7
	RqbhRI5uiDpjHOH3Sb4Mx+PyEteEl4SgZR7LSJK5/DhqYn/u1LPHlQtGt16FozjkQkAd4ek2CAy
	Fws8HlZ53aBucg5XXIZ+xadiIJ9bos9yzyCkHAM14QqqyhZcKHG31u957NE0vxxq0CWboVP6v+d
	BkfQUTn/MEltIJRA==
X-Received: by 2002:a05:600c:609b:b0:47e:e952:86c9 with SMTP id 5b1f17b1804b1-4804c8ecc6dmr94073185e9.0.1769242563770;
        Sat, 24 Jan 2026 00:16:03 -0800 (PST)
X-Received: by 2002:a05:600c:609b:b0:47e:e952:86c9 with SMTP id 5b1f17b1804b1-4804c8ecc6dmr94072985e9.0.1769242563359;
        Sat, 24 Jan 2026 00:16:03 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-480470cc278sm179966875e9.12.2026.01.24.00.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jan 2026 00:16:02 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.19-rc7
Date: Sat, 24 Jan 2026 09:16:01 +0100
Message-ID: <20260124081601.16453-1-pbonzini@redhat.com>
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69037-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 12B3B7CF60
X-Rspamd-Action: no action

Linus,

The following changes since commit 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7:

  Linux 6.19-rc6 (2026-01-18 15:42:45 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e89f0e9a0a007e8c3afb8ecd739c0b3255422b00:

  Merge tag 'kvmarm-fixes-6.19-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2026-01-24 08:42:14 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.19

- Ensure early return semantics are preserved for pKVM fault handlers

- Fix case where the kernel runs with the guest's PAN value when
  CONFIG_ARM64_PAN is not set

- Make stage-1 walks to set the access flag respect the access
  permission of the underlying stage-2, when enabled

- Propagate computed FGT values to the pKVM view of the vCPU at
  vcpu_load()

- Correctly program PXN and UXN privilege bits for hVHE's stage-1 page
  tables

- Check that the VM is actually using VGICv3 before accessing the GICv3
  CPU interface

- Delete some unused code

----------------------------------------------------------------
Alexandru Elisei (4):
      KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
      KVM: arm64: Inject UNDEF for a register trap without accessor
      KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_hyp()
      KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()

Dongxu Sun (1):
      KVM: arm64: Remove unused vcpu_{clear,set}_wfx_traps()

Marc Zyngier (2):
      KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
      KVM: arm64: Don't blindly set set PSTATE.PAN on guest exit

Oliver Upton (1):
      KVM: arm64: nv: Respect stage-2 write permssion when setting stage-1 AF

Paolo Bonzini (1):
      Merge tag 'kvmarm-fixes-6.19-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Sascha Bischoff (1):
      KVM: arm64: gic: Check for vGICv3 when clearing TWI

Will Deacon (1):
      KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers

 arch/arm64/include/asm/kvm_asm.h        |  2 ++
 arch/arm64/include/asm/kvm_emulate.h    | 16 ----------------
 arch/arm64/include/asm/kvm_pgtable.h    | 16 ++++++++++++----
 arch/arm64/include/asm/sysreg.h         |  3 ++-
 arch/arm64/kernel/image-vars.h          |  1 +
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/at.c                     |  8 ++++++--
 arch/arm64/kvm/hyp/entry.S              |  4 +++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  3 +++
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  1 -
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/pgtable.c            |  5 +++--
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 arch/arm64/kvm/mmu.c                    | 12 +++++-------
 arch/arm64/kvm/sys_regs.c               |  5 ++++-
 arch/arm64/kvm/va_layout.c              | 28 ++++++++++++++++++++++++++++
 17 files changed, 73 insertions(+), 38 deletions(-)


