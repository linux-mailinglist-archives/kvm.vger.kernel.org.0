Return-Path: <kvm+bounces-41109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89200A6197B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 19:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D23A7A9E6A
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361C3204598;
	Fri, 14 Mar 2025 18:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q9QGTG9f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62D82E3389
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 18:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741977269; cv=none; b=mh/5Qx1iIhADlHYr7dlEEjnYT9iRoAWNDP7XOCjaOy9FzcYc41SpD4h31OyoQbwhnBtD1+t2la+awibmw7ZEXhyd4GZgnFqcIPwwmeZ2BYVTIfWhg10mx+nIWb5ZUO8cNwdCowgYj0kgjD/gSu9fJlZ3yGqhq2/C+fkxqybhqbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741977269; c=relaxed/simple;
	bh=CVLyX9R2vJXFh5cDZ/zHtgs3Y5yJU7mVlCHIs3KI11A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fpNyRQ+JJLorMgCgS20zZNPEvIYuFXc+eTCtC/We/jltRrHkHiLobozGI630fYk0DUGrbyfPe88MCbPJcWBnlcEoFK5cOyQFIJmyidhtiZ+ZqUqimdZqeC3VWZf10Z4EoLO7pMYerKhuXgifLEnjGpRNsClu+U+nx51eYyKo82M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q9QGTG9f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741977266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HK5sLkunXapSB/dnyvvTD+u7UXC4kRvUIomHQWQCwCU=;
	b=Q9QGTG9f/v3vyoBEKX+8DmW/BpZvskUJINyty7u57g6EThKkMSft9nwrm57WL+y+xywv3+
	b3f1kWGin6juNk+CIrRxygwkVgXcwm6F7meTW+OeM5rftcoAJRXiG8cYvOrHfReSHegruv
	uqBxM2OPwiZWfmJQDyQF+2jEC4hORao=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-3LI3WcWZP4yIzNr6iUDMXA-1; Fri,
 14 Mar 2025 14:34:25 -0400
X-MC-Unique: 3LI3WcWZP4yIzNr6iUDMXA-1
X-Mimecast-MFC-AGG-ID: 3LI3WcWZP4yIzNr6iUDMXA_1741977264
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 310DF19560B0;
	Fri, 14 Mar 2025 18:34:24 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5D8E31801747;
	Fri, 14 Mar 2025 18:34:23 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	nikunj@amd.com
Subject: [PATCH v2 0/2] KVM: x86: Support protected TSC
Date: Fri, 14 Mar 2025 14:34:20 -0400
Message-ID: <20250314183422.2990277-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

These are the two patches from Isaku that were posted last October and
which can be used for AMD's secure TSC as well..  I will rebase TDX on
top of these in kvm-coco-queue, because these can be included in 6.15.

Paolo

Supersedes: <cover.1728719037.git.isaku.yamahata@intel.com>

Isaku Yamahata (2):
  KVM: x86: Push down setting vcpu.arch.user_set_tsc
  KVM: x86: Add infrastructure for secure TSC

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 23 +++++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

-- 
2.43.5


