Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236D428A5CE
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 07:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgJKF1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Oct 2020 01:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgJKF1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Oct 2020 01:27:11 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4203AC0613CE
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 22:27:11 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d24so14944901lfa.8
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 22:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=BXr6Qv9c19rLUAFC72iyMLSJkX8fR5TDPxOXRWfLo6E=;
        b=Q4SvkjVK4tQ4PInpkVuq++Gnpxwlgej6KTKzWEOs2Q/Bz2/HkypNARzSev4FwnVP91
         qlacBzHNmZpE6lnK34B4kESW5Bgo8Qh5lffptegokv0EIW3Mytcv2gkDS5JgA55zJ3ah
         CuY1x9F7KHQcvizo1n3VOBiK3yYITNXCbramrDdyaZO0nEp6rlanFgvlYNiUPFwr2lp6
         HDZWfqhe40I70EnKYievR5V8FQnpT6llQUZ9IHGPUJ99Mh52qhnCdLTelS7aKy2pqbdu
         vG+p5l4TAerErm39K8iivmD2yikm6/2Ud7ynZCt3rDmBllNwDQKGKD1FuiEKwXK07S5q
         EtMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BXr6Qv9c19rLUAFC72iyMLSJkX8fR5TDPxOXRWfLo6E=;
        b=CKOgdfSra6MYgfa0wJ74RCap7pihxG/R3Njz76p7piY88tua5PV2nre+v7gKofP88s
         uKy+Im5KBiuq8WpN9JSF4KN3XvaTO7DFcM1UclPPRUqoVD8VdlkyjifdRDwmY1Kw4izp
         wW5BI21yDKvxEHvoGNpoVj2fLt/kt+BPTDa1QGDCyu1xR28ZH3LBevA2HzR0xwkn1G1C
         B+WPEm8v8ovDmiSSfEYrUilCFNTIXXHJ7ANY0sn0oAj03h/qV7s/VQl+gnKBxFQmQxQG
         1C0klTHyPKTT6iYtS5DLqesmxctXrDUH9+/54KzMJWFJLbpDkFsuBDePJvyqZiS1NuLC
         bWsg==
X-Gm-Message-State: AOAM5314BJw0ZjCI4Uzm8bvGaR7KQGNj/ebO1ddOlSN2WzHNYbVi0FBM
        tMgsVtckJjezdD05WUpKSeSkN2UqidTCLHOsu9M=
X-Google-Smtp-Source: ABdhPJzcHgxI7SrbYA/0tXX/VBuvfcmF+piFzByAl92owvJcz6dDGixtHU8yfidTlw/Ft4RpewrEk3c/Ds5Ci2HeVeY=
X-Received: by 2002:ac2:554c:: with SMTP id l12mr775302lfk.35.1602394029527;
 Sat, 10 Oct 2020 22:27:09 -0700 (PDT)
MIME-Version: 1.0
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Sun, 11 Oct 2020 01:26:55 -0400
Message-ID: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
Subject: Why guest physical addresses are not the same as the corresponding
 host virtual addresses in QEMU/KVM? Thanks!
To:     qemu-devel@nongnu.org, mathieu.tarral@protonmail.com,
        stefanha@redhat.com, libvir-list@redhat.com, kvm@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi QEMU/KVM developers,

I am sorry if my email disturbs you. I did an experiment and found the
guest physical addresses (GPAs) are not the same as the corresponding
host virtual addresses (HVAs). I am curious about why; I think they
should be the same. I am very appreciated if you can give some
comments and suggestions about 1) why GPAs and HVAs are not the same
in the following experiment; 2) are there any better experiments to
look into the reasons? Any other comments/suggestions are also very
welcome. Thanks!

The experiment is like this: in a single vCPU VM, I ran a program
allocating and referencing lots of pages (e.g., 100*1024) and didn't
let the program terminate. Then, I checked the program's guest virtual
addresses (GVAs) and GPAs through parsing its pagemap and maps files
located at /proc/pid/pagemap and /proc/pid/maps, respectively. At
last, in the host OS, I checked the vCPU's pagemap and maps files to
find the program's HVAs and host physical addresses (HPAs); I actually
checked the new allocated physical pages in the host OS after the
program was executed in the guest OS.

With the above experiment, I found GPAs of the program are different
from its corresponding HVAs. BTW, Intel EPT and other related Intel
virtualization techniques were enabled.

Thanks,
Harry
