Return-Path: <kvm+bounces-60453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9650DBEEC85
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 23:03:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B1B724E51CB
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 21:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD12822D7B6;
	Sun, 19 Oct 2025 21:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LA/YY1MY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B019156661
	for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760907808; cv=none; b=GsI45YGyehisY933wde4fRYkZVuKWaKn4lge1KdVTBHIy5kFyUCv/G7s38YlgjNazSDkJh5eHjHbDdTQQw4Vx5JS86emK+gGDBOfWFrlaklrGDXIx1QQvaBXxFmThmpEsmJeXBoaCY5dkdB6GyTon4/QWgQDO4BKZ95imeQjuL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760907808; c=relaxed/simple;
	bh=By9E7lYdRxlaOJR/oKPPWHvdezshuFOjhtstdkHOEUM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ZKNz+C3SFUoswVBMVlqE2mWdHalvspm1O1IuM2fkWZcXgl9IXtxwLExvTMVzodgQdDAZpUaRfZk71ghBg6bFJwftG4RFMb5zQKEbd2sXHjBfdUs/ojXjXKEtku9vr38GKhiOM3R1UTIzSSKu6qs0eJjT27oQhfXFT10w+JcWXpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LA/YY1MY; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-63c0eb94ac3so6390530a12.2
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 14:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760907805; x=1761512605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/5xsUG6WLPbZparIfWCrq5hzPBogw4t3aogUtWePXKU=;
        b=LA/YY1MYdawRr6Y5I7qJ6O+njEH9NEGYg2mSlPPnhjUKjGwpjFDr7EWTIoWIW42KDT
         4ByCSv7fVwZyt0dh8y+N7O1CZxScSup6l7vgAQc1vaxlUdYPSu2Wx8LFvJ/ac+YkU3ES
         z1NWFhR8Rq1qew22Jyq385POANRBw6bd2jvnQ31MgMml7P7TvL4dppuFdA+C3LrIDhjx
         ol81vYkN4WytqrCSV42ofuah1tWX6f8XA9HOPAfKv2exLEZF0pzKIYvp1GUCeQUNZxV2
         UX8F8Wr0m1G+Kz8v07EhXwXGobSVvNm+BsY8EaEKxcfRqPUnLyrYshN64NIbC24Xv6LY
         aomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760907805; x=1761512605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/5xsUG6WLPbZparIfWCrq5hzPBogw4t3aogUtWePXKU=;
        b=N7Gw+oMM9Vm8iZLQRL1FzD19V0wsxDS2m/hFxwcHUIGciIquH2Fs9EnMZSE2hQ5/F5
         +RG3EWFzJn1AQsXLZ6Q4R1aCB9jRmJbTqbZcOY34Z8rrZ8vqIq4pq6u4FIxAAGWgfwyF
         4frJ3T0I5C1WHEeKZu3ZcEuKAWrAEqSHZ+FFwhVG2WCA4XgfqYSsUb9ai1mwVmPwv1YZ
         cgXKi+nbd39ozg6l3yZWavwe6BRAGsfYCewHTX7WLLmCU+mChug1mB/pKq4cJ2n6U0oZ
         Zqxwz5F7GYVcH671t/nyMS6TMHCxo94A3Ji4V1he3MeV1G4GmxrzFyf2UV2WGW9FAJRo
         K8NQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyuSxuzcd7ACGUnvOwCTAhv2OGfFut12fA1cPfecqXeEaRw1pE3By57AhFPl030R1PPKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfZAZz5CZyQ6NrT/6E2JnhwDQCehgHiJgMdkzQI9cTNdxkp9+D
	M3o/1cb4nZiCRMzEQhach/4DWTocIOqSSa6XFdFpIw2yYe1yI14A5za5
X-Gm-Gg: ASbGnctwMo7SRUU9pwPjgPKWWSzsj3USSvW0F0cBIXL+XQx/VgG/JNqNwGhW0OEKW90
	JKQ2Q2F3XahNYomMcj2sf8W69eOcaphJ1d1+GZSo16i1FM3G32KMQx1SoZLvSfk/16/Tm1wfTio
	d8yGtLgPrsgJQUbZsvSXRhBcaFSO38ttSH+Gi6mPSxboOJEWDepmstFAsFbsvRzSDufOKN29I6M
	cTrYDuvDhjvB3vrFn0ovSCDhZ9sxydwPjGZqRZFiBm6qCb8Fsqv8mQVVEsPcGzYxo6deGD1sFNu
	QL2iccnSgAT4vl72W0VRc8Wtlgru48kAFhO5eywVMqzh/T9HkBLRX/x8fHwW/TksQbaewyZWpIg
	DZ9N0Q6K4tsnRQ3zz7E1PVuEvR+KberCZfk3YJA7BaICrkMgfOiz93q6HzBfBx1wu5WLIsb2T6O
	OyTrupHOnCqvxadyM7qzhzQWunzX4F2fBQ54T31xtGEQuZ7YloMpvA5Hn1e5W2fhZMkCao
X-Google-Smtp-Source: AGHT+IH4tgIuX3U2EOesYznwiJ9M1OqncIKIcgC99vfyI7Cx11Blbd3601WSC9drtYlUz8URQ5BAng==
X-Received: by 2002:a05:6402:42c1:b0:63b:edcd:3d52 with SMTP id 4fb4d7f45d1cf-63c1f650d74mr12149784a12.15.1760907805205;
        Sun, 19 Oct 2025 14:03:25 -0700 (PDT)
Received: from archlinux (dynamic-002-245-026-170.2.245.pool.telefonica.de. [2.245.26.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4945f003sm5107655a12.27.2025.10.19.14.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 14:03:24 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	Michael Tokarev <mjt@tls.msk.ru>,
	Cameron Esfahani <dirty@apple.com>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-trivial@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v3 00/10] Cleanup patches, mostly PC-related
Date: Sun, 19 Oct 2025 23:02:53 +0200
Message-ID: <20251019210303.104718-1-shentey@gmail.com>
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
improved tracing and reduced usage of cpu_get_current_apic(). The remaining=
=0D
patch resolves duplicate code in the test of DS1338 RTC which is used in e5=
00=0D
machines.=0D
=0D
v3:=0D
* Don't remove cpu_get_current_apic() since it is needed in=0D
  apic_mem_{read,write} (the local APIC memory regions aren't per CPU)=0D
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
Bernhard Beschow (10):=0D
  hw/timer/i8254: Add I/O trace events=0D
  hw/audio/pcspk: Add I/O trace events=0D
  hw/rtc/mc146818rtc: Convert CMOS_DPRINTF() into trace events=0D
  hw/rtc/mc146818rtc: Use ARRAY_SIZE macro=0D
  hw/rtc/mc146818rtc: Assert correct usage of=0D
    mc146818rtc_set_cmos_data()=0D
  hw/ide/ide-internal: Move dma_buf_commit() into ide "namespace"=0D
  hw/i386/apic: Prefer APICCommonState over DeviceState=0D
  hw/i386/apic: Ensure own APIC use in apic_msr_{read,write}=0D
  hw/intc/apic: Pass APICCommonState to apic_register_{read,write}=0D
  tests/qtest/ds1338-test: Reuse from_bcd()=0D
=0D
 hw/ide/ide-internal.h                |   2 +-=0D
 include/hw/i386/apic.h               |  37 ++++----=0D
 include/hw/i386/apic_internal.h      |   7 +-=0D
 target/i386/cpu.h                    |   4 +-=0D
 target/i386/kvm/kvm_i386.h           |   2 +-=0D
 target/i386/whpx/whpx-internal.h     |   2 +-=0D
 hw/audio/pcspk.c                     |  10 ++-=0D
 hw/i386/kvm/apic.c                   |   3 +-=0D
 hw/i386/vapic.c                      |   2 +-=0D
 hw/i386/x86-cpu.c                    |   2 +-=0D
 hw/ide/ahci.c                        |   8 +-=0D
 hw/ide/core.c                        |  10 +--=0D
 hw/intc/apic.c                       | 126 ++++++++++-----------------=0D
 hw/intc/apic_common.c                |  56 ++++--------=0D
 hw/rtc/mc146818rtc.c                 |  20 ++---=0D
 hw/timer/i8254.c                     |   6 ++=0D
 target/i386/cpu-apic.c               |  18 ++--=0D
 target/i386/cpu-dump.c               |   2 +-=0D
 target/i386/cpu.c                    |   2 +-=0D
 target/i386/hvf/hvf.c                |   4 +-=0D
 target/i386/kvm/kvm.c                |   2 +-=0D
 target/i386/tcg/system/misc_helper.c |   4 +-=0D
 target/i386/whpx/whpx-apic.c         |   3 +-=0D
 tests/qtest/ds1338-test.c            |  12 +--=0D
 hw/audio/trace-events                |   4 +=0D
 hw/rtc/trace-events                  |   4 +=0D
 hw/timer/trace-events                |   4 +=0D
 27 files changed, 158 insertions(+), 198 deletions(-)=0D
=0D
-- =0D
2.51.1.dirty=0D
=0D

