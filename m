Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35765388FB6
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 16:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346748AbhESOB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 10:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbhESOBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 10:01:55 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877D2C06175F
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 07:00:34 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id b12so8535188ljp.1
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 07:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=cH5U9Az7eYofu3eA4ftQUffWK1rQQwjbWurlsdJWGcs=;
        b=PsWmCiUmc0h6jhfs8n0zs3WyblSVZ2kUwHfBnc2GdYbUF8tQ/EAduwiPqpCBvvWuAV
         7EBu6Di5txh7+u0aguiGdClwNmaz4jJmdsAPd5jkwP/ynfSUqEmpdorkx0uXGEliS0HL
         V4gvbj4hLt0shXfOLVUVx4u6jYkqiFJNktSpgbI/rNy4Z/6+Vh8HXBTAA5d5m7MP0C9T
         bc1cbB8SNyiS9coO2Yy7SqhmCa1y/rpQmJMZ1h48CrC/7tzF6K118RVnOuTM0JaW0i8w
         57W7aksfsjkAzQ7C0mpUOtbLcHw0FtCEdK5DKFQu2GCYHE5cMoB0VZ4vLuYr3BsKj70T
         e9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=cH5U9Az7eYofu3eA4ftQUffWK1rQQwjbWurlsdJWGcs=;
        b=Co07wj257Bx2WmWR6uBKY10Dvb3uMla1plRw+K9fd1PkFDBGfndRphD9xKeczji8Ob
         vqzZwkXvaAv1BsQ251986+SO6AG/C9a68Cji6cHNt39GImU+l7Rd5/IQnixw6Y9GJJzV
         ppP6dNuU8yYaapEStZyjrNpufQRyI3BO54p+TTVIxIPeORYZnC9vYgP4xzw3yNlSPU2r
         GSgyZM1Z9TxREMu5orVqaMJBEPCQcAHzNt1E1ur5HX1LyyOtg33P0h5o3m/KCe0NGvJW
         tKoISYRDVeyn6yPTJaiQ6012Em99i8GtwhnPQXPrqVmQE5wpQlPNFt2HY8rFvNipz/GT
         ihVg==
X-Gm-Message-State: AOAM533p5u24Y+LEo93MVgVGz6UdCAMuC8GtXHLfC8aE4TPwj8VQChBg
        jutxrwWdz9QaJVvGTxM5a/u+gQJ6PvFY3eoIH2j76eOkIN0osw==
X-Google-Smtp-Source: ABdhPJyt1aYpq0/SyLXL0dDpoeoKQD/5+WHAgE9KRT3tffH8yD1OazmgdUfzxGyYtnxIbTs1l9olrGfYGX8yIUMEGYw=
X-Received: by 2002:a2e:8e26:: with SMTP id r6mr5780477ljk.472.1621432832689;
 Wed, 19 May 2021 07:00:32 -0700 (PDT)
MIME-Version: 1.0
From:   Liang Li <liliang324@gmail.com>
Date:   Wed, 19 May 2021 22:00:20 +0800
Message-ID: <CA+2MQi-_06J1cmLhKAmV1vkPEnvDx6+bOnK06OciYmdymaNruw@mail.gmail.com>
Subject: About the performance of hyper-v
To:     vkuznets@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Tianyu.Lan@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[resend for missing cc]

Hi Vitaly,

I found a case that the virtualization overhead was almost doubled
when turning on Hper-v related features compared to that without any
no hyper-v feature.  It happens when running a 3D game in windows
guest in qemu kvm environment.

By investigation, I found there are a lot of IPIs triggered by guest,
when turning on the hyer-v related features including stimer, for the
apicv is turned off, at least two vm exits are needed for processing a
single IPI.


perf stat will show something like below [recorded for 5 seconds]

---------

Analyze events for all VMs, all VCPUs:
             VM-EXIT    Samples  Samples%     Time%    Min Time    Max
Time         Avg time
  EXTERNAL_INTERRUPT     471831    59.89%    68.58%      0.64us
65.42us      2.34us ( +-   0.11% )
           MSR_WRITE     238932    30.33%    23.07%      0.48us
41.05us      1.56us ( +-   0.14% )

Total Samples:787803, Total events handled time:1611193.84us.

I tried turning off hyper-v for the same workload and repeat the test,
the overall virtualization overhead reduced by about of 50%:

-------

Analyze events for all VMs, all VCPUs:

             VM-EXIT    Samples  Samples%     Time%    Min Time    Max
Time         Avg time
          APIC_WRITE     255152    74.43%    50.72%      0.49us
50.01us      1.42us ( +-   0.14% )
       EPT_MISCONFIG      39967    11.66%    40.58%      1.55us
686.05us      7.27us ( +-   0.43% )
           DR_ACCESS      35003    10.21%     4.64%      0.32us
40.03us      0.95us ( +-   0.32% )
  EXTERNAL_INTERRUPT       6622     1.93%     2.08%      0.70us
57.38us      2.25us ( +-   1.42% )

Total Samples:342788, Total events handled time:715695.62us.

For this scenario,  hyper-v works really bad.  stimer works better
than hpet, but on the other hand, it relies on SynIC which has
negative effects for IPI intensive workloads.
Do you have any plans for improvement?


Thanks!
Liang
