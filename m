Return-Path: <kvm+bounces-60316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 28F3BBE91C3
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:12:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 36BEE4F4BA4
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1ED036CDE7;
	Fri, 17 Oct 2025 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJF7Ib2D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652D42F6911
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710368; cv=none; b=G9PyZ/K/zY5cvjpZkPgFcny9H1I/R5dJDK/OUiiTWw9lhlyVbnzodKq6ikZPo7s4NGN3emGfWhx5R7uJa0nZerGyxucZDUK+0dYt/VD1/X4qz2tPYhvIi9UrgV/sAY4yRaeDIjS5pbSxjKMlDC2CHW+yD8so6RBcYGL97WAv1XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710368; c=relaxed/simple;
	bh=fhQdc/TehWg2BTjnzi6hLrhzwpNj/lIV1nW3zz1Q2T0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=aIiCmG7yPof2vvO/jXwuPhzj87pmuyE53ASNzEsHe4hhLkn5E51PaaIylbverWU3XaOa390xlLUvPwrAjnatzLCvli7oChlOvUCTIaUzQHu4gzCFbMQLHTEz+/QlFbmhtULkoAupDANWQCP9IE8UOfx8uFij6MKoCzNzB+oov8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJF7Ib2D; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ee64bc6b85so2065967f8f.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710365; x=1761315165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gzW3ekQZ7Psj0DsMhnvdQfGfYGGMgoTsdSCNvzg/jEU=;
        b=iJF7Ib2DflG7cubtU9ylYfpow3ug2uAOtCgTFBn9pRU32LFD6xAKKrr0yg+7aMSTNr
         ub8ZBT/t6eZqRi1kxEsDNo8pho/WQA6goe/n095kR+Cq0oipj2JUAI3edXsV6KHnaaid
         lnVvTVUlEtZzUCzgq+KQHuQ/Qsc6Pp+HthPqx1XuTKL6cTDytJ5BowrSYheUoUGV+a1D
         8CVErV4zCxBsa3eV1jRI6lbpileq/rUZp7bMRgkV6Lcmv/YQKpMDgNtzN1uCJuP2fVXg
         b/a8oAzMtft6AKtJqQq6pD/wf0H2rvBbB8ESDEK8t/Lby7MUKzkLi67WPacUW9pJCY4R
         dFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710365; x=1761315165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gzW3ekQZ7Psj0DsMhnvdQfGfYGGMgoTsdSCNvzg/jEU=;
        b=WZSOXd9gxXHnAByN3IOw1iLfFn2aVJzSpVVEL7crFTz0UqSp5SyqGOa8WDkiiXQAtb
         NVfC5FRah3GDaO8WidT3tS0UR6Ky9TXQwqKDIGEDcAqZ06rKYCABIN9kJTMUmV6BWUEx
         vwY3ed6bMY4K/oAKok0brSRmoSCJtTgYJR2M+aBF4v8+CXtNFk/cvm9xEr+jl5+vutE0
         D90ghc/nJcfpAJGuQ2W8EG85f2Kw6z6dRe6z2iMYLBNdv3u85s1V5PotZKC6lyxGjv6X
         02zOCUtU3IQSnExLFQvl14Bz941+CWa7DgJOtdC4pFeopxu1XxQcOkxL5jEa53l+CIOM
         erUQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/sg+KUXKC9AOLJfWkWhb976F5RP7adt1ryZHdiwsi8tN4b9nttbTvX1eEZoUGIdfBYZM=@vger.kernel.org
X-Gm-Message-State: AOJu0YydVpYnwPG+gT9/TjcOAWEKyE9RtT0SqsEk6WfwP04vWtnaMViu
	l+aqHWVfLcEvG/06DziQ8X7kVpmyWnzDO1vk1eLXuWG+v01SSM8q+T7A
X-Gm-Gg: ASbGncv/0OrSRXWYeHzk3/w75755qPtzNJ5Z2MUwUQsPNvRCIqduYTtN+Msmv3GSaVV
	Jt5XG/XsnJFHO95zUjAUGpssMh9HiC3ZOxWFT2QQtiThOKT0J1pricK23S8FnjrDncAcUAVA7mE
	9fbaT4Iq+TQgpzdfEWp4D4OJTASNqsJbwhATN36ZeZiN4ZOyYhl4/GC4DnmiaOT5oJiv1wk3KwC
	BTH+VCfHkMKaE+nRiH+MvD1dO7Vbdoa13BhH6uAP52gz7CU9dQxB16g5AVYP633BDG6yDHdwgrt
	PKgdjqr5Fe/MZyNE9AVJ9iYHMsAwDfKLXyw88Iip0GA3hhGOiWo67W8/l3xfeTxWpopXW05XJLb
	Je8UopiqMLrg/xn/Dmf2bJ4yGxPfw7guENzBFCUK/StJbbgTu5wQJz3gaMohRrSgE/FEs3PzKvd
	58D6SWq9cedj71aSKYtclw+9viTgqj1JJN
X-Google-Smtp-Source: AGHT+IGeuxOJBWpmVCX3U1tHBDipCkpzrypzvQWf6sOPwcugLBzMa9b7CCp6AGBV0FZ+Pn8TPlDLZw==
X-Received: by 2002:a05:6000:25c7:b0:427:854:787 with SMTP id ffacd0b85a97d-4270854085bmr1487022f8f.51.1760710364350;
        Fri, 17 Oct 2025 07:12:44 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cb36e7csm51359675e9.2.2025.10.17.07.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:12:43 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Roman Bolshakov <rbolshakov@ddn.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Eduardo Habkost <eduardo@habkost.net>,
	Cameron Esfahani <dirty@apple.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-trivial@nongnu.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	qemu-block@nongnu.org,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Michael Tokarev <mjt@tls.msk.ru>,
	John Snow <jsnow@redhat.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v2 00/11] Cleanup patches, mostly PC-related
Date: Fri, 17 Oct 2025 16:11:06 +0200
Message-ID: <20251017141117.105944-1-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

This series mostly contains PC-related patches I came up with when doing=0D
"virtual retrocomputing" with my via-apollo-pro-133t branch [1]. It include=
s=0D
improved tracing and removal of cpu_get_current_apic(). The remaining patch=
=0D
resolves duplicate code in the test of DS1338 RTC which is used in e500=0D
machines.=0D
=0D
v2:=0D
* Remove some redundant APIC_COMMON(cpu->apic_state) casts=0D
* Resolve cpu_get_current_apic()=0D
=0D
Testing done:=0D
* make check=0D
* Work with recent x86_64 Linux distribution running on WHPX=0D
=0D
[1] https://github.com/shentok/qemu/tree/via-apollo-pro-133t=0D
=0D
Supersedes: 20251017113338.7953-1-shentey@gmail.com=0D
=0D
Bernhard Beschow (11):=0D
  hw/timer/i8254: Add I/O trace events=0D
  hw/audio/pcspk: Add I/O trace events=0D
  hw/rtc/mc146818rtc: Convert CMOS_DPRINTF() into trace events=0D
  hw/rtc/mc146818rtc: Use ARRAY_SIZE macro=0D
  hw/rtc/mc146818rtc: Assert correct usage of=0D
    mc146818rtc_set_cmos_data()=0D
  hw/ide/ide-internal: Move dma_buf_commit() into ide "namespace"=0D
  hw/i386/apic: Prefer APICCommonState over DeviceState=0D
  hw/i386/apic: Ensure own APIC use in apic_msr_{read,write}=0D
  hw/intc/apic: Ensure own APIC use in apic_register_{read,write}=0D
  hw/i386/x86-cpu: Remove now unused cpu_get_current_apic()=0D
  tests/qtest/ds1338-test: Reuse from_bcd()=0D
=0D
 hw/ide/ide-internal.h                |   2 +-=0D
 include/hw/i386/apic.h               |  38 +++++----=0D
 include/hw/i386/apic_internal.h      |   7 +-=0D
 target/i386/cpu.h                    |   4 +-=0D
 target/i386/kvm/kvm_i386.h           |   2 +-=0D
 target/i386/whpx/whpx-internal.h     |   2 +-=0D
 hw/audio/pcspk.c                     |  10 ++-=0D
 hw/i386/kvm/apic.c                   |   3 +-=0D
 hw/i386/vapic.c                      |   2 +-=0D
 hw/i386/x86-cpu.c                    |  10 ---=0D
 hw/ide/ahci.c                        |   8 +-=0D
 hw/ide/core.c                        |  10 +--=0D
 hw/intc/apic.c                       | 116 +++++++++------------------=0D
 hw/intc/apic_common.c                |  56 +++++--------=0D
 hw/rtc/mc146818rtc.c                 |  20 ++---=0D
 hw/timer/i8254.c                     |   6 ++=0D
 target/i386/cpu-apic.c               |  16 ++--=0D
 target/i386/cpu-dump.c               |   2 +-=0D
 target/i386/cpu.c                    |   2 +-=0D
 target/i386/hvf/hvf.c                |   4 +-=0D
 target/i386/kvm/kvm.c                |   2 +-=0D
 target/i386/tcg/system/misc_helper.c |   5 +-=0D
 target/i386/whpx/whpx-apic.c         |   3 +-=0D
 tests/qtest/ds1338-test.c            |  12 +--=0D
 hw/audio/trace-events                |   4 +=0D
 hw/rtc/trace-events                  |   4 +=0D
 hw/timer/trace-events                |   4 +=0D
 27 files changed, 146 insertions(+), 208 deletions(-)=0D
=0D
-- =0D
2.51.1.dirty=0D
=0D

