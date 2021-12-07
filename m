Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A461546C3E2
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 20:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbhLGTsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 14:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236460AbhLGTsO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 14:48:14 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1938C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 11:44:43 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id x32so317876ybi.12
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 11:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=pv56N59OYh3OWyRpYvYAFVCTCVe97urRbwQLcjCWj1U=;
        b=HloGL6JK5hAt0vcc1u0lemz2erhjdaHNJdEDFUtOO1r9b3Fd1g1uncPYx4L9yAk829
         p49NdCiCOv6v33DAPWT5QTr28bY6lWpY6OWUDEk/OJW8ZMHuElDjOnEj0AA4h57lseEB
         Giq0ltwks9WkVarYX3Lvu5huzPoDv8bX7eNoIWE9adAEehu/K9tAh2cL9h9QsGGOBVdN
         7QbEMvgHF02qaNkfrwK5GJJvBHtFgz+KvtyesXLmOSxUtUpNmBgh/2lQJDsV7sahMPhe
         bI5Vcw80c1jVveI582QR/DGF+5+EvLgkd5cC1AhT8bLq7haUAnxyyShaFNH7CiUeUd60
         DuXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=pv56N59OYh3OWyRpYvYAFVCTCVe97urRbwQLcjCWj1U=;
        b=CqanYooe2nnwrucMZ8bwJ/8lLRkHPizEPUGiKS1JQETeAFcQ/j9eclQhQ/Ru4geiB1
         BVCmtbQGM4T9k1U/Kzdnz363O/3Y/HMyd9nWiwY0zo10cO5xj9Efil32FclqEjRfpArA
         9tHsJLxS/TaaWWkSXz52BxFJQdLlAIKOPxC/bHeduc6Nt7LegaEsTiMQdCGl9wtLNnA5
         bN2BVpaicWQk9+WkgQJ+JR+nlN+eQQ2VZ13ch3cWhoWQytowkVxe9Ne28VUaMnFjGeyx
         d457loz1TLE8RaYH+YW+4XEZfre67d75ynMIJiud4UknXaK9DhlPWxvb8S9usOvHVPnU
         wLPA==
X-Gm-Message-State: AOAM531pkJOmk7K3Cdxo+AM6vgG8GMDwF4fardLwODtVIJq3EN+H87H3
        F3TkdwiSCGltabf2fAEoj1dTnuMHdnQK/7CkO6ZzmxlOSCjOnZDT
X-Google-Smtp-Source: ABdhPJxyCd41kLJfg21VXYAm0CDv6SDKVQ/tZgKVJkeTQ49n2d6/JcQ5LAL0yZR0dkwSr5PYS5NojP3hhfHR5fA7/RY=
X-Received: by 2002:a25:e543:: with SMTP id c64mr49019799ybh.239.1638906282813;
 Tue, 07 Dec 2021 11:44:42 -0800 (PST)
MIME-Version: 1.0
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 7 Dec 2021 14:44:27 -0500
Message-ID: <CAJCQCtSx_OFkN1csWGQ2-pP1jLgziwr0oXoMMb4q8Y=UYPGqAg@mail.gmail.com>
Subject: dozens of qemu/kvm VMs getting into stuck states since kernel ~5.13
To:     kvm@vger.kernel.org
Cc:     qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cc: qemu-devel

Hi,

I'm trying to help progress a very troublesome and so far elusive bug
we're seeing in Fedora infrastructure. When running dozens of qemu-kvm
VMs simultaneously, eventually they become unresponsive, as well as
new processes as we try to extract information from the host about
what's gone wrong.

Systems (Fedora openQA worker hosts) on kernel 5.12.12+ wind up in a
state where forking does not work correctly, breaking most things
https://bugzilla.redhat.com/show_bug.cgi?id=2009585

In subsequent testing, we used newer kernels with lockdep and other
debug stuff enabled, and managed to capture a hung task with a bunch
of locks listed, including kvm and qemu processes. But I can't parse
it.

5.15-rc7
https://bugzilla-attachments.redhat.com/attachment.cgi?id=1840941
5.15+
https://bugzilla-attachments.redhat.com/attachment.cgi?id=1840939

If anyone can take a glance at those kernel messages, and/or give
hints how we can extract more information for debugging, it'd be
appreciated. Maybe all of that is normal and the actual problem isn't
in any of these traces.

Thanks,

--
Chris Murphy
