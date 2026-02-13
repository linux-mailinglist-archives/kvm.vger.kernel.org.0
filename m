Return-Path: <kvm+bounces-71067-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UKgqGddVj2lqQQEAu9opvQ
	(envelope-from <kvm+bounces-71067-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:48:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B73AB1385E8
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:48:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 46674300F50B
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6FB365A16;
	Fri, 13 Feb 2026 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JpNWzp4A";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="huQJlWsR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A94F2773F7
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 16:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771001202; cv=none; b=u/GA0ux3WD9FSCPEkX6V7spkVtRsR56Ca4mThMUqGs1s6ID2PoHjEIdE5U8V98bi2xTxsD9WN5sehUpbR6WfUf/gQSucZMR8Oxi47znRW4LIdHCv3teXy8f8G4LJFDY/qK97U78bmWOFoJY5vqhyJ7XeuHFizT5HveBcwb6HT9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771001202; c=relaxed/simple;
	bh=ZP8OCw60RL32EwkYY0e89hbTwnR2vKyoEIQhwW/em4Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=iwj5RTfmrE4UyfyYE1oclGYRi0XR5jfCEbOOrzBV9JtkgrhlVtW+teAJC9d90fOfKZ6zyLYqJABw1ENjSlR62Mhn1U3obV/2gwq8gM7oOp8FLZwuQGvLwe+GiSXgWmHUE5mXnVVqe6DjR15owf1n7AZCh9KTuYDV2SPIdG2lgJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JpNWzp4A; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=huQJlWsR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771001200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uYps0bA+LE4KmG37wny/5CLyE9iGD7sFxaJXKfQbGck=;
	b=JpNWzp4ANzyaH0GlGZBzuZ1r3DE8XKPGz55iflgsLEg/jQtigdZ246QQnewt9zWTebz7RH
	Q5sCXlMkHrqsNiDWQH9YobNGh24rO+pXyBynhOVNOkNnqXY40vQD86Sy2jV7egOMDRfgbZ
	nteY6nJGxslDtZULjTxq9JT2GzGT8rk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-qRADtbeNPpmP-a31fpYjqw-1; Fri, 13 Feb 2026 11:46:38 -0500
X-MC-Unique: qRADtbeNPpmP-a31fpYjqw-1
X-Mimecast-MFC-AGG-ID: qRADtbeNPpmP-a31fpYjqw_1771001198
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43637c70876so798332f8f.2
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 08:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771001198; x=1771605998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=uYps0bA+LE4KmG37wny/5CLyE9iGD7sFxaJXKfQbGck=;
        b=huQJlWsR7ONst+7F9hQiHPT2M5/VNiIahXzMRhzDpPrBsN1VVD7PBGm1XnPYwNBzl0
         Fk/Q5ixIe4hk90+9W41uPhucH4Yee6kwyWx2LkFpUfm8odaH452gjV3iqCFI4eRYlId5
         JLy0wMj7BtbSZBZahBJdLpJafNRdOWTWSbYXVJtFGO3GL6y7IEM9Wuvenrk9J9aav7zC
         3FyLzMqkNnU1d4CTNncbF0GR7c4yVpOjcrlNXk358ovnANoxovi62c7D/Mal6D9qGRNV
         aObOKD9SY2is7SHwUjl5GdaNxQIwYqtlvMBaoKPujom7OklD9eLjbLcIVcNWC+FAKKL6
         6q3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771001198; x=1771605998;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uYps0bA+LE4KmG37wny/5CLyE9iGD7sFxaJXKfQbGck=;
        b=qG59dUOR/kHy7DCcq4tCgt0oDUoJu9i0eBwiXjS7EPx0Ebh0f4t8rtKA0Jd1HoeKom
         FNMayFBZkdNNWPE6G42qrxiOVVv7rIYfuOC+eFZqmd7CjMRZaG73mIHk1PsPXQcsAXwn
         E3KIQFVkAuBux7epZEfq/3mZ9cB8a9IqQdWeJWSYFKPt4+s+2M1wx2+ruXTtXYZJedhX
         jhDSdQgjb+2ytxLylvmXM5XEDxqWNE/FuyROHaWRm2hLSx8wGPdi2p/TcW5AoGa89eD7
         ncj/CPXhkNlQUcFDOaiezUm9nqda2hMmHH1YpeINsJ5w8vLqDni2sE3WmMfX7nn/QgSE
         l9Qw==
X-Forwarded-Encrypted: i=1; AJvYcCUoFmXekpQmPnRpWjBv8oXweOjeO6d/R+PvYQVXLLLx1oSRiAOk6fvwSf7pLl5TXNLGVUI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkQnQU0v0G0TDW8Mx9OtJgg+zqJMysff9jtY0ZIFDEEkgGj7hn
	rJGgE9xVYRbufwJeJHxS2PptAjTqOeRO1tqOQlRmJGDDV0mL/SeWxnmlDByKrpEtRIurDlRuTxM
	fSpsxY2xjXylofMbeWgUHQJolaK8Q70r1+DMaYC1SCf70h74OpDqPYw==
X-Gm-Gg: AZuq6aKt5ZctjTwT2zt68jG0qYBXq8irq4rhRFqUAnPPQIV/B8jY3WiZdjBdGX9mmso
	YVnxvjhkOrbFUzN8+nHbeo9n74vIXPsXWKQSECbGcYoYjQU+UBA9Ys8aV4x9DjMICPAdUrqykgT
	VgR8uomF/8pdhqBxAbzAlPzrTBPe3JHjQ0eRYDvIyf+6Ed0NVeD4DqhVQBXaVibi3dsCFwAUBcM
	syaUBqHmDCnR6jrYJTcbKIBAYAafU5D6Zmp3IORk6xUYdUYZ8VDf4bSe+DB7cZDnKk8J+Fe1hmx
	hoJH6wEbuxRTJB6wekxqpGpC1YqPqDfibbmLPs1pSmwY8rXX+F9+kLk2I7PIvfiqvT22Snl+KhQ
	IpTveR7UzRjdMWFLpm7haP9d5tM10EHTYUXlcr4888Zl8dkXdwZidaCazGRCzuqb1XPxFX5Rkw5
	wup3Yj07wVql6v/DrKBHIxlnAZlA==
X-Received: by 2002:a5d:5d89:0:b0:437:9d2f:8bf1 with SMTP id ffacd0b85a97d-4379db8cdf6mr207422f8f.38.1771001197694;
        Fri, 13 Feb 2026 08:46:37 -0800 (PST)
X-Received: by 2002:a5d:5d89:0:b0:437:9d2f:8bf1 with SMTP id ffacd0b85a97d-4379db8cdf6mr207374f8f.38.1771001197236;
        Fri, 13 Feb 2026 08:46:37 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a74918sm6797134f8f.17.2026.02.13.08.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 08:46:36 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: require generic MMU notifier implementation
Date: Fri, 13 Feb 2026 17:46:33 +0100
Message-ID: <20260213164635.33630-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71067-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B73AB1385E8
X-Rspamd-Action: no action

With s390's switch to MMU notifier, all architectures select
CONFIG_KVM_GENERIC_MMU_NOTIFIER and define KVM_CAP_SYNC_MMU,
so remove the possibility to _not_ have them.

The only intricate Kconfig-ery is powerpc's, but there is
a nice pre-existing BUILD_BUG_ON to tell us that it *does*
in fact require CONFIG_KVM_GENERIC_MMU_NOTIFIER.

Paolo

v1->v2: do select MMU_NOTIFIER

Paolo Bonzini (2):
  KVM: remove CONFIG_KVM_GENERIC_MMU_NOTIFIER
  KVM: always define KVM_CAP_SYNC_MMU

 Documentation/virt/kvm/api.rst | 10 ++++------
 arch/arm64/kvm/Kconfig         |  1 -
 arch/arm64/kvm/arm.c           |  1 -
 arch/loongarch/kvm/Kconfig     |  1 -
 arch/loongarch/kvm/vm.c        |  1 -
 arch/mips/kvm/Kconfig          |  1 -
 arch/mips/kvm/mips.c           |  1 -
 arch/powerpc/kvm/Kconfig       |  4 ----
 arch/powerpc/kvm/powerpc.c     |  6 ------
 arch/riscv/kvm/Kconfig         |  1 -
 arch/riscv/kvm/vm.c            |  1 -
 arch/s390/kvm/Kconfig          |  2 --
 arch/s390/kvm/kvm-s390.c       |  1 -
 arch/x86/kvm/Kconfig           |  1 -
 arch/x86/kvm/x86.c             |  1 -
 include/linux/kvm_host.h       |  7 +------
 virt/kvm/Kconfig               |  9 +--------
 virt/kvm/kvm_main.c            | 17 +----------------
 18 files changed, 7 insertions(+), 59 deletions(-)

-- 
2.52.0


