Return-Path: <kvm+bounces-27403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0BB99851CC
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 06:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8452B1F22D3A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 04:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D047153BFC;
	Wed, 25 Sep 2024 04:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXyH372H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E68314D29B
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727237088; cv=none; b=pyAyf3/nvo6zjz5PcgjzrpAleLC6BRm0Rmc6lXIrE5jVjs+I31aajJYbdi8wypWDjFJq7/I1kf/RjphQSH98pC7ew5CVVuzqDrE33AkN18iSi/ljXxE0+n3QBeId7XaDBSy4szhs7oICnsc/nXXc14Ksh/LF3L6MCvfoY2Yciqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727237088; c=relaxed/simple;
	bh=4omANBFai2DET+2RuHd26H/DXlWLFuz7XxNzGw4IuYU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EGAYHYQuS7Q7+W1TMM5u3cwbdZt3CBfFVe9959j4NYuy9Fe5lQ4XXrKnq9f5YrnIcb+gQQ9e615no3wgzem/ZMligWUiGVv0avopZbUQN3rZz1xidtp/j6C47mOT6J339D1z+7dD1Jv9drGVzsIDtOZltsHOvHKKjn+zamfMAbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXyH372H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C716C4CED0;
	Wed, 25 Sep 2024 04:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727237088;
	bh=4omANBFai2DET+2RuHd26H/DXlWLFuz7XxNzGw4IuYU=;
	h=From:To:Cc:Subject:Date:From;
	b=AXyH372H1EQXFhWVe0BLf5P8wyrOFMnnJW9SV5rEn4rMBUnvEw5/icF88hNnKZBdf
	 C00YUH8M4JdoOa9dtEJXXEoOPh5BPbSEMimVTAez20vkR4EyRj3STkTdOXWrSw21Sv
	 qReOQ5a73c4VBp88cCvAtsrDiLokc/WEbInZmSOvCr2pTYUQa7Pn0RIU3nVNdQbvfx
	 6Fey3XYSrPo70/zIpgPSssEDP74DJSjucPcpOyq2HoD0TyMlU8NBOhgwgaj+hHojsk
	 wTnoVeqGnVEDIXtRIO7sJXbALBQN+7fBy/3elSLPHwqNM4YedWH3GJVmHeulwx9dsQ
	 a5OMwZGGe5/qw==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1stJGg-0000000827e-0DCu;
	Wed, 25 Sep 2024 06:04:46 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org
Subject: [PATCH 00/15] Prepare GHES driver to support error injection
Date: Wed, 25 Sep 2024 06:04:05 +0200
Message-ID: <cover.1727236561.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

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
  better name the offset of the hardware error firmware
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
2.46.1



