Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D954BF425
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 09:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiBVIzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 03:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiBVIzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 03:55:38 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF67113AF6;
        Tue, 22 Feb 2022 00:55:13 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 139so16486910pge.1;
        Tue, 22 Feb 2022 00:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=SqY4RYApw/rHHyut2RadLb+KTBeKBHsZ8/ALJMCdqNE=;
        b=faNAiegRag9s5saBdxjWTeFqRea/WD3xlGpHuBQJjy2McR1wW9L2B0gQGOZirTTKCs
         Ihrhl5GIcgaxGp5R1ReXnRlXFgIBGx++PEjSUAAAbAMrjbWcV7mlLMCVWrrgPIRStBrC
         WvB+un22QNMpoBZb+nV0F9oVN3ZrF+FyNXWOEkYd5lDEUSBs98ryQQgBbU5ONNKHL9SN
         7H2VuyhDIJ6sp5yrcVPZCcxGhJAmkBZk9TSc4p3ieOC2kd6DiVqK0b2zSC2M0oImnK6o
         ozcam6HDhAMfW5Yy0TIETy639ML/jdqTqKj6MfJsjaTX48s3AXfcJwbIAaRB48/26hmX
         SiPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=SqY4RYApw/rHHyut2RadLb+KTBeKBHsZ8/ALJMCdqNE=;
        b=FkLe51JiDOX2qBAK93Rq+KqtyM/XmOWq7UiXATUvoF7u9BSPqgaetL2mfcWdqoYDVn
         aQLhCEEeAaglkWuu1ZBRIYFhfNQ6z+qfi4tnriDcCy+ZqvFNAzG1akb3gHry3zbaDK5U
         6XtEwLHTQevcVAH7qRSog8U8olpOgf2bUeM47zK+DUs2fJAuBykxoFdo0rUQdumPSE/9
         8yaH54YVGqa5VImngC1zsacvnukHNoZTo6AoVtD7YOZagDHnSzJamosztSGZpmZWVyKL
         DNYtDJflp2tOl+3vkZs6YN/Ni5NMnO+XhoFpo5efHEPvgeu8FLJdxDpLM75xKnHBwx39
         84cA==
X-Gm-Message-State: AOAM531vMa25fbjiy36GaBJNMKhKMjMZ/1hPDCEP7oFFSZ5B9u+U7ayj
        fp1fAgxo+MbEpCGDDs44KR7f2OYkpeSb80J2
X-Google-Smtp-Source: ABdhPJyuJQiciVxVpf4GaW18jm9TeGGaO05skl+jDGyMRgwMKpe9zhVQ2KqbiBKGZYCG8WqRNVFN1A==
X-Received: by 2002:a63:2d44:0:b0:34b:3f1b:952a with SMTP id t65-20020a632d44000000b0034b3f1b952amr18850180pgt.522.1645520113121;
        Tue, 22 Feb 2022 00:55:13 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id p4sm20218364pgh.53.2022.02.22.00.55.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 00:55:12 -0800 (PST)
Message-ID: <fb9e8765-33d8-5696-37bc-98e33c93f0c2@gmail.com>
Date:   Tue, 22 Feb 2022 16:54:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] KVM: x86: Fix function address when kvm_x86_ops.func is
 NULL
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220222062510.48592-1-likexu@tencent.com>
 <01ba8559-b6f9-cc75-2080-7308a04ce262@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <01ba8559-b6f9-cc75-2080-7308a04ce262@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/2/2022 4:33 pm, Paolo Bonzini wrote:
> On 2/22/22 07:25, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Fix the function address for __static_call_return0() which is used by
>> static_call_update() when a func in struct kvm_x86_ops is NULL.
>>
>> Fixes: 5be2226f417d ("KVM: x86: allow defining return-0 static calls")
>> Signed-off-by: Like Xu <likexu@tencent.com>
> 
> Sorry for the stupid question, but what breaks?

Although they are numerically the same, I suppose we should use the
& operator here, as in the other cases where __static_call_return0 is used.

What's more, Clang complains about the KVM_X86_OP_OPTIONAL_RET0 change:

./arch/x86/include/asm/kvm-x86-ops.h:108:1: warning: pointer type mismatch \
	('bool (*)(struct kvm_vcpu *)' (aka '_Bool (*)(struct kvm_vcpu *)') and 'void *') \
	[-Wpointer-type-mismatch]
and more warnings from [-Wpointer-type-mismatch]

Does it help you ?

> 
> Paolo
> 
>> ---
>>   arch/x86/include/asm/kvm_host.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 713e08f62385..312f5ee19514 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1548,7 +1548,7 @@ static inline void kvm_ops_static_call_update(void)
>>   #define KVM_X86_OP_OPTIONAL __KVM_X86_OP
>>   #define KVM_X86_OP_OPTIONAL_RET0(func) \
>>       static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
>> -               (void *) __static_call_return0);
>> +               (void *)&__static_call_return0);
>>   #include <asm/kvm-x86-ops.h>
>>   #undef __KVM_X86_OP
>>   }
> 
