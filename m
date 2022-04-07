Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90CE4F8133
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 16:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbiDGODt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 10:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiDGODr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 10:03:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85B5CBF52D
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 07:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649340104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iPVjUD4VGANcIQRfm5QWOv0d3iQPwruTr6X8FPFV1Gg=;
        b=YyxZCZGv4Yvlt42+3nJKYsE/GbbD9SPl4Nkp299RZPRSzPkiXuhrg0cqb8D3jlPhZQScPH
        pAulYpD5IKyDOllWiaWsS9JORllCDvNF80ItdikRsAj/yrlPSbdask+rBbR939rr09Z6XN
        wlJCgf5X1GI0CtT5e4MpxedTJaa4TW0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-15H9wykCPN6Y7vWWd0jECA-1; Thu, 07 Apr 2022 10:01:42 -0400
X-MC-Unique: 15H9wykCPN6Y7vWWd0jECA-1
Received: by mail-wm1-f70.google.com with SMTP id t2-20020a7bc3c2000000b003528fe59cb9so3012155wmj.5
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 07:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iPVjUD4VGANcIQRfm5QWOv0d3iQPwruTr6X8FPFV1Gg=;
        b=xL/SXJB8J/qhCj04Hy3L00K+acX4CLcyFMyYhbN7Uf/EFBJAlGbnFHpHh5EC/EyiXp
         jzReuodHIixmJ0xuxk7JozjN3fcdBeny13WVA2KqmXotywy5dfpFmIJOJTFU76XKs/wN
         zgS7OUCwKVneIm67DSBHPx1k+ikTQMsKdexfP9rr7lChB81kPh0nFpV7x8AzVDCQWPpj
         NvGF6VIP6UhEVRmZa7SbHejnQPn2W3h2mGU93Zgz1sKC5T9WXypicGtj+c7mxG3G1jN3
         yJnNudxlA2wExVmpu8me0OoZEr1irftMa6JSNrAELiZmBiH/FNVCQwylp+M/oqOAzH4k
         OCgg==
X-Gm-Message-State: AOAM531+Zy3VKclTQRV9MkJQM4FGc21aU8B69XIgRDh20zc2qMJYEssz
        TqfAzfCdeUBT4NNjxvKbRMH5vCVUwMdbzrNod7vOSM7WQM9SjHMHtB5Z6b1gdRw0J29gB1xhERD
        KhKMa/R4RvMYm
X-Received: by 2002:a05:600c:1910:b0:38c:bff7:b9db with SMTP id j16-20020a05600c191000b0038cbff7b9dbmr12633651wmq.182.1649340100898;
        Thu, 07 Apr 2022 07:01:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxU/dYZtfiATAomIrnRvl8FEyxkNIr3CwJEqCIWLwzLHA8afMCdfS5sdwqZVv6K+GTlXvZw4A==
X-Received: by 2002:a05:600c:1910:b0:38c:bff7:b9db with SMTP id j16-20020a05600c191000b0038cbff7b9dbmr12633611wmq.182.1649340100678;
        Thu, 07 Apr 2022 07:01:40 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v1-20020adf9e41000000b00205c3d212easm17786210wre.51.2022.04.07.07.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 07:01:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Shuah Khan <shuah@kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: WARNING: at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3156
 mark_page_dirty_in_slot
In-Reply-To: <YkMxGLAG0zqEzt1V@google.com>
References: <CA+G9fYsd+zXJqsxuYkWLQo0aYwmqLVA_YeBu+sr546bGA+1Nfg@mail.gmail.com>
 <YkMxGLAG0zqEzt1V@google.com>
Date:   Thu, 07 Apr 2022 16:01:39 +0200
Message-ID: <87tub56lh8.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Mar 29, 2022, Naresh Kamboju wrote:
>> While running kselftest kvm test cases on x86_64 devices the following
>> kernel warning was reported.
>
> ...
>
>> [   62.510388] ------------[ cut here ]------------
>> [   62.515064] WARNING: CPU: 1 PID: 915 at
>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:3156
>> mark_page_dirty_in_slot+0xba/0xd0
>> [   62.525968] Modules linked in: x86_pkg_temp_thermal fuse
>> [   62.531307] CPU: 1 PID: 915 Comm: hyperv_clock Not tainted 5.17.0 #1
>> [   62.537691] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
>> 2.0b 07/27/2017
>> [   62.545185] RIP: 0010:mark_page_dirty_in_slot+0xba/0xd0
>
> Long known issue.  I think we're all waiting for someone else to post an actual
> patch.
>
> Vitaly, can you formally post the below patch, or do you need feedback first?
>
> https://lore.kernel.org/all/874k51eddp.fsf@redhat.com/
>

Sorry, missed this. Will do.

-- 
Vitaly

