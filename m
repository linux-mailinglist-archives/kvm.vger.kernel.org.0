Return-Path: <kvm+bounces-36480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48983A1B642
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 196121888D88
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 12:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691F38BE7;
	Fri, 24 Jan 2025 12:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iUirqGiQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C577F20ED
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 12:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737722845; cv=none; b=Rs+CLSQoAbBnf1KYIPEyH1mDMCf6JfC7cCBCiozJ1WZvcYEaDNE/wcAsRlVnq6VJyDUtRWQXv284/um2rwO3fUmTyf8xSVQpnA6rMiMkMoZUIhDkYpgSl+tChMQWA50t+1SDmbBs3umnqzbfCb54U4CzF0WsxynzhqC6u0qDcb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737722845; c=relaxed/simple;
	bh=DsS9Qhk1JgJvFvJVluXZgQGiSzbB01yBWsUHv+o53ts=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EnRDP6wL1WrotzGROR0sl/JuIvJqX5pztcu3OsZGGXGlGJhJG+xvjfgzf8hKAUNb3SjKDyfKCmEOEMRzSzz227zteehG9zBOTNIuOuDjGT/VkNMK/d86+p960e5zzW8khuwtWCsYfZBKm++F01QSHcRREOGbba/wJ5CVI4vDzxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iUirqGiQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737722842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sUFa3BHRM1lCZt1AxF1frfdVKD8rPIbxarCScvHGYqE=;
	b=iUirqGiQ4ffZWIms3xBWDCcG3xV9lwf8Z+X+0p0WKWwbtdzrSQZzp3mdcV0u1wi9n7jEaz
	pwSrqJiKuKyZpaBs2K481fCFQNmGhABYoUm+kvrMCLja4ZeAFjsNLEIJE1THcVbiENAzsY
	/cz4+xB+xQvO2/DjByRtA0b7FhJ1KfQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-p7ia0PVaNDSYmnpuyxlfhg-1; Fri, 24 Jan 2025 07:47:21 -0500
X-MC-Unique: p7ia0PVaNDSYmnpuyxlfhg-1
X-Mimecast-MFC-AGG-ID: p7ia0PVaNDSYmnpuyxlfhg
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38a684a0971so1026022f8f.2
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 04:47:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737722840; x=1738327640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sUFa3BHRM1lCZt1AxF1frfdVKD8rPIbxarCScvHGYqE=;
        b=alBDVK8o1K0hAio14LI1ObpdNA9unfTqM2AM1HUAGG9s257HeWAoKvyuzFhx91ZkhE
         m7dDmNDfCiGL/7Ne2HO+LHRi4XUhVq+0CN1ph1ieLI7LE3hMYRsGoMjv2qdjrPoC0bX/
         yP9LpxXZZ/jSalZBI0dDwdw2RTyjbRurjKwb95YrQCZ1CbBSnqT9NUtW/upSHbkC2OaG
         oUxz3PegXT+8Dhyk4mw1AojrN+LY4N3MNezJxOGE9rK3kX5fQHQ3T0CRNkI+rqkYnpRB
         fH3J3KNRh9udXgIPSSv7/dz56uwMWJ1XSaUMFZrjHCzUVrsbKWK9BWEfx7m9fIyo2Wci
         fVnw==
X-Forwarded-Encrypted: i=1; AJvYcCUBPTUMx2I3rJiQJYbNaWLeaHkl43tpYPfMIYqxrSAN9cYe8Z0nGvSAPXczJCy2D3bKdz8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzWuhUzusFKGhdP2NJbur1ubZsulfTlJZydNjDUyMNs87g5K5y
	ElKnVUbcD1Xq+yF6FxWL0tWWdM6q0Os5c7Y4/RPlxa0OhzgwqQxQaI5vDbxIeuBbXQmfnXcetZp
	IgTqRyzH4UO4Pwy/DgVAwkYq5KUzfNf3SYNonfkWUa/1cTSaXxw==
X-Gm-Gg: ASbGncsnnretYlxLz/kWGPLJAekawEsumO6nQdbfhLpO8K2RMUDx40qVALda6/aA2MI
	dis1A1IVXXluNMwVmSL4SpJ+MIrGqhO+WVztxo77Xi40I2dkXG+ahR8rfCa5vtrg0eF4AaoG6Yx
	IB4TmMSULIUN8MocNUwTE6nxTSYKIW2bTc+cSUECXK5Qg6IbvGiETCMmST/566QWoNJTwUqSvsv
	T1AvUzGf6q7sNiwweJjihdThnjoBZ4/rINFAV3iE0GD4+VxZU88GW9dY69Sn5UZqOQPPGzc1CKB
	Y+ECuCgT/KfEA2igDFeEbets1pvKzuswb/wcvmyFOQ==
X-Received: by 2002:a5d:64c9:0:b0:385:f220:f788 with SMTP id ffacd0b85a97d-38bf57bbfa5mr29250403f8f.48.1737722840124;
        Fri, 24 Jan 2025 04:47:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIa/qJYb53I8CRY29wjjcU5tWAwqCN40ac1gjQdm+m09Yx/dchLdoDyW0UVw2aF0l1aHWnfw==
X-Received: by 2002:a5d:64c9:0:b0:385:f220:f788 with SMTP id ffacd0b85a97d-38bf57bbfa5mr29250366f8f.48.1737722839737;
        Fri, 24 Jan 2025 04:47:19 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1c402esm2610633f8f.97.2025.01.24.04.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 04:47:19 -0800 (PST)
Date: Fri, 24 Jan 2025 13:47:18 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org, Philippe =?UTF-8?B?TWF0aGll?=
 =?UTF-8?B?dS1EYXVkw6k=?= <philmd@linaro.org>, Ani Sinha
 <anisinha@redhat.com>, Cleber Rosa <crosa@redhat.com>, Dongjiu Geng
 <gengdongjiu1@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, Eric Blake
 <eblake@redhat.com>, John Snow <jsnow@redhat.com>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Markus Armbruster <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Shannon Zhao
 <shannon.zhaosl@gmail.com>, Yanan Wang <wangyanan55@huawei.com>, Zhao Liu
 <zhao1.liu@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250124134718.3e228b0b@imammedo.users.ipa.redhat.com>
In-Reply-To: <cover.1737560101.git.mchehab+huawei@kernel.org>
References: <cover.1737560101.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 Jan 2025 16:46:17 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Now that the ghes preparation patches were merged, let's add support
> for error injection.
> 
> I'm opting to fold two patch series into one here:
> 
> 1. https://lore.kernel.org/qemu-devel/20250113130854.848688-1-mchehab+huawei@kernel.org/
> 
> It is the first 5 patches containing changes to the math used to calculate offsets at HEST
> table and hardware_error firmware file, together with its migration code. Migration tested
> with both latest QEMU released kernel and upstream, on both directions.
> 
> There were no changes on this series since last submission, except for a conflict
> resolution at the migration table, due to upstream changes.
> 
> For more details, se the post of my previous submission.
> 
> 2. It follows 6 patches from:
> 	https://lore.kernel.org/qemu-devel/cover.1726293808.git.mchehab+huawei@kernel.org/
>     containing the error injection code and script.
> 
>    They add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
>    to inject ARM Processor Error records.
> 
> PS.: If I'm counting well, this is the 18th version of this series rebase.

the series is more or less in good shape,
it requires a few fixups here and there, so I'd expect to to be ready on
the next respin.

I'm done with this round of review.

PS:
the moment you'd start changing ACPI tables you need, 1st whitelist
affected tables and then update expected blobs with new content.
see comment at the beginning of tests/qtest/bios-tables-test.c

if you haven't done above 'make check-qtest' would fail,
and if it didn't that likely means a missing test case
(in that case please add one) 

> 
> Mauro Carvalho Chehab (11):
>   acpi/ghes: Prepare to support multiple sources on ghes
>   acpi/ghes: add a firmware file with HEST address
>   acpi/ghes: Use HEST table offsets when preparing GHES records
>   acpi/generic_event_device: Update GHES migration to cover hest addr
>   acpi/generic_event_device: add logic to detect if HEST addr is
>     available
>   acpi/ghes: add a notifier to notify when error data is ready
>   acpi/ghes: Cleanup the code which gets ghes ged state
>   acpi/generic_event_device: add an APEI error device
>   arm/virt: Wire up a GED error device for ACPI / GHES
>   qapi/acpi-hest: add an interface to do generic CPER error injection
>   scripts/ghes_inject: add a script to generate GHES error inject
> 
>  MAINTAINERS                            |  10 +
>  hw/acpi/Kconfig                        |   5 +
>  hw/acpi/aml-build.c                    |  10 +
>  hw/acpi/generic_event_device.c         |  38 ++
>  hw/acpi/ghes-stub.c                    |   4 +-
>  hw/acpi/ghes.c                         | 184 +++++--
>  hw/acpi/ghes_cper.c                    |  32 ++
>  hw/acpi/ghes_cper_stub.c               |  19 +
>  hw/acpi/meson.build                    |   2 +
>  hw/arm/virt-acpi-build.c               |  35 +-
>  hw/arm/virt.c                          |  19 +-
>  hw/core/machine.c                      |   2 +
>  include/hw/acpi/acpi_dev_interface.h   |   1 +
>  include/hw/acpi/aml-build.h            |   2 +
>  include/hw/acpi/generic_event_device.h |   1 +
>  include/hw/acpi/ghes.h                 |  36 +-
>  include/hw/arm/virt.h                  |   2 +
>  qapi/acpi-hest.json                    |  35 ++
>  qapi/meson.build                       |   1 +
>  qapi/qapi-schema.json                  |   1 +
>  scripts/arm_processor_error.py         | 377 +++++++++++++
>  scripts/ghes_inject.py                 |  51 ++
>  scripts/qmp_helper.py                  | 702 +++++++++++++++++++++++++
>  target/arm/kvm.c                       |   2 +-
>  24 files changed, 1517 insertions(+), 54 deletions(-)
>  create mode 100644 hw/acpi/ghes_cper.c
>  create mode 100644 hw/acpi/ghes_cper_stub.c
>  create mode 100644 qapi/acpi-hest.json
>  create mode 100644 scripts/arm_processor_error.py
>  create mode 100755 scripts/ghes_inject.py
>  create mode 100644 scripts/qmp_helper.py
> 


