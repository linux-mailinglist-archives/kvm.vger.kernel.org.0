Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4485152C118
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240915AbiERRMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240901AbiERRMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:12:13 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2088C14B64A
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:12:12 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id a127so2758480vsa.3
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=+AANePwKGdxk2E4UxIRt4i4SnxzMdkwNxju/Mp13Gj0=;
        b=Bzyb4JS6IeF8/oQHViGvpXIOB4Ax+TYolJxDMJM4lcc8a4iva6NLdelYALp9VRXpqf
         5zlD/037AqZMIZm8FjvmT+xZIqjNABOoD2oSiIeA6jPqzy6XMe+91OXXQaN56bf4Bu1Z
         eCIHMX5fN67cquqO/VvThmouQFFq5AvgRHA0glvqCfi26d1WPmkXHUWKZeCmb3YMx6mO
         9fpWT+mEpN2H5Jhd9Jegki33l/zKHQi2ckuQUtXRBko6B5HxtlPUPFT2N0cDEw0QznqM
         UHqJWvyy8pqdSfi1pl+Yk1bPqxEyDDKcZVm6Z5TVAPjvCc668gpKAWT7HdonEK93/S0r
         gKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=+AANePwKGdxk2E4UxIRt4i4SnxzMdkwNxju/Mp13Gj0=;
        b=j8djP294/KzvqXENafrlEDgtQHGF1PZkAd+FjYZlZS41V4E7ApyCRin7I/gbPTms5u
         G+ZSopQRLzQRkqJInXfN3vuL/ptK6wIdxd7F3LsyrL4zgRunvqM+1tl8QBVfeBDkBX2C
         OtjXJ4Dy7Yrkn9N5JLXorkJutrnnptDvzL8uCrc5i4bZVxkhLtiURS9B+Vo54ZQ1i0D2
         5A/I6DY3SCIuSM97WuQbFZi4vFITExPidoV7t6d54AxBAaXn/4zSPLU5x1VitEDjHA1l
         s/KahBVRmuMaRMKXF/OUUFEtRwzPB/FFBkvPjKWzSjI+4wS0D+rGQrx5/VhpW/20Q8X3
         VWig==
X-Gm-Message-State: AOAM531NZyQlnaw8Adm9dkdYkYAyuLtLgTcxluDAiGXiJwjsoZb60x7l
        Ez1lqoRDkQ6o7t8ppBz2z/bXDvRK2ewpYYsewXWsCMPs
X-Google-Smtp-Source: ABdhPJzMeRt/61lEL/ROSFfY1Hm+P457W2h/vcIy1XETrOfIMntoH0jTi3LD2FAAbsXLiRo73Ap1TYNsEdJ0StWCmL8=
X-Received: by 2002:a05:6102:3e90:b0:327:eb37:be90 with SMTP id
 m16-20020a0561023e9000b00327eb37be90mr503077vsv.26.1652893931043; Wed, 18 May
 2022 10:12:11 -0700 (PDT)
MIME-Version: 1.0
From:   Brian Cowan <brcowan@gmail.com>
Date:   Wed, 18 May 2022 13:12:39 -0400
Message-ID: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
Subject: A really weird guest crash, that ONLY happens on KVM, and ONLY on 6th
 gen+ Intel Core CPU's
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all, looking for hints on a wild crash.

The company I work for has a kernel driver used to literally make a db
query result look like a filesystem=E2=80=A6 The =E2=80=9Cdatabase=E2=80=9D=
 in question being
a proprietary SCM repository=E2=80=A6 (ClearCase, for those who have been
around forever=E2=80=A6 Like me=E2=80=A6)

We have a crash on mounting the remote repository ONE way (ClearCase
=E2=80=9CAutomatic views=E2=80=9D) but not another (ClearCase =E2=80=9CDyna=
mic views=E2=80=9D) where
both use the same kernel driver=E2=80=A6 The guest OS is RHEL 7.8, not
registered with RH (since the VM is only supposed to last a couple of
days.) The host OS is Ubuntu 20.04.2 LTS, though that does not seem to
matter.

The wild part is that this only happens when the ClearCase host is a
KVM guest, and only on 6th-generation or newer . It does NOT happen
on:
* VMWare Virtual machines configured identically
* VirtualBox Virtual machines Configured identically
* 2nd generation intel core hosts running the same KVM release.
(because OF COURSE my office "secondary desktop" host is ancient...
* A 4th generation I7 host running Ubuntu 22.04 and that version=E2=80=99s
default KVM. (Because I am a laptop packrat. That laptop had been
sitting on a bookshelf for 3+ years and I went "what if...")

If I edit the KVM configuration and change the =E2=80=9Cmirror host CPU=E2=
=80=9D
option to use the 2nd or 4th generation CPU options, the crash stops
happening=E2=80=A6 If this was happening on physical machines, the VM crash
would make sense, but it's literally a hypervisor-specific crash.

Any hints, tips, or comments would be most appreciated... Never
thought I'd be trying to debug kernel/hypervisor interactions, but
here I am...
