Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309D3581770
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 18:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239395AbiGZQaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 12:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiGZQaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 12:30:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A0B525C5D
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 09:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658852999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZzAlLINwAEAoAQYtQp+D4ukrI4e7/yR1Da8zdRffjvY=;
        b=exnCvsX7USMPWWdgkOX3ZDOdXCdvfWJ7nPmfSzzCvLIBsspN28mwfaXAIjhzTIJqbUjI6f
        H9//VC7arWYN0DZmg6X3k9Sb3yiFVH7MmWa4YnhKjicrqjg+ewM/8FZXC1dm9krRZnPELh
        GmTFZVW7HRpDJW9ZH1hGHVGFGAxZUNA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-qvwPdP3cNLq3zKDo0GuP-A-1; Tue, 26 Jul 2022 12:29:57 -0400
X-MC-Unique: qvwPdP3cNLq3zKDo0GuP-A-1
Received: by mail-ed1-f72.google.com with SMTP id c9-20020a05640227c900b0043ad14b1fa0so9033646ede.1
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 09:29:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZzAlLINwAEAoAQYtQp+D4ukrI4e7/yR1Da8zdRffjvY=;
        b=r21WoX9BtoOQoJhNVwh7Q0lwcASyiCWSuwZ3dOl7CBRAF7MSe+90T8xbw/1U5zBK91
         GHJvrnlu+oXc/+SEqPzP+e2Knd37QJBSVi9nO+HcYCUDc2c8uKnb1HhVfAMdvcJpz6Rm
         JE6e7Z92bPkFYe0mH5EGSqfBCr7l3mFzS9iXgyEceBItlti2kl25SJuodfJcFV6zecag
         tjLaEBtRjRP10GNqHpbd3kvhEhwxZH7l8jSGzKRQ3Qm1YQFus9IkMpnmwSUYOcPbEE3T
         ius0Y8KAiHjDeQ20LwfrrDtrOet7Glzt917VRlLRUE/a9pSNxiBPHQVEBPDY39e37eC6
         SXkw==
X-Gm-Message-State: AJIora+QF6JAbTN6BQ8Hp77E1YbJfdgGROSndWtWItQO6jAojzWUGRTm
        UdGlj3wkTVsXMuTSUHVdFBT6MSv6f8hwAt2/vmj3TLoZLqB2s/jLtN89/uUDrNwkV74A1aji/tC
        nj5WjqjC8utIr
X-Received: by 2002:a05:6402:1b02:b0:43c:915d:c4fb with SMTP id by2-20020a0564021b0200b0043c915dc4fbmr1323577edb.59.1658852995861;
        Tue, 26 Jul 2022 09:29:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sfocQxac08KlH6P5482QLn9jsqilmmUKkCRGbPhSjGqsud/sqWGD5tgSmzDJSEzgEsmXyt+w==
X-Received: by 2002:a05:6402:1b02:b0:43c:915d:c4fb with SMTP id by2-20020a0564021b0200b0043c915dc4fbmr1323563edb.59.1658852995623;
        Tue, 26 Jul 2022 09:29:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id i15-20020a50fd0f000000b0043b910de985sm8793724eds.74.2022.07.26.09.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 09:29:54 -0700 (PDT)
Message-ID: <3f2f83a3-e240-a509-38ca-1b88bdc179d4@redhat.com>
Date:   Tue, 26 Jul 2022 18:29:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH MANUALSEL 5.10 1/2] KVM: x86: lapic: don't touch
 irr_pending in kvm_apic_update_apicv when inhibiting it
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
References: <20220222140532.211620-1-sashal@kernel.org>
 <e9e3f438-8699-abba-a1f8-d4d8bfbd63ed@redhat.com>
 <6d900dc3-44c0-5a0d-a545-1a51936e6a80@huawei.com>
 <Yt8sAWd6qvEtZVji@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yt8sAWd6qvEtZVji@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/22 01:49, Sean Christopherson wrote:
> On Mon, Jul 25, 2022, Zenghui Yu wrote:
>> Hi,
>>
>> On 2022/3/2 1:10, Paolo Bonzini wrote:
>>> On 2/22/22 15:05, Sasha Levin wrote:
>>>> From: Maxim Levitsky <mlevitsk@redhat.com>
>>>>
>>>> [ Upstream commit 755c2bf878607dbddb1423df9abf16b82205896f ]
>>>
>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>> What prevented it to be accepted into 5.10-stable? It can still be
>> applied cleanly on top of linux-5.10.y.
> 
> KVM opts out of the AUTOSEL logic and instead uses MANUALSEL.  The basic idea is
> the same, use scripts/magic to determine what commits that _aren't_ tagged with an
> explicit "Cc: stable@vger.kernel.org" should be backported to stable trees, the
> difference being that MANUALSEL requires an explicit Acked-by from the maintainer.

But as far as I understand it was not applied, and neither was "KVM: 
x86: nSVM: deal with L1 hypervisor that intercepts interrupts but lets 
L2 control them".

Paolo

