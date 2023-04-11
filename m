Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7B06DD2EF
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 08:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjDKGfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 02:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjDKGfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 02:35:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30680FF
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 23:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681194892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Cf/qv357ca13kf6O82+vlb+EKz3duU5OpGh0AK2ziA=;
        b=QdhdHnc0pO1kIZFfEuCKPYimgUvqcqTp9JQcYfSvO80n6IerdnLr7cRPolNhNqgIJ/6n5q
        SdHOOdWwgmwEUzII9zOL/G9ankHRztu8zia/fA+zl3PSI+8kd96kuk8fNUE4ismid5WG32
        AY0M8qP2fzae9mi/2RAHGhADoWvLPrY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-Eip4uKI8ND6JfzV-cmlYHw-1; Tue, 11 Apr 2023 02:34:51 -0400
X-MC-Unique: Eip4uKI8ND6JfzV-cmlYHw-1
Received: by mail-wm1-f70.google.com with SMTP id n36-20020a05600c502400b003ee93fac4a9so4634032wmr.2
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 23:34:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681194889; x=1683786889;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Cf/qv357ca13kf6O82+vlb+EKz3duU5OpGh0AK2ziA=;
        b=TvIDjdtVExgKNI/ibOdTK5EAbhF0M9cQUdUR09Y0DaXKFN7aFBwcpm1SWpCeFoawmf
         fsF8cN7iAmkSrq0LPGnfS3W+PIfUrql5VgGxGgYhcqFXtjQKpyaFiC7O45C3Jr7S5yEI
         /LCE5v5JeI6gmcUDx5+Lj+prIDHj6VJUzkMEMTXp8Ji0k4zBmEv1UwKYh7SDds8XG2BE
         s9/w0rmB3ma6t+A5X1EmwIn2Qbc4e9ZylYLjxXJGFS2lFiXUuTD/rF7eLu3Lb7brLvr0
         AP4TDHRjFsfU0ocCvKMYXJkgxP0ZlDBUL8BDONbBzSqXvrdHgQtKHXbkUgm0RGKhQDUf
         4Z2w==
X-Gm-Message-State: AAQBX9fiXS7PSYyrOvxSxgCmntHz1e/Bo1HCS4vyifI/SWs6ZFTb1Hud
        +vYJoMqcSXosYk7X2VtSDq2NxNTYTJpz/WR/EztBaGbLacwe/irXihVR1TejgQzM/7G/6HuZ+mL
        at/lVadPc+hyB0/UKyE42
X-Received: by 2002:a05:6000:110e:b0:2cf:ec6c:f253 with SMTP id z14-20020a056000110e00b002cfec6cf253mr1044836wrw.20.1681194889649;
        Mon, 10 Apr 2023 23:34:49 -0700 (PDT)
X-Google-Smtp-Source: AKy350YOU2zbEMzqYmgaRaZzmHmzLjA4stKyKaRTsKOC2o5bn67u0LmxVDMjMH71xkJIITbGoHH9zw==
X-Received: by 2002:a05:6000:110e:b0:2cf:ec6c:f253 with SMTP id z14-20020a056000110e00b002cfec6cf253mr1044825wrw.20.1681194889292;
        Mon, 10 Apr 2023 23:34:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id b16-20020adfe310000000b002f27a6a49d0sm2519213wrj.10.2023.04.10.23.34.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 23:34:48 -0700 (PDT)
Message-ID: <2560f4b4-8620-6160-eee5-4086630bb5cc@redhat.com>
Date:   Tue, 11 Apr 2023 08:34:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [GIT PULL] KVM changes for Linux 6.3-rc7
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
        "'oliver.upton@linux.dev'" <oliver.upton@linux.dev>
References: <20230410153917.1313858-1-pbonzini@redhat.com>
 <CAHk-=wiYktfscvihY0k6M=Rs=Xykx9G7=oT5uCy1A80zpmu1Jg@mail.gmail.com>
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAHk-=wiYktfscvihY0k6M=Rs=Xykx9G7=oT5uCy1A80zpmu1Jg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/10/23 23:05, Linus Torvalds wrote:
> On Mon, Apr 10, 2023 at 8:39 AM Paolo Bonzini<pbonzini@redhat.com>  wrote:
>>    https://git.kernel.org/pub/scm/virt/kvm/kvm.git  tags/for-linus
>>
>> for you to fetch changes up to 0bf9601f8ef0703523018e975d6c1f3fdfcff4b9:
>>
>>    Merge tag 'kvmarm-fixes-6.3-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2023-04-06 13:34:19 -0400)
> Nope, not at all.
> 
> You seem to have tagged the wrong commit. Instead of pointing to that
> "kvmarm fixes" thing, it points to something entirely different.
> 
> Please double-check what happened.

That's the current 6.4 head, so the most likely explanation is that I 
incorrectly ran "git tag ... -F<absolute path> && git push kvm 
+tags/for-linus" again from the wrong window/worktree.  That must have 
been while I was doing a final check of the pull request, between 
preparing the message and sending it; probably something stupid like 
pressing "Enter" instead of "Ctrl-c" after a command line search (for 
example, I typically use Ctrl-r to do the final send without --dry-run).

I've now pushed the correct tag (object hash 7088282073b8).

Out of curiosity, do you have some kind of script that parses the "git 
request-pull" messages and does these checks?  Or was it just the 
mismatch between diffstat and tag message?

Paolo

