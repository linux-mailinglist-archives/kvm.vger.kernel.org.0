Return-Path: <kvm+bounces-32346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F2C9D5B7E
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 10:12:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33BE228285A
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 09:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D3D11DDA00;
	Fri, 22 Nov 2024 09:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hicpxZG2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436A21CACE9;
	Fri, 22 Nov 2024 09:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732266709; cv=none; b=DBQB+CAavF4pju4pk9fbiFTGOrDOGySNrVr8m0cTccT9fbkjIa9TK0R45w+TnqnPf+waBZ4k/hViEQ8qosHFi2VqsC57g1/VL0W7ikq6Y4NkrOCbIgAmQbChnXqQ9g4LQtcRkxzIbdvT2HS7Z/n3WSgVVO/Wg0W+eY/3ih16fDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732266709; c=relaxed/simple;
	bh=qKfL0lpeQe7vMNvWc+52krTVhwa9caxmXJXwYVTO5NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DpmNmhwow34O6zIm2d82gzwna/mZZphHt7UdgVit7apzQ6WcMYoPPNLRUczbYIyMqUgZxOVNx7rFbnJ32QnjFIlHXSM4ddO0EJM54Vg/u2AGNRD2BjqqOb2pwRUcoP72ohaHbSO+UIT3+z25Tco2GOJG2cO+JkxWpMipK0sTTQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hicpxZG2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79965C4CED8;
	Fri, 22 Nov 2024 09:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732266708;
	bh=qKfL0lpeQe7vMNvWc+52krTVhwa9caxmXJXwYVTO5NQ=;
	h=From:To:Cc:Subject:Date:From;
	b=hicpxZG2RDz2cNDb4J8Z3NXf7HweFZSJdwR69DK3Zbi3z3X1hk3gWdKnildZXhahv
	 xrmiaO8yWXA91QrwRv7SR3WeS25Ht++UZWOnS5/Ftz6n5IXW1CeNdzp1Isr56gE3ZR
	 eGGOGHckhhXZqoXvX5G9Y2kjja2x407mgKAIEa+5OL3se04hUeCM4UiuroGvUZ1Ttj
	 TaSrz2Y0oT+mB/mxvc3VrDrOjki9oVBZxtRnYwAtVdAITZW90qN9eYZe0JfyUjZ8Qg
	 G8dxA36CZ5ZE6cZDNPCE4lqw8J+oU4nn5JHsW9nqzC0c7SzTGbg4fJxzswUMQthIDV
	 kdUKHsEzMf6Mw==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1tEPhW-00000006l3V-3wPb;
	Fri, 22 Nov 2024 10:11:42 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
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
Subject: [PATCH v4 00/15] Prepare GHES driver to support error injection
Date: Fri, 22 Nov 2024 10:11:17 +0100
Message-ID: <cover.1732266152.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.47.0
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

---

v4:
- merged a patch renaming the function which calculate offsets to:
  get_hw_error_offsets(), to avoid the need of such change at the next
  patch series;
- removed a functional change at the logic which makes
  the GHES record generation more generic;
- a couple of trivial changes on patch descriptions and line break cleanups.

v3:
- improved some patch descriptions;
- some patches got reordered to better reflect the changes;
- patch v2 08/15: acpi/ghes: Prepare to support multiple sources on ghes
  was split on two patches. The first one is in this cleanup series:
      acpi/ghes: Change ghes fill logic to work with only one source
  contains just the simplification logic. The actual preparation will
  be moved to this series:
     https://lore.kernel.org/qemu-devel/cover.1727782588.git.mchehab+huawei@kernel.org/

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
  acpi/ghes: make the GHES record generation more generic
  acpi/ghes: better name GHES memory error function
  acpi/ghes: don't crash QEMU if ghes GED is not found
  acpi/ghes: rename etc/hardware_error file macros
  acpi/ghes: better name the offset of the hardware error firmware
  acpi/ghes: move offset calculus to a separate function
  acpi/ghes: Change ghes fill logic to work with only one source
  docs: acpi_hest_ghes: fix documentation for CPER size

 docs/specs/acpi_hest_ghes.rst  |   6 +-
 hw/acpi/generic_event_device.c |   4 +-
 hw/acpi/ghes-stub.c            |   2 +-
 hw/acpi/ghes.c                 | 266 +++++++++++++++++++--------------
 hw/arm/virt-acpi-build.c       |   5 +-
 include/hw/acpi/ghes.h         |  16 +-
 target/arm/kvm.c               |   2 +-
 7 files changed, 176 insertions(+), 125 deletions(-)

-- 
2.47.0



