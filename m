Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92A7732883
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 09:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244499AbjFPHLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 03:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbjFPHLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 03:11:12 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A59E3170E;
        Fri, 16 Jun 2023 00:11:09 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.43])
        by gateway (Coremail) with SMTP id _____8Cx+ekMC4xkouAFAA--.12557S3;
        Fri, 16 Jun 2023 15:11:08 +0800 (CST)
Received: from [10.20.42.43] (unknown [10.20.42.43])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxZuQLC4xk+_0cAA--.16734S3;
        Fri, 16 Jun 2023 15:11:07 +0800 (CST)
Message-ID: <3c1c86ab-96ea-aa1c-c9c5-9a4012644fd6@loongson.cn>
Date:   Fri, 16 Jun 2023 15:11:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v7 2/8] PCI/VGA: Deal only with VGA class devices
Content-Language: en-US
To:     Alex Deucher <alexdeucher@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Sui Jingfeng <15330273260@189.cn>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-fbdev@vger.kernel.org, kvm@vger.kernel.org,
        nouveau@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, linux-pci@vger.kernel.org
References: <20230613030151.216625-1-15330273260@189.cn>
 <20230613030151.216625-3-15330273260@189.cn>
 <dbf0d89f-717a-1f78-aef2-f30506751d4d@loongson.cn>
 <CADnq5_N6vVtzH6tzguZdHnP_TdRoG1G-Cr94O+X03jvtk=vhag@mail.gmail.com>
From:   Sui Jingfeng <suijingfeng@loongson.cn>
Organization: Loongson
In-Reply-To: <CADnq5_N6vVtzH6tzguZdHnP_TdRoG1G-Cr94O+X03jvtk=vhag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxZuQLC4xk+_0cAA--.16734S3
X-CM-SenderInfo: xvxlyxpqjiv03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Xw1Utryrury5AF4rCFyrKrX_yoW7Ar48pF
        WrCay5KrW8JFy7C342qr1kXFyYv3sYya4rJF4rK3sakFZ0yr98WryrKry5u3yxGrZ5GF1I
        vw4UJF9rua9YqagCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jOa93UUU
        UU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2023/6/16 05:11, Alex Deucher wrote:
> On Wed, Jun 14, 2023 at 6:50 AM Sui Jingfeng <suijingfeng@loongson.cn> wrote:
>> Hi,
>>
>> On 2023/6/13 11:01, Sui Jingfeng wrote:
>>> From: Sui Jingfeng <suijingfeng@loongson.cn>
>>>
>>> Deal only with the VGA devcie(pdev->class == 0x0300), so replace the
>>> pci_get_subsys() function with pci_get_class(). Filter the non-PCI display
>>> device(pdev->class != 0x0300) out. There no need to process the non-display
>>> PCI device.
>>>
>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>>> Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
>>> ---
>>>    drivers/pci/vgaarb.c | 22 ++++++++++++----------
>>>    1 file changed, 12 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
>>> index c1bc6c983932..22a505e877dc 100644
>>> --- a/drivers/pci/vgaarb.c
>>> +++ b/drivers/pci/vgaarb.c
>>> @@ -754,10 +754,6 @@ static bool vga_arbiter_add_pci_device(struct pci_dev *pdev)
>>>        struct pci_dev *bridge;
>>>        u16 cmd;
>>>
>>> -     /* Only deal with VGA class devices */
>>> -     if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
>>> -             return false;
>>> -
>> Hi, here is probably a bug fixing.
>>
>> For an example, nvidia render only GPU typically has 0x0380.
>>
>> as its PCI class number, but render only GPU should not participate in
>> the arbitration.
>>
>> As it shouldn't snoop the legacy fixed VGA address.
>>
>> It(render only GPU) can not display anything.
>>
>>
>> But 0x0380 >> 8 = 0x03, the filter  failed.
>>
>>
>>>        /* Allocate structure */
>>>        vgadev = kzalloc(sizeof(struct vga_device), GFP_KERNEL);
>>>        if (vgadev == NULL) {
>>> @@ -1500,7 +1496,9 @@ static int pci_notify(struct notifier_block *nb, unsigned long action,
>>>        struct pci_dev *pdev = to_pci_dev(dev);
>>>        bool notify = false;
>>>
>>> -     vgaarb_dbg(dev, "%s\n", __func__);
>>> +     /* Only deal with VGA class devices */
>>> +     if (pdev->class != PCI_CLASS_DISPLAY_VGA << 8)
>>> +             return 0;
>> So here we only care 0x0300, my initial intent is to make an optimization,
>>
>> nowadays sane display graphic card should all has 0x0300 as its PCI
>> class number, is this complete right?
>>
>> ```
>>
>> #define PCI_BASE_CLASS_DISPLAY        0x03
>> #define PCI_CLASS_DISPLAY_VGA        0x0300
>> #define PCI_CLASS_DISPLAY_XGA        0x0301
>> #define PCI_CLASS_DISPLAY_3D        0x0302
>> #define PCI_CLASS_DISPLAY_OTHER        0x0380
>>
>> ```
>>
>> Any ideas ?
> I'm not quite sure what you are asking about here.

To be honest, I'm worried about the PCI devices which has a

PCI_CLASS_DISPLAY_XGA as its PCI class number.

As those devices are very uncommon in the real world.


$ find . -name "*.c" -type f | xargs grep "PCI_CLASS_DISPLAY_XGA"


Grep the "PCI_CLASS_DISPLAY_XGA" in the linux kernel tree got ZERO,

there no code reference this macro. So I think it seems safe to ignore 
the XGA ?


PCI_CLASS_DISPLAY_3D and PCI_CLASS_DISPLAY_OTHER are used to annotate 
the render-only GPU.

And render-only GPU can't decode the fixed VGA address space, it is safe 
to ignore them.


>   For vga_arb, we
> only care about VGA class devices since those should be on the only
> ones that might have VGA routed to them.

>   However, as VGA gets deprecated,

We need the vgaarb for a system with multiple video card.

Not only because some Legacy VGA devices implemented

on PCI will typically have the same "hard-decoded" addresses;

But also these video card need to participate in the arbitration,

determine the default boot device.


Nowadays, the 'VGA devices' here is stand for the Graphics card

which is capable of display something on the screen.

We still need vgaarb to select the default boot device.


> you'll have more non VGA PCI classes for devices which
> could be the pre-OS console device.

Ah, we still want  do this(by applying this patch) first,

and then we will have the opportunity to see who will crying if 
something is broken. Will know more then.

But drop this patch or revise it with more consideration is also 
acceptable.


I asking about suggestion and/or review.

> Alex
>
>>>        /* For now we're only intereted in devices added and removed. I didn't
>>>         * test this thing here, so someone needs to double check for the
>>> @@ -1510,6 +1508,8 @@ static int pci_notify(struct notifier_block *nb, unsigned long action,
>>>        else if (action == BUS_NOTIFY_DEL_DEVICE)
>>>                notify = vga_arbiter_del_pci_device(pdev);
>>>
>>> +     vgaarb_dbg(dev, "%s: action = %lu\n", __func__, action);
>>> +
>>>        if (notify)
>>>                vga_arbiter_notify_clients();
>>>        return 0;
>>> @@ -1534,8 +1534,8 @@ static struct miscdevice vga_arb_device = {
>>>
>>>    static int __init vga_arb_device_init(void)
>>>    {
>>> +     struct pci_dev *pdev = NULL;
>>>        int rc;
>>> -     struct pci_dev *pdev;
>>>
>>>        rc = misc_register(&vga_arb_device);
>>>        if (rc < 0)
>>> @@ -1545,11 +1545,13 @@ static int __init vga_arb_device_init(void)
>>>
>>>        /* We add all PCI devices satisfying VGA class in the arbiter by
>>>         * default */
>>> -     pdev = NULL;
>>> -     while ((pdev =
>>> -             pci_get_subsys(PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>>> -                            PCI_ANY_ID, pdev)) != NULL)
>>> +     while (1) {
>>> +             pdev = pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, pdev);
>>> +             if (!pdev)
>>> +                     break;
>>> +
>>>                vga_arbiter_add_pci_device(pdev);
>>> +     }
>>>
>>>        pr_info("loaded\n");
>>>        return rc;
>> --
>> Jingfeng
>>
-- 
Jingfeng

