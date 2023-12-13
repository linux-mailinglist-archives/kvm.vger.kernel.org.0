Return-Path: <kvm+bounces-4292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CE95810A80
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 07:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD4D51F2190F
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 06:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7815C10A0C;
	Wed, 13 Dec 2023 06:40:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DACAAD;
	Tue, 12 Dec 2023 22:40:37 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8AxZfDjUXll_pUAAA--.3703S3;
	Wed, 13 Dec 2023 14:40:35 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxvnPhUXllJvMBAA--.12195S2;
	Wed, 13 Dec 2023 14:40:33 +0800 (CST)
From: Tianrui Zhao <zhaotianrui@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	maobibo@loongson.cn,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: WANG Xuerui <kernel@xen0n.name>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	loongarch@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Mark Brown <broonie@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Xi Ruoyao <xry111@xry111.site>,
	zhaotianrui@loongson.cn
Subject: [PATCH v4 0/2] LoongArch: KVM: Add LSX,LASX support
Date: Wed, 13 Dec 2023 14:27:38 +0800
Message-Id: <20231213062740.4175002-1-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxvnPhUXllJvMBAA--.12195S2
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This patch series add LSX,LASX support for LoongArch KVM.
There will be LSX,LASX exception in KVM when guest use the
LSX,LASX instructions. KVM will enable LSX,LASX and restore
the vector registers for guest then return to guest to continue
running.

Changes for v4:
1. Supplement vcpu features checking when cpucfg2 is passed from
user space.
(1) The LLFTP must be set, as guest must has a constant timer.
(2) Single and double float point must both be set when enable FP.
(3) FP should be set when enable LSX.
(4) LSX,FP should be set when enable LASX.

Changes for v3:
1. Use KVM_GET_DEVICE_ATTR interface to return CPUCFG2
features which are supported by KVM to user space.
2. Remove version checking in kvm_check_cpucfg.

Changes for v2:
1. Add interface to return CPUCFG2 features which have
been supported by current KVM to user space. So that
user space can get CPU features such as FPU,LSX,LASX
whether support by KVM.
2. Add CPUCFG2 checking interface to check that if the
value which is passed from user space has any errors.
3. Export both _restore_lsx_upper and _restore_lasx_upper
to keep consistency.
4. Use "jr ra" instruction to repalce "jirl zero, ra, 0".

Changes for v1:
1. Add LSX support for LoongArch KVM.
2. Add LASX support for LoongArch KVM.

Tianrui Zhao (2):
  LoongArch: KVM: Add LSX support
  LoongArch: KVM: Add LASX support

 arch/loongarch/include/asm/kvm_host.h |  17 ++
 arch/loongarch/include/asm/kvm_vcpu.h |  22 +++
 arch/loongarch/include/uapi/asm/kvm.h |   1 +
 arch/loongarch/kernel/fpu.S           |   2 +
 arch/loongarch/kvm/exit.c             |  37 ++++
 arch/loongarch/kvm/switch.S           |  36 ++++
 arch/loongarch/kvm/trace.h            |   6 +-
 arch/loongarch/kvm/vcpu.c             | 271 +++++++++++++++++++++++++-
 8 files changed, 386 insertions(+), 6 deletions(-)

-- 
2.39.1


