Return-Path: <kvm+bounces-67962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F06D1A98B
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2D5713002165
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151FD350A25;
	Tue, 13 Jan 2026 17:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G18rXsnV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AFwhHrAl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2F734DB4A
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768325107; cv=none; b=HH6vZFhhnLh9vARJuzweqd4MVdXdgo6sh/4kgCslxhXHgDG88Nf5SfECmu/Nc2HJ5k04oa+2/NmTVQX+lm7hedEKacHWcue6u6H0sHJJP3MpDDUWRxLoOq2XGDNQ+wxvxdUKvh0IBqshjHYCBSh6aiWVS2wSy4JhwuS5U8hvO58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768325107; c=relaxed/simple;
	bh=ibYqdnqWYRZj8LNCfVJgYQA2WrNizkuf5313JZ8ZQlg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MCCj8y4II0NS9JPFtyl7F22ZyeqpVUjwQ4U3ul7tx6X0Cso0oyHIDob8DFMUoBx0B8WVAvSss/OH+4gfy+J3vTa1IY/kg4pyfRtXVk6SPVMcxPpMTpw8H2zB0dqcQibes93vtpmDqXvbUBETPOa4uzCJwcCWp6WjUGakl0W5dIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G18rXsnV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AFwhHrAl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768325105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fl4IIKtRTau0b1ATp1rU+9TSO5vHpYgdgpmNSNZyz/A=;
	b=G18rXsnV4jg50FGB6SvcEiZcx0Q3Ju49QQAcgNSNOLwnYpQbR6i6uIW7EJ/zVQqeZ9cXJB
	LYXA+EBUVc/WKk1ig+z9dyLTdXNHDUs1eBnIxqDgoP7HKUgl/Ay8IEjpQCer6rpPUZnZ3i
	YYScBFcvFPsjKIgXzHaRivPBpt/2es8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-AtK1QvqeOxKfA3AQVDtJPg-1; Tue, 13 Jan 2026 12:25:03 -0500
X-MC-Unique: AtK1QvqeOxKfA3AQVDtJPg-1
X-Mimecast-MFC-AGG-ID: AtK1QvqeOxKfA3AQVDtJPg_1768325103
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-88a2e9e09e6so230416806d6.2
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 09:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768325103; x=1768929903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fl4IIKtRTau0b1ATp1rU+9TSO5vHpYgdgpmNSNZyz/A=;
        b=AFwhHrAlQ158o95/IfaUavPfC0i1dGWBooERHsURriz8atKUv0xmnaQhtr0pMNouJS
         hEz71LbZCMJUWpMfeT162CcTIccz2eLhuOKdG1EvWMNEpJjoS5MEjIRi5IhYhyY/mtLM
         RFbLf3GfLIZFx86vJz0BMyVV0Vd909pA3enCqws3qaiUWwUV5z8hP5DSI5BZZrkXZm5J
         iXi7s3zJrkinAwHw5UQQ7/iiL8I8kwCQb0IjG9lio6YT/3r2HYcHOiMRMN7V+ahWw992
         cY0bBXhPc6qY7q0AGK6n0utLq5iLgU8994R2btagpdIXOpHZaa3zjeX4bIfAMxPu43EV
         QtzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768325103; x=1768929903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fl4IIKtRTau0b1ATp1rU+9TSO5vHpYgdgpmNSNZyz/A=;
        b=iSZ+ggKad6HJzzu/PnnmRgY8BAkrnwy5m3ZHqbS1Qqw8BohlCXFdKshRK2YuCM5pbC
         fksARqYpqkxOr7NBmbomwPTmceo84yL0dIlQ3NSDC9OOlt9LuxHk5l634rGebMRm1FTv
         mKryEQ95HG4Bb8N1wNcp/b2aKsKynr/ug4Ge3z2lFkZvt6FlmUzwZ6oayA/fG1u+7Ewb
         pferA0FviP/BvXjojunn/TG29/QvxWKJhQwzMe7rUQclkJB75hsNCWWH4QBbnFKIXcgJ
         fYzKfGPsG42qf/6U3XCbkfjiV7vsxu0uLKeH0Zy1xzpJjVMUU9apJgC4CoD33yDUalBd
         chNw==
X-Forwarded-Encrypted: i=1; AJvYcCVmF9wa+ghnrZ6TzO2pCk81voWm0YmPT5W5vRTkh5vwm/KVx2KcbXNs1B/31EaP9gSsIfM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc4atLhUUXWJVhSCvGhrr+Enkef5BJIQG23EkyyFvaZ0N84wxc
	sgzNaWcrRqwjsNYLALDCRjSC4beLR1kP5mCZOa7F42wb4ZM0GgZkSlScGNqXPHjzdkZcQG38ALi
	+uM1zaI7p4ythxFgOS36vctYOFhepUWhnciokuGiTus9IFigozKAfzw==
X-Gm-Gg: AY/fxX6l1VN2NaHl1Q0xJv/t+Q/BeLjPNwxK2yGYH1VY20Ehp2uQfvUYA90Um9xcNez
	jCcWs3O1r4gMuhKi0SCEq0YXyBsLV+RKcvNXc0F+zQDli3/XFVgXE80lEIkjBtTimVKSvHKQsrm
	2DOKsmPJjGMu5ZQ5JlPYsbv0WhyA14u5CvIqoXkYMgsANQBY/nwEPAkAAPT3VcbqxnG6mlvawCP
	b++xC5efeN2LBbwimcRw23TV/HO8RLeyrDMwuK3bl8tZ5yVF3n3mhELHIDjSbBdqcAbPZp1d1T9
	/NSZsRAvpRemk3hMWZMhd0bA732K5bMAmrkorBKQXhyK6N82kTK+OVY+TKNDu22i/1slPXCtz+u
	gl189m2TsJK6nwTA5dFrBCziQfj+fn/FRh04GdK0pyNSaQnZyC+oqMHTB/Yo7knq00iHsWMYaGf
	hiN0xJJbXgxZkdCQ==
X-Received: by 2002:a05:6214:5509:b0:880:5a6d:acd1 with SMTP id 6a1803df08f44-89084275d7amr322570326d6.47.1768325102945;
        Tue, 13 Jan 2026 09:25:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF9/oMoncN1hsTQyAK17N9TO1sKxE6wf+3zBnFkmfn6PLfkBaYxJbZxnee6//I+YgSPrkAHeA==
X-Received: by 2002:a05:6214:5509:b0:880:5a6d:acd1 with SMTP id 6a1803df08f44-89084275d7amr322569996d6.47.1768325102445;
        Tue, 13 Jan 2026 09:25:02 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770ce985sm157440406d6.11.2026.01.13.09.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 09:25:01 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	seanjc@google.com
Subject: [GIT PULL] KVM changes for Linux 6.19-rc6
Date: Tue, 13 Jan 2026 18:24:59 +0100
Message-ID: <20260113172459.1291801-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus,

The following changes since commit c8ebd433459bcbf068682b09544e830acd7ed222:

  Merge tag 'nfsd-6.19-2' of git://git.kernel.org/pub/scm/linux/kernel/git/cel/linux (2025-12-30 17:56:26 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 3611ca7c12b740e250d83f8bbe3554b740c503b0:

  selftests: kvm: Verify TILELOADD actually #NM faults when XFD[18]=1 (2026-01-10 07:17:30 +0100)

----------------------------------------------------------------
x86 fixes:

- Avoid freeing stack-allocated node in kvm_async_pf_queue_task

- Clear XSTATE_BV[i] in guest XSAVE state whenever XFD[i]=1

----------------------------------------------------------------
Paolo Bonzini (2):
      selftests: kvm: replace numbered sync points with actions
      selftests: kvm: try getting XFD and XSAVE state out of sync

Ryosuke Yasuoka (1):
      x86/kvm: Avoid freeing stack-allocated node in kvm_async_pf_queue_task

Sean Christopherson (2):
      x86/fpu: Clear XSTATE_BV[i] in guest XSAVE state whenever XFD[i]=1
      selftests: kvm: Verify TILELOADD actually #NM faults when XFD[18]=1

 arch/x86/kernel/fpu/core.c                 |  32 ++++++-
 arch/x86/kernel/kvm.c                      |  19 +++-
 arch/x86/kvm/x86.c                         |   9 ++
 tools/testing/selftests/kvm/x86/amx_test.c | 144 +++++++++++++++++------------
 4 files changed, 139 insertions(+), 65 deletions(-)


