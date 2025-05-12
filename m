Return-Path: <kvm+bounces-46175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C6DEAB3A11
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 16:09:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E9EC19E040F
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 14:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31CF1E3769;
	Mon, 12 May 2025 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="s9KQ4ByV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FAE1E32D7
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 14:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747058964; cv=none; b=Zv1rUDrh5Rxh21lIbDC8GfOapPrai6rxDGiAOip0aL0a8zlPOx0mBVXP5b2BqorteAnx0DgWlv6M6rWrYIwTBI+9JyS+eDqC7CROWaqzTjFR7AZcyP6ANYGNzc9lXkLUqa0n6Wdy3riNbMPYvkKqeD2ZzFoIVRElewB7QR0CJ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747058964; c=relaxed/simple;
	bh=bs0KT0uEopTREFIV09FXprEMp4r+yb1cp38ev0pRS7o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XZd5qwzHbQsT+uF8wVlrtdikXDAfbNwMvfEoTzUxr6GXev4LBxHCZsbaZdSB06QOUSk5huQcvQ99HxymEj1rx05kge6CWT15f52I6o6BQLGTtbaJ0Tn7vvYV8XeBbpCwbaBFxA6fLjDL6yVTOfqyAN/fJ2vVxTDtr0EjB677KE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=s9KQ4ByV; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1747058963; x=1778594963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bs0KT0uEopTREFIV09FXprEMp4r+yb1cp38ev0pRS7o=;
  b=s9KQ4ByVZwCtw8FnIG6rzV6PwIa71HAg9AGlviS8njwPznNMUB1hH9Rr
   o+xyeWd0F6UxHAtUurb9meYdifM9rgt+78ztOBdw7OoOD+KumGmftyuIA
   kxqw7IHz+pGVMVoPEjbCEYLm1FHI+XrR0GdCV8MEAAskSuc5J3T4mwjWo
   7p7NkvrsqZDaxBmTtBWEOtDqbDp2cnpOC0yPFjp9Ohhq0zPbe3RqOHqBn
   716x7QrSh5CwRKrAhif8kpLbey8utMbdge8Nb25YyjrF+ofEJL5/GCHw4
   JD8IteHfcPMHy8UjujvJHjEt3/9G2GeNsUvlZHhg1RvfRd3WEjtG39n4E
   w==;
X-IronPort-AV: E=Sophos;i="6.15,282,1739836800"; 
   d="scan'208";a="489002478"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 14:09:19 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:46847]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.21.215:2525] with esmtp (Farcaster)
 id d1c2ccfc-6936-4d2e-9e97-d566a0803f65; Mon, 12 May 2025 14:09:19 +0000 (UTC)
X-Farcaster-Flow-ID: d1c2ccfc-6936-4d2e-9e97-d566a0803f65
Received: from EX19D023EUB003.ant.amazon.com (10.252.51.5) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 12 May 2025 14:09:18 +0000
Received: from dev-dsk-dssauerw-1b-2c5f429c.eu-west-1.amazon.com
 (10.13.238.31) by EX19D023EUB003.ant.amazon.com (10.252.51.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1544.14; Mon, 12 May 2025 14:09:13 +0000
From: David Sauerwein <dssauerw@amazon.de>
To: <jingzhangos@google.com>
CC: <andre.przywara@arm.com>, <coltonlewis@google.com>, <eauger@redhat.com>,
	<jiangkunkun@huawei.com>, <joey.gouly@arm.com>, <kvm@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<lishusen2@huawei.com>, <maz@kernel.org>, <oupton@google.com>,
	<pbonzini@redhat.com>, <rananta@google.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <graf@amazon.com>, <nh-open-source@amazon.com>
Subject: Re: [PATCH v4 5/5] KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE
Date: Mon, 12 May 2025 14:09:09 +0000
Message-ID: <20250512140909.3464-1-dssauerw@amazon.de>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241107214137.428439-6-jingzhangos@google.com>
References: <20241107214137.428439-6-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D036UWC003.ant.amazon.com (10.13.139.214) To
 EX19D023EUB003.ant.amazon.com (10.252.51.5)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jing,

After pulling this patch in via the v6.6.64 and v5.10.226 LTS releases, I see
NULL pointer dereferences in some guests. The dereference happens in different
parts of the kernel outside of the GIC driver (file systems, NVMe driver,
etc.). The issue only appears once every few hundred DISCARDs / guest boots.
Reverting the commit does fix the problem. I have seen multiple different guest
kernel versions (4.14, 5.15) and distributions exhibit this issue.

The issue looks like some kind of race. I think the guest re-uses the memory
allocated for the ITT before the hypervisor is actually done with the DISCARD
command, i.e. before it zeros the ITE. From what I can tell, the guest should
wait for the command to finish via its_wait_for_range_completion(). I tried
locking reads to its->cwriter in vgic_mmio_read_its_cwriter() and its->creadr
in vgic_mmio_read_its_creadr() with its->cmd_lock in the hypervisor kernel, but
that did not help. I also instrumented the guest kernel both via printk() and
trace events. In both cases the issue disappears once the instrumentation is in
place, so I'm not able to fully observe what is happening on the guest side.

Do you have an idea of what might cause the issue?

David



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


