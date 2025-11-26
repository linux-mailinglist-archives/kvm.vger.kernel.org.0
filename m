Return-Path: <kvm+bounces-64586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C51DEC87BC7
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 02:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 66A904E4033
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C3130C355;
	Wed, 26 Nov 2025 01:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vt/j7meV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCF530BBB9
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 01:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764121507; cv=none; b=OdfJwr0QNK5giwfmqiA80pzkcpv2UHDa3bePE5E5YJEfZzNAz+36MU4T582mbd3DwKNyC6S0xaGfxp7B822/bY93wKgGRVAbwLr6rH66avWZTw2hfTBvzochK6kJZqs+kyOJ/rO897MRyZpsngGfvb/KTHmAfd9R8DckgDzs91k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764121507; c=relaxed/simple;
	bh=7FT7D7Ds7uPE4OpiJHH7w4Jr/Ed+BmB1+OifHStKJw0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NJ4dDDfkqIbyZqsLRMaU7SxViGvO7PQH7l4Dz+/sWoI5b2of3HUkgdewRn8+LKSKGjzj4GjtQIXn9fryGuUrY6ejVCxBygLsS46OEq/kAgM5w0qqxBCS+59cxxVHjIdoujcJvC52pjwIRKc28PIbzBLVzNHMGjbn9UK60STr7JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vt/j7meV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34378c914b4so16335323a91.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764121505; x=1764726305; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ubPeBhCsOGgl7/bQOgh35BG+WehMifDtZg+5jSaqPf4=;
        b=vt/j7meV9IeUavtN/+Cd+LNoZZ3N+Pj3eqKMSVpEGI7Ee4OWzIfl0ptZHChayfIBHa
         5CVETesnmwApZlw1ZaxY4I8ODbmqWS3K6luQTm+hCu+H/ETEVOINGsO14o+VFRySrrlV
         hatWiTVhF9Bx6jIXm6idqra4LKgdhayOfdiuGlTalz+d6iva3le06678iBX4JpBeaW5Z
         4+KiULxh8g/VxYME/3Cx1lOfe5pMP76nKSdII37dijDBCSpA3wO5IDhUTCghjoXCbpri
         1Wz+vlGzR3M3e/7ziqHojLH/Sv7C3dAiQRYNjBYK6CmxP7YO/d9qMVlCAWktoh0v6Fk/
         tt7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764121505; x=1764726305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ubPeBhCsOGgl7/bQOgh35BG+WehMifDtZg+5jSaqPf4=;
        b=mtjTVrJMx7b2FGxdyix5MMJzEmWvNkaaEL8X8/5vsUDgoDkG4EvPT4TASYV/3hlWqo
         x9Qwq/sm4utX/Km9THXq3z6Bc9or5d7aBLPxuJmQB0pP5hSf0z8qQPo41iklk+T0jXDh
         o7fxUkpIFV+VeJDjKcqU/Ax5B0ZT8Du2T08LfehctDj4lDM9UkUQXj019lBFSKdKXQ1R
         zhhx1zGHkhxf8pGNb6XQTlHFZZMlum8TTrSIWzoiiaFb0gKAoDGktl60nuWeh3Ygpddg
         8f+jT1MH6K3Nx95ckTJVIOtdxCYQcvLnQs3VIuDxr5RXEXi5ZLxvBtBvc7yc/JmtCBxX
         aWQA==
X-Gm-Message-State: AOJu0YzXAcEWqSSZEsWl4+GKYjJ6wOokWfZqT0VzAl/tHJZjhHo0ruqi
	SD+3iZw6Oz8p/bFFHc6byghN+cn6F/W4ULN3H2vggIhOyOyY2YGSY3olcr/36rLb543qwjrYc6M
	ejRcF3w==
X-Google-Smtp-Source: AGHT+IHTwgWgvBbWEEtTZQaq7mTQrUQrb0WvEC4T38Ff+vg6npKuJnxhRxbH5v5sUvtjeQmXHfCD1i4+lqM=
X-Received: from pjvf16.prod.google.com ([2002:a17:90a:da90:b0:343:7087:1d21])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d40d:b0:343:66e2:5fa8
 with SMTP id 98e67ed59e1d1-34733ef6e2dmr18764951a91.21.1764121505153; Tue, 25
 Nov 2025 17:45:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Nov 2025 17:44:51 -0800
In-Reply-To: <20251126014455.788131-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126014455.788131-5-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

An optimization for enable_mmio_caching=0 and a minor cleanup.

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.19

for you to fetch changes up to 6422060aa9c7bb2039b23948db5d4e8194036657:

  KVM: x86/mmu: Move the misplaced export of kvm_zap_gfn_range() (2025-11-04 09:51:06 -0800)

----------------------------------------------------------------
KVM x86 MMU changes for 6.19:

 - Skip the costly "zap all SPTEs" on an MMIO generation wrap if MMIO SPTE
   caching is disabled, as there can't be any relevant SPTEs to zap.

 - Relocate a misplace export.

----------------------------------------------------------------
Dmytro Maluka (1):
      KVM: x86/mmu: Skip MMIO SPTE invalidation if enable_mmio_caching=0

Kai Huang (1):
      KVM: x86/mmu: Move the misplaced export of kvm_zap_gfn_range()

 arch/x86/kvm/mmu/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

