Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00AE53FABF
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 12:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbiFGKDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 06:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240587AbiFGKDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 06:03:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44F429CCA7
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 03:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654596195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tn8n2EP4nBOl/jeJiKD2hmW0PfLCuCcbPrCveEkgN4I=;
        b=Kq5Qy2+y1dhPOajOPr7gEt+WCpKvzFTbbQPD5v4roJzuMqJkZjXkLmaCJ0B7ZdRFdZGcRs
        CMo/36M3/SrHouZGw/jpWc4cxejcNQesiC2HO8qocQghlgHKFFo68lmtbCTA8+toVpOHcn
        Dd7N7IgUhZweZ8l45PyMB85F2mYQtmI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-7Fio7RLvN_2dMqGlfkVvoA-1; Tue, 07 Jun 2022 06:03:14 -0400
X-MC-Unique: 7Fio7RLvN_2dMqGlfkVvoA-1
Received: by mail-qk1-f198.google.com with SMTP id s11-20020a05620a254b00b006a6a23ff939so8551159qko.17
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 03:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tn8n2EP4nBOl/jeJiKD2hmW0PfLCuCcbPrCveEkgN4I=;
        b=UIJkfbFGStc+r121tvvw1hg1oxeynudOFVoQMSCjSQPSiuSR4ZYRrNCVqdAna5Q1Uu
         h7JyVzrd0bBLSzg4+f2tFfT/3O4HcASwssQBeaWBTL1MgZ0HuWBNJI4v1Q9JI4baC3wv
         viRbGsKaEXLOL4YvrXbGI1O2lUep6VF4LYXpdmvVSCkIBw+X7PghPDDKfEsMrXyttDIX
         WDGgt7W7DuKDsc6OhhIzr+7amq2usZRiiJTqLSQ5fh8EeaIzY8dhAZwI25pQHocZwKqB
         OnAH6x+1X+9wPMz91gDcWGv/1ZvuW8+WI9+bCJAFC5xYfEbfLliGqK7QCoekJ0GBMG+u
         eQxQ==
X-Gm-Message-State: AOAM530w/POLDrbZ4WhSnTzoezGff4bI6U4Rv+XVKSIEItrldFZrBqat
        uBDC+2sMy9E1GgY6JdlyJDujVs3rG9xwkJjP38jTGwdZqxo/fU5E7qksuZjgaJ4iHBpMhAWWlzE
        tzYYGLVwrgzJl
X-Received: by 2002:a05:6214:5004:b0:464:4b5d:be65 with SMTP id jo4-20020a056214500400b004644b5dbe65mr34443441qvb.73.1654596192510;
        Tue, 07 Jun 2022 03:03:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPByfw/hUG/Aux5xx0c3Tp0JOYTT5E6Si7SnvDulKoW6LpsUErEdVOqXXLDz37bjMJ8Lh6SA==
X-Received: by 2002:a05:6214:5004:b0:464:4b5d:be65 with SMTP id jo4-20020a056214500400b004644b5dbe65mr34443425qvb.73.1654596192116;
        Tue, 07 Jun 2022 03:03:12 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id az37-20020a05620a172500b006a6ebde4799sm462050qkb.90.2022.06.07.03.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 03:03:11 -0700 (PDT)
Message-ID: <e1ed09265061a2a2b7565b310c4384c358d377bd.camel@redhat.com>
Subject: Re: [PATCH v6 25/38] KVM: selftests: Move HYPERV_LINUX_OS_ID
 definition to a common header
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Jun 2022 13:03:08 +0300
In-Reply-To: <20220606083655.2014609-26-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
         <20220606083655.2014609-26-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-06 at 10:36 +0200, Vitaly Kuznetsov wrote:
> HYPERV_LINUX_OS_ID needs to be written to HV_X64_MSR_GUEST_OS_ID by
> each Hyper-V specific selftest.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/hyperv.h  | 3 +++
>  tools/testing/selftests/kvm/x86_64/hyperv_features.c | 5 ++---
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index b66910702c0a..f0a8a93694b2 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -185,4 +185,7 @@
>  /* hypercall options */
>  #define HV_HYPERCALL_FAST_BIT          BIT(16)
>  
> +/* Proper HV_X64_MSR_GUEST_OS_ID value */
> +#define HYPERV_LINUX_OS_ID ((u64)0x8100 << 48)
> +
>  #endif /* !SELFTEST_KVM_HYPERV_H */
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 672915ce73d8..98c020356925 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -14,7 +14,6 @@
>  #include "hyperv.h"
>  
>  #define VCPU_ID 0
> -#define LINUX_OS_ID ((u64)0x8100 << 48)
>  
>  extern unsigned char rdmsr_start;
>  extern unsigned char rdmsr_end;
> @@ -127,7 +126,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
>         int i = 0;
>         u64 res, input, output;
>  
> -       wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
> +       wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
>         wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
>  
>         while (hcall->control) {
> @@ -230,7 +229,7 @@ static void guest_test_msrs_access(void)
>                          */
>                         msr->idx = HV_X64_MSR_GUEST_OS_ID;
>                         msr->write = 1;
> -                       msr->write_val = LINUX_OS_ID;
> +                       msr->write_val = HYPERV_LINUX_OS_ID;
>                         msr->available = 1;
>                         break;
>                 case 3:
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

