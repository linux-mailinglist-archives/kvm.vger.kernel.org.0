Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB116601B73
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 23:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiJQVo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 17:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJQVoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 17:44:37 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A1A8049C;
        Mon, 17 Oct 2022 14:36:17 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1okXmL-0001p3-Ku; Mon, 17 Oct 2022 23:36:09 +0200
Message-ID: <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
Date:   Mon, 17 Oct 2022 23:36:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US, pl-PL
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ajones@ventanamicro.com, pbonzini@redhat.com, maz@kernel.org,
        shuah@kernel.org, oliver.upton@linux.dev, seanjc@google.com,
        peterx@redhat.com, ricarkol@google.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
In-Reply-To: <20221014071914.227134-6-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.10.2022 09:19, Gavin Shan wrote:
> The addresses and sizes passed to madvise() and vm_userspace_mem_region_add()
> should be aligned to host page size, which can be 64KB on aarch64. So it's
> wrong by passing additional fixed 4KB memory area to various tests.
> 
> Fix it by passing additional fixed 64KB memory area to various tests. After
> it's applied, the following command works fine on 64KB-page-size-host and
> 4KB-page-size-guest.
> 
>    # ./memslot_perf_test -v -s 512
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>   .../testing/selftests/kvm/memslot_perf_test.c  | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
> index d587bd952ff9..e6d34744b45d 100644
> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
> @@ -25,12 +25,14 @@
>   #include <kvm_util.h>
>   #include <processor.h>
>   
> -#define MEM_SIZE		((512U << 20) + 4096)
> -#define MEM_GPA		0x10000000UL
> +#define MEM_EXTRA_SIZE		0x10000

So the biggest page size supported right now is 64 KiB - it would be
good to have an assert somewhere to explicitly check for this
(regardless of implicit checks present in other calculations).

Also, an expression like "(64 << 10)" is more readable than a "1"
with a tail of zeroes (it's easy to add one zero too many or be one
zero short).

Thanks,
Maciej

