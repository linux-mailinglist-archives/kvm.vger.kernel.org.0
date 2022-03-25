Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4097A4E795C
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 17:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356475AbiCYQzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 12:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245467AbiCYQzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 12:55:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FCAB38D88
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 09:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648227213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rn001TI2+ev3rjEVO1qe7SoRJL2l7+xuOCYmZgKJjK0=;
        b=LXek2/70F3XELFhVE1TAI2UBoGthTXqeNuPU5RyZpLwJ/19carEb/g1DDuoy0OFR06N2Ii
        ixF6k0A0VIur7Qg6rh0tg5GojulOvGdOhL3aZi5Sr52/YV6s4c2K2qPD/yfvthN+yo6mJF
        HaCPYOZkrUpxBhJJ1ZraOmJsQfZY25o=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-3vpWXB9DOZ2cZPIH765h8Q-1; Fri, 25 Mar 2022 12:53:32 -0400
X-MC-Unique: 3vpWXB9DOZ2cZPIH765h8Q-1
Received: by mail-ed1-f70.google.com with SMTP id m21-20020a50d7d5000000b00418c7e4c2bbso5271868edj.6
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 09:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Rn001TI2+ev3rjEVO1qe7SoRJL2l7+xuOCYmZgKJjK0=;
        b=N1ogQHj1TY+Iq2JdsJQKuwdalOP1AMuTYJIUhjf4D/D0Xls/QKq+OClSpUOYKrlG3N
         ZcziObNgXd1YeJ9YBNyY6Ye/0OIBsvzgEH+/Qr+A1xKFnsTBJmoXtgWpIu8/z2ubdF/H
         jDIXoLLKsqFcKgG8SUYGn7TFWa32cnO+448nspJA0aKUBEJt83elC9IfKOBsIahU3ABS
         gAk0pq+16sgUtGvWDN+745pAACoFXbCcRHcNwK/XLdlPC5oMQQrBCX1nHHWg6GBCCHOQ
         7AZsHwlxt5qc/JoT5+ljmsLRn0jg/7unEblMK98ak4/yYoqrCsTPtOyOhHoA6HDj8wP1
         9gbg==
X-Gm-Message-State: AOAM533C5DxLPl6RmYmczFSmBskozlhT/Q9pmKKXFwGCZk3n33JiwTqD
        0j7+4OSSX6EKydfg5Cet59pqhVDzYchRsqQzFbuRLPo/VZDjGmRzpbpv3y2wbLOXCDYovY9JuNr
        1L4YekM3fPY8V
X-Received: by 2002:a17:906:2646:b0:6d5:d889:c92b with SMTP id i6-20020a170906264600b006d5d889c92bmr12991668ejc.696.1648227211225;
        Fri, 25 Mar 2022 09:53:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzapKU8f2he+ofcyryhegTHBFNGgHx51LCluIK5c6uYkYMRuFnEOqVukQXj7BcKBky+vzWfsQ==
X-Received: by 2002:a17:906:2646:b0:6d5:d889:c92b with SMTP id i6-20020a170906264600b006d5d889c92bmr12991651ejc.696.1648227211033;
        Fri, 25 Mar 2022 09:53:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id a18-20020a170906671200b006e05929e66csm2511374ejp.20.2022.03.25.09.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 09:53:30 -0700 (PDT)
Message-ID: <632d3601-ecf4-12f3-4f3b-408c35f028f6@redhat.com>
Date:   Fri, 25 Mar 2022 17:53:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220325152758.335626-1-pgonda@google.com>
 <d0366a14-6492-d2b9-215e-2ee310d9f8ae@redhat.com>
 <CAMkAt6rACYqFXA_6pa9JUnx0=3vyM6PeaNkq-Yih4KM6saf6PQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAMkAt6rACYqFXA_6pa9JUnx0=3vyM6PeaNkq-Yih4KM6saf6PQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/22 16:31, Peter Gonda wrote:
> On Fri, Mar 25, 2022 at 9:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 3/25/22 16:27, Peter Gonda wrote:
>>> SEV-ES guests can request termination using the GHCB's MSR protocol. See
>>> AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
>>> guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
>>> return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
>>> struct the userspace VMM can clear see the guest has requested a SEV-ES
>>> termination including the termination reason code set and reason code.
>>>
>>> Signed-off-by: Peter Gonda <pgonda@google.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: Borislav Petkov <bp@alien8.de>
>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Cc: Brijesh Singh <brijesh.singh@amd.com>
>>> Cc: Joerg Roedel <jroedel@suse.de>
>>> Cc: Marc Orr <marcorr@google.com>
>>> Cc: Sean Christopherson <seanjc@google.com>
>>> Cc: kvm@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>
>> This is missing an update to Documentation/.
>>
> 
> My mistake. I'll send another revision. Is the behavior of
> KVM_CAP_EXIT_SHUTDOWN_REASON OK? Or should we only return 1 for SEV-ES
> guests?

No, you can return 1 unconditionally, but you should also set reason and 
clear ndata in the other cases that return KVM_EXIT_SHUTDOWN.

Paolo

