Return-Path: <kvm+bounces-19467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CF629056FB
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B26D7281F7C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F658180A6B;
	Wed, 12 Jun 2024 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gUcc01e/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FF918622
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 15:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206512; cv=none; b=tmMsosJQXpCvnO3NhpMTF4NGlY/ZkAwBXLyT2H1AT6kJD4QdyT25Nqfw5twtt5LWoJfBJ9FjUqTh/ScWuryHKCadu10Xh5cK6WCr92tmqTgwK+D4qKgzez2bgmXlFtWTds77E8R1FlEJ9zQRqpKs3UzMUUtfiz/wsW6+u8Pnn1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206512; c=relaxed/simple;
	bh=E+Hbk/hmtOzU7TT+zfxQKRwq7esr2uDrO1s3yBDGySQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=PX4QuGImAvunnAqzdo5P6SlgdE/U4QCKePS25XgsD8wCYoyDiwlZKJLHQV0Sh3jGpugA1+BzXmF7tqCA04IYNyUcVIbVPrSk6Z4xm/ZeMbrKJlsnOiXqhdnTrfL2rpTcJ/whBRowgNX/ZiJg0BF3YHbNgG3zEg1ypbwbZUzMTPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gUcc01e/; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-57a1fe63a96so9291892a12.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 08:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718206509; x=1718811309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+qqLWSg7tRM2gGCJAJtzdTrDQlMzenU32kd2gKR8s2c=;
        b=gUcc01e/OP3bo8oHoYUtlz0kWL6MJ6+a9wKe919mDYKjgRoKOANvFfsxKrpXwLAuUH
         HjjF2VCwZC9AfyB2usJlmobO7kt9SzLz/cC52LpxhQ6pCwgb9EA8yAOokf1gVxZPbrgl
         0Jk5nDu1VbXisM06FwvEBxmLfVBvmkhJRIoljM3dpGmVTaqyQXhhQWsWG25lXX7gxcPb
         kTxMKj7WLV9lZRwSz4LjQGBG3Sy4JwoJkzI3IJVZlWtcpadPOOmSuizS/bzX9CQi0NOb
         JSGZy1ne/DiWznrL+9IE1OLpzWqruIIzl9CC80vQy0tzk7ARMO8sPeM+0PH/mOGq98it
         3oQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718206509; x=1718811309;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+qqLWSg7tRM2gGCJAJtzdTrDQlMzenU32kd2gKR8s2c=;
        b=ChyeSHRJW1yuqM//c20+T9gcJW/3TFdVFZDVVATkH+2HcQbo+YYeM1Ud5I+eG2serh
         /qQTInsD5UXug70EYi9cdaQRPDTnpR1Ufhyd0oso8+By2DDuAaCUlpPGJxJOO63TztrC
         zTVEuRIWWOYJcdlvILu1WKLvy/ORgKf01psiRqTimMNNfpHzHVjIbYZnGrmGbtC+v+Gu
         dg36aUpuZzSirRIV+6GFiD+zCm+kkOG1dtKET6l6+lr9i07Mhh8POTNE8Uoejkhz6VlA
         vkZKPrBh/6vYfPfdO5XtB3A3YYC0clDlkKjRXtBleTxfD3O/tvAHHYF2EvvVMJg40xY/
         n04g==
X-Forwarded-Encrypted: i=1; AJvYcCXAMoZyAH72v/K3o7f19uTjjxp97SQMqQfHK2bTaLZ/TYFb91n1QjCPrbc/mqFGqxxuxaMo++iqLkXoNyDidDGCeF+h
X-Gm-Message-State: AOJu0Yy6I2YHVJcMaHYZ8iCWyFKPK/ha/HkMMxyp24JTvs6u9UJz6Tit
	UMR4aQxSO03VHYTkCnfhPWP60TFg73NX5QiaS4Rya1V4MOw1ViJjoaR5PNgVfTQ=
X-Google-Smtp-Source: AGHT+IERL/2jvHutLftjXOxlHqfrdjG3j3FdZVVa7m1ZXHMLA/R2foTn5KoIJagMPECFajcOPxgGQg==
X-Received: by 2002:a50:ab18:0:b0:57c:5764:15f1 with SMTP id 4fb4d7f45d1cf-57caa9ba475mr1540370a12.29.1718206508979;
        Wed, 12 Jun 2024 08:35:08 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57c855b959bsm5045462a12.38.2024.06.12.08.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 08:35:08 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2563B5F893;
	Wed, 12 Jun 2024 16:35:08 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	qemu-s390x@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	Alexander Graf <agraf@csgraf.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	qemu-ppc@nongnu.org,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 0/9] maintainer updates (gdbstub, plugins, time control)
Date: Wed, 12 Jun 2024 16:34:59 +0100
Message-Id: <20240612153508.1532940-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi,

This is the current state of my maintainer trees. The gdbstub patches
are just minor clean-ups. The main feature this brings in is the
ability for plugins to control time. This has been discussed before
but represents the first time plugins can "control" the execution of
the core. The idea would be to eventually deprecate the icount auto
modes in favour of a plugin and just use icount for deterministic
execution and record/replay.

Alex.

Akihiko Odaki (1):
  plugins: Ensure register handles are not NULL

Alex Bennée (6):
  include/exec: add missing include guard comment
  gdbstub: move enums into separate header
  sysemu: add set_virtual_time to accel ops
  qtest: use cpu interface in qtest_clock_warp
  sysemu: generalise qtest_warp_clock as qemu_clock_advance_virtual_time
  plugins: add time control API

Pierrick Bouvier (2):
  qtest: move qtest_{get, set}_virtual_clock to accel/qtest/qtest.c
  contrib/plugins: add ips plugin example for cost modeling

 include/exec/gdbstub.h                        |  11 +-
 include/gdbstub/enums.h                       |  21 +++
 include/qemu/qemu-plugin.h                    |  25 +++
 include/qemu/timer.h                          |  15 ++
 include/sysemu/accel-ops.h                    |  18 +-
 include/sysemu/cpu-timers.h                   |   3 +-
 include/sysemu/qtest.h                        |   2 -
 accel/hvf/hvf-accel-ops.c                     |   2 +-
 accel/kvm/kvm-all.c                           |   2 +-
 accel/qtest/qtest.c                           |  13 ++
 accel/tcg/tcg-accel-ops.c                     |   2 +-
 contrib/plugins/ips.c                         | 164 ++++++++++++++++++
 gdbstub/user.c                                |   1 +
 monitor/hmp-cmds.c                            |   3 +-
 plugins/api.c                                 |  39 ++++-
 ...t-virtual-clock.c => cpus-virtual-clock.c} |   5 +
 system/cpus.c                                 |  11 ++
 system/qtest.c                                |  37 +---
 system/vl.c                                   |   1 +
 target/arm/hvf/hvf.c                          |   2 +-
 target/arm/hyp_gdbstub.c                      |   2 +-
 target/arm/kvm.c                              |   2 +-
 target/i386/kvm/kvm.c                         |   2 +-
 target/ppc/kvm.c                              |   2 +-
 target/s390x/kvm/kvm.c                        |   2 +-
 util/qemu-timer.c                             |  26 +++
 contrib/plugins/Makefile                      |   1 +
 plugins/qemu-plugins.symbols                  |   2 +
 stubs/meson.build                             |   2 +-
 29 files changed, 357 insertions(+), 61 deletions(-)
 create mode 100644 include/gdbstub/enums.h
 create mode 100644 contrib/plugins/ips.c
 rename stubs/{cpus-get-virtual-clock.c => cpus-virtual-clock.c} (68%)

-- 
2.39.2


