Return-Path: <kvm+bounces-60057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB57BDC592
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 05:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5B653C0582
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 03:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C04A329D269;
	Wed, 15 Oct 2025 03:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AtiLMs48"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D002927B4EB
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 03:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760499189; cv=none; b=EWnW4bQ431mNAfAuteZCOFM9WNm77XVEbP4OKt7YaUFB9//GSWVofUXEoOnKiq5RIdyvWwLxxqq36dvYDCbhRknsRRlshd7MAYQgwdiChVz4JSH0IQ5DjF+Prkg8VosSKLQkWQqNPPqkqnVh6KnESB0gPBCBFR0+fRaqafZTQPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760499189; c=relaxed/simple;
	bh=nh6A6QTW5DFWbqA0LXLmFEnYV+abQ4LqDLTOtaSusmY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=D+mJc0AyymHt8NMKE8LUJd1P+eg+r7hkEnze9n21fkxlzHI+J4kZSY8wtMOhloI7XQ/KR49BqgnoLIQy8t5kjK6Oaf9lEaYw2kookA8pBtgwjWgO2VBzs7P9U5LAekV1+Ats1lY1EAg0rcje7LPCTl3P0UHcxF4iEyOEs45jHQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AtiLMs48; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760499186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sFXia4dAf+nJBlW1l2txxKlIDrP+1ClTxtSsWhIIzPA=;
	b=AtiLMs48KDKWS1jLrE/DD1cCtBHfcEjb682+6yq3IQeo/5BZ9x4/qj5OZLofORJGc5eFrj
	x/Y54db7x7ranUDFu33agJrjYGRhk562lruBy5r8neuLl6lMd8wAx3naSY2pf2sj2qJU+8
	seGqr4t0/nftMzXTyAt3u0Hjg5hJvZk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-n4N2v3_1MnO5Amk7Uvhx6g-1; Tue,
 14 Oct 2025 23:33:03 -0400
X-MC-Unique: n4N2v3_1MnO5Amk7Uvhx6g-1
X-Mimecast-MFC-AGG-ID: n4N2v3_1MnO5Amk7Uvhx6g_1760499182
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72D83180035D;
	Wed, 15 Oct 2025 03:33:01 +0000 (UTC)
Received: from intellaptop.redhat.com (unknown [10.22.80.16])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2D4BA1800452;
	Wed, 15 Oct 2025 03:32:59 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/3] Fix a lost async pagefault notification when the guest is using SMM
Date: Tue, 14 Oct 2025 23:32:55 -0400
Message-ID: <20251015033258.50974-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Recently we debugged a customer case in which the guest VM was showing=0D
tasks permanently stuck in the kvm_async_pf_task_wait_schedule.=0D
=0D
This was traced to the incorrect flushing of the async pagefault queue,=0D
which was done during the real mode entry by the kvm_post_set_cr0.=0D
=0D
This code, the kvm_clear_async_pf_completion_queue does wait for all #APF=0D
tasks to complete but then it proceeds to wipe the 'done' queue without=0D
notifying the guest.=0D
=0D
Such approach is acceptable if the guest is being rebooted or if=0D
it decided to disable APF, but it leads to failures if the entry to real=0D
mode was caused by SMM, because in this case the guest intends to continue=
=0D
using APF after returning from the SMM handler.=0D
=0D
Amusingly, and on top of this, the SMM entry code doesn't call=0D
the kvm_set_cr0 (and subsequently neither it calls kvm_post_set_cr0),=0D
but rather only the SMM mode exit code does.=0D
=0D
During SMM entry, the SMM code calls .set_cr0 instead, with an intention=0D
to bypass various architectural checks that can otherwise fail.=0D
=0D
One example of such check is a #GP check on an attempt to disable paging=0D
while the long mode is active.=0D
To do this, the user must first exit to the compatibility mode and only the=
n=0D
disable paging.=0D
=0D
The question of the possiblity of eliminating this bypass, is a side topic=
=0D
that is probably worth discussing separately.=0D
=0D
Back to the topic, the kvm_set_cr0 is still called during SMM handling,=0D
more particularly during the exit from SMM, by emulator_leave_smm:=0D
=0D
It is called once with CR0.PE =3D=3D off, to setup a baseline real-mode=0D
environment, and then a second time, with the original CR0 value.=0D
=0D
Even more amusingly, usually both mentioned calls result in APF queue being=
=0D
flushed, because the code in kvm_post_set_cr0 doesn't distinguish between=0D
entry and exit from protected mode, and SMM mode usually enables protection=
=0D
and paging, and exits itself without bothering first to exit back to=0D
the real mode.=0D
=0D
To fix this problem, I think the best solution is to drop the call to=0D
kvm_clear_async_pf_completion_queue in kvm_post_set_cr0 code altogether,=0D
and instead raise the KVM_REQ_APF_READY, when the protected mode=0D
is re-established.=0D
=0D
Existing APF requests should have no problem to complete while the guest is=
=0D
in SMM and the APF completion event injection should work too,=0D
because SMM handler *ought* to not enable interrupts because otherwise=0D
things would go south very quickly.=0D
=0D
This change also brings the logic to be up to date with logic that KVM=0D
follows when the guest disables APIC.=0D
KVM also raises KVM_REQ_APF_READY when the APIC is re-enabled.=0D
=0D
In addition to this, I also included few fixes for few semi-theortical=0D
bugs I found while debugging this.=0D
=0D
V2: incorporated review feedback from Paolo Bonzini and Sean Christopherson=
.=0D
=0D
Best regards,=0D
        Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  KVM: x86: Warn if KVM tries to deliver an #APF completion when APF is=0D
    not enabled=0D
  KVM: x86: Fix a semi theoretical bug in=0D
    kvm_arch_async_page_present_queued=0D
  KVM: x86: Fix the interaction between SMM and the asynchronous=0D
    pagefault=0D
=0D
 arch/x86/kvm/x86.c | 37 +++++++++++++++++++++++--------------=0D
 1 file changed, 23 insertions(+), 14 deletions(-)=0D
=0D
-- =0D
2.49.0=0D
=0D


