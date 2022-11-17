Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F61262E1F0
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 17:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbiKQQcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 11:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239197AbiKQQbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 11:31:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4B74FFB8
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668702526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kznKS9/sGLdHb625c2zKSaYWZ5CnNN1F94mhqirnc2w=;
        b=ZBgYGr99HJAOXERb1WWEy7WSqnkY3cjgbXUDMaL/aLVdSMhT7u4KLFm2jRySRKM1UDfgFn
        eOkGoF3I3fUFhlOh5UIPynkrZi7V+adfkpFpeJPdviuKf60HoMFYXYlCh+VHr6Sb/PBYZw
        YyriYxKoMkkfarUbUJkjWcYyLc11TeA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-255-QkA9Co5fPUm3Nt57MJJq6A-1; Thu, 17 Nov 2022 11:28:45 -0500
X-MC-Unique: QkA9Co5fPUm3Nt57MJJq6A-1
Received: by mail-ej1-f71.google.com with SMTP id sd31-20020a1709076e1f00b007ae63b8d66aso1390196ejc.3
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:28:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kznKS9/sGLdHb625c2zKSaYWZ5CnNN1F94mhqirnc2w=;
        b=EnT1AdlI+wsnF+sli3UhbmP3Qxo4KLpjz/sVu1ReZgdeNYoFY2bClF1D5RmM3Boy6w
         psoRDbiFXVSmoXi534nNiqIOboPJo35xXCnszaLY1xfu5G08a1xZ5lrD3n/SMVQG23A0
         FbIydaI28fFvXtnjbW/Qj20nPNPM7mHFgmpyIyZL91MTbAUvFHt/HpvRmpF9bbn6k39d
         ir386L1PBOOjWOPAd0AWXRrCzCgS2jZOmDjKa8k4WkwZX2fu78s05VrCu6oH1a+qbRAu
         ZrLluDyqoRlszuMC1lqlGBLqrGxQzFZrdY9zsBU3RmVppzv1z61GbtwbLm0tGEcp+Ocg
         cEOw==
X-Gm-Message-State: ANoB5pkeLac7SP9KhBtbW6hPe8xe4noR5usM2Z/503c8p7ihcEhexT3H
        r183N6E3TkTUKksvo3h1F4bGJPQqCqvs+A8ChaVa/mvLJQNsnSVHgo4LXKq0TG2cf90jXx7wOWg
        cs1FrY5d3E/f/
X-Received: by 2002:a05:6402:2987:b0:45c:a9d3:d535 with SMTP id eq7-20020a056402298700b0045ca9d3d535mr2873770edb.0.1668702523994;
        Thu, 17 Nov 2022 08:28:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf60uJW0qR53PDy341USHtndG6QniF6Z952xANom+qWTbRnqqmz18Dt0kmSkVw8cz2DZzKJLSw==
X-Received: by 2002:a05:6402:2987:b0:45c:a9d3:d535 with SMTP id eq7-20020a056402298700b0045ca9d3d535mr2873761edb.0.1668702523786;
        Thu, 17 Nov 2022 08:28:43 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id r9-20020a1709060d4900b007ae243c3f05sm548506ejh.189.2022.11.17.08.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 08:28:42 -0800 (PST)
Message-ID: <d636e626-ae33-0119-545d-a0b60cbe0ff7@redhat.com>
Date:   Thu, 17 Nov 2022 17:28:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org
References: <20221103204421.1146958-1-dmatlack@google.com>
 <Y2l247/1GzVm4mJH@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Do not recover dirty-tracked NX Huge
 Pages
In-Reply-To: <Y2l247/1GzVm4mJH@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/22 22:21, Sean Christopherson wrote:
> 
> Hmm, and the memslot heuristic doesn't address the recovery worker holding mmu_lock
> for write.  On a non-preemptible kernel, rwlock_needbreak() is always false, e.g.
> the worker won't yield to vCPUs that are trying to handle non-fast page faults.
> The worker should eventually reach steady state by unaccounting everything, but
> that might take a while.

I'm not sure what you mean here?  The recovery worker will still 
decrease to_zap by 1 on every unaccounted NX hugepage, and go to sleep 
after it reaches 0.

Also, David's test used a 10-second halving time for the recovery 
thread.  With the 1 hour time the effect would Perhaps the 1 hour time 
used by default by KVM is overly conservative, but 1% over 10 seconds is 
certainly a lot larger an effect, than 1% over 1 hour.

So, I'm queuing the patch.

Paolo

> An alternative idea to the memslot heuristic would be to add a knob to allow
> disabling the recovery thread on a per-VM basis.  Userspace should know that it's
> dirty logging a given VM for migration.

