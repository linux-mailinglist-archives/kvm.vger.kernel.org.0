Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF33797CC0
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 21:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237376AbjIGTba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 15:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243518AbjIGRWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 13:22:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D91135
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 10:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694107209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T19fvwwZwYYxN0N2ir2GwX4u4CAMB7SDLx2HtMxv4lk=;
        b=a7nsgWt/6no8YN6pgosTNA+KnPOCojA72QyJrms3YvLEgNjyegKCh0XFzfIUb7YI8al4W1
        fTMKhk9aNsnJ5nHKBiMcyr+j2JeoJYO15qj8AnGsNUjhJdG8zrW33sa94liy5DrpfZuyD2
        5iuX7yw0uc9dalEa9APhyAmHAJkf8ZA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-Biq_1bLnNVinpIASYQw43A-1; Thu, 07 Sep 2023 06:55:06 -0400
X-MC-Unique: Biq_1bLnNVinpIASYQw43A-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-314256aedcbso545823f8f.0
        for <kvm@vger.kernel.org>; Thu, 07 Sep 2023 03:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694084105; x=1694688905;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T19fvwwZwYYxN0N2ir2GwX4u4CAMB7SDLx2HtMxv4lk=;
        b=B+nzT5+WE/gA5jSWDMNb353DkBOzQ0V6TDvJl42mV3nTZu35W6+GCYhukoStLRuRRw
         WC0l3WlnNbg56HOcK6IEVxreOQ3TJjv8C09djo8TOPKikGdgKYE+HEZNaSgv2ZEyorXR
         +QcYXN/u71CmPkgvaODNGb8Umc3kTj6r86IqkFqxE7U6AVCl/loYtWLeICvwyWn8hzxT
         OQdv+M2TbIx/vQRQGg6JMrUOA8XNL/LrnBe/9YuCjxK3aso4sw3K1g+qbC6vJOT6UHSL
         I3xm1s2nL3MSLqWjSqRFgdwip3HG8XThVhZMBPt16c3Tyjhldnj+S9M8YTIHd9W41XQd
         Y2vg==
X-Gm-Message-State: AOJu0YyZdUGhuIoSI5vlZyoFmcFGGz3u1rSIOu+9Ba7ii4kwfa6nSzRW
        /WZVVAR883ZPggSRbLplO5tmPg00z9gQjhdBAa6JuehmEYlpqRuYd2lEeqrjlHeBmnUlZiVGNue
        mC9QIsQbVul9O
X-Received: by 2002:a7b:c8ca:0:b0:3fc:21:2c43 with SMTP id f10-20020a7bc8ca000000b003fc00212c43mr4445662wml.13.1694084105368;
        Thu, 07 Sep 2023 03:55:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqFWYOgdb5RcycadIErqmAG5PL6+JJULN0r3CFf2H3pMoBcI8MCKupsm+TZ8wkJ5cFFMPe/Q==
X-Received: by 2002:a7b:c8ca:0:b0:3fc:21:2c43 with SMTP id f10-20020a7bc8ca000000b003fc00212c43mr4445653wml.13.1694084105063;
        Thu, 07 Sep 2023 03:55:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312::1fc? ([2001:b07:6468:f312::1fc])
        by smtp.googlemail.com with ESMTPSA id k20-20020a7bc414000000b003fd2e898aa3sm1433469wmi.0.2023.09.07.03.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Sep 2023 03:55:04 -0700 (PDT)
Message-ID: <0634f55b-e319-ba29-0746-eea826cc7f94@redhat.com>
Date:   Thu, 7 Sep 2023 12:55:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Jari Ruusu <jariruusu@protonmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <NOTSPohUo5EZSaOrRTX88K-vU9QJqeV2Vqti75bEwTpckXBiudKyWw97EDAbgp9ODnk8-lCVBVNCYdd7YygWY5S2n-Yoz_BiJ13DeNLEItI=@protonmail.com>
 <ZPeBE5aZqLwdnspl@google.com>
 <DSxaeYtslZW13dZU36PVY2RooaqU99qcXgPSYkyw6F5t8LSJk8MkAn1shTVrb-cAFRaKEVr5VDrWD6JRmSTlpDbGrHBiM-8zHwIiH90nNHI=@protonmail.com>
 <ZPeV1GWQWeH48a2G@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm ignores ignore_msrs=1 VETO for some MSRs
In-Reply-To: <ZPeV1GWQWeH48a2G@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/5/23 22:55, Sean Christopherson wrote:
> On Tue, Sep 05, 2023, Jari Ruusu wrote:
>> On Tuesday, September 5th, 2023 at 22:27, Sean Christopherson <seanjc@google.com> wrote:
>>> As for working around this in your setup, assuming you don't actually need a
>>> virtual PMU in the guest, the simplest workaround would be to turn off vPMU
>>> support in KVM, i.e. boot with kvm.enable_pmu=0. That should cause QEMU to not
>>> advertise a PMU to the guest.
>>
>> Newer host kernels seem to have kvm.enable_pmu parameter,
>> but linux-5.10.y kernels do not have that.
> 
> Gah, try kvm.pmu.
> 
> Commit 4732f2444acd ("KVM: x86: Making the module parameter of vPMU more common")
> renamed the variable to avoid collisions, but it unnecessarily changed the name
> exposed to userspace too.  My gut reaction is to revert the param name back to
> "pmu".
> 
> Paolo, any idea if reverting "enable_pmu" back to "pmu" would be worth the churn?

Hmm, 5.17 is almost a couple years old so I'm debating it...  Probably 
not, but I wouldn't complain either way.

Paolo

