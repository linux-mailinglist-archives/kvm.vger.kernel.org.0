Return-Path: <kvm+bounces-9780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C237867080
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D06D3B21CBC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE8AA5D75C;
	Mon, 26 Feb 2024 09:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AYNUoSo2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61125D753;
	Mon, 26 Feb 2024 09:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940329; cv=none; b=tgdURhSfrjN0OInuTLR6qgPsT62q+rV5kdqC+Ly3PRI3ngEtYzXFw0rqCAj8oRexuBaECBpfT6bJ+ZzjCrp3PlbbYRW+EI+esz0Gox5Ney6TfDPQxCBY5TE3PF+J1UoOCICbDeszRuu8hFiHAmD1zvi8WPrZ4/9v7Hvy9xSXd0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940329; c=relaxed/simple;
	bh=BZa2CYxdxcryjEo1CdrUSVmtZW8t0c2cn2PR8OdYQJA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=agWptva1qp4feGdWU3eVyrOOIWmGbXd0BDbac1bwk7wSCUsP+GRHVwPq1HzKxKu/eZ54s/3sojb2XV4ak0I0tIRvTGmH9+2tEkIRVadZT0M583COvgJ3TQSWqJq/GIzVoJ3NiZ++Fr57ApG6SyhCAJhNQACx1WfKG39WNSeeHsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AYNUoSo2; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2997cb49711so1120722a91.3;
        Mon, 26 Feb 2024 01:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708940327; x=1709545127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E3G/NyHHNl3Usb0b+rbhE6Rkccfmxj4qh+DyqPiks1E=;
        b=AYNUoSo2wE32qJTgaDuocjyLijJ5qPko9rNyyzBJn705F+gr+zNWlRFkJlW43I2gkc
         jWOhoPqH3H6h8FZZe3/LSSqhRQiD9H1mToG8KdE5SZHU7BggZPJF9Oe6gr1UdkBNHvhw
         Np2hIFcQHUGoP51yqMSyVTYq0QvHbU2oeOMWHEQY9CmqVAqBsegQJT3X5yvrNyfkPMHv
         INFr8NMtKtEZOz5FDcXP75RfpZoWEJRBloZD8s4M5J5Z4G+FKVLP79wVYI8yan62reAX
         qMUBnTk4gYmmC+Qx6j5mO//oTb9/GUSeB+uttgXK84nh89Cnidh2v/AkCE3zIPYS4FMR
         tNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708940327; x=1709545127;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E3G/NyHHNl3Usb0b+rbhE6Rkccfmxj4qh+DyqPiks1E=;
        b=XwlKzhhz1Tcq74cs6g/jhi7rBV/tQA3i7MEzPO0f0bXpe55+4FB5PiIKDXtQjuVf/Y
         P7e31xPIATMf+zyBcWzuSQG0LzfRiVIPQ1RjjoJveTf34VCVUdWatrP4mVJi2mmiFGgA
         zOYquXSANR+skDRkjL3jSx9jWR8xWbzM87lvFdEVMV/KWtUVpDFGCV8mxprXUMudKu+N
         9XOYGOnhqiL1eHH7rkIfDC1nYTGHI0L86EOIs1Z9CZTLyrX20zKY1KYhbQk3xzLEmQDR
         X0Wr2Ui3iMsGDxASWYWqHIU3vmEOnXpzJt1Ny/85V8nJ2H7n71z0x0ZDSJLl7dJAPRv/
         +0aQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZdf0hJNkSAdAwhcbRUdrs2W5/V2GBNiWaLhUftDRIZW5QVInovncNfxXdHeiusH/cLgjkdfZ4YdFOl8kHFEvmJt1yBErbtgAE6aLj98Fs9TY6lgPDzV4qCbnihk/zow==
X-Gm-Message-State: AOJu0YwcANbQjahXG/+UYcYJ6H6JRhWJG8tPntMyzA+c81Ic+Ii/eMj2
	xUdPhuqUy7RIe/yR9PkTzNPfXJ34FFCUI+jGpjbgU41HQeR9k4O0GnMkxBDG
X-Google-Smtp-Source: AGHT+IGMwqjc4MYINbePOp82r8OWn0Ybag/WhoYmigaBPWKyvko3+xObzrZwGy7/pnjt3jaEplP3kA==
X-Received: by 2002:a17:90b:4f47:b0:29a:cbde:7607 with SMTP id pj7-20020a17090b4f4700b0029acbde7607mr950982pjb.21.1708940326863;
        Mon, 26 Feb 2024 01:38:46 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id pa3-20020a17090b264300b0029929ec25fesm6036782pjb.27.2024.02.26.01.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 01:38:46 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/7] more migration enhancements and tests
Date: Mon, 26 Feb 2024 19:38:25 +1000
Message-ID: <20240226093832.1468383-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series applies on top of the multi-migration patches and just
has assorted things I've been collecting.

- New migrate_skip() command that tidies up the wart of using
  migrate_once() to skip migration.
- New "continuous migration" mode where the harness just
  migrates the test contually while it is running.
- Put some migration tests in gitlab CI for powerpc and s390.
- Add a test case that can reproduce the QEMU TCG dirty bitmap
  migration bug.

Nicholas Piggin (7):
  arch-run: Keep infifo open
  migration: Add a migrate_skip command
  (arm|s390): Use migrate_skip in test cases
  powerpc: add asm/time.h header with delay and get_clock_us/ms
  arch-run: Add a "continuous" migration option for tests
  gitlab-ci: Run migration selftest on s390x and powerpc
  common: add memory dirtying vs migration test

 .gitlab-ci.yml              |  18 ++++---
 arm/gic.c                   |  21 ++++----
 common/memory-verify.c      |  48 +++++++++++++++++
 common/selftest-migration.c |  26 ++++++---
 lib/migrate.c               |  37 ++++++++++++-
 lib/migrate.h               |   5 ++
 lib/powerpc/asm/processor.h |  21 --------
 lib/powerpc/asm/time.h      |  30 +++++++++++
 lib/powerpc/processor.c     |  11 ++++
 lib/powerpc/smp.c           |   1 +
 lib/ppc64/asm/time.h        |   1 +
 powerpc/Makefile.common     |   1 +
 powerpc/memory-verify.c     |   1 +
 powerpc/spapr_vpa.c         |   1 +
 powerpc/sprs.c              |   1 +
 powerpc/tm.c                |   1 +
 powerpc/unittests.cfg       |  13 +++++
 s390x/Makefile              |   1 +
 s390x/memory-verify.c       |   1 +
 s390x/migration-cmm.c       |   8 +--
 s390x/migration-skey.c      |   4 +-
 s390x/migration.c           |   1 +
 s390x/unittests.cfg         |  11 ++++
 scripts/arch-run.bash       | 104 +++++++++++++++++++++++++++++-------
 24 files changed, 299 insertions(+), 68 deletions(-)
 create mode 100644 common/memory-verify.c
 create mode 100644 lib/powerpc/asm/time.h
 create mode 100644 lib/ppc64/asm/time.h
 create mode 120000 powerpc/memory-verify.c
 create mode 120000 s390x/memory-verify.c

-- 
2.42.0


