Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866755FDE67
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 18:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiJMQmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 12:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiJMQmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 12:42:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605E814D1CD
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 09:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665679356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YBQyFVBuF/SKjPazJHlLgOwvTK+5LZv1rrMgf1acIpo=;
        b=OVmQtbgXw8JRQxULPqRWQKAJZDLB9izUGQeft0pktXCqzFbGURy6MNfMClXuR71mWvjdtu
        RdtMsHHkqGZ7pN3uZrrtZkDqp0urqzHL2IcC/HB1GWmPXaoSAMVPYKCkCCpb0u5ofGBAoE
        fRQReF4UU0DpyhSrxQmi1v7dd1tw3x4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-315-M4nhNGB8PiyM4DQ--AdYuA-1; Thu, 13 Oct 2022 12:42:35 -0400
X-MC-Unique: M4nhNGB8PiyM4DQ--AdYuA-1
Received: by mail-wm1-f71.google.com with SMTP id 133-20020a1c028b000000b003c5e6b44ebaso3160666wmc.9
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 09:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YBQyFVBuF/SKjPazJHlLgOwvTK+5LZv1rrMgf1acIpo=;
        b=F9dB5vty6lTiCe9NAOdShuz8IPh5yctrCfbyeYC/L9mTGvjxwOY5oVwAEV5YhgzONV
         0m/icVxwlBE1wEwcaNEoZI/b2fFsA20ALDYoejh1Xo2cSZcF2Q9QHoG4oWAlcRjt0RZI
         SLnwAvw8Tc6YQgqR5+Z1wFbm07Xc/Jin2YA9YXD2xmzYtsLc9jQIWxbCeAjRoax2bRPi
         2zad3Adho/7YFa8Gh2O3PyFPlmXg7Gv7GqkxHNWwByhoRwd5R9MahxRUILG2iTWwpDlA
         UnLaOFZaBa5QudpQUncT79bVOFXoqcBd4oaaPHU7cRfgjYU0iacxmAqVq1xJRu1LXM67
         I8lw==
X-Gm-Message-State: ACrzQf0AdUsbQ7U3KwpBsR8oAykAHKDQiiZY6dTYq6gTC6btrw9iBh9x
        ZOVjE0naW7gjWOjFMbuKhuJKw4e1DN9Z3lH+g8092Or76HP3BckVtOxPvWY8yAnEK15wWJdamsn
        nb9kzY9UkAQrw
X-Received: by 2002:a05:600c:1912:b0:3c6:e3cf:4335 with SMTP id j18-20020a05600c191200b003c6e3cf4335mr740380wmq.81.1665679354000;
        Thu, 13 Oct 2022 09:42:34 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM63OJlvg+GZtxl6mLYfE9Y5CCeBv34c5qID7pyf4ZqxFTU/m9Khf2eRtYMqinx72PY+/mPmQQ==
X-Received: by 2002:a05:600c:1912:b0:3c6:e3cf:4335 with SMTP id j18-20020a05600c191200b003c6e3cf4335mr740365wmq.81.1665679353762;
        Thu, 13 Oct 2022 09:42:33 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h5-20020adfe985000000b002322bff5b3bsm52198wrm.54.2022.10.13.09.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 09:42:32 -0700 (PDT)
Message-ID: <7f071249-b402-9534-c127-40af9379756d@redhat.com>
Date:   Thu, 13 Oct 2022 18:42:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: arm64: vgic: fix wrong loop condition in
 scan_its_table()
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, Eric Ren <renzhengeek@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm <kvmarm@lists.cs.columbia.edu>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
References: <acd9f1643980fbd27cd22523d2d84ca7c9add84a.1665592448.git.renzhengeek@gmail.com>
 <87o7ughoyf.wl-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <87o7ughoyf.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 10/12/22 20:33, Marc Zyngier wrote:
> Hi Eric,
> 
> Before I comment on this patch, a couple of things that need
> addressing:
> 
>> "Cc: marc.zyngier@arm.com, cdall@linaro.org"
> 
> None of these two addresses are valid anymore, and haven't been for
> several years.
> 
> Please consult the MAINTAINERS file for up-to-date addresses for
> current maintainers and reviewers, all of whom should be Cc'd on this
> email. I've now added them as well as Eric Auger who has written most
> of the ITS migration code, and the new mailing list (the Columbia list
> is about to be killed).
> 
> On Wed, 12 Oct 2022 17:59:25 +0100,
> Eric Ren <renzhengeek@gmail.com> wrote:
>>
>> Reproducer hints:
>> 1. Create ARM virt VM with pxb-pcie bus which adds
>>    extra host bridges, with qemu command like:
>>
>> ```
>>   -device pxb-pcie,bus_nr=8,id=pci.x,numa_node=0,bus=pcie.0 \
>>   -device pcie-root-port,..,bus=pci.x \
>>   ...
>>   -device pxb-pcie,bus_nr=37,id=pci.y,numa_node=1,bus=pcie.0 \
>>   -device pcie-root-port,..,bus=pci.y \
>>   ...
>>
>> ```
>> 2. Perform VM migration which calls save/restore device tables.
>>
>> In that setup, we get a big "offset" between 2 device_ids (
>> one is small, another is big), which makes unsigned "len" round
>> up a big positive number, causing loop to continue exceptionally.
> 
> You'll have to spell it out for me here. If you have a very sparse
> device ID and you are only using a single level device table, you are
> bound to have a large len. Now, is the issue that 'size' is so large
> that it is negative as an 'int'? Describing the exact situation you're
> in would help a lot.
> 
>>
>> Signed-off-by: Eric Ren <renzhengeek@gmail.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-its.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> index 24d7778d1ce6..673554ef02f9 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>> @@ -2141,7 +2141,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
>>  			  int start_id, entry_fn_t fn, void *opaque)
>>  {
>>  	struct kvm *kvm = its->dev->kvm;
>> -	unsigned long len = size;
>> +	ssize_t len = size;
> 
> This feels wrong, really. If anything, all these types should be
> unsigned, not signed. Signed types in this context make very little
> sense...

After digging into the code back again, I realized I told you something
wrong. The next_offset is the delta between the current device id and
the next one. The next device can perfectly be in a different L1 device
table, - it is your case actually- , in which case the code is
definitely broken.

So I guess we should rather have a
while (true) {
	../..
	if (byte_offset >= len)
		break;
	len -= byte_offset;
}

You can add a Fixes tag too:
Fixes: 920a7a8fa92a ("KVM: arm64: vgic-its: Add infrastructure for table
lookup")
and cc stable@vger.kernel.org

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

