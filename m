Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B194C9E7F
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 08:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiCBHn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 02:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbiCBHnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 02:43:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92E711274A
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 23:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646206960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r54KECS5Ta4+XfMPrM9TZqlD4g6ikpj26D7X7GFm2xk=;
        b=cw8cEjwtKGHOv3OYdt3dcxaE388U8YaebEfjyft3HLQk52+f8kLk5SLlNFFeMf4ZvgclRa
        tWekZQ0R7LxzRrqrtdT6aggY98zMpN/rVK0QFQVRrTKCcCz/n3R1swauxIrkfLDAU6NRJ0
        LNqE3aucoohIPvbMj1/nvKQxqXki9vo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-64gqKUhyPFi-V2Acz3RSCw-1; Wed, 02 Mar 2022 02:42:38 -0500
X-MC-Unique: 64gqKUhyPFi-V2Acz3RSCw-1
Received: by mail-wm1-f70.google.com with SMTP id l19-20020a05600c4f1300b003818783847eso229487wmq.2
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 23:42:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r54KECS5Ta4+XfMPrM9TZqlD4g6ikpj26D7X7GFm2xk=;
        b=K+rBDsJRRW2FK3/26979raHcyYfndDJ4c0Fwd0vYOQ+gYu2kT3Jx9MX2KyXR1LsGJA
         QQR3wVx1aCE52/2By+30m1i7tctEqxPu9yDQCao8xDUHL7Msl/XQVT1gZuOUgmz+p2S4
         R7n903QEHzetJlZTVF17mETV7Rjz04zivPLREohC+lIiXfyIHr+zM9CLzdwJBuOu3Cnv
         BWJwFOrjlC26WZfVhrKQABHthTe58g+gNJnD3CmyHtpN/ClPeNUHjarg3WcH0VLAzHIE
         tr6qATAVk+Fxn5Dt1cjpnItRF7BdUtMiP21VVmp/7pM0ku4jd0vLYvO1aE/4syWwNvAD
         gODQ==
X-Gm-Message-State: AOAM533BeGj/CvEFUsyU3sCRokfKbZgCQb/bdBDUURh3YuZFnRN/o1Do
        iRYBlQJqL8Qf/TYebWPxJ65LEOYuqbH0w4OKnRyEQ/0tbdN8KhL8St7f0priMjAZYW1P7GRSqxq
        Pe0GWzTn51pdk
X-Received: by 2002:a05:600c:4ed0:b0:37b:e983:287b with SMTP id g16-20020a05600c4ed000b0037be983287bmr19550320wmq.156.1646206957593;
        Tue, 01 Mar 2022 23:42:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrhIny0LTz+oAiVJdVBdcw7M1SyuYOvWiCd108UgZKej5mVsXb3i5PRUQLI/CVYzNAxiQ1tA==
X-Received: by 2002:a05:600c:4ed0:b0:37b:e983:287b with SMTP id g16-20020a05600c4ed000b0037be983287bmr19550301wmq.156.1646206957345;
        Tue, 01 Mar 2022 23:42:37 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id n15-20020a05600c4f8f00b003842f011bc5sm1040455wmq.2.2022.03.01.23.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 23:42:36 -0800 (PST)
Date:   Wed, 2 Mar 2022 02:42:33 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Laszlo Ersek <lersek@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        linux-hyperv@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alexander Graf <graf@amazon.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        adrian@parity.io,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Linux PM <linux-pm@vger.kernel.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: propagating vmgenid outward and upward
Message-ID: <20220302024137-mutt-send-email-mst@kernel.org>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
 <223f858c-34c5-3ccd-b9e8-7585a976364d@redhat.com>
 <Yh5JwK6toc/zBNL7@zx2c4.com>
 <20220301121419-mutt-send-email-mst@kernel.org>
 <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022 at 07:37:06PM +0100, Jason A. Donenfeld wrote:
> Hi Michael,
> 
> On Tue, Mar 1, 2022 at 6:17 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > Hmm okay, so it's a performance optimization... some batching then? Do
> > you really need to worry about every packet? Every 64 packets not
> > enough?  Packets are after all queued at NICs etc, and VM fork can
> > happen after they leave wireguard ...
> 
> Unfortunately, yes, this is an "every packet" sort of thing -- if the
> race is to be avoided in a meaningful way. It's really extra bad:
> ChaCha20 and AES-CTR work by xoring a secret stream of bytes with
> plaintext to produce a ciphertext. If you use that same secret stream
> and xor it with a second plaintext and transmit that too, an attacker
> can combine the two different ciphertexts to learn things about the
> original plaintext.

So what about the point about packets queued then? You don't fish
packets out of qdisc queues, do you?

> But, anyway, it seems like the race is here to stay given what we have
> _currently_ available with the virtual hardware. That's why I'm
> focused on trying to get something going that's the least bad with
> what we've currently got, which is racy by design. How vitally
> important is it to have something that doesn't race in the far future?
> I don't know, really. It seems plausible that that ACPI notifier
> triggers so early that nothing else really even has a chance, so the
> race concern is purely theoretical. But I haven't tried to measure
> that so I'm not sure.
> 
> Jason

