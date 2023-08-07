Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBEE771AC3
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 08:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjHGGvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 02:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjHGGvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 02:51:45 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FF481B5;
        Sun,  6 Aug 2023 23:51:41 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxHOt6lNBk49wRAA--.35082S3;
        Mon, 07 Aug 2023 14:51:38 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxJ8x5lNBkwspMAA--.23544S2;
        Mon, 07 Aug 2023 14:51:37 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Cc:     Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn
Subject: [PATCH v2 0/4] KVM: selftests: Add LoongArch support
Date:   Mon,  7 Aug 2023 14:51:33 +0800
Message-Id: <20230807065137.3408970-1-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxJ8x5lNBkwspMAA--.23544S2
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series base on the Linux LoongArch KVM patch:
Based-on: <20230803022138.2736430-1-zhaotianrui@loongson.cn>

We add LoongArch support into KVM selftests and there are some KVM
test cases we have passed:
  kvm_create_max_vcpus
  demand_paging_test
  kvm_page_table_test
  set_memory_region_test
  memslot_modification_stress_test
  memslot_perf_test
  kvm_binary_stats_test

The test results:
1..7
selftests: kvm: kvm_create_max_vcpus
  KVM_CAP_MAX_VCPU_ID: 256
  KVM_CAP_MAX_VCPUS: 256
  Testing creating 256 vCPUs, with IDs 0...255.
  ok 1 selftests: kvm: kvm_create_max_vcpus

selftests: kvm: demand_paging_test
  Testing guest mode: PA-bits:36,  VA-bits:47, 16K pages
  guest physical test memory: [0xfbfffc000, 0xfffffc000)
  Finished creating vCPUs and starting uffd threads
  Started all vCPUs
  All vCPU threads joined
  Total guest execution time: 0.787727423s
  Overall demand paging rate: 83196.291111 pgs/sec
  ok 2 selftests: kvm: demand_paging_test

selftests: kvm: kvm_page_table_test
  Testing guest mode: PA-bits:36,  VA-bits:47, 16K pages
  Testing memory backing src type: anonymous
  Testing memory backing src granularity: 0x4000
  Testing memory size(aligned): 0x40000000
  Guest physical test memory offset: 0xfbfffc000
  Host  virtual  test memory offset: 0xffb011c000
  Number of testing vCPUs: 1
  Started all vCPUs successfully
  KVM_CREATE_MAPPINGS: total execution time: -3.-672213074s
  KVM_UPDATE_MAPPINGS: total execution time: -4.-381650744s
  KVM_ADJUST_MAPPINGS: total execution time: -4.-434860241s
  ok 3 selftests: kvm: kvm_page_table_test

selftests: kvm: set_memory_region_test
  Allowed number of memory slots: 256
  Adding slots 0..255, each memory region with 2048K size
  ok 4 selftests: kvm: set_memory_region_test

selftests: kvm: memslot_modification_stress_test
  Testing guest mode: PA-bits:36,  VA-bits:47, 16K pages
  guest physical test memory: [0xfbfffc000, 0xfffffc000)
  Finished creating vCPUs
  Started all vCPUs
  All vCPU threads joined
  ok 5 selftests: kvm: memslot_modification_stress_test

selftests: kvm: memslot_perf_test
  Testing map performance with 1 runs, 5 seconds each
  Test took 0.003797735s for slot setup + 5.012294023s all iterations
  Done 369 iterations, avg 0.013583452s each
  Best runtime result was 0.013583452s per iteration (with 369 iterations)

  Testing unmap performance with 1 runs, 5 seconds each
  Test took 0.003841196s for slot setup + 5.001802893s all iterations
  Done 341 iterations, avg 0.014668043s each
  Best runtime result was 0.014668043s per iteration (with 341 iterations)

  Testing unmap chunked performance with 1 runs, 5 seconds each
  Test took 0.003784356s for slot setup + 5.000265398s all iterations
  Done 7376 iterations, avg 0.000677910s each
  Best runtime result was 0.000677910s per iteration (with 7376 iterations)

  Testing move active area performance with 1 runs, 5 seconds each
  Test took 0.003828075s for slot setup + 5.000021760s all iterations
  Done 85449 iterations, avg 0.000058514s each
  Best runtime result was 0.000058514s per iteration (with 85449 iterations)

  Testing move inactive area performance with 1 runs, 5 seconds each
  Test took 0.003809146s for slot setup + 5.000024149s all iterations
  Done 181908 iterations, avg 0.000027486s each
  Best runtime result was 0.000027486s per iteration (with 181908 iterations)

  Testing RW performance with 1 runs, 5 seconds each
  Test took 0.003780596s for slot setup + 5.001116175s all iterations
  Done 391 iterations, avg 0.012790578s each
  Best runtime result was 0.012790578s per iteration (with 391 iterations)
  Best slot setup time for the whole test area was 0.003780596s
  ok 6 selftests: kvm: memslot_perf_test

selftests: kvm: kvm_binary_stats_test
  TAP version 13
  1..4
  ok 1 vm0
  ok 2 vm1
  ok 3 vm2
  ok 4 vm3
  Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0
  ok 7 selftests: kvm: kvm_binary_stats_test

Changes for v2:
1. We should use ".balign 4096" to align the assemble code with 4K in
exception.S instead of "align 12".
2. LoongArch only supports 3 or 4 levels page tables, so we remove the
hanlders for 2-levels page table.
3. Remove the DEFAULT_LOONGARCH_GUEST_STACK_VADDR_MIN and use the common
DEFAULT_GUEST_STACK_VADDR_MIN to allocate stack memory in guest.
4. Reorganize the test cases supported by LoongArch.
5. Fix some code comments.
6. Add kvm_binary_stats_test test case into LoongArch KVM selftests.

changes for v1:
1. Add kvm selftests header files for LoongArch.
2. Add processor tests for LoongArch KVM.
3. Add ucall tests for LoongArch KVM.
4. Add LoongArch tests into makefile.

Tianrui Zhao (4):
  KVM: selftests: Add KVM selftests header files for LoongArch
  KVM: selftests: Add core KVM selftests support for LoongArch
  KVM: selftests: Add ucall test support for LoongArch
  KVM: selftests: Add test cases supported by LoongArch into makefile

 tools/testing/selftests/kvm/Makefile          |  12 +
 .../selftests/kvm/include/kvm_util_base.h     |   5 +
 .../kvm/include/loongarch/processor.h         | 107 ++++++
 .../selftests/kvm/lib/loongarch/exception.S   |  27 ++
 .../selftests/kvm/lib/loongarch/processor.c   | 356 ++++++++++++++++++
 .../selftests/kvm/lib/loongarch/ucall.c       |  43 +++
 6 files changed, 550 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/processor.h
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/exception.S
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/processor.c
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/ucall.c

-- 
2.39.1

