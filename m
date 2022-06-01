Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876A1539FD4
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 10:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345797AbiFAIvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 04:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239470AbiFAIvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 04:51:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 954A15EBFB
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 01:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654073461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KN/gK72qOTKu9oykyg1cq1wlv7KFsZdLZxOdh5lYes4=;
        b=QQ1HKy0aU0O7brmMTybr4eHGHbvAYpvl6zitfpUGEu7o/V+2iAWftj3gCAKjOFIVWZ7POy
        Aw1nnORw1YUi4oOfIQn3PvWubvu8mjEP1VuKQxZ0pweyCWUnEQBya3GfULGLARp4/5yHLN
        6L5HZXC9bXqy3Ypm9jKgeFl0RWWt3As=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-vSNooh8TOAavvgYMfN6Gqg-1; Wed, 01 Jun 2022 04:51:00 -0400
X-MC-Unique: vSNooh8TOAavvgYMfN6Gqg-1
Received: by mail-ej1-f72.google.com with SMTP id ks1-20020a170906f84100b006fee53b22c2so595837ejb.10
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 01:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KN/gK72qOTKu9oykyg1cq1wlv7KFsZdLZxOdh5lYes4=;
        b=gzZHG/SG/lH4wbFM/GixS3x4QUZBYnMoABCHqQww9Wi+cW4F6XvZvB8bIHDcmHDcec
         tWU4i98QXpgvo2h1topFU2wPtMoZBbUinyKjsSO7IOsOccNI4d68uA2jYhBnat3rHMbE
         2FQzCmmau1YG2I5ydiMusQRj9loZAigC6Lq3ZbGywg2mvU7oYVqCPhjkcsI9/OZELWMq
         vE0AjuYajOutPgAcB9JGFmVPYPMm2CaroNuwDgwwdBg0j1/y1R8xzgiFsDz8yN0LSlh1
         uuwe7BfwYVjWZLv5Eex/jvvdrUGdwc7YHgs7Wdk9UKiRw2R74Jri86Fuk7wP3cqYi5i6
         AKhw==
X-Gm-Message-State: AOAM530VZfRYCa4rQdfhjIMDnmNa998GvwI/lJrRopwS9xx7Tljg+Scg
        F53ZhPgeP6HIP5U1oFm/hgZ1bOeWcmOALJ7bORYUWk6l+d1NdDiR/UqVUyT5KIQpBdSgU2BwJkT
        GD5vHR3sKKkOq
X-Received: by 2002:a17:907:3e0e:b0:6fe:b42f:db81 with SMTP id hp14-20020a1709073e0e00b006feb42fdb81mr51843021ejc.516.1654073459286;
        Wed, 01 Jun 2022 01:50:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwC6bgj8hLRPwD+BHgB2LciO37PKhjdM24QD5p2bMDOSMN53AB7Z+7EKpHXXweZN8cxNQEFQ==
X-Received: by 2002:a17:907:3e0e:b0:6fe:b42f:db81 with SMTP id hp14-20020a1709073e0e00b006feb42fdb81mr51843001ejc.516.1654073459009;
        Wed, 01 Jun 2022 01:50:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id bv15-20020a170906b1cf00b006f4c4330c49sm454424ejb.57.2022.06.01.01.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 01:50:58 -0700 (PDT)
Message-ID: <42261964-df72-879b-0166-8bbb8b0fc3df@redhat.com>
Date:   Wed, 1 Jun 2022 10:50:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/2] KVM: vmx, pmu: accept 0 for absent MSRs when
 host-initiated
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220531175450.295552-1-pbonzini@redhat.com>
 <20220531175450.295552-2-pbonzini@redhat.com> <YpZgU+vfjkRuHZZR@google.com>
 <ce2b4fed-3d9e-a179-a907-5b8e09511b7d@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ce2b4fed-3d9e-a179-a907-5b8e09511b7d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/22 04:46, Like Xu wrote:
> On 1/6/2022 2:37 am, Sean Christopherson wrote:
>> On Tue, May 31, 2022, Paolo Bonzini wrote:
>>> Whenever an MSR is part of KVM_GET_MSR_INDEX_LIST, as is the case for
>>> MSR_IA32_DS_AREA, MSR_ARCH_LBR_DEPTH or MSR_ARCH_LBR_CTL, it has to be
>>> always settable with KVM_SET_MSR.  Accept a zero value for these MSRs
>>> to obey the contract.
> 
> Do we have a rule to decide whether to put MSRs into 
> KVM_GET_MSR_INDEX_LIST,
> for example a large number of LBR MSRs do not appear in it ?

In general I think it's much better to include them.  The only reason 
not to include them should be if the number of MSRs is variable and the 
actual number is accessible via KVM_GET_SUPPORTED_CPUID, a feature MSR, 
or KVM_CHECK_EXTENSION.

>> This is wrong, it will allow an unchecked wrmsrl() to 
>> MSR_ARCH_LBR_DEPTH if
>> X86_FEATURE_ARCH_LBR is not supported by hardware but userspace forces 
>> it in
>> guest CPUID.
> 
> What should we expect if the userspace forces guest to use features not 
> supported by KVM,
> especially the emulation of this feature depends on the functionality of 
> host and guest vcpu model ?

Certainly not a WARN or invalid vmwrite.

Paolo

