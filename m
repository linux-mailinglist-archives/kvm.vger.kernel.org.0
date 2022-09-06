Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B561D5AF878
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 01:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiIFXlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 19:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIFXlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 19:41:40 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B648086066
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 16:41:38 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-127d10b4f19so6322756fac.9
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 16:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date;
        bh=6DmgDWDVvhf2DsRZYCyyKP6t8ktOLccqH5dGRzjtswE=;
        b=E2y+2Cy6kiYmfX8zYVCDZ1UsQkH8Syz0qpwJUwkFGmPKnLZ7PRVndWlQjIR/EVByqu
         zXdukqrnNKT+H6ccKuIvArsr5a3iR6kWnbiHF8mT9uBqgbMr7CPHxzbVxf5TKq+UA2DM
         3wEQ3S7iQBStEYO7sU2LJv4/SrIqtm2FkiJqcTKAbgxZNV4EypkNv2LOoXPNUIR6HL8H
         HzZKBK82ZyP9gqdUaaxhO33fjWNug2p1lq4fFXjPmeWGGGn5KLR1p7kuNMTdV60tZfKU
         QIgVDgc7cN4hDkbJjxZgXxau6XJm+R01AmTAdbs1EffQoiUa8NlpgdRZvZNMDdQsLtgS
         go8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6DmgDWDVvhf2DsRZYCyyKP6t8ktOLccqH5dGRzjtswE=;
        b=GvswqQ31d2H8hl4HCD80OtA+WfmktrU9J8WWCdzXqH0ZlGFAsGRkK2MHPJ4kK+qUH8
         NE6FW9cF7uMQDPHc/7dnzOYDnod168R07BHgdKcO4kYWkO938MlyX16ZlpHGgAsgg6vL
         YZLZm8ZfmsN8M76d5M87wH0wrKIqtt07dGesQhXrIBZpt/hp3AGXfCPo4vKJ2JkBvHGF
         XQkgDHdOQoKjWEEV1wt3a4goIPXNMVzt7Iuvw8OS8Q24NZlGzt5xawnfkWq7qIEaZGJ2
         kxJUcxStgALVxJJiq6Xxojgkbw0obNqmBgXPN9F3ZjVvmGfSdLseoEfqrLFQZFz75fcc
         aPwA==
X-Gm-Message-State: ACgBeo3+rwim+w+ir4Y5mHfqK+6Dvd+rN84YoYLI09TGcZ3ism7vgYlw
        Z6W+JO17YrBHYi3Kwxl1FPF/DuIdH/lTSGkOHVghe+RXD6y5lg==
X-Google-Smtp-Source: AA6agR5SGxv30YYQOAa5ywaEUlB/8hZYbLT8cGc+lpacHxayCnKQw6rNLJUZFmgq0WtWUYpl36sp1U2D7Pwu2jf+VMg=
X-Received: by 2002:aca:170f:0:b0:343:171f:3596 with SMTP id
 j15-20020aca170f000000b00343171f3596mr360873oii.181.1662507697616; Tue, 06
 Sep 2022 16:41:37 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 6 Sep 2022 16:41:26 -0700
Message-ID: <CALMp9eT685aGv-kn8Yb4Xq7u=33kE27U1GHJ=0pqaKn2AcO7og@mail.gmail.com>
Subject: Intel's "virtualize IA32_SPEC_CTRL" VM-execution control
To:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This looks like a souped-up version of AMD's X86_FEATURE_V_SPEC_CTRL.
From https://www.intel.com/content/www/us/en/developer/articles/technical/s=
oftware-security-guidance/technical-documentation/branch-history-injection.=
html:

When =E2=80=9Cvirtualize IA32_SPEC_CTRL=E2=80=9D VM-execution control is en=
abled, the
processor supports virtualizing MSR writes and reads to
IA32_SPEC_CTRL. This VM-execution control is enabled when the tertiary
processor-based VM-execution control bit 7 is set and the tertiary
controls are enabled. The support for this VM-execution control is
enumerated by bit 7 of the IA32_VMX_PROCBASED_CTLS3 MSR (0x492).

Is anyone working on kvm support for this yet? (Intel?)
