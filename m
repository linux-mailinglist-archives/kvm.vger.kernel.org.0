Return-Path: <kvm+bounces-40452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12DB0A5742B
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:56:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E916B3B0EED
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2B3221F35;
	Fri,  7 Mar 2025 21:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qySPkWTJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DC320B209
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384595; cv=none; b=O0X4m5fZ3NL8PHWG/Nd/3E6/NRPmDghpkJXyWCJSKmB+W7zByiOotmtyN4SUGU4PtSGDwBZyw1jRJuCS2Bu7ush9GmDmZUQUs/iTHdx2eeJGWTa490H/VGNvbjuBscir4qKBlNtzAYpRIWo9EjVERD4Hdk6m+p+AgFbBpG1QbrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384595; c=relaxed/simple;
	bh=M6XMBSkl/eJ3gIb1fGr0kCK7MTaXP0njZB0cQsXdc14=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=DAc9pxnW31BmyFl3pbPgz92beRzvrRlJ0dKZ1CFOtfHYeVHn7skDuLDAxx97p6qzAxIQej8nAqjjwqCthJJOBGD9Zlan7la0YIYTC9NC8JGeZglrh84eBz8x5KnaZtLa2bYTbnB1sN8RTDhj+BSm8QtICPZTN55Yp8aiEz3cCJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qySPkWTJ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2235189adaeso40782575ad.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 13:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741384594; x=1741989394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vmW8mpO+51LbriEKWobYb1vkwz08PyFagyva1YCnsvQ=;
        b=qySPkWTJBwn4D/lzN1WXEkjrkvKEuID5Y9jKCH4mEyj+YMYF9rqDs+RfYYFZ34A2+j
         aZGMcucAHuvBDLHut4SWMVBt82xmtl1FasgT+wi3hD6bXr5OLO6T3oq5mvmf2EcIau3i
         ibOpK8u3I6T2HJ7+WeygaxwUGSsTKMPHezCh41mL0uBUe+Zbfa1C27228m2iP86TIoNF
         LaEt2M91oD0RtPBpUM7oGf6DylWkaZ6NmfqEuVryzXAAaixGQr9ph+TtuM+fvwvqUZgq
         9KZg3CrP20tV/xXDj8zfulnJAwpx+7FOEyIAMrblYyX/UkMx2PH6kVx8+Mj05gCP84J9
         KJ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741384594; x=1741989394;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vmW8mpO+51LbriEKWobYb1vkwz08PyFagyva1YCnsvQ=;
        b=TMNF2YNjEIYkAYDCm1VHJXRLxaKOuE3nSkoefQNXLt2nbPxyqkW0C666TPzHHWVJTf
         ZZqoKbZRiqpk+7sFkkxW7hecnw5LzE0chLxw4bHvWxTSetXAMGb6SBt5XYksBX+p0DQa
         xdHnNhivTVlPdiTyilRe1HUcrp6hvTgEuRdFQLb5md1FzN9Bcy4g76mv/E4A27M+hoiQ
         w3oawcysKk3gRh3JutwoMmQJAp2owvt8qyXvMvUI3KtVJhx8yOjZ6izfL0Ng3rAU9DTf
         bR2TiROdBBhksfu8v2y6wzFU8oTl+GNigfgy7NfyQo3UTZMW7ZEHEL6GNrh3/tjvSpRq
         rrqw==
X-Forwarded-Encrypted: i=1; AJvYcCXb7dLreedCmSzBXXxKPPCBc6z1kJ5LSRx4V4ko+/c7BGImifI9CETghDzbq1k0SIZCJXc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo/27Ic4D/K4IrUtwa6l6dsSGYpBWjkg2K8S/zYZX1rJlIA3Rk
	RKweco7aFHilzz2If5cOtVeM5f8UcJgbOL6sFP/FExzz1IECJLy8s6jYF34Q1u8=
X-Gm-Gg: ASbGncvSuMueWgYEpvjlEGtJZ0+8d3bHClKnAdK3lxEPzvrtaJCswQsKAbcJ6K7Ka9D
	f0NjVSnjH4yrmcVUaex2sesX3EfuK6bX+6jm6/5jrGDB6w0JByNBd6F8P+QAnszYVY9iOBZPFbb
	sB53keyiJjuIbMGKg/iJQsoxaFhWExtmmn32O1cueeQsGI5hMfASlzmgmYv8E7XrHqVUESO6UkT
	0qff6KHcBdBeKbzj0ABbw/56JZMffTZBQ9o77wQsypvzHfh4jA+15rjcUKKSQrrSy0IhDuz66Rz
	F+V+2C91EPQK1kbZMHV6DoNsUjbC2IMe0azGlMeJbKWd
X-Google-Smtp-Source: AGHT+IGZj5v3f7xS8vJEb0p8ApYtBb9xYLDO7DIkJnv8r93Ui68HFQrEuHLB+G46dT5oBoz88XrvPg==
X-Received: by 2002:a17:903:2f82:b0:223:fbbe:599c with SMTP id d9443c01a7336-2246452f784mr19947915ad.19.1741384593835;
        Fri, 07 Mar 2025 13:56:33 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736ac9247dcsm2000927b3a.125.2025.03.07.13.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 13:56:33 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v4 0/7] hw/hyperv: remove duplication compilation units
Date: Fri,  7 Mar 2025 13:56:16 -0800
Message-Id: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Work towards having a single binary, by removing duplicated object files.

hw/hyperv/hyperv.c was excluded at this time, because it depends on target
dependent symbols:
- from system/kvm.h
    - kvm_check_extension
    - kvm_vm_ioctl
- from exec/cpu-all.h | memory_ldst_phys.h.inc
    - ldq_phys

v2
- remove osdep from header
- use hardcoded buffer size for syndbg, assuming page size is always 4Kb.

v3
- fix assert for page size.

v4
- use KiB unit

Pierrick Bouvier (7):
  hw/hyperv/hv-balloon-stub: common compilation unit
  hw/hyperv/hyperv.h: header cleanup
  hw/hyperv/vmbus: common compilation unit
  hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
  hw/hyperv/syndbg: common compilation unit
  hw/hyperv/balloon: common balloon compilation units
  hw/hyperv/hyperv_testdev: common compilation unit

 include/hw/hyperv/hyperv-proto.h | 12 ++++++++
 include/hw/hyperv/hyperv.h       |  3 +-
 target/i386/kvm/hyperv-proto.h   | 12 --------
 hw/hyperv/syndbg.c               | 11 +++++--
 hw/hyperv/vmbus.c                | 50 ++++++++++++++++----------------
 hw/hyperv/meson.build            |  9 +++---
 6 files changed, 52 insertions(+), 45 deletions(-)

-- 
2.39.5


