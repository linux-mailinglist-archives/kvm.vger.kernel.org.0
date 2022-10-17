Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707FB60157D
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 19:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiJQRfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 13:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiJQRfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 13:35:13 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516D8220D5;
        Mon, 17 Oct 2022 10:35:03 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1okU0m-0001Ml-UB; Mon, 17 Oct 2022 19:34:48 +0200
Message-ID: <fb3926da-a683-2811-71a4-31fe36a9cb50@maciej.szmigiero.name>
Date:   Mon, 17 Oct 2022 19:34:42 +0200
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
 <20221014071914.227134-4-gshan@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 3/6] KVM: selftests: memslot_perf_test: Probe memory slots
 for once
In-Reply-To: <20221014071914.227134-4-gshan@redhat.com>
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
> prepare_vm() is called in every iteration and run. The allowed memory
> slots (KVM_CAP_NR_MEMSLOTS) are probed for multiple times. It's not
> free and unnecessary.
> 
> Move the probing logic for the allowed memory slots to parse_args()
> for once, which is upper layer of prepare_vm().
> 
> No functional change intended.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>   .../testing/selftests/kvm/memslot_perf_test.c | 29 ++++++++++---------
>   1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
> index dcb492b3f27b..d5aa9148f96f 100644
> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
> @@ -245,27 +245,17 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
>   		       void *guest_code, uint64_t mempages,
>   		       struct timespec *slot_runtime)
>   {
> -	uint32_t max_mem_slots;
>   	uint64_t rempages;
>   	uint64_t guest_addr;
>   	uint32_t slot;
>   	struct timespec tstart;
>   	struct sync_area *sync;
>   
> -	max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
> -	TEST_ASSERT(max_mem_slots > 1,
> -		    "KVM_CAP_NR_MEMSLOTS should be greater than 1");
> -	TEST_ASSERT(nslots > 1 || nslots == -1,
> -		    "Slot count cap should be greater than 1");
> -	if (nslots != -1)
> -		max_mem_slots = min(max_mem_slots, (uint32_t)nslots);
> -	pr_info_v("Allowed number of memory slots: %"PRIu32"\n", max_mem_slots);
> -
>   	TEST_ASSERT(mempages > 1,
>   		    "Can't test without any memory");
>   
>   	data->npages = mempages;
> -	data->nslots = max_mem_slots - 1;
> +	data->nslots = nslots;
>   	data->pages_per_slot = mempages / data->nslots;
>   	if (!data->pages_per_slot) {
>   		*maxslots = mempages + 1;
> @@ -885,8 +875,8 @@ static bool parse_args(int argc, char *argv[],
>   			break;
>   		case 's':
>   			targs->nslots = atoi(optarg);
> -			if (targs->nslots <= 0 && targs->nslots != -1) {
> -				pr_info("Slot count cap has to be positive or -1 for no cap\n");
> +			if (targs->nslots <= 1 && targs->nslots != -1) {
> +				pr_info("Slot count cap must be larger than 1 or -1 for no cap\n");
>   				return false;
>   			}
>   			break;
> @@ -932,6 +922,19 @@ static bool parse_args(int argc, char *argv[],
>   		return false;
>   	}
>   
> +	/* Memory slot 0 is reserved */
> +	if (targs->nslots == -1) {
> +		targs->nslots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS) - 1;
> +		if (targs->nslots < 1) {
> +			pr_info("KVM_CAP_NR_MEMSLOTS should be greater than 1\n");
> +			return false;
> +		}
> +	} else {
> +		targs->nslots--;
> +	}
> +
> +	pr_info_v("Number of memory slots: %d\n", targs->nslots);
> +

Can't see any capping of the command line provided slot count to
KVM_CAP_NR_MEMSLOTS value, like the old code did.

>   	return true;
>   }
>   

Thanks,
Maciej

