Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B209F3D110C
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 16:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbhGUNjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 09:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbhGUNjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 09:39:53 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478B1C061575
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 07:20:30 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id r17so1977179qtp.5
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 07:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=NIayiqzujDc7AZWJFwZQRXdbiOz5U1FB/LPA9woxhDs=;
        b=ecyIj+tOWl/XowrA+prU7DQmM65e0AMJJe5kDjrrYNMS9kSFKH0424xFeA+XCCluuS
         gHcM6KJjTgJDnpI8j4c+ZYB4Jm1bRSjIndS0AjfQDgYgsmbABX2FtLHSYK6oWT6tgVEe
         JPPOjrv/GjHa9fMzM3HxfM8c2XPbfFOSC7AnyjTfCdFtULHdsJ5e9tBqrciRl14B+sEE
         hTudqc67PHtzvNH/+lZrBQphDctXE3yhRUHpL/B7NdUl3jpw3h3Ico13NgP3i6Dpn9lc
         EyFej1AN/dp7oyIvWQebfZtyGoZ1M0/uWaLHIFFoAEPG80LWVJMo7kiZcGnJhU21JVza
         pszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NIayiqzujDc7AZWJFwZQRXdbiOz5U1FB/LPA9woxhDs=;
        b=fs1O5cHpJ1qpPYoBuaJh3fVmIYabpqn4W6hhc8ffjZzQkxeyPw7Q/ixX8t7ZJRl0pY
         g4N7Rx4UsALUMTRsNGIilUkMRWmsO06m13bXi45F0M62OSJ0ALGwCyPc/kVpe3QTowYM
         0Sxkc9ga+VFscwFTi1bHa6a/L66ZvWKGqjhkDV7vzzscEuYu1SMXmP4uBj4gGsn3+oE4
         IESLSWzV7uIyLW0VvD/czqc7kTRXFtSQe37QrF0207mR1y6J6+/tHNbrJ5uHTe2voT6S
         q0Vcsrd8I1Cln4QLwY/BIG3klICKh6I4na9bPvnHB36zysQdKIWhQLWrWwZKhEU5yE0Q
         t36w==
X-Gm-Message-State: AOAM53012M2CcmSvd2amKR/SA7MFb4sJJ2YYy7aCtIVmFM2SKJ87z+1w
        wr7KpVdIk7HYlIf8UmfYj/wHwM9hgRA4uAvD4xWKpXSO6LXMREdNVBY=
X-Google-Smtp-Source: ABdhPJwmsmcX/E20+Dv+9yYFKa3YK57t0aDZhkBQfgj3Y5cZoo6C46PY6CfI9OcTJAf6u1TZqojx/QjahSszYR+EiO8=
X-Received: by 2002:ac8:4e44:: with SMTP id e4mr6112333qtw.252.1626877229351;
 Wed, 21 Jul 2021 07:20:29 -0700 (PDT)
MIME-Version: 1.0
From:   KVM Man <kvmman602@gmail.com>
Date:   Wed, 21 Jul 2021 09:20:18 -0500
Message-ID: <CAN-39qaEWAcKxB6cw64tD14VCDiVHZ9zj43a=j475j+FWVWJeg@mail.gmail.com>
Subject: kvm_read_guest_virt returning unexpected data
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I'm making changes to KVM on linux 5.11.4 while using qemu 5.0.0 and
having issues using kvm_read_guest_virt successfully with an x86_64 VM
guest.

I call kvm_read_guest_virt in a VM exit handler, and it returns data
that's unexpected, as compared to what I see with a kernel debugger
attached to the guest. The function returns a successful error code
(X86EMUL_CONTINUE), and I've verified that virtual to physical address
translation is working properly when kvm_read_guest_virt_helper calls
vcpu->arch.walk_mmu->gva_to_gpa.

Are there any reasons that this function would not work as expected?

Thanks.
