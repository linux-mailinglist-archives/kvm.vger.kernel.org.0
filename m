Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DDC699B4A
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjBPRam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBPRak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:30:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8334C3F8
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676568595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U6Zp8Hed3CW6iFq59SZSz4SAwXwLQFpWH3KbP0of+xk=;
        b=GferFBFu9Zbu33eStnL+BNXC1QMS+F1e+f9i08LvfzCPiq1EYfNz/vArgS0j7zDYGhiSc6
        0ONwMOTVVYcldOf3ewTuh0LUr8YLenO4HxJHzNVXUViBUuGkuej1OqBHRnF1Q8EZvySnao
        3C7iuHvuZWQhjld1ijmzjJnndS9b2hU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-362-e8NwBhDnMleeF2V7xt1FHQ-1; Thu, 16 Feb 2023 12:29:52 -0500
X-MC-Unique: e8NwBhDnMleeF2V7xt1FHQ-1
Received: by mail-wm1-f70.google.com with SMTP id l38-20020a05600c1d2600b003ddff4b9a40so1444025wms.9
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:29:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U6Zp8Hed3CW6iFq59SZSz4SAwXwLQFpWH3KbP0of+xk=;
        b=Mp4B2xYWeO2Ot51hKFBfr24nDINhPJmetdb8eU8+XAwR1TMAPo6ngTP+CHki5TKPjd
         FpEI/8Mw/sg8oGO0hyV9qxaAjArb6eyuLnSF/Su6+K0OU9rOLN5hZL+lSVd6Ec2bD0ES
         b0Xe3XaU+AuZD1p2/hKTaRrGuKNpfXhY2/7cR+VDFx0K4gUdtwEAfVr4RenqFXg/Xysm
         Sx2090SfseBZh/Bpy6SEoRzd93y2bRQ7K3IL95yQc/UhVxefQ3PvePahehgWKs+wDiId
         tIOgDfA0oa4l5osaBSNQugnFr4wQeA18EGnk18t7RBKTXuqloNpgFjNwR+Q6WDVHkmr9
         XSig==
X-Gm-Message-State: AO0yUKVVSdgiHGOXKfKRaq10nUlKBOb/JviQUDiPqA8Te3Pj360Ja0sD
        li+//n66h2JLZ7EjJTCzLEbcrQqU0gYF+v735HZW6XA3g2vOztS9670kDS3xBNkdBT9qPxghzxd
        sbO2dafWPtYErdWTyaw==
X-Received: by 2002:a05:6000:1052:b0:2c5:54a7:363f with SMTP id c18-20020a056000105200b002c554a7363fmr5074131wrx.63.1676568591325;
        Thu, 16 Feb 2023 09:29:51 -0800 (PST)
X-Google-Smtp-Source: AK7set82yB4K8Il3lHHCT270RGiHuww46qNUxJQL7eS+qWxsdpYLKrxzTDgkELvErE+u8iG/k+RyXw==
X-Received: by 2002:a05:6000:1052:b0:2c5:54a7:363f with SMTP id c18-20020a056000105200b002c554a7363fmr5074119wrx.63.1676568591022;
        Thu, 16 Feb 2023 09:29:51 -0800 (PST)
Received: from [192.168.10.118] ([93.56.168.140])
        by smtp.googlemail.com with ESMTPSA id w9-20020a5d6089000000b002be099f78c0sm1990185wrt.69.2023.02.16.09.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 09:29:48 -0800 (PST)
Message-ID: <77e6336c-a09c-7e24-8abe-401984a2c3bb@redhat.com>
Date:   Thu, 16 Feb 2023 18:29:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] KVM: x86/mmu: Make @tdp_mmu_allowed static
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20230213212844.3062733-1-dmatlack@google.com>
 <Y+18f7go7J98XbzR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y+18f7go7J98XbzR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/16/23 01:44, Sean Christopherson wrote:
> Paolo, want to grab this one directly for 6.3?
Yep, done (and removed the "@").

Paolo

