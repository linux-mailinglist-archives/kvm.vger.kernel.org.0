Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C75C4F420D
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 23:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241430AbiDEOvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344025AbiDEOFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 10:05:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 907021557F0
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 05:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649163489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I7YDzc0txooe4wDXjoZKV+HdiLgjGSAsT9wsXDKfsIc=;
        b=GCH3mdPj5P/QCvI6vGv3NA4ffpbmcJ2RekgJMXeh8e2QPpEhVM5lhv3zgsvHFUqf8v8LTV
        qUETPhgzkuoV825Yp1GXxZ3ch+C4ccErDIdgvpBml21qyQeVCvgo63I2URfSB7FdKPsOke
        kfutKvoNxOaCfxkVcAv6Y4cic/RPYRo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-_ixsmQSKP3yl4uz4NgGKLw-1; Tue, 05 Apr 2022 08:58:08 -0400
X-MC-Unique: _ixsmQSKP3yl4uz4NgGKLw-1
Received: by mail-wm1-f72.google.com with SMTP id l19-20020a05600c1d1300b0038e736f98faso1504060wms.4
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 05:58:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I7YDzc0txooe4wDXjoZKV+HdiLgjGSAsT9wsXDKfsIc=;
        b=4sTmiKdO4Papv7vrDA/+d/Co6Z4jjbYlMVrqpP1+XZBZ38YMQq9EqeHv0j/pfvA6om
         m6s+CWtwS3f+nwqOBvlvEZCJmSpeQv0IzIiGeIdJmyuPMpg3sBIBYCjW3EdWbneKnT7v
         +buoqaJjZFBeHlD3orO+QAsQxEnyvwRW0cpCLZ3N+qiTwReUCW2pt6kcdmO2Qijc2MEx
         XTOI/QmslZpUwOSbPXpIU7YNBBuVqD02aGYniPqk2IQVietGQhMm6tcqJARlXaeQRfFj
         sNb742EH2hET1TIRUBrYz49o9Vu+ZpNH6V75rt+zsQR7k//sVifd1OSBRl+RvFw/gNCt
         AElg==
X-Gm-Message-State: AOAM530yYYNwzMScf3W0lf3lTk3CO1Z6UC/kduYDB8EuNfGZo3XtKomx
        dVDEHhhm3evPCjnxOdEHT5D+aO+zJtAHz4jyF/kFyicpITwdMUtYQpt6PdCPJWpUzy4loGU4sZw
        N4CCKENKg7Kym
X-Received: by 2002:a7b:c347:0:b0:37e:68e6:d85c with SMTP id l7-20020a7bc347000000b0037e68e6d85cmr3142057wmj.176.1649163487129;
        Tue, 05 Apr 2022 05:58:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOngzMtEU2KPnwylW2akB8kPVoiTa6yBmTv34dc8nvDFuKKvuEx56M9l/8R39QBk1A2dB1TQ==
X-Received: by 2002:a7b:c347:0:b0:37e:68e6:d85c with SMTP id l7-20020a7bc347000000b0037e68e6d85cmr3142030wmj.176.1649163486869;
        Tue, 05 Apr 2022 05:58:06 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b0038cbd8c41e9sm2096679wmq.12.2022.04.05.05.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 05:58:05 -0700 (PDT)
Message-ID: <e392b53a-fbaa-4724-07f4-171424144f70@redhat.com>
Date:   Tue, 5 Apr 2022 14:58:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 027/104] KVM: TDX: initialize VM with TDX specific
 parameters
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> +	td_params->attributes = init_vm->attributes;
> +	if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> +		pr_warn("TD doesn't support perfmon. KVM needs to save/restore "
> +			"host perf registers properly.\n");
> +		return -EOPNOTSUPP;
> +	}

Why does KVM have to hardcode this (and LBR/AMX below)?  Is the level of 
hardware support available from tdx_caps, for example through the CPUID 
configs (0xA for this one, 0xD for LBR and AMX)?

> +	/* PT can be exposed to TD guest regardless of KVM's XSS support */
> +	guest_supported_xss &= (supported_xss | XFEATURE_MASK_PT);
> +	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
> +	if (td_params->xfam & TDX_TD_XFAM_LBR) {
> +		pr_warn("TD doesn't support LBR. KVM needs to save/restore "
> +			"IA32_LBR_DEPTH properly.\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (td_params->xfam & TDX_TD_XFAM_AMX) {
> +		pr_warn("TD doesn't support AMX. KVM needs to save/restore "
> +			"IA32_XFD, IA32_XFD_ERR properly.\n");
> +		return -EOPNOTSUPP;
> +	}

> 
> +	if (init_vm->tsc_khz)
> +		guest_tsc_khz = init_vm->tsc_khz;
> +	else
> +		guest_tsc_khz = max_tsc_khz;

You can just use kvm->arch.default_tsc_khz in the latest kvm/queue.

> +#define BUILD_BUG_ON_MEMCPY(dst, src)				\
> +	do {							\
> +		BUILD_BUG_ON(sizeof(dst) != sizeof(src));	\
> +		memcpy((dst), (src), sizeof(dst));		\
> +	} while (0)
> +
> +	BUILD_BUG_ON_MEMCPY(td_params->mrconfigid, init_vm->mrconfigid);
> +	BUILD_BUG_ON_MEMCPY(td_params->mrowner, init_vm->mrowner);
> +	BUILD_BUG_ON_MEMCPY(td_params->mrownerconfig, init_vm->mrownerconfig);
> +


Please rename to MEMCPY_SAME_SIZE.

Thanks,

Paolo

