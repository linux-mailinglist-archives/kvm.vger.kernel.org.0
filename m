Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E1B5F4490
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 15:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJDNoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 09:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiJDNoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 09:44:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D68712A8D;
        Tue,  4 Oct 2022 06:44:03 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294DhrN1024970;
        Tue, 4 Oct 2022 13:44:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=V9qRQCFmlpg/MrUFbaU8DN876X8stZcwjUlLHSqp6qk=;
 b=XQMc7/SF2W72kXzKNqyr95xZfWctVlzNVFNChlQwQdnA17Wn62xszIiEH19FLPWowrfk
 cBg5LNvkgmTjISgox87Y2Fg7gt8xpK8GEJ1fKH1kzIDaL4t86dalONVKc/HsBvrfq41t
 wzX4FpzK87LvQHEkEFRuhSxQKZzwwqrmwhHvqH8BEBFNkqgvF4Xqh32ipSprnusDYh7g
 94iyXy8edTnMX8WlmwjZBuD7kszJilKGGtSbG1n2UhKbkKQ2PNbRN2azehzLsC2+NpO2
 JvI9q7FoO+JUS2/XWxuELKJOftr1Yk/EV+nkjEd2FmI0aBPnO3VBiAsXv2LSGj/ccEJx 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gwts2wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:44:01 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 294Dhrsh024592;
        Tue, 4 Oct 2022 13:44:01 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gwts2vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:44:01 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 294Dd9ni008770;
        Tue, 4 Oct 2022 13:43:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3jxd68u38u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:43:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 294Dhtds53674470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Oct 2022 13:43:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DC19A405B;
        Tue,  4 Oct 2022 13:43:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC624A4054;
        Tue,  4 Oct 2022 13:43:54 +0000 (GMT)
Received: from [9.145.154.3] (unknown [9.145.154.3])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Oct 2022 13:43:54 +0000 (GMT)
Message-ID: <7ec6b318-b354-8681-3853-1514f3dbbbd7@linux.ibm.com>
Date:   Tue, 4 Oct 2022 15:43:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v14 2/6] KVM: s390: pv: api documentation for asynchronous
 destroy
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com, nrb@linux.ibm.com
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
 <20220930140150.37463-3-imbrenda@linux.ibm.com>
Content-Language: en-US
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20220930140150.37463-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qNptVM7u4ZWgkl4Sakvib0UsQVAjq_y1
X-Proofpoint-ORIG-GUID: tThHKkvhSLKn1USY9YnS8Z4q0tSUNI4n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 spamscore=0 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040088
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/30/22 16:01, Claudio Imbrenda wrote:
> Add documentation for the new commands added to the KVM_S390_PV_COMMAND
> ioctl.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>LGTM.

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

> ---
>   Documentation/virt/kvm/api.rst | 37 ++++++++++++++++++++++++++++++----
>   1 file changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index abd7c32126ce..5775e5fbfd18 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5161,10 +5161,13 @@ KVM_PV_ENABLE
>     =====      =============================
>   
>   KVM_PV_DISABLE
> -  Deregister the VM from the Ultravisor and reclaim the memory that
> -  had been donated to the Ultravisor, making it usable by the kernel
> -  again.  All registered VCPUs are converted back to non-protected
> -  ones.
> +  Deregister the VM from the Ultravisor and reclaim the memory that had
> +  been donated to the Ultravisor, making it usable by the kernel again.
> +  All registered VCPUs are converted back to non-protected ones. If a
> +  previous protected VM had been prepared for asynchonous teardown with
> +  KVM_PV_ASYNC_CLEANUP_PREPARE and not subsequently torn down with
> +  KVM_PV_ASYNC_CLEANUP_PERFORM, it will be torn down in this call
> +  together with the current protected VM.
>   
>   KVM_PV_VM_SET_SEC_PARMS
>     Pass the image header from VM memory to the Ultravisor in
> @@ -5287,6 +5290,32 @@ KVM_PV_DUMP
>       authentication tag all of which are needed to decrypt the dump at a
>       later time.
>   
> +KVM_PV_ASYNC_CLEANUP_PREPARE
> +  Prepare the current protected VM for asynchronous teardown. Most
> +  resources used by the current protected VM will be set aside for a
> +  subsequent asynchronous teardown. The current protected VM will then
> +  resume execution immediately as non-protected. There can be at most
> +  one protected VM prepared for asynchronous teardown at any time. If
> +  a protected VM had already been prepared for teardown without
> +  subsequently calling KVM_PV_ASYNC_CLEANUP_PERFORM, this call will
> +  fail. In that case, the userspace process should issue a normal
> +  KVM_PV_DISABLE. The resources set aside with this call will need to
> +  be cleaned up with a subsequent call to KVM_PV_ASYNC_CLEANUP_PERFORM
> +  or KVM_PV_DISABLE, otherwise they will be cleaned up when KVM
> +  terminates. KVM_PV_ASYNC_CLEANUP_PREPARE can be called again as soon
> +  as cleanup starts, i.e. before KVM_PV_ASYNC_CLEANUP_PERFORM finishes.
> +
> +KVM_PV_ASYNC_CLEANUP_PERFORM
> +  Tear down the protected VM previously prepared for teardown with
> +  KVM_PV_ASYNC_CLEANUP_PREPARE. The resources that had been set aside
> +  will be freed during the execution of this command. This PV command
> +  should ideally be issued by userspace from a separate thread. If a
> +  fatal signal is received (or the process terminates naturally), the
> +  command will terminate immediately without completing, and the normal
> +  KVM shutdown procedure will take care of cleaning up all remaining
> +  protected VMs, including the ones whose teardown was interrupted by
> +  process termination.
> +
>   
>   4.126 KVM_X86_SET_MSR_FILTER
>   ----------------------------
