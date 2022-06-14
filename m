Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7060654B41F
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355901AbiFNPCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350950AbiFNPCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:02:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20F343F315
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655218919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J0TyJoYQ26JBnYmZYgj7lHRpHCJIU5GdHdyAKYNVq4s=;
        b=BgJIrEg35r5MUlBNsa+PhoFVUy4e/dPj9XQNxJUtvr5DWuUEBY32vPJDP0+KgtD1PupZ5b
        AyzHJcl9mt2L5kUW5Z/JMSQ90yv+jgK+b1CHw548FvIOO0GIGPErzw8woh+C/cz9yznA0n
        igDnATc9rGPOtYtEZbt9j3S6mKNVSOs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-TBkkYLkdOf2v3Re_jRfoKQ-1; Tue, 14 Jun 2022 11:01:54 -0400
X-MC-Unique: TBkkYLkdOf2v3Re_jRfoKQ-1
Received: by mail-wm1-f70.google.com with SMTP id p6-20020a05600c358600b0039c873184b9so4461270wmq.4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=J0TyJoYQ26JBnYmZYgj7lHRpHCJIU5GdHdyAKYNVq4s=;
        b=cc8BO2yBE2MIYl6OWcz0a+TBCS/XDgoxQlc0h/X/9+qeomc6q4oB8OYQwDWChB+1aX
         MfOjjpo8H/4qeJxiT1AeRoL1XBeS3h2c0bODChhenbEUVoi71blP7BkzKo81u01aGnjY
         DLPjDW+I+JBwC0mnXdYf+92cukDLrTjPACtS+b8bKhlONvZjOcCc8kDpOLWPF6RnRszl
         lpmWuSoOF4TNlJFwpUYyD0RnPm6+tNHWTQxFdw34o/+9tEwK4jtUkSp1W3sPuLrBjNcV
         Y9ZFAI6c8e5TRZc4Zc9/Bgc3zlflV6/hdg7/OVsdLt1YMuSGrByGd3C3nIwYhxoVCXqR
         vpwA==
X-Gm-Message-State: AOAM530BmjcQB/Emm+hOxp+xKJHgqhsByS4d3t5wru2FbNlu9HkR4nMy
        Zdrm/MQnJ7SgsBDpZoF9o1iStf94xANPvBM+atfJeGa9fQJJ/sLpp40ulg4jXGRoSI9Lyb7Sed+
        kLg7sE1fA1wXa
X-Received: by 2002:a05:600c:4fd0:b0:39c:6565:31a5 with SMTP id o16-20020a05600c4fd000b0039c656531a5mr4672019wmq.60.1655218906970;
        Tue, 14 Jun 2022 08:01:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMIhlZbyecRjzqaqLq58DG7gWGNeWqK36G+IRce1uMWn4j2Niel2ejc1+7NC3ArykNox5mJg==
X-Received: by 2002:a05:600c:4fd0:b0:39c:6565:31a5 with SMTP id o16-20020a05600c4fd000b0039c656531a5mr4671978wmq.60.1655218906712;
        Tue, 14 Jun 2022 08:01:46 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c129100b0039754d1d327sm13356207wmd.13.2022.06.14.08.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 08:01:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     mail@anirudhrb.com, kumarpraveen@linux.microsoft.com,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        wei.liu@kernel.org, robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
In-Reply-To: <87sfo7igis.fsf@redhat.com>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <87sfo7igis.fsf@redhat.com>
Date:   Tue, 14 Jun 2022 17:01:45 +0200
Message-ID: <87pmjbi90m.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:
>
> ...
>
>>
>> As per the comments in arch/x86/kvm/vmx/evmcs.h, TSC multiplier field is
>> currently not supported in EVMCS.
>
> The latest version:
> https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_vmx_enlightened_vmcs
>
> has it, actually. It was missing before (compare with e.g. 6.0b version
> here:
> https://github.com/MicrosoftDocs/Virtualization-Documentation/raw/live/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v6.0b.pdf)
>
> but AFAIR TSC scaling wasn't advertised by genuine Hyper-V either.
> Interestingly enough, eVMCS version didn't change when these fields were
> added, it is still '1'.
>
> I even have a patch in my stash (attached). I didn't send it out because
> it wasn't properly tested with different Hyper-V versions.

And of course I forgot a pre-requisite patch which updates 'struct
hv_enlightened_vmcs' to the latest:

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 0a9407dc0859..038e5ef9b4a6 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -559,9 +559,20 @@ struct hv_enlightened_vmcs {
        u64 partition_assist_page;
        u64 padding64_4[4];
        u64 guest_bndcfgs;
-       u64 padding64_5[7];
+       u64 guest_ia32_perf_global_ctrl;
+       u64 guest_ia32_s_cet;
+       u64 guest_ssp;
+       u64 guest_ia32_int_ssp_table_addr;
+       u64 guest_ia32_lbr_ctl;
+       u64 padding64_5[2];
        u64 xss_exit_bitmap;
-       u64 padding64_6[7];
+       u64 host_ia32_perf_global_ctrl;
+       u64 encls_exiting_bitmap;
+       u64 tsc_multiplier;
+       u64 host_ia32_s_cet;
+       u64 host_ssp;
+       u64 host_ia32_int_ssp_table_addr;
+       u64 padding64_6;
 } __packed;
 
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                    0

-- 
Vitaly

