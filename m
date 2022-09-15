Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216A75B9BBE
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 15:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiIONVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 09:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIONVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 09:21:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A01C74CCE
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 06:21:47 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FBvkpZ030243;
        Thu, 15 Sep 2022 13:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OE+orV7pQtnk1IsxbaVXQNywQkyusOgQS9iFM3Ujp/U=;
 b=j/zf71wPJAOFkmnRjRPuEaSyoQ9Ia4AY/mMR2gNSfwwilEOiKxEGhjarXKluc5jjZA5D
 ArgExz2P+O6uwiZKPP4jN2QzbHjvUAa/a0DBvp9GNb61CEOnU4vK9t34VB2LcLH2QS+T
 VmYBeXFgaf3tKLVCvFo7p4UGjRCcw3GP5evikLQ7WN9Q5urFxFflefnvUYrL3JFn+HI1
 htRN913mxA4VuCuUwTJsYkd//lifJO3UXQXkmMu77l7vygkUaaMkTw6i4zzVKO2xQk0G
 x1AY9jZbHEA31OA1V0Rfg7moSDjaRrcPZ8KOSCRlL+x6jETnYQTTC56sy0WWz5ZC6WaC oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm3mw2ukw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 13:21:31 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28FCHd1n013784;
        Thu, 15 Sep 2022 13:21:30 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm3mw2ujb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 13:21:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28FDKfvW020579;
        Thu, 15 Sep 2022 13:21:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3jjytx2dtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 13:21:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28FDLPmG42467756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 13:21:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE6364C046;
        Thu, 15 Sep 2022 13:21:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 589A54C040;
        Thu, 15 Sep 2022 13:21:25 +0000 (GMT)
Received: from [9.171.87.36] (unknown [9.171.87.36])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Sep 2022 13:21:25 +0000 (GMT)
Message-ID: <a63becdf-18d7-25f1-9070-209dbc008add@linux.ibm.com>
Date:   Thu, 15 Sep 2022 15:21:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
Content-Language: en-US
To:     Shivam Kumar <shivam.kumar1@nutanix.com>, pbonzini@redhat.com,
        seanjc@google.com, maz@kernel.org, james.morse@arm.com,
        david@redhat.com
Cc:     kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220915101049.187325-2-shivam.kumar1@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vVKgXlIKkhN6aSIUL56ntADcrPfIHM6w
X-Proofpoint-ORIG-GUID: wjudDg31W_cx5IAhaHAlH5Bs2aGhdifp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_08,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150074
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 15.09.22 um 12:10 schrieb Shivam Kumar:
> Define variables to track and throttle memory dirtying for every vcpu.
> 
> dirty_count:    Number of pages the vcpu has dirtied since its creation,
>                  while dirty logging is enabled.
> dirty_quota:    Number of pages the vcpu is allowed to dirty. To dirty
>                  more, it needs to request more quota by exiting to
>                  userspace.
> 
> Implement the flow for throttling based on dirty quota.
> 
> i) Increment dirty_count for the vcpu whenever it dirties a page.
> ii) Exit to userspace whenever the dirty quota is exhausted (i.e. dirty
> count equals/exceeds dirty quota) to request more dirty quota.
> 
> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
[...]

I am wondering if this will work on s390. On s390  we only call
mark_page_dirty_in_slot for the kvm_read/write functions but not
for those done by the guest on fault. We do account those lazily in
kvm_arch_sync_dirty_log (like x96 in the past).

> +
>   void mark_page_dirty_in_slot(struct kvm *kvm,
>   			     const struct kvm_memory_slot *memslot,
>   		 	     gfn_t gfn)
>   {
>   	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>   
> -#ifdef CONFIG_HAVE_KVM_DIRTY_RING
>   	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>   		return;
> -#endif

This will rigger on s390 for the interrupt payload written from vhost
if I recall correctly. Please do not enable this warning.

>   
> -	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
> +	if (!memslot)
> +		return;
> +
> +	WARN_ON_ONCE(!vcpu->stat.generic.pages_dirtied++);
> +
> +	if (kvm_slot_dirty_track_enabled(memslot)) {
>   		unsigned long rel_gfn = gfn - memslot->base_gfn;
>   		u32 slot = (memslot->as_id << 16) | memslot->id;
>   
> @@ -3318,6 +3336,8 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>   					    slot, rel_gfn);
>   		else
>   			set_bit_le(rel_gfn, memslot->dirty_bitmap);
> +
> +		kvm_vcpu_is_dirty_quota_exhausted(vcpu);
>   	}
>   }
>   EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
