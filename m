Return-Path: <kvm+bounces-50471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE35CAE60C0
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 11:23:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17AFF404B9B
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A8BB27AC57;
	Tue, 24 Jun 2025 09:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i5ojOb+d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1607D279DDA
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 09:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750756987; cv=none; b=h/RpZBKr/ZPKQ8jE0lZGTo4uQlRGej1/Dm/thSSgTG6yZYQemQRa8ZEAD8webuWWwmPXlM3DE2z4MxwfaiVnBL1iwUUnCTU44q0j6DCaFgWVWRjSIVae0Ccl7WSyyWFh4ET3uci6ZL1M92RE8tr1JXwvMRn27U/wMx5r+YU6FV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750756987; c=relaxed/simple;
	bh=NLpwGNqu1U+2tmsJ+aXz+PezJD5PodPVGzOyX33N4OA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qNKr0K7RySBm90T1ba6ySZwgvaOqsHKHsMzP2q49pmY/3Qy3427Qr9rH82q7lG0qH//gDqy3Yqwa2gwvOt2DUZVwW1NEyc63EkqXbrN7pu90eeXqijSQtqfDSl42gFKQP5HYT3Q9odGIBJOVE4zouR8Zgq+aj6hoexEQmsHb1zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i5ojOb+d; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a6da94a532so1610619f8f.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 02:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750756984; x=1751361784; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AVN7ijrerqrKRgMyDOXBQhh0QAZU9NZB9WAJvr5lBS8=;
        b=i5ojOb+dr85TwLkziSC7Yye9WZaJ4eweQu5cjgU5MrNQwhnwn1gyLyAz0fCjl5Nbnk
         eCvD1Q8Me+ECZ+eS/1GbwRWZXa8C1AMYaHYrWpFs8DfQx/eVcpr++CAKJ492Bwu2Kolg
         SbCi4J0Q+7nWTskjuwEnxS/NgaA6C/aNJuK1jzCDCLdY7p4Ckej7n3wrpsvd2yPNXHzJ
         lgWQeD9x7mceSzBKswvJ0hgi7ezK2mhkHfvEACoyk5iiKOgE7Yux3h00cIfKr1S4aKt7
         BGo246v1S2TCD7eb6gf4Nrkjy1OtNsNGNWvuKTC5Y+FyLJ53IMcXpao2jC/LRG35LJls
         FD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750756984; x=1751361784;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AVN7ijrerqrKRgMyDOXBQhh0QAZU9NZB9WAJvr5lBS8=;
        b=LXknMNyYwsA94wTVePzmPRTCi4PZUjx3rMskS+F8EyBDt0VI3sT9WifLFZcoTEKmHM
         qjT5fUpjMEEXl3S5yzywSnXaqoTn8/67gBT0YBpLyDZ2zFm3gV/t65w9wJHEYLb6VgfY
         18fu/mzAzwz8Qj+2cPgDnfzYcVmLGazDdbmL1g2EJcHxjfW0l0qIPsUGw2I8KwWs0DHc
         3D7hU1PRt6CuFcNg+2ahgPLRv7j2Ke64FWzvuxm3QoTeldVQAsS7KfP6scswFGmxsIAE
         ENkSdM7ULLWoOCD+eqIiHOKp1L/i8yvYgdIUm6VsKrzhgjtWV93TYMj8sjpYVf55qN9H
         aq7g==
X-Forwarded-Encrypted: i=1; AJvYcCVp32uk897lLOkuQkSzoQvaq7hKlwiKHrzTWe+jvUyke6JhA1dDb8IDd3TMXEJdMUn03+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhcquWfS2pzDkuDaLRPcOPzERyzDzZUVMNBVdwqvamkM3TWqfz
	V4fXU3kO0+x/f6LKEC1Acl1Ew277NC59y27dc4RDQBEqBgd+T5G6/by27vlaDyq061wD120Pkas
	3HQ==
X-Google-Smtp-Source: AGHT+IGqR5KN60A+DlDRinsD9PxEgoB+9GsV+BbWlwoRfvGJZm269VIx0emnCkjD7fUm89pZbzqZPn7R9Q==
X-Received: from wmsz14.prod.google.com ([2002:a05:600c:c16e:b0:44a:b793:9e40])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:25f2:b0:3a4:f8fa:8a3a
 with SMTP id ffacd0b85a97d-3a6d12de19dmr11877837f8f.18.1750756984556; Tue, 24
 Jun 2025 02:23:04 -0700 (PDT)
Date: Tue, 24 Jun 2025 09:22:52 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc2.761.g2dc52ea45b-goog
Message-ID: <20250624092256.1105524-1-keirf@google.com>
Subject: [PATCH 0/3] KVM: Speed up MMIO registrations
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"

This series improves performance of MMIO registrations, which occur
multiple times when booting a typical VM. The existing call to
synchronize_srcu() may block for a considerable time: In our tests
it was found to account for approximately 25% of a VM's startup time.

arm64 vgic code is cleaned up and made responsible for
its own setup synchronization, and the MMIO registration logic
replaces synchronize_srcu() with a deferred callback to free the old
io_bus struct.

Keir Fraser (3):
  KVM: arm64: vgic-init: Remove vgic_ready() macro
  KVM: arm64: vgic: Explicitly implement vgic_dist::ready ordering
  KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()

 arch/arm64/kvm/vgic/vgic-init.c | 14 +++-----------
 include/kvm/arm_vgic.h          |  1 -
 include/linux/kvm_host.h        |  1 +
 virt/kvm/kvm_main.c             | 10 ++++++++--
 4 files changed, 12 insertions(+), 14 deletions(-)

-- 
2.50.0.rc2.761.g2dc52ea45b-goog


