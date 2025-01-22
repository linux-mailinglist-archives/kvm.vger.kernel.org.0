Return-Path: <kvm+bounces-36269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B438A195AB
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF73916307D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6352D215040;
	Wed, 22 Jan 2025 15:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MkVxpfvn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8332A214811;
	Wed, 22 Jan 2025 15:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737560800; cv=none; b=dH0edeNlQP6U9Wlp85tJo6rMkZKUmA62WjF1zTkbMAY7NP8oDTVhtPWd6Ih8hwxkXDWcBWES4iXwV1NXqUk3T5+7fyxB9thle3Aug6Q0aESEh4BYXASD95VY3lOu6Enm57sFdAX4xBmUKjZdvhBYMsBdhk6fOUIYpEwDy/tzgs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737560800; c=relaxed/simple;
	bh=xgqHqajVAv5YFaGSD+Bsr3dzmM+voIVzZZYOg6BWkh8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ht3hNXZ5WXIRb5/7RyiD87KrF4xRtaYts2Bs9dQ4pn6Ed4acQ7VtmMu8yIHQNz9tS1RFm0VOGNKX3u7vVxfJ4KAXR0RUei+KQWaw8hDjag1sJ80m5tfsu6oumugqD7ge+OTg1chRhaQDC5bBcz3XJ+JOaw36qK8cZBFyyHZTciA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MkVxpfvn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D3AC4AF0E;
	Wed, 22 Jan 2025 15:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737560800;
	bh=xgqHqajVAv5YFaGSD+Bsr3dzmM+voIVzZZYOg6BWkh8=;
	h=From:To:Cc:Subject:Date:From;
	b=MkVxpfvnuuhiRQvdrXBo4jemukHoGHGwldya+r+XdW7tpd/SNn7fZ4e3o0C40J9+L
	 gzmXoPPDN1VQHZUTLqBWnrUy16FCheDfGNjdFVLxf7X9uOErKnE/iDTIomEMq3n+oW
	 OuCIjhUPTTCgqgu/reZcZoOv7uSa9SGil+Fhbj8JOKCjIktJiTa3aCLRe1dvkAx7dl
	 o3R0RYfi76XyyTEXAi5TjwxhqavyP3AL2Hjisee3UL6Rjw2WYmpox3ZwL6q4j+zWbw
	 AR2ytzlMfuVdNnfMRYzq2UnNmDqjAnj6atXKO1hrg41keqC8DTLz+RLYZAAcQF7U43
	 hOktCBd7kn8qw==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1tacw9-00000008ogE-3Aj4;
	Wed, 22 Jan 2025 16:46:37 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Eric Blake <eblake@redhat.com>,
	John Snow <jsnow@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] Change ghes to use HEST-based offsets and add support for error inject
Date: Wed, 22 Jan 2025 16:46:17 +0100
Message-ID: <cover.1737560101.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Now that the ghes preparation patches were merged, let's add support
for error injection.

I'm opting to fold two patch series into one here:

1. https://lore.kernel.org/qemu-devel/20250113130854.848688-1-mchehab+huawei@kernel.org/

It is the first 5 patches containing changes to the math used to calculate offsets at HEST
table and hardware_error firmware file, together with its migration code. Migration tested
with both latest QEMU released kernel and upstream, on both directions.

There were no changes on this series since last submission, except for a conflict
resolution at the migration table, due to upstream changes.

For more details, se the post of my previous submission.

2. It follows 6 patches from:
	https://lore.kernel.org/qemu-devel/cover.1726293808.git.mchehab+huawei@kernel.org/
    containing the error injection code and script.

   They add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
   to inject ARM Processor Error records.

PS.: If I'm counting well, this is the 18th version of this series rebase.

Mauro Carvalho Chehab (11):
  acpi/ghes: Prepare to support multiple sources on ghes
  acpi/ghes: add a firmware file with HEST address
  acpi/ghes: Use HEST table offsets when preparing GHES records
  acpi/generic_event_device: Update GHES migration to cover hest addr
  acpi/generic_event_device: add logic to detect if HEST addr is
    available
  acpi/ghes: add a notifier to notify when error data is ready
  acpi/ghes: Cleanup the code which gets ghes ged state
  acpi/generic_event_device: add an APEI error device
  arm/virt: Wire up a GED error device for ACPI / GHES
  qapi/acpi-hest: add an interface to do generic CPER error injection
  scripts/ghes_inject: add a script to generate GHES error inject

 MAINTAINERS                            |  10 +
 hw/acpi/Kconfig                        |   5 +
 hw/acpi/aml-build.c                    |  10 +
 hw/acpi/generic_event_device.c         |  38 ++
 hw/acpi/ghes-stub.c                    |   4 +-
 hw/acpi/ghes.c                         | 184 +++++--
 hw/acpi/ghes_cper.c                    |  32 ++
 hw/acpi/ghes_cper_stub.c               |  19 +
 hw/acpi/meson.build                    |   2 +
 hw/arm/virt-acpi-build.c               |  35 +-
 hw/arm/virt.c                          |  19 +-
 hw/core/machine.c                      |   2 +
 include/hw/acpi/acpi_dev_interface.h   |   1 +
 include/hw/acpi/aml-build.h            |   2 +
 include/hw/acpi/generic_event_device.h |   1 +
 include/hw/acpi/ghes.h                 |  36 +-
 include/hw/arm/virt.h                  |   2 +
 qapi/acpi-hest.json                    |  35 ++
 qapi/meson.build                       |   1 +
 qapi/qapi-schema.json                  |   1 +
 scripts/arm_processor_error.py         | 377 +++++++++++++
 scripts/ghes_inject.py                 |  51 ++
 scripts/qmp_helper.py                  | 702 +++++++++++++++++++++++++
 target/arm/kvm.c                       |   2 +-
 24 files changed, 1517 insertions(+), 54 deletions(-)
 create mode 100644 hw/acpi/ghes_cper.c
 create mode 100644 hw/acpi/ghes_cper_stub.c
 create mode 100644 qapi/acpi-hest.json
 create mode 100644 scripts/arm_processor_error.py
 create mode 100755 scripts/ghes_inject.py
 create mode 100644 scripts/qmp_helper.py

-- 
2.48.1



