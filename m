Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01345F40DB
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 12:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiJDKb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 06:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiJDKby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 06:31:54 -0400
X-Greylist: delayed 377 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Oct 2022 03:31:53 PDT
Received: from pv50p00im-ztdg10021901.me.com (pv50p00im-ztdg10021901.me.com [17.58.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C11924951
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 03:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
        t=1664879136; bh=irS+IMj7fxUkA3LyldGd+V+KREAfBoo4MYjatluiGoY=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=YHCKcP+ivmDMcpuNWxQx4sV5UV/DOUt1MHzIXu/Wa8t3EALQUmVgG/YvFTBHorxaH
         0Ugl2BqMAQKVolV4mnnceuCTrlYGv022i99U92J9kEwpP9gJkQKjzi/IqdHdX/gh3z
         pwRZlu1DgwA++4bp1mBPkqB0BfQw8+r/UrQwP3ycpD1cJ/yGF9Hgv1wHWeBLUpyhZ7
         qWDo7HHiF85H7jm6fg3nweu+mxgIoLL0Kt0LGkeWg1iG8efSodgat/Tw2wGpJsWW6n
         alyowHJFmbKwyX68FAUwJPxAN4dptdFxrCITa+o9gVw1v2s9tTmEdsNX9wdTTwRDsX
         gzW/xDlKg86wA==
Received: from smtpclient.apple (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10021901.me.com (Postfix) with ESMTPSA id 28A5081A09;
        Tue,  4 Oct 2022 10:25:32 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH  v3 12/15] gdbstub: move sstep flags probing into
 AccelClass
From:   Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <20220927141504.3886314-13-alex.bennee@linaro.org>
Date:   Tue, 4 Oct 2022 12:25:30 +0200
Cc:     qemu-devel@nongnu.org, "open list:ARM cores" <qemu-arm@nongnu.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <84FB206A-5BFF-403F-84B9-2AC9F353096B@ynddal.dk>
References: <20220927141504.3886314-1-alex.bennee@linaro.org>
 <20220927141504.3886314-13-alex.bennee@linaro.org>
To:     =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Proofpoint-GUID: JimXms5MbrMWolMGRiZc5txqLU-VC4hy
X-Proofpoint-ORIG-GUID: JimXms5MbrMWolMGRiZc5txqLU-VC4hy
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.883,17.11.64.514.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F08:2022-06-21=5F01,2022-06-21=5F08,2022-02-23?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=818 adultscore=0 mlxscore=0 suspectscore=0 clxscore=1030
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


> The support of single-stepping is very much dependent on support from
> the accelerator we are using. To avoid special casing in gdbstub move
> the probing out to an AccelClass function so future accelerators can
> put their code there.
>=20
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Cc: Mads Ynddal <mads@ynddal.dk>
> ---
> include/qemu/accel.h | 12 ++++++++++++
> include/sysemu/kvm.h |  8 --------
> accel/accel-common.c | 10 ++++++++++
> accel/kvm/kvm-all.c  | 14 +++++++++++++-
> accel/tcg/tcg-all.c  | 17 +++++++++++++++++
> gdbstub/gdbstub.c    | 22 ++++------------------
> 6 files changed, 56 insertions(+), 27 deletions(-)

Reviewed-by: Mads Ynddal <mads@ynddal.dk>=
