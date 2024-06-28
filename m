Return-Path: <kvm+bounces-20708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3062B91C966
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF6B4B23720
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD6E13B5B0;
	Fri, 28 Jun 2024 22:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PFF8aZdt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728F6824A1
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 22:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719615439; cv=none; b=DW4vgf0VIcT2RFRluh64ust+ZLL15BjP8b674T9xO1PqcJMNN0czg78Og6w4REsemWiU0e3tZJ5q3weWES3aawdHDFstcOD/ta6HBRHMhfVIk30SnrCh/uwPClza8foP4u1q4kh0xTqXbEDnV4of47HRr/9ieaGOCTUmWj6Rt9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719615439; c=relaxed/simple;
	bh=0N53I7IvRtVI5T7cB3Re4x7De5UnRlFbk0KmzGPmLZU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JCeU7rVBcv/E0Rgg/S3CgZyKmlAJJ0oYmH5a+itCDXpCDcOMpwZP32S32agrYDe2ESDuC/bzJ8La4aGYEFA//8W8Tdf6hiORrWgyCjbHWePBpRTNSd+nMyoudXb1HH9yEsVKHMNmxaAny4KOWrvMZTQ2dq3vxV2HG9lpqcLAYa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PFF8aZdt; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62fb4a1f7bfso20771507b3.3
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 15:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719615437; x=1720220237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NeiKLTeYecaI7blKhL4eUGMIebS7L/6ZmCgbIaIBrbU=;
        b=PFF8aZdtdDHdwZclPsytdYsRwPq9kEszqWGUMGNfB2v2U0MUNzxjTEdc5weF/g0tIM
         swcTcAS15iLTyKyLd3XaXxGCYKgjZcZPWBNkH+XjNsy/SkIpRJ6UXRolXwWIJAc3Wh6D
         RCXHB3r+pI8/r6+2NSCNdsm7b9+h68C7ILkfAxjWoAnmx+HsmSqKhS/EuJKMz0XMBndV
         Rj/0Gy3ToMq4DCoTv+C5BZktgZ7SF4eSaD43Rp5DwlnVyQJqV4B5LAnEyNF8x+3N9QFr
         VR3XyPanZq56tKYMHzFggmGvn9weaxmKDjJ5ZtRqBFN/7PTgwaKVu1KErGmLv56j9436
         gDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719615437; x=1720220237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NeiKLTeYecaI7blKhL4eUGMIebS7L/6ZmCgbIaIBrbU=;
        b=A/cTSlt7ufcrznNMqDI+oWqZyR1nxYUlIsMrSU2n3BWne1rxGGXLmro8Rjav0/QIGO
         lByVf6jg8EgIMsqE879PL+FOdDh2Emxe3DdJbVGASMdPylAVevRV3rTaT32nVrgY5iFP
         he+T/UApgAEWhZRvAsH49hMtc4UxlzWYPO8hrGK2hI3No0mhVpJP/k93VXC0N9tCuLhH
         hC1nv6fr/YqkBN0CDgwdYY0cCJa1nwgCt5hpTmDnWZgnbRU1K3tB3BWYK/rr9fqf1HSN
         SlkplA1pkSDrfYXAzY7czZiAaYgp09k8T95ZM9ZR/omWkaTiAFMfHdWHXDwtoPZHCleB
         iTrg==
X-Forwarded-Encrypted: i=1; AJvYcCW3y6IsAJemSueMR+HZX67HnoU3MRh40ezaoLSBmZmAKRoL4+aYx/NY1Tc7HcyBkm29y/4kIgem6c5N0vXIo1YwK1Hy
X-Gm-Message-State: AOJu0YzobC2M1lXWVwGjnA7p1eXVHcUT7EbMHiwydZtAniejg66oUxSr
	ivk8bsW444RekGE8+UbMHcvOL7ig+fM3TU7z0ZSLeLzbXZEJNvhgc664cMu8unPZoFEAf0mz9P6
	DTA==
X-Google-Smtp-Source: AGHT+IHONDjsFi0Y4/UOoJE5S0o2N3JrCbgQstm+BXqMj/B4A4H59R0KqKFAZMVr5qhs563ZYaSpVwz8eqc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d4:b0:e03:5a51:382f with SMTP id
 3f1490d57ef6-e035a513a82mr239884276.8.1719615437498; Fri, 28 Jun 2024
 15:57:17 -0700 (PDT)
Date: Fri, 28 Jun 2024 15:55:36 -0700
In-Reply-To: <20240627010524.3732488-1-kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240627010524.3732488-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <171961446436.238031.3450027759536844841.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Switch __vmx_exit() and kvm_x86_vendor_exit()
 in vmx_exit()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 27 Jun 2024 13:05:24 +1200, Kai Huang wrote:
> In the vmx_init() error handling path, the __vmx_exit() is done before
> kvm_x86_vendor_exit().  They should follow the same order in vmx_exit().
> 
> But currently __vmx_exit() is done after kvm_x86_vendor_exit() in
> vmx_exit().  Switch the order of them to fix.
> 
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Switch __vmx_exit() and kvm_x86_vendor_exit() in vmx_exit()
      https://github.com/kvm-x86/linux/commit/92c1e3cbf0d0

--
https://github.com/kvm-x86/linux/tree/next

