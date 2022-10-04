Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4434F5F40DC
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 12:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJDKb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 06:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiJDKby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 06:31:54 -0400
Received: from pv50p00im-ztdg10021901.me.com (pv50p00im-ztdg10021901.me.com [17.58.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC0C3FA1A
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 03:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
        t=1664879142; bh=Mc9SKPjS+zJA0G5WEib9D/fYuCld+4eFmEHniPH1AIc=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=ADuW/2dGCtIsUlhClvTTUFmcV1GMxbkD5WXLkgLQcWEvjb8DbBC+u/wmFz9FiXQ58
         vB+F1+UUKi5/po8ZNHmc4h0HnnFaBayqlEJU7rP27rCqLpFn9i6ZvBFjZngtCk/fjb
         0Hql0MGitqD/pRQwYnPO6LOk1EKlESkGhILmMIuCbCsQMFZ358mti8nmVJZzFGUo6R
         rSQtumJO0eFcudhes71BbAkQQSV9KzxOL8tEY4JSUqgL0JiWnYFP4V8MqzCSVw4QfH
         ke4T8ZECnUVnVQpjiSjL7v+ftxb5K/DCzIK3IVTPpICG4dx8Knp6ie5rfzXwmwRjhZ
         FNn27SXSv2iWw==
Received: from smtpclient.apple (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10021901.me.com (Postfix) with ESMTPSA id CD9EF8197B;
        Tue,  4 Oct 2022 10:25:39 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH  v3 14/15] gdbstub: move guest debug support check to ops
From:   Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <20220927141504.3886314-15-alex.bennee@linaro.org>
Date:   Tue, 4 Oct 2022 12:25:33 +0200
Cc:     qemu-devel@nongnu.org, "open list:ARM cores" <qemu-arm@nongnu.org>,
        =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2F256D6E-40B8-49F8-99E7-70B60127E7D6@ynddal.dk>
References: <20220927141504.3886314-1-alex.bennee@linaro.org>
 <20220927141504.3886314-15-alex.bennee@linaro.org>
To:     =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Proofpoint-GUID: QDvbfUURPPEqV9J9o6cbN-_cddP3bhUS
X-Proofpoint-ORIG-GUID: QDvbfUURPPEqV9J9o6cbN-_cddP3bhUS
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.883,17.11.64.514.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F08:2022-06-21=5F01,2022-06-21=5F08,2022-02-23?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=959 adultscore=0 mlxscore=0 suspectscore=0 clxscore=1030
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040067
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> This removes the final hard coding of kvm_enabled() in gdbstub and
> moves the check to an AccelOps.
>=20
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Cc: Mads Ynddal <mads@ynddal.dk>
> ---
> accel/kvm/kvm-cpus.h       | 1 +
> gdbstub/internals.h        | 1 +
> include/sysemu/accel-ops.h | 1 +
> include/sysemu/kvm.h       | 7 -------
> accel/kvm/kvm-accel-ops.c  | 1 +
> accel/kvm/kvm-all.c        | 6 ++++++
> accel/tcg/tcg-accel-ops.c  | 6 ++++++
> gdbstub/gdbstub.c          | 5 ++---
> gdbstub/softmmu.c          | 9 +++++++++
> gdbstub/user.c             | 6 ++++++
> 10 files changed, 33 insertions(+), 10 deletions(-)

Reviewed-by: Mads Ynddal <mads@ynddal.dk>=
