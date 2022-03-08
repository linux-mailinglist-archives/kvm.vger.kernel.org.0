Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7724D1AF0
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 15:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347495AbiCHOtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 09:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242655AbiCHOtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 09:49:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DADE3916C
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 06:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646750886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LZcs0WshXiDTg8J9tIJLtneLFviU5TBv//0m9mRi4bk=;
        b=YtYJ6X+bMIElMqveL/4V5vyo4ymi9qyn2E2SZ5OMCUQRoVDE/9g0jiHrC9crTL3qjDm7vg
        jSEwrpIdlnI39ZW/UmUyYSjSg1Ish9ZuXw2esaYBedzhuMXvdESCu/XiSWRC1/U+SHLguS
        mEXGMt/n1StT6smsHsQ/ONEmPzVeHb8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-WzRrHkgKPAqiX3wnCuDa3Q-1; Tue, 08 Mar 2022 09:48:05 -0500
X-MC-Unique: WzRrHkgKPAqiX3wnCuDa3Q-1
Received: by mail-ej1-f70.google.com with SMTP id r18-20020a17090609d200b006a6e943d09eso8769878eje.20
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 06:48:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=LZcs0WshXiDTg8J9tIJLtneLFviU5TBv//0m9mRi4bk=;
        b=P3B8W/NNlQN9VOiv0cCNkRues7nJRjizQR93t0h4Fv+9moxP/k2xFJ6ldOb/7gAcfb
         Z58kjZdE+LE3FYG7iTWPEyFMgp0AahMB6pHzPpyyG6DCrRdyfpN4Lxzm11f3Z/t6FxOt
         K6Mfy5RWF+sBX2W5FMI093cxE7d2vXT3t6ZKpCU9wF3v1C9xcIboP1gSa/ag4VWbOTIH
         ZmfYcac6wwC1x5EQ7xNuUhv4kd1eXhs1GqqBDYPcOjYH94hXmH19hHPIOygznxMjl+EX
         DKJL+ct/3+TrQkkNaMUHcDor8jn8PIOSD4SPC1bUwgxPV3oduMOIES51wsNIXz1i1J6U
         eVvA==
X-Gm-Message-State: AOAM532dFiuxfw3w+LtzKxw4Gw8t5tvoXkC0IBPd441mqsEXqFbELfH6
        6Yu4TDIWUshZgpy08R4jClEOMojIhYTKaYVESMgW2VDasfxxOUxVJlsHRZT8DfOXRsrWgvsLry2
        sd1GiBcunjA53
X-Received: by 2002:a17:906:b095:b0:6cf:752c:fb88 with SMTP id x21-20020a170906b09500b006cf752cfb88mr13874904ejy.128.1646750883906;
        Tue, 08 Mar 2022 06:48:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUiOz69MV3fnzeZwcli5HCN//v73UVca4UC7IlcTdRuBqZ3C9hfP3suv1rmdDZgzjYnqtIsQ==
X-Received: by 2002:a17:906:b095:b0:6cf:752c:fb88 with SMTP id x21-20020a170906b09500b006cf752cfb88mr13874883ejy.128.1646750883665;
        Tue, 08 Mar 2022 06:48:03 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id sd21-20020a170906ce3500b006da97cf5a30sm5609077ejb.177.2022.03.08.06.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 06:48:02 -0800 (PST)
Message-ID: <63f4a488-87f1-097f-95d5-f85e46786740@redhat.com>
Date:   Tue, 8 Mar 2022 15:47:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 30/30] KVM: selftests: Add test to populate a VM with
 the max possible guest mem
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-31-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-31-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/3/22 20:38, Paolo Bonzini wrote:
> From: Sean Christopherson<seanjc@google.com>
> 
> Add a selftest that enables populating a VM with the maximum amount of
> guest memory allowed by the underlying architecture.  Abuse KVM's
> memslots by mapping a single host memory region into multiple memslots so
> that the selftest doesn't require a system with terabytes of RAM.
> 
> Default to 512gb of guest memory, which isn't all that interesting, but
> should work on all MMUs and doesn't take an exorbitant amount of memory
> or time.  E.g. testing with ~64tb of guest memory takes the better part
> of an hour, and requires 200gb of memory for KVM's page tables when using
> 4kb pages.

I couldn't quite run this on a laptop, so I'll tune it down to 128gb and 
3/4 of the available CPUs.

> To inflicit maximum abuse on KVM' MMU, default to 4kb pages (or whatever
> the not-hugepage size is) in the backing store (memfd).  Use memfd for
> the host backing store to ensure that hugepages are guaranteed when
> requested, and to give the user explicit control of the size of hugepage
> being tested.
> 
> By default, spin up as many vCPUs as there are available to the selftest,
> and distribute the work of dirtying each 4kb chunk of memory across all
> vCPUs.  Dirtying guest memory forces KVM to populate its page tables, and
> also forces KVM to write back accessed/dirty information to struct page
> when the guest memory is freed.
> 
> On x86, perform two passes with a MMU context reset between each pass to
> coerce KVM into dropping all references to the MMU root, e.g. to emulate
> a vCPU dropping the last reference.  Perform both passes and all
> rendezvous on all architectures in the hope that arm64 and s390x can gain
> similar shenanigans in the future.

Did you actually test aarch64 (not even asking about s390 :))?  For now 
let's only add it for x86.

> +			TEST_ASSERT(nr_vcpus, "#DE");

srsly? :)

Paolo

