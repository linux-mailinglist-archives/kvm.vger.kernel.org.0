Return-Path: <kvm+bounces-13677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B2E8998B7
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:01:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 256F71F23EE7
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61CC515FA8D;
	Fri,  5 Apr 2024 09:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WeISPJDE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173EB611E;
	Fri,  5 Apr 2024 09:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307668; cv=none; b=aQFuWImfjfVcjbD5KpFVJhsOw4vc1LDu9EqzMX0Axe52aE7mTfn5Nmb0HGzId3OqVwZQRUGPlzFF0sJLBV0v4+4fsi+7hVyhqpjlLUn/xSaqztZpZW0ujdChXXyRkpr2nLFwDHtCvvyfyPG66qaWFGp0/yB02QppHXQL7z0hXBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307668; c=relaxed/simple;
	bh=2DLlYhed/nh73dIMIHSWhwKFVemru08OyxDmfqOJgKA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EVS0XRD31OZvZ0DUHhHGSHtxuECeavMauLVw37b+tNay4yOs00rBH7t3AZaxQbpEukHqLnkbzob89JqoGbI3u5VdhrtpVtQx0H3urst+Rr2xFIhFJs5qfnvEYKgA3zcFsvIkVl1rxZVtVbWEfiewPIy7EZv73QbzQBQra/qpSF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WeISPJDE; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6ecfd29f65dso635527b3a.0;
        Fri, 05 Apr 2024 02:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307666; x=1712912466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wI4DwimW0m+Dm8ZQCp4DenGm21I2AM0p3NfyF7YdsYM=;
        b=WeISPJDEk+DdzdpiDBDDj6uMdNr/mFlG0J3LaOl5+lG4nm8k7posFynAAaTJ0h9oCu
         f4l6STmfY7ZeooIT/8TSb+z6IjNqPc09LmXRv3YuHWJYOE61wNEVPVnkrvU6xKySL0Zy
         rc/A3sNHoS84E3pOx3RlwOtkZJV0I46N3yFGiddkhNHKOjREVRXxW7/g6584VYaukydS
         9y8HEgOJdAxKerFmzJ6qsQ3SVkD2NCraWbWI2R+8Z+xNDW6pmglCmwo3KYGGCOzWETVX
         ceBPEQvA9HGU7i6uVydyDbZdg9aA++JxaFJRbo1OijK+jjl+irg19rTuFbL8S+aS+3cJ
         dyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307666; x=1712912466;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wI4DwimW0m+Dm8ZQCp4DenGm21I2AM0p3NfyF7YdsYM=;
        b=qzpzCZmYQd/5wNp3hkPxafC6EaJuNFSHglWbR7VhaWoK1+8OEyGMlHgV0rkuLumnJg
         hdDofUsaibWwPKMlqnMKaCDq5V+h5HA1N6ytM+ahf7gT79XfCkO/RNkwVYJE8LeU8JiY
         F9zZ9Ta6dWMA3regKYyCGNCSdoLivCS5rNsmhbdhT+fk4S8UcFSu47+rPYyy+rn3agDo
         zvF1UjSbLS6KI2wmD5UFMYSc3er3xrTK5QiN74kVlU9IXQRBhL4Wmr5aRjm6JE8MEI28
         zkAB5K9QsRVauDKxiQjIyJsRKWcwD5hCpPQeT4OF6mzYae/REVNuMgATlQ7T3fOdRR9R
         SjYg==
X-Forwarded-Encrypted: i=1; AJvYcCVgnURQZMKgk0VpI75nhhHNGu54YxeUKfOdYiKGk8Vr3O7HxOwZIxLkimg/p0rkqHjuhSdbqqS/iXsFvHmWZboBZvQ2sHLok5vRJgfK2Act0jFcT9iZKBDFAGpGEsChEg==
X-Gm-Message-State: AOJu0Yw1Qzx1eg9xCMdo6thFQvNqQH0xquxuGy6mq8kj6uYY24e8mYeM
	fZViIM3fJXvI3bQBcVhDKYDBYAIX6iCkfTUSDd89GCsgJbljZ2M9
X-Google-Smtp-Source: AGHT+IGlcBi2VUkohcnGRD3fzDjABuKFi3W10RhRfQ1OuAg3W7+E3pA6bb2h+PqEKmLJKinBlGe9vA==
X-Received: by 2002:a05:6a20:2d28:b0:1a3:57b4:ed1c with SMTP id g40-20020a056a202d2800b001a357b4ed1cmr1173245pzl.25.1712307666319;
        Fri, 05 Apr 2024 02:01:06 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:05 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC PATCH 00/17] add shellcheck support
Date: Fri,  5 Apr 2024 19:00:32 +1000
Message-ID: <20240405090052.375599-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I foolishly promised Andrew I would look into shellcheck, so here
it is.

https://gitlab.com/npiggin/kvm-unit-tests/-/tree/powerpc?ref_type=heads

This is on top of the "v8 migration, powerpc improvements" series. For
now the patches are a bit raw but it does get down to zero[*] shellcheck
warnings while still passing gitlab CI.

[*] Modulo the relatively few cases where they're disabled or
suppressed.

I'd like comments about what should be enabled and disabled? There are
quite a lot of options. Lots of changes don't fix real bugs AFAIKS, so
there's some taste involved.

Could possibly be a couple of bugs, including in s390x specific. Any
review of those to confirm or deny bug is appreciated. I haven't tried
to create reproducers for them.

I added a quick comment on each one whether it looks like a bug or
harmless but I'm not a bash guru so could easily be wrong. I would
possibly pull any real bug fixes to the front of the series and describe
them as proper fix patches, and leave the other style / non-bugfixes in
the brief format.  shellcheck has a very good wiki explaining each issue
so there is not much point in rehashing that in the changelog.

One big thing kept disabled for now is the double-quoting to prevent
globbing and splitting warning that is disabled. That touches a lot of
code and we're very inconsistent about quoting variables today, but it's
not completely trivial because there are quite a lot of places that does
rely on splitting for invoking commands with arguments. That would need
some rework to avoid sprinkling a lot of warning suppressions around.
Possibly consistently using arrays for argument lists would be the best
solution?

Thanks,
Nick

Nicholas Piggin (17):
  Add initial shellcheck checking
  shellcheck: Fix SC2223
  shellcheck: Fix SC2295
  shellcheck: Fix SC2094
  shellcheck: Fix SC2006
  shellcheck: Fix SC2155
  shellcheck: Fix SC2235
  shellcheck: Fix SC2119, SC2120
  shellcheck: Fix SC2143
  shellcheck: Fix SC2013
  shellcheck: Fix SC2145
  shellcheck: Fix SC2124
  shellcheck: Fix SC2294
  shellcheck: Fix SC2178
  shellcheck: Fix SC2048
  shellcheck: Fix SC2153
  shellcheck: Suppress various messages

 .shellcheckrc           | 32 +++++++++++++++++++++++++
 Makefile                |  4 ++++
 README.md               |  2 ++
 arm/efi/run             |  4 ++--
 riscv/efi/run           |  4 ++--
 run_tests.sh            | 11 +++++----
 s390x/run               |  8 +++----
 scripts/arch-run.bash   | 52 ++++++++++++++++++++++++++++-------------
 scripts/common.bash     |  5 +++-
 scripts/mkstandalone.sh |  4 +++-
 scripts/runtime.bash    | 14 +++++++----
 scripts/s390x/func.bash |  2 +-
 12 files changed, 106 insertions(+), 36 deletions(-)
 create mode 100644 .shellcheckrc

-- 
2.43.0


