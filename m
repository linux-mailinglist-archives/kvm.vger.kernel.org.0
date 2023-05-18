Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4508F708486
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 17:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjERPC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 11:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjERPCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 11:02:53 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774521B6
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 08:02:25 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-561f6e63decso11218277b3.1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 08:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684422073; x=1687014073;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=COEcCFWgCbplE1MtlqGXZIriKuoSjyaM69XcEc43hFs=;
        b=V4t31ISM6ddijUWJrMbzNdsub50JqaWK0bG2NFCCpmTFivM5lhHY9OWHzMC0C/HCMT
         Ja37GZLQK+L91ygKXO4cJFqPAoIr3jFi1MTJXKDiS/EGFspP9Frt+o9dDL8Nt0rXY7Ua
         Ausy7uWZTyz5+fN5nyBn1wmlxoKRTBGWLWJlig0yVzR79vIUv/RMFOFcXJiDrmQZoa6d
         HQy+bLYpiwmqRs3B2j7jXF2JXzKsYXuDfjdrnYJNbxh/Km+HRilenhnoRg1cmJFynjeP
         xxeuMJ42jYGmeu3M3IZ8qsQ+6U1GzhFBwKRh08c9gxKDFBu4fbkUTLHLge/Lo83UhALz
         gvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684422073; x=1687014073;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=COEcCFWgCbplE1MtlqGXZIriKuoSjyaM69XcEc43hFs=;
        b=RVn4ECi+ITOTNHrWC4Eid3gwaZDc6U9M/GDQFBBuw/QIgWMYodH0EV7R0VWHkf3XBn
         N29sJBCLmRuBAxGcmJ32DlZgAxBDuPcSBtxINm0q718zMV8RxULYhc8vuVJtn+Eg6aXF
         BCURxAhdrP1Yo6v28tajSXaZnVcU9STHif1u/6sOYN5E1vGFGXYc/gNjoIHMbIEMD+gq
         uZoVGp3UhwZsne5P6HqHff1ytK4czuW6xyOmgvAjps/FZwe5FXycD2eIOXRe70yR7Kv0
         Vylbh/PCAsWUhDQPV2aSjIVbaViivA4+gsDvUQQyrLZ1R+pqdtFaacSN4dkMEHDkbA8/
         AEGA==
X-Gm-Message-State: AC+VfDxZFBJRjXRX2teWTM3vOLXeazpliDHKy8tpuH7vpqTVm+EE84I8
        50p1K3Qfo25TC+YBWJCzbKpbkSiR+dA=
X-Google-Smtp-Source: ACHHUZ7IX6Wx0LSBkpzQqjr+OXaJS2pKyVuTTzwb3z0a97s/un34w9qdMEO5QA63WIOBuZvYpFhahx6OOmI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e50e:0:b0:561:3149:d684 with SMTP id
 s14-20020a81e50e000000b005613149d684mr1180910ywl.10.1684422072950; Thu, 18
 May 2023 08:01:12 -0700 (PDT)
Date:   Thu, 18 May 2023 08:01:11 -0700
In-Reply-To: <babafe0f-3154-fb0a-346f-2bbea48a366e@gmail.com>
Mime-Version: 1.0
References: <71288f04-546c-9af3-e29a-eb3c44e0d948@gmail.com> <babafe0f-3154-fb0a-346f-2bbea48a366e@gmail.com>
Message-ID: <ZGY9twXBuTWpliAB@google.com>
Subject: Re: Fwd: Persistent rt_sigreturn segfaults on KVM VMs after upgrade
 to 5.15
From:   Sean Christopherson <seanjc@google.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Theodor Milkov <tm@del.bg>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023, Bagas Sanjaya wrote:
> On 5/18/23 20:57, Bagas Sanjaya wrote:
> > Hi,
> > 
> > I notice a regression report on Bugzilla [1]. Quoting from it:
> > 
> >> I'm experiencing sporadic but persistent segmentation faults on the KVM
> >> VMs I manage. These faults began appearing after upgrading from Linux
> >> Kernel 4.x to 5.15.59. I further upgraded to 5.15.91 and transitioned the
> >> userspace from Debian 10 (buster) to Debian 11 (bullseye), yet the issues
> >> persist. Notably, the libc has also changed in the process as seen in the
> >> following error logs:

Was the host or guest kernel upgraded?  If the guest kernel was upgraded, it's
unlikely, though still possible, that this is a KVM bug.

> >> post.sh[21952]: bad frame in rt_sigreturn frame:000072db65961bb8
> >> ip:6c25f82a9a5d sp:72db65962168 orax:ffffffffffffffff in
> >> libc-2.28.so[6c25f8294000+147000]
> >>
> >> cron[7626]: bad frame in rt_sigreturn frame:000073ddebeb6ff8
> >> ip:72ad9f44d594 sp:73ddebeb75a8 orax:ffffffffffffffff in
> >> libc-2.28.so[72ad9f3a9000+147000]
> >>
> >> cron[64687]: bad frame in rt_sigreturn frame:000073265764b038
> >> ip:67c7b5a0f14a sp:73265764b5f0 orax:ffffffffffffffff in
> >> libc-2.31.so[67c7b596f000+159000]
> >>
> >> worker.py[54568]: bad frame in rt_sigreturn frame:000078eef6591cf8
> >> ip:6c9f9b2a604e sp:78eef6592298 orax:ffffffffffffffff in
> >> libpthread-2.31.so[6c9f9b29a000+10000]
> >>
> >>
> >> The segmentation faults occur 1-3 times daily across approximately 1000
> >> VMs running on hundreds of (supermicro, intel cpu) bare-metal servers.
> >> Currently, there's no reliable way for me to reproduce the issue. I
> >> initially considered this bug -
> >> https://www.spinics.net/lists/linux-tip-commits/msg61293.html - as a
> >> possible cause, but judging from the comments it likely isn't.
> >>
> >> The best approximation to a reproducer I have is a Python script that
> >> initiates several child processes and continuously sends them a sigusr1
> >> signal. Still, it takes a few hours to trigger the issue even when running
> >> this script on several hundred VMs.
> >>
> >> Switching to the 6.x kernel isn't immediately feasible as these are
> >> production systems with specific requirements. The transition is planned
> >> but will likely take several months.
> >>
> >> I'm looking for suggestions on how to more reliably reproduce this
> >> problem. Then I could try different old and new kernels and maybe narrow
> >> it down.
> > 
> > See bugzilla for the full thread.
> > 
> > Anyway, I'm adding it to regzbot:
> > 
> > #regzbot introduced: v4.19..v5.15 https://bugzilla.kernel.org/show_bug.cgi?id=217457
> > #regzbot title: bad frame in rt_sigreturn (libc-related?) regression after 5.15 upgrade
> > 
> 
> Oops, I forgot to add the reporter:
> 
> #regzbot from: Theodor Milkov <tm@del.bg>
> 
> Sorry for inconvenience.
> 
> -- 
> An old man doll... just what I always wanted! - Clara
> 
