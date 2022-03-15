Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765F94DA4DB
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 22:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352038AbiCOVvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 17:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344031AbiCOVvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 17:51:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57B9B5BE63
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647380990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GVTno3uwaKedC5z7RdpUfqlKxBXLrWKbeKGbJ46ufWc=;
        b=Xq+VxJnPMP6y+VsYobjYTIEuk/Due3SbfJ9kLTjE1JSmgsMwT48/xBIEFQGfpzyx/1jFlX
        WXEDiGGowESgbWnrFn4f5+9eKr/BiaTvrnYEVmXUWyopHm34PYNbUhxGwKYS2vv+6vx+Cw
        aCE/4swEvCXPrYJf6L+1peYmxj1LvsM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-0i8GuAJwPxKFxoN1Q_2Izg-1; Tue, 15 Mar 2022 17:49:49 -0400
X-MC-Unique: 0i8GuAJwPxKFxoN1Q_2Izg-1
Received: by mail-ej1-f69.google.com with SMTP id gz16-20020a170907a05000b006db8b2baa10so109804ejc.1
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:49:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GVTno3uwaKedC5z7RdpUfqlKxBXLrWKbeKGbJ46ufWc=;
        b=m3HW9D9vG3t5YjrG2cijbfQzTWkehRvNn6QIQ6PxFh/eS3Z6QRIuA6mHrDYoUMP49C
         5mJUAc/8P2BKWv+a1P8uAsJotrPyg0Z0cQQk5c+SaFIDT3IpK7Zbfh/PAyTx3mzBCQCz
         A3trbOqR4axeHhk1452dr50dhaDi+Hrtg6vxCccAkKLLUjsNCERVMRQyWhn6KHiW84iO
         AXzoXYlEThddSspF72+0wZbox8GhqJ8LioKYHcjYzceXmOcXE1KUXQW1QAZVgxTsOlaU
         JWB1LRqHqNhBBpTSjgTkG0+jV9viq37sr6CjZha0Gy/onsZF4xmCqlayhpUjqb+ggpko
         wQQg==
X-Gm-Message-State: AOAM5303W9izp9Uq2yeiNGWtzbhbB4eWXF8VEMo1I8MTVSb8LX4U1voE
        mrP7oxL1u90ExXWE8zHOzM/kpncEIbpmU1Il2x4Af7C135U60oEOfRcYB316lppH01ru/k9ba0H
        QHpLDZWWpDXjp
X-Received: by 2002:a17:907:1c0a:b0:6da:7ac4:5349 with SMTP id nc10-20020a1709071c0a00b006da7ac45349mr24637594ejc.596.1647380987405;
        Tue, 15 Mar 2022 14:49:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjb4JGyQJec/pMSJpOYHm1OGNj4Mo/pMqjdAHmpdwTdrKZ/ktCxntndWmQuh4d7xILgPsZkQ==
X-Received: by 2002:a17:907:1c0a:b0:6da:7ac4:5349 with SMTP id nc10-20020a1709071c0a00b006da7ac45349mr24637585ejc.596.1647380987193;
        Tue, 15 Mar 2022 14:49:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id o3-20020a17090637c300b006d8631b2935sm79932ejc.186.2022.03.15.14.49.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 14:49:46 -0700 (PDT)
Message-ID: <bfd4c023-a40e-2f1b-0a02-adc6cb61f5ae@redhat.com>
Date:   Tue, 15 Mar 2022 22:49:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 010/104] KVM: TDX: Make TDX VM type supported
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <0596db2913da40660e87d5005167c623cee14765.1646422845.git.isaku.yamahata@intel.com>
 <18a150fd2e0316b4bae283d244f856494e0dfefd.camel@intel.com>
 <20220315210350.GE1964605@ls.amr.corp.intel.com>
 <9b90aaac2d55674550d35ce5a4ddd604825423c3.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <9b90aaac2d55674550d35ce5a4ddd604825423c3.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/22 22:47, Kai Huang wrote:
>> The intention is that developers can exercise the new code step-by-step even if
>> the TDX KVM isn't complete.
> What is the purpose/value to allow developers to exercise the new code step-by-
> step?  Userspace cannot create TD successfully anyway until all patches are
> ready.

We can move this to the end when the patch is committed, but I think 
there is value in showing that the series works (for partial definitions 
of "work") at every step of the enablement process.

Paolo

