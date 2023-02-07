Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA7568CF71
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 07:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjBGGZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 01:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBGGZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 01:25:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCF611663;
        Mon,  6 Feb 2023 22:24:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1679261028;
        Tue,  7 Feb 2023 06:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7542C433EF;
        Tue,  7 Feb 2023 06:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675751098;
        bh=54y3Lwvfe2FREfsKfSnUXmHXeq1yIf3FBACyGmaiRRE=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=BC8LniRyI7cZxEo6V/OJ2TfOH069VH0jc3qDneWC0kfyzjiws/UB91UqGoy0lFgtx
         LXYsyjUw8f+1sNxpJGlVBfya8ow4ZabdSUYnCD4ja7JcVTA+TotnsaDqC4FFyOxLwJ
         /gw4Ly8IuJfxueit4OOu1nlpPL7HlA39DXOltgVBME/WkaSFStpXG5ENnJxQEVlLd0
         U+XIOSiAB4yFt/zAAbl7QLaniwUHax1VWlpRkQuTG7iHvQ9dPs1sNYkPuWGAQtGT5B
         logFTUf/8ekR7GU/UUYD6rX7lxMZlVKA5kmfFXLrfslmnLEUsm5nJwAQ45jlD/Ys69
         6JL2WFFYwXU7Q==
Date:   Tue, 07 Feb 2023 06:24:52 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Atish Patra <atishp@atishpatra.org>
CC:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 08/14] RISC-V: KVM: Add SBI PMU extension support
User-Agent: K-9 Mail for Android
In-Reply-To: <CAOnJCULfPR22sHLYAOmqbTZUg9XY3trOnMVoEcWjVXKU-TCw8A@mail.gmail.com>
References: <20230205011515.1284674-1-atishp@rivosinc.com> <20230205011515.1284674-9-atishp@rivosinc.com> <F8326D42-00ED-4639-91E7-5CF8E84469E7@kernel.org> <CAOnJCULfPR22sHLYAOmqbTZUg9XY3trOnMVoEcWjVXKU-TCw8A@mail.gmail.com>
Message-ID: <B878B403-34BD-457D-971B-7E6D5726E8F8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7 February 2023 06:10:57 GMT, Atish Patra <atishp@atishpatra=2Eorg> wro=
te:
>On Sun, Feb 5, 2023 at 2:31 AM Conor Dooley <conor@kernel=2Eorg> wrote:
>>
>>
>>
>> On 5 February 2023 02:15:09 GMT+01:00, Atish Patra <atishp@rivosinc=2Ec=
om> wrote:
>> >SBI PMU extension allows KVM guests to configure/start/stop/query abou=
t
>> >the PMU counters in virtualized enviornment as well=2E
>> >
>> >In order to allow that, KVM implements the entire SBI PMU extension=2E
>> >
>> >Reviewed-by: Anup Patel <anup@brainfault=2Eorg>
>> >Signed-off-by: Atish Patra <atishp@rivosinc=2Ecom>
>>
>> Hey Atish,
>> CI is still complaining about something in this patch:
>> https://gist=2Egithub=2Ecom/conor-pwbot/8f8d6a60a65b0b44d96c9c3b220e3ef=
d
>>
>
>This is an invalid warning as vcpu_sbi_ext_pmu is used as an extern varia=
ble in
>arch/riscv/kvm/vcpu_sbi=2Ec=2E That's how every sbi extension code define=
s the
>kvm_vcpu_sbi_extension in its own respective file=2E

Ah, so the user is in another patch=2E

>> I'm without a laptop this weekend, so apologies for
>> the lack of investigation as to whether there's a
>> reason for it=2E

Hard to check these things from a phone!
Sorry for bothering you so=2E

>>
>> Cheers,
>> Conor=2E
>>
>>
>> >---
>> > arch/riscv/kvm/Makefile       |  2 +-
>> > arch/riscv/kvm/vcpu_sbi=2Ec     | 11 +++++
>> > arch/riscv/kvm/vcpu_sbi_pmu=2Ec | 87 ++++++++++++++++++++++++++++++++=
+++
>> > 3 files changed, 99 insertions(+), 1 deletion(-)
>> > create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu=2Ec
>> >was > >diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
>> >index 5de1053=2E=2E278e97c 100644
>> >--- a/arch/riscv/kvm/Makefile
>> >+++ b/arch/riscv/kvm/Makefile
>> >@@ -25,4 +25,4 @@ kvm-y +=3D vcpu_sbi_base=2Eo
>> > kvm-y +=3D vcpu_sbi_replace=2Eo
>> > kvm-y +=3D vcpu_sbi_hsm=2Eo
>> > kvm-y +=3D vcpu_timer=2Eo
>> >-kvm-$(CONFIG_RISCV_PMU_SBI) +=3D vcpu_pmu=2Eo
>> >+kvm-$(CONFIG_RISCV_PMU_SBI) +=3D vcpu_pmu=2Eo vcpu_sbi_pmu=2Eo
>> >diff --git a/arch/riscv/kvm/vcpu_sbi=2Ec b/arch/riscv/kvm/vcpu_sbi=2Ec
>> >index fe2897e=2E=2E15fde15 100644
>> >--- a/arch/riscv/kvm/vcpu_sbi=2Ec
>> >+++ b/arch/riscv/kvm/vcpu_sbi=2Ec
>> >@@ -20,6 +20,16 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi=
_ext_v01 =3D {
>> > };
>> > #endif
>> >
>> >+#ifdef CONFIG_RISCV_PMU_SBI
>> >+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
>> >+#else
>> >+static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu =3D {
>> >+      =2Eextid_start =3D -1UL,
>> >+      =2Eextid_end =3D -1UL,
>> >+      =2Ehandler =3D NULL,
>> >+};
>> >+#endif
>> >+
>> > static const struct kvm_vcpu_sbi_extension *sbi_ext[] =3D {
>> >       &vcpu_sbi_ext_v01
>> >       &vcpu_sbi_ext_base,
>> >@@ -28,6 +38,7 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[=
] =3D {
>> >       &vcpu_sbi_ext_rfence,
>> >       &vcpu_sbi_ext_srst,
>> >       &vcpu_sbi_ext_hsm,
>> >+      &vcpu_sbi_ext_pmu,
>> >       &vcpu_sbi_ext_experimental,
>> >       &vcpu_sbi_ext_vendor,
>> > };
>> >diff --git a/arch/riscv/kvm/vcpu_sbi_pmu=2Ec b/arch/riscv/kvm/vcpu_sbi=
_pmu=2Ec
>> >new file mode 100644
>> >index 0000000=2E=2E9fdc1e1
>> >--- /dev/null
>> >+++ b/arch/riscv/kvm/vcpu_sbi_pmu=2Ec
>> >@@ -0,0 +1,87 @@
>> >+// SPDX-License-Identifier: GPL-2=2E0
>> >+/*
>> >+ * Copyright (c) 2023 Rivos Inc
>> >+ *
>> >+ * Authors:
>> >+ *     Atish Patra <atishp@rivosinc=2Ecom>
>> >+ */
>> >+
>> >+#include <linux/errno=2Eh>
>> >+#include <linux/err=2Eh>
>> >+#include <linux/kvm_host=2Eh>
>> >+#include <asm/csr=2Eh>
>> >+#include <asm/sbi=2Eh>
>> >+#include <asm/kvm_vcpu_sbi=2Eh>
>> >+
>> >+static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_=
run *run,
>> >+                                 struct kvm_vcpu_sbi_return *retdata)
>> >+{
>> >+      int ret =3D 0;
>> >+      struct kvm_cpu_context *cp =3D &vcpu->arch=2Eguest_context;
>> >+      struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
>> >+      unsigned long funcid =3D cp->a6;
>> >+      u64 temp;
>> >+
>> >+      /* Return not supported if PMU is not initialized */
>> >+      if (!kvpmu->init_done) {
>> >+              retdata->err_val =3D SBI_ERR_NOT_SUPPORTED;
>> >+              return 0;
>> >+      }
>> >+
>> >+      switch (funcid) {
>> >+      case SBI_EXT_PMU_NUM_COUNTERS:
>> >+              ret =3D kvm_riscv_vcpu_pmu_num_ctrs(vcpu, retdata);
>> >+              break;
>> >+      case SBI_EXT_PMU_COUNTER_GET_INFO:
>> >+              ret =3D kvm_riscv_vcpu_pmu_ctr_info(vcpu, cp->a0, retda=
ta);
>> >+              break;
>> >+      case SBI_EXT_PMU_COUNTER_CFG_MATCH:
>> >+#if defined(CONFIG_32BIT)
>> >+              temp =3D ((uint64_t)cp->a5 << 32) | cp->a4;
>> >+#else
>> >+              temp =3D cp->a4;
>> >+#endif
>> >+              /*
>> >+               * This can fail if perf core framework fails to create=
 an event=2E
>> >+               * Forward the error to userspace because it's an error=
 happened
>> >+               * within the host kernel=2E The other option would be =
to convert
>> >+               * this an SBI error and forward to the guest=2E
>> >+               */
>> >+              ret =3D kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, =
cp->a1,
>> >+                                                     cp->a2, cp->a3, =
temp, retdata);
>> >+              break;
>> >+      case SBI_EXT_PMU_COUNTER_START:
>> >+#if defined(CONFIG_32BIT)
>> >+              temp =3D ((uint64_t)cp->a4 << 32) | cp->a3;
>> >+#else
>> >+              temp =3D cp->a3;
>> >+#endif
>> >+              ret =3D kvm_riscv_vcpu_pmu_ctr_start(vcpu, cp->a0, cp->=
a1, cp->a2,
>> >+                                                 temp, retdata);
>> >+              break;
>> >+      case SBI_EXT_PMU_COUNTER_STOP:
>> >+              ret =3D kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a=
1, cp->a2, retdata);
>> >+              break;
>> >+      case SBI_EXT_PMU_COUNTER_FW_READ:
>> >+              ret =3D kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retda=
ta);
>> >+              break;
>> >+      default:
>> >+              retdata->err_val =3D SBI_ERR_NOT_SUPPORTED;
>> >+      }
>> >+
>> >+      return ret;
>> >+}
>> >+
>> >+static unsigned long kvm_sbi_ext_pmu_probe(struct kvm_vcpu *vcpu)
>> >+{
>> >+      struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
>> >+
>> >+      return kvpmu->init_done;
>> >+}
>> >+
>> >+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu =3D {
>> >+      =2Eextid_start =3D SBI_EXT_PMU,
>> >+      =2Eextid_end =3D SBI_EXT_PMU,
>> >+      =2Ehandler =3D kvm_sbi_ext_pmu_handler,
>> >+      =2Eprobe =3D kvm_sbi_ext_pmu_probe,
>> >+};
>
>
>
