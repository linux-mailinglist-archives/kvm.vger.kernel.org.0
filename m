Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092B160BFFB
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 02:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiJYAph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 20:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiJYApO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 20:45:14 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D0740BFE;
        Mon, 24 Oct 2022 16:18:39 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1on6iG-000850-Py; Tue, 25 Oct 2022 01:18:32 +0200
Message-ID: <91d563b6-5f1c-5ecc-0a40-7d8838770b22@maciej.szmigiero.name>
Date:   Tue, 25 Oct 2022 01:18:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 0/6] KVM: selftests: memslot_perf_test: aarch64
 cleanup/fixes
Content-Language: en-US, pl-PL
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
        ajones@ventanamicro.com, kvmarm@lists.linux.dev, shuah@kernel.org,
        peterx@redhat.com, oliver.upton@linux.dev, seanjc@google.com,
        ricarkol@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221020071209.559062-1-gshan@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <20221020071209.559062-1-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.10.2022 09:12, Gavin Shan wrote:
> kvm/selftests/memslots_perf_test doesn't work with 64KB-page-size-host
> and 4KB-page-size-guest on aarch64. In the implementation, the host and
> guest page size have been hardcoded to 4KB. It's ovbiously not working
> on aarch64 which supports 4KB, 16KB, 64KB individually on host and guest.
> 
> This series tries to fix it. After the series is applied, the test runs
> successfully with 64KB-page-size-host and 4KB-page-size-guest.
> 
>     # ./memslots_perf_tests -v -s 512
> 
> Since we're here, the code is cleaned up a bit as PATCH[1-3] do. The
> other patches are fixes to handle the mismatched host/guest page
> sized.
> 
> v1: https://lore.kernel.org/kvmarm/20221014071914.227134-1-gshan@redhat.com/T/#t
> v2: https://lore.kernel.org/kvmarm/20221018040454.405719-1-gshan@redhat.com/T/#t
> 
> Changelog
> =========
> v3:
>    * Improved comments about MEM_TEST_MOVE_SIZE, which is set
>      to 64KB in PATCH[v3 4/6] and finally fixed to 192KB in
>      PATCH[v3 5/6].                                              (Maciej)
>    * Use size instead of pages to do the comparison in
>      test_memslot_move_prepare()                                 (Maciej)
>    * Use tools/include/linux/sizes.h instead of inventing
>      our own macros.                                             (Oliver)
> v2:
>    * Pick the smaller value between the ones specified by
>      user or probed from KVM_CAP_NR_MEMSLOTS in PATCH[v2 3/6]    (Maciej)
>    * Improved comments about MEM_TEST_MOVE_SIZE in
>      PATCH[v2 4/6]                                               (Maciej)
>    * Avoid mismatched guest page size after VM is started in
>      prepare_vm() in PATCH[v2 4/6]                               (Maciej)
>    * Fix condition to check MEM_TEST_{UNMAP, UNMAP_CHUNK}_SIZE
>      in check_memory_size() in PATCH[v2 4/6]                     (Maciej)
>    * Define base and huge page size in kvm_util_base.h in
>      PATCH[v2 5/6]                                               (Sean)
>    * Add checks on host/guest page size in check_memory_size()
>      and fail early if any of them exceeds 64KB in PATCH[v2 5/6] (Maciej)
> 
> 
> Gavin Shan (6):
>    KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
>    KVM: selftests: memslot_perf_test: Consolidate loop conditions in
>      prepare_vm()
>    KVM: selftests: memslot_perf_test: Probe memory slots for once
>    KVM: selftests: memslot_perf_test: Support variable guest page size
>    KVM: selftests: memslot_perf_test: Consolidate memory
>    KVM: selftests: memslot_perf_test: Report optimal memory slots
> 

This patch set now looks good to me, so for the whole series:
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej

