Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4835F3E0D
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 10:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiJDIRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 04:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJDIRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 04:17:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEC1A45A
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 01:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664871390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s1Ke6vWjy6sZVOxZDv/F68Ltu/tjCrJKJ2xupBwFw+g=;
        b=YNq67rmo90yJe5xxkvUxqmkCAgD5P4nYsdc8LOkOE2/7Qfcf6X655FNxhxFZgXTBYs3Jx3
        UQJn+tLeQRj5W/C9nILkho1b9Q/UA5xWZ8zSF3Sg0b4+YTXVV04pLBj6QnHN7EYIR/aGcL
        avhVumLY2PRI9LBio0zrW+0zmMxN96g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-591-WJqFU0PvNY2AH1GYOCWTwA-1; Tue, 04 Oct 2022 04:16:29 -0400
X-MC-Unique: WJqFU0PvNY2AH1GYOCWTwA-1
Received: by mail-wm1-f69.google.com with SMTP id n32-20020a05600c3ba000b003b5054c71faso10503454wms.9
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 01:16:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=s1Ke6vWjy6sZVOxZDv/F68Ltu/tjCrJKJ2xupBwFw+g=;
        b=KdhZhELmK7EbsB3EbRzwKeXb4Q6P6SEcXkGBRcyDVWjt+CHGOvUBtX7xoR22d8v/jp
         FeeMDMT3mck8MbBHSaQIACiVJcR4fRkemnbzhmncXiYW4SxWK5in5V+wReSQCWgBkIp2
         nKkIGc1EVyMrTTXJ4i/a1OLV6Jf8uNmtcwAJLnNkm29uXaxZoXZ+PZCUq8diubznnCqk
         jgeuqK4cGx1vAB19PcJw+bWIX8gl5bD33vR/dY6SOaK1SdFPOhXCMxMYpHojVs8AIYYP
         mUaS2ZGMrq2Uc0pB/WcV++6efaB4ac1Qpygq0XV4uuDDUA/+QgfkpkdEIHfHuG/K8r0K
         wHNw==
X-Gm-Message-State: ACrzQf1GFqWb88okA5LwycKcbusCl3MPTvVbzzVSqi3B00eOus33O906
        19ta8igDzDEYzZ46DN0+vW1RHWjjt91gCZKhnqxdsdy7EDe8DduB2dYWmQw8kQEpoj4jrFYy2T1
        iMhn+9VqBIdi8
X-Received: by 2002:a05:600c:6026:b0:3b5:b00:3a5a with SMTP id az38-20020a05600c602600b003b50b003a5amr9273966wmb.108.1664871388231;
        Tue, 04 Oct 2022 01:16:28 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6AJR6ZKmOGetRSwFQXSiNVHL4YhpjeY5FFbBcjgQ7eWf8MFgd+CX5i7tPqgGgSKXx9pV9qqg==
X-Received: by 2002:a05:600c:6026:b0:3b5:b00:3a5a with SMTP id az38-20020a05600c602600b003b50b003a5amr9273945wmb.108.1664871388035;
        Tue, 04 Oct 2022 01:16:28 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-178-246.web.vodafone.de. [109.43.178.246])
        by smtp.gmail.com with ESMTPSA id b4-20020a05600003c400b0022a3a887ceasm11990805wrg.49.2022.10.04.01.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 01:16:27 -0700 (PDT)
Message-ID: <85399389-9b5a-d72a-5db1-b8418008ad58@redhat.com>
Date:   Tue, 4 Oct 2022 10:16:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v1 3/9] Documentation: KVM: s390: Describe
 KVM_S390_MEMOP_F_CMPXCHG
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20220930210751.225873-1-scgl@linux.ibm.com>
 <20220930210751.225873-4-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220930210751.225873-4-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/2022 23.07, Janis Schoetterl-Glausch wrote:
> Describe the semantics of the new KVM_S390_MEMOP_F_CMPXCHG flag for
> absolute vm write memops which allows user space to perform (storage key
> checked) cmpxchg operations on guest memory.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   Documentation/virt/kvm/api.rst | 18 +++++++++++++++++-
>   1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index abd7c32126ce..0e02d66e38ae 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3771,6 +3771,7 @@ Parameters are specified via the following structure::
>   		struct {
>   			__u8 ar;	/* the access register number */
>   			__u8 key;	/* access key, ignored if flag unset */

Padding / alignment?

> +			__u64 old[2];	/* ignored if flag unset */
>   		};
>   		__u32 sida_offset; /* offset into the sida */
>   		__u8 reserved[32]; /* ignored */
> @@ -3853,8 +3854,23 @@ Absolute accesses are permitted for non-protected guests only.
>   Supported flags:
>     * ``KVM_S390_MEMOP_F_CHECK_ONLY``
>     * ``KVM_S390_MEMOP_F_SKEY_PROTECTION``
> +  * ``KVM_S390_MEMOP_F_CMPXCHG``
> +
> +The semantics of the flags common with logical acesses are as for logical accesses.
> +
> +For write accesses, the KVM_S390_MEMOP_F_CMPXCHG might be supported.
> +In this case, instead of doing an unconditional write, the access occurs only
> +if the target location contains the value provided in "old". This is performed
> +as an atomic cmpxchg. "size" must be a power of two up to and including 16.
> +Values with sizes <8 byte are to be provided by assignment to "old[1]".
> +Doublewords are provided with the higher value word in "old[0]" and the lower
> +word in "old[1]".
> +The value at the target location is returned in "old", encoded in the same manner.
> +If the value was exchanged the KVM_S390_MEMOP_F_CMPXCHG bit in "flags" is set to
> +0, otherwise it remains set.
> +The KVM_S390_MEMOP_F_CMPXCHG flag is supported if KVM_CAP_S390_MEM_OP_EXTENSION
> +has bit 1 (i.e. bit with value 2) set.

Please try to fit the text within 80 columns.

  Thanks,
   Thomas

