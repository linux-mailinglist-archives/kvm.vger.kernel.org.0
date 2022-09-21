Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D21F5C00E7
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiIUPQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiIUPQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:16:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D5D8B2F7
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663773365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e1/3iD7RI36kvj0Sowor/BnZgoD6RNq2G2Sg9asUTkE=;
        b=jObK5hSiDlRfVvmB5gxThuDqNF27pFrGEQwBpX4ZURAcbXJkhne3fAfwHqsQn1n+6gEfhg
        B+eRKrJE+9+tLOEc/b6u8Xl1rBGh2K2/acutbBHrM8uYCOn6uVaVfo+ywI9NGORT2nBA75
        zITTGX13kamWpCZsbJMksYt3SFoD5cc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-484-c6TVvKhcPbmenWoxTc4jjQ-1; Wed, 21 Sep 2022 11:16:03 -0400
X-MC-Unique: c6TVvKhcPbmenWoxTc4jjQ-1
Received: by mail-ed1-f72.google.com with SMTP id e15-20020a056402190f00b0044f41e776a0so4664374edz.0
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=e1/3iD7RI36kvj0Sowor/BnZgoD6RNq2G2Sg9asUTkE=;
        b=h4fqUngh7uuyQFnkOXBjlrUfu1UN3edv9x2A7QY01KWP6ZzIuPR0Z9mX0Rf8aDzGjg
         /CYyGleHrXKqPgjF9Qc+NaY/zORjz/QS1miwfKxntNypCKP7x11GutW08eICGi5+iV9i
         h9rjrwePOwHR/6CLkc4wuMjweM6nDrFX4AHU/fTgwIhY3kxOsnX6n4T+HGKo0HxJTh8A
         vIbXv2L0dJUAejTUXCR9yU5AfW/RbVRDeOAcJdO1aOOLs1JIoz8vh8gCfsz/qrGkojBg
         Hph2xWqoTc2b5Yo9hJUDDyUf4gI+nkFzr/ZQHMT0TKSAQ4TpqUirCfVzipMXFZRkX1CX
         Q4MA==
X-Gm-Message-State: ACrzQf3KSAurtFErDJk1DEhkYwerge+MESTLviY2h+N3Uv6fF0vqgBXZ
        Ut3LPl3QS6CwnnuFmsB9pqAdFK4zN1a4pw4oBHeP/I7dKZ6ndokOsT70VE9F/P+xwInkjbevvZb
        x1tn9cym8YwA/032/KlU6LRfbJoF4Gb1e/RVKepuxw9e8n3A8kshRmJwrmqnePPwE
X-Received: by 2002:a17:907:75dc:b0:730:9c68:9a2e with SMTP id jl28-20020a17090775dc00b007309c689a2emr21875439ejc.22.1663773362075;
        Wed, 21 Sep 2022 08:16:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6C+CtvwXrusPAZI+96omZxJ1ec8xlFJMKiv4OXhnUjyL+XsezuiUSrsR051eKLQRYujgifDA==
X-Received: by 2002:a17:907:75dc:b0:730:9c68:9a2e with SMTP id jl28-20020a17090775dc00b007309c689a2emr21875408ejc.22.1663773361822;
        Wed, 21 Sep 2022 08:16:01 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ay4-20020a170906d28400b00777249e951bsm1420632ejb.51.2022.09.21.08.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 08:15:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v9 00/40] KVM: x86: hyper-v: Fine-grained TLB flush + L2
 TLB flush features
In-Reply-To: <Yw46XAP3aafdH/xZ@google.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
 <8735ddvoc2.fsf@redhat.com> <Yw46XAP3aafdH/xZ@google.com>
Date:   Wed, 21 Sep 2022 17:15:52 +0200
Message-ID: <87o7v8oj13.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Aug 30, 2022, Vitaly Kuznetsov wrote:
>> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>> 
>> > Changes since v8:
>> > - Rebase to the current kvm/queue (93472b797153)
>> > - selftests: move Hyper-V test pages to a dedicated struct untangling from 
>> >  vendor-specific (VMX/SVM) pages allocation [Sean].
>> 
>> Sean, Paolo,
>> 
>> I've jsut checked and this series applies cleanly on top of the latest
>> kvm/queue [372d07084593]. I also don't seem to have any feedback to
>> address.
>> 
>> Any chance this can be queued?
>
> It's the top "big" series on my todo list.  I fully plan on getting queued for 6.1,
> but I don't expect to get to it this week.

I was going to do a bare 'ping' here but then I decided to check whether
this series still applies cleanly and turns out there's some fuzz and
some minor conflicts with the already queued "KVM: VMX: Support updated
eVMCSv1 revision + use vmcs_config for L1 VMX MSRs" (in
sean/for_paolo/6.1 atm). I've rebased and re-tested and besides the
(unrelated) shadow MMU issue I've reported, things still seem to work
fine. I'm going to go ahead and send out rebased v10 then.

-- 
Vitaly

