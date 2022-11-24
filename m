Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF97A637B07
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 15:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiKXOEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 09:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiKXODj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 09:03:39 -0500
Received: from mr85p00im-ztdg06021701.me.com (mr85p00im-ztdg06021701.me.com [17.58.23.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB3B1255C2
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 06:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
        t=1669298483; bh=AoIel4w+JRQ/jK7hEzDTo1ooQVDioZn5F3sPHAbOF2A=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=HGLSjv4XAZXEUAzlcPKwjVSMLz9CbaPQp8/UDeelhjp6s5xWVXtZyoWOwNKa+ypYG
         dfIizEuop1U1/OuUmC615QYlZqQH1z3+X/6dtIaSUKQ5HY24MYKLAfh6QlkVrQ7sHQ
         NZwobpl1mB3e3pg8GWGYo6YzNGQX1mQNdYr2YdeX3VLJFVBExKlJKNyedNnb3fnVQI
         66JHtol68sHXAHGacCKgbEHKfdB0mvFVcamOIuOFBAHkngXCCFWZlGOh0q3yxyCvGq
         y8BVQJ6v1TwnoS993uFHw1hVjCwHgDKZgIEm9FZmQFL+wie5NqfH+nwEFgJXxxOATy
         2C3KqMaLtrIWA==
Received: from smtpclient.apple (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-ztdg06021701.me.com (Postfix) with ESMTPSA id DA5309A0549;
        Thu, 24 Nov 2022 14:01:19 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] gdbstub: move update guest debug to accel ops
From:   Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <af92080f-e708-f593-7ff5-81b7b264d587@linaro.org>
Date:   Thu, 24 Nov 2022 14:59:52 +0100
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C8BC6E24-F98D-428D-80F8-98BDA40C7B15@ynddal.dk>
References: <20221123121712.72817-1-mads@ynddal.dk>
 <af92080f-e708-f593-7ff5-81b7b264d587@linaro.org>
To:     =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Proofpoint-ORIG-GUID: DWzLgZrbfIE4SuGNGfuepdxL-rqKcJSM
X-Proofpoint-GUID: DWzLgZrbfIE4SuGNGfuepdxL-rqKcJSM
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 clxscore=1030 phishscore=0 malwarescore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2211240106
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> Isn't this '0' flag here accelerator-specific? ...

> ... if so the prototype should be:
>=20
>       int (*update_guest_debug)(CPUState *cpu);
>=20
> and the '0' value set within kvm-accel-ops.c handler implementation.
>=20

You're right, we can avoid the additional variable. We'll then have to =
wrap
`kvm_update_guest_debug`. Would the following be ok?

diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 6ebf9a644f..5e0fb42408 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -86,6 +86,10 @@ static bool kvm_cpus_are_resettable(void)
     return !kvm_enabled() || kvm_cpu_check_are_resettable();
 }
=20
+static int kvm_update_guest_debug_ops(CPUState *cpu) {
+    return kvm_update_guest_debug(cpu, 0);
+}
+
 static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
 {
     AccelOpsClass *ops =3D ACCEL_OPS_CLASS(oc);
@@ -99,7 +103,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, =
void *data)
     ops->synchronize_pre_loadvm =3D kvm_cpu_synchronize_pre_loadvm;
=20
 #ifdef KVM_CAP_SET_GUEST_DEBUG
-    ops->update_guest_debug =3D kvm_update_guest_debug;
+    ops->update_guest_debug =3D kvm_update_guest_debug_ops;
     ops->supports_guest_debug =3D kvm_supports_guest_debug;
     ops->insert_breakpoint =3D kvm_insert_breakpoint;
     ops->remove_breakpoint =3D kvm_remove_breakpoint;
diff --git a/cpu.c b/cpu.c
index ef433a79e3..b2ade96caa 100644
--- a/cpu.c
+++ b/cpu.c
@@ -383,7 +383,7 @@ void cpu_single_step(CPUState *cpu, int enabled)
         cpu->singlestep_enabled =3D enabled;
=20
         if (ops->update_guest_debug) {
-            ops->update_guest_debug(cpu, 0);
+            ops->update_guest_debug(cpu);
         }
=20
         trace_breakpoint_singlestep(cpu->cpu_index, enabled);
diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
index 0a47a2f00c..cd6a4ef7a5 100644
--- a/include/sysemu/accel-ops.h
+++ b/include/sysemu/accel-ops.h
@@ -48,7 +48,7 @@ struct AccelOpsClass {
=20
     /* gdbstub hooks */
     bool (*supports_guest_debug)(void);
-    int (*update_guest_debug)(CPUState *cpu, unsigned long flags);
+    int (*update_guest_debug)(CPUState *cpu);
     int (*insert_breakpoint)(CPUState *cpu, int type, hwaddr addr, =
hwaddr len);
     int (*remove_breakpoint)(CPUState *cpu, int type, hwaddr addr, =
hwaddr len);
     void (*remove_all_breakpoints)(CPUState *cpu);


If you have a better name for `kvm_update_guest_debug_ops`, I'm open for
suggestions.

On a side note. When compiling for an arch that isn't the same as the =
system
(i.e. aarch64 on x86_64), I'm getting a linker-error for cpu.c that
`cpus_get_accel` isn't defined. Do I need to move `cpus_get_accel` or =
somehow
#ifdef its use?=
