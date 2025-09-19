Return-Path: <kvm+bounces-58101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31749B878ED
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 03:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 577527B917D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E575325FA0F;
	Fri, 19 Sep 2025 01:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QNaMHQKw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50983258CD8
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 01:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758243609; cv=none; b=MJlJWMCUV/O3NZ8JPsjRE4ojDTuMN8+i1DCmEFP6IcqkcCYEq7fRWOhOq9JEewnLqjoU9NZsFG3LfXJ4Sd2SV7vZJe9HQrWLcVzq7ur2v8aSMjLGfwQLveEikRfAGCFF+CWWEf2/6u8EljZmstub5u03+zOjpfbH0FGzSDaNkpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758243609; c=relaxed/simple;
	bh=LsLpFAxR2r/kYmw7xHJtCSmeqll4la2sZk2Tqpzc9oc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o7p+28/3uIUbO1kX7PkVrvS4l7WBfgfXd3i02pwodRreR670V/a7UzJCWb2Fi933dh1pgXgwsaSHudkAiG7xEo8MneHFx7dePWwdH//nNqWFLQlWOytRosUNg/u8LcrVS+8VZnCDvgImCRpSWDd4KEf7EbCGhxhH9ecULAd8InA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QNaMHQKw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eddb7e714so1521902a91.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 18:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758243606; x=1758848406; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2SCjX/C9Pl/3F4W6bLgbAPLvNsr2cRYsD9OSEcrvFjM=;
        b=QNaMHQKwdDRuKv/nJSRn9hSD+jnscU1OLxtt6X3XdulK6AxSPy5K4tPHsU6yftI33L
         hF1PmpzG6I0Ge2VO88F5967IljV+ImmAAkkKyWbLuBjFIY94mcSnpBt4uvQiuli+H8/X
         gW71nsR/ggpF/MvOxljHCY9UXyRs24d3QY4SgL/GRPVkWWPt023gdm8XLe+CdTR/ZIDD
         jfulmXfdkczbib+sIXXjEBc5anNOQx4trgnUX6HioO4hxfU5wvaf66TqYcy+exIeo/M9
         rdqkbWYBUbEbjhyycQmWIHiCPXrN3Cd/YuSxJIRlpksRZyU7qtGbs9KjtmQul6Ny4O7b
         PGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758243606; x=1758848406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2SCjX/C9Pl/3F4W6bLgbAPLvNsr2cRYsD9OSEcrvFjM=;
        b=Q167p1jlTeFUQHh5yLfx1/JRdkrY85ppxvFugnrfixibsa1JKRW+4DyhtaoE+Opd6h
         4KMiE5hsGmZPwFYTbfCsd7GP4vCesWl8VZ+TB1XM3CNcGfSkD/gnKDzf/PEFQgKQpNXp
         tqC5QaU7zGzBWaJ4nxek1pwcodf8hOfF1Vm0h/zLQkQTMa9tYHEnJg7uwjCr640tG5sZ
         jKh2837fSFwkZKOGeN7j7w+AanxDYN3cikD0Wl2qHMfW/h3N3ZD5rDYYUS5dOpRVS3qI
         QHFTAWG56XjBnnsVrFARFxw2YOEUJsIKWbSLOoiWZmRerHqVKI5LywCn418owe2MoJLm
         k7NQ==
X-Gm-Message-State: AOJu0YxGDqs94n9se/3G5U667fAJlYieCwIzupYvBA6mMu6wIIBxaRS7
	cmbn5wVQeEIu2+b5tbIRgswQbPvnIbhepVw8y6/cMlScNXIhiCqMpMWk3yrTgavPduo6zlJP/+x
	bgmVzjQ==
X-Google-Smtp-Source: AGHT+IFUBVqY6omtVwJGu2LCApfEsfDNlkWkBfC9sU/rre8XJpYtigGsjXv/+phjEKVu5Y5A7dIXEO9/TmQ=
X-Received: from pjbqi4.prod.google.com ([2002:a17:90b:2744:b0:327:50fa:eff9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e12:b0:32e:a59e:21c9
 with SMTP id 98e67ed59e1d1-33098379102mr1492674a91.26.1758243605678; Thu, 18
 Sep 2025 18:00:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:59:51 -0700
In-Reply-To: <20250919005955.1366256-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919005955.1366256-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919005955.1366256-6-seanjc@google.com>
Subject: [PATCH 5/9] KVM: nVMX: Add consistency check for TPR_THRESHOLD[31:4]!=0
 without VID
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a missing consistency check on the TPR Threshold.  Per the SDM

  If the "use TPR shadow" VM-execution control is 1 and the "virtual-
  interrupt delivery" VM-execution control is 0, bits 31:4 of the TPR
  threshold VM-execution control field must be 0.

Note, nested_vmx_check_tpr_shadow_controls() bails early if "use TPR
shadow" is 0.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 253e93ced9dc..5ac7ad207ef7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -555,6 +555,9 @@ static int nested_vmx_check_tpr_shadow_controls(struct kvm_vcpu *vcpu,
 	if (CC(!page_address_valid(vcpu, vmcs12->virtual_apic_page_addr)))
 		return -EINVAL;
 
+	if (CC(!nested_cpu_has_vid(vmcs12) && vmcs12->tpr_threshold >> 4))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.51.0.470.ga7dc726c21-goog


