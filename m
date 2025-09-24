Return-Path: <kvm+bounces-58674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87260B9AD2D
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 18:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45EC319C210A
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8393128AD;
	Wed, 24 Sep 2025 16:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="BCtY3ZkV"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24039312838;
	Wed, 24 Sep 2025 16:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.178.143.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758730524; cv=none; b=GQ+3GqIc8eXcjsgkwPG/EDL2msgDA+szXlXshi+jE/yYy4fsZgcZal5skik/yH+FZ5BFRcF2+ONjbvF6Wd0hxNZYn0fSao0Ori1URkRJbakljD/fw2hHNKOf8C9lYKcVsfID6ZmAytMzSSTKKPTonFxM6X51h6bnf5slv/uwSkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758730524; c=relaxed/simple;
	bh=gAs4jsrpHAQu2tuTZq0JaEc/iHjRGcabUu8W4Wjib6c=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XGvHX+/9UMcwiKvbakX7/0+W5KZWFO3vH4ytayuxgKOnlfOokwTMrFyyNVnKgJ6ArhHHslvlbhWRQqhTuIxEF9dtUa8IlWeiMurxpnhvnkU9D1XVm1JzMCjipjNqcmBIEThwSnMYPYKiIbcbsQV8doE95bZDz35qWi1IEppjOvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=BCtY3ZkV; arc=none smtp.client-ip=63.178.143.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1758730522; x=1790266522;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=gAs4jsrpHAQu2tuTZq0JaEc/iHjRGcabUu8W4Wjib6c=;
  b=BCtY3ZkVoegiWR7W+uxYZ30wQjoECTM1FlBFN8MHaOKJc9017GtFgEy5
   OyNkTvMGiOlvJ1deixbHaqbXsUwoK3Z6Kx9qkmQNI9FF2JU14iu3BSm4Q
   M6ZZAfffNX/eR0+sbZ2ZdWHOlZ79TubFb/gH/fLxphMHADcY1KYiCvAPG
   3sdY8S77k/gAOISbjgh5HIL2pWR+f8jW2GEhBWgEJ2iGM5yv1rLdrFrrW
   u2KhBs1xK/Tnk2iIHzPO2DMr0W/YmFYJAA0iyo8SXwtn+SjjuUN2fcKpO
   9vPBwxFAvTZrONaMfUOnNaWNtZ6Get5lWpG+py+y32gciMLTgjan3OkiJ
   g==;
X-CSE-ConnectionGUID: b1x+cZfDT7OjE/HiZgeAOA==
X-CSE-MsgGUID: GnzEbFGYTkWNN4F82VCqjg==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2516126"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 16:15:11 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:30853]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.43:2525] with esmtp (Farcaster)
 id 01638588-c3c8-4e5f-8145-cf6f65b4dd3e; Wed, 24 Sep 2025 16:15:11 +0000 (UTC)
X-Farcaster-Flow-ID: 01638588-c3c8-4e5f-8145-cf6f65b4dd3e
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 16:15:10 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 16:15:07 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <kbusch@kernel.org>,
	<benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
	<pravkmr@amazon.de>, <nagy@khwaternagy.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/7] vfio/pci: add RCU locking for regions access
In-Reply-To: <20250924141018.80202-4-mngyadam@amazon.de> (Mahmoud Adam's
	message of "Wed, 24 Sep 2025 16:09:54 +0200")
References: <20250924141018.80202-1-mngyadam@amazon.de>
	<20250924141018.80202-4-mngyadam@amazon.de>
Date: Wed, 24 Sep 2025 18:15:03 +0200
Message-ID: <lrkyqldm3zv20.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: EX19D037UWC002.ant.amazon.com (10.13.139.250) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)


..Having a second look on the rcu read sections. Some of these read
sections could sleep/block. simple RCU with these sections will not
work. Need to fix this on the next send.

-MNAdam



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


