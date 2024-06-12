Return-Path: <kvm+bounces-19514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F3FF905E06
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:54:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BC2D1F220AC
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636F6127B62;
	Wed, 12 Jun 2024 21:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="YBC9pWJn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CA031A67
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 21:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718229270; cv=none; b=Pw8AbjVKixn/NAEe6whVBkovQg+8JoAXviZhjjUKHokbMspsXF6UlRF2VzApSjPiQgMelmLrRmxQbQx8o5NwccIxunTX/cfz/Qs0+v51N00n72TnLd4ieNk+/D+5qgesaCZlp5PwC5NQHD/xRLorqiGzqVcOpn46J/mVcMZPd7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718229270; c=relaxed/simple;
	bh=81y5PdQWI3Dz2dVO1NfAd5bwDfsoCxXpUvsFQd6ruGg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kQgNxJAOE6zUPw18AN/ne4Zwzxp+6VRF88AwAa5iSihxPcr6bHb3ZQy+Kre4wbsHBkZLnuiDYjAeYiO58eHbKT+nyoSQ4NcRiiF5NaHtl5QgEqhLDE/Y3yDPAH4Td6EjVn3wQuHGFa6evvYt6Bgi3vnr6+dujvvFRmKBGy0SuEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=YBC9pWJn; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a6ef46d25efso47553566b.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718229267; x=1718834067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dJ8EY04tXRIESGbFw44fQedORBs2GbTIYFd7oPwOyhA=;
        b=YBC9pWJnMyyQk3reAoffMxCFk8tATOOis2GQvYHyi9aWbijN39bt6dvrD0EOILrav7
         +02hII+YlnHUTADkn0yOZ6EWQfQ0Tdq+A1aYYeu8siisbammr11D1AiBaTMRGP9DnIkn
         W0FcXt5/PCwnK2xMdYF9aXWUTkv+I6Oel82dtJmd1SVEq/GAJ/KYUDVJ/3rhzsSszuIp
         SlNHZUuhlye9MV2O/I25TVk7+94uTIhNoIYfeZCDug1gNsQwbvPrib7LxyXnvOmwWpZh
         cjLYYUStex745NHXXieep+n5SP3MNtOxD7Yx2UgG8L5win7hk3pwyvW3Cb0h14T+EFht
         Hkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718229267; x=1718834067;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJ8EY04tXRIESGbFw44fQedORBs2GbTIYFd7oPwOyhA=;
        b=tLyA+CXSGu5K8nHl0mZX3N7zG6ZgCrrk3hzWJIl6ozBPKFt5Nl8OsRuYQBMiFjGBmf
         OuCzQGKVAo3Yjkkb7nQ92pZtWp9FjuNT68qp7kswy+l7SJ36TAISITdw8dP6OKMWX0xe
         m2/hhe+IV1nRf6MI+yYa02KiiaYLr7r6USKXhSZ98owr5jpfsxg+1LVVhUscQZQL4svi
         wABzf63mB+JVBwwa1lXVt7z4fb61+KVx0vE10TCAznxLAfVBCPCrvbrLDlYoty4CLQ7a
         p6EyQujKLNyGt77i0oU1G5gw7e1pcjOR/qWkPvE+n0Q9QmriaI8SSngMngopqpSY49Q6
         VKcQ==
X-Gm-Message-State: AOJu0YxelOBtJdZnoEDbD7e1RQh3V2sySqyw7zIqgSKIlBdWqOZ8Ab5x
	pbrpey/pIsDpD94aisxuPEZ+tVV0KEju+TEB4fmOooiFTRlOUXGlZjVTDvc7+pg=
X-Google-Smtp-Source: AGHT+IGEUAsWH0o1ZnPLHnIp5N0skro47wxPEeeJ6E6lBo0zQ5nHvUJ6cBc4SZ8o6vkD5S7qcqumAw==
X-Received: by 2002:a17:906:468b:b0:a6e:ff0d:bbff with SMTP id a640c23a62f3a-a6f4801bf53mr177661066b.72.1718229267053;
        Wed, 12 Jun 2024 14:54:27 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af372f000c444b1ebcbc1017.dip0.t-ipconnect.de. [2003:f6:af37:2f00:c44:4b1e:bcbc:1017])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6dff0247a4sm785359966b.147.2024.06.12.14.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 14:54:26 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v2 0/4] KVM: Reject vCPU IDs above 2^32
Date: Wed, 12 Jun 2024 23:54:11 +0200
Message-Id: <20240612215415.3450952-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vCPU IDs above 2^32 are currently not rejected as invalid for
KVM_CREATE_VCPU and KVM_SET_BOOT_CPU_ID.

Below patches fix this and add selftests for it.

Please apply!

Thanks,
Mathias

v1: https://lore.kernel.org/kvm/20240605220504.2941958-1-minipli@grsecurity.net/

changes v1->v2:
- add comment and build bug to make truncation check more obvious (Sean)
- handle KVM_SET_BOOT_CPU_ID similar

Mathias Krause (4):
  KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
  KVM: selftests: Test vCPU IDs above 2^32
  KVM: Limit check IDs for KVM_SET_BOOT_CPU_ID
  KVM: selftests: Test vCPU boot IDs above 2^32

 arch/x86/kvm/x86.c                                   | 12 +++++++++---
 .../selftests/kvm/x86_64/max_vcpuid_cap_test.c       | 11 ++++++++++-
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c | 11 +++++++++++
 virt/kvm/kvm_main.c                                  | 10 +++++++++-
 4 files changed, 39 insertions(+), 5 deletions(-)

-- 
2.30.2


