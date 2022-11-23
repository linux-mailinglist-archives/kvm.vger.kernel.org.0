Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749D8635CE4
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 13:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbiKWM2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 07:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237676AbiKWM1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 07:27:36 -0500
Received: from mr85p00im-zteg06021601.me.com (mr85p00im-zteg06021601.me.com [17.58.23.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2D3657E9
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 04:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
        t=1669206367; bh=lJVg3ZxnRm681egfIyRW+IsGtQn9gz8w4LBHD7jLcPE=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=F2bJXTHsWBHn0Iec7wZADHHqmhzwKVu2p29dOV0HvnPhY8jijHhlAMoNfIc4Vqzs2
         6CGa/E3Vj8XjEdkyEX11X0traT7QqtPg6HLzuoKhqWWAlS3d1D+rl8QLffipkIy88j
         UrrL1NPXmvPtqXAR5dGOenngoNNpQk6vAGp9KzQ190NpdcYabYPD/v1V4b22GoQctq
         HiF9z0yAjSDSX0CqWWz7e7VWKgWVtrb/2hvrzioG7r09/N+E8ZYCC0nkpTMrawjD3M
         R/Ue5jezhcPz06bHGd+OovJhE6aX36oCVfqzubT5Ajj9brlx3Pp8QCuviRsWYoHYDs
         /5mp9ArktwwWA==
Received: from smtpclient.apple (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-zteg06021601.me.com (Postfix) with ESMTPSA id 42F0A404DD;
        Wed, 23 Nov 2022 12:26:05 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] gdbstub: move update guest debug to accel ops
From:   Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <20221123121712.72817-1-mads@ynddal.dk>
Date:   Wed, 23 Nov 2022 13:25:53 +0100
Cc:     "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Mads Ynddal <mads@ynddal.dk>
Content-Transfer-Encoding: quoted-printable
Message-Id: <030ED145-9BC0-4B16-A0FD-A7F5E0F4EA85@ynddal.dk>
References: <20221123121712.72817-1-mads@ynddal.dk>
To:     qemu-devel@nongnu.org
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Proofpoint-ORIG-GUID: SJMrlgdhjI1cJwv3jZxliVHc5Am-SPPQ
X-Proofpoint-GUID: SJMrlgdhjI1cJwv3jZxliVHc5Am-SPPQ
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.425,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-14=5F01:2022-01-14=5F01,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1030 spamscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=878 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2211230092
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 23 Nov 2022, at 13.17, Mads Ynddal <mads@ynddal.dk> wrote:
>=20
> From: Mads Ynddal <m.ynddal@samsung.com>
>=20
> Continuing the refactor of a48e7d9e52 (gdbstub: move guest debug =
support
> check to ops) by removing hardcoded kvm_enabled() from generic cpu.c
> code, and replace it with a property of AccelOpsClass.
>=20
> Signed-off-by: Mads Ynddal <m.ynddal@samsung.com>
> ---
> accel/kvm/kvm-accel-ops.c  |  1 +
> cpu.c                      | 10 +++++++---
> include/sysemu/accel-ops.h |  1 +
> 3 files changed, 9 insertions(+), 3 deletions(-)
>=20

+CC Alex Benn=C3=A9e=
