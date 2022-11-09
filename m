Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED46622666
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 10:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiKIJMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 04:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiKIJLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 04:11:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CE722509
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 01:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667984995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gp1nu7gDdjQPLi62onKx+VMmcKi4JmumYYSuGwj42UE=;
        b=LdKLA2FXVctRvtCIUpblRGgkMXDjXdhza9IWOay45pNMe6IIf/Pcj3t0YDKUxeU4DEr7tB
        xc8+6wEmU9Zdwp3G+YdCfM8ibk7AMBe5iaEI/cHyik9k8vk9GwbSL2ZPaKneI3Bt5jR49w
        GLFdHP2CwhByfhUvfQEIXeNeFDeRFL8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-642-ZIFKMNSGPBeITOR-HvPt8Q-1; Wed, 09 Nov 2022 04:09:54 -0500
X-MC-Unique: ZIFKMNSGPBeITOR-HvPt8Q-1
Received: by mail-wm1-f70.google.com with SMTP id v125-20020a1cac83000000b003cfa148576dso4896212wme.3
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 01:09:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gp1nu7gDdjQPLi62onKx+VMmcKi4JmumYYSuGwj42UE=;
        b=aNzi+uCDxpBSgGFAop+vWa8sFwiekXvEx/dm1qqBVZRptpwqPR7hIT/GgW8M/+Mx7o
         lBZzjkqyvvWtj8Zyhl0KIm2dtWa4xyjtncHYeq+4JPuUGHP8HeQBowXSJVYiRLrRqaA4
         zBtWktvFHsTGX02dI5t4tI/ui90DKeKmJqGSu5lVmDS2/3oNCcKmP4+qkrV6ZfEcyzKT
         QF0a/XT7/vzPr2x7hpov3Yei5NDIQq/jgPLWZsWYSgIR9IoCu7Uf5KTN0rWzx1MzU5es
         nzOJmYxYa1j9tcvI9U0aHxSm0gazhSb6feA0MLc5c1lUruimgs/VIQOygReuJFcFohMo
         yCyg==
X-Gm-Message-State: ACrzQf1pOTtERAFDMy/r12tOxc9t2ZJ1eeO49xit5nlVbWgQfsB7Rfxq
        IAExx/ne/In0QWf+z5idaLxrc8Bl0Jt2nbSbl/IXMCunPXIPO9nCSegU4YZXC92+M7qKwb323aM
        PXQAuegZ313WY
X-Received: by 2002:a05:6000:16c8:b0:236:c60d:22b9 with SMTP id h8-20020a05600016c800b00236c60d22b9mr34218720wrf.526.1667984992769;
        Wed, 09 Nov 2022 01:09:52 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5b4W/+KStIQIEd31Opg71eedm54oI8YXOA25VraYMWJIMF7jYyeAE5P55LvkdaxbispEfo6g==
X-Received: by 2002:a05:6000:16c8:b0:236:c60d:22b9 with SMTP id h8-20020a05600016c800b00236c60d22b9mr34218703wrf.526.1667984992514;
        Wed, 09 Nov 2022 01:09:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id n19-20020a05600c3b9300b003b4c979e6bcsm1014454wms.10.2022.11.09.01.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 01:09:51 -0800 (PST)
Message-ID: <7ba6da25-9ce4-f146-8480-c2614154fbb4@redhat.com>
Date:   Wed, 9 Nov 2022 10:09:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 4/8] KVM: SVM: retrieve VMCB from assembly
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
References: <20221108151532.1377783-1-pbonzini@redhat.com>
 <20221108151532.1377783-5-pbonzini@redhat.com> <Y2r6FqZyT4XxUkYB@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2r6FqZyT4XxUkYB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/22 01:53, Sean Christopherson wrote:
> On Tue, Nov 08, 2022, Paolo Bonzini wrote:
>> This is needed in order to keep the number of arguments to 3 or less,
>> after adding hsave_pa and spec_ctrl_intercepted.  32-bit builds only
>> support passing three arguments in registers, fortunately all other
>> data is reachable from the vcpu_svm struct.
> 
> Is it actually a problem if parameters are passed on the stack?  The assembly
> code mostly creates a stack frame, i.e. %ebp can be used to pull values off the
> stack.

It's not, but given how little love 32-bit KVM receives, I prefer to 
stick to the subset of the ABI that is "equivalent" to 64-bit.

> no one cares about 32-bit and I highly doubt a few extra PUSH+POP
> instructions will  be noticeable.

Same reasoning (no one cares about 32-bits), different conclusions...

>> What fields are actually used is (like with any other function)
>> "potentially all, you'll have to read the source code and in fact you
>> can just read asm-offsets.c instead".  What I mean is, I cannot offhand
>> see or remember what fields are touched by svm_prepare_switch_to_guest,
>> why would __svm_vcpu_run be any different?
> 
> It's different because if it were a normal C function, it would simply take
> @vcpu, and maybe @spec_ctrl_intercepted to shave cycles after CLGI.

Not just for that, but especially to avoid making 
msr_write_intercepted() noinstr.

> But because
> it's assembly and doesn't have to_svm() readily available (among other restrictions),
> __svm_vcpu_run() ends up taking a mishmash of parameters, which for me makes it
> rather difficult to understand what to expect.

Yeah, there could be three reasons to have parameters in assembly:

* you just need them (@svm)

* it's too much of a pain to compute it in assembly 
(@spec_ctrl_intercepted, @hsave_pa)

* it needs to be computed outside the clgi/stgi region (not happening 
here, only mentioned for completeness)

As this patch shows, @vmcb is not much of a pain to compute in assembly: 
it is just two instructions, and not passing it in simplifies register 
allocation (the weird push/pop goes away) because all the arguments 
except @svm/_ASM_ARG1 are needed only after vmexit.

> Oooh, and after much staring I realized that the address of the host save area
> is passed in because grabbing it after VM-Exit can't work.  That's subtle, and
> passing it in isn't strictly necessary; there's no reason the assembly code can't
> grab it and stash it on the stack.

Right, in fact that's not the reason why it's passed in---it's just to 
avoid coding page_to_pfn() in assembly, and to limit the differences 
between the regular and SEV-ES cases.  But using a per-CPU variable is 
fine (either in addition to the struct page, which "wastes" 8 bytes per 
CPU, or as a replacement).

> What about killing a few birds with one stone?  Move the host save area PA to
> its own per-CPU variable, and then grab that from assembly as well.

I would still place it in struct svm_cpu_data itself, I'll see how it 
looks and possibly post v3.

Paolo

