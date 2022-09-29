Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C095EFC02
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 19:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbiI2R25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 13:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236204AbiI2R2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 13:28:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B961F0CE5
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 10:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664472532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ee74vZ2+nDWj/8Ky/P/PwQkAspnTrwNqbrRcVZAkfE8=;
        b=H6i7xgIB5d6nAklnqBtEOl8AcmzFD7sU19TPerK4lVOFkwZFFuvOI4xlGGZNvuw3q7HLL9
        GVeDav7bWoTHSAq5ZvafPQyB2ktpIBpojZPz6qIY0T6n532Um7VqUH5CQ87oIyQU3Jx33X
        MuPIV1cWsAm5urfGgkJpb0wxx1W66HA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-398-kEAb_7mZOkCPYVlcWjsThA-1; Thu, 29 Sep 2022 13:28:49 -0400
X-MC-Unique: kEAb_7mZOkCPYVlcWjsThA-1
Received: by mail-ed1-f69.google.com with SMTP id h13-20020a056402280d00b004581108ba90so1759923ede.2
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 10:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ee74vZ2+nDWj/8Ky/P/PwQkAspnTrwNqbrRcVZAkfE8=;
        b=uu8kPqQU8yWYgkWsORzsIDn27AJzPtHMsproACzbswiMYmq+IYWX8nKcB6YbPt/Z79
         JFH+VlwTpLSukxCBbmKrBlntSpch1FpeP18/5KwlOoPMpT8z/1w/XzB6x38JzeHFEUMq
         bHT6eraHkzf4wxHGMHKcU/az+fVddh3ofL8AUIkBUG4h56BIrOdV3eVlaqCMm9vBQBGs
         t+wl2BTEyCWywKGrriRpnI6SW/S5RIV2ssBS+TRK43CrBLueLGlcVyWweFj4q2RexyNF
         ZMJbFug7I/6GVGl0fRPh+nyuGdESrCZ77DjpqB5WgiEihVpvtdgYahWYp1RGxe3u6Xnh
         +X7A==
X-Gm-Message-State: ACrzQf1WD99DzS00FOOfWy8lUCPRqX7UxTatVjX+fP5glzQX6S2waM7+
        59l3w+FGvQAcp5zmQo+5ZmopTl1s6aUGl+MxuYNGLm71R6US4C92qdIt8LDEImOVa6lkuRuolKD
        uwXiCiKIwaLQ0
X-Received: by 2002:a05:6402:1e8d:b0:441:58db:b6a2 with SMTP id f13-20020a0564021e8d00b0044158dbb6a2mr4182019edf.277.1664472528569;
        Thu, 29 Sep 2022 10:28:48 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6Bu9pW2u2b1ouHMGXN6IOcGYu9uUO0uGgZojVl1QDjEoqp3phmNzdNe+OzXBKTdTFjfCFIgQ==
X-Received: by 2002:a05:6402:1e8d:b0:441:58db:b6a2 with SMTP id f13-20020a0564021e8d00b0044158dbb6a2mr4182003edf.277.1664472528345;
        Thu, 29 Sep 2022 10:28:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id dk12-20020a0564021d8c00b0044e8d0682b2sm38807edb.71.2022.09.29.10.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 10:28:47 -0700 (PDT)
Message-ID: <d20d8f67-2ad9-7b87-71f6-011aab7b6ba5@redhat.com>
Date:   Thu, 29 Sep 2022 19:28:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v8 0/4] Enable notify VM exit
Content-Language: en-US
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220929070341.4846-1-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220929070341.4846-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/22 09:03, Chenyi Qiang wrote:
> Notify VM exit is introduced to mitigate the potential DOS attach from
> malicious VM. This series is the userspace part to enable this feature
> through a new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT. The detailed
> info can be seen in Patch 4.
> 
> The corresponding KVM support can be found in linux 6.0-rc:
> (2f4073e08f4c KVM: VMX: Enable Notify VM exit)

Thanks, I will queue this in my next pull request.

Paolo

> ---
> Change logs:
> v7 -> v8
> - Add triple_fault_pending field transmission on migration (Paolo)
> - Change the notify-vmexit and notify-window to the accelerator property. Add it as
>    a x86-specific property. (Paolo)
> - Add a preparation patch to expose struct KVMState in order to add target-specific property.
> - Define three option for notify-vmexit. Make it on by default. (Paolo)
> - Raise a KVM internal error instead of triple fault if invalid context of guest VMCS detected.
> - v7: https://lore.kernel.org/qemu-devel/20220923073333.23381-1-chenyi.qiang@intel.com/
> 
> v6 -> v7
> - Add a warning message when exiting to userspace (Peter Xu)
> - v6: https://lore.kernel.org/all/20220915092839.5518-1-chenyi.qiang@intel.com/
> 
> v5 -> v6
> - Add some info related to the valid range of notify_window in patch 2. (Peter Xu)
> - Add the doc in qemu-options.hx. (Peter Xu)
> - v5: https://lore.kernel.org/qemu-devel/20220817020845.21855-1-chenyi.qiang@intel.com/
> 
> ---
> 
> Chenyi Qiang (3):
>    i386: kvm: extend kvm_{get, put}_vcpu_events to support pending triple
>      fault
>    kvm: expose struct KVMState
>    i386: add notify VM exit support
> 
> Paolo Bonzini (1):
>    kvm: allow target-specific accelerator properties
> 
>   accel/kvm/kvm-all.c      |  78 ++-----------------------
>   include/sysemu/kvm.h     |   2 +
>   include/sysemu/kvm_int.h |  75 ++++++++++++++++++++++++
>   qapi/run-state.json      |  17 ++++++
>   qemu-options.hx          |  11 ++++
>   target/arm/kvm.c         |   4 ++
>   target/i386/cpu.c        |   1 +
>   target/i386/cpu.h        |   1 +
>   target/i386/kvm/kvm.c    | 121 +++++++++++++++++++++++++++++++++++++++
>   target/i386/machine.c    |  20 +++++++
>   target/mips/kvm.c        |   4 ++
>   target/ppc/kvm.c         |   4 ++
>   target/riscv/kvm.c       |   4 ++
>   target/s390x/kvm/kvm.c   |   4 ++
>   14 files changed, 272 insertions(+), 74 deletions(-)
> 

