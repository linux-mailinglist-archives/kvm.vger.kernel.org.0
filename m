Return-Path: <kvm+bounces-53319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7897B0FC58
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 23:56:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A6231CC2E15
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 21:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A6827147B;
	Wed, 23 Jul 2025 21:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KHR00hTA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76232586CE
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 21:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753307765; cv=none; b=X8lsrJ/smy+yKTUGqiJuqP1R+PMFyH0V4wv3fIAEIczIoK3VWDFq2wqBK0eR7xVrV4fzEFx+WsSXqY7KTzvLiNKTElMg6SumGhTPknk54vzQQN9YRxb6JwOogkstLp0wMM3gN7bc1oKK19eTtqXn39UgAhu8JsDIlMcoQPPHsQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753307765; c=relaxed/simple;
	bh=rFRYrwm+DOUX9xSeAUwEf3toe5F2mt6lAjC8IjY+S64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r3BR7vBPO08M9EEbtaGj9zohlW3Z50YtQ1nEl8GHmoFe/WLuvMDuLWjvRosaLMT5yCWx21RTXE8kCMl/8UA/OG248C35eIG/1SCfa1qgZ6dQIcseg73ugxosIwzG+DSyr+PwzCyT0Myk/qomkoA9FD+//bHVIEGLIoI+3sM7Gkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KHR00hTA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753307762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VNyF4uOWBx+H0ptzy3xhOM9MUH24yGLru2zp+eruyEw=;
	b=KHR00hTABPfV/2HugnwnohU+W6yAIaevFlThvKocxRckQV9+ryk7PmQrMpj4dnv6JGkb6r
	jfDyFVS7uQZ/J361k0VNrs1t51k5CjJZJMt+YI36grOoHohRT5Ur2Flp7WRAH8lclycfq+
	+utUe36ZSK1iDHcNk+qKJIr3d6A16vA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-E6Q2RSHYOxSC0j47eUI5TA-1; Wed, 23 Jul 2025 17:56:00 -0400
X-MC-Unique: E6Q2RSHYOxSC0j47eUI5TA-1
X-Mimecast-MFC-AGG-ID: E6Q2RSHYOxSC0j47eUI5TA_1753307759
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-455f7b86aeeso1205755e9.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 14:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753307759; x=1753912559;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VNyF4uOWBx+H0ptzy3xhOM9MUH24yGLru2zp+eruyEw=;
        b=mzfyeVjDs/M8CFR0tjgGhOaUhlWF5ZfPTnge91i+0/NJya5tS2jWK9xxYAANnHLQce
         mk6FCfezdBz9eB3nFjmZDP4HT+uAYx9stGu6v+27MwExcVVuT9mniT1MWFsPQYnCjwTq
         FH9PorfRCD0Xmej0FcW6SLbAxsX1uMpISz36acnO/KySIDR02pnkJRCTHeFSLvNgfbJn
         xYZCqQ80uXKBJl8F3VE5/v84IcqpD4Hc9f5m34pIURVCl4hb56HewimADkNnO4whDKuI
         b4xSpvZ8LoN3VtamWVzL2ZqpnTxokHbTMZvNl4Jq86YpO7K9Np6HYFO2PnsxNzcW1OIi
         WD2A==
X-Forwarded-Encrypted: i=1; AJvYcCWHOOwKDyXUwUr6AQZjwpyXYHLuOwqje2TRNQJewxCrJWeoDZCEfvSqd7skAUa1ns/JDmE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4RVCRUM0hjTMwyFZpyZT1nkYGIUBCH9a2IoJmJSMpIc6vVLLy
	KpxSFqVuhxqECdmnO10O65H9xyx5LFtcvXy6OSmSUXp7YBV9i+oa4dUo4JJoev5XoJKHuMgqByq
	BfyiE7HORgj81rp7JtDdsYbrWIn95nt2rqo+YwzrZGYgdp364VoobPg==
X-Gm-Gg: ASbGncvxu2bJn6sZFFrm1OaXg5wZgzg1STI0zv139AEJRC3aK62zsrACkZnG9aUeBg7
	1Zdv7BoCVkSgmMDxOPpojYeMkY5PdYFlGD024JMl9UVvubaVbIncdzEry+S1wx5G+O2kv8qrPA+
	yZhNvHkxlHEuxVrM34IcsFNcLaS1hSKpNQigcCEILCq7VqnxyylZqdSZPUiKcdWHWFTSiXsQe9z
	B8385vDbDTSRYL3k2UtqDxX0D4LO2RBoo1bAgjDX4Ui0DOp8DhibCoOQg7AUcirLINFoYScEhss
	o0CqJ+ppeXlGk8wmaiTMhGvMfDzzvcOLs0+Zac3FkvNr
X-Received: by 2002:a05:600c:190e:b0:456:1e5a:8880 with SMTP id 5b1f17b1804b1-45868c9cf1bmr40352095e9.13.1753307758820;
        Wed, 23 Jul 2025 14:55:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDybqmhAfgpmbV80V72LiLYlwQT3s2MSf16SaizlQdvxbUuDyl916gLncW4mae4vXrdvcvDw==
X-Received: by 2002:a05:600c:190e:b0:456:1e5a:8880 with SMTP id 5b1f17b1804b1-45868c9cf1bmr40351915e9.13.1753307758355;
        Wed, 23 Jul 2025 14:55:58 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.154.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45869198e5dsm35517305e9.9.2025.07.23.14.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 14:55:57 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] (Final?) KVM change for Linux 6.16
Date: Wed, 23 Jul 2025 23:55:56 +0200
Message-ID: <20250723215556.866784-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus,

The following changes since commit 4b7d440de209cb2bb83827c30107ba05884a50c7:

  Merge tag 'kvm-x86-fixes-6.16-rc7' of https://github.com/kvm-x86/linux into HEAD (2025-07-17 17:06:13 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 5a53249d149f48b558368c5338b9921b76a12f8c:

  KVM: x86/xen: Fix cleanup logic in emulation of Xen schedop poll hypercalls (2025-07-23 23:48:54 +0200)

----------------------------------------------------------------
x86:

* Fix cleanup mistake (probably a cut-and-paste error) in a Xen
  hypercall.

----------------------------------------------------------------
Manuel Andreas (1):
      KVM: x86/xen: Fix cleanup logic in emulation of Xen schedop poll hypercalls

 arch/x86/kvm/xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


