Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F555B36E6
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 14:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiIIMDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 08:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIIMDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 08:03:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8D8C0BD8
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 05:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662724978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wjpmu9u4qwdnH4a30y2Ux10ogI6BAeP5cRwQHpYLzpo=;
        b=Mhpewv7HyQ+cysiVDlw0oirRf64Kh1Dbfr9NneXD69DLPWXaxU4zUgX63d4/56hhrkiDlK
        SKqANk5y+WeHu0SlvWYfVUNVIDeaAoFSchc7Zc+ECvliH/7mcKiHq34XYeAYP7aJfP+rzz
        WQauLlX+J1+DwLkwiUdhUSudIaDPAEs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-31-cP3SMsQFPT2wFvPWJ_U8tw-1; Fri, 09 Sep 2022 08:02:57 -0400
X-MC-Unique: cP3SMsQFPT2wFvPWJ_U8tw-1
Received: by mail-wr1-f69.google.com with SMTP id v15-20020adf8b4f000000b002285ec61b3aso295236wra.6
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 05:02:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Wjpmu9u4qwdnH4a30y2Ux10ogI6BAeP5cRwQHpYLzpo=;
        b=UBatHhjz1dxN5ccZOIoljdx6iqg/dWG/4omceX47KFvjEYuHbNmB2+7o52jxvLdokP
         LeUgmK96OEE4XsglBtPBNLOQmCdPp9LUAQziMWCoVkqVDmz5kROKJCoaCQ/QwTDKF66V
         6rFEkL8/qyZMcCWDgfJMadbJj+drs5OlTb85z255P6I14giiFkQ7ST/5IULI74SGxbOf
         Q9Wpr1bBT0hzJIFC2q/RUH27eu96aJO0mTqtIZXF5c0GNPDciLruO5KNHsPNDrmcvqyn
         QTxSckXadiPwMnanDVuyE9KR5MsQYd4yOLyX9GHitBrtm2zpp7zqXsT9rNE/RYD2anNV
         bbMA==
X-Gm-Message-State: ACgBeo018lY5n5EW1i5wEaFJM/Ymn9usejCQO8k2biKPJf/zsrJDXoSv
        IYgsP90UN1XXyM2i539o7OW07ebu9QBjHV6r8iiWxPMt1ibm0XtNh6yI7Ou0nQ3i44JYDAWuuCW
        OFkIooxR7spDj
X-Received: by 2002:a1c:f016:0:b0:3a8:3d3b:6b8a with SMTP id a22-20020a1cf016000000b003a83d3b6b8amr5210250wmb.168.1662724975935;
        Fri, 09 Sep 2022 05:02:55 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5YGR1txRJVt7SxZFEcay9yaUc5SK0hrQEq1QvfrbkkHfUFZZR+VcL1qOlkCh/yv4+j47O4Xw==
X-Received: by 2002:a1c:f016:0:b0:3a8:3d3b:6b8a with SMTP id a22-20020a1cf016000000b003a83d3b6b8amr5210231wmb.168.1662724975688;
        Fri, 09 Sep 2022 05:02:55 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:6300:1fe0:42e1:62c5:91b6? (p200300cbc70463001fe042e162c591b6.dip0.t-ipconnect.de. [2003:cb:c704:6300:1fe0:42e1:62c5:91b6])
        by smtp.gmail.com with ESMTPSA id j8-20020a5d5648000000b00228bf773b1fsm374376wrw.7.2022.09.09.05.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 05:02:55 -0700 (PDT)
Message-ID: <30566203-bbf6-786e-d4b7-f0003ee35e37@redhat.com>
Date:   Fri, 9 Sep 2022 14:02:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [GIT PULL] VFIO fix for v6.0-rc5
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20220909045225.3a572a57.alex.williamson@redhat.com>
 <CAHk-=wj3rrkPvPJB_u4qoHK4=PVUuBHKB67f_oZO62EE22pNPQ@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAHk-=wj3rrkPvPJB_u4qoHK4=PVUuBHKB67f_oZO62EE22pNPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.09.22 13:53, Linus Torvalds wrote:
> On Fri, Sep 9, 2022 at 6:52 AM Alex Williamson
> <alex.williamson@redhat.com> wrote:
>>
>> VFIO fix for v6.0-rc5
>>
>>   - Fix zero page refcount leak (Alex Williamson)
> 
> Ugh. This is disgusting.
> 
> Don't get me wrong - I've pulled this, but I think there's some deeper
> problem that made this patch required.
> 
> Why is pin_user_pages_remote() taking a reference to a reserved page?
> Maybe it just shouldn't (and then obviously we should fix the unpin
> case to match too).
> 
> Adding a few GUP people to the participants for comments.
> 
> Anybody?

I mentioned in an offline discussion to Alex that we should teach the 
pin/unpin interface to not mess with the zeropage at all (i.e., not 
adjust the refcount and eventually overflow it).

We decided that the unbalanced pin/unpin should be fixed independently, 
such that the refcount handling change on pin/unpin stays GUP internal.


-- 
Thanks,

David / dhildenb

