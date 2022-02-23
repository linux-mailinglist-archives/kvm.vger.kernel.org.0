Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12CF4C1147
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 12:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239874AbiBWLbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 06:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239846AbiBWLbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 06:31:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 405BA90268
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 03:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645615840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gE7c+TJZwdJ+gVzSVPXnxEm5PYurvMoN/2kz7QXDHUQ=;
        b=PJ3L2ZFl6cYyRqfmfQFcuH7AlEGndm2dCKPcIcipp+DLqTIppouT3CuwYutp8t4AVZxG46
        M2le/z5HYOI8dxREYvSg8Dcj45HjOtT2o8D5fbjV8En2yagOTcCL32nkG1yjkuOqdp2CfT
        QAj0Vh1BYAvp1QUkmUW/iFoflfANeyI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-986Dce37PLGvxVJpnbAEPA-1; Wed, 23 Feb 2022 06:30:39 -0500
X-MC-Unique: 986Dce37PLGvxVJpnbAEPA-1
Received: by mail-wr1-f70.google.com with SMTP id j27-20020adfb31b000000b001ea8356972bso2377431wrd.1
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 03:30:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gE7c+TJZwdJ+gVzSVPXnxEm5PYurvMoN/2kz7QXDHUQ=;
        b=6FpJn+ifonIP/cTSbPZ9pPNdK1gTeFT1oKNUapf8Y1/qhikqoL38N4pbKzMQhCs/q5
         8CCju02xa6g0+3I35R2kFa7irESiGDRjGJLRa2Ob1AddDJ1loOp1R0SPpDi45Y95Rw0L
         IKcRlYQtTLTKJbTu03Wg39M8XleQwhS+zblbbmIzxjuAg/KxqTUIAMygBY3+7Lhv+iWA
         /kJ9ZsCzqjTo+JH/at9QSCxie/7VIuT4QhEfd1Uv5OzNsqaqls5261kY4XYHd7GPF6yb
         aojYqGWbPQ2PS+cn1hX+m82hy8BDR3rFXaMf+Tg785wss/8eZUGtUHdfqSBqDCZMSvi5
         rx4Q==
X-Gm-Message-State: AOAM530hIhKvOeEiA/3hikgAsZ1zBr4j/intF1fOFAPQnlWWcm8I7fVu
        yXuCTecUBLYNSHvLnEsnxpJaX4QuUCQq7MOnQBKCu328FedITEJu0pcZF9HCYPTBsreNpG7W546
        12LRnM9QljKrN
X-Received: by 2002:a05:6000:1d99:b0:1ed:bc55:34ad with SMTP id bk25-20020a0560001d9900b001edbc5534admr920990wrb.427.1645615837922;
        Wed, 23 Feb 2022 03:30:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyszBOWYlHNQwLxhXHNusl4BU8vLtOvldGHIca7YPyki7EvMfBkXxUePbm2YmXVo7pCzEFZHg==
X-Received: by 2002:a05:6000:1d99:b0:1ed:bc55:34ad with SMTP id bk25-20020a0560001d9900b001edbc5534admr920975wrb.427.1645615837592;
        Wed, 23 Feb 2022 03:30:37 -0800 (PST)
Received: from [10.33.192.232] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id t1sm67945067wre.45.2022.02.23.03.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 03:30:37 -0800 (PST)
Message-ID: <b2fd362a-eefa-8fa7-1016-55bedd3fa6ee@redhat.com>
Date:   Wed, 23 Feb 2022 12:30:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 3/9] KVM: s390: pv: Add query interface
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
References: <20220223092007.3163-1-frankja@linux.ibm.com>
 <20220223092007.3163-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220223092007.3163-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/02/2022 10.20, Janosch Frank wrote:
> Some of the query information is already available via sysfs but
> having a IOCTL makes the information easier to retrieve.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 47 ++++++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h | 23 ++++++++++++++++++++
>   2 files changed, 70 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index faa85397b6fb..837f898ad2ff 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2217,6 +2217,34 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	return r;
>   }
>   
> +static int kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
> +{
> +	u32 len;
> +
> +	switch (info->header.id) {
> +	case KVM_PV_INFO_VM: {
> +		len =  sizeof(info->header) + sizeof(info->vm);
> +
> +		if (info->header.len < len)
> +			return -EINVAL;
> +
> +		memcpy(info->vm.inst_calls_list,
> +		       uv_info.inst_calls_list,
> +		       sizeof(uv_info.inst_calls_list));
> +
> +		/* It's max cpuidm not max cpus so it's off by one */
> +		info->vm.max_cpus = uv_info.max_guest_cpu_id + 1;
> +		info->vm.max_guests = uv_info.max_num_sec_conf;
> +		info->vm.max_guest_addr = uv_info.max_sec_stor_addr;
> +		info->vm.feature_indication = uv_info.uv_feature_indications;
> +
> +		return 0;
> +	}
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>   static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>   {
>   	int r = 0;
> @@ -2353,6 +2381,25 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>   			     cmd->rc, cmd->rrc);
>   		break;
>   	}
> +	case KVM_PV_INFO: {
> +		struct kvm_s390_pv_info info = {};
> +
> +		if (copy_from_user(&info, argp, sizeof(info.header)))
> +			return -EFAULT;
> +
> +		if (info.header.len < sizeof(info.header))
> +			return -EINVAL;
> +
> +		r = kvm_s390_handle_pv_info(&info);
> +		if (r)
> +			return r;
> +
> +		r = copy_to_user(argp, &info, sizeof(info));

sizeof(info) is currently OK ... but this might break if somebody later 
extends the kvm_s390_pv_info struct, I guess? ==> Maybe also better use 
sizeof(info->header) + sizeof(info->vm) here, too? Or let 
kvm_s390_handle_pv_info() return the amount of bytes that should be copied here?

  Thomas


> +		if (r)
> +			return -EFAULT;
> +		return 0;
> +	}
>   	default:
>   		r = -ENOTTY;
>   	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dbc550bbd9fa..96fceb204a92 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1642,6 +1642,28 @@ struct kvm_s390_pv_unp {
>   	__u64 tweak;
>   };
>   
> +enum pv_cmd_info_id {
> +	KVM_PV_INFO_VM,
> +};
> +
> +struct kvm_s390_pv_info_vm {
> +	__u64 inst_calls_list[4];
> +	__u64 max_cpus;
> +	__u64 max_guests;
> +	__u64 max_guest_addr;
> +	__u64 feature_indication;
> +};
> +
> +struct kvm_s390_pv_info_header {
> +	__u32 id;
> +	__u32 len;
> +};
> +
> +struct kvm_s390_pv_info {
> +	struct kvm_s390_pv_info_header header;
> +	struct kvm_s390_pv_info_vm vm;
> +};
> +
>   enum pv_cmd_id {
>   	KVM_PV_ENABLE,
>   	KVM_PV_DISABLE,
> @@ -1650,6 +1672,7 @@ enum pv_cmd_id {
>   	KVM_PV_VERIFY,
>   	KVM_PV_PREP_RESET,
>   	KVM_PV_UNSHARE_ALL,
> +	KVM_PV_INFO,
>   };
>   
>   struct kvm_pv_cmd {

