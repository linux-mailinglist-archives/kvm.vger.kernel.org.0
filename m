Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E949050E1DA
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 15:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242079AbiDYNet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 09:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237070AbiDYNeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 09:34:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE17ABCD
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 06:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650893500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2J9nQuOx9gLdZyowRFU9MRgC1pGvNVOyWwzdGodnxr0=;
        b=NUE3eDkt9ujYHiaXJ5YPwUSEZDYcDoT3qjirpPM3og7J9loOrCxBFVDNYR7ZmFCVISBnOO
        e80PeWrwclYUKLubjZtfD6wIOCB01PmAkXOWg7TUbIUp7msg+r6545YOY0WuV+CXyrft9E
        4SZImBUByz8mRH144c4+4qBa9MV557o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-ooqt-V2sOeKiSPnj2QJGPg-1; Mon, 25 Apr 2022 09:31:38 -0400
X-MC-Unique: ooqt-V2sOeKiSPnj2QJGPg-1
Received: by mail-wm1-f71.google.com with SMTP id t2-20020a7bc3c2000000b003528fe59cb9so7158939wmj.5
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 06:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2J9nQuOx9gLdZyowRFU9MRgC1pGvNVOyWwzdGodnxr0=;
        b=rMMxK0R9GFSQaQDBWOWoKRvtFFZae+Aqsg5DEQV0Zp8/lxhEG5Gwwx0gz2NdDjgsc2
         NA1piNWAxuwScTeGpd2xKzLEmU57rmZaRGNJlvr4AkfhOllvyu0hMv7VJJjR74onpQ8R
         MT2AyADK3EykIzhXeGch4F/zUTrvSKLD8A6nlE/6FpjxkSL47jNLi2JMNRzoz3PraDHT
         KVdtTGExaJpEo6Q/zM+UYF9s0jLs4YvucGHK+153EfuWgdg15bLnJvjmOtlL8eW9Qi0v
         9VRdWWY/phFiQIGGyzPHDQy+I+E7K9JYeVyaTukCWQ49ThBmsya3HdTpuuXByjxzpgti
         skag==
X-Gm-Message-State: AOAM530OpmY4qdJ+lUNBFDuWBkQem1ENb7ZyWEM8/XMNtqIcFIgUbeOI
        rBkR12IpNa7xc0IwOkiz8hTB98rMTPutNuwHgeL/x7qknvIyByMPbiyJYGHv9DVy1xpPiGGc7AU
        +TFYnf7srV+LU
X-Received: by 2002:a1c:2546:0:b0:392:b691:1eed with SMTP id l67-20020a1c2546000000b00392b6911eedmr16551375wml.200.1650893497482;
        Mon, 25 Apr 2022 06:31:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzu0N74WSl0++W5eoD5gFbLKhoRCeHYOXMNbTRsbUr6pwlg73ilLKDTUjO+JzE+k0OhXahn/w==
X-Received: by 2002:a1c:2546:0:b0:392:b691:1eed with SMTP id l67-20020a1c2546000000b00392b6911eedmr16551361wml.200.1650893497254;
        Mon, 25 Apr 2022 06:31:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id m35-20020a05600c3b2300b00393ebe201a6sm2938665wms.44.2022.04.25.06.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 06:31:36 -0700 (PDT)
Message-ID: <19e902c3-b3cd-a9cc-be0f-d709b2a52c77@redhat.com>
Date:   Mon, 25 Apr 2022 15:31:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests RESEND PATCH v3 0/8] Move npt test cases and NPT
 code improvements
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, seanjc@google.com
Cc:     kvm@vger.kernel.org
References: <20220425114417.151540-1-manali.shukla@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220425114417.151540-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/25/22 13:44, Manali Shukla wrote:
> If __setup_vm() is changed to setup_vm(), KUT will build tests with
> PT_USER_MASK set on all PTEs. It is a better idea to move nNPT tests
> to their own file so that tests don't need to fiddle with page tables midway.

Sorry, I have already asked this but I don't understand: why is it 
problematic to have PT_USER_MASK set on all PTEs, since you have a patch 
(3) to "allow nSVM tests to run with PT_USER_MASK enabled"?

Paolo

