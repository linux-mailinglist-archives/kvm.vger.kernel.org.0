Return-Path: <kvm+bounces-59255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DC51BBAF955
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B648D4E206E
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEDAA27FB0E;
	Wed,  1 Oct 2025 08:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HtIZADWU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3778027B35D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306963; cv=none; b=ieFO/1ihUoUgStfALUB/hrfZA1Vt/SbS98dDjkUzjmAmu4s7+Ol8HNlhDW2lUpPj2F2T9dRz5EL/A9dKx/5NGt7dKe3s7fXwCsXsgAjFcfcYbfPCndrOtr5j2M/IaLcRFYqplu6ETMrx9eb6imq8xYRiDx8U0dGWE4rNLbmcZWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306963; c=relaxed/simple;
	bh=vsctjK0e4fAQVIRoFerlRP1zBiKAkD9HoibEVA6y758=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IHKVJaXc+gFc9cm2KL3afGDw75pyyQQ5f9mkkqY17yqZLWLArbJ8mzhsQPrvEfN7sDCuvChkK1TVCFzlylqJmYrRYlB3uxOOrfM8a4EmurBQf5JAsVjomtlonSbP0zfIBwlCo6TekEn/AoQF0dpdHN+krfK9Nshdr76ZXGDchvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HtIZADWU; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3f0ae439bc3so3487388f8f.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306959; x=1759911759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IX+0YqpET4g31NDLY5+FZNI7uU5E3uyAuFWScssj2Zc=;
        b=HtIZADWUgoKimxsw6aB0gLOi7o2FeyWaY4MVaESB1EPtakeZi6cQaTd1dc9TirIgFI
         ++Fc15E8NVYqfhStDJjcezyxJ+8JThLuaPyLVNBZhLjZ5jBNmF0kKaM8LDudtoTy1GfM
         Q6d7s1Oga2SaA4MTPzrBMvQ5hlWi1GYYnA8ZHR0UXp58yzwSOpR/+SMQbGTIckJPWTRg
         PnPi2G3vrX6Po2rQ5cjNXgK26Azd+ifKxK5cqkbhOvs4auKe6BDYX0KGOHNnumPM0ubT
         lhM5hmEmODCPdPl0s24wu4XTdeYtNvbyxK79qiDdP7vLI/oAGebiwdchrsp2j8S0/YEL
         5bAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306959; x=1759911759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IX+0YqpET4g31NDLY5+FZNI7uU5E3uyAuFWScssj2Zc=;
        b=MkMIcMewm/w5rUlRXjvG0vxF2DUAAZAapqHfrHqiejqTlmxlvQ2jtKHQqBiGx7vXof
         K1939Rjj1/fSSacSkh22xE/pW69u30WEpo1aZy82qDeB7ddgVg9g7wNHp/7s4ItExacl
         MQUbJiIXycjNrd5AQp5mWD2hlhX2IU+Y/m6NfLjVJgdGxRz4lk+xqZxudeBal3ajESd3
         vJb4aUARWhHnpGepPiBeFeTgInrTav+2hSzs9kK6QuCM3gfSl6NDuXjmt166D6Ncj2I8
         bgx73pfBnjvluuDTUSYI14R4IFwX5gSwZP24YYVAnojnk7etryfVhwXYwGO38DZQlLb+
         un5A==
X-Forwarded-Encrypted: i=1; AJvYcCU3Ms8Btvjef05fFaQAzf7d0rqR630ULNtupWBUrXra3H0vFbejt+3AwgerR0BiPGP+VNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwudBohghLv2WtNCSLAikOor+ncJRbdc+/O/TH64ngGduXeu6dC
	SyZiDQyAmJFU9oZr8gRZiyKeB+obrzBsLoGw901TRzxzRQFDjg640VXYRF3xsxZ+GFw=
X-Gm-Gg: ASbGncvlPcJkh9h9ywkQwiAAOe9s979smWb4AeZx34xaoaze4f06oWfAAN2j1Fn8nbk
	iws4UVm3E4jEFaNERPtKljT6bUEFyFCR6Zn3PhvP9V8Hf1t6SH7RtqqKGjpqeWm/pvzb0oU86eM
	qtwZxbi7NV2RbKiWfw6g2yqeMGeyauTOpgziEQxK0jC/fisjKER4p3RV1YIIfuAyvh7VLq5k9bC
	o0L7BaoSbA8FXDvtrpcff3LJqWTBCMSBF7VRGG1w16oPlykoMfkI+8X8ztucwOUfhnu4F+Y5WHi
	ooih6XSvT2oFQb/HLtr/kGQQ7iwNXcbCT3nMdm9wPf6WEnvCpNym6gmE2BDAbWnDegD2xHL6DPm
	b17WoVobp6n/YdgMyWQtPi6NbG/5mnR821Q3+yu8N99lul1ne96CJp8eeojNIugODLi2d08xdRh
	/92hMy8fdME80m6O4F7MKgqxcJinwK1EM=
X-Google-Smtp-Source: AGHT+IE/8bf21R3sZXOBj/IBWXVsuZtflY0OYXywlOPEETSJRqRNNcj4CdTyXwOOx1Abubt3QQ+Txg==
X-Received: by 2002:a05:6000:220b:b0:3fd:2dee:4e3d with SMTP id ffacd0b85a97d-42557818464mr1936382f8f.46.1759306959396;
        Wed, 01 Oct 2025 01:22:39 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb985e080sm25891823f8f.24.2025.10.01.01.22.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:22:38 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	qemu-arm@nongnu.org,
	Jagannathan Raman <jag.raman@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-s390x@nongnu.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 13/25] system/physmem: Rename @start argument of physical_memory_range*()
Date: Wed,  1 Oct 2025 10:21:13 +0200
Message-ID: <20251001082127.65741-14-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001082127.65741-1-philmd@linaro.org>
References: <20251001082127.65741-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Generally we want to clarify terminology and avoid confusions,
prefering @start with (exclusive) @end, and base @addr with
@length (for inclusive range).

Here as cpu_physical_memory_range_includes_clean() operates
on a range, rename @start as @addr.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 7a9e8f86be0..e06cc4d0c52 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -185,22 +185,22 @@ bool cpu_physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
 
 bool cpu_physical_memory_is_clean(ram_addr_t addr);
 
-static inline uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
+static inline uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t addr,
                                                                ram_addr_t length,
                                                                uint8_t mask)
 {
     uint8_t ret = 0;
 
     if (mask & (1 << DIRTY_MEMORY_VGA) &&
-        !cpu_physical_memory_all_dirty(start, length, DIRTY_MEMORY_VGA)) {
+        !cpu_physical_memory_all_dirty(addr, length, DIRTY_MEMORY_VGA)) {
         ret |= (1 << DIRTY_MEMORY_VGA);
     }
     if (mask & (1 << DIRTY_MEMORY_CODE) &&
-        !cpu_physical_memory_all_dirty(start, length, DIRTY_MEMORY_CODE)) {
+        !cpu_physical_memory_all_dirty(addr, length, DIRTY_MEMORY_CODE)) {
         ret |= (1 << DIRTY_MEMORY_CODE);
     }
     if (mask & (1 << DIRTY_MEMORY_MIGRATION) &&
-        !cpu_physical_memory_all_dirty(start, length, DIRTY_MEMORY_MIGRATION)) {
+        !cpu_physical_memory_all_dirty(addr, length, DIRTY_MEMORY_MIGRATION)) {
         ret |= (1 << DIRTY_MEMORY_MIGRATION);
     }
     return ret;
-- 
2.51.0


