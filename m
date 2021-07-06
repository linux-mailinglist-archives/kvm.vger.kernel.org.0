Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3D73BDCA3
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 20:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhGFSGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 14:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhGFSGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 14:06:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C348C061760
        for <kvm@vger.kernel.org>; Tue,  6 Jul 2021 11:03:54 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id t11-20020a056902124bb029055a821867baso87685442ybu.14
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 11:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CSaRFHpTxy16Ddo1NtyMtRRD0xvN/MydJKRi7zViX0I=;
        b=q69BIoXU+SrWy8FbEhW2A0qf6ejeMPY7TUGU0XoDxj9NVRoJiG9eXHoLmcXhmlZGsN
         GgC2ZFvL3tmHNuf+vgS33znaYv+kYh/1R4zCygSPXRrJKijML/1qKuc6++HSTMoX5mZ2
         WDzlJYlYYZLCd7VaCVDhN/nLnp85bJeXqOWz0UuZefD6hYaIxAe1InKADey8K/aY24PC
         8H0kiJkPvMLMBSEU5CvEFX0G4xSXBfUtzlV3WDtcEUAF2suI6KctxTw+UEchX6ULd96k
         egWw9aC7WEKyiYw0bt2Pke/KIu9uYX5fXblDPy3DIJwutmHdAFVIkyoGfCsvm0y2ZEta
         tq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CSaRFHpTxy16Ddo1NtyMtRRD0xvN/MydJKRi7zViX0I=;
        b=Ik4Jwwfl4+RHQPMKaQlfXJIfDle6Q7G+FhxLgdPgoWsJ8SwQ8M9FNSviry4d6bP8ml
         ATFNdI8L80nWGD0vwcQ4ZuSlsY0nWg+wdFS/47IGblFWGSDzLw3/+AFmlmtQsIJX4KTf
         7rhzeCI88xAL2lrzeIWQ6Znqgov9b5LLaY5t2Fgu8KhOowii8lJAaYUKTmVxWsG5gNEY
         gkTww/4nox9oW1ZBJ2fv5bRi4ePQKTuiojacUgQSSuJ7/z3uWIkVcc23E1wWowmH+682
         fEL280w4ZZ3KAfuuFxFNJdh4Vhl2Z0rkeuAMw/tIhCfivYGBxWgWL6qhKZNxtzK8xe1l
         LnVg==
X-Gm-Message-State: AOAM5336BnqoHjjiM2vqzs8gES4Bfu2WnC+f6EhnhKC39SQmold85xaz
        39mGsjSfiIfSjTYxhjLz1E/3RmWeeLJMtYsSzzKaxGDOeL2AlNqf8MYugkDTEqUbHmwQNDJwWX5
        h/9hX1ohV0dNeVqbb66xaQ7tuwVhUB0SomUWAn08SjPat2Sgu0ucP769BUf9oxPlxIWuPtXw=
X-Google-Smtp-Source: ABdhPJzf909G0NSuD7V5yhqjbYX1/5qucOOuJ/OQjQJGjJ3ggT+v9Kt8R+xnTL2szxaAU9+FOR53NJgYI2uSfCF8jg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:cf0f:: with SMTP id
 f15mr19890068ybg.229.1625594633413; Tue, 06 Jul 2021 11:03:53 -0700 (PDT)
Date:   Tue,  6 Jul 2021 18:03:46 +0000
Message-Id: <20210706180350.2838127-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v1 0/4] Linear and Logarithmic histogram statistics
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset adds linear and logarithmic histogram stats support and extend
some halt polling stats with histogram.
Histogram stats is very useful when we need to know the distribution of some
latencies or any other stuff like used memory size, huge page size, etc.
Below is a snapshot for three logarithmic histogram stats added in this
patchset. halt_poll_success_hist shows the distribution of wait time before a
success polling. halt_poll_fail_hist shows the distribution of wait time before
a fail polling. halt_wait_hist shows the distribution of wait time of a VCPU
spending on wait after it is halted. The halt polling parameters is halt_poll_ns
= 500000, halt_poll_ns_grow = 2, halt_poll_ns_grow_start = 10000,
halt_poll_ns_shrink = 2;
From the snapshot, not only we can get an intuitive overview of those latencies,
but also we can tune the polling parameters based on this; For example, it shows
that about 80% of successful polling is less than 132000 nanoseconds from
halt_poll_success_hist, then it might be a good option to set halt_poll_ns as
132000 instead of 500000.

halt_poll_success_hist:
Range		Bucket Value	Percent     Cumulative Percent
[0, 1)		 0		 0.000%      0.000%
[1, 2)		 0		 0.000%      0.000%
[2, 4)		 0		 0.000%      0.000%
[4, 8)		 0		 0.000%      0.000%
[8, 16)		 0		 0.000%      0.000%
[16, 32)	 0		 0.000%      0.000%
[32, 64)	 0		 0.000%      0.000%
[64, 128)	 0		 0.000%      0.000%
[128, 256)	 3		 0.093%      0.093%
[256, 512)	 21		 0.650%      0.743%
[512, 1024)	 43		 1.330%      2.073%
[1024, 2048)	 279		 8.632%      10.705%
[2048, 4096)	 253		 7.828%      18.533%
[4096, 8192)	 595		 18.410%     36.943%
[8192, 16384)	 274		 8.478%      45.421%
[16384, 32768)	 351		 10.860%     56.281%
[32768, 65536)	 343		 10.613%     66.894%
[65536, 131072)  421		 13.026%     79.920%
[131072, 262144) 459		 14.202%     94.121%
[262144, 524288) 190		 5.879%      100.000%


halt_poll_fail_hist:
Range		Bucket Value	Percent     Cumulative Percent
[0, 1)		 0		 0.000%      0.000%
[1, 2)		 0		 0.000%      0.000%
[2, 4)		 0		 0.000%      0.000%
[4, 8)		 0		 0.000%      0.000%
[8, 16)		 0		 0.000%      0.000%
[16, 32)	 0		 0.000%      0.000%
[32, 64)	 0		 0.000%      0.000%
[64, 128)	 21		 0.529%      0.529%
[128, 256)	 398		 10.020%     10.549%
[256, 512)	 613		 15.433%     25.982%
[512, 1024)	 437		 11.002%     36.984%
[1024, 2048)	 264		 6.647%      43.630%
[2048, 4096)	 302		 7.603%      51.234%
[4096, 8192)	 350		 8.812%      60.045%
[8192, 16384)	 488		 12.286%     72.331%
[16384, 32768)	 258		 6.495%      78.827%
[32768, 65536)	 227		 5.715%      84.542%
[65536, 131072)  232		 5.841%      90.383%
[131072, 262144) 246		 6.193%      96.576%
[262144, 524288) 136		 3.424%      100.000%


halt_wait_hist:
Range			    Bucket Value    Percent	Cumulative Percent
[0, 1)			     0		     0.000%	 0.000%
[1, 2)			     0		     0.000%	 0.000%
[2, 4)			     0		     0.000%	 0.000%
[4, 8)			     0		     0.000%	 0.000%
[8, 16)			     0		     0.000%	 0.000%
[16, 32)		     0		     0.000%	 0.000%
[32, 64)		     0		     0.000%	 0.000%
[64, 128)		     0		     0.000%	 0.000%
[128, 256)		     0		     0.000%	 0.000%
[256, 512)		     0		     0.000%	 0.000%
[512, 1024)		     0		     0.000%	 0.000%
[1024, 2048)		     0		     0.000%	 0.000%
[2048, 4096)		     7		     0.127%	 0.127%
[4096, 8192)		     37		     0.671%	 0.798%
[8192, 16384)		     69		     1.251%	 2.049%
[16384, 32768)		     94		     1.704%	 3.753%
[32768, 65536)		     150	     2.719%	 6.472%
[65536, 131072)		     233	     4.224%	 10.696%
[131072, 262144)	     276	     5.004%	 15.700%
[262144, 524288)	     236	     4.278%	 19.978%
[524288, 1.04858e+06)	     176	     3.191%	 23.169%
[1.04858e+06, 2.09715e+06)   94		     16.207%	 39.376%
[2.09715e+06, 4.1943e+06)    1667	     30.221%	 69.598%
[4.1943e+06, 8.38861e+06)    825	     14.956%	 84.554%
[8.38861e+06, 1.67772e+07)   111	     2.012%	 86.566%
[1.67772e+07, 3.35544e+07)   76		     1.378%	 87.944%
[3.35544e+07, 6.71089e+07)   65		     1.178%	 89.123%
[6.71089e+07, 1.34218e+08)   161	     2.919%	 92.041%
[1.34218e+08, 2.68435e+08)   250	     4.532%	 96.574%
[2.68435e+08, 5.36871e+08)   188	     3.408%	 99.982%
[5.36871e+08, 1.07374e+09)   1		     0.018%	 100.000%

---

Jing Zhang (4):
  KVM: stats: Support linear and logarithmic histogram statistics
  KVM: stats: Update doc for histogram statistics
  KVM: selftests: Add checks for histogram stats parameters
  KVM: stats: Add halt polling related histogram stats

 Documentation/virt/kvm/api.rst                | 36 ++++++++++-
 arch/arm64/kvm/guest.c                        |  4 --
 arch/mips/kvm/mips.c                          |  4 --
 arch/powerpc/include/asm/kvm_host.h           |  1 -
 arch/powerpc/kvm/book3s.c                     |  5 --
 arch/powerpc/kvm/book3s_hv.c                  | 20 +++++-
 arch/powerpc/kvm/booke.c                      |  5 --
 arch/s390/kvm/kvm-s390.c                      |  4 --
 arch/x86/kvm/x86.c                            |  4 --
 include/linux/kvm_host.h                      | 62 ++++++++++++++-----
 include/linux/kvm_types.h                     | 20 ++++++
 include/uapi/linux/kvm.h                      | 11 +++-
 .../selftests/kvm/kvm_binary_stats_test.c     | 17 +++++
 virt/kvm/binary_stats.c                       | 36 +++++++++++
 virt/kvm/kvm_main.c                           | 19 ++++++
 15 files changed, 196 insertions(+), 52 deletions(-)


base-commit: 7caa04b36f204a01dac65582b71d26d190a1e022
-- 
2.32.0.93.g670b81a890-goog

