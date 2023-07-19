Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD4375A07A
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 23:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjGSVSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 17:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjGSVSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 17:18:45 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6F4F1FC0;
        Wed, 19 Jul 2023 14:18:43 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.43])
        by gateway (Coremail) with SMTP id _____8BxHOsyU7hkPm8HAA--.13941S3;
        Thu, 20 Jul 2023 05:18:42 +0800 (CST)
Received: from [10.20.42.43] (unknown [10.20.42.43])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxvM4yU7hk5xU1AA--.15484S3;
        Thu, 20 Jul 2023 05:18:42 +0800 (CST)
Message-ID: <184a570c-cd11-fc08-be63-3ff795dfc6d8@loongson.cn>
Date:   Thu, 20 Jul 2023 05:18:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 1/9] video/aperture: Add a helper to detect if an
 aperture contains firmware FB
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Sui Jingfeng <sui.jingfeng@linux.dev>
Cc:     David Airlie <airlied@gmail.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Helge Deller <deller@gmx.de>
References: <20230719204343.GA513226@bhelgaas>
From:   suijingfeng <suijingfeng@loongson.cn>
In-Reply-To: <20230719204343.GA513226@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf8CxvM4yU7hk5xU1AA--.15484S3
X-CM-SenderInfo: xvxlyxpqjiv03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9xXoWruFyDAFyrXFWxXFy8uFyrZrc_yoWDKFc_Ww
        43A3s29348JFZ2krn7Jr4rCrZYkayjkryjvas3tFs7Wry7tF4DXF1fCw1rWa45uryFyF15
        C398tF4Fkw13uosvyTuYvTs0mTUanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvT
        s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
        cSsGvfJTRUUUbDAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
        vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
        JVW8Jr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
        x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
        McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7
        I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCF
        x2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
        0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jFApnUUUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,


On 2023/7/20 04:43, Bjorn Helgaas wrote:
> On Wed, Jul 12, 2023 at 12:43:02AM +0800, Sui Jingfeng wrote:
>> From: Sui Jingfeng <suijingfeng@loongson.cn>
>>
>> This patch adds the aperture_contain_firmware_fb() function to do the
>> determination. Unfortunately, due to the fact that the apertures list
>> will be freed dynamically, the location and size information of the
>> firmware FB will be lost after dedicated drivers call
>> aperture_remove_conflicting_devices(),
>> aperture_remove_conflicting_pci_devices() or
>> aperture_remove_all_conflicting_devices() functions
>> We solve this problem by introducing two static variables that record the
>> firmware framebuffer's start addrness and end addrness. It assumes that the
>> system has only one active firmware framebuffer driver at a time. We don't
>> use the global structure screen_info here, because PCI resources may get
>> reallocated (the VRAM BAR could be moved) during the kernel boot stage.
> s/addrness/address/ (twice)


Will be fixed at the next version, thanks.


