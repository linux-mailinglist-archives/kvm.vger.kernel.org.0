Return-Path: <kvm+bounces-27752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8583798B527
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 09:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B38361C2243A
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0881BD4F4;
	Tue,  1 Oct 2024 07:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U48KyXAp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FD51BC9EC;
	Tue,  1 Oct 2024 07:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727766251; cv=none; b=kHrjGlseE61eTumwkxFJE/v1F3VHVLWU3J0X1oA1jgwqF3JBBJz3N9okSsWM77PrZsifLqEFq5bB586ODcIansn9+VDrwkb1F+NqbeCUNRMxikxF/EAXP/MAR5x4hUgfqFaOWeCpapbSrhA318MzqNN/QNqvOytVaIFlurysVos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727766251; c=relaxed/simple;
	bh=YxTGQndDRXUrIv1rcoZzDFrSZkpN1CHT/gS1t6B9Ipo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vh72BhbmxdBqiqyUpAUhg2OJWYccs7pnezxLkeOePeUo8q8HpT2FL85kQlTpOF/dx3HImpqEGvCDcqewle1yuzhXWJ+1NIFiwJLajRvEhitNcsRLMLZwYoRTeWfrzLY4484lPKHv1N53qGIf6f4i/hue9uAgEctZujtqz/rFQ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U48KyXAp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F49AC4CED2;
	Tue,  1 Oct 2024 07:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727766251;
	bh=YxTGQndDRXUrIv1rcoZzDFrSZkpN1CHT/gS1t6B9Ipo=;
	h=From:To:Cc:Subject:Date:From;
	b=U48KyXApci3UtxQWQZGJOivaoaBm54OMwNhLIDUKNMLk/lKydMXiobmwy5JQap02V
	 ycIF3JFoJWdIMs/UAvzUC3/ph6sbhe+8p9rONZY8gMkG5DaG6tCMFpQh+YRcE7TrE3
	 o2L/4EL8amY1ChcXXLqz796i7CFCMGM34YgBOWVx5K+r0l42fRA+2OayziUVTvJAur
	 WG4RpsH+W6KDcvbDE3UWuyXneac9Sa2ZoAHqJDlHanFq5uo1JxlRYY4tF6WRsj5t90
	 DsbjQketoBNk9Ar24iXB5vVQSgrEKe9hgWNIWvnXkFPCTKafUu6+l69lJCe1TiOWuN
	 0QE6YNbFDuxzA==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab@kernel.org>)
	id 1svWvY-00000001V0L-18y3;
	Tue, 01 Oct 2024 09:04:08 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 00/15] Prepare GHES driver to support error injection
Date: Tue,  1 Oct 2024 09:03:37 +0200
Message-ID: <cover.1727766088.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>

During the development of a patch series meant to allow GHESv2 error injections,
it was requested a change on how CPER offsets are calculated, by adding a new
BIOS pointer and reworking the GHES logic. See:

https://lore.kernel.org/qemu-devel/cover.1726293808.git.mchehab+huawei@kernel.org/

Such change ended being a big patch, so several intermediate steps are needed,
together with several cleanups and renames.

As agreed duing v10 review, I'll be splitting the big patch series into separate pull 
requests, starting with the cleanup series. This is the first patch set, containing
only such preparation patches.

The next series will contain the shift to use offsets from the location of the
HEST table, together with a migration logic to make it compatible with 9.1.

---

v2: 
- some indentation fixes;
- some description improvements;
- fixed a badly-solved merge conflict that ended renaming a parameter.

Mauro Carvalho Chehab (15):
  acpi/ghes: get rid of ACPI_HEST_SRC_ID_RESERVED
  acpi/ghes: simplify acpi_ghes_record_errors() code
  acpi/ghes: simplify the per-arch caller to build HEST table
  acpi/ghes: better handle source_id and notification
  acpi/ghes: Fix acpi_ghes_record_errors() argument
  acpi/ghes: Remove a duplicated out of bounds check
  acpi/ghes: Change the type for source_id
  acpi/ghes: Prepare to support multiple sources on ghes
  acpi/ghes: make the GHES record generation more generic
  acpi/ghes: move offset calculus to a separate function
  acpi/ghes: better name GHES memory error function
  acpi/ghes: don't crash QEMU if ghes GED is not found
  acpi/ghes: rename etc/hardware_error file macros
  acpi/ghes: better name the offset of the hardware error firmware
  docs: acpi_hest_ghes: fix documentation for CPER size

 docs/specs/acpi_hest_ghes.rst  |   6 +-
 hw/acpi/generic_event_device.c |   4 +-
 hw/acpi/ghes-stub.c            |   2 +-
 hw/acpi/ghes.c                 | 279 ++++++++++++++++++++-------------
 hw/arm/virt-acpi-build.c       |  10 +-
 include/hw/acpi/ghes.h         |  34 ++--
 target/arm/kvm.c               |   3 +-
 7 files changed, 206 insertions(+), 132 deletions(-)

-- 
2.46.0



