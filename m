Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93672583346
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 21:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbiG0TPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 15:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbiG0TNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 15:13:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C423B9;
        Wed, 27 Jul 2022 12:00:08 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RIjMD1005507;
        Wed, 27 Jul 2022 19:00:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=haRmwXUaPjE67kxdXNo1DNxC3LBQYFRTGsi8riRPWqo=;
 b=Zfvq27Br3YiXO28eb8+BJ+dKORWKZaSvgfi+o0vH+D+2B8uKBWcKTe8uj8wUG/smVVNa
 hBHtiTO5yZbu6TXi9VdQOsbrm7SfBmt5Kw1Zot5xRYa7G6/CGprEip9WYuMtAD9UQarJ
 78zl0yuWIHGo8U2PdNqSF12b8EhvyHBbeIHUYOgQOD0pceukRaMvEMayMasCkSqGDscg
 FEBwaHBEMYFTGDN2d0mLYXR3r+wuRVmJTsi6NbH5ZlwXJVBwHbsBqIWaclMNHL4jAYDU
 MHcHmmQDvO33IqSmLXaYkOLiOJlT330vW8t9l4K2D3+oj9xv2PGheirSMfMCH8fAtBof 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hkawt8e66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 19:00:07 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26RIkj3U010217;
        Wed, 27 Jul 2022 19:00:07 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hkawt8e5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 19:00:07 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26RIpnvI025893;
        Wed, 27 Jul 2022 19:00:06 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 3hg978skk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 19:00:06 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26RJ04kb35783042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 19:00:04 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B81B26E066;
        Wed, 27 Jul 2022 19:00:04 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD65F6E058;
        Wed, 27 Jul 2022 19:00:02 +0000 (GMT)
Received: from [9.77.149.49] (unknown [9.77.149.49])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 27 Jul 2022 19:00:02 +0000 (GMT)
Message-ID: <647bfead-5d7c-1cb1-3bf2-235ae0205310@linux.ibm.com>
Date:   Wed, 27 Jul 2022 15:00:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC] kvm: reverse call order of kvm_arch_destroy_vm() and
 kvm_destroy_devices()
Content-Language: en-US
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com, pbonzini@redhat.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com
References: <20220705185430.499688-1-akrowiak@linux.ibm.com>
In-Reply-To: <20220705185430.499688-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rT3txdSzXi1UFUTs5FkdB69PDVLbCV02
X-Proofpoint-ORIG-GUID: WHidbzhMSFrAaCYswLLJYD4c-hPidy3m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_07,2022-07-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207270079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Any Takers??????

On 7/5/22 2:54 PM, Tony Krowiak wrote:
> There is a new requirement for s390 secure execution guests that the
> hypervisor ensures all AP queues are reset and disassociated from the
> KVM guest before the secure configuration is torn down. It is the
> responsibility of the vfio_ap device driver to handle this.
>
> Prior to commit ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM"),
> the driver reset all AP queues passed through to a KVM guest when notified
> that the KVM pointer was being set to NULL. Subsequently, the AP queues
> are only reset when the fd for the mediated device used to pass the queues
> through to the guest is closed (the vfio_ap_mdev_close_device() callback).
> This is not a problem when userspace is well-behaved and uses the
> KVM_DEV_VFIO_GROUP_DEL attribute to remove the VFIO group; however, if
> userspace for some reason does not close the mdev fd, a secure execution
> guest will tear down its configuration before the AP queues are
> reset because the teardown is done in the kvm_arch_destroy_vm function
> which is invoked prior to vm_destroy_devices.
>
> This patch proposes a simple solution; rather than introducing a new
> notifier into vfio or callback into KVM, what aoubt reversing the order
> in which the kvm_arch_destroy_vm and kvm_destroy_devices are called. In
> some very limited testing (i.e., the automated regression tests for
> the vfio_ap device driver) this did not seem to cause any problems.
>
> The question remains, is there a good technical reason why the VM
> is destroyed before the devices it is using? This is not intuitive, so
> this is a request for comments on this proposed patch. The assumption
> here is that the medev fd will get closed when the devices are destroyed.
>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   virt/kvm/kvm_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a49df8988cd6..edaf2918be9b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1248,8 +1248,8 @@ static void kvm_destroy_vm(struct kvm *kvm)
>   #else
>   	kvm_flush_shadow_all(kvm);
>   #endif
> -	kvm_arch_destroy_vm(kvm);
>   	kvm_destroy_devices(kvm);
> +	kvm_arch_destroy_vm(kvm);
>   	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>   		kvm_free_memslots(kvm, &kvm->__memslots[i][0]);
>   		kvm_free_memslots(kvm, &kvm->__memslots[i][1]);
