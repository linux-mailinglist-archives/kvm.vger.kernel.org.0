Return-Path: <kvm+bounces-46409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D03AB6103
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 04:58:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17C368660CF
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 02:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C0A1E5B7D;
	Wed, 14 May 2025 02:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I3HTe8Gh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946A11E5218
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 02:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747191513; cv=none; b=s4H3VC7KNr+k2ywzFECbb1Xn4/hprYqyYYHMF2ZdRFO1vFunImglP0Brg3O8ME1OuWxIUYxbyPT98pwI2C4uFkZwaR4Rn4xND9sCqbqPUFQeAnk6NFTbV/kDhcoiM53c/8o01Ilwt+9sZmi7QeAM3rNxsW1q2OvJ2/nXFRhA96s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747191513; c=relaxed/simple;
	bh=k6ghV4tWmPA/vjzHfQm/IiYzz5sjqXUUrYZgWa3mQvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g9KnI7M0gYbTnOZz/ExZLBKOBh3/8lgW0ffGYwK/Yl8KFAxx934cMtTbbIZMofWFKHsY23aXluJs2QCHymRM0V83q1nCrbD9/NpvsDaLcQSW8UlRp+uLP1+KIfnD1h07TEwVieYdfJvrlpiJvaxii4xyda3I9u5ZbYUFBuxcG2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I3HTe8Gh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747191508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qki9LdQjtAuB9rdSNOpOrtVN3/cyzGlkpiRxnFd5QxQ=;
	b=I3HTe8Gh9wALL+5ZdIyvFEbCHu4pGFG2eVQpPuwBtQrxW6b+BvpEh3d1cFtdlhWJHi3m9P
	5Gdps8nYNrFEvPPXfpCyxOALeP2goJBg7DJvCQskmi1ee0AMDXbTffsm23edaMXKQgZhib
	eWmUMFPwcPL3VRMQfCTn0cEfmBuY3XE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-jtnMTDy0NjyGTg0lfdO1Vg-1; Tue, 13 May 2025 22:58:26 -0400
X-MC-Unique: jtnMTDy0NjyGTg0lfdO1Vg-1
X-Mimecast-MFC-AGG-ID: jtnMTDy0NjyGTg0lfdO1Vg_1747191506
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-30ab450d918so9670022a91.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 19:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747191506; x=1747796306;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qki9LdQjtAuB9rdSNOpOrtVN3/cyzGlkpiRxnFd5QxQ=;
        b=l0fPuP2OZgK+/SWgIK2QEgYRgpFOmhz2z3fOdmO8tbEPyxcl7de93wNFMOOUt6Ltol
         p5JirN8JYI56lFeaw8F0qycqRL6aXw9G90uEMlRIZVwItdgxbNo/HM3/93ltLBSLRPKR
         yb3eVSQSE9N5s0YYlaFehnmZUDPALrkwe1LZ7dQTBmJC+RJmcI3SfbDiaG4P3eZvA6bE
         8t9c736+sbTHVDOdVFcIGriUCklXsrZdCLSG72ZazBzUQ+SY49/qc/0HRL2wPKcS7ygQ
         uZ6tRRViNXv3+rt2qSO5tQwU3sna5gPsBEWbEksVehhlfwp1z+xhr+ndP1LQF3LQACFf
         kwQg==
X-Gm-Message-State: AOJu0YxCfj3ef8CQNZ2xRRECZmyFL8/8c2uAsWXjuYNwFihYeB1scatA
	1yX5EW9aCVdx1K3BS11ngbA5Du2zCV/spDgNgheWP2+N4+y398mKm2HD6rtgDUzP62TgCVk46GG
	bjEpGY7XZKqVx8KS4znvDDqvAgG11j5/xH0LqjWDW3nvJcDE8LA==
X-Gm-Gg: ASbGncviuNYvQoYNeAryZUf4qWVS21ep/4oY9VHG7sJ6a83POZYrp24LpvGAioBPQ4f
	decCvRYeEFqYb80lXlFUCidEdyeNMIwRRKbVagzSeyc6ew5WCR/5DtuZr2uvihj0eI4osZtuS7I
	Ccu2Gpp78StC9CmNmr3PX0aiwSUQOYnP4waxCiq8y1VWhUfVI5Tx8+4WMmK5N2vs9AkPOJYr9Lw
	FycnPG1SsQkwcNAA2k9oYAa2D19rzOYpPOq1GdB6SKIgakOe+HHl+PFWcyobvuklXRGMIMQ78GB
	4rcpZpafn62ImTX/
X-Received: by 2002:a17:90b:1b09:b0:2ff:5c4e:5acd with SMTP id 98e67ed59e1d1-30e2e630192mr2691991a91.35.1747191505589;
        Tue, 13 May 2025 19:58:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IES5FwFqM+jrNlEU4SGfTBZTe1UXiaXheUXNCYmDBTW+m5hzT3MB31mVdHsV719R+ZY9V1/wA==
X-Received: by 2002:a17:90b:1b09:b0:2ff:5c4e:5acd with SMTP id 98e67ed59e1d1-30e2e630192mr2691936a91.35.1747191504942;
        Tue, 13 May 2025 19:58:24 -0700 (PDT)
Received: from [10.72.116.125] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e334fb829sm381166a91.45.2025.05.13.19.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 19:58:24 -0700 (PDT)
Message-ID: <46b07625-7b5d-4531-b1d6-32283520892f@redhat.com>
Date: Wed, 14 May 2025 10:57:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 01/16] scripts: unittests.cfg: Rename
 'extra_params' to 'qemu_params'
To: Alexandru Elisei <alexandru.elisei@arm.com>, andrew.jones@linux.dev,
 eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
 david@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com,
 maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-2-alexandru.elisei@arm.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-2-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> The arm and arm64 architectures can also be run with kvmtool, and work is
> under way to have it supported by the run_tests.sh test runner. Not
> suprisingly, kvmtool's syntax for running a virtual machine is different to
> qemu's.
> 
> Add a new unittest parameter, 'qemu_params', with the goal to add a similar
> parameter for kvmtool, when that's supported.
> 
> 'extra_params' has been kept in the scripts as an alias for 'qemu_params'
> to preserve compatibility with custom test definition, but it is expected
> that going forward new tests will use 'qemu_params'.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   arm/unittests.cfg     |  76 +++++++++++------------
>   docs/unittests.txt    |  15 +++--
>   powerpc/unittests.cfg |  18 +++---
>   riscv/unittests.cfg   |   2 +-
>   s390x/unittests.cfg   |  50 +++++++--------
>   scripts/common.bash   |   8 +--
>   scripts/runtime.bash  |   6 +-
>   x86/unittests.cfg     | 140 +++++++++++++++++++++---------------------
>   8 files changed, 160 insertions(+), 155 deletions(-)
> 
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index fe1011454f88..6c6f76b2fb52 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -15,26 +15,26 @@
>   [selftest-setup]
>   file = selftest.flat
>   smp = 2
> -extra_params = -m 256 -append 'setup smp=2 mem=256'
> +qemu_params = -m 256 -append 'setup smp=2 mem=256'
>   groups = selftest
>   
>   # Test vector setup and exception handling (kernel mode).
>   [selftest-vectors-kernel]
>   file = selftest.flat
> -extra_params = -append 'vectors-kernel'
> +qemu_params = -append 'vectors-kernel'
>   groups = selftest
>   
>   # Test vector setup and exception handling (user mode).
>   [selftest-vectors-user]
>   file = selftest.flat
> -extra_params = -append 'vectors-user'
> +qemu_params = -append 'vectors-user'
>   groups = selftest
>   
>   # Test SMP support
>   [selftest-smp]
>   file = selftest.flat
>   smp = $MAX_SMP
> -extra_params = -append 'smp'
> +qemu_params = -append 'smp'
>   groups = selftest
>   
>   # Test PCI emulation
> @@ -46,79 +46,79 @@ groups = pci
>   [pmu-cycle-counter]
>   file = pmu.flat
>   groups = pmu
> -extra_params = -append 'cycle-counter 0'
> +qemu_params = -append 'cycle-counter 0'
>   
>   [pmu-event-introspection]
>   file = pmu.flat
>   groups = pmu
>   arch = arm64
> -extra_params = -append 'pmu-event-introspection'
> +qemu_params = -append 'pmu-event-introspection'
>   
>   [pmu-event-counter-config]
>   file = pmu.flat
>   groups = pmu
>   arch = arm64
> -extra_params = -append 'pmu-event-counter-config'
> +qemu_params = -append 'pmu-event-counter-config'
>   
>   [pmu-basic-event-count]
>   file = pmu.flat
>   groups = pmu
>   arch = arm64
> -extra_params = -append 'pmu-basic-event-count'
> +qemu_params = -append 'pmu-basic-event-count'
>   
>   [pmu-mem-access]
>   file = pmu.flat
>   groups = pmu
>   arch = arm64
> -extra_params = -append 'pmu-mem-access'
> +qemu_params = -append 'pmu-mem-access'
>   
>   [pmu-mem-access-reliability]
>   file = pmu.flat
>   groups = pmu
>   arch = arm64
> -extra_params = -append 'pmu-mem-access-reliability'
> +qemu_params = -append 'pmu-mem-access-reliability'
>   
>   [pmu-sw-incr]
>   file = pmu.flat
>   groups = pmu
>   arch = arm64
> -extra_params = -append 'pmu-sw-incr'
> +qemu_params = -append 'pmu-sw-incr'
>   
>   [pmu-chained-counters]
>   file = pmu.flat
>   groups = pmu
>   arch = arm64
> -extra_params = -append 'pmu-chained-counters'
> +qemu_params = -append 'pmu-chained-counters'
>   
>   [pmu-chained-sw-incr]
>   file = pmu.flat
>   groups = pmu
>   arch = arm64
> -extra_params = -append 'pmu-chained-sw-incr'
> +qemu_params = -append 'pmu-chained-sw-incr'
>   
>   [pmu-chain-promotion]
>   file = pmu.flat
>   groups = pmu
>   arch = arm64
> -extra_params = -append 'pmu-chain-promotion'
> +qemu_params = -append 'pmu-chain-promotion'
>   
>   [pmu-overflow-interrupt]
>   file = pmu.flat
>   groups = pmu
>   arch = arm64
> -extra_params = -append 'pmu-overflow-interrupt'
> +qemu_params = -append 'pmu-overflow-interrupt'
>   
>   # Test PMU support (TCG) with -icount IPC=1
>   #[pmu-tcg-icount-1]
>   #file = pmu.flat
> -#extra_params = -icount 0 -append 'cycle-counter 1'
> +#qemu_params = -icount 0 -append 'cycle-counter 1'
>   #groups = pmu
>   #accel = tcg
>   
>   # Test PMU support (TCG) with -icount IPC=256
>   #[pmu-tcg-icount-256]
>   #file = pmu.flat
> -#extra_params = -icount 8 -append 'cycle-counter 256'
> +#qemu_params = -icount 8 -append 'cycle-counter 256'
>   #groups = pmu
>   #accel = tcg
>   
> @@ -126,77 +126,77 @@ extra_params = -append 'pmu-overflow-interrupt'
>   [gicv2-ipi]
>   file = gic.flat
>   smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
> -extra_params = -machine gic-version=2 -append 'ipi'
> +qemu_params = -machine gic-version=2 -append 'ipi'
>   groups = gic
>   
>   [gicv2-mmio]
>   file = gic.flat
>   smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
> -extra_params = -machine gic-version=2 -append 'mmio'
> +qemu_params = -machine gic-version=2 -append 'mmio'
>   groups = gic
>   
>   [gicv2-mmio-up]
>   file = gic.flat
>   smp = 1
> -extra_params = -machine gic-version=2 -append 'mmio'
> +qemu_params = -machine gic-version=2 -append 'mmio'
>   groups = gic
>   
>   [gicv2-mmio-3p]
>   file = gic.flat
>   smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
> -extra_params = -machine gic-version=2 -append 'mmio'
> +qemu_params = -machine gic-version=2 -append 'mmio'
>   groups = gic
>   
>   [gicv3-ipi]
>   file = gic.flat
>   smp = $MAX_SMP
> -extra_params = -machine gic-version=3 -append 'ipi'
> +qemu_params = -machine gic-version=3 -append 'ipi'
>   groups = gic
>   
>   [gicv2-active]
>   file = gic.flat
>   smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
> -extra_params = -machine gic-version=2 -append 'active'
> +qemu_params = -machine gic-version=2 -append 'active'
>   groups = gic
>   
>   [gicv3-active]
>   file = gic.flat
>   smp = $MAX_SMP
> -extra_params = -machine gic-version=3 -append 'active'
> +qemu_params = -machine gic-version=3 -append 'active'
>   groups = gic
>   
>   [its-introspection]
>   file = gic.flat
>   smp = $MAX_SMP
> -extra_params = -machine gic-version=3 -append 'its-introspection'
> +qemu_params = -machine gic-version=3 -append 'its-introspection'
>   groups = its
>   arch = arm64
>   
>   [its-trigger]
>   file = gic.flat
>   smp = $MAX_SMP
> -extra_params = -machine gic-version=3 -append 'its-trigger'
> +qemu_params = -machine gic-version=3 -append 'its-trigger'
>   groups = its
>   arch = arm64
>   
>   [its-migration]
>   file = gic.flat
>   smp = $MAX_SMP
> -extra_params = -machine gic-version=3 -append 'its-migration'
> +qemu_params = -machine gic-version=3 -append 'its-migration'
>   groups = its migration
>   arch = arm64
>   
>   [its-pending-migration]
>   file = gic.flat
>   smp = $MAX_SMP
> -extra_params = -machine gic-version=3 -append 'its-pending-migration'
> +qemu_params = -machine gic-version=3 -append 'its-pending-migration'
>   groups = its migration
>   arch = arm64
>   
>   [its-migrate-unmapped-collection]
>   file = gic.flat
>   smp = $MAX_SMP
> -extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
> +qemu_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
>   groups = its migration
>   arch = arm64
>   
> @@ -231,37 +231,37 @@ groups = cache
>   [debug-bp]
>   file = debug.flat
>   arch = arm64
> -extra_params = -append 'bp'
> +qemu_params = -append 'bp'
>   groups = debug
>   
>   [debug-bp-migration]
>   file = debug.flat
>   arch = arm64
> -extra_params = -append 'bp-migration'
> +qemu_params = -append 'bp-migration'
>   groups = debug migration
>   
>   [debug-wp]
>   file = debug.flat
>   arch = arm64
> -extra_params = -append 'wp'
> +qemu_params = -append 'wp'
>   groups = debug
>   
>   [debug-wp-migration]
>   file = debug.flat
>   arch = arm64
> -extra_params = -append 'wp-migration'
> +qemu_params = -append 'wp-migration'
>   groups = debug migration
>   
>   [debug-sstep]
>   file = debug.flat
>   arch = arm64
> -extra_params = -append 'ss'
> +qemu_params = -append 'ss'
>   groups = debug
>   
>   [debug-sstep-migration]
>   file = debug.flat
>   arch = arm64
> -extra_params = -append 'ss-migration'
> +qemu_params = -append 'ss-migration'
>   groups = debug migration
>   
>   # FPU/SIMD test
> @@ -276,17 +276,17 @@ arch = arm64
>   [mte-sync]
>   file = mte.flat
>   groups = mte
> -extra_params = -machine mte=on -append 'sync'
> +qemu_params = -machine mte=on -append 'sync'
>   arch = arm64
>   
>   [mte-async]
>   file = mte.flat
>   groups = mte
> -extra_params = -machine mte=on -append 'async'
> +qemu_params = -machine mte=on -append 'async'
>   arch = arm64
>   
>   [mte-asymm]
>   file = mte.flat
>   groups = mte
> -extra_params = -machine mte=on -append 'asymm'
> +qemu_params = -machine mte=on -append 'asymm'
>   arch = arm64
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> index c4269f6230c8..3d19fd70953f 100644
> --- a/docs/unittests.txt
> +++ b/docs/unittests.txt
> @@ -24,9 +24,9 @@ param = value format.
>   
>   Available parameters
>   ====================
> -Note! Some parameters like smp and extra_params modify how a test is run,
> -while others like arch and accel restrict the configurations in which the
> -test is run.
> +Note! Some parameters like smp and qemu_params/extra_params modify how a
> +test is run, while others like arch and accel restrict the configurations
> +in which the test is run.
>   
>   file
>   ----
> @@ -56,13 +56,18 @@ smp = <number>
>   Optional, the number of processors created in the machine to run the test.
>   Defaults to 1. $MAX_SMP can be used to specify the maximum supported.
>   
> -extra_params
> +qemu_params
>   ------------
>   These are extra parameters supplied to the QEMU process. -append '...' can
>   be used to pass arguments into the test case argv. Multiple parameters can
>   be added, for example:
>   
> -extra_params = -m 256 -append 'smp=2'
> +qemu_params = -m 256 -append 'smp=2'
> +
> +extra_params
> +------------
> +Alias for 'qemu_params', supported for compatibility purposes. Use
> +'qemu_params' for new tests.
>   
>   groups
>   ------
> diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
> index 149f963f3d53..5097911e4bf3 100644
> --- a/powerpc/unittests.cfg
> +++ b/powerpc/unittests.cfg
> @@ -15,7 +15,7 @@
>   [selftest-setup]
>   file = selftest.elf
>   smp = 2
> -extra_params = -m 1g -append 'setup smp=2 mem=1024'
> +qemu_params = -m 1g -append 'setup smp=2 mem=1024'
>   groups = selftest
>   
>   [selftest-migration]
> @@ -27,7 +27,7 @@ groups = selftest migration
>   file = selftest-migration.elf
>   machine = pseries
>   groups = selftest migration
> -extra_params = -append "skip"
> +qemu_params = -append "skip"
>   
>   [migration-memory]
>   file = memory-verify.elf
> @@ -46,20 +46,20 @@ machine = pseries
>   file = rtas.elf
>   machine = pseries
>   timeout = 5
> -extra_params = -append "get-time-of-day date=$(date +%s)"
> +qemu_params = -append "get-time-of-day date=$(date +%s)"
>   groups = rtas
>   
>   [rtas-get-time-of-day-base]
>   file = rtas.elf
>   machine = pseries
>   timeout = 5
> -extra_params = -rtc base="2006-06-17" -append "get-time-of-day date=$(date --date="2006-06-17 UTC" +%s)"
> +qemu_params = -rtc base="2006-06-17" -append "get-time-of-day date=$(date --date="2006-06-17 UTC" +%s)"
>   groups = rtas
>   
>   [rtas-set-time-of-day]
>   file = rtas.elf
>   machine = pseries
> -extra_params = -append "set-time-of-day"
> +qemu_params = -append "set-time-of-day"
>   timeout = 5
>   groups = rtas
>   
> @@ -94,7 +94,7 @@ smp = 2
>   [atomics-migration]
>   file = atomics.elf
>   machine = pseries
> -extra_params = -append "migration -m"
> +qemu_params = -append "migration -m"
>   groups = migration
>   
>   [timebase]
> @@ -103,14 +103,14 @@ file = timebase.elf
>   [timebase-icount]
>   file = timebase.elf
>   accel = tcg
> -extra_params = -icount shift=5
> +qemu_params = -icount shift=5
>   
>   [h_cede_tm]
>   file = tm.elf
>   machine = pseries
>   accel = kvm
>   smp = 2,threads=2
> -extra_params = -machine cap-htm=on -append "h_cede_tm"
> +qemu_params = -machine cap-htm=on -append "h_cede_tm"
>   groups = h_cede_tm
>   
>   [sprs]
> @@ -119,7 +119,7 @@ file = sprs.elf
>   [sprs-migration]
>   file = sprs.elf
>   machine = pseries
> -extra_params = -append '-w'
> +qemu_params = -append '-w'
>   groups = migration
>   
>   [sieve]
> diff --git a/riscv/unittests.cfg b/riscv/unittests.cfg
> index 2eb760eca24e..5b31047f75c7 100644
> --- a/riscv/unittests.cfg
> +++ b/riscv/unittests.cfg
> @@ -10,7 +10,7 @@
>   [selftest]
>   file = selftest.flat
>   smp = $MAX_SMP
> -extra_params = -append 'foo bar baz'
> +qemu_params = -append 'foo bar baz'
>   groups = selftest
>   
>   # Set $FIRMWARE_OVERRIDE to /path/to/firmware to select the SBI implementation.
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index a9af6680f2a6..1e129fef3c38 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -10,7 +10,7 @@
>   file = selftest.elf
>   groups = selftest
>   # please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parmfile
> -extra_params = -append 'test 123'
> +qemu_params = -append 'test 123'
>   
>   [selftest-migration]
>   file = selftest-migration.elf
> @@ -22,7 +22,7 @@ accel = kvm
>   [selftest-migration-skip]
>   file = selftest-migration.elf
>   groups = selftest migration
> -extra_params = -append "skip"
> +qemu_params = -append "skip"
>   
>   # This fails due to a QEMU TCG bug so KVM-only until QEMU is fixed upstream
>   [migration-memory]
> @@ -47,7 +47,7 @@ file = sthyi.elf
>   
>   [skey]
>   file = skey.elf
> -extra_params = -device virtio-net-ccw
> +qemu_params = -device virtio-net-ccw
>   
>   [diag10]
>   file = diag10.elf
> @@ -75,11 +75,11 @@ file = cpumodel.elf
>   
>   [diag288]
>   file = diag288.elf
> -extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
> +qemu_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
>   
>   [stsi]
>   file = stsi.elf
> -extra_params=-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-0242ac130003 -smp 1,maxcpus=8
> +qemu_params=-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-0242ac130003 -smp 1,maxcpus=8
>   
>   [smp]
>   file = smp.elf
> @@ -87,15 +87,15 @@ smp = 2
>   
>   [sclp-1g]
>   file = sclp.elf
> -extra_params = -m 1G
> +qemu_params = -m 1G
>   
>   [sclp-3g]
>   file = sclp.elf
> -extra_params = -m 3G
> +qemu_params = -m 3G
>   
>   [css]
>   file = css.elf
> -extra_params = -device virtio-net-ccw
> +qemu_params = -device virtio-net-ccw
>   
>   [skrf]
>   file = skrf.elf
> @@ -126,25 +126,25 @@ file = spec_ex.elf
>   [firq-linear-cpu-ids-kvm]
>   file = firq.elf
>   timeout = 20
> -extra_params = -smp 1,maxcpus=3 -device host-s390x-cpu,core-id=1 -device host-s390x-cpu,core-id=2
> +qemu_params = -smp 1,maxcpus=3 -device host-s390x-cpu,core-id=1 -device host-s390x-cpu,core-id=2
>   accel = kvm
>   
>   [firq-nonlinear-cpu-ids-kvm]
>   file = firq.elf
>   timeout = 20
> -extra_params = -smp 1,maxcpus=3 -device host-s390x-cpu,core-id=2 -device host-s390x-cpu,core-id=1
> +qemu_params = -smp 1,maxcpus=3 -device host-s390x-cpu,core-id=2 -device host-s390x-cpu,core-id=1
>   accel = kvm
>   
>   [firq-linear-cpu-ids-tcg]
>   file = firq.elf
>   timeout = 20
> -extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=1 -device qemu-s390x-cpu,core-id=2
> +qemu_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=1 -device qemu-s390x-cpu,core-id=2
>   accel = tcg
>   
>   [firq-nonlinear-cpu-ids-tcg]
>   file = firq.elf
>   timeout = 20
> -extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1
> +qemu_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1
>   accel = tcg
>   
>   [sck]
> @@ -152,7 +152,7 @@ file = sck.elf
>   
>   [epsw]
>   file = epsw.elf
> -extra_params = -device virtio-net-ccw
> +qemu_params = -device virtio-net-ccw
>   
>   [tprot]
>   file = tprot.elf
> @@ -161,26 +161,26 @@ file = tprot.elf
>   file = adtl-status.elf
>   smp = 2
>   accel = kvm
> -extra_params = -cpu host,gs=on,vx=on
> +qemu_params = -cpu host,gs=on,vx=on
>   
>   [adtl-status-no-vec-no-gs-kvm]
>   file = adtl-status.elf
>   smp = 2
>   accel = kvm
> -extra_params = -cpu host,gs=off,vx=off
> +qemu_params = -cpu host,gs=off,vx=off
>   
>   [adtl-status-tcg]
>   file = adtl-status.elf
>   smp = 2
>   accel = tcg
>   # no guarded-storage support in tcg
> -extra_params = -cpu qemu,vx=on
> +qemu_params = -cpu qemu,vx=on
>   
>   [adtl-status-no-vec-no-gs-tcg]
>   file = adtl-status.elf
>   smp = 2
>   accel = tcg
> -extra_params = -cpu qemu,gs=off,vx=off
> +qemu_params = -cpu qemu,gs=off,vx=off
>   
>   [migration]
>   file = migration.elf
> @@ -214,13 +214,13 @@ smp = 2
>   [migration-skey-sequential]
>   file = migration-skey.elf
>   groups = migration
> -extra_params = -append '--sequential'
> +qemu_params = -append '--sequential'
>   
>   [migration-skey-parallel]
>   file = migration-skey.elf
>   smp = 2
>   groups = migration
> -extra_params = -append '--parallel'
> +qemu_params = -append '--parallel'
>   
>   [execute]
>   file = ex.elf
> @@ -229,34 +229,34 @@ file = ex.elf
>   file = pv-icptcode.elf
>   smp = 3
>   groups = pv-host
> -extra_params = -m 2200
> +qemu_params = -m 2200
>   
>   [pv-ipl]
>   file = pv-ipl.elf
>   groups = pv-host
> -extra_params = -m 2200
> +qemu_params = -m 2200
>   
>   [pv-diags]
>   file = pv-diags.elf
>   groups = pv-host
> -extra_params = -m 2200
> +qemu_params = -m 2200
>   
>   [uv-host]
>   file = uv-host.elf
>   smp = 2
>   groups = pv-host
> -extra_params = -m 2200
> +qemu_params = -m 2200
>   
>   [topology]
>   file = topology.elf
>   
>   [topology-2]
>   file = topology.elf
> -extra_params = -cpu max,ctop=on -smp sockets=31,cores=8,maxcpus=248  -append '-sockets 31 -cores 8'
> +qemu_params = -cpu max,ctop=on -smp sockets=31,cores=8,maxcpus=248  -append '-sockets 31 -cores 8'
>   
>   [topology-3]
>   file = topology.elf
> -extra_params = """-cpu max,ctop=on -smp cpus=1,drawers=2,books=2,sockets=2,cores=16,maxcpus=128 \
> +qemu_params = """-cpu max,ctop=on -smp cpus=1,drawers=2,books=2,sockets=2,cores=16,maxcpus=128 \
>   -append '-drawers 2 -books 2 -sockets 2 -cores 16' \
>   -device max-s390x-cpu,core-id=31,drawer-id=0,book-id=0,socket-id=0,entitlement=medium,dedicated=false \
>   -device max-s390x-cpu,core-id=11,drawer-id=0,book-id=0,socket-id=0,entitlement=high,dedicated=true \
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 3aa557c8c03d..bd7c82f1adda 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -38,8 +38,8 @@ function for_each_unittest()
>   			kernel=$TEST_DIR/${BASH_REMATCH[1]}
>   		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
>   			smp=${BASH_REMATCH[1]}
> -		elif [[ $line =~ ^extra_params\ *=\ *'"""'(.*)$ ]]; then
> -			opts=${BASH_REMATCH[1]}$'\n'
> +		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *'"""'(.*)$ ]]; then
> +			opts=${BASH_REMATCH[2]}$'\n'
>   			while read -r -u $fd; do
>   				#escape backslash newline, but not double backslash
>   				if [[ $opts =~ [^\\]*(\\*)$'\n'$ ]]; then
> @@ -54,8 +54,8 @@ function for_each_unittest()
>   					opts+=$REPLY$'\n'
>   				fi
>   			done
> -		elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
> -			opts=${BASH_REMATCH[1]}
> +		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *(.*)$ ]]; then
> +			opts=${BASH_REMATCH[2]}
>   		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
>   			groups=${BASH_REMATCH[1]}
>   		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index ee229631277d..400e8a082528 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -179,9 +179,9 @@ function run()
>           echo $cmdline
>       fi
>   
> -    # extra_params in the config file may contain backticks that need to be
> -    # expanded, so use eval to start qemu.  Use "> >(foo)" instead of a pipe to
> -    # preserve the exit status.
> +    # qemu_params/extra_params in the config file may contain backticks that
> +    # need to be expanded, so use eval to start qemu.  Use "> >(foo)" instead of
> +    # a pipe to preserve the exit status.
>       summary=$(eval "$cmdline" 2> >(RUNTIME_log_stderr $testname) \
>                                > >(tee >(RUNTIME_log_stdout $testname $kernel) | extract_summary))
>       ret=$?
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 6e69c50b9b0d..a356f486eaec 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -10,20 +10,20 @@
>   [apic-split]
>   file = apic.flat
>   smp = 2
> -extra_params = -cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqchip=split
> +qemu_params = -cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqchip=split
>   arch = x86_64
>   groups = apic
>   
>   [ioapic-split]
>   file = ioapic.flat
> -extra_params = -cpu qemu64 -machine kernel_irqchip=split
> +qemu_params = -cpu qemu64 -machine kernel_irqchip=split
>   arch = x86_64
>   groups = apic
>   
>   [x2apic]
>   file = apic.flat
>   smp = 2
> -extra_params = -cpu qemu64,+x2apic,+tsc-deadline
> +qemu_params = -cpu qemu64,+x2apic,+tsc-deadline
>   arch = x86_64
>   timeout = 30
>   groups = apic
> @@ -33,7 +33,7 @@ groups = apic
>   [xapic]
>   file = apic.flat
>   smp = 2
> -extra_params = -cpu qemu64,-x2apic,+tsc-deadline -machine pit=off
> +qemu_params = -cpu qemu64,-x2apic,+tsc-deadline -machine pit=off
>   arch = x86_64
>   timeout = 60
>   groups = apic
> @@ -41,7 +41,7 @@ groups = apic
>   [ioapic]
>   file = ioapic.flat
>   smp = 4
> -extra_params = -cpu qemu64,+x2apic
> +qemu_params = -cpu qemu64,+x2apic
>   arch = x86_64
>   
>   [cmpxchg8b]
> @@ -58,27 +58,27 @@ smp = 3
>   
>   [vmexit_cpuid]
>   file = vmexit.flat
> -extra_params = -append 'cpuid'
> +qemu_params = -append 'cpuid'
>   groups = vmexit
>   
>   [vmexit_vmcall]
>   file = vmexit.flat
> -extra_params = -append 'vmcall'
> +qemu_params = -append 'vmcall'
>   groups = vmexit
>   
>   [vmexit_mov_from_cr8]
>   file = vmexit.flat
> -extra_params = -append 'mov_from_cr8'
> +qemu_params = -append 'mov_from_cr8'
>   groups = vmexit
>   
>   [vmexit_mov_to_cr8]
>   file = vmexit.flat
> -extra_params = -append 'mov_to_cr8'
> +qemu_params = -append 'mov_to_cr8'
>   groups = vmexit
>   
>   [vmexit_inl_pmtimer]
>   file = vmexit.flat
> -extra_params = -append 'inl_from_pmtimer'
> +qemu_params = -append 'inl_from_pmtimer'
>   groups = vmexit
>   
>   # To allow IPIs to be accelerated by SVM AVIC when the feature is available and
> @@ -87,77 +87,77 @@ groups = vmexit
>   [vmexit_ipi]
>   file = vmexit.flat
>   smp = 2
> -extra_params = -machine pit=off -append 'ipi'
> +qemu_params = -machine pit=off -append 'ipi'
>   groups = vmexit
>   
>   [vmexit_ipi_halt]
>   file = vmexit.flat
>   smp = 2
> -extra_params = -append 'ipi_halt'
> +qemu_params = -append 'ipi_halt'
>   groups = vmexit
>   
>   [vmexit_ple_round_robin]
>   file = vmexit.flat
> -extra_params = -append 'ple_round_robin'
> +qemu_params = -append 'ple_round_robin'
>   groups = vmexit
>   
>   [vmexit_tscdeadline]
>   file = vmexit.flat
>   groups = vmexit
> -extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline
> +qemu_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline
>   
>   [vmexit_tscdeadline_immed]
>   file = vmexit.flat
>   groups = vmexit
> -extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
> +qemu_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
>   
>   [vmexit_cr0_wp]
>   file = vmexit.flat
>   smp = 2
> -extra_params = -append 'toggle_cr0_wp'
> +qemu_params = -append 'toggle_cr0_wp'
>   groups = vmexit
>   
>   [vmexit_cr4_pge]
>   file = vmexit.flat
>   smp = 2
> -extra_params = -append 'toggle_cr4_pge'
> +qemu_params = -append 'toggle_cr4_pge'
>   groups = vmexit
>   
>   [access]
>   file = access_test.flat
>   arch = x86_64
> -extra_params = -cpu max,host-phys-bits
> +qemu_params = -cpu max,host-phys-bits
>   
>   [access_fep]
>   file = access_test.flat
>   arch = x86_64
> -extra_params = -cpu max,host-phys-bits -append force_emulation
> +qemu_params = -cpu max,host-phys-bits -append force_emulation
>   groups = nodefault
>   timeout = 240
>   
>   [access-reduced-maxphyaddr]
>   file = access_test.flat
>   arch = x86_64
> -extra_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off
> +qemu_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off
>   check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
>   
>   [smap]
>   file = smap.flat
> -extra_params = -cpu max
> +qemu_params = -cpu max
>   
>   [pku]
>   file = pku.flat
>   arch = x86_64
> -extra_params = -cpu max
> +qemu_params = -cpu max
>   
>   [pks]
>   file = pks.flat
>   arch = x86_64
> -extra_params = -cpu max
> +qemu_params = -cpu max
>   
>   [asyncpf]
>   file = asyncpf.flat
> -extra_params = -cpu host -m 2048
> +qemu_params = -cpu host -m 2048
>   
>   [emulator]
>   file = emulator.flat
> @@ -177,7 +177,7 @@ arch = x86_64
>   
>   [memory]
>   file = memory.flat
> -extra_params = -cpu max
> +qemu_params = -cpu max
>   arch = x86_64
>   
>   [msr]
> @@ -186,11 +186,11 @@ arch = x86_64
>   # support follows the host kernel.  Running a 32-bit guest on a 64-bit host
>   # will fail due to shortcomings in KVM.
>   file = msr.flat
> -extra_params = -cpu max,vendor=GenuineIntel
> +qemu_params = -cpu max,vendor=GenuineIntel
>   
>   [pmu]
>   file = pmu.flat
> -extra_params = -cpu max
> +qemu_params = -cpu max
>   check = /sys/module/kvm/parameters/enable_pmu=Y /proc/sys/kernel/nmi_watchdog=0
>   accel = kvm
>   groups = pmu
> @@ -198,7 +198,7 @@ groups = pmu
>   [pmu_lbr]
>   arch = x86_64
>   file = pmu_lbr.flat
> -extra_params = -cpu host,migratable=no
> +qemu_params = -cpu host,migratable=no
>   check = /sys/module/kvm/parameters/enable_pmu=Y /proc/sys/kernel/nmi_watchdog=0 /sys/module/kvm/parameters/ignore_msrs=N
>   accel = kvm
>   groups = pmu
> @@ -206,14 +206,14 @@ groups = pmu
>   [pmu_pebs]
>   arch = x86_64
>   file = pmu_pebs.flat
> -extra_params = -cpu host,migratable=no
> +qemu_params = -cpu host,migratable=no
>   check = /sys/module/kvm/parameters/enable_pmu=Y /proc/sys/kernel/nmi_watchdog=0
>   accel = kvm
>   groups = pmu
>   
>   [vmware_backdoors]
>   file = vmware_backdoors.flat
> -extra_params = -machine vmport=on -cpu max
> +qemu_params = -machine vmport=on -cpu max
>   check = /sys/module/kvm/parameters/enable_vmware_backdoor=Y
>   arch = x86_64
>   accel = kvm
> @@ -234,20 +234,20 @@ timeout = 180
>   [syscall]
>   file = syscall.flat
>   arch = x86_64
> -extra_params = -cpu Opteron_G1,vendor=AuthenticAMD
> +qemu_params = -cpu Opteron_G1,vendor=AuthenticAMD
>   
>   [tsc]
>   file = tsc.flat
> -extra_params = -cpu max
> +qemu_params = -cpu max
>   
>   [tsc_adjust]
>   file = tsc_adjust.flat
> -extra_params = -cpu max
> +qemu_params = -cpu max
>   
>   [xsave]
>   file = xsave.flat
>   arch = x86_64
> -extra_params = -cpu max
> +qemu_params = -cpu max
>   
>   [rmap_chain]
>   file = rmap_chain.flat
> @@ -256,20 +256,20 @@ arch = x86_64
>   [svm]
>   file = svm.flat
>   smp = 2
> -extra_params = -cpu max,+svm -m 4g -append "-pause_filter_test"
> +qemu_params = -cpu max,+svm -m 4g -append "-pause_filter_test"
>   arch = x86_64
>   groups = svm
>   
>   [svm_pause_filter]
>   file = svm.flat
> -extra_params = -cpu max,+svm -overcommit cpu-pm=on -m 4g -append pause_filter_test
> +qemu_params = -cpu max,+svm -overcommit cpu-pm=on -m 4g -append pause_filter_test
>   arch = x86_64
>   groups = svm
>   
>   [svm_npt]
>   file = svm_npt.flat
>   smp = 2
> -extra_params = -cpu max,+svm -m 4g
> +qemu_params = -cpu max,+svm -m 4g
>   arch = x86_64
>   
>   [taskswitch]
> @@ -285,68 +285,68 @@ groups = tasks
>   [kvmclock_test]
>   file = kvmclock_test.flat
>   smp = 2
> -extra_params = --append "10000000 `date +%s`"
> +qemu_params = --append "10000000 `date +%s`"
>   
>   [pcid-enabled]
>   file = pcid.flat
> -extra_params = -cpu qemu64,+pcid,+invpcid
> +qemu_params = -cpu qemu64,+pcid,+invpcid
>   arch = x86_64
>   groups = pcid
>   
>   [pcid-disabled]
>   file = pcid.flat
> -extra_params = -cpu qemu64,-pcid,-invpcid
> +qemu_params = -cpu qemu64,-pcid,-invpcid
>   arch = x86_64
>   groups = pcid
>   
>   [pcid-asymmetric]
>   file = pcid.flat
> -extra_params = -cpu qemu64,-pcid,+invpcid
> +qemu_params = -cpu qemu64,-pcid,+invpcid
>   arch = x86_64
>   groups = pcid
>   
>   [rdpru]
>   file = rdpru.flat
> -extra_params = -cpu max
> +qemu_params = -cpu max
>   arch = x86_64
>   
>   [umip]
>   file = umip.flat
> -extra_params = -cpu qemu64,+umip
> +qemu_params = -cpu qemu64,+umip
>   
>   [la57]
>   file = la57.flat
> -extra_params = -cpu max,host-phys-bits
> +qemu_params = -cpu max,host-phys-bits
>   
>   [vmx]
>   file = vmx.flat
> -extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_exception_forced_emulation_test -vmx_pf_no_vpid_test -vmx_pf_invvpid_test -vmx_pf_vpid_test -vmx_basic_vid_test -vmx_eoi_virt_test -vmx_posted_interrupts_test"
> +qemu_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_exception_forced_emulation_test -vmx_pf_no_vpid_test -vmx_pf_invvpid_test -vmx_pf_vpid_test -vmx_basic_vid_test -vmx_eoi_virt_test -vmx_posted_interrupts_test"
>   arch = x86_64
>   groups = vmx
>   
>   [ept]
>   file = vmx.flat
> -extra_params = -cpu max,host-phys-bits,+vmx -m 2560 -append "ept_access*"
> +qemu_params = -cpu max,host-phys-bits,+vmx -m 2560 -append "ept_access*"
>   arch = x86_64
>   groups = vmx
>   
>   [vmx_eoi_bitmap_ioapic_scan]
>   file = vmx.flat
>   smp = 2
> -extra_params = -cpu max,+vmx -m 2048 -append vmx_eoi_bitmap_ioapic_scan_test
> +qemu_params = -cpu max,+vmx -m 2048 -append vmx_eoi_bitmap_ioapic_scan_test
>   arch = x86_64
>   groups = vmx
>   
>   [vmx_hlt_with_rvi_test]
>   file = vmx.flat
> -extra_params = -cpu max,+vmx -append vmx_hlt_with_rvi_test
> +qemu_params = -cpu max,+vmx -append vmx_hlt_with_rvi_test
>   arch = x86_64
>   groups = vmx
>   timeout = 10
>   
>   [vmx_apicv_test]
>   file = vmx.flat
> -extra_params = -cpu max,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test vmx_basic_vid_test vmx_eoi_virt_test"
> +qemu_params = -cpu max,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test vmx_basic_vid_test vmx_eoi_virt_test"
>   arch = x86_64
>   groups = vmx
>   timeout = 30
> @@ -354,7 +354,7 @@ timeout = 30
>   [vmx_posted_intr_test]
>   file = vmx.flat
>   smp = 2
> -extra_params = -cpu max,+vmx -append "vmx_posted_interrupts_test"
> +qemu_params = -cpu max,+vmx -append "vmx_posted_interrupts_test"
>   arch = x86_64
>   groups = vmx
>   timeout = 10
> @@ -362,14 +362,14 @@ timeout = 10
>   [vmx_apic_passthrough_thread]
>   file = vmx.flat
>   smp = 2
> -extra_params = -cpu max,+vmx -m 2048 -append vmx_apic_passthrough_thread_test
> +qemu_params = -cpu max,+vmx -m 2048 -append vmx_apic_passthrough_thread_test
>   arch = x86_64
>   groups = vmx
>   
>   [vmx_init_signal_test]
>   file = vmx.flat
>   smp = 2
> -extra_params = -cpu max,+vmx -m 2048 -append vmx_init_signal_test
> +qemu_params = -cpu max,+vmx -m 2048 -append vmx_init_signal_test
>   arch = x86_64
>   groups = vmx
>   timeout = 10
> @@ -377,62 +377,62 @@ timeout = 10
>   [vmx_sipi_signal_test]
>   file = vmx.flat
>   smp = 2
> -extra_params = -cpu max,+vmx -m 2048 -append vmx_sipi_signal_test
> +qemu_params = -cpu max,+vmx -m 2048 -append vmx_sipi_signal_test
>   arch = x86_64
>   groups = vmx
>   timeout = 10
>   
>   [vmx_apic_passthrough_tpr_threshold_test]
>   file = vmx.flat
> -extra_params = -cpu max,+vmx -m 2048 -append vmx_apic_passthrough_tpr_threshold_test
> +qemu_params = -cpu max,+vmx -m 2048 -append vmx_apic_passthrough_tpr_threshold_test
>   arch = x86_64
>   groups = vmx
>   timeout = 10
>   
>   [vmx_vmcs_shadow_test]
>   file = vmx.flat
> -extra_params = -cpu max,+vmx -append vmx_vmcs_shadow_test
> +qemu_params = -cpu max,+vmx -append vmx_vmcs_shadow_test
>   arch = x86_64
>   groups = vmx
>   timeout = 180
>   
>   [vmx_pf_exception_test]
>   file = vmx.flat
> -extra_params = -cpu max,+vmx -append "vmx_pf_exception_test"
> +qemu_params = -cpu max,+vmx -append "vmx_pf_exception_test"
>   arch = x86_64
>   groups = vmx nested_exception
>   
>   [vmx_pf_exception_test_fep]
>   file = vmx.flat
> -extra_params = -cpu max,+vmx -append "vmx_pf_exception_forced_emulation_test"
> +qemu_params = -cpu max,+vmx -append "vmx_pf_exception_forced_emulation_test"
>   arch = x86_64
>   groups = vmx nested_exception nodefault
>   timeout = 240
>   
>   [vmx_pf_vpid_test]
>   file = vmx.flat
> -extra_params = -cpu max,+vmx -append "vmx_pf_vpid_test"
> +qemu_params = -cpu max,+vmx -append "vmx_pf_vpid_test"
>   arch = x86_64
>   groups = vmx nested_exception nodefault
>   timeout = 240
>   
>   [vmx_pf_invvpid_test]
>   file = vmx.flat
> -extra_params = -cpu max,+vmx -append "vmx_pf_invvpid_test"
> +qemu_params = -cpu max,+vmx -append "vmx_pf_invvpid_test"
>   arch = x86_64
>   groups = vmx nested_exception nodefault
>   timeout = 240
>   
>   [vmx_pf_no_vpid_test]
>   file = vmx.flat
> -extra_params = -cpu max,+vmx -append "vmx_pf_no_vpid_test"
> +qemu_params = -cpu max,+vmx -append "vmx_pf_no_vpid_test"
>   arch = x86_64
>   groups = vmx nested_exception nodefault
>   timeout = 240
>   
>   [vmx_pf_exception_test_reduced_maxphyaddr]
>   file = vmx.flat
> -extra_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off,+vmx -append "vmx_pf_exception_test"
> +qemu_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off,+vmx -append "vmx_pf_exception_test"
>   arch = x86_64
>   groups = vmx nested_exception
>   check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
> @@ -444,31 +444,31 @@ arch = x86_64
>   [hyperv_synic]
>   file = hyperv_synic.flat
>   smp = 2
> -extra_params = -cpu host,hv_passthrough -device hyperv-testdev
> +qemu_params = -cpu host,hv_passthrough -device hyperv-testdev
>   groups = hyperv
>   
>   [hyperv_connections]
>   file = hyperv_connections.flat
>   smp = 2
> -extra_params = -cpu host,hv_passthrough -device hyperv-testdev
> +qemu_params = -cpu host,hv_passthrough -device hyperv-testdev
>   groups = hyperv
>   
>   [hyperv_stimer]
>   file = hyperv_stimer.flat
>   smp = 2
> -extra_params = -cpu host,hv_passthrough
> +qemu_params = -cpu host,hv_passthrough
>   groups = hyperv
>   
>   [hyperv_stimer_direct]
>   file = hyperv_stimer.flat
>   smp = 2
> -extra_params = -cpu host,hv_passthrough -append direct
> +qemu_params = -cpu host,hv_passthrough -append direct
>   groups = hyperv
>   
>   [hyperv_clock]
>   file = hyperv_clock.flat
>   smp = 2
> -extra_params = -cpu host,hv_passthrough
> +qemu_params = -cpu host,hv_passthrough
>   arch = x86_64
>   groups = hyperv
>   check = /sys/devices/system/clocksource/clocksource0/current_clocksource=tsc
> @@ -478,20 +478,20 @@ file = intel-iommu.flat
>   arch = x86_64
>   timeout = 30
>   smp = 4
> -extra_params = -M q35,kernel-irqchip=split -device intel-iommu,intremap=on,eim=off -device edu
> +qemu_params = -M q35,kernel-irqchip=split -device intel-iommu,intremap=on,eim=off -device edu
>   
>   [tsx-ctrl]
>   file = tsx-ctrl.flat
> -extra_params = -cpu max
> +qemu_params = -cpu max
>   groups = tsx-ctrl
>   
>   [intel_cet]
>   file = cet.flat
>   arch = x86_64
>   smp = 2
> -extra_params = -enable-kvm -m 2048 -cpu host
> +qemu_params = -enable-kvm -m 2048 -cpu host
>   
>   [lam]
>   file = lam.flat
>   arch = x86_64
> -extra_params = -enable-kvm -cpu max
> +qemu_params = -enable-kvm -cpu max

-- 
Shaoqin


