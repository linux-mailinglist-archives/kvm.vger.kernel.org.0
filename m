Return-Path: <kvm+bounces-37092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B931A25290
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 07:40:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D834B1638AB
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 06:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9A81DACB1;
	Mon,  3 Feb 2025 06:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4O4yMjZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647454502F;
	Mon,  3 Feb 2025 06:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738564802; cv=none; b=jn08ErFmY4ZVFxH8S5ogR0QFmlJ9d+SoNrHdTWLYXXbMWssGmGdrJh9s8aUfSKZMVpeL1CmpDUddG75YEECseShfesNHei7lkfa3uK/3XUZL05TJiuEABsGD7Rb0dWBeSwY1xETLeGOeDN9Eq681yOgo3NHwfAsh5eowkF8L2Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738564802; c=relaxed/simple;
	bh=0NIW1OmAfq0yBW8lzkZJLh8Kz5Zpes6kvYzJJBWxpEw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D5cLFzZjdH1QVjyWh6cDCAIfCX+s3UpeXtYcSWULNfjeyXdwhji08X65BBJ69lf0VeESlblKIQrR34Wf83KTQV6AT9szijSNf34eyjUeXP+0OOBz7YzDt20Ef3XQZ1yQMq0H33NCnmHV/GpB7C7gnx0YRKFyTH3iw8WnGzIZCnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4O4yMjZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29213C4CEE2;
	Mon,  3 Feb 2025 06:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738564801;
	bh=0NIW1OmAfq0yBW8lzkZJLh8Kz5Zpes6kvYzJJBWxpEw=;
	h=From:To:Cc:Subject:Date:From;
	b=Q4O4yMjZu0+eYD0JK7biZWR2K0u/2E8n5nkaKeYlkaL6gSkoALlF29FKggJ2ON4gX
	 Wcu4zBUOpWncFxdgRbebLW5OqopJKRJGC3TgWABJQlnSmKloR3aj3YuAcddogm+YRb
	 WhdmAoBuB4CfeE4ariIPVk7vQ6QANZaxZxVLUwwDFnjvKmzQABba5gay4mnRBG8Q4n
	 p1nVQ6xHsjwi80dqxw5cG3+lgLaWmrCAnEBKQBmBOEy2mFHK7/yLtONCJ3xGwcloRg
	 Ib7e6c14Ho4iWC9Z3q7Ke5Z2PHYlxTDadLSZwc4Fzy8J55d76o/OWfEPcY2w0QfMra
	 hLGNoJgCajmHQ==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 0/2] KVM: SVM: Add support for 4096 vcpus with x2AVIC
Date: Mon,  3 Feb 2025 12:07:44 +0530
Message-ID: <cover.1738563890.git.naveen@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 adds support for up to 4096 vcpus with x2AVIC, and is unchanged 
since v1:
http://lkml.kernel.org/r/20241008171156.11972-1-suravee.suthikulpanit@amd.com

Patch 2 is new and limits the value that is programmed into 
AVIC_PHYSICAL_MAX_INDEX in the VMCB based on the max APIC ID indicated 
by the VMM.


- Naveen


Naveen N Rao (AMD) (1):
  KVM: SVM: Limit AVIC physical max index based on configured
    max_vcpu_ids

Suravee Suthikulpanit (1):
  KVM: SVM: Increase X2AVIC limit to 4096 vcpus

 arch/x86/include/asm/svm.h |  4 ++
 arch/x86/kvm/svm/avic.c    | 82 ++++++++++++++++++++++++++++----------
 arch/x86/kvm/svm/svm.c     |  6 +++
 arch/x86/kvm/svm/svm.h     |  1 +
 4 files changed, 73 insertions(+), 20 deletions(-)


base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 
2.48.1


