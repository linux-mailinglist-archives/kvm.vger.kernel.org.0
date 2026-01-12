Return-Path: <kvm+bounces-67810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C05CDD14761
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:45:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 78AC03051587
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7A837E31F;
	Mon, 12 Jan 2026 17:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wkz2cVjD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAF324397A
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239736; cv=none; b=Ojm9zVHNgTjqGOckkV2vrih5t6QHfztnbQs43gn/Hc051KmEQdawUzVDZkf9iUHWPH+jvMZB3rdx/J6JiMAexXqkqie/vNfIUwueyYcq77dKJZ4F7BMpsuyy9XbvfZYgWUOX2AYDbVd2ygbW76LkuJk0771yP8PXcc1vi3O7d0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239736; c=relaxed/simple;
	bh=VzCnP9eiupLpePiHSwZLVuj5ssn5dd1cbk6U5LaMpI4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fk7XU/okMyDGAfj9sOdMLU7cRFSKP9T3hl2ftxqXF8DDBnza/CboLe95fdIR44Q0n8M8kR2lL4M+YJSCJo81DxUaxW32dtO6kjhzXTFiOg+XxlaYwxEuZg24ooA/jLimHECEPY6LVD7Qoidep3NISkJyMpowaWO1jfcoj+Bi6bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wkz2cVjD; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-81ee4f90ef8so2018811b3a.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239733; x=1768844533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hF0F1wYHks88ql+q5tFmnuZk1jksWoy6owIWqYKviSk=;
        b=Wkz2cVjDGM0C5vIrvLAwQTF2UgMbQ9AZAD8g2wF4Sqx08AweHgfh9/Lt9VsAmGo0Pw
         hD6Y9TBzW26gpEeVWvbSMmQfO42TkdfJc6fg6ChTG5k+8McTjf/cLZiwp+Yv/va/SaZh
         9LShRojv11XPsTqhezRckLwLokGu/yA24cPVNBOJ8qUXzDmXfRiYliK4gcjV3lgIawy/
         55GiRWvIZstTtYJJsDFzd7rPtYSWyfBfnSWrn2SKiXrhEyYiMs+Z6s5D8l9kOQ8T3hYe
         aeUWdLrJDkqd71bXJ5qpSkcxqAPe69BOquzpF7KlJMlvHXtgOd/ezG1Hp93RijEojz6e
         sFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239733; x=1768844533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hF0F1wYHks88ql+q5tFmnuZk1jksWoy6owIWqYKviSk=;
        b=nh3o1GAo4/ZI6KDUxl5Xjh6Hhjm+TaBjCai1aZa1l4FbqqPBdhlrOJmKqG8BdDaOKS
         RxdVpMwgzt5lJDxq190RMM6kWL14LSCDb1M+SOwaEpe3uxpALjPEj71Wm2c7/QQgmpiO
         QyWVhRRMHSVXhUAWhcswb/2bpCh06rXqWwHOTFTMhvozjhTPBDASqCqGzZtzHxZh/A5H
         1RSmCDTUB1ATgvEjoj/UCw4QBxRy6sjmlkUeF6A0JchIPAo9sMg+zPLxOw0O0Te1wpO4
         j+RL6pgVa3ZNhehI8Ro0VFiNARHLIm0ZaTJN8c83bY2wk7doBp9f4jB/5PK6J1eEANrC
         64QA==
X-Forwarded-Encrypted: i=1; AJvYcCWPdCgd0eBhAlpdv4LwSZGduzawISYUC/3Bc1qOm+dMUDC0/P2YDDbQy0oe017aE6Gu8Ps=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBwKk9UkSVMer0yRGsdcwXAsQx8QOuW/Z2u8aKNBemKy4R1Fy8
	/nvmLXD5QIY76ifIHrVVu6lgpljMyBPxDiNCfHnDc4nEjsB5EGE7bZlVMlWyThLEXWzkMi1DyDL
	KdkGJig==
X-Google-Smtp-Source: AGHT+IHAiTZ5/n/hYqVbrJntap0IKOSyiwf5IseZZtDEeh+eB1yG4jNLVZUOt635znoR5FLQYWwHxD1bbJY=
X-Received: from pffv4.prod.google.com ([2002:aa7:8084:0:b0:7e5:5121:f943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:bc91:b0:81c:c98c:aebb
 with SMTP id d2e1a72fcca58-81cc98cb60emr14422230b3a.61.1768239733376; Mon, 12
 Jan 2026 09:42:13 -0800 (PST)
Date: Mon, 12 Jan 2026 09:39:02 -0800
In-Reply-To: <20251121204803.991707-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121204803.991707-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823870995.1367937.15505376193038248820.b4-ty@google.com>
Subject: Re: [PATCH v3 0/4] KVM: SVM: GIF and EFER.SVME are independent
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 21 Nov 2025 20:47:59 +0000, Yosry Ahmed wrote:
> Clearing EFER.SVME is not architected to set GIF, so GIF may be clear
> even when EFER.SVME is clear.
> 
> This is covered in the discussion at [1].
> 
> v2 -> v3:
> - Keep setting GIF when force-leaving nested (Sean).
> - Moved the relevant selftests patches from the series at [2] here
>   (Sean).
> 
> [...]

Applied to kvm-x86 svm, with my suggested fixup and the order of 1 and 2
swapped.  Thanks!

[1/4] KVM: SVM: Don't set GIF when clearing EFER.SVME
      https://github.com/kvm-x86/linux/commit/8312f1b9dd71
[2/4] KVM: SVM: Allow KVM_SET_NESTED_STATE to clear GIF when SVME==0
      https://github.com/kvm-x86/linux/commit/6f4d3ebc24c6
[3/4] KVM: selftests: Use TEST_ASSERT_EQ() in test_vmx_nested_state()
      https://github.com/kvm-x86/linux/commit/bda6ae6f2966
[4/4] KVM: selftests: Extend vmx_set_nested_state_test to cover SVM
      https://github.com/kvm-x86/linux/commit/ca2eccb953fd

--
https://github.com/kvm-x86/linux/tree/next

