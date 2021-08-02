Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0DD3DDE14
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhHBQ4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhHBQ4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:56:48 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B5EC061760
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:56:37 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id c5-20020a05620a2005b02903b8d1e253a9so13399204qka.11
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5Z4bZj5paPSkp4gwqawduLyKtqagQ8T50jVQFMFNZX4=;
        b=FVjE3L7/+lsSi2HksgsyNy/qi/XvmL/1Vw4CYJ7OUMcqHgF96eJ86XSCD4YTx9KohZ
         LfnZfm9zuI3XIyNUa/kXCPlw/HjWl6f0/89d1IMqwaZFFrysyBmXxO8WwkAbh+CUbjl/
         37dMGZlUMcd58E1gxUkSJItGsXruWlairgc9eLnnGKp9rxu5BSxzE1DkVoikvAGibtpM
         UqSdID9vvnVpZ/s3aOdjsnq9ChBughMPv5yMYr/cS56W0OMulqhqoOPG99KrNmQiXwRz
         F6rvvXDtn3U4D7NLnnXboT6U6fswCbN7NtGfwF2MzWizoobQ4PW+o/sd8wGO/U0JpMx/
         6HLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5Z4bZj5paPSkp4gwqawduLyKtqagQ8T50jVQFMFNZX4=;
        b=f/UzLZzQ/JkD4PNBpn+rFjGyrNduyV9VaP8c9UENi371g36xV28lncjkVKuHsBMFbm
         lP2QgACfFIqx1O25+5xDRsw5HfOBgPMGTzcYKQmA/k3QlnFwPCux/IS2wdTvZ5dhHzEG
         bJKCwljyOwUElX35VAiuSgqEmUwnulrn2ldCw0SSlyUCD0DKjCMhATIvlJz2UeXEuTwu
         zJWOTqe9GlHRh8ocJ/3eUT6r5NWdM/W5HqDaihe6eARFT+zsd0qHFJsHtkxBcXr9HNWB
         uY3+MRBZWTaQIRjy84MtlXZJ8ixY7i7BLUeY7n0JUVDHOLoG+G42glufy6Sd0DrXdf8e
         xO2g==
X-Gm-Message-State: AOAM533+jhUPNphDkYTTRiaxRX56BgCFKwwtS8cfOII3ADpd1BKRTbsC
        9BNY3qOdUnFZlfKsHvTc1YoSDCZe6Hmx744aEzR9DGi2cQ1ADwHfTjOmWZFQOpgPHOYQtby4jjx
        zQ8xjnxCHzgpY4BovDxtVwKFCfv63aeOzMlzGPFJaLlGtAk87m1D9UmWB9db9E4wdxvIeUXQ=
X-Google-Smtp-Source: ABdhPJwcHMYUcemzn9GJzKi/qJ6Q3lCevKa09kbHridtMOa3iYdchTcbci5ukgq4UGPoxL4REkMH0g6IYFU4z5gY8g==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6214:8c6:: with SMTP id
 da6mr9705685qvb.18.1627923396953; Mon, 02 Aug 2021 09:56:36 -0700 (PDT)
Date:   Mon,  2 Aug 2021 16:56:28 +0000
Message-Id: <20210802165633.1866976-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 0/5] Linear and Logarithmic histogram statistics
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

* v2 -> v3
  - Rebase to kvm/queue, commit 8ad5e63649ff
    (KVM: Don't take mmu_lock for range invalidation unless necessary)
  - Specify inline explicitly for histogram stats update functions
  - Use array_index_nospec to clamp the index to histogram array size
  - Remove constant macros for histogram array size and bucket size
  - Addressed other comments from Paolo.

* v1 -> v2
  - Rebase to kvm/queue, commit 1889228d80fe
    (KVM: selftests: smm_test: Test SMM enter from L2)
  - Break some changes to separate commits
  - Fix u64 division issue Reported-by: kernel test robot <lkp@intel.com>
  - Address a bunch of comments by David Matlack <dmatlack@google.com>

[1] https://lore.kernel.org/kvm/20210706180350.2838127-1-jingzhangos@google.com
[2] https://lore.kernel.org/kvm/20210714223033.742261-1-jingzhangos@google.com

---

Jing Zhang (5):
  KVM: stats: Support linear and logarithmic histogram statistics
  KVM: stats: Update doc for histogram statistics
  KVM: selftests: Add checks for histogram stats bucket_size field
  KVM: stats: Add halt_wait_ns stats for all architectures
  KVM: stats: Add halt polling related histogram stats

 Documentation/virt/kvm/api.rst                | 28 ++++++--
 arch/arm64/kvm/guest.c                        |  4 --
 arch/mips/kvm/mips.c                          |  4 --
 arch/powerpc/include/asm/kvm_host.h           |  1 -
 arch/powerpc/kvm/book3s.c                     |  5 --
 arch/powerpc/kvm/book3s_hv.c                  | 18 ++++-
 arch/powerpc/kvm/booke.c                      |  5 --
 arch/s390/kvm/kvm-s390.c                      |  4 --
 arch/x86/kvm/x86.c                            |  4 --
 include/linux/kvm_host.h                      | 67 ++++++++++++++-----
 include/linux/kvm_types.h                     |  6 ++
 include/uapi/linux/kvm.h                      | 11 +--
 .../selftests/kvm/kvm_binary_stats_test.c     | 12 ++++
 virt/kvm/binary_stats.c                       | 34 ++++++++++
 virt/kvm/kvm_main.c                           | 16 +++++
 15 files changed, 165 insertions(+), 54 deletions(-)


base-commit: 8ad5e63649ffaa9207b8fde932f3bd59a72c4c94
-- 
2.32.0.554.ge1b32706d8-goog

