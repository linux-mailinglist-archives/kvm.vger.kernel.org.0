Return-Path: <kvm+bounces-73289-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MDi+JGO/rmlEIgIAu9opvQ
	(envelope-from <kvm+bounces-73289-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 13:38:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F09238F79
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 13:38:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C1E3D301E7D2
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 12:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869FD3AEF52;
	Mon,  9 Mar 2026 12:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NaOyQSgo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D42A3ACF1E
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 12:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773059930; cv=none; b=IhYxzUGJpqHnHfRpOnC2dPWNAT5i1HHZr7Eve57l3mW6vgm9hoT0w/UhN7EHTzynCwCfsQh3+e2I/WW9PlqnWlXz9WLqRUCR0Iu8Sb9QhS9u97zrOYKdgtTDKLq+H0u2HC6C53pUm9+CrBqyPqMCUYzw4JVWniQrgxTqF3HIpaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773059930; c=relaxed/simple;
	bh=V3EMYBRqyzEJ6Vju6UtCEtdyL7830YWzE0P9moZtzbY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=R5DMomsYdDb1iKGK9AWm5NP9/UhacnTsam5erG5AlvgoZ8F2je3Gb+Xi8TMEi3wEIFcqR8fW9LkuRrhFFLxAS8yQxlCYDQ1b08SbbVHtT5PrBcoi5GuQ8pyz1GXYnrzvr/ndeJj3xFISdWMFgTOsEdx4QrIYHG/TdHBSjS2UuXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NaOyQSgo; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ae4e538abdso78198345ad.3
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 05:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773059929; x=1773664729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vew/51ISuWV8SVa/aQVcC7dheArZhsg+HjWKeDYSuPQ=;
        b=NaOyQSgoc17brGUkP0ONppVOid7BA66qMGKMay7yvtmWEZ+LIOrSBq1qRuE6IrZDo4
         RDN5OVrpYafXEIfgRQdHhLx3671bay7Xtzus3hOZ9cy2XG7ji23DssWbrW7JLWbT1m2G
         6nkFwC90m5mi3/ZafeNb0vnXdioeVLWLkKp1Z2o3hy9ZqbwATXI8mQgALU6JvJBpYErP
         sw+PzENfL8yX9apzXv+02E2HfV/yeS4SwyfXSocsfU556SqT76YN1oB0cYS7sZSdFN1D
         g71pr/+Ahdzy/6XlTe77Z1g6oljeWQ6bZBsOmFuPq0PDItRazlwq9ckzAe4ulusQz6E/
         +tIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773059929; x=1773664729;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vew/51ISuWV8SVa/aQVcC7dheArZhsg+HjWKeDYSuPQ=;
        b=oaWifLdknkm7X2HCNzQC5L/B6pYH+kgA6aywEQtLcFNmE5kfZxuveiFNnhaVQeqtHn
         XxQ5VG/rt8+yXbAEwPnAul94MW9IN7rmoZI1ZDhHP0TYNr9Er0zsWEoX0U8kWfm3LVdf
         oJKqP1CIzhUO3pOFj2IYkhcM6CvME37gNHl57h4amY9KJhoqbg+dr4NS+9cDDjcVa8N+
         t+VBGvvzLm4c0KbVrt4aCJGEnXPO6wVItCEMI8V7SQZp/KfmURox7tfcm4Q3McnV4l3B
         reKpTNImT2eculUD53qlbCk1nVZoXwNa5yUYDCvA1lDan5D0LjJBCqTmgfd9HdLFuVXi
         Znhg==
X-Forwarded-Encrypted: i=1; AJvYcCUhPHpO1BuUQ8/kOaHnXDSlpTsLcwlAPr2Pk1Nbn+ZLltP2xCxk3PNfgL3jXM8jIpuo9to=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzkqt56MMzKrLf6iJQvuraPeLqib7rYYAbwCPm6TMZiHjf3usTQ
	Vm/hkhqc+3Ylo50SqeKNyZ8KjfWQFsr1Vv6uG5lHkDQF5uHgtHoHMHFv
X-Gm-Gg: ATEYQzwrdhc9J2fKgt4A8SlClt8JlDrAwl+Gtx7pvpRsL0Bt0rq2pYd8ZnrG1DyBHb9
	krYDhycW9cAydibbcJ+zZrX9xhMUB2A9soZoANhPK0YQGxwBJDHkD3JuwXvNm7PCQV5nksv/Z/D
	3OXaxGnn0TvvYqKfmcXjxarzoEiu5TwSHAWwmthlgIt//be7D9OxU2VUCNRf/O/75F4Yuydxbmd
	I5WzN+fzL5K2u8dvBhRebBuwCZLVhBfI4245Au6CMBhAycagfRv5eH1x6qvAF5zdt2nD63BqzS5
	V0g20WY/FJj29hi643Bn/0yI0yA0Jzsr5R3xMGFmyjIblG/2BBF5uK2gmG5rNt5qTxrwRJtLngU
	E98B6Xp1PD6o5qslYQ0GrK1ftMCnjYMHcgw43771lHJ6RDo1T7m8uyEmqpHE+j3Poq3Up33VazA
	aA7o6juT48FKVldMLMByO36sthhZlLCPCllVk70CQ=
X-Received: by 2002:a17:903:388f:b0:2ae:50a3:3aa5 with SMTP id d9443c01a7336-2ae824879a7mr107552435ad.52.1773059928817;
        Mon, 09 Mar 2026 05:38:48 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83eafc64sm154867375ad.40.2026.03.09.05.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 05:38:48 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Christophe Leroy <chleroy@kernel.org>,
	linux-mm@kvack.org,
	kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	Peter Xu <peterx@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v2 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from switch case to if/else block
Date: Mon,  9 Mar 2026 18:08:37 +0530
Message-Id: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01F09238F79
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux.ibm.com,kernel.org,kvack.org,vger.kernel.org,shazbot.org,redhat.com,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73289-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[riteshlist@gmail.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.977];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Architectures like PowerPC uses runtime defined values for
PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
at runtime using kernel cmdline. So the pXd_index_size is not known at
compile time. Without this fix, when we add huge pfn support on powerpc
in the next patch, vfio_pci_core driver compilation can fail with the
following errors.

  CC [M]  drivers/vfio/vfio_main.o
  CC [M]  drivers/vfio/group.o
  CC [M]  drivers/vfio/container.o
  CC [M]  drivers/vfio/virqfd.o
  CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
  CC [M]  drivers/vfio/pci/vfio_pci_core.o
  CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
  CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
  CC [M]  drivers/vfio/pci/vfio_pci_config.o
  CC [M]  drivers/vfio/pci/vfio_pci.o
  AR      kernel/built-in.a
../drivers/vfio/pci/vfio_pci_core.c: In function ‘vfio_pci_vmf_insert_pfn’:
../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not reduce to an integer constant
 1678 |         case PMD_ORDER:
      |         ^~~~
../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not reduce to an integer constant
 1682 |         case PUD_ORDER:
      |         ^~~~
make[6]: *** [../scripts/Makefile.build:289: drivers/vfio/pci/vfio_pci_core.o] Error 1
make[6]: *** Waiting for unfinished jobs....
make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2

Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
v1 -> v2:
1. addressed review comments from Christophe [1]
[1]: https://lore.kernel.org/linuxppc-dev/0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com/

 drivers/vfio/pci/vfio_pci_core.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d43745fe4c84..0967307235b8 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1670,21 +1670,16 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		return VM_FAULT_SIGBUS;

-	switch (order) {
-	case 0:
+	if (!order)
 		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
-	case PMD_ORDER:
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
 		return vmf_insert_pfn_pmd(vmf, pfn, false);
-#endif
-#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
-	case PUD_ORDER:
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PUD_ORDER)
 		return vmf_insert_pfn_pud(vmf, pfn, false);
-		break;
-#endif
-	default:
-		return VM_FAULT_FALLBACK;
-	}
+
+	return VM_FAULT_FALLBACK;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);

--
2.39.5


