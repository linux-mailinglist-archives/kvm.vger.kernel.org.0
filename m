Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274606A008C
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 02:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbjBWBX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 20:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbjBWBX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 20:23:26 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D48D2005F;
        Wed, 22 Feb 2023 17:23:18 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8CxEZQEwPZj+uwDAA--.2399S3;
        Thu, 23 Feb 2023 09:23:16 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axvr4CwPZjolc5AA--.43950S3;
        Thu, 23 Feb 2023 09:23:15 +0800 (CST)
Subject: Re: [PATCH v2 06/29] LoongArch: KVM: Implement vcpu create and
 destroy interface
To:     Paolo Bonzini <pbonzini@redhat.com>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-7-zhaotianrui@loongson.cn>
 <cbd95763-ec38-63f7-89bf-c8b01aa7df77@redhat.com>
 <abfa3fbc-e234-d0ab-ec35-90d9c251bf79@loongson.cn>
 <a9623c91-a28a-d91d-5311-fcfc4bd13247@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <bb5ad31a-cac1-bbfd-789a-a371eece4e9e@loongson.cn>
Date:   Thu, 23 Feb 2023 09:23:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <a9623c91-a28a-d91d-5311-fcfc4bd13247@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axvr4CwPZjolc5AA--.43950S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxJrWUJF4DGrW8Aw1kXr1UZFb_yoW8Gryxpa
        4kAan09r4DJryxJ3WqgF17ZFyI9rW8ZryUWF1DWrWUX3yDtrn3Ar18K3s8CF98ur1kZ3W0
        qFWvgFn5A3WYyrDanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
        n4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
        ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E
        87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
        AS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年02月22日 20:17, Paolo Bonzini 写道:
> On 2/22/23 02:52, Tianrui Zhao wrote:
>>>
>>>> +    vcpu->arch.guest_eentry = (unsigned long)kvm_context->kvm_eentry;
>>>> +    vcpu->arch.vcpu_run = kvm_context->kvm_enter_guest;
>>>> +    vcpu->arch.handle_exit = _kvm_handle_exit;
>>>
>>> Here as well, whatever is constant must not be stored in struct 
>>> kvm_arch_vcpu.
>>>
>>> Paolo
>>
>> Thanks,  we use this in vcpu_arch because the vcpu_arch is used as 
>> argument in switch.S' methods, we can quickly access the guest_eentry 
>> and handle_exit by using the  KVM_ARCH_GEENTRY, KVM_ARCH_HANDLE_EXIT 
>> offsets. If we change to global variable , we should relocate it in 
>> switch.S and may lead  to lower accessing speed.
>
> For guest_eentry and handle_exit this is correct so you can add a 
> comment in kvm_host.h, like
>
>     /* Pointers stored here for easy access from assembly code. */
>
> However, vcpu->arch.vcpu_run is not used in switch.S so there is no 
> need to store it in struct kvm_arch_vcpu.  Since you're already going 
> to move kvm_enter_guest out of kvm_context and into a global variable, 
> please give it the right pointer-to-function type instead of using 
> unsigned long.
>
> Paolo

Thanks, I will remove this vcpu_run and replace it with the new global 
variable, and fix the pointer-to-function type.

Thanks
Tianrui Zhao


