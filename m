Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9835168D625
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 13:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjBGMFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 07:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjBGMFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 07:05:07 -0500
X-Greylist: delayed 388 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Feb 2023 04:05:06 PST
Received: from mr85p00im-hyfv06011401.me.com (mr85p00im-hyfv06011401.me.com [17.58.23.191])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B7027986
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 04:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
        t=1675771118; bh=Cn0qz0bMHB6vxV8Q4ejxdppqOEkAynR/SkSPXu1IlvI=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=Xr4x63GAslHmhREJ5ScX0ShUVTWttvXUdV+P0RRokExZ+BiNGGhAJQr532uOfCXj1
         ZqkDVc9iOGpGjBHjWVFxgIwpjsracshofIVX3/1c8bFteBwMssKElDCSl9Wq++grLs
         1YE8czPPd15jiviooew03Evu38xofTXifMKQYw62JHNKzwacVgifJS64xzMIdmZbsS
         L6WveY1JxmlZ2fpSB/ClKH8gn6QiJUvvvgt/NdWQKM1L6rXc4EKkV9GtRNNiDcuJoi
         NCukyy9rq6vHv5GsbMTMqRRH9NhBvTcjFByiC8xHexFZoeyjAggq/BQ0XVsdm38Gnv
         dBh9CuU3l811g==
Received: from smtpclient.apple (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-hyfv06011401.me.com (Postfix) with ESMTPSA id DA007357B5F6;
        Tue,  7 Feb 2023 11:58:35 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] gdbstub: move update guest debug to accel ops
From:   Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <871qn2rjd2.fsf@linaro.org>
Date:   Tue, 7 Feb 2023 12:58:23 +0100
Cc:     =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <35145587-C279-46A1-A2C5-3261A646F225@ynddal.dk>
References: <20221123121712.72817-1-mads@ynddal.dk>
 <af92080f-e708-f593-7ff5-81b7b264d587@linaro.org>
 <C8BC6E24-F98D-428D-80F8-98BDA40C7B15@ynddal.dk> <87h6xyjcdh.fsf@linaro.org>
 <4B19094C-63DC-4A81-A008-886504256D5D@ynddal.dk> <871qn2rjd2.fsf@linaro.org>
To:     =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Proofpoint-GUID: SyIWDj8aX2WDaQWMsXo-TNJimMYxIvbX
X-Proofpoint-ORIG-GUID: SyIWDj8aX2WDaQWMsXo-TNJimMYxIvbX
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.425,18.0.816,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-18=5F01:2022-01-14=5F01,2022-01-18=5F01,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1030
 suspectscore=0 mlxlogscore=660 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2302070107
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>=20
> Sorry this dropped of my radar. Yes I think the ifdef will do. Are you
> going to post a v2 with all the various updates?
>=20

No worries, I'll make a v2 with the changes.

=E2=80=94
Mads Ynddal

