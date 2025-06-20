Return-Path: <kvm+bounces-50174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C67AE24FA
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 00:19:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A31C5A2A3F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 22:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 177F5242D9D;
	Fri, 20 Jun 2025 22:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B1fTMjpl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B74923D290
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 22:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457920; cv=none; b=b0Y4js/UDxcsEmupTBSNZdKeuB2/BxkquXQeAgbotlJZX2rdmOmg9PpXyq3xZk66z/E/0PDm/H9IxANhjTkBkr0yyl+THGxmbxfOC8aCWhcmiJCEisQ8qGewaorvPFowOR+d+S7fMNQyjB7UUjYsuy1GHtkY8fU14XOSU/AI+vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457920; c=relaxed/simple;
	bh=ZTAgaNMzI4qiekOqkv3pNeLxj5wOqxlFzSL0ObZQoaI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tkfGBU4vELfnsKbObI8CguOlDqm349Jir2Wc1c5of96vmzlVVT1DT/FuO/X9YhK33SH+MYM2TS7zyqTZyWtB0B6ZH5aAdcrZuF7vAoAM22kYtJC3+Tn3j0B/Gweo9un2qJbVIjGkii6UVtjunifsgeszUs7XAbKHfAw/IrqsNWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B1fTMjpl; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddd5311fd3so26855745ab.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457917; x=1751062717; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tgz/COFsBAperIPw3jbaNsXNDBcCpCZIFlLHMRVJgqY=;
        b=B1fTMjplXpGS1iTbK6dYeZ95fWN25oPNuUEbaLnxmiqKHrvP8hGzncZCU33rzqojcg
         uYmnJ1g+kLVwiCdMxgEeuptR2jPqu8cAKAtFlqFVlTXogG+MpLeRWABIeaE5neV8BxAo
         NQz8QLdEVf59XiyH13SvbeOAq3n9oK0rRM6eBZamwYZ8RgoQ5qSsaPNIGfSQBG3Xgcs3
         zX4qOxT6Hm4ET9WfOW6KlTX/PAa9qArUfOz0ZPcMHSet9ckoLHrh9K9DhpE8mXUywYhr
         NSmfD1+kGK0XIpfVQCWvk/RtW/ZEeOO/ALT4Nf4uKW+eHq9VZjkYtdyLnyotyzMQj2ZU
         Kmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457917; x=1751062717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tgz/COFsBAperIPw3jbaNsXNDBcCpCZIFlLHMRVJgqY=;
        b=ojg9GfJ7eQOHYAzd1pARxkmulUjB2nFw6L3f3MGJ7BnKRZzUkjbYiS1qaMjRlu7PWe
         dGPkZfznvhXs0sP1RtMGb+zI13M3qSq1Gz1b/38f7LI5NfB+U6k1An3queyQyhStGE/b
         5M/DJRgONlKg6N5biz4P6xAbeA+EattUBQihs2hWb3tlI3fsKA9EfGZTzexsAKBAx7Qq
         4QJbVAXk/iOtEcRbjgx47AgMwwjS73y/0qpnJ523gjP3N60iVInrsVVpZTN0VF8KdXQn
         lOnSZJXXS8l4hWVp4tx8iF1C+6AHNg3hMn8/Ki0bveHLDv0JFBi9rTueOPC/P1tTfGtH
         LSow==
X-Gm-Message-State: AOJu0YzlEvW5rXjDUo2n7H4eKBNOYxx/OqcQ2mFjchjgL9U0hABfvHA7
	dI7cKgVlODl77zpNzqzeTmfXleeF7ArseYNieufX4ljyE3PCNwTSOyW2uk7mzLRyivCbVPJC23F
	+U2Ym5m4sy/t6cBEBNOStDRSIdaslXTgcrbApDNBoJNXG4WXpfXbtCVJiTsvVTIc/0khzr97f/j
	IThUy6fUtQyajEdUv5dRzn4/3rnAlhlE1OtqIpNniv+v6JWIyy0fgd+LxKxFo=
X-Google-Smtp-Source: AGHT+IGjEFFNY2ukf5QiVzn6d0Iwii2o/2bYlxITJ69QjxdmPFLoVLBssIQF8Rhp8gGY8wow9/U+VX25kMai0q6pUg==
X-Received: from ilbee13.prod.google.com ([2002:a05:6e02:490d:b0:3dd:bec6:9d56])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1646:b0:3db:86fc:d328 with SMTP id e9e14a558f8ab-3de38c2e1c2mr57720245ab.5.1750457917550;
 Fri, 20 Jun 2025 15:18:37 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:02 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-3-coltonlewis@google.com>
Subject: [PATCH v2 02/23] arm64: Generate sign macro for sysreg Enums
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

There's no reason Enums shouldn't be equivalent to UnsignedEnums and
explicitly specify they are unsigned. This will avoid the annoyance I
had with HPMN0.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/tools/gen-sysreg.awk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
index f2a1732cb1f6..fa21a632d9b7 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -308,6 +308,7 @@ $1 == "Enum" && (block_current() == "Sysreg" || block_current() == "SysregFields
 	parse_bitdef(reg, field, $2)
 
 	define_field(reg, field, msb, lsb)
+	define_field_sign(reg, field, "false")
 
 	next
 }
-- 
2.50.0.714.g196bf9f422-goog


