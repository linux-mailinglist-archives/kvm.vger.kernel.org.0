Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F091360AE82
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 17:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiJXPGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 11:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiJXPFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 11:05:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC30F14BB6E
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 06:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666618824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TYYeY6WmbISjt57nThyLXvb2Wb4vuO7aGaq3NhLmbyU=;
        b=WX6WE/TlV8YGOqLQjE1SgQjgapv6IexEnlQ/+PM53o5rv80Fp8MphSmMiKka36NR758CV9
        OTBgR2oZYoXYOsXfC81GoDUKGvkkt11zWMh9OEx8nUVoaIoPDLZlWFCPmbzfZjPih7Di9v
        9SIknBWcw/goa7nP101JQveQCcnSR20=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-220-IeN-0MqcMw2cuMOWYkyLxA-1; Mon, 24 Oct 2022 08:57:39 -0400
X-MC-Unique: IeN-0MqcMw2cuMOWYkyLxA-1
Received: by mail-qv1-f71.google.com with SMTP id e13-20020ad450cd000000b004bb49d98da4so4021345qvq.9
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TYYeY6WmbISjt57nThyLXvb2Wb4vuO7aGaq3NhLmbyU=;
        b=DaTlguYygZR5sFmrbnizsJAwNBBHZQnUHCKdgLzh2et8tJzz84BS+GTj7goFGQYr4y
         OIxkw/BF0tqiwhyZGpi3TnKkzJv7UBqhIPkVh+tNkx1bGB5VZV7gVnMA8CEZeA4daYMg
         XsqiHywFpzzDGSD6jDho1CZaCw3MFhei7OqJhb2fEtQISP5GhKWfhzIzZyT9HkRryQ0g
         uXz2Y5UIgDI8rZl0tR4CqaWFEenxrjKOVkOhn71Tl25/nplRufyYJlj7IwVbeNmm+wJl
         A0JCmk4B3jQ6IMGLqOGOqTihpKx1n56/vihZI3nfM6Hz17VO/x7zymgscbhj8CfCzQ6p
         lDrQ==
X-Gm-Message-State: ACrzQf2WkMBD2299271tTHO1YZtDjRf7z5Qq4f0HMz2b4+w0G3lMdu2T
        yNRVx09Gr/EGaeu0VQqNC064kn8hgXJJ71ucLf1ub+/FekbyP5K96XKlmbp/GSAL8Xu+05hGRIX
        oh2ezEY5/Hscg
X-Received: by 2002:a05:622a:5cd:b0:39c:fcaf:7b36 with SMTP id d13-20020a05622a05cd00b0039cfcaf7b36mr23058055qtb.117.1666616257079;
        Mon, 24 Oct 2022 05:57:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7WC/42UgfWTDRy7m+TsBLfPQ7a53w+oMwbp6Q5j9cwx09EhMTQrNFPl7veBJ1xcH6Q+Absww==
X-Received: by 2002:a05:622a:5cd:b0:39c:fcaf:7b36 with SMTP id d13-20020a05622a05cd00b0039cfcaf7b36mr23058043qtb.117.1666616256881;
        Mon, 24 Oct 2022 05:57:36 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id bn39-20020a05620a2ae700b006cddf59a600sm14693814qkb.34.2022.10.24.05.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 05:57:36 -0700 (PDT)
Message-ID: <fba8e829-0d28-8f4d-a8ce-84d533009eb9@redhat.com>
Date:   Mon, 24 Oct 2022 14:57:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 3/4] KVM: introduce memory transaction semaphore
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221022154819.1823133-1-eesposit@redhat.com>
 <20221022154819.1823133-4-eesposit@redhat.com>
 <62500f94-b95b-1e16-4aa2-f67905fab01a@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <62500f94-b95b-1e16-4aa2-f67905fab01a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 23/10/2022 um 19:50 schrieb Paolo Bonzini:
> On 10/22/22 17:48, Emanuele Giuseppe Esposito wrote:
>> +static DECLARE_RWSEM(memory_transaction);
> 
> This cannot be global, it must be per-struct kvm.  Otherwise one VM can
> keep the rwsem indefinitely while a second VM hangs in
> KVM_KICK_ALL_RUNNING_VCPUS.
> 
> It can also be changed to an SRCU (with the down_write+up_write sequence
> changed to synchronize_srcu_expedited) which has similar characteristics
> to your use of the rwsem.
> 

Makes sense, but why synchronize_srcu_expedited and not synchronize_srcu?

Thank you,
Emanuele

