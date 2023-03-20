Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5F56C1CFF
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 17:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbjCTQ63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 12:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbjCTQ6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 12:58:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1266A6C
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 09:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679330936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8jLk4WbwvS9Ny13bH7DClBsHew7f2C7O1NAotrJay2U=;
        b=SSk2uoRqln87w2bV7vCkqoFiLo7NY+3zuik3yZvwWq7fp2giIqMuMqGDka5dMb+8UPAtkE
        wpIlAmgvndWy4VgL6iwrHJJ3zbVTgqjOzDfTRWjso8oYFCMxqEyMK1Tf6ZUzlBsR2WAV0O
        HP+FqBuAklQ6CE7WYpn0hENuj9CccdI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-n9nPlFU1OyeBpSlCZktQWg-1; Mon, 20 Mar 2023 12:48:55 -0400
X-MC-Unique: n9nPlFU1OyeBpSlCZktQWg-1
Received: by mail-qv1-f71.google.com with SMTP id c15-20020a056214070f00b005bb308e7c12so5215474qvz.19
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 09:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679330934;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8jLk4WbwvS9Ny13bH7DClBsHew7f2C7O1NAotrJay2U=;
        b=H+m9if/mIhbqKVm20kq2wuG/J+3YhvujdMT4j2CsFH821RHtomxkDvOqKiaQ6S9NCO
         FbqgoMXRIy4UHHqiGa0NmeebQHOxjzyP//km1TqCEgDUC7tcUwj7S/kKVZyRRoDwbPsq
         ft43Gbgm2ZIm3vPEu5cZwcJu2oqD31gzkXKbmjY0yjgOQwl5KETGCMCfWHhM/aG+oqhY
         tf7kWNNYcpCXC4Zw361/nNylWri0qrfOUB3bKtihnThuRuqgu0CaAjyY0n+AZ7hPb6mQ
         +vWtyr9GG6yLhdg9lf145/lonCjQTBNgZ4u/oxBiD/dfXrjUkfjzHbGD29IaQ0v5F/NI
         ivXw==
X-Gm-Message-State: AO0yUKXUUHK86UjXq9bNns6GrSBeDDWs2laqpkxUy/vYjLN4RyyJv3sW
        msA/qRCh9zdoji3izeLUs/FPfmuwOoRkD73NSTjCXSljlaOWTOQFdVwSAncsZdLwmblWVXXlt+j
        XKYrX9cQ04NOl
X-Received: by 2002:a05:622a:315:b0:3e3:7cf1:c453 with SMTP id q21-20020a05622a031500b003e37cf1c453mr2812305qtw.18.1679330934528;
        Mon, 20 Mar 2023 09:48:54 -0700 (PDT)
X-Google-Smtp-Source: AK7set/nha1fcO+y4yO4p9AC5bCoFlYVNIMLGxBzqcQix8NlbIGIUZJ7jJj7d5Agz6/Uf8LuvPgs3g==
X-Received: by 2002:a05:622a:315:b0:3e3:7cf1:c453 with SMTP id q21-20020a05622a031500b003e37cf1c453mr2812271qtw.18.1679330934232;
        Mon, 20 Mar 2023 09:48:54 -0700 (PDT)
Received: from [192.168.149.90] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id w2-20020ac87182000000b003b9a6d54b6csm6615687qto.59.2023.03.20.09.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 09:48:53 -0700 (PDT)
Message-ID: <c83cb646-ce29-5397-aa1b-4a26f92a6102@redhat.com>
Date:   Mon, 20 Mar 2023 17:48:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/3] kvm: vmx: Add IA32_FLUSH_CMD guest support
Content-Language: de-CH
To:     Sean Christopherson <seanjc@google.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Nathan Chancellor <nathan@kernel.org>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Ben Serebrin <serebrin@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230201132905.549148-1-eesposit@redhat.com>
 <20230201132905.549148-2-eesposit@redhat.com>
 <20230317190432.GA863767@dev-arch.thelio-3990X>
 <20230317225345.z5chlrursjfbz52o@desk>
 <20230317231401.GA4100817@dev-arch.thelio-3990X>
 <20230317235959.buk3y25iwllscrbe@desk> <ZBhzhPDk+EV1zRf0@google.com>
 <301c7527-6319-b993-f43f-dc61b9af4b34@redhat.com>
 <ZBiIt2LBoogxQ2jP@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <ZBiIt2LBoogxQ2jP@google.com>
Content-Type: text/plain; charset=UTF-8
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



Am 20/03/2023 um 17:24 schrieb Sean Christopherson:
> On Mon, Mar 20, 2023, Emanuele Giuseppe Esposito wrote:
>>
>> Am 20/03/2023 um 15:53 schrieb Sean Christopherson:
>>> The patches obviously weren't tested,
>> Well... no. They were tested. Call it wrongly tested, badly tested,
>> whatever you want but don't say "obviously weren't tested".
> 
> Heh, depends on how you define "tested".  I was defining tested as "tested to
> work as expected on systems with and without support for IA32_FLUSH_CMD".
> 
> But yeah, I should have said "properly tested".
> 
>> I even asked you in a private email why the cpu flag was visible in Linux and
>> not in rhel when using the same machine.
>>
>> So again, my bad with these patches, I sincerely apologize but I would
>> prefer that you think I don't know how to test this stuff rather than
>> say that I carelessly sent something without checking :)
> 
> I didn't intend to imply that you didn't try to do the right thing, nor am I
> unhappy with you personally.  My apologies if my response came off that way.
> 
> What I am most grumpy about is that this series was queued without tests.  E.g.
> unless there's a subtlety I'm missing, a very basic KVM-Unit-Test to verify that
> the guest can write MSR_IA32_FLUSH_CMD with L1D_FLUSH when the MSR is supported
> would have caught this bug.  One of the reasons for requiring actual testcases is
> that dedicated testcases reduce the probability of "testing gone wrong", e.g. a
> TEST_SKIPPED would have alerted you that the KVM code wasn't actually being exercised.
> 
Yeah, I should have added a test. I see what you mean.

Anyways, as the cover letter said patches 1-2 are both unnecessary and
taken from an old past serie that was left unanswered (that's why I
thought it was lost).
What mainly interested me was patch 3, ie advertising FLUSH_L1D to user
space. As far as I understand, that looks good to you, right?

I'll be happy to do the exercise and resend all three patches plus an
unit test to verify it works if you want. But if you think they are
useless, just drop the first two and take only the third.

As always, I appreciate you&Paolo&others feedback :)

Let me know what you think.

Thank you,
Emanuele

