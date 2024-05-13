Return-Path: <kvm+bounces-17317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C85D68C41E3
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 15:27:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 677231F22875
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 13:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EA2A152522;
	Mon, 13 May 2024 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MYnmQXP3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE1314C594
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 13:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715606837; cv=none; b=rP5d0iP65GF8JtQpIMn6yQLhARJUHcwjiyWCJfR6sGvv58TlGnM/NKtBnH32PIHHauqIPjdpT1o7xSN8S40YcV+xgjXYpwGjLqiwF9+c6j9fHJLs1Z6pBh60NXxZNvCzc+6QJzvH0Jx97ViWJPMNo45RtzSXj0vh/ZvUjcN2y1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715606837; c=relaxed/simple;
	bh=MEzUdxUhfY1RRiLXx4z2pKJImSLFBalpqmWr4ipWXR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMCTasVOu4f8mtCSjaeDOzpIIHYAImJOFZTf5beH6xYHmW4H65kxWBm/6Dze+v5YX6xZl25ENP3+J/6hnJc+s/5cS8vCv9PSgSCQqaAfHN77wLfU64GPavCEwReIZ+564mGz+aYVqkvszhpTQN4PsPHeqGndh96W0BTzkscc2Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MYnmQXP3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715606834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MEzUdxUhfY1RRiLXx4z2pKJImSLFBalpqmWr4ipWXR0=;
	b=MYnmQXP3lE2i6XaasBIMsIyow9E6eglOD59xMu31W4RtaUQG+pT+qOB/i1wfE6Jricj/wo
	SBhVPEBjqjNco+c8+wd8fzXI7zauVnDIZxOPhsp6iZ1FKoOkmCprzFd5Rb7j0Cv9Ade3VI
	uDvRmdY5PCauhLmb6MIuxMs3Lnv+VzM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-o2JVwcYHPgOiLJ-JiwglUQ-1; Mon, 13 May 2024 09:26:58 -0400
X-MC-Unique: o2JVwcYHPgOiLJ-JiwglUQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6a0e8859d2bso56933936d6.3
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 06:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715606818; x=1716211618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MEzUdxUhfY1RRiLXx4z2pKJImSLFBalpqmWr4ipWXR0=;
        b=Pd02/EvLoqYSWESGSqDrqdGR4bGMJAcJVRj5ERm2YwHvcmqEscrTYBWTaTRuAmFNfO
         AFlroni4EtwMMNeA4h/fymChmvgNQX68C4Rn+rU1u5R90ujQc9qCEJkVGOcZxAf4f57/
         zEPaKnSxv13KNG7i2UhvBDoGYqTIdSelcOiG61uDZBQWmo3byp6G3KOtSITf4GiglEeC
         EREGBJFcqpJFe2hHyQisYNZACB/MzPdqgp2Bvcmd5exhsxJu5/m9XMnGKcznls/QdQUU
         JTQCg4cJUCCFaUTTi5h2E5g9i3pRAGI+PW7Qaf9xwC5ri8/A+vFS0+bnsqzWh3QZF0Jn
         X82Q==
X-Forwarded-Encrypted: i=1; AJvYcCXKLNPdxNGaIGXXg3/F0CvDpxWXG6AjKDG43DKyuBrVVY0kJXg4kqdjGJ3WDDPmrFnXuTMr2bFS3IsuMTQgglba8ixZ
X-Gm-Message-State: AOJu0YxXO1qyEmj3NRC2bITDlLCso59DxeAE0E+dU8dtjuhdeI28qcdo
	7E0K1Qnaq696k/893RO0WdeWL6RnHVnyGtN/3+yIo5j+PvTevXxmBm/Pj2FqC2aFvo/z+7kaUPn
	A8xcXyZso5wb/HZCI0xhxyT9ZdAom1h6dt2ai6XzoaSKmokmAww==
X-Received: by 2002:a05:6214:3d07:b0:69b:5576:49e7 with SMTP id 6a1803df08f44-6a1681f5588mr125169616d6.45.1715606818254;
        Mon, 13 May 2024 06:26:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/j+JjKCWE8cRoMDkq03QS6KhsAqgmIlUjNCdmfJge/OlxjxNjcM8A71gXRJX0XEXntsFzJA==
X-Received: by 2002:a05:6214:3d07:b0:69b:5576:49e7 with SMTP id 6a1803df08f44-6a1681f5588mr125169466d6.45.1715606817915;
        Mon, 13 May 2024 06:26:57 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a340d25a18sm3747716d6.40.2024.05.13.06.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 06:26:57 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: oliver.upton@linux.dev
Cc: james.morse@arm.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH 2/7] KVM: arm64: Reset VM feature ID regs from kvm_reset_sys_regs()
Date: Mon, 13 May 2024 15:26:53 +0200
Message-ID: <20240513132653.14219-1-sebott@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240502233529.1958459-3-oliver.upton@linux.dev>
References: <20240502233529.1958459-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> A subsequent change to KVM will expand the range of feature ID registers
> that get special treatment at reset. Fold the existing ones back in to
> kvm_reset_sys_regs() to avoid the need for an additional table walk.

Reviewed-by: Sebastian Ott <sebott@redhat.com>


