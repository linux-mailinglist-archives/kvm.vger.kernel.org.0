Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F96F69A362
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 02:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjBQB17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 20:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBQB15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 20:27:57 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73FCA1ADE6;
        Thu, 16 Feb 2023 17:27:55 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8DxXNoa2O5jfJUBAA--.3848S3;
        Fri, 17 Feb 2023 09:27:54 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bxzr4W2O5jl+80AA--.43407S3;
        Fri, 17 Feb 2023 09:27:51 +0800 (CST)
Subject: Re: [PATCH v1 01/24] LoongArch: KVM: Implement kvm module related
 interface
To:     Oliver Upton <oliver.upton@linux.dev>
References: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
 <20230214025648.1898508-2-zhaotianrui@loongson.cn>
 <Y+ssT+W27GxDRAAZ@kroah.com>
 <6fd2ca5a-7243-0627-79e9-8c8bd840adc2@loongson.cn>
 <Y+tbMwXjA0hkiUJA@kroah.com>
 <a44fc722-e3e2-7f8a-0454-f27a8a10d52b@loongson.cn>
 <Y+6FTC1vBeZoZx8V@linux.dev>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <9b7f86e9-d7a9-a197-03f8-c46af46c2b7a@loongson.cn>
Date:   Fri, 17 Feb 2023 09:27:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <Y+6FTC1vBeZoZx8V@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bxzr4W2O5jl+80AA--.43407S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7tr4rZr18CrWUJF45WF4kZwb_yoW8WFWfpF
        WjkFW8KFsYqr4fGrZ2yw1Ig3ZxCw4xJFsxua4Fqw4rZFW5GryxGF1xKF4qkFZYvw4kC3W0
        va4jvF9xC34qya7anT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bDAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UM2kK
        e7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI
        0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280
        aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2
        xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC
        6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
        026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF
        0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0x
        vE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUUUU=
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年02月17日 03:34, Oliver Upton 写道:
> On Tue, Feb 14, 2023 at 09:00:50PM +0800, Tianrui Zhao wrote:
>> 在 2023年02月14日 17:58, Greg Kroah-Hartman 写道:
>>> On Tue, Feb 14, 2023 at 05:00:56PM +0800, Tianrui Zhao wrote:
>>>>>> +#define KVM_GET_CSRS		_IOWR(KVMIO, 0xc5, struct kvm_csrs)
>>>>>> +#define KVM_SET_CSRS		_IOW(KVMIO,  0xc6, struct kvm_csrs)
>>>>> Why does this arch need new ioctls?
>>>> We want to use this ioctl to access multiple csrs at one time. If without
>>>> this, we only access one csr.
>>> What is wrong with accessing only one csr at a time?  Isn't this what
>>> other architectures do?
>> Generally, using KVM_GET_ONE_GET ioctl to get one reg, but we want a
>> more convenient interface to get serial regs at one time, so we add this
>> ioctl.
> Have you found register accesses through the KVM_{GET,SET}_ONE_REG
> ioctls to actually be a bounding issue? I'd be surprised if that were
> actually the case.
>
> An architecture-neutral implementation was entertained a few years ago
> [*], but even then it saved an inconsequential amount of time relative
> to the rest of VM serialization (at least for arm64). The one thing that
> series got right was to share the plumbing across all architectures that
> use the ONE_REG interface (i.e. everyone but x86).
>
> If you have data that supports the thesis that a batched ioctl is
> useful then please do share. But in any case this should not use an ioctl
> tied down to a single architecture.
>
> [*] https://lore.kernel.org/kvm/20201120125616.14436-1-darkhan@amazon.com/
>

Thanks for your explanation, and we have decided to remove this ioctls.

thanks,
Tianrui Zhao

