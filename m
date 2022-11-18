Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9451162F7EF
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 15:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242519AbiKROln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 09:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241721AbiKROlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 09:41:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF2A970AF
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 06:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668782250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UPk972akfZfuwBephZFAJS92+OaEvfxCgvAwmUwC+Mw=;
        b=YUtvkGSgPPfgA7l0qfbnCJ9GvL5fr/n+069bmlGWeMryG2A2RBNICl2IdYqxE1SyuoiiQ1
        KltbpZiq6E2tmipxCagAbNmWkTRN54N4ulxCGZfN1A5VBBxErnOwdXlQ4+NuRWZ8CTD/cH
        z1eP+kaj+iZMeRkcfYFjv5zrmV4DWfs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-62-BlzoUhxeOVOSza3-2EAeqA-1; Fri, 18 Nov 2022 09:37:29 -0500
X-MC-Unique: BlzoUhxeOVOSza3-2EAeqA-1
Received: by mail-wm1-f69.google.com with SMTP id m34-20020a05600c3b2200b003cf549cb32bso4567825wms.1
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 06:37:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UPk972akfZfuwBephZFAJS92+OaEvfxCgvAwmUwC+Mw=;
        b=ST0MblOIFV1bZckHono3MKn/YuBENwUhLlnTIhn1STyNerZgxRmw9yj6G9LIBI4BUT
         qX4cb5OFuE5ugDmnAZld6xUgk0z2LMC9ZLtICCa0pd1vwtjLMpS07b+s5I3jOfxDXbE3
         CCyLufCDVI2XfKO/sR5Am3LayJzsOjQwH4l6OPDlNDgg9SWkSKZBjLfcjucPOzF/2v7H
         d28zGdbkUDQq82etQlIEE9yNic6vcZ7Wx9yujGMgmKyasiManMWFSeUIhTpft3POVc6Y
         eb7+TBbmcg5nvwDLq9GUtk8pPhj0UmlDszNfiaeIkXz/KI13SVBIMKhPL0zmsPTLloRw
         svjg==
X-Gm-Message-State: ANoB5pkCs78xi22owm1KHAeXeu2i6O47naCv8/VeIZCjsmhcATyJiri7
        1ZMp1CHAOydSEsTUsn3f7WtQt7GYmA9Qjg/s3af9ynDnKDlM9ifSDPo3g0+TqA0Re1WaNW5j1+r
        rNPw/k/LHvG4s
X-Received: by 2002:a5d:4c8c:0:b0:241:c222:e27e with SMTP id z12-20020a5d4c8c000000b00241c222e27emr357999wrs.236.1668782248585;
        Fri, 18 Nov 2022 06:37:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7PlKqWjn8KTrQXB14vUIs9jaDWsY5UxLsFjeau3btWbKZTTI09DoC0fRcoqZTqg7scz4TrfQ==
X-Received: by 2002:a5d:4c8c:0:b0:241:c222:e27e with SMTP id z12-20020a5d4c8c000000b00241c222e27emr357982wrs.236.1668782248374;
        Fri, 18 Nov 2022 06:37:28 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-177-78.web.vodafone.de. [109.43.177.78])
        by smtp.gmail.com with ESMTPSA id he5-20020a05600c540500b003cfd4e6400csm4824578wmb.19.2022.11.18.06.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 06:37:27 -0800 (PST)
Message-ID: <90f07edc-238f-b3d0-80d2-f4b4573f12ad@redhat.com>
Date:   Fri, 18 Nov 2022 15:37:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 1/9] KVM: s390: Extend MEM_OP ioctl by storage key
 checked cmpxchg
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20221117221758.66326-1-scgl@linux.ibm.com>
 <20221117221758.66326-2-scgl@linux.ibm.com> <Y3dalbP5yb2gflA9@osiris>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <Y3dalbP5yb2gflA9@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/2022 11.12, Heiko Carstens wrote:
> On Thu, Nov 17, 2022 at 11:17:50PM +0100, Janis Schoetterl-Glausch wrote:
>> User space can use the MEM_OP ioctl to make storage key checked reads
>> and writes to the guest, however, it has no way of performing atomic,
>> key checked, accesses to the guest.
>> Extend the MEM_OP ioctl in order to allow for this, by adding a cmpxchg
>> mode. For now, support this mode for absolute accesses only.
>>
>> This mode can be use, for example, to set the device-state-change
>> indicator and the adapter-local-summary indicator atomically.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>   include/uapi/linux/kvm.h |   5 ++
>>   arch/s390/kvm/gaccess.h  |   3 ++
>>   arch/s390/kvm/gaccess.c  | 101 +++++++++++++++++++++++++++++++++++++++
>>   arch/s390/kvm/kvm-s390.c |  35 +++++++++++++-
>>   4 files changed, 142 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 0d5d4419139a..1f36be5493e6 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -588,6 +588,8 @@ struct kvm_s390_mem_op {
>>   		struct {
>>   			__u8 ar;	/* the access register number */
>>   			__u8 key;	/* access key, ignored if flag unset */
>> +			__u8 pad1[6];	/* ignored */
>> +			__u64 old_p;	/* ignored if flag unset */
> 
> Just one comment: the suffix "_p" for pointer is quite unusual within
> the kernel. This also would be the first of its kind within kvm.h.
> Usually there is either no suffix or "_addr".
> So for consistency reasons I would suggest to change this to one of
> the common variants.
> 
> The code itself looks good from my point of view, even though for the
> sake of simplicity I would have put the complete sign/zero extended
> 128 bit old value into the structure, instead of having a pointer to
> the value.

See 
https://lore.kernel.org/kvm/37197cfe-d109-332f-089b-266d7e8e23f8@redhat.com/ 
... it would break the "IOW" definition of the ioctl. It can be done, but 
that confuses tools like valgrind, as far as I know. So I think the idea 
with the pointer is better in this case.

  Thomas

