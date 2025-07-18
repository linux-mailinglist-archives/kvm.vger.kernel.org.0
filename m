Return-Path: <kvm+bounces-52862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9477AB09BB0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:50:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FF10168775
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E6E202960;
	Fri, 18 Jul 2025 06:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWPBmRcU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3114689;
	Fri, 18 Jul 2025 06:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752821406; cv=none; b=LyJrPEO6iRCEy7qTF0SaCOzEwugdeHTXe4biWvmkHsq6oH8cOVwoSmeAyu+16SAkXOmhkN/l2juDWzmvMrT+5vYMGdQ7gFD8HcGWnDCoCWpOIxVo3AUhLBQPGNfwyTH6KsR+sJY9AyhAhbJ08cmeKcx6kgmZuMpZcsUbzm5jr2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752821406; c=relaxed/simple;
	bh=dNjvBvVDoDotAFqXuu1WvpTaH3Qa0mGPmPm5pFh2/Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NOH0sKb073NFsli47l2TxO4Ow+J3Xpa2EfU2Nh2EXfmAl6Ep0IJ5oub69PiGMjiJgQJzW32vPIfjTvxzSrpr34hHtG8jILzjhX7h0J+6h6IS+8teFUA+qFHBQltL5TO/VoclrL3HZpLIDANMqTHQlYu0ct+kktpTqVKBSdcsnQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWPBmRcU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4763C4CEED;
	Fri, 18 Jul 2025 06:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752821406;
	bh=dNjvBvVDoDotAFqXuu1WvpTaH3Qa0mGPmPm5pFh2/Ak=;
	h=From:To:Cc:Subject:Date:From;
	b=aWPBmRcUizrhKxkHZiMJZ3hKRzdlzmVExliBwBmN6rVqFApnfeGNczbG5HjX8GI6T
	 ubaZAxeKcp/0J3y7q54A34FztCVsI/4wF+WhOX8ar4mf33eG/52eY1LHNJEAjgye3v
	 8NaEVpVjSydhJ4UaO39nUGiWDcKXeqKesLoxOzqR6ng8Ah3pF8fFPDyO8ExNsUO5RA
	 XA6zpWqpQIz/7dJBSnvd0X8SznnO4z2jO/QjVd2UDZ0SaiQ7M+a5MlE9DvsYJg/ZAJ
	 PjET131RzaxjSbiId9I/ICd+DbtyUmKg9xMM6cTQnarS/58VhzT2S/jHqxeqy03v2g
	 rJ2BheY0edfNA==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 0/3] KVM: SVM: Fix IRQ window inhibit handling
Date: Fri, 18 Jul 2025 12:13:33 +0530
Message-ID: <cover.1752819570.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sean, Paolo,
I have attempted to take the changes discussed in the below thread and 
to convert them into a patch series:
http://lkml.kernel.org/r/Z6JoInXNntIoHLQ8@google.com

I have tried to describe the changes, but the nested aspects would 
definitely need a review to ensure correctness and that all aspects are 
covered there.

None of these patches include patch tags since none were provided in the 
discussion. I have proposed patch trailers on the individual patches.  
Please take a look and let me know if that's fine.

I tested this lightly with nested guests as well and it is working fine 
for me.


Thanks,
Naveen


Naveen N Rao (AMD) (3):
  KVM: SVM: Fix clearing IRQ window inhibit with nested guests
  KVM: SVM: Fix IRQ window inhibit handling across multiple vCPUs
  KVM: SVM: Optimize IRQ window inhibit handling

 arch/x86/include/asm/kvm_host.h | 16 +++++++++
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/svm/svm.c          | 60 ++++++++++++++++++++-------------
 arch/x86/kvm/x86.c              | 45 ++++++++++++++++++++++++-
 4 files changed, 98 insertions(+), 24 deletions(-)


base-commit: 87198fb0208a774d0cb8844744c67ee8680eafab
-- 
2.50.1


