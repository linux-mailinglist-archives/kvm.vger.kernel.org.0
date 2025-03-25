Return-Path: <kvm+bounces-41883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09721A6E826
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 02:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 963FD18968DF
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 01:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48950B666;
	Tue, 25 Mar 2025 01:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EOtvt+ie"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF75015E5AE
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 01:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742867875; cv=none; b=jH1g+SjgxBdhFR7Zhbm2Iw+n6rE/2bkEJiIOqVXmXcZvK17g78hSdMxPKyK1G3HWGuBaE+frRPyom7KEUQ/W6BLUIytix663rOZZCnx4vPssFy3R+EvP68wcNlG5Rx/VDKiOqBTAFlj6hYw3vNvEFi1UjlO42nK6f2zgvh/+ijE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742867875; c=relaxed/simple;
	bh=Ij/UC/V3EoUszJukWy9se9p2Z5SkuuZcxQy6mcDyK18=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=UGKkx6+6YDnxBrM9+cK7u6WhfjQk7O4xuU5EQWvylrPbjuArErHEZfHWjnRjoDIMQx9S/FIE/flAjrM10vCnJW8iZvzDmO0fYzUkvFLB+/bNojbh58TTbmthfIriDiY5jrMX8D62vwJU+8ghU9ML+32AZIeaba5QM7H/Y15txhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EOtvt+ie; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742867872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HnkkWB/IJYXgybfVM3A/a6LLwZkE9IPLdJKeFGOk9uQ=;
	b=EOtvt+ie+HhgY84hInEgUa9AleMeOv04hqEykunTGmwWTqrzN2VTm017eh1XBWrK1imtYZ
	ljrOK5asjJxqjxYE5NEYEw9biW9yeB+7CVq/5r7xiw/i97mIHTSBvL4X7XLxWDTduYE9Gh
	8AnSoj7MIaC1aQNRa+czaJfn84COI2M=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-3i8avJ-0NuqAhShzKFiqwg-1; Mon,
 24 Mar 2025 21:57:47 -0400
X-MC-Unique: 3i8avJ-0NuqAhShzKFiqwg-1
X-Mimecast-MFC-AGG-ID: 3i8avJ-0NuqAhShzKFiqwg_1742867865
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20F03196D2CD;
	Tue, 25 Mar 2025 01:57:45 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.191])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 89B551800268;
	Tue, 25 Mar 2025 01:57:42 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kselftest@vger.kernel.org,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH v2 0/2] KVM: selftests: access_tracking_perf_test: skip the test when NUMA balancing is active
Date: Mon, 24 Mar 2025 21:57:39 -0400
Message-Id: <20250325015741.2478906-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Due to several issues which are unlikely to be fixed in the near future,=0D
the access_tracking_perf_test sanity check for how many pages are still cle=
an=0D
after an iteration is not reliable when NUMA balancing is active.=0D
=0D
This patch series refactors this test to skip this check by default automat=
ically.=0D
=0D
V2: adopted Sean's suggestions.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (1):=0D
  KVM: selftests: access_tracking_perf_test: add option to skip the=0D
    sanity check=0D
=0D
Sean Christopherson (1):=0D
  KVM: selftests: Extract guts of THP accessor to standalone sysfs=0D
    helpers=0D
=0D
 .../selftests/kvm/access_tracking_perf_test.c | 33 +++++++++++++--=0D
 .../testing/selftests/kvm/include/test_util.h |  1 +=0D
 tools/testing/selftests/kvm/lib/test_util.c   | 42 ++++++++++++++-----=0D
 3 files changed, 61 insertions(+), 15 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D


