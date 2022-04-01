Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E404EEED4
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 16:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346677AbiDAOIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 10:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346540AbiDAOI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 10:08:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F639214FB2
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 07:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648821995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oPKiMeBipG/n75nIi9Z8lQEgirdQ3eeZPdOA5+6OEM4=;
        b=ZQRusk0oM7V35K3hhC+OgeKY5SeeOneIKZoH0I3eOBEJ7nGt5R7XUpfGTAgJZQKJMAudXs
        29hMZ7zmVHa9++0OIYkFMGrQWU/6UwNRjN4iDLmbrAubrLbpkYP3hUVkaDmhfPmJnnR2gl
        UsAOxlkyls9Mem6pfD5HZh30BdVHfOk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-Ofvw9tXPNdaCK27gXZpG1g-1; Fri, 01 Apr 2022 10:06:33 -0400
X-MC-Unique: Ofvw9tXPNdaCK27gXZpG1g-1
Received: by mail-ej1-f71.google.com with SMTP id m12-20020a1709062acc00b006cfc98179e2so1659625eje.6
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 07:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oPKiMeBipG/n75nIi9Z8lQEgirdQ3eeZPdOA5+6OEM4=;
        b=Tkwqi+EETRniZAj90QMfDL9i48QvRoP/u2L3ZcgEK4cTq/pzUCkYMmQbj0Ir0+Zs/w
         lKlqo+UfjJmxD6+nfYk+Z0Q4oDa/S6HL9iWnMH2jryOeGv8ctIUgfj6VRRr5xB7g+yIE
         oKKK0m2MyvG5tpy1iyvJMbZXN7DgTPSKFbNnUPRTEcG6iIOcS6FkC4nDWlh74XH4nyQv
         jqtttUtRsow0B3ISmXmSZ+EEMNc6awVAFLJkiA8y6MHtR5IBXQY23Q5nD0RJeThItI/l
         jiCkw/lgRYwXcj1k0l8QJiVC0xdF63TTmxJBOmafKwhmVTQ+lOM65ddjkaxHyleGa+Yk
         6ppA==
X-Gm-Message-State: AOAM533vKA8yVV/2VvdgmwgdzpPCCrGleCjWV22IKsUoF3y/q4bg2he7
        tHMDsJ1U+o0f9gprwv1Ippm1dBV8QEQn3JLg/sOMQ452TLyeyiB+HDOqii+2fvgqcbtSv4lZ1Uq
        1Eg5FBPlEBvId
X-Received: by 2002:a17:907:2cc6:b0:6e0:1ae5:d762 with SMTP id hg6-20020a1709072cc600b006e01ae5d762mr9714613ejc.291.1648821991803;
        Fri, 01 Apr 2022 07:06:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzD6bu0GtgNQPcO6zhHTHlVfQGsBTyEM/XcoIIEW2FyS6WECKfMjFl64ImfiDDCAZyLfM/7cA==
X-Received: by 2002:a17:907:2cc6:b0:6e0:1ae5:d762 with SMTP id hg6-20020a1709072cc600b006e01ae5d762mr9714577ejc.291.1648821991539;
        Fri, 01 Apr 2022 07:06:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id c12-20020a05640227cc00b004192114e521sm1221807ede.60.2022.04.01.07.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 07:06:30 -0700 (PDT)
Message-ID: <705809c7-8370-de2e-fe32-47735fc9c39e@redhat.com>
Date:   Fri, 1 Apr 2022 16:06:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: MMU: fix an IS_ERR() vs NULL bug
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20220401100147.GA29786@kili> <YkcGfMNjaayttqtC@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YkcGfMNjaayttqtC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/1/22 16:04, Sean Christopherson wrote:
> Paolo, any objection to also returning '0' in all non-error paths?  There's no
> need to return whether or not the TDP MMU is enabled since that's handled locally,
> and the "return 1" is rather odd.

Well, I kept that because I thought there was a hidden reason for that. 
  At this point I was really about to press Enter and send out the pull 
request, so...

Paolo

