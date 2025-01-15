Return-Path: <kvm+bounces-35525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D97A11F55
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 11:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C96416856C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 10:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F28241684;
	Wed, 15 Jan 2025 10:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b="y42NWyW2"
X-Original-To: kvm@vger.kernel.org
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B80523F280
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.40.203.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736936806; cv=none; b=lpB7zZxJojbQaLMpL5wS0Ly+SofI7BWhaU8foVEDF9YDtvVecj1lzitw//sPANYChLRj71PasMIiypA+QpWxVAYGUrStFBTZCD3oagfoXKBQ0+cmMxyxio5pMNQwbIgkuCSVi2s1cGCtUoW+0FbopS0KdQ7+FzZbqXERSNK0rBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736936806; c=relaxed/simple;
	bh=o/xRBId6vd12ckPbFLIQDQYVFNxDL/A9W5X5L7wQTJw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qsaBbdCCk/bEQzft3xEiqCErRXAkt6ERly3oZhY+6wT6rH5GpLLbUvfRJKFuvhBbMe9eoa5fy6sJNwEQNpc8zx8fL6gncmpNi8d2MicSHl+s4dLZHHX+0ZM4CzBqWAW+ndZmejomYjWAjvQFnhUmWCOqeGmnsOiFxcFPlCx1fSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk; spf=pass smtp.mailfrom=codethink.com; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=y42NWyW2; arc=none smtp.client-ip=188.40.203.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codethink.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SboxPYOGaDW0P/C1VXXtvnKtK1CsOM3SpCK2pkDime8=; b=y42NWyW2+5eJmuLmDP+j5554Sw
	VN5NfBZ2IzmOUpZWRNe6EtgeR96RgxAMmQFZkA/LR3075WBwSpojdgXL0EAw+O9zPDLkLSssv31j8
	49pklMZ1sHO3D0VESxNaC0fNeW6To/2Mf/rqpDqIwfB1bt66HQLV03kvhp4RB+bzjtEo4Nf7SMQsB
	VNw3kCxuJeLhds+zxS54N5W7dX5FnXIQX65AsRScKK3OVPgKUTa1eBmQX0KOOHVpj5Gxnd3pmMG/q
	7I0IQUo/CkA7CP3pV5pJwLTbbJOuJ8f7BgxhQ2y9XtydyACPwhDRElh8vX7UXKlVcI2X352GRK64J
	IsBhOyag==;
Received: from [63.135.74.212] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1tY0Mx-000X88-Na; Wed, 15 Jan 2025 10:11:27 +0000
Received: from ben by rainbowdash with local (Exim 4.98)
	(envelope-from <ben@rainbowdash>)
	id 1tY0Mx-00000002Cy1-18ZK;
	Wed, 15 Jan 2025 10:11:27 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: kvm@vger.kernel.org
Cc: felix.chong@codethink.co.uk,
	lawrence.hunter@codethink.co.uk,
	roan.richmond@codethink.co.uk,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH kvmtool] kvmtool: virtio: fix endian for big endian hosts
Date: Wed, 15 Jan 2025 10:11:25 +0000
Message-Id: <20250115101125.526492-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: srv_ts003@codethink.com

When running on a big endian host, the virtio mmio-modern.c correctly
sets all reads to return little endian values. However the header uses
a 4 byte char for the magic value, which is always going to be in the
correct endian regardless of host endian.

To make the simplest change, simply avoid endian convresion of the
read of the magic value. This fixes the following bug from the guest:

[    0.592838] virtio-mmio 10020000.virtio: Wrong magic value 0x76697274!

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 virtio/mmio-modern.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virtio/mmio-modern.c b/virtio/mmio-modern.c
index 6c0bb38..fd9c0cb 100644
--- a/virtio/mmio-modern.c
+++ b/virtio/mmio-modern.c
@@ -66,7 +66,10 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
 		return;
 	}
 
-	*data = cpu_to_le32(val);
+	if (addr != VIRTIO_MMIO_MAGIC_VALUE)
+		*data = cpu_to_le32(val);
+	else
+		*data = val;
 }
 
 static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
-- 
2.37.2.352.g3c44437643


