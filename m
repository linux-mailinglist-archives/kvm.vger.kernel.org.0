Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04A8570F35
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiGLBHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiGLBHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:07:51 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCE827FFF;
        Mon, 11 Jul 2022 18:07:50 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fz10so6270120pjb.2;
        Mon, 11 Jul 2022 18:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ypHMFXn2YcaaY0AHuBIgk51BYFs/v71Cwy5/0gPeK/s=;
        b=dprawehKM255mpHjv2LvRV9r7DqT89cmjcUNjBYT50xteRnjmIoWBNBWamqcfPSZDo
         UUGpiMlUY835A7PsSGcfBOtRNVoOjyTQgXradmnDPaBTla0uzAfxF9Zhd1pNAmaSYyTH
         KcCnbTzkHSuAhrPmqoIBWQi7JkX7jsS4ntfcUdEnVu36rD2FL1ZPe3oXFAhnV8dsNEQ3
         6LMjH52IhekqLnIXq7vv0JR6nobm/XLYMckYVaIi8CW2TuTDEzXPM2/B2VFnhpeJIXEF
         pXQrABnnJAMGOYBtPOgdvqnvcVUsgIcOJGJdEup1Jwmxk/bTNGfgTnodTgySbbHpS9NT
         YNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ypHMFXn2YcaaY0AHuBIgk51BYFs/v71Cwy5/0gPeK/s=;
        b=vrAGd9fhr99VNXYBws6eLZVcsrAoZQzalzPaJAMmbPZTcbbRYugbpuxXc6GZo2XquH
         57rgq2E+Kdn/uToxSGNGMnb3CSvSYPtylDJhCcxZ7JEfLzUBuzdnAqqClJPlPBZV4I9e
         9cazbvAzEKbjHM4stM7Qxk3hQ98lDMmEH++4cnsLQuZEli171PaitympLou8JNxhrw2V
         Z8AXqNh8EwYGW437bv0KntKIbY8YaJFIMUs5EZmaaNJjnUG6068Jv1sLDhxhgsX3RLxt
         OPRtfFbdOw5M2EpYbLVY8hLVXlWtXcKZBqMEy5oYCyYK0Vv7Vt/9qtskRO/8ygQukuag
         4s5w==
X-Gm-Message-State: AJIora8FLoFo24fXp0JBhgZY3vXcpsfUcaDi9cpldrC+DlxhchPUtIwG
        pH5eahA6PSRe/VDJYpSqho0=
X-Google-Smtp-Source: AGRyM1tuySMa992JVPAaBz05oHL2gAY/HgT/wzJjOIpgpZ5baQPIPETMaeVDHZGpChmgXF3RgHDfRA==
X-Received: by 2002:a17:90b:4a90:b0:1f0:4059:b2e5 with SMTP id lp16-20020a17090b4a9000b001f04059b2e5mr1231262pjb.241.1657588069342;
        Mon, 11 Jul 2022 18:07:49 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id q11-20020aa7982b000000b005289fad1bbesm5546838pfl.94.2022.07.11.18.07.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jul 2022 18:07:48 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 0/3] KVM: x86: Fix fault-related bugs in LTR/LLDT
 emulation
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20220711232750.1092012-1-seanjc@google.com>
Date:   Mon, 11 Jul 2022 18:07:47 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <103BF4B8-2ABE-4CB1-9361-F386D820E554@gmail.com>
References: <20220711232750.1092012-1-seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Jul 11, 2022, at 4:27 PM, Sean Christopherson <seanjc@google.com> =
wrote:

> Patch 1 fixes a bug found by syzkaller where KVM attempts to set the
> TSS.busy bit during LTR before checking that the new TSS.base is =
valid.
>=20
> Patch 2 fixes a bug found by inspection (when reading the APM to =
verify
> the non-canonical logic is correct) where KVM doesn't provide the =
correct
> error code if the new TSS.base is non-canonical.
>=20
> Patch 3 makes the "dangling userspace I/O" WARN_ON two separate =
WARN_ON_ONCE
> so that a KVM bug doesn't spam the kernel log (keeping the WARN is =
desirable
> specifically to detect these types of bugs).

Hi Sean,

If/when you find that I screwed up, would you be kind enough to cc me?

Very likely I won=E2=80=99t be able to assist too much in fixing the =
bugs under my
current affiliation, but it is always interesting to see the escapees of
Intel=E2=80=99s validation tools=E2=80=A6 ;-)

Only if you can.

Thanks,
Nadav

[ p.s. - please use my gmail account for the matter ]

