Return-Path: <kvm+bounces-72147-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wE+cF8uRoWmvuQQAu9opvQ
	(envelope-from <kvm+bounces-72147-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:44:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B02AC1B7510
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0C2531E407B
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 12:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1992399026;
	Fri, 27 Feb 2026 12:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGETGO3J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED0421772A;
	Fri, 27 Feb 2026 12:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772195821; cv=none; b=VOG6h75MwKYY3u/+cLEkOvxYeML5tb0DJ9nwPcUx685Upn7v/lon1924yshW2wrR2AETUebdpIQQcZ8yizjjpXB0SY0cbgB9/M9aRl6yuicP81JJVKGJspNQolDpIIEmb9yrE2Hs9wNNzGWa2nvzjM4V3dcrC+J3s9SEwFtyu1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772195821; c=relaxed/simple;
	bh=dsee9eRlHaKPY3/htEY7eYUTcjs6v6upQYrzS0dDUus=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VVOQ56pKxflEQxoHZbRqHhFwX893zsapKg7g5ku1SV99YBMJ5uexdgWVL28imuuRP6Lq8MGFSdB1NT//4uoruS4zVRIrl/XFhCWZPC+D4BSIL3lR95rnpkGzUwwqUH1stA5qZ4YRpJDp+X+BxvCx3v7hb+6QAOpImeMW8tYXUNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGETGO3J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EA7C116C6;
	Fri, 27 Feb 2026 12:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772195820;
	bh=dsee9eRlHaKPY3/htEY7eYUTcjs6v6upQYrzS0dDUus=;
	h=From:To:Cc:Subject:Date:From;
	b=WGETGO3JBTefW1vOvnYv3JF00EwegeaUPWNDmob4fWwcFSDNAfhxVGEydPYrZh2yW
	 WWrCdZco5wY/d8fVQnf0eO21CXZPwm7l25FBxG3LfAQNBBHe5jX3MWB+XqZGNMOseH
	 xClpJrMMUdjHK3Uk9Yj5yF3upd4nUHZCR20LEZWsIHcvC1AbSZDbNHTlfggFRUJBdx
	 jMADBpStQytFhRd8qwINWIbuVfgYHWWL9i7SVnNQ0G2jyZ2Komg0P/lP76FHGO6oj/
	 WWQBTPuEUfNPhTggHUaQY5qTc+hR5rdQCS9DZ/8BlK/kX1dN1ZhFwv4lcuknKvS3M9
	 DpQasjwlrFFgQ==
From: Bjorn Helgaas <helgaas@kernel.org>
To: linux-pci@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Alex Williamson <alex@shazbot.org>
Cc: Baruch Siach <baruch@tkos.co.il>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] PCI: Correct PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value
Date: Fri, 27 Feb 2026 06:36:53 -0600
Message-ID: <20260227123653.3891008-1-bhelgaas@google.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72147-lists,kvm=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[helgaas@kernel.org,kvm@vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,tkos.co.il:email,infradead.org:email]
X-Rspamd-Queue-Id: B02AC1B7510
X-Rspamd-Action: no action

fb82437fdd8c ("PCI: Change capability register offsets to hex") incorrectly
converted the PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value from decimal 52 to hex
0x32:

  -#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 52      /* v2 endpoints with link end here */
  +#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 0x32    /* end of v2 EPs w/ link */

Change PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 to the correct value of 0x34.

fb82437fdd8c was from Baruch Siach <baruch@tkos.co.il>, but this was not
Baruch's fault; it's a mistake I made when applying the patch.

Fixes: fb82437fdd8c ("PCI: Change capability register offsets to hex")
Reported-by: David Woodhouse <dwmw2@infradead.org>
Closes: https://lore.kernel.org/all/3ae392a0158e9d9ab09a1d42150429dd8ca42791.camel@infradead.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 include/uapi/linux/pci_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index ec1c54b5a310..14f634ab9350 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -712,7 +712,7 @@
 #define  PCI_EXP_LNKCTL2_HASD		0x0020 /* HW Autonomous Speed Disable */
 #define PCI_EXP_LNKSTA2		0x32	/* Link Status 2 */
 #define  PCI_EXP_LNKSTA2_FLIT		0x0400 /* Flit Mode Status */
-#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	0x32	/* end of v2 EPs w/ link */
+#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	0x34	/* end of v2 EPs w/ link */
 #define PCI_EXP_SLTCAP2		0x34	/* Slot Capabilities 2 */
 #define  PCI_EXP_SLTCAP2_IBPD	0x00000001 /* In-band PD Disable Supported */
 #define PCI_EXP_SLTCTL2		0x38	/* Slot Control 2 */
-- 
2.51.0


