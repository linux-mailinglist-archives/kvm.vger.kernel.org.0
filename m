Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F744DA466
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 22:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351902AbiCOVOQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 17:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351897AbiCOVON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 17:14:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67E77140DB
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647378779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S/Oxo2Zf/jCAmwn2Cz21fK7yT+TLG75ZLqETpuHgIms=;
        b=BvK14RQ/2l7S0xMuuzI5ox50lG84ZiNeurwHCsw9vw1F+Z6yGNwqpnYqusoT4prWiwy2Io
        LZsw0OvAzVXPRnf2C5bemkm+Q8bzvZA+nKQYXLYZnxwqUyKsmlv0YCPgufvWuaUs5diJpo
        zU6f9q2Mfsh+t4VAiKY0EXJjpfMawyw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-OhWwDqH9MyO3Fpj3zIaF7w-1; Tue, 15 Mar 2022 17:12:57 -0400
X-MC-Unique: OhWwDqH9MyO3Fpj3zIaF7w-1
Received: by mail-wm1-f71.google.com with SMTP id v184-20020a1cacc1000000b0038a12dbc23bso1725081wme.5
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:12:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S/Oxo2Zf/jCAmwn2Cz21fK7yT+TLG75ZLqETpuHgIms=;
        b=ccK5oIqePzJm1Vh3h1/laYsHdsy8m84xoANisvI7fJYKszS9CleIrjDs9kdTXRuWkZ
         coF31/srRuhri/0Q2yJ4xuUTDw4gglyexA33wAa17XQeCIcKFQd4OLp1N99UKOus3lM9
         Nq7U4QUcOdlrqhb4aU00hoWcq28ndJNTIjUJdiDOQTw2i3O3+QLS5e5zL/zXcdmPsOla
         +NDVMJhWR8xWopQm55LpMHvgfonVctOONdm45walKmZlFqwnHMOHLxVqWGkDhXH/CPNS
         oL5ipCoKslf99AW74ICmaTO4QbyQJ6YkQSNDSTj9GnZD+DZQUD5W1AN8mDSznTWq7wiF
         wCEg==
X-Gm-Message-State: AOAM531k1RPXnMqBFspLCkUT4068b7Bq1FHcfYhvsjDTsn9tWlYLh4RY
        QVF4oB/M2/CmXEAWhVwVkiE3r8xNC3rHsFOAkZOLZM8M+U91rxujYRsSGJhmjCi+bL6lcSteH4M
        7ax9jlkH4J//z
X-Received: by 2002:a05:600c:42c1:b0:389:8310:1128 with SMTP id j1-20020a05600c42c100b0038983101128mr4868251wme.3.1647378776704;
        Tue, 15 Mar 2022 14:12:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3Rs6Zc4YkLmBuIxVEDciW9Wq9T9wjxv8N/ar8OuoX76JXewHflmabVT9DwIW65yRsimPGKQ==
X-Received: by 2002:a05:600c:42c1:b0:389:8310:1128 with SMTP id j1-20020a05600c42c100b0038983101128mr4868241wme.3.1647378776522;
        Tue, 15 Mar 2022 14:12:56 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id j42-20020a05600c1c2a00b00389d2ca24c9sm9638wms.30.2022.03.15.14.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 14:12:55 -0700 (PDT)
Message-ID: <61684923-30eb-96eb-7c76-bab9119667bd@redhat.com>
Date:   Tue, 15 Mar 2022 22:12:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 3/3] KVM: x86: Trace all APICv inhibit changes and capture
 overall status
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220311043517.17027-1-seanjc@google.com>
 <20220311043517.17027-4-seanjc@google.com> <20220315144249.GA5496@gao-cwp>
 <57c2d5d64f9d65e442744fa8b7f188ed3fd37c1c.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <57c2d5d64f9d65e442744fa8b7f188ed3fd37c1c.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/22 15:48, Maxim Levitsky wrote:
>> Note that some calls may not toggle any bit. Do you want to log them?
>> I am afraid that a VM with many vCPUs may get a lot of traces that actually
>> doesn't change inhibits.
> I also think so.

Let's keep Sean's version for now, it may also be useful to see the 
state changes for all vCPU threads (based on the pid field in the 
trace).  We can always change it later if it's too noisy.

Paolo

