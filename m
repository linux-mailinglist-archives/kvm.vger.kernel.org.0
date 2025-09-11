Return-Path: <kvm+bounces-57292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DAE6B52E17
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 12:13:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CA853AE25E
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 10:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D826D30EF9D;
	Thu, 11 Sep 2025 10:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="P4nyxlDP"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252B522578A;
	Thu, 11 Sep 2025 10:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.65.3.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757585599; cv=none; b=qRaygQMiAHkFZfqOSjsrooWKiDFn18DTiJ41ELZvoYQ3VzlYM6VEpMAWarKUJhufdY5KFDWdd3k62eI5xkeWJQzxPg2IIV/5q8RepeB+q8FAtgeA9xTiFq4OSsKy95W3NRfLCpFJmBStLbZkD/0BrZhaenKp0klXlOO409JCABQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757585599; c=relaxed/simple;
	bh=OOPu29kQ1BH24bAUxy/ULMGjObDfbqKtts7G9RxD7FI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSnzHQwZydIfdRKB20+ExrLd7RCRymO8GfdI42yAaONE0Vj3wi3T5JlGuUk8aO4vC55zmNfsCpEb9mBUrhXkauuS3IrCDgYYmqB1BJsmAvPNSojBpBNcxi4DbgblkyUUhUrMgTf1em0B0ZXPW7TyRi3J8aeR0wuDLiv3ghb9yqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=P4nyxlDP; arc=none smtp.client-ip=3.65.3.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1757585597; x=1789121597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OOPu29kQ1BH24bAUxy/ULMGjObDfbqKtts7G9RxD7FI=;
  b=P4nyxlDP3J+MEG32OQ/E6wmxy2nyN23LocXdFN2loNOXJHQh5Q2imuXQ
   fxgO6wjfeQ+PQkhcykjkC8+Eyfk+n5Ve0pEiYux5hhakUPwU9oM+jFZ54
   c2QVwWmlFjzTLB5lBegrWB3xJoclrBolFN2xGW7kcQAYT+/T/FlJQFhfA
   t4YAfIYG3zw/awDGxN0iWO4fShOX29Ft3LSz7JotTQfRUTVLdCNO1bjJO
   TFHnyTlKSsNZ42oVcMXH2PuRLbXhWAUHDLZqfFFwljCRxaGqi9qLgI0C/
   SmiNpHswM2GI9hDEq4q8qcHrSNVNC4du0wuySX0lCwEalsoqj2qbFk7AH
   g==;
X-CSE-ConnectionGUID: bOYZsoX9Q6yFqFhWnhEZ/A==
X-CSE-MsgGUID: rmJyDOMAR+KDQ1fYQgccAw==
X-IronPort-AV: E=Sophos;i="6.18,257,1751241600"; 
   d="scan'208";a="1955887"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 10:13:05 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:8661]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.40.78:2525] with esmtp (Farcaster)
 id 797de9ee-61f8-47a9-841f-cecc5d78cdf7; Thu, 11 Sep 2025 10:13:05 +0000 (UTC)
X-Farcaster-Flow-ID: 797de9ee-61f8-47a9-841f-cecc5d78cdf7
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 11 Sep 2025 10:13:05 +0000
Received: from u5934974a1cdd59.ant.amazon.com (10.146.13.110) by
 EX19D003EUB001.ant.amazon.com (10.252.51.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 11 Sep 2025 10:12:59 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <wangtao554@huawei.com>
CC: <graf@amazon.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mingo@redhat.com>, <nh-open-source@amazon.com>, <peterz@infradead.org>,
	<sieberf@amazon.com>, <tanghui20@huawei.com>, <vincent.guittot@linaro.org>,
	<zhangqiao22@huawei.com>
Subject: Re: [PATCH] sched/fair: Only increment deadline once on yield
Date: Thu, 11 Sep 2025 12:12:43 +0200
Message-ID: <20250911101243.215354-1-sieberf@amazon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910014353.1015060-1-wangtao554@huawei.com>
References: <20250910014353.1015060-1-wangtao554@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
 EX19D003EUB001.ant.amazon.com (10.252.51.97)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Tao,

The patch hasn't been merged yet.
I have resent this patch with fixes tag and additional maintainers in Cc.
Please review on the following thread:

Link: https://lore.kernel.org/lkml/20250911095113.203439-1-sieberf@amazon.com

Thanks,
Fernand



Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07


