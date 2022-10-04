Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D6C5F44AB
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiJDNs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 09:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJDNsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 09:48:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B5D2982F;
        Tue,  4 Oct 2022 06:48:09 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294DhrJe009533;
        Tue, 4 Oct 2022 13:48:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gjs6jxYUVXBETBOD2y3XS11GdH82NGbdtggBHFFHPCE=;
 b=f4mA/D1xmmUfORrSuJfj/NNPxKnh9iKmh6Y4ETIfSSyHIK8igfJu6EwGwC3W3Aj4sO45
 BrQ0mNNekyLN3tBt/kknCs+NzTxVvACcGHLfExP4LGZhEAuTQ8/NXdL/xaCRVSsiSBXk
 mdPJc3wRbXwAm5DiVgExTJ8kHzWMx06kjJCst641DSbry29BiumdAbXHVhtSVHQ7qhPJ
 60v3LXv7JwzkRVEDLiK3pEL51wdxUyrghIaMAcy7ooa6KzLVfKYNj12fA05UgYKs1ovC
 kgcbc5DTmL9xSR9wqVfXCiV/rmahLKDiBjYBkE1AViPYZte1BE3I5tcUHLRTx37ym9QC ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0bdsj3pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:48:08 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 294DiAji015415;
        Tue, 4 Oct 2022 13:48:08 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0bdsj3nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:48:08 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 294De643005943;
        Tue, 4 Oct 2022 13:48:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3jxd6948j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:48:06 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 294Dm3Ml61931998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Oct 2022 13:48:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 667BAA4054;
        Tue,  4 Oct 2022 13:48:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11939A405C;
        Tue,  4 Oct 2022 13:48:03 +0000 (GMT)
Received: from [9.145.154.3] (unknown [9.145.154.3])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Oct 2022 13:48:03 +0000 (GMT)
Message-ID: <6475e527-6257-d6dd-e712-e7b64f95ccad@linux.ibm.com>
Date:   Tue, 4 Oct 2022 15:48:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v14 5/6] KVM: s390: pv: support for Destroy fast UVC
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com, nrb@linux.ibm.com
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
 <20220930140150.37463-6-imbrenda@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20220930140150.37463-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UuXniwwT8WWkvsFtZtJ8mH7Axf3tCOxr
X-Proofpoint-GUID: fpUBdCuXgauuykaTRzFSrN2dNTT-gOjw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_05,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040088
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/30/22 16:01, Claudio Imbrenda wrote:
> Add support for the Destroy Secure Configuration Fast Ultravisor call,
> and take advantage of it for asynchronous destroy.
> 
> When supported, the protected guest is destroyed immediately using the
> new UVC, leaving only the memory to be cleaned up asynchronously.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
LGTM
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

> ---
>   arch/s390/include/asm/uv.h | 10 +++++++
>   arch/s390/kvm/pv.c         | 57 ++++++++++++++++++++++++++++++++------
>   2 files changed, 59 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index be3ef9dd6972..28a9ad57b6f1 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -34,6 +34,7 @@
>   #define UVC_CMD_INIT_UV			0x000f
>   #define UVC_CMD_CREATE_SEC_CONF		0x0100
>   #define UVC_CMD_DESTROY_SEC_CONF	0x0101
> +#define UVC_CMD_DESTROY_SEC_CONF_FAST	0x0102
>   #define UVC_CMD_CREATE_SEC_CPU		0x0120
>   #define UVC_CMD_DESTROY_SEC_CPU		0x0121
>   #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
> @@ -81,6 +82,7 @@ enum uv_cmds_inst {
>   	BIT_UVC_CMD_UNSHARE_ALL = 20,
>   	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
>   	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
> +	BIT_UVC_CMD_DESTROY_SEC_CONF_FAST = 23,
>   	BIT_UVC_CMD_DUMP_INIT = 24,
>   	BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE = 25,
>   	BIT_UVC_CMD_DUMP_CPU = 26,
> @@ -230,6 +232,14 @@ struct uv_cb_nodata {
>   	u64 reserved20[4];
>   } __packed __aligned(8);
>   
> +/* Destroy Configuration Fast */
> +struct uv_cb_destroy_fast {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 handle;
> +	u64 reserved20[5];
> +} __packed __aligned(8);
> +
>   /* Set Shared Access */
>   struct uv_cb_share {
>   	struct uv_cb_header header;
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 335eeec6e3da..1b51e5c3f7df 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -201,6 +201,9 @@ static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
>   {
>   	int cc;
>   
> +	/* It used the destroy-fast UVC, nothing left to do here */
> +	if (!leftover->handle)
> +		goto done_fast;
>   	cc = uv_cmd_nodata(leftover->handle, UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
>   	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY LEFTOVER VM: rc %x rrc %x", *rc, *rrc);
>   	WARN_ONCE(cc, "protvirt destroy leftover vm failed rc %x rrc %x", *rc, *rrc);
> @@ -215,6 +218,7 @@ static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
>   	free_pages(leftover->stor_base, get_order(uv_info.guest_base_stor_len));
>   	free_pages(leftover->old_gmap_table, CRST_ALLOC_ORDER);
>   	vfree(leftover->stor_var);
> +done_fast:
>   	atomic_dec(&kvm->mm->context.protected_count);
>   	return 0;
>   }
> @@ -248,6 +252,32 @@ static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
>   	srcu_read_unlock(&kvm->srcu, srcu_idx);
>   }
>   
> +static int kvm_s390_pv_deinit_vm_fast(struct kvm *kvm, u16 *rc, u16 *rrc)
> +{
> +	struct uv_cb_destroy_fast uvcb = {
> +		.header.cmd = UVC_CMD_DESTROY_SEC_CONF_FAST,
> +		.header.len = sizeof(uvcb),
> +		.handle = kvm_s390_pv_get_handle(kvm),
> +	};
> +	int cc;
> +
> +	cc = uv_call_sched(0, (u64)&uvcb);
> +	*rc = uvcb.header.rc;
> +	*rrc = uvcb.header.rrc;
> +	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM FAST: rc %x rrc %x", *rc, *rrc);
> +	WARN_ONCE(cc, "protvirt destroy vm fast failed rc %x rrc %x", *rc, *rrc);
> +	/* Inteded memory leak on "impossible" error */
> +	if (!cc)
> +		kvm_s390_pv_dealloc_vm(kvm);
> +	return cc ? -EIO : 0;
> +}
> +
> +static inline bool is_destroy_fast_available(void)
> +{
> +	return test_bit_inv(BIT_UVC_CMD_DESTROY_SEC_CONF_FAST, uv_info.inst_calls_list);
> +}
> +
>   /**
>    * kvm_s390_pv_set_aside - Set aside a protected VM for later teardown.
>    * @kvm: the VM
> @@ -269,6 +299,7 @@ static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
>   int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
>   {
>   	struct pv_vm_to_be_destroyed *priv;
> +	int res = 0;
>   
>   	/*
>   	 * If another protected VM was already prepared for teardown, refuse.
> @@ -280,14 +311,21 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	if (!priv)
>   		return -ENOMEM;
>   
> -	priv->stor_var = kvm->arch.pv.stor_var;
> -	priv->stor_base = kvm->arch.pv.stor_base;
> -	priv->handle = kvm_s390_pv_get_handle(kvm);
> -	priv->old_gmap_table = (unsigned long)kvm->arch.gmap->table;
> -	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> -	if (s390_replace_asce(kvm->arch.gmap)) {
> +	if (is_destroy_fast_available()) {
> +		res = kvm_s390_pv_deinit_vm_fast(kvm, rc, rrc);
> +	} else {
> +		priv->stor_var = kvm->arch.pv.stor_var;
> +		priv->stor_base = kvm->arch.pv.stor_base;
> +		priv->handle = kvm_s390_pv_get_handle(kvm);
> +		priv->old_gmap_table = (unsigned long)kvm->arch.gmap->table;
> +		WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> +		if (s390_replace_asce(kvm->arch.gmap))
> +			res = -ENOMEM;
> +	}
> +
> +	if (res) {
>   		kfree(priv);
> -		return -ENOMEM;
> +		return res;
>   	}
>   
>   	kvm_s390_destroy_lower_2g(kvm);
> @@ -464,6 +502,7 @@ static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
>   {
>   	struct kvm *kvm = container_of(subscription, struct kvm, arch.pv.mmu_notifier);
>   	u16 dummy;
> +	int r;
>   
>   	/*
>   	 * No locking is needed since this is the last thread of the last user of this
> @@ -472,7 +511,9 @@ static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
>   	 * unregistered. This means that if this notifier runs, then the
>   	 * struct kvm is still valid.
>   	 */
> -	kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
> +	r = kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
> +	if (!r && is_destroy_fast_available())
> +		kvm_s390_pv_deinit_vm_fast(kvm, &dummy, &dummy);
>   }
>   
>   static const struct mmu_notifier_ops kvm_s390_pv_mmu_notifier_ops = {
