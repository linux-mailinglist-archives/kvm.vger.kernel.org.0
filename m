Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9EE273F0E2
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 04:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjF0Cfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 22:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjF0Cfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 22:35:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F0CC5
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 19:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687833284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wu4+qGRzze9rNAF/oBI8QT0UDNN6zhdjUkN+ApOnm6A=;
        b=On6sbPQZFXZ/2FBwM9y4LTr5erS/FaJBqMreL8Rguh4E+5kjL5Pcet/oNzSw7fgsrM6y2H
        Y+rH/3xTntGr+gfEYYhUpuXMsr+hGVRz4eJASD0E7OVQnlW5PGfVMoEYke0hYcwtuPtVlF
        obl0LR7/4A2cWRY7JxQDfvVOMOsuadk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-zrtTEoUfP82D601mEy3bGQ-1; Mon, 26 Jun 2023 22:34:42 -0400
X-MC-Unique: zrtTEoUfP82D601mEy3bGQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b80c4ca6c5so1278605ad.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 19:34:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687833281; x=1690425281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wu4+qGRzze9rNAF/oBI8QT0UDNN6zhdjUkN+ApOnm6A=;
        b=eSc3qLzl8OWVa8Gb7jisRpAXjDUePAgvW3KpLVbI7E8bOtWfRFCVLNEU+1kG2IeOCR
         z8w5cS7qR5AzuXegfIUFDmzPT29vdEfWuyIaKgm8QFkUUER2oJZHXdxeLxaULC0nUW5F
         ktvRGPUKw8UG/1w1MAMc+sR+0e/9+RE6fPTHleeFY6vL6BKzDK2b1u4+6h2sa1VtIyAK
         LSDfC3ZUNCgHLlcgWnqt3+Mb/fzXoWQ6VlNPFACPL3vLlkYLPqclbhnpBf9upFrAj4ZZ
         lRQlrWOkgXrKZZ8ZVFBvOip11DuMlbLwqCxdUQy2x+DPHFuDnOpnntrhoWrtRauUFbxX
         QJcQ==
X-Gm-Message-State: AC+VfDzV77e2gdZ/d1jTWeyWELzl0O01qcl1bjAMMHlMFTDZU8ZfzDf5
        jkPlVEZgpKM/Jcx95VZipm+P/0gUM+VxMKdM3xiIY9xyM9PtyLPwwiQ6U3DWI6vJ6e2sK2g8knD
        Uwc1NEkufrYWx
X-Received: by 2002:a17:903:1ca:b0:1b5:32ec:df97 with SMTP id e10-20020a17090301ca00b001b532ecdf97mr36654226plh.5.1687833280750;
        Mon, 26 Jun 2023 19:34:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6yE6lyZOsSy5asQLEIJAm4foiQaPUY/FsSOYw03E80E6jiejKP5iLw6DKgjFN0Ijz8VV/FTg==
X-Received: by 2002:a17:903:1ca:b0:1b5:32ec:df97 with SMTP id e10-20020a17090301ca00b001b532ecdf97mr36654214plh.5.1687833280521;
        Mon, 26 Jun 2023 19:34:40 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jn22-20020a170903051600b001b3eed9cf24sm4821765plb.54.2023.06.26.19.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jun 2023 19:34:40 -0700 (PDT)
Message-ID: <fb5e8d4d-2388-3ab0-aaac-a1dd91e74b08@redhat.com>
Date:   Tue, 27 Jun 2023 10:34:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v1 0/5] target/arm: Handle psci calls in userspace
To:     Salil Mehta <salil.mehta@huawei.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>
Cc:     "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Salil Mehta <salil.mehta@opnsrc.net>
References: <20230626064910.1787255-1-shahuang@redhat.com>
 <9df973ede74e4757b510f26cd5786036@huawei.com>
Content-Language: en-US
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <9df973ede74e4757b510f26cd5786036@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Salil,

On 6/26/23 21:42, Salil Mehta wrote:
>> From: Shaoqin Huang <shahuang@redhat.com>
>> Sent: Monday, June 26, 2023 7:49 AM
>> To: qemu-devel@nongnu.org; qemu-arm@nongnu.org
>> Cc: oliver.upton@linux.dev; Salil Mehta <salil.mehta@huawei.com>;
>> james.morse@arm.com; gshan@redhat.com; Shaoqin Huang <shahuang@redhat.com>;
>> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org; Michael S. Tsirkin
>> <mst@redhat.com>; Paolo Bonzini <pbonzini@redhat.com>; Peter Maydell
>> <peter.maydell@linaro.org>
>> Subject: [PATCH v1 0/5] target/arm: Handle psci calls in userspace
>>
>> The userspace SMCCC call filtering[1] provides the ability to forward the SMCCC
>> calls to the userspace. The vCPU hotplug[2] would be the first legitimate use
>> case to handle the psci calls in userspace, thus the vCPU hotplug can deny the
>> PSCI_ON call if the vCPU is not present now.
>>
>> This series try to enable the userspace SMCCC call filtering, thus can handle
>> the SMCCC call in userspace. The first enabled SMCCC call is psci call, by using
>> the new added option 'user-smccc', we can enable handle psci calls in userspace.
>>
>> qemu-system-aarch64 -machine virt,user-smccc=on
>>
>> This series reuse the qemu implementation of the psci handling, thus the
>> handling process is very simple. But when handling psci in userspace when using
>> kvm, the reset vcpu process need to be taking care, the detail is included in
>> the patch05.
> 
> This change in intended for VCPU Hotplug and we are duplicating the code
> we are working on. Unless this change is also intended for any other
> feature I would request you to defer this.

Thanks for sharing me the information. I'm not intended for merging this 
series, but discuss something about the VCPU Hotplug, since I'm also 
following the work of vCPU Hotplug.

Just curious, what is your plan to update a new version of VCPU Hotplug 
which is based on the userspace SMCCC filtering?

Thanks,
Shaoqin

> 
> 
> Thanks
> Salil
> 

-- 
Shaoqin

