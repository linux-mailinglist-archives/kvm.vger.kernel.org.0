Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2620977DB66
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 09:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242538AbjHPHy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 03:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbjHPHx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 03:53:56 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E5AB196;
        Wed, 16 Aug 2023 00:53:53 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Cxc_CQgNxkbwwZAA--.51565S3;
        Wed, 16 Aug 2023 15:53:52 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxLCOPgNxkttJbAA--.9822S3;
        Wed, 16 Aug 2023 15:53:51 +0800 (CST)
Message-ID: <624efb22-8723-d813-0943-edab2870b51d@loongson.cn>
Date:   Wed, 16 Aug 2023 15:53:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mike.kravetz@oracle.com, apopple@nvidia.com,
        jgg@nvidia.com, rppt@kernel.org, akpm@linux-foundation.org,
        kevin.tian@intel.com, david@redhat.com
References: <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com>
 <ZNZshVZI5bRq4mZQ@google.com> <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com>
 <ZNpZDH9//vk8Rqvo@google.com> <ZNra3eDNTaKVc7MT@yzhao56-desk.sh.intel.com>
 <ZNuQ0grC44Dbh5hS@google.com>
 <107cdaaf-237f-16b9-ebe2-7eefd2b21f8f@loongson.cn>
 <c8ccc8f1-300a-09be-db6b-df2a1dedd4cf@loongson.cn>
 <ZNxbLPG8qbs1FjhM@yzhao56-desk.sh.intel.com>
 <42ff33c7-ec50-1310-3e57-37e8283b9b16@loongson.cn>
 <ZNx4OoRQvyh3A0BL@yzhao56-desk.sh.intel.com>
From:   bibo mao <maobibo@loongson.cn>
In-Reply-To: <ZNx4OoRQvyh3A0BL@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxLCOPgNxkttJbAA--.9822S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoWrKw1DGr48WrWDZFykKw13WrX_yoW3Krg_u3
        yrGr9rKw45GrW7ta12yF4UXrW2gF1rWFWDZ3y09ay2g343Ja48JrWxGas7XFy2y34rGF98
        Crn0va1fW3yavosvyTuYvTs0mTUanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvT
        s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
        cSsGvfJTRUUUbqkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
        vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
        6r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
        1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVW8ZVWrXwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07joc_-UUU
        UU=
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/8/16 15:18, Yan Zhao 写道:
> On Wed, Aug 16, 2023 at 03:29:22PM +0800, bibo mao wrote:
>>> Flush must be done before kvm->mmu_lock is unlocked, otherwise,
>>> confusion will be caused when multiple threads trying to update the
>>> secondary MMU.
>> Since tlb flush is delayed after all pte entries are cleared, and currently
>> there is no tlb flush range supported for secondary mmu. I do know why there
>> is confusion before or after kvm->mmu_lock.
> 
> Oh, do you mean only do kvm_unmap_gfn_range() in .invalidate_range_end()?
yes, it is just sketchy thought for numa balance scenery, 
do kvm_unmap_gfn_range() in invalidate_range_end rather than
invalidate_range_start.
 
> Then check if PROT_NONE is set in primary MMU before unmap?
> Looks like a good idea, I need to check if it's feasible.
> Thanks!
> 
> 

