Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2749369A36E
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 02:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBQBdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 20:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBQBdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 20:33:22 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73EB938E8D;
        Thu, 16 Feb 2023 17:33:20 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Cx75df2e5j5ZUBAA--.2743S3;
        Fri, 17 Feb 2023 09:33:19 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxQuVb2e5j2PA0AA--.63274S3;
        Fri, 17 Feb 2023 09:33:15 +0800 (CST)
Message-ID: <57be9198-5b8c-d0d2-2d6e-d1d4855bf38b@loongson.cn>
Date:   Fri, 17 Feb 2023 09:33:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v1 01/24] LoongArch: KVM: Implement kvm module related
 interface
To:     Oliver Upton <oliver.upton@linux.dev>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
References: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
 <20230214025648.1898508-2-zhaotianrui@loongson.cn>
 <Y+ssT+W27GxDRAAZ@kroah.com>
 <6fd2ca5a-7243-0627-79e9-8c8bd840adc2@loongson.cn>
 <Y+tbMwXjA0hkiUJA@kroah.com>
 <a44fc722-e3e2-7f8a-0454-f27a8a10d52b@loongson.cn>
 <Y+6FTC1vBeZoZx8V@linux.dev>
Content-Language: en-US
From:   maobibo <maobibo@loongson.cn>
In-Reply-To: <Y+6FTC1vBeZoZx8V@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxQuVb2e5j2PA0AA--.63274S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjvJXoW7tr4rZr18CF4DJryrGr47XFb_yoW8uw4fpa
        yjkF4UKF4qqr1Ig392yrnFg3Z8Cw4UJFsxZF1Fqw45AFWDJr1xCF4xKF4YkF9Fvr4kCF10
        vFyjq3s3urWqyrDanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bDAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UM2kK
        e7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI
        0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280
        aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2
        xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC
        6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67AKxVWUJVWUGwC20s
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



在 2023/2/17 03:34, Oliver Upton 写道:
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
>>
>> Generally, using KVM_GET_ONE ioctl to get one reg, but we want a
>> more convenient interface to get serial regs at one time, so we add this
>> ioctl.
> 
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
we found this issue during migration downtime stage, all vcpus will get
vcpu hw registers by KVM_GET_ONE_REG interface. If the virtual machine
has many vcpus, it will increase downtime time and reduce migration success
ratio; however it is just in theory and there is no actual data supporting
the point.

I am newbie for kvm:), and we will use KVM_GET_ONE_REG interface for loongarch
kvm for updated patches, which is common for all architectures. I just think
that it is normal to get many registers just like ptrace function, ptrace
regset API can be used to get many registers at one time.

Regards
Bibo, Mao



> 
> [*] https://lore.kernel.org/kvm/20201120125616.14436-1-darkhan@amazon.com/
> 

