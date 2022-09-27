Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5116F5EBF7A
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 12:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiI0KMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 06:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbiI0KMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 06:12:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F366CBAEC
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 03:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664273521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OQd8FYCDQy3HQURocCej6OC1RjFJIa51YDrjxzf/0AM=;
        b=foBVWIyDcQ0vWJf1MEAZYcn8tUyRAacfeFLN9DjV/BxJzZaNS1yk7cLpwxTZK4mGpc5Z23
        BQAEk7bBR/YN0MgJnrKZPYc7GtZFmEqdVritDs38D8K+X7Nh+jtYRZoqtNN6Nn22nWgAR9
        /Fc9xncG2iMRskqT6/5sWDqZYH3cMU0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-550-k9unhw8QPGSd8u5Ej1RIUA-1; Tue, 27 Sep 2022 06:11:59 -0400
X-MC-Unique: k9unhw8QPGSd8u5Ej1RIUA-1
Received: by mail-ej1-f71.google.com with SMTP id sb34-20020a1709076da200b00783a5f786easo2456483ejc.22
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 03:11:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=OQd8FYCDQy3HQURocCej6OC1RjFJIa51YDrjxzf/0AM=;
        b=fdnrGHqTxTKjnQSWaVK1PX8UqXPOpatj3BieK0EPFB8IEyfj410n99zrwqryKK1a0Q
         dABSLmOkjbJJfHrcoQy9dOAcsCN0WhSjcb/vWXOTN2QAUsOUQnRlWf64ZLpEDsWAJHgQ
         2O+j1SZwk2prX7PjofsnDU3dhAN7i61M/JP+mR+l1swhrNBNIcT6Mz80f7eSU1IdJuPt
         lnbu43b/mnrR5ipgmAVUKbn6bzydTHfxQKnR4GIsgwjcxa51mV/Fqzn7gZZu3syKYHIq
         GMpOhgpc6kDyhFXHFCgdGceILaJ9jJ5M/9PRet7KEaIfzpZrqbehkvpPS1baJZkvtTka
         gFow==
X-Gm-Message-State: ACrzQf1hEqLLoIzSlbDdaPF7Zc/E7zMjHjZlxQ4kCGpmnxssA9agazJD
        PZ4/W3kQ/4X47jxDegjWTlQsF7Pzgm1zGDnv39V96hgrzRXWyuPMzoVuYu76Qsz7jUCnQ7A7+ff
        lo7JTThbtX6vd
X-Received: by 2002:a17:907:2d09:b0:781:d793:f51e with SMTP id gs9-20020a1709072d0900b00781d793f51emr4056431ejc.628.1664273518591;
        Tue, 27 Sep 2022 03:11:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5a/uFARed6CYSDEjLBgEocSIoC2LGZ4xrTfoHJ7Pq7WGxYRuIWKX+ve0FETVLwQS3Do7XTlg==
X-Received: by 2002:a17:907:2d09:b0:781:d793:f51e with SMTP id gs9-20020a1709072d0900b00781d793f51emr4056405ejc.628.1664273518308;
        Tue, 27 Sep 2022 03:11:58 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d41-20020a056402402900b0045703d699b9sm931101eda.78.2022.09.27.03.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 03:11:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86/hyperv: Move VMCB enlightenment definitions to
 hyperv-tlfs.h
In-Reply-To: <YyzgD0xp/Ki9a3jK@google.com>
References: <20220921201607.3156750-1-seanjc@google.com>
 <20220921201607.3156750-2-seanjc@google.com>
 <BYAPR21MB1688D04068DBA520366DA205D74E9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <YyzgD0xp/Ki9a3jK@google.com>
Date:   Tue, 27 Sep 2022 12:11:56 +0200
Message-ID: <87tu4tktxv.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Sep 22, 2022, Michael Kelley (LINUX) wrote:
>> From: Sean Christopherson <seanjc@google.com> Sent: Wednesday, September 21, 2022 1:16 PM
>> > 
>> > Move Hyper-V's VMCB enlightenment definitions to the TLFS header; the
>> > definitions come directly from the TLFS[*], not from KVM.
>> > 
>> > No functional change intended.
>> > 
>> > [*] https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_svm_enlightened_vmcb_fields> 
>> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>> > ---
>> >  arch/x86/include/asm/hyperv-tlfs.h | 22 +++++++++++++++++++
>> >  arch/x86/kvm/svm/hyperv.h          | 35 ------------------------------
>> >  arch/x86/kvm/svm/svm_onhyperv.h    |  3 ++-
>> >  3 files changed, 24 insertions(+), 36 deletions(-)
>> >  delete mode 100644 arch/x86/kvm/svm/hyperv.h
>> > 
>> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
>> > index 0a9407dc0859..4c4f81daf5a2 100644
>> > --- a/arch/x86/include/asm/hyperv-tlfs.h
>> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
>> > @@ -584,6 +584,28 @@ struct hv_enlightened_vmcs {
>> > 
>> >  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL			0xFFFF
>> > 
>> > +/*
>> > + * Hyper-V uses the software reserved 32 bytes in VMCB control area to expose
>> > + * SVM enlightenments to guests.
>> > + */
>> > +struct hv_enlightenments {
>> > +	struct __packed hv_enlightenments_control {
>> > +		u32 nested_flush_hypercall:1;
>> > +		u32 msr_bitmap:1;
>> > +		u32 enlightened_npt_tlb: 1;
>> > +		u32 reserved:29;
>> > +	} __packed hv_enlightenments_control;
>> > +	u32 hv_vp_id;
>> > +	u64 hv_vm_id;
>> > +	u64 partition_assist_page;
>> > +	u64 reserved;
>> > +} __packed;
>> > +
>> > +/*
>> > + * Hyper-V uses the software reserved clean bit in VMCB.
>> > + */
>> > +#define VMCB_HV_NESTED_ENLIGHTENMENTS		31
>> 
>> Is it feasible to change this identifier so it starts with HV_ like
>> everything else in this source code file, such as
>> HV_VMCB_NESTED_ENLIGHTENMENTS?  It doesn't look like it is
>> used in very many places.  
>
> Most definitely, IIRC it's used in only one spot.
>

I'll take these 4 patches to the next iteration of my "KVM: x86:
hyper-v: Fine-grained TLB flush + L2 TLB flush features" series and I'll
change VMCB_HV_NESTED_ENLIGHTENMENTS to HV_VMCB_NESTED_ENLIGHTENMENTS.

-- 
Vitaly

