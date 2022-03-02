Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6FA4C9F44
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 09:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240227AbiCBIbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 03:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240276AbiCBIa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 03:30:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD777BABAA
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 00:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646209812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4ju3TXslkK4ikbzwJYtvQpU2DB+d0S/w2MnovYNUeUk=;
        b=LSDk0QzDGFTMZo8ie3l84Q8M5k37KeUt7+akkIqbjXt+JAaP9BAXHH5SbpOvlI01PrH+mX
        uUo4HY55LRvCq05WZZmjm7DFQesBwmZG+2Xo+OFTFjXSDjH5DEGLfcgJINxEPZof9KDhRk
        2aiEzMKzYzseINDxBJTLyA6LS6DJEgA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-zinzY1gLMaOqlYZa9K-tbg-1; Wed, 02 Mar 2022 03:30:11 -0500
X-MC-Unique: zinzY1gLMaOqlYZa9K-tbg-1
Received: by mail-wr1-f72.google.com with SMTP id b7-20020a05600003c700b001efac398af7so345506wrg.22
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 00:30:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4ju3TXslkK4ikbzwJYtvQpU2DB+d0S/w2MnovYNUeUk=;
        b=zfK8iBzK7bUWs6AHJVdykTGaHvc3cTlhi5bF3G2J3haf2CMN4eLvH4c6pMFOStvcI3
         AaD0xxCy0kyy5COaui9IYivqviypFFMQvSYap87UY+GPMB4AICj9oJc/97L82oab1iFz
         ueUj7YLG0xRDccLJvewb9WY3jHOwLgFRW4mA9vVAXczhmL2jgHxWLjBq7yMHA89b2Qu+
         ATnpdfTl3C3OfLPcn/huZ+5uKJN3qecdtMGHQ/xCN9V0C7++G3aHzTG1TP/Uv4FNQ1Qa
         I+zpSVFixffN5/0w6PLFdLJMx8IvWvOpA+Rr0p7SapIq8unKEjiy9l9Hvf25OlgYOIoA
         w12w==
X-Gm-Message-State: AOAM533TA3eYkK/MVeqod4WIKiKr6ni+7bX7SwvrAhzH7H/qbycO9+iM
        YSpAETiZfSQhBQJ8E/25aBCdCQ1yLrv1QWTNaprifGy2hMZdw4hgg+GHbvtuvqAkd9sUdbh+k86
        H96YfQ/Kfx7uJ
X-Received: by 2002:a05:600c:587:b0:381:b2:89b0 with SMTP id o7-20020a05600c058700b0038100b289b0mr20467139wmd.114.1646209810408;
        Wed, 02 Mar 2022 00:30:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUFCa8ddS38oq9IT6e/yWdwiarFYl14hc8Iyy/vjPTuHZpDyCAzWiVC6dCDT5EWZ3tUieAJg==
X-Received: by 2002:a05:600c:587:b0:381:b2:89b0 with SMTP id o7-20020a05600c058700b0038100b289b0mr20467105wmd.114.1646209810176;
        Wed, 02 Mar 2022 00:30:10 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id f4-20020a5d4dc4000000b001d8e67e5214sm16454314wru.48.2022.03.02.00.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 00:30:09 -0800 (PST)
Date:   Wed, 2 Mar 2022 03:30:06 -0500
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
Message-ID: <20220302031738-mutt-send-email-mst@kernel.org>
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
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
> 
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


I got curious, and wrote a dumb benchmark:


#include <stdio.h>
#include <assert.h>
#include <limits.h>
#include <string.h>

struct lng {
	unsigned long long l1;
	unsigned long long l2;
};

struct shrt {
	unsigned long s;
};


struct lng l = { 1, 2 };
struct shrt s = { 3 };

static void test1(volatile struct shrt *sp)
{
	if (sp->s != s.s) {
		printf("short mismatch!\n");
		s.s = sp->s;
	}
}
static void test2(volatile struct lng *lp)
{
	if (lp->l1 != l.l1 || lp->l2 != l.l2) {
		printf("long mismatch!\n");
		l.l1 = lp->l1;
		l.l2 = lp->l2;
	}
}

int main(int argc, char **argv)
{
	volatile struct shrt sv = { 4 };
	volatile struct lng lv = { 5, 6 };

	if (argc > 1) {
		printf("test 1\n");
		for (int i = 0; i < 10000000; ++i) 
			test1(&sv);
	} else {
		printf("test 2\n");
		for (int i = 0; i < 10000000; ++i)
			test2(&lv);
	}
	return 0;
}


Results (built with -O2, nothing fancy):

[mst@tuck ~]$ perf stat -r 1000 ./a.out 1 > /dev/null

 Performance counter stats for './a.out 1' (1000 runs):

              5.12 msec task-clock:u              #    0.945 CPUs utilized            ( +-  0.07% )
                 0      context-switches:u        #    0.000 /sec                   
                 0      cpu-migrations:u          #    0.000 /sec                   
                52      page-faults:u             #   10.016 K/sec                    ( +-  0.07% )
        20,190,800      cycles:u                  #    3.889 GHz                      ( +-  0.01% )
        50,147,371      instructions:u            #    2.48  insn per cycle           ( +-  0.00% )
        20,032,224      branches:u                #    3.858 G/sec                    ( +-  0.00% )
             1,604      branch-misses:u           #    0.01% of all branches          ( +-  0.26% )

        0.00541882 +- 0.00000847 seconds time elapsed  ( +-  0.16% )

[mst@tuck ~]$ perf stat -r 1000 ./a.out > /dev/null

 Performance counter stats for './a.out' (1000 runs):

              7.75 msec task-clock:u              #    0.947 CPUs utilized            ( +-  0.12% )
                 0      context-switches:u        #    0.000 /sec                   
                 0      cpu-migrations:u          #    0.000 /sec                   
                52      page-faults:u             #    6.539 K/sec                    ( +-  0.07% )
        30,205,916      cycles:u                  #    3.798 GHz                      ( +-  0.01% )
        80,147,373      instructions:u            #    2.65  insn per cycle           ( +-  0.00% )
        30,032,227      branches:u                #    3.776 G/sec                    ( +-  0.00% )
             1,621      branch-misses:u           #    0.01% of all branches          ( +-  0.23% )

        0.00817982 +- 0.00000965 seconds time elapsed  ( +-  0.12% )


So yes, the overhead is higher by 50% which seems a lot but it's from a
very small number, so I don't see why it's a show stopper, it's not by a
factor of 10 such that we should sacrifice safety by default. Maybe a
kernel flag that removes the read replacing it with an interrupt will
do.

In other words, premature optimization is the root of all evil.

-- 
MST

