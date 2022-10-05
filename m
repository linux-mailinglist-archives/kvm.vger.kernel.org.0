Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA3E5F4FD0
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 08:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJEGcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 02:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiJEGcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 02:32:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAA574BA3
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 23:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664951558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i2fZF5NpPxB+zfptp/E3otmQs3yA+XxyrCxE6wqs+1E=;
        b=OSM4ra3N3OxoF2d9th2aaXP8EvvHu4ECl1mGAALy/BxRGLuF+BF4vZGFBCPWHfnls049na
        JUGd8Q9jDTaQGqwGAx4b2EUClk/xybEh8fXc1yYiHClMD2QpIGgZ+DY5orml3uc4tpSXSz
        gjVzw1fTU7sbIUuYj2BGLR3YpacvPVM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-115-VxFdeY2NNTC8YYb-NY964w-1; Wed, 05 Oct 2022 02:32:37 -0400
X-MC-Unique: VxFdeY2NNTC8YYb-NY964w-1
Received: by mail-wm1-f70.google.com with SMTP id z14-20020a05600c220e00b003be0a6b3b13so120614wml.8
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 23:32:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=i2fZF5NpPxB+zfptp/E3otmQs3yA+XxyrCxE6wqs+1E=;
        b=i22ftr53wfUVpOjJpspXy0M9rPQ8jXvtKBqUYLtzcKJugQdBxlG4Kjvy/llF8yFooc
         M//omdGO4O75VT2d9PdHrfqE3CPnkXZj5/mlp7zBdSD04/2p4qClBda5/q0IwnLwyD+q
         jz6OeWNGvn537yJbXc+MdLjvIrRNAZv5xhNTOcNkzVLrFVqelRz1+4C5pxS0ue0xOx/w
         C/hbdjdSLKR4XL9aFYMw5wPLRIdOlPIVKqjpN0i0hG4OcY0hCn3Atov1vShAsWC/I0ta
         jNyIAsXaCA7hfCLAK38XgWKJifiGDOPComlmWv8MHGOp9U33Du09Wkr8z8FHLMAD3Kzv
         h16Q==
X-Gm-Message-State: ACrzQf1sYAE31SnG2+lc4J62mlMHk+7wcYhZw+hQEBcXhz2UwTONJA/I
        K8lXkmNRlgFQam9KggHu0sdgBdmWoqRIFeJrWzEiukZ4RMCpSq+KxLBk4gNR1XEay6BwciBttM9
        qa0H6wjAjNpjT
X-Received: by 2002:a05:600c:1549:b0:3b4:8fd7:af4 with SMTP id f9-20020a05600c154900b003b48fd70af4mr2124933wmg.100.1664951556628;
        Tue, 04 Oct 2022 23:32:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6oN6PV4QL5PeEwB3AulW8hy8JRxoJitj3BA4H8xzN2l786Y0utSyQ0xn5AhPGpmYJfRD5rnQ==
X-Received: by 2002:a05:600c:1549:b0:3b4:8fd7:af4 with SMTP id f9-20020a05600c154900b003b48fd70af4mr2124913wmg.100.1664951556442;
        Tue, 04 Oct 2022 23:32:36 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-177-249.web.vodafone.de. [109.43.177.249])
        by smtp.gmail.com with ESMTPSA id s16-20020a1cf210000000b003a5f3f5883dsm997040wmc.17.2022.10.04.23.32.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 23:32:35 -0700 (PDT)
Message-ID: <37197cfe-d109-332f-089b-266d7e8e23f8@redhat.com>
Date:   Wed, 5 Oct 2022 08:32:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v1 2/9] KVM: s390: Extend MEM_OP ioctl by storage key
 checked cmpxchg
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
 <20220930210751.225873-3-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220930210751.225873-3-scgl@linux.ibm.com>
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
> User space can use the MEM_OP ioctl to make storage key checked reads
> and writes to the guest, however, it has no way of performing atomic,
> key checked, accesses to the guest.
> Extend the MEM_OP ioctl in order to allow for this, by adding a cmpxchg
> mode. For now, support this mode for absolute accesses only.
> 
> This mode can be use, for example, to set the device-state-change
> indicator and the adapter-local-summary indicator atomically.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
> 
> 
> The return value of MEM_OP is:
>    0 on success,
>    < 0 on generic error (e.g. -EFAULT or -ENOMEM),
>    > 0 if an exception occurred while walking the page tables
> A cmpxchg failing because the old value doesn't match is neither an
> error nor an exception, so the question is how best to signal that
> condition. This is not strictly necessary since user space can compare
> the value of old after the MEM_OP with the value it set. If they're
> different the cmpxchg failed. It might be a better user interface if
> there is an easier way to see if the cmpxchg failed.
> This patch sets the cmpxchg flag bit to 0 on a successful cmpxchg.
> This way you can compare against a constant instead of the old old
> value.
> This has the disadvantage of being a bit weird, other suggestions
> welcome.

This also breaks the old API of defining the ioctl as _IOW only ... with 
your change to the flags field, it effectively gets IOWR instead.

Maybe it would be better to put all the new logic into a new struct and only 
pass a pointer to that struct in kvm_s390_mem_op, so that the ioctl stays 
IOW ? ... or maybe even introduce a completely new ioctl for this 
functionality instead?

  Thomas

