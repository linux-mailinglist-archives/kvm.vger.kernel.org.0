Return-Path: <kvm+bounces-40102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5150BA4F333
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:05:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F36697A4EAE
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7576C1339A4;
	Wed,  5 Mar 2025 01:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oAA4SsI8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617D24AEE0
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 01:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741136726; cv=none; b=qV+L/txT77m6H0aM0OqSz1qGw6mJOvIXQgi8K6LPxoxRnWp5MH8E63kXTuIreJigeKiWsYmmB+ZFoUFLXfkaS8G3LzfIrzcOw+vO+Y0RxDbjefhlC7k7LcXF+FBz4PsqbhQWOpNfmJXYL0TQhUrSUPJc1t5qdfTWKmWG6KkVCbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741136726; c=relaxed/simple;
	bh=wShgWdPbM6jGU2419za23vFDM4K7IyG90XjDg/wsL3g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tUJIejfcXt8oQhcEDm9ZDnlm4wMtJjQGuD7PUzCGVqXnQcJWdYULX2mJzDG/xediK6VLOeI4FHOCsHBfQxoTAQtwexgsf8kLMtpmsG8o9dh62YUgWgApzL7EUzyZ6Hdoj4VG0m7ntv55ft568EV3pILZLFSPYc6StJkyVlqyZjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oAA4SsI8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2235667c974so158449555ad.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 17:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741136724; x=1741741524; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PyytL6RWgngZAWNTVxaJae87poWubuVZXsEbznEraZ8=;
        b=oAA4SsI8CpJOJKK5zDCYCd5Jxs7iQIiAkXeV/jwLlwEsoSbCv3tg8V7qumYQJqe8gm
         /ZxVaMWDps9hc/HZAEvOw+x1/2coVVi6dkLwxiCKHNoho0pfHQMwaRpcxdKtOQ+bEToh
         +tRtH+Z6g8aAnZAzL/drQ03x/nkWt6pryxfVXXWh6VmpOWv7jAtCQytxRx+EMb89/r/d
         xTcKAdW0PJAqy6kLnSvm+LmtLvDRIg3Lkmg5GatusPKKCtsyMAxOFOodoAEH9fqrFSgq
         +EbvSQiuutMVr/bzsUyWKgGIxMocOc8J3ubNlY2MidpZ4v9+UJ8B9A44V1kulQBqYd1+
         UocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741136724; x=1741741524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PyytL6RWgngZAWNTVxaJae87poWubuVZXsEbznEraZ8=;
        b=auu1ODjmoJLSNokBqHkioTmHfDJjgqPu7IQH0bRGekKBp+xqGPCxsW+GjJqqgvPtLn
         IMlqSDN+iZ2nZY1/tc57apPtDHcDlT7LPPqplpyu46V7ay71hW8/gb4fPmIuGhDIb9EY
         xHmSvRTYMVJziwEEJIsT7LlCTNJSNrmukUBfTR0cd+/BDE3zKO0OnSLR2TVYeBcBRtBA
         m2JWPFgDHLcQXXSxgQkuyPZfAa2FbUTFBOZ0NkaKP81Ote6rY8LoLhsUWVVYjk5v0I/E
         3bp1m7FhcEJQoulOceBJNmGwArkPSC23JW9uVKM4zVCMhWDbsUZ2xO9rjSoT+3HVHsDD
         b2PA==
X-Gm-Message-State: AOJu0YzsBqipOMtAsXtutGDcRppQ6kagkqU2toqlZCm4juTbqWCt/A8S
	spflbeMQEcAqS6OnWKRvIVESNU2WQlPwXU7OhHOn/8aQ0DmhHTrpUxq6Vs/+zf+hFzLau/3oCVH
	ewA==
X-Google-Smtp-Source: AGHT+IG7hrL8iysRg7HI20C5pg/n/j0wepPak7RC2J0Nx+UI5UHj705nm6UvLybs+TWHmYoX5vcV95KuZhg=
X-Received: from plbmo13.prod.google.com ([2002:a17:903:a8d:b0:223:637d:8bf7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc4e:b0:21f:dc3:8901
 with SMTP id d9443c01a7336-223f1d2645amr19814055ad.34.1741136724598; Tue, 04
 Mar 2025 17:05:24 -0800 (PST)
Date: Tue,  4 Mar 2025 17:05:08 -0800
In-Reply-To: <20250228230804.3845860-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250228230804.3845860-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174101637372.3904037.6271235554709270288.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Ensure all vCPUs hit -EFAULT during
 initial RO stage
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 28 Feb 2025 15:08:04 -0800, Sean Christopherson wrote:
> During the initial mprotect(RO) stage of mmu_stress_test, keep vCPUs
> spinning until all vCPUs have hit -EFAULT, i.e. until all vCPUs have tried
> to write to a read-only page.  If a vCPU manages to complete an entire
> iteration of the loop without hitting a read-only page, *and* the vCPU
> observes mprotect_ro_done before starting a second iteration, then the
> vCPU will prematurely fall through to GUEST_SYNC(3) (on x86 and arm64) and
> get out of sequence.
> 
> [...]

Applied to kvm-x86 fixes, with Fixes and Closes.  Thanks!

[1/1] KVM: selftests: Ensure all vCPUs hit -EFAULT during initial RO stage
      https://github.com/kvm-x86/linux/commit/d88ed5fb7c88

--
https://github.com/kvm-x86/linux/tree/next

