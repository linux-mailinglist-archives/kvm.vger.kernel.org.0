Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F0254B766
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 19:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344174AbiFNRNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 13:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344218AbiFNRM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 13:12:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDCCC1FA63
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 10:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655226771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BfrhtGAtLvOb91U5Caoxz7ToRMTUo4BX498hJvwylV4=;
        b=Wpdb598WVOBu+1TrrRVISryupR1ZzrUGnlOKcmh8bXvLR0du9uXq/Yi+FOiKEpuaL3mXqK
        b4cCsDhKJdLYuQsxn4oX22kVYZHLcG2EFzDUPa3LZ4s+itYd9XRSp7QCtDYXRYC9zGjrW9
        0+VHx+nxy59BD18WcrNaeDHeMw6So4s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-jitiP3n_MNa138pxCenHkw-1; Tue, 14 Jun 2022 13:12:49 -0400
X-MC-Unique: jitiP3n_MNa138pxCenHkw-1
Received: by mail-wm1-f70.google.com with SMTP id p6-20020a05600c358600b0039c873184b9so4634413wmq.4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 10:12:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BfrhtGAtLvOb91U5Caoxz7ToRMTUo4BX498hJvwylV4=;
        b=wRWbjzQDNZsFUX7cTXUXnKCnLRiByA1i80P/OXr/ZGuQi2rFl/bNt2n9/3Tavq97EX
         ywv/4T7b4CDNqlVYQXN40GaMr312Gt3cWbqoix++M2X5b7oBaq4q3db5pSXlaCYlX1qw
         D8LMAkYy+qDb/mLWiDgesh8FbTZ17jf16BuZ75/Pk5aSB6Zdgp4c1qJbrGnPXFE6cxoX
         R5N+um1rg1N4ZNu3XKN+1tJ3JGUjXBltSVHeyM2f7Kb/LOnDit9tX0PSPZ4Kk0HW82SY
         mNusI9pJxeFxBxlvn7hS9Df8FOfKg42+giMRXORvE/uRVRG7FAlWRBz738NafF80iNJt
         pnfw==
X-Gm-Message-State: AOAM533ebU9RqJGc1FEendHh+iH61wrqqPRa3MlhM8g0rRse3F0AOGtR
        pmysLD2JQKqe4UNbmtrwJnjYXZxHem2HqvTYGkkP7mg24LGkF3dBg53cSiFRUt2yNgeTJxsQLFS
        FNkZHwxOL7xzb
X-Received: by 2002:a05:600c:3d99:b0:39c:55ba:ecc3 with SMTP id bi25-20020a05600c3d9900b0039c55baecc3mr5382963wmb.42.1655226768598;
        Tue, 14 Jun 2022 10:12:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxzHRj9jPybDShmEzjDSQmNckyNLR7TmjRU0BvivRa22+pBhTAlu7GJThPLg9tZdNRpxpyEQ==
X-Received: by 2002:a05:600c:3d99:b0:39c:55ba:ecc3 with SMTP id bi25-20020a05600c3d9900b0039c55baecc3mr5382934wmb.42.1655226768288;
        Tue, 14 Jun 2022 10:12:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id g15-20020a05600c4ecf00b0039c4945c753sm19088159wmq.39.2022.06.14.10.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 10:12:47 -0700 (PDT)
Message-ID: <25293823-222b-274a-c2b5-63a5558b02d8@redhat.com>
Date:   Tue, 14 Jun 2022 19:12:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/8] KVM: x86/mmu: Drop unused CMPXCHG macro from
 paging_tmpl.h
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <20220613225723.2734132-1-seanjc@google.com>
 <20220613225723.2734132-2-seanjc@google.com>
 <CAJhGHyDjFCJdRjdV-W5+reg-3jiwJAqeCQ7A-vdUqt+dToJBdA@mail.gmail.com>
 <YqibwNj8ihL3vbel@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YqibwNj8ihL3vbel@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/14/22 16:31, Sean Christopherson wrote:
> I'd prefer to keep them around as it allows using them to generate the other masks
> that are used.

Ok, I see what you're doing in patch 6.  Yeah, I'll wait for v2.

Paolo

