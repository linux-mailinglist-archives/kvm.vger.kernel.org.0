Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7372F6D9199
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 10:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbjDFIbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 04:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbjDFIbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 04:31:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C437EC6
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 01:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680769861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ERnzxn9Qx+vwXFLzk0V7Z+TZPxG+skd++dkET3pEDA=;
        b=fq5hrbMEhSr5sV2EYnGWDORJco4nvgQELjlwSO/41rdakmqlGvjgpENehimCW/VeH4zX4E
        E3+MFG9oYrgfH21vqyXP12eLTt6XkqWt+OpZlH0ND/A1Qczeq2sZn/vir4+eG5heyVdYfs
        eXQrftlGl1/oTebIvowhRfkevqjzYhY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-nt8LxGTlPV6qcl7cZZ3bvw-1; Thu, 06 Apr 2023 04:31:00 -0400
X-MC-Unique: nt8LxGTlPV6qcl7cZZ3bvw-1
Received: by mail-qv1-f69.google.com with SMTP id e1-20020a0cd641000000b005b47df84f6eso17710665qvj.0
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 01:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680769860;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ERnzxn9Qx+vwXFLzk0V7Z+TZPxG+skd++dkET3pEDA=;
        b=0N4/PDLXmOpcQy5z7Wyve+niI0mBVLFzaa6Hgq+n7Jgzhihf7stS6S4zJ1btpCeKmB
         409Cw+cOyJE9WFRLqGRrOR8CAK5eA6bwjV3kDS57akQ/7eF1JCEA/RGfMcrl3SaUbNYW
         PWX3EX6l3czR1DiOr9p8RzKkunvHx8+vfpo/tI7xUzIgdWsTLny1AWOeHuNeZiJiU99U
         jRMvHw5YtnUmtxXGgdVuNltK+kARN3HDd6Q6+UTZU4qsLgG5BHkG5opdpSIizBVwXclv
         g3P0Zn/kj4cQanVp5477mj8mEc3O+kZHgRtpLFWiy/lfcBtarPdHJnRocrkzxnVTATvz
         dapA==
X-Gm-Message-State: AAQBX9fPewZBAH1kixxRU3bCJt1P6G8+vWBYr+boYIAFQC9ysJ+xTrKl
        gpcM2xUL5pfslv1f2QRDDlWSIkrCQHkAaPOzB2lTWkjg/wahqnxwaX4HFfSdJUuNuPH1Qyzbidv
        yr+anIBwxdFguNXer7YnWDGQ=
X-Received: by 2002:a05:622a:1707:b0:3e3:93ae:d104 with SMTP id h7-20020a05622a170700b003e393aed104mr10590514qtk.30.1680769859912;
        Thu, 06 Apr 2023 01:30:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350bX/yu95XVWK0ZnZ1Tm5Ts1RGGCREWa6oXibiKT2zJGhGsp/AR1+Uw/BcOp85JRID7YKxdxlw==
X-Received: by 2002:a05:622a:1707:b0:3e3:93ae:d104 with SMTP id h7-20020a05622a170700b003e393aed104mr10590489qtk.30.1680769859542;
        Thu, 06 Apr 2023 01:30:59 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-193.web.vodafone.de. [109.43.178.193])
        by smtp.gmail.com with ESMTPSA id b125-20020ae9eb83000000b0071eddd3bebbsm306099qkg.81.2023.04.06.01.30.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 01:30:59 -0700 (PDT)
Message-ID: <82060846-281f-8c30-6938-7ad35a8c5548@redhat.com>
Date:   Thu, 6 Apr 2023 10:30:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Janosch Frank <frankja@linux.ibm.com>, qemu-devel@nongnu.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-11-philmd@linaro.org>
 <3cccc7e6-3a39-b3b4-feaf-85a3faa58570@redhat.com>
 <3fe240da-9a75-0e39-7762-cd91af9ed3f0@linux.ibm.com>
 <c47e1b5a-38bb-fe08-8020-29361fd0e99a@linaro.org>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 10/10] hw/s390x: Rename pv.c -> pv-kvm.c
In-Reply-To: <c47e1b5a-38bb-fe08-8020-29361fd0e99a@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/04/2023 10.22, Philippe Mathieu-Daudé wrote:
> On 6/4/23 10:04, Janosch Frank wrote:
>> On 4/6/23 09:50, Thomas Huth wrote:
>>> On 05/04/2023 18.04, Philippe Mathieu-Daudé wrote:
>>>> Protected Virtualization is specific to KVM.
>>>> Rename the file as 'pv-kvm.c' to make this clearer.
>>>>
>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>>> ---
>>>>    hw/s390x/{pv.c => pv-kvm.c} | 0
>>>>    hw/s390x/meson.build        | 2 +-
>>>>    2 files changed, 1 insertion(+), 1 deletion(-)
>>>>    rename hw/s390x/{pv.c => pv-kvm.c} (100%)
>>>>
>>>> diff --git a/hw/s390x/pv.c b/hw/s390x/pv-kvm.c
>>>> similarity index 100%
>>>> rename from hw/s390x/pv.c
>>>> rename to hw/s390x/pv-kvm.c
>>>> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
>>>> index f291016fee..2f43b6c473 100644
>>>> --- a/hw/s390x/meson.build
>>>> +++ b/hw/s390x/meson.build
>>>> @@ -22,7 +22,7 @@ s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
>>>>      'tod-kvm.c',
>>>>      's390-skeys-kvm.c',
>>>>      's390-stattrib-kvm.c',
>>>> -  'pv.c',
>>>> +  'pv-kvm.c',
>>>>      's390-pci-kvm.c',
>>>>    ))
>>>>    s390x_ss.add(when: 'CONFIG_TCG', if_true: files(
>>>
>>> Hmmm, maybe we should rather move it to target/s390x/kvm/ instead?
>>>
>>> Janosch, what's your opinion?
>>>
>>>    Thomas
>>>
>>>
>>
>> Don't care as long as the file is not deleted :)
> 
> I followed the current pattern:
> 
> $ ls -1 hw/s390x/*kvm*
> hw/s390x/s390-pci-kvm.c
> hw/s390x/s390-skeys-kvm.c
> hw/s390x/s390-stattrib-kvm.c
> hw/s390x/tod-kvm.c

There's a differences for those: First, these devices have an implementation 
that works with TCG, too. Second, protected virtualization (pv) is not a 
real hardware device, it's a feature of the firmware on s390x that is 
exposed to userspace via the KVM interface. So target/s390x/kvm/ slightly 
sounds like a better place to me ... no strong opinion, though.

  Thomas

