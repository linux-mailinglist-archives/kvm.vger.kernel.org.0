Return-Path: <kvm+bounces-2761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 285507FD835
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:34:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54B4B1C20E6D
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 13:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3D1C208C5;
	Wed, 29 Nov 2023 13:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Pa0EKVY0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2931DB0;
	Wed, 29 Nov 2023 05:33:52 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C08DD1FCF3;
	Wed, 29 Nov 2023 13:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1701264830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Qd/edhp+5962psCPMPy4XP3r2u443myO08oYjOHlTLA=;
	b=Pa0EKVY0qxxUd5ai3BkeXQ5O36LsXwze2YUAWSo+uhiqrqu+qQnOMc08tb752X/3bhkI4m
	zYIZAMIQnrocT+NXv0m6eFE9HhHgm/vc2JCCLVRkIuKeW6Gq8NZCOTCDWChK+a1azg+4be
	jXG4Qt7cAEBdPBvNbmAiVU1MYGGsVv0=
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D8461376F;
	Wed, 29 Nov 2023 13:33:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id tvlGEb49Z2V6HwAAn2gu4w
	(envelope-from <jgross@suse.com>); Wed, 29 Nov 2023 13:33:50 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Ajay Kaher <akaher@vmware.com>,
	Alexey Makhalov <amakhalov@vmware.com>,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 0/5] 86/paravirt: Get rid of paravirt patching
Date: Wed, 29 Nov 2023 14:33:27 +0100
Message-Id: <20231129133332.31043-1-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: 0.90
X-Spamd-Result: default: False [0.90 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 RCPT_COUNT_TWELVE(0.00)[18];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]

This is a small series getting rid of paravirt patching by switching
completely to alternative patching for the same functionality.

The basic idea is to add the capability to switch from indirect to
direct calls via a special alternative patching option.

This removes _some_ of the paravirt macro maze, but most of it needs
to stay due to the need of hiding the call instructions from the
compiler in order to avoid needless register save/restore.

What is going away is the nasty stacking of alternative and paravirt
patching and (of course) the special .parainstructions linker section.

I have tested the series on bare metal and as Xen PV domain to still
work.

Note that objtool might need some changes to cope with the new
indirect call patching mechanism. Additionally some paravirt handling
can probably be removed from it.

Changes in V5:
- addressed Boris' comments
- rebased on top of the tip/master branch

Changes in V4:
- addressed Boris' comments in patch 1
- fixed bugs found by kernel test robot (patch 2)

Changes in V3:
- split v2 patch 3 into 2 patches as requested by Peter and Ingo

Changes in V2:
- split last patch into 2
- rebase of patch 2 as suggested by Peter
- addressed Peter's comments for patch 3

Juergen Gross (5):
  x86/paravirt: introduce ALT_NOT_XEN
  x86/paravirt: move some functions and defines to alternative
  x86/alternative: add indirect call patching
  x86/paravirt: switch mixed paravirt/alternative calls to alternative_2
  x86/paravirt: remove no longer needed paravirt patching code

 arch/x86/include/asm/alternative.h        |  30 +++++-
 arch/x86/include/asm/paravirt.h           |  77 ++++---------
 arch/x86/include/asm/paravirt_types.h     |  85 +++++----------
 arch/x86/include/asm/qspinlock_paravirt.h |   4 +-
 arch/x86/include/asm/text-patching.h      |  12 ---
 arch/x86/kernel/alternative.c             | 125 ++++++++++------------
 arch/x86/kernel/callthunks.c              |  17 ++-
 arch/x86/kernel/kvm.c                     |   4 +-
 arch/x86/kernel/module.c                  |  20 +---
 arch/x86/kernel/paravirt.c                |  54 ++--------
 arch/x86/kernel/vmlinux.lds.S             |  13 ---
 arch/x86/tools/relocs.c                   |   2 +-
 arch/x86/xen/irq.c                        |   2 +-
 13 files changed, 161 insertions(+), 284 deletions(-)

-- 
2.35.3


