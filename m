Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35F74CADAF
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244657AbiCBSh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242995AbiCBSh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:37:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A684D885B
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 10:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646246203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dkI26oH12rAI/rcHa+Bb6lkfS1t78b0pEHbqKtN0UIk=;
        b=JG/AbnL4k5MurG3+LE2PiTDqH5L+zeER9Jm2tfIT76KmxBdHqBZPDDDE/D2TaMcBocLNAm
        iVmuGIfJkiAmr79H9lhcTggU3EpqthySOUwIw3SXeo9hw/Yv0r3c21SjQnnO57kFjYXTsv
        waUhITVtQFAaT8Kfd3i6jDtqwJsEPqQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-5wxYnD2pMJugiw7zOR4Zrg-1; Wed, 02 Mar 2022 13:36:42 -0500
X-MC-Unique: 5wxYnD2pMJugiw7zOR4Zrg-1
Received: by mail-wm1-f69.google.com with SMTP id j42-20020a05600c1c2a00b00381febe402eso1803360wms.0
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 10:36:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dkI26oH12rAI/rcHa+Bb6lkfS1t78b0pEHbqKtN0UIk=;
        b=reAtTz1TvvQzvQYvPAJZVUmpsEUCuRwBa8B5MVxGbo3nNdVa7mpUCkXCVJ/Tb1A+ud
         tqyfoE16Hi2nfdarUL+g3WxRDFlq5K3/PdbftnUEfdW0BNKC9pXuQmJkJ+QSSQiOwyLz
         4p6b1mHloF9WssSyGfkgfhzVMGsvaAHU+dMQk5nVvQuS279MFeVHZ/K/quZ4z55jxxqR
         oLYlZIf+epLVJVpl0wQ/WOaKndb21nCtkbfjMEuvrCnC9W2MHZ9woQt460+s5BAdjVVX
         39DQgyMXIO5NC13VOoTRuU4McIW4CqPeARCzmyxrSyvVj7fbr/bRWhQhgcUW5EvvwdvP
         riOg==
X-Gm-Message-State: AOAM533By8vUYGDYeWG610ZyD48cQveGD6LxVmShdAQ0oyCa/KN02asc
        r/LHtSfBD+tuG8xp1K8I4qmLIks68XTTBlkKVvhkSSYqBbL5KsB8Ad0Ki/MnPyHFNCkqtju8EAu
        xTYKjrCYMnosA
X-Received: by 2002:a7b:cb44:0:b0:381:4dd8:5ec4 with SMTP id v4-20020a7bcb44000000b003814dd85ec4mr931459wmj.12.1646246201232;
        Wed, 02 Mar 2022 10:36:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0vLxk9UjI8UxS7wBOYxHK0l/sumk1InbU7uquyOLxzs3VdPsMO4Q7v+TvpQSfv85JSO/PCw==
X-Received: by 2002:a7b:cb44:0:b0:381:4dd8:5ec4 with SMTP id v4-20020a7bcb44000000b003814dd85ec4mr931433wmj.12.1646246201019;
        Wed, 02 Mar 2022 10:36:41 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id g11-20020a5d554b000000b001f0326a23ddsm2875275wrw.70.2022.03.02.10.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 10:36:40 -0800 (PST)
Message-ID: <764356ef-dd0f-01bd-129c-a821136a4f6e@redhat.com>
Date:   Wed, 2 Mar 2022 19:36:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 26/28] KVM: selftests: Split out helper to allocate
 guest mem via memfd
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-27-seanjc@google.com>
 <b41c303fc49e1b31d3e8ef92177a0de2458901bd.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b41c303fc49e1b31d3e8ef92177a0de2458901bd.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 00:36, David Woodhouse wrote:
> On Sat, 2022-02-26 at 00:15 +0000, Sean Christopherson wrote:
>> Extract the code for allocating guest memory via memfd out of
>> vm_userspace_mem_region_add() and into a new helper, kvm_memfd_alloc().
>> A future selftest to populate a guest with the maximum amount of guest
>> memory will abuse KVM's memslots to alias guest memory regions to a
>> single memfd-backed host region, i.e. needs to back a guest with memfd
>> memory without a 1:1 association between a memslot and a memfd instance.
>>
>> No functional change intended.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> While we're at it, please can we make the whole thing go away and just
> return failure #ifndef MFD_CLOEXEC, instead of breaking the build on
> older userspace?

We can just use old school F_SETFD if that's helpful for you.

Paolo

