Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA9A63D80C
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiK3O31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiK3O3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:29:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A6852888
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669818510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y4BuH5cBFYGQO0HJvV3GfOV4tMTDeQ8Y1esgc3MwA+8=;
        b=cu2V+7EOI/LJLuf8TuOcQa7yy407UH9PwgZFa+6h/a6ZBtKKLfWHBgBqOY+evshuc/Lpn+
        mHnrHyhEf5VIL6AVGaHfmNN5uuAeGOLjJXoeI++I0suiRw+4yrOWwBQ1TYyNrt02uUlLWD
        AMatKWBvLzGA2duyWk9akA064KWAL9A=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-YjFhZkbvN1moFZkvkq3hWw-1; Wed, 30 Nov 2022 09:28:28 -0500
X-MC-Unique: YjFhZkbvN1moFZkvkq3hWw-1
Received: by mail-ej1-f70.google.com with SMTP id qk16-20020a1709077f9000b007c080a6b4ddso4449506ejc.18
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:28:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4BuH5cBFYGQO0HJvV3GfOV4tMTDeQ8Y1esgc3MwA+8=;
        b=RI/rBbRwPg8m7VMDoxe6talMa76UA7tSOYRHvQgr+6Cr1znOu23lZ7aArhnACutHeg
         raWtO4WPCGazTDHNURtCAxeBcuRB2Qc7ctqAg84oUmnWatpcbg/4JnsxkRqvbn+u+A0O
         y5TVrnKBzOVUocjINW3ua0JFLnxe5iypdJ43iOzhOIy4+7xxParYxkgHPH2oawmYh/1T
         n54VjkSc9b+yUPfHEfaRitZMMpOFEEdbODK8eApjFH30RFeG7WZO64N7rCPFDE747Uci
         8/RnlT7de/2LEj2ZZ+RjLJ9rAaa2/nO2lGOBSbHiVKYvBwi6da0Q0GyyPHO4R9D7zhqV
         FBXA==
X-Gm-Message-State: ANoB5pmHOu/JdtVprF5XNEyroOoaypbbt/K9byn5kCjFTd5HWxJuIBeI
        jyU9zOQ2jZpWVhJGGsMYgkTv3WMToi7ILolg4K4Tq14eBhrKpnag5R6J6LjduWqYx8pDYBna3gj
        /pPtzhta1KmWs
X-Received: by 2002:a05:6402:54:b0:46a:c420:6da7 with SMTP id f20-20020a056402005400b0046ac4206da7mr22875299edu.202.1669818507868;
        Wed, 30 Nov 2022 06:28:27 -0800 (PST)
X-Google-Smtp-Source: AA0mqf74GZy7rhgQ1fqF9sgb0UnZtEde2fVssY+6TyZrXo/JhdUvdUpocS5AnJH5pjMtnAJHi/2nmQ==
X-Received: by 2002:a05:6402:54:b0:46a:c420:6da7 with SMTP id f20-20020a056402005400b0046ac4206da7mr22875280edu.202.1669818507599;
        Wed, 30 Nov 2022 06:28:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id 18-20020a170906211200b007adaca75bd0sm700756ejt.179.2022.11.30.06.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 06:28:26 -0800 (PST)
Message-ID: <a6a59b75-2ee2-ab9b-3038-2590df17d031@redhat.com>
Date:   Wed, 30 Nov 2022 15:28:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/2] KVM: Mark KVM_SET_MEMORY_REGION and
 KVM_SET_MEMORY_ALIAS as obsoleted
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Javier Martinez Canillas <javierm@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Sergio Lopez Pascual <slp@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20221119085632.1018994-1-javierm@redhat.com>
 <Y4T+SY9SZIRFBdBM@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y4T+SY9SZIRFBdBM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/28/22 19:30, Sean Christopherson wrote:
> E.g. KVM_{CREATE,GET,SET}_PIT are good examples of obsolete ioctls; they've been
> supplanted by newer variants, but KVM still supports the old ones too.
> 
> Alternatively (to marking them deprecated), can we completely remove all references
> to VM_SET_MEMORY_REGION and KVM_SET_MEMORY_ALIAS?  The cascading updates in api.rst
> will be painful, but it's one-time pain.

Yes, we should.

Paolo

