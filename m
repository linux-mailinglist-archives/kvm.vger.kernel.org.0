Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6FD5F40EA
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 12:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJDKhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 06:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiJDKhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 06:37:33 -0400
Received: from pv50p00im-ztdg10021801.me.com (pv50p00im-ztdg10021801.me.com [17.58.6.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07A04D836
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 03:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
        t=1664879851; bh=QlSvwC0FZZH5RpxI3IuBMhXIoFMoTqI4zfjc2S1+OV0=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=D1V9Yggm9nh8f1zUmW5Wywq3JAnJ8ONUdGQxndkyTGLn9QxAxSrPWWdugXjlK2l8B
         90HAiVl18V0JLftlgnLZd8qF9OYGhEDORi3F+5qFEB9tlqqYbS3m2mbB4Sl+KaOkLr
         RgSjQCB4be+knpIQEEUwSGpUpvy3no8h8p0cOOsTyOYcUwqtYZfb1/lO6/yADaBzRF
         TTET6sU2X5MABE1ytTHo2YsOh3gFWl9aWQnJnra15FjDjTthZjv6DXzjIR9eYizRZw
         7Xt3L00aPTPBHkupyKRhGKc/Fyy0q2PF7IwKglq+4m1NT9/k/iIQ1kB8lWflRmvMAP
         ccUpqzyi5gD1Q==
Received: from smtpclient.apple (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10021801.me.com (Postfix) with ESMTPSA id 26CA01609A3;
        Tue,  4 Oct 2022 10:37:27 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH  v3 13/15] gdbstub: move breakpoint logic to accel ops
From:   Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <20220927141504.3886314-14-alex.bennee@linaro.org>
Date:   Tue, 4 Oct 2022 12:25:32 +0200
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <340E64CE-3798-4671-9C51-510E28216E1E@ynddal.dk>
References: <20220927141504.3886314-1-alex.bennee@linaro.org>
 <20220927141504.3886314-14-alex.bennee@linaro.org>
To:     =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Proofpoint-GUID: sexTsaKf4iJ8y5gI7xPpZWij0kVGfh8k
X-Proofpoint-ORIG-GUID: sexTsaKf4iJ8y5gI7xPpZWij0kVGfh8k
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.11.64.514.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2022-02-23?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=964 bulkscore=0
 clxscore=1030 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040068
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> As HW virtualization requires specific support to handle breakpoints
> lets push out special casing out of the core gdbstub code and into
> AccelOpsClass. This will make it easier to add other accelerator
> support and reduces some of the stub shenanigans.
>=20
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Cc: Mads Ynddal <mads@ynddal.dk>
> ---
> accel/kvm/kvm-cpus.h       |   3 +
> gdbstub/internals.h        |  16 +++++
> include/sysemu/accel-ops.h |   6 ++
> include/sysemu/cpus.h      |   3 +
> include/sysemu/kvm.h       |   5 --
> accel/kvm/kvm-accel-ops.c  |   8 +++
> accel/kvm/kvm-all.c        |  24 +------
> accel/stubs/kvm-stub.c     |  16 -----
> accel/tcg/tcg-accel-ops.c  |  92 +++++++++++++++++++++++++++
> gdbstub/gdbstub.c          | 127 +++----------------------------------
> gdbstub/softmmu.c          |  42 ++++++++++++
> gdbstub/user.c             |  62 ++++++++++++++++++
> softmmu/cpus.c             |   7 ++
> gdbstub/meson.build        |   8 +++
> 14 files changed, 259 insertions(+), 160 deletions(-)

Reviewed-by: Mads Ynddal <mads@ynddal.dk>=
