Return-Path: <kvm+bounces-3498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FEEB8050A8
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EDC51F2154C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F2D54BD2;
	Tue,  5 Dec 2023 10:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OfReK5YH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAC5109
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EsQ/ScQJftZQ38BrXkVofNWM2kNPQwbMRUJ0a1EdV7M=;
	b=OfReK5YHyAFRefDWG67UoOutdP/g7oSQWSlp0I+9YebKcCmX5ye0l5G5AaT0W4uKWzzUv1
	OrwyTKiBYeQ2f0Q4BpXbJGdw8gqDB3PZ1/B7Am6JuY1Ex/V9PP6IgayxNvUFUrxuJz+bZu
	QDE9ZtUGUWC46g/v6YxnoS8JTGRvzoQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-QCBqOJBcMhinqUqTnoYdWA-1; Tue, 05 Dec 2023 05:37:49 -0500
X-MC-Unique: QCBqOJBcMhinqUqTnoYdWA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BF5283B825;
	Tue,  5 Dec 2023 10:37:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.225.152])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2241EC15968;
	Tue,  5 Dec 2023 10:37:45 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 0/4] KVM: x86: tracepoint updates
Date: Tue,  5 Dec 2023 12:37:41 +0200
Message-Id: <20231205103745.506724-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

This patch series is intended to add some selected information=0D
to the kvm tracepoints to make it easier to gather insights about=0D
running nested guests.=0D
=0D
This patch series was developed together with a new x86 performance analysi=
s tool=0D
that I developed recently (https://gitlab.com/maximlevitsky/kvmon)=0D
which aims to be a better kvm_stat, and allows you at glance=0D
to see what is happening in a VM, including nesting.=0D
=0D
V4: addressed review feedback=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  KVM: x86: refactor req_immediate_exit logic=0D
  KVM: x86: add more information to the kvm_entry tracepoint=0D
  KVM: x86: add information about pending requests to kvm_exit=0D
    tracepoint=0D
  KVM: x86: add new nested vmexit tracepoints=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h |   2 +-=0D
 arch/x86/include/asm/kvm_host.h    |  10 +--=0D
 arch/x86/kvm/svm/nested.c          |  22 ++++++=0D
 arch/x86/kvm/svm/svm.c             |  24 ++++++-=0D
 arch/x86/kvm/trace.h               | 105 +++++++++++++++++++++++++++--=0D
 arch/x86/kvm/vmx/nested.c          |  27 ++++++++=0D
 arch/x86/kvm/vmx/vmx.c             |  30 +++++----=0D
 arch/x86/kvm/vmx/vmx.h             |   2 -=0D
 arch/x86/kvm/x86.c                 |  34 +++++-----=0D
 9 files changed, 209 insertions(+), 47 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D


