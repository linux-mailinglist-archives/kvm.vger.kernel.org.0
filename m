Return-Path: <kvm+bounces-14678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 637908A5914
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 19:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FB8E284679
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 17:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D74839E5;
	Mon, 15 Apr 2024 17:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JfSFXysI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8B4811EB
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 17:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713201947; cv=none; b=R4dxC0v8dfZ5WqFm5gazRWHkl7JXUhF19AwIrdux9xdeHj8K5M+OsVAxG2rY5l5DcJt6Ad5+nVORtIxd8lDLbnfTSjz2S2GEQCL49Atyn9jU3PNvm6SP2vZTce5ZtvHGpa2+jMPrM+v7ys/QNsC52I6x/ORQ7RFzO7nsa+if4Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713201947; c=relaxed/simple;
	bh=41hwORd9C0nFa0NIUCQFQDhpkmFQlIiBxNgkU4DwnKA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DJPfUKqWzhSsw86AdGnYpdzyvLrnE2yroNrYyxQ69Rw8dieVeYMEdXxrjdPma/U+Z/MU7opcAXMR97itu9HtZ7yAdSaHAYjXWo7JipvfAIj0BvkvcCLEPjoATsZuCtNGxlbyiEeu8KywPFGEEl7GTO8VHqzLzvoG/Xo4CFNMpMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JfSFXysI; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6edff450718so2129469b3a.0
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 10:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713201945; x=1713806745; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JvfVg3OIACHh186qJ/kodeeut9EMeQL1oz2fUu6nWY0=;
        b=JfSFXysIuETqirvpEvoKIiQ7I2iUc6F6Eodis80xsBu6NpnJGVQ6GU5ma6QZHe0rT3
         Xr1B1GTMjDqbSxAlOK1KPvMohM/j2x62XsaXSG9H+4G+QsaXax7gGeFW5uXPEcYpEn5V
         KF+dUdhMEKzdRCv9FEKrmBPtRwASddRvXVvwTWiEq0xXhyb9kd+FrNV9D6Fbc2CuxEGz
         NuVe8oNYRVGix9w8Fmj+59kkOHG9iNHRciDOvJndmS1uQZLe8bFjzPPDzMw646GdhbLx
         YJb37d1ofaFYgs8PiGuVjnR6GMyCXK+5xyOIQuVQv7nsP3vZTyXiUj22U6bqdMkSMh/W
         xmHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713201945; x=1713806745;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JvfVg3OIACHh186qJ/kodeeut9EMeQL1oz2fUu6nWY0=;
        b=edpzX3OCGGR77nAqktZBvA1J2KKwz92/qytYlwH/qfBXRbnBq69mwha8PaieYXYGkQ
         Pxp+nHzZt8zjc8iLPz2phIABtWSjfSffIYdpuYJnvuntygKcy+im+Zx5GJWLECyjeZ3t
         jusVBRVQ4Rdrg2HAPcDfLEl3rF2ySEyqInoF7eD1MpGhqVSWO76OzeD17ng9oW7/pCyw
         zxz7sFZ7w/evyZOjNrbDnXq/iL+vDQzGOL/ofFU6L1VFg9ZpV7LV015up+XhrvvVgr5W
         4uEzEDp/QfIvCSwdzYTYXiwU4PDSLW7o7zb2uWPl8qcH3Yu3ZcIoCCT1cJ879NQNd51W
         OTAA==
X-Gm-Message-State: AOJu0YwGTXRPTuXCYWsh3/ikvj3gHsLvgfkRsFnFvQDrGyCh0AxcwRkg
	TIs6qj5QaceUelQ+YHIO1Go2ahpliZSJNpyxSutDvRnDDeBTUZecX7G3O+Y77L0eXCA4KwqMN48
	ZDOecGg==
X-Google-Smtp-Source: AGHT+IHxnM1480CzxcF8GpLv+BdxL8ocAKHl+3ilY3zYXyspqu3qJCoPHU2WD1cPMqI6UVgHw6B4Zn/Awano
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:2d14:b0:6ea:ad01:358f with SMTP id
 fa20-20020a056a002d1400b006eaad01358fmr275792pfb.6.1713201945128; Mon, 15 Apr
 2024 10:25:45 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon, 15 Apr 2024 17:25:42 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240415172542.1830566-1-mizhang@google.com>
Subject: [kvm-unit-tests PATCH] x86: msr: Remove the loop for testing reserved
 bits in MSR_IA32_FLUSH_CMD
From: Mingwei Zhang <mizhang@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Avoid testing reserved bits in MSR_IA32_FLUSH_CMD. Since KVM passes through
the MSR at runtime, testing reserved bits directly touches the HW and
should generate #GP. However, some older CPU models like skylake with
certain FMS do not generate #GP.

Ideally, it could be fixed by enumerating all such CPU models. The value
added is would be low. So just remove the testing loop and allow the test
pass.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 x86/msr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 3a041fab..76c80d29 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -302,8 +302,6 @@ static void test_cmd_msrs(void)
 		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", 0);
 		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", L1D_FLUSH);
 	}
-	for (i = 1; i < 64; i++)
-		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", BIT_ULL(i));
 }
 
 int main(int ac, char **av)

base-commit: 7b0147ea57dc29ba844f5b60393a0639e55e88af
-- 
2.44.0.683.g7961c838ac-goog


