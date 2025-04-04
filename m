Return-Path: <kvm+bounces-42634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA52AA7BABF
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 976FD3B7FDF
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 197921C84DC;
	Fri,  4 Apr 2025 10:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IIyaNQ/c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C364C198E75
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743762569; cv=none; b=F8VsmmpLHhPdI1FI8V7baqKoS6ufZwBhQuH8go0vjMFtymb5I4TDUUGhVmmNX+sqLPoYfvF7wcpsWDkL59e8Y9IPVZycJq4nmoQ3Kw6d71/KeZKOAIr2gL/e9MaozEdrM+kRcGukSuoXhqzSNAqV506Ca05l3pdPbs7uhkErx+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743762569; c=relaxed/simple;
	bh=4tdmetf1lCXliEewrbfbIOmwuXj1mc0LGbqbXi+55wc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LMACRc2fnDtAEPsMturYEs4lxS6cyfm5MrPHjJ8mgxlU1Na5bEsOyHDHIDWWaStsWEcYKBRTz2iXSYLlmMvrxUhk7LW6yZqd8fy5l9JGOepDzVU8KFVifaRkaeS2xrSXVNI5cZQp+OH/qO2ci3aYlBgQL2Jks3CHzmhnC10/MgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IIyaNQ/c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743762565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=T6NquZdovmTMsUinuO4eB4LIwS+YsKGYMLukNBFuSdg=;
	b=IIyaNQ/c3gppgtOnh26zi3fqEDbHl2yqc+cWA52l69TG08x16tgNrWaMKtFT1YWTQj6KEe
	S1/p7BYQX4fnzr7+vxYVgBIPWPotd5roRp7WC9zEbZO/Ryi3qeJBUyEGfes1F1NaEqjvNi
	+cZk6Eo/LIbvU6L3mLrEt1l1RcbBJ7w=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-Z7VTZf3qPYqyTpDyw_0JEQ-1; Fri, 04 Apr 2025 06:29:24 -0400
X-MC-Unique: Z7VTZf3qPYqyTpDyw_0JEQ-1
X-Mimecast-MFC-AGG-ID: Z7VTZf3qPYqyTpDyw_0JEQ_1743762563
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ac3db5469fbso150623766b.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 03:29:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743762562; x=1744367362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T6NquZdovmTMsUinuO4eB4LIwS+YsKGYMLukNBFuSdg=;
        b=WprJbVZPODV9Qez6Gm7pnS1iChpvZtgZmBx7d6YBXzgUDuMdf08yx6Foust0NgIxao
         iKXx7dqjc5xKCq91XOA3oUNai+Fd0/ApRNyJW9KYsbzswav6MdKxHSRV99aZGYfxYAo4
         OS5VgQVhczRs1/RhZ2ifezNydWpRLPGRZF5BbXhWdlklaAETwGcx9lnaRiVnaAFcqa6P
         Fpd5VS2G3mNnTczcmaTNkq/KcbcwjEAFC0QVNO6/SrXUnU0lytcGqcvYcnRkMxUZClgj
         2cgu4KTBxBziWStZCGyJxhoInSwtmbk4nsMR2ANY8ct45T59cFxOmGlegP5TumtvXIH5
         pfrw==
X-Forwarded-Encrypted: i=1; AJvYcCWoEY/tJVDoPymEwgxqHnQCOxfwS++x8gCjAAZxvL3rb0Gh5WKYzJYyFsEKqEqxd128OOs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp+65BNV4dGcYxceUfFTnqRsu7Zu3I8s9uI6IfSSRGSoQBKQZV
	dx7zjHhd2JoEqOyLCzi3GFuBil2H1DC5l7oLjkSPc+Q7/vFab5c35fHRcBmTPUnJYzyb/oXURT4
	9adS1Vv5mxYSZS76Te61XPqt4wpDGEMVhbGnEAYLptuZkxwrt3ObbKXGFqg==
X-Gm-Gg: ASbGnct1Nia04EKP4vwm46uovte4HVnhq/Wz4yICSsEE8O4nWc9KBWhknGEt4nADd5F
	/d2eVKnMUS26z72qw9jHCehoSedcnWqvztdctVyYunC7ad9iqS4JnZu4xusMNYWtnqELkhdcZ9P
	6GTpUEl0vfkKL6suNtEbDeANf4h6lVCeaV7a7Vv/RiMxdnBSyeRiarvWdDl1Ttntsgdb/klJLjP
	ujEigZA9cDg3jAoe5GZgapT7Bxnw/aUABQAoZyefzXZANODC1+t/owZ3O0GbE2hzsSFjt2Xi3up
	61s0bsq0xa9uoefI7FSS
X-Received: by 2002:a17:907:970b:b0:ac6:edd3:e466 with SMTP id a640c23a62f3a-ac7d6d03dc7mr161144666b.19.1743762562280;
        Fri, 04 Apr 2025 03:29:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfA32d489HvKK0l5PnqVrR3kR//7KWWZo584P/Gc87QpdSbTdgAfAHbKrKml5QdqYMR+aH2Q==
X-Received: by 2002:a17:907:970b:b0:ac6:edd3:e466 with SMTP id a640c23a62f3a-ac7d6d03dc7mr161143766b.19.1743762561960;
        Fri, 04 Apr 2025 03:29:21 -0700 (PDT)
Received: from [192.168.122.1] ([151.49.230.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe9bb8esm228306666b.48.2025.04.04.03.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 03:29:21 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 0/5] Documentation: kvm: fixes for capability section
Date: Fri,  4 Apr 2025 12:29:14 +0200
Message-ID: <20250404102919.171952-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several capabilities are documented in the wrong section (6 is for
vCPU-enabled capabilities, 7 for VM-enabled capabilities, 8 for
informational ones) or have incorrect information.  Fix a bunch of
things.

Paolo

Paolo Bonzini (5):
  Documentation: kvm: give correct name for KVM_CAP_SPAPR_MULTITCE
  Documentation: kvm: drop "Capability" heading from capabilities
  Documentation: kvm: fix some definition lists
  Documentation: kvm: organize capabilities in the right section
  Documentation: kvm: remove KVM_CAP_MIPS_TE

 Documentation/virt/kvm/api.rst | 1104 ++++++++++++++++----------------
 1 file changed, 540 insertions(+), 564 deletions(-)

-- 
2.49.0


