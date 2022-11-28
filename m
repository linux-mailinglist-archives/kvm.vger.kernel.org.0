Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEF063B0D9
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 19:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbiK1SN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 13:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiK1SNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 13:13:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70DB303D2
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 09:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669658057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+uFyPjLnwKMD6Xl5l2PYu2qfTLueZbWcvV6HwAdYcQU=;
        b=LwJpu2G442XAY30wjghZXcStQegzc4Rc5n1Itow1RYgq1DCWrGbasgMRrAyyd0pxpi1DLn
        oQ2d98jX3hYPvNPz2/uIjuem4nvZWVpe+o6PzKWgdLEgEulp3u2+6gQLzUr8UzhgRe2czY
        awI4cocowboVGGnUzflU6AZuAYU1KZk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-7-r7lqW_ruPT6ZMQFyCoz2XA-1; Mon, 28 Nov 2022 12:54:15 -0500
X-MC-Unique: r7lqW_ruPT6ZMQFyCoz2XA-1
Received: by mail-wr1-f72.google.com with SMTP id l8-20020adfc788000000b00241ef50e89eso2221067wrg.0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 09:54:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+uFyPjLnwKMD6Xl5l2PYu2qfTLueZbWcvV6HwAdYcQU=;
        b=UDrPDd/rP0KgcRw9gNWKqS1sYIqrIJ0A8jYDL4ZqY4GJlXAG7rWAu9MuETJV0idX16
         EoPYyvaefvdlD19t/qeO/1Hs7dZTHow5qI2JyBP0h1Ko1LEcQwLvHg4Gk3YENNIoRz+U
         N8hs7YtEmh8DB1eEitrKggs4OJE2vi/6BQ+tBUNE6N8z2WRkNfcyRf+cjYePjQd8ojHY
         bvDxLI5xrCTTwa5BKVjCchPHm+xXuphI2cGWuI2L+vPRmALQ1hW6idpll4vsnIqLzmb/
         znjLxJCYBjq41Tex6LkbgUz4M0rkBroNE89FoB4rDsXKJOyza/EtfBryJsOqd+Wmq2/P
         Noww==
X-Gm-Message-State: ANoB5plOkO8EIvOLFR+VZL7gBulVbs37zfQntmcr077vZ5vsxGyEYTyI
        oTpa1DD4CRGNC4lVeGAJk1KRIlIP2gkhq3ptHfITIrILJIfQYlYd14EP/RtBmBN9570OsduaFdq
        1sFvCetL9mrcj
X-Received: by 2002:a5d:4946:0:b0:241:f7b9:7c05 with SMTP id r6-20020a5d4946000000b00241f7b97c05mr15086900wrs.528.1669658054362;
        Mon, 28 Nov 2022 09:54:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6O9CsyS+uyvKXPFErqjzGVPi3pMEpnvSXZjfvMVTOq1imw4NDu2tjfkes2nOccdjIUpzY1SQ==
X-Received: by 2002:a5d:4946:0:b0:241:f7b9:7c05 with SMTP id r6-20020a5d4946000000b00241f7b97c05mr15086886wrs.528.1669658054072;
        Mon, 28 Nov 2022 09:54:14 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id n11-20020adfe78b000000b0023677fd2657sm11434048wrm.52.2022.11.28.09.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 09:54:13 -0800 (PST)
Message-ID: <0f4b560d-8148-6a1e-6634-6d31168d5032@redhat.com>
Date:   Mon, 28 Nov 2022 18:54:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: Nvidia GPU PCI passthrough and kernel commit
 #5f33887a36824f1e906863460535be5d841a4364
Content-Language: en-US
To:     "Ashish Gupta (SJC)" <ashish.gupta1@nutanix.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        John Levon <john.levon@nutanix.com>
References: <PH0PR02MB84228844F6176836E8C86B1BA40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
 <df01b973-d56c-7ba9-866f-9ca47dccd123@redhat.com>
 <PH0PR02MB84229CEBB3C7A8DAC626107CA40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
 <PH0PR02MB8422D2C6A7F56200FCD384D8A40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
 <CABgObfa+NKKeV=178L348VfrZkB7sa2kCZ1V1kwU+3pKfUd2jg@mail.gmail.com>
 <PH0PR02MB84221C062510FCFAEE7EE9BAA4109@PH0PR02MB8422.namprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <PH0PR02MB84221C062510FCFAEE7EE9BAA4109@PH0PR02MB8422.namprd02.prod.outlook.com>
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

On 11/27/22 19:29, Ashish Gupta (SJC) wrote:
> Hi Paolo,
> 
> I checked on Ubuntu 20.04 with kernel 6.0.
> 
> Nvidia GPU PCI passthrough working fine there.
> 
> Any guess, if this could be problem in 5.10.x and fixed by some 
> subsequent commit.

Yes, most likely (and also that's probably why it wasn't reported until 
now).  If you would like it to be fixed in 5.10, you can try the latest 
release of all the 5.10-5.19 stable branches.  Having the first fixed 
release might be enough to figure out a candidate fix.

Paolo

