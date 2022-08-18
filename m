Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F647598739
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 17:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344316AbiHRPU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 11:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344238AbiHRPUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 11:20:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109485B7AB
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660836037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3GQGhpbZE8ROB+knhR1egNzmPjUJp4WnI2UO3qznnGI=;
        b=fwU4GwrSSQ5YSnXi1/XuMZ+yPBjnjlPSDxSvlXsMn73P4rZSNjO2EIZUGk2J2UDdzRP9gK
        UoP1wAZIQpO7jPTKLzwQcSa2Z/M9ZpHLVHpJKdCrcYFP9t7l2FazfzeObjJY0kdb2lpQVp
        S8JzzPEt4aGyJLe/iH+Bnso6VhpWP0k=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-168-BWTL_4ZHOje9BxwW7tX1JQ-1; Thu, 18 Aug 2022 11:20:28 -0400
X-MC-Unique: BWTL_4ZHOje9BxwW7tX1JQ-1
Received: by mail-ed1-f70.google.com with SMTP id b13-20020a056402350d00b0043dfc84c533so1128103edd.5
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=3GQGhpbZE8ROB+knhR1egNzmPjUJp4WnI2UO3qznnGI=;
        b=hJS3Z0M2xTTKnvEFwKoKHmMa1HX/8hkm3wmqHJu8Q6mHJgLoQrpjstEmdRh+/rgmAI
         V/7zY2lY0GPOUKf0vHLuucxedvZ4e5hSBRCOjw6dIGqZMpk2KZ7IeTgK66rqOcfzoxKI
         DiKFfUJMeN5gXjWVmLDx1kaztolhII/6Qic0+8NBRwrPpfEPMws80wxYJEqNy8kGJSrr
         gU3RYw6kE7ujWshNXNaN2tpUs9bJ1N8zjyoAz40bZ0esenrjHYfHAdVte/S3RCn/TEhj
         6q2Rp34sB0DB1AEJ98fECdYb3o18zg/cPUecJKQW4C2S6PQ6W9ytRZW8sVxx6Qwzy5+j
         gebQ==
X-Gm-Message-State: ACgBeo10XTltTTSIxiAguTFbjwQnyfggbYOx6CtdfFBGNaLx/fo553Z6
        hDLc3M0Z6pUtYz9hTMWaCRU8sXq22V1MODekTgh3yzkOqsBBM68PemCG9hSBlh3LEOFgpTSkTCu
        L8KBsVXYz4v0G
X-Received: by 2002:a17:906:9b09:b0:730:9480:9729 with SMTP id eo9-20020a1709069b0900b0073094809729mr2228162ejc.588.1660836025927;
        Thu, 18 Aug 2022 08:20:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7bh4JrZAPWDBf+wZbX/JS8gz/ZAVA15O/nNLBF7TBz5gRTyDxEDV3jKJnQao0yfUYyQPmZUg==
X-Received: by 2002:a17:906:9b09:b0:730:9480:9729 with SMTP id eo9-20020a1709069b0900b0073094809729mr2228146ejc.588.1660836025686;
        Thu, 18 Aug 2022 08:20:25 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p6-20020a05640210c600b0043df40e4cfdsm1308866edu.35.2022.08.18.08.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 08:20:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/26] KVM: x86: hyper-v: Expose access to debug MSRs
 in the partition privilege flags
In-Reply-To: <Yv5XPnSRwKduznWI@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-2-vkuznets@redhat.com>
 <Yv5XPnSRwKduznWI@google.com>
Date:   Thu, 18 Aug 2022 17:20:24 +0200
Message-ID: <878rnltw7b.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
>> For some features, Hyper-V spec defines two separate CPUID bits: one
>> listing whether the feature is supported or not and another one showing
>> whether guest partition was granted access to the feature ("partition
>> privilege mask"). 'Debug MSRs available' is one of such features. Add
>> the missing 'access' bit.
>> 
>> Note: hv_check_msr_access() deliberately keeps checking
>> HV_FEATURE_DEBUG_MSRS_AVAILABLE bit instead of the new HV_ACCESS_DEBUG_MSRS
>> to not break existing VMMs (QEMU) which only expose one bit. Normally, VMMs
>> should set either both these bits or none.
>
> This is not the right approach long term.  If KVM absolutely cannot unconditionally
> switch to checking HV_ACCESS_DEBUG_MSRS because it would break QEMU users, then we
> should add a quirk, but sweeping the whole thing under the rug is wrong.
>

First, this patch is kind of unrelated to the series so in case it's the
only thing which blocks it from being merged -- let's just pull it out
and discuss separately.

My personal opinion is that in this particular case we actually can
switch to checking HV_ACCESS_DEBUG_MSRS and possibly backport this patch
to stable@ and be done with it as SynDBG is a debug feature which is not
supposed to be used much in the wild. This, however, will not give us
much besides 'purity' in KVM as no sane VMM is supposed to set just one
of the HV_FEATURE_DEBUG_MSRS_AVAILABLE/HV_ACCESS_DEBUG_MSRS bits. TL;DR:
I'm not against the change.

-- 
Vitaly

