Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F0A636207
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 15:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbiKWOlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 09:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbiKWOlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 09:41:32 -0500
Received: from mr85p00im-ztdg06021801.me.com (mr85p00im-ztdg06021801.me.com [17.58.23.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D7611C02
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 06:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
        t=1669214491; bh=YoTnueSOm5nRNUCyNMaLCXhvOGUqLJOkEgAT4C74spQ=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=A/G5kqbROZhHsUruc+wabTCDnpJWLessMk0Qq+bYbaWnjYJqDyEyqTnR7H+g5L3NM
         tCXritpo9bLDzz1nPSBzozSp5G+G09TcU/3nc74NBp7vxGfpm/mKXtbA/ccSsIgTX4
         WlTYfZ4DFUVkpUSuqR3omE9Wl66AJXF+nvjvUCPp3cuFKzvrfcoQLK3maHmYc9Sg/+
         WQ2IU541fMMRRX8H7wN7HW7R74ZluaOwYQoHq2WtOkb+H+eJYnoof9/3TW9OTGpBdp
         mTJqrroICyKNSk3jZ5LEw665Ne7mmyXKaU+6LXycKIP6bgW+4Ve/j3nw3MTTjadXsN
         5PbEjcIn6kqOw==
Received: from smtpclient.apple (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-ztdg06021801.me.com (Postfix) with ESMTPSA id 6B008D00941;
        Wed, 23 Nov 2022 14:41:29 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] gdbstub: move update guest debug to accel ops
From:   Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <87k03lbwaz.fsf@linaro.org>
Date:   Wed, 23 Nov 2022 15:41:17 +0100
Cc:     "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-devel@nongnu.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <460BA831-0D46-482A-A647-8C6E1C70CF52@ynddal.dk>
References: <20221123121712.72817-1-mads@ynddal.dk>
 <87k03lbwaz.fsf@linaro.org>
To:     =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Proofpoint-GUID: _L0Su5wXsImx2G-_Ibexfbi7zIDlVTp_
X-Proofpoint-ORIG-GUID: _L0Su5wXsImx2G-_Ibexfbi7zIDlVTp_
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1030 phishscore=0
 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 mlxlogscore=810 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2211230109
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Nov 2022, at 15.05, Alex Benn=C3=A9e <alex.bennee@linaro.org> =
wrote:
>=20
> Nice. Looks good to me but I'll have a proper look when I go through =
my
> gdbstub/next queue. I don't think this is critical for 7.2.
>=20

Thanks, and I agree. It can easily wait.=
