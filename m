Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22F6651F2D
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 11:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiLTKqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 05:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiLTKqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 05:46:13 -0500
Received: from mr85p00im-hyfv06021401.me.com (mr85p00im-hyfv06021401.me.com [17.58.23.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA76397
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 02:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
        t=1671533171; bh=+/eU1TAjx4WUSjXZ6JhSVqCcFUfV+vuJWIVq0JcPOrk=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=V6e+hvGRi/qMbxwUXXOCjaAAeljCF0VJ2je1F54nG+aDC/NX8a7QYt3WCXmbtQoY4
         znaJtDUPcR8eAP1QF5+X6gGECA+s026lu1x9yxfQ1CD118LJROJvPwQBE1QwsQekjJ
         tVVab+DaDES8o12jHy6Rul4aJCdU25DfH2y1ufV1rsNBXkpwDQZ12ImItWB7ofYYOp
         aKn5LNH+XEh0DJxCzHvySOhgsbDMy7oolDNs8Q+BhYsRk75+RoqEL6BARkhkDhzIbt
         l27v5EtEvTSVGhLi60ZkRe2oBsAc3gF38w0vXguDWF4asJpMyNMElpV8o66Cc7j6yD
         KOVJZgBKKDNrA==
Received: from smtpclient.apple (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-hyfv06021401.me.com (Postfix) with ESMTPSA id EF840303FAC4;
        Tue, 20 Dec 2022 10:46:08 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] gdbstub: move update guest debug to accel ops
From:   Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <87h6xyjcdh.fsf@linaro.org>
Date:   Tue, 20 Dec 2022 11:45:56 +0100
Cc:     =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4B19094C-63DC-4A81-A008-886504256D5D@ynddal.dk>
References: <20221123121712.72817-1-mads@ynddal.dk>
 <af92080f-e708-f593-7ff5-81b7b264d587@linaro.org>
 <C8BC6E24-F98D-428D-80F8-98BDA40C7B15@ynddal.dk> <87h6xyjcdh.fsf@linaro.org>
To:     =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Proofpoint-GUID: JCBdP1BveQSPN6rlqSgMr_A8JbhoN_u6
X-Proofpoint-ORIG-GUID: JCBdP1BveQSPN6rlqSgMr_A8JbhoN_u6
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.425,18.0.816,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-18=5F01:2022-01-14=5F01,2022-01-18=5F01,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 clxscore=1030 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2212200090
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> It will do. You could just call it update_guest_debug as it is an
> internal static function although I guess that makes grepping a bit of =
a
> pain.

I agree. It should preferably be something unique, to ease grep'ing.

> Is something being accidentally linked with linux-user and softmmu?

Good question. I'm not familiar enough with the code base to know.

I experimented with enabling/disabling linux-user when configuring, and =
it does
affect whether it compiles or not.

The following seems to fix it, and I can see the same approach is taken =
other
places in cpu.c. Would this be an acceptable solution?

diff --git a/cpu.c b/cpu.c
index 6effa5acc9..c9e8700691 100644
--- a/cpu.c
+++ b/cpu.c
@@ -386,6 +386,7 @@ void cpu_breakpoint_remove_all(CPUState *cpu, int =
mask)
 void cpu_single_step(CPUState *cpu, int enabled)
 {
     if (cpu->singlestep_enabled !=3D enabled) {
+#if !defined(CONFIG_USER_ONLY)
         const AccelOpsClass *ops =3D cpus_get_accel();

         cpu->singlestep_enabled =3D enabled;
@@ -393,6 +394,7 @@ void cpu_single_step(CPUState *cpu, int enabled)
         if (ops->update_guest_debug) {
             ops->update_guest_debug(cpu, 0);
         }
+#endif

         trace_breakpoint_singlestep(cpu->cpu_index, enabled);
     }

=E2=80=94
Mads Ynddal

