Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D13734ABB
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 05:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjFSDpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jun 2023 23:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjFSDpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Jun 2023 23:45:36 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB454114;
        Sun, 18 Jun 2023 20:45:33 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.43:57978.1471128269
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-114.242.206.180 (unknown [10.64.8.43])
        by 189.cn (HERMES) with SMTP id 505FA10029B;
        Mon, 19 Jun 2023 11:45:30 +0800 (CST)
Received: from  ([114.242.206.180])
        by gateway-151646-dep-75648544bd-7vx9t with ESMTP id 7239e2ea64ab49028b0edbdbd8b976d0 for macro@orcam.me.uk;
        Mon, 19 Jun 2023 11:45:32 CST
X-Transaction-ID: 7239e2ea64ab49028b0edbdbd8b976d0
X-Real-From: 15330273260@189.cn
X-Receive-IP: 114.242.206.180
X-MEDUSA-Status: 0
Sender: 15330273260@189.cn
Message-ID: <c53476a4-fbc9-00e9-d47d-51a4ce5b9259@189.cn>
Date:   Mon, 19 Jun 2023 11:45:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v7 2/8] PCI/VGA: Deal only with VGA class devices
Content-Language: en-US
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Sui Jingfeng <suijingfeng@loongson.cn>
References: <20230613030151.216625-1-15330273260@189.cn>
 <20230613030151.216625-3-15330273260@189.cn>
 <alpine.DEB.2.21.2306190339590.14084@angie.orcam.me.uk>
From:   Sui Jingfeng <15330273260@189.cn>
In-Reply-To: <alpine.DEB.2.21.2306190339590.14084@angie.orcam.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2023/6/19 11:02, Maciej W. Rozycki wrote:
> On Tue, 13 Jun 2023, Sui Jingfeng wrote:
>
>> Deal only with the VGA devcie(pdev->class == 0x0300), so replace the
>   Typo here: s/devcie/device/.
Thanks a lot,
>> pci_get_subsys() function with pci_get_class(). Filter the non-PCI display
>> device(pdev->class != 0x0300) out. There no need to process the non-display
>> PCI device.
>   I've only come across this patch series now.  Without diving into what
> this code actually does I have just one question as a matter of interest.
>
>> diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
>> index c1bc6c983932..22a505e877dc 100644
>> --- a/drivers/pci/vgaarb.c
>> +++ b/drivers/pci/vgaarb.c
>> @@ -1500,7 +1496,9 @@ static int pci_notify(struct notifier_block *nb, unsigned long action,
>>   	struct pci_dev *pdev = to_pci_dev(dev);
>>   	bool notify = false;
>>   
>> -	vgaarb_dbg(dev, "%s\n", __func__);
>> +	/* Only deal with VGA class devices */
>> +	if (pdev->class != PCI_CLASS_DISPLAY_VGA << 8)
>> +		return 0;
>   Hmm, shouldn't this also handle PCI_CLASS_NOT_DEFINED_VGA?

If your machine have only one such a VGA card, it probably don't hurt.

But, such a card will also get ignored originally (before applying this 
patch).

>   As far as I
> know it is the equivalent of PCI_CLASS_DISPLAY_VGA for PCI <= 2.0 devices
> that were implemented before the idea of PCI device classes has developed
> into its current form.

If multiple video card problems on your machine is matter,

then I think it do deserve another patch to clarify this issue and to 
explain the rationale.

>   I may have such a VGA device somewhere.
>
>    Maciej
