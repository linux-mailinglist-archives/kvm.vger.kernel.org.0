Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1683451C5D5
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 19:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382498AbiEEROc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 13:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382500AbiEERO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 13:14:29 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9674B5C852
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 10:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651770645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MSaM/kFaxl/G15Cuy6NKT1yGgbW5/ComR9Zu67jESeY=;
        b=HEERBQOFE41EHs4upp56YvoTaC9Y3TWjns/nOlDvlTvtDE9Rgp/PUPQkYZ99O0I/PSsJ7J
        5DnsDJG8iJ5IhpFduDJ5yyVGHdtvpj/6zc7VKOMwe356uz4Xsidiig0Kxy0twNUnZw9UPF
        jZCjGvZLNGTtwMIHA0DTUueUs1jVvQQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-cz0r1MMON7aZqRqctJY9eg-1; Thu, 05 May 2022 13:10:44 -0400
X-MC-Unique: cz0r1MMON7aZqRqctJY9eg-1
Received: by mail-wr1-f70.google.com with SMTP id p10-20020adfaa0a000000b0020c4829af5fso1699862wrd.16
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 10:10:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=MSaM/kFaxl/G15Cuy6NKT1yGgbW5/ComR9Zu67jESeY=;
        b=nlfZ5rMnlsfsP/VyrqGyjl1YZrLIO2rFwYog+QsKIQSh+w1HFKq1W4xH4rRwuEWSOj
         0+XkZnHMq6vNhRIMrbeB5xBoqjQoACAvjqRmRreqiOvCkuqR3Tac45Ji3AIx86D3C1hK
         5egbPdzmavzSckEYQSbmQWzVqapmLBNcj+iimYDmnzeSOfPVH8zap9a7uJSVYUmYGs9v
         /gVKuvPLtnfnWIKsIULHdIauLXmPa1b+ajd2Xjw08A2CoEUOK1gxNK2hhzb6sDBXezIm
         OnXoUr2XYaC/kN7lG/EmXmLKohbdYNGYXkwKxeL/OpNPCG4MJbQzvJyyHLn/rdPsCuAT
         FOQg==
X-Gm-Message-State: AOAM530mJxjfuuc7JbgPMYPJOMwUE3QjyrNlifoXTygEpVQMu8li6EBk
        vxIbDgVhqF/8RYXRaHgLjc6m6Dvl1/DNeSBhR4v8CzwfNSB2aoWbh5b522NEs7RMB6BbSFs0yz8
        GTxmvWPyXyrNy
X-Received: by 2002:a05:6000:1b0e:b0:20a:deb9:ea39 with SMTP id f14-20020a0560001b0e00b0020adeb9ea39mr21905787wrz.393.1651770643251;
        Thu, 05 May 2022 10:10:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyDPn9nP/p49lTzu0R0gLGHU+GkCp0ndDtLLDn9SzIMnVpTyOSEy+TSFjpyyzaiqQej4sBww==
X-Received: by 2002:a05:6000:1b0e:b0:20a:deb9:ea39 with SMTP id f14-20020a0560001b0e00b0020adeb9ea39mr21905774wrz.393.1651770643024;
        Thu, 05 May 2022 10:10:43 -0700 (PDT)
Received: from [192.168.8.104] (tmo-082-126.customers.d1-online.com. [80.187.82.126])
        by smtp.gmail.com with ESMTPSA id p10-20020a05600c05ca00b003942a244ee3sm1723631wmd.40.2022.05.05.10.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 10:10:42 -0700 (PDT)
Message-ID: <9d79d8c9-9d3f-de6e-e910-62549fc2ac5d@redhat.com>
Date:   Thu, 5 May 2022 19:10:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
 <20220414080311.1084834-3-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v10 02/19] KVM: s390: pv: handle secure storage violations
 for protected guests
In-Reply-To: <20220414080311.1084834-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/2022 10.02, Claudio Imbrenda wrote:
> With upcoming patches, protected guests will be able to trigger secure
> storage violations in normal operation.
> 
> A secure storage violation is triggered when a protected guest tries to
> access secure memory that has been mapped erroneously, or that belongs
> to a different protected guest or to the ultravisor.
> 
> With upcoming patches, protected guests will be able to trigger secure
> storage violations in normal operation.

You've already used this sentence as 1st sentence of the patch description. 
Looks weird to read it again. Maybe scratch the 1st sentence?

> This happens for example if a
> protected guest is rebooted with lazy destroy enabled and the new guest
> is also protected.
> 
> When the new protected guest touches pages that have not yet been
> destroyed, and thus are accounted to the previous protected guest, a
> secure storage violation is raised.
> 
> This patch adds handling of secure storage violations for protected
> guests.
> 
> This exception is handled by first trying to destroy the page, because
> it is expected to belong to a defunct protected guest where a destroy
> should be possible. If that fails, a normal export of the page is
> attempted.
 >
> Therefore, pages that trigger the exception will be made non-secure
> before attempting to use them again for a different secure guest.

I'm an complete ignorant here, but isn't this somewhat dangerous? Could it 
happen that a VM could destroy/export the pages of another secure guest that 
way?

  Thomas

