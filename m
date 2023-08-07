Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFA1771B0A
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 09:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjHGHEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 03:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjHGHEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 03:04:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59353E78
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 00:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691391797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b4v8GA0u0EC8VkcgQUv3B1mp/A++xZyvZaXBENnPjeM=;
        b=etnkgQW4XkK412FSG3nDZPXp1YsuJUag+VOyvVAiVJpVEospd/wNurBh42TPOf3eviv8Qi
        qNnxHuS0m+VGTIpYZHAkD6rfCyQ76T1f20JacXI7HeIHhU+xjnBpIIGAD3SS7fMNJwB2hn
        GTjGYNg93WACl49BOtzPXUMxoCvH88k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-r8H2M3dTMi2-Rv5f-JJy1Q-1; Mon, 07 Aug 2023 03:03:16 -0400
X-MC-Unique: r8H2M3dTMi2-Rv5f-JJy1Q-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fe11910e46so19415565e9.0
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 00:03:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691391795; x=1691996595;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b4v8GA0u0EC8VkcgQUv3B1mp/A++xZyvZaXBENnPjeM=;
        b=ZF+qq0mXH2Lgo7B6pNOf7sxaEJ4Cbx1ttw2RkrzTVA8hqUAxaLQhf+BclqYOFpCj7o
         ch/82wKb/hyXaR2L/UL3mWqLBRHqb2zBDrNcKFsNiPek1Xa7Vcrzgvij9D0MrJ53QfvR
         Po8/JnL2Ox5D8YlUvsiUoLt2w7CDre84svbLVnggkl97LzMAi7MTwMTSaIGqmrldRQwc
         ovll+Uq2DB6a57FxfVlPMaw4q1Pqt3PMzjVNQTrbRzXOBiVNJWGxDGxHcBy0ft3yNVwV
         qmwe5rd9hh0RHiH7tbilPci6FCS8WWOt9D2TGKJgA17QLKXK8zO1zW8FButBiOfzO6vp
         fNCw==
X-Gm-Message-State: AOJu0Yy4a1BS7BmCARvtrEeG/JNHT/Bph9OAA5sjEsDSOnAGcgsM1mYN
        gelixkyu9NgyUb3dX1RJSt0sivVVwVkXUjge1oLv9AM8alibBXjEqyHvGV7XhEvnNEYX+3WlXjS
        5PUZFFRybPxS2
X-Received: by 2002:a05:600c:22c6:b0:3fe:df0:c10f with SMTP id 6-20020a05600c22c600b003fe0df0c10fmr4618396wmg.17.1691391794834;
        Mon, 07 Aug 2023 00:03:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCFAFoTUZJH8TVrXZsQ7UgyVKCscgQ+xaV6pqbrkpL57eDgfEyPnej4zYot4z9yJV489u6tg==
X-Received: by 2002:a05:600c:22c6:b0:3fe:df0:c10f with SMTP id 6-20020a05600c22c600b003fe0df0c10fmr4618372wmg.17.1691391794472;
        Mon, 07 Aug 2023 00:03:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id i12-20020a05600c290c00b003fbb618f7adsm9704074wmd.15.2023.08.07.00.03.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Aug 2023 00:03:13 -0700 (PDT)
Message-ID: <73338ff4-24b0-0358-0419-ad0fb0101813@redhat.com>
Date:   Mon, 7 Aug 2023 09:03:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 11/19] KVM:VMX: Emulate read and write to CET MSRs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chao Gao <chao.gao@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        binbin.wu@linux.intel.com
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-12-weijiang.yang@intel.com>
 <ZMyJIq4CgXxudJED@chao-email> <ZM1tNJ9ZdQb+VZVo@google.com>
 <c5bdcd8e-c6cd-d586-499c-4a2b7528cda9@redhat.com>
 <ZM15zd998LCOUOrZ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZM15zd998LCOUOrZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/23 00:21, Sean Christopherson wrote:
> Oooh, the MSRs that don't exempt host_initiated are added to the list

(are *not* added)

> of MSRs to save/restore, i.e. KVM "silently" supports 
> MSR_AMD64_OSVW_ID_LENGTH and MSR_AMD64_OSVW_STATUS.
> 
> And guest_pv_has() returns true unless userspace has opted in to
> enforcement.

Two different ways of having the same bug.  The latter was introduced in 
the implementation of KVM_CAP_ENFORCE_PV_FEATURE_CPUID; it would become 
a problem if some selftests started using it.

Paolo

