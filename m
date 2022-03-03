Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D70F4CBE84
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 14:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbiCCNIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 08:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiCCNIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 08:08:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98F80184B67
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 05:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646312844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lj6VpxefHrxOOwhnhf4/p/2XcRsNuTwXL6WEnQsA11I=;
        b=AFKMr6vLTJWojOBP40PvbVBn1m5IyHKXATf+pa5Hobu4V5OMP8sbaNFrn+rxqJIZMY15iN
        DpEF1aJMLtM2sKgimKisKN0yB7SxGzq99mg2ISELIhDlyS9YhsahXYv2X/4KtBnimaT9GD
        VzKKoNEgpTnrfsm+cqLLd7wlZiJ2S+w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-6DY_BCK8PKyklLT_wYiCZA-1; Thu, 03 Mar 2022 08:07:23 -0500
X-MC-Unique: 6DY_BCK8PKyklLT_wYiCZA-1
Received: by mail-wr1-f72.google.com with SMTP id g17-20020adfa591000000b001da86c91c22so2024107wrc.5
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 05:07:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lj6VpxefHrxOOwhnhf4/p/2XcRsNuTwXL6WEnQsA11I=;
        b=6jKTuVzTsYyZSdB9afYS++uusedLUWVF+GsXDiM46oFtcjEtn27rikMlPtcVAik2gI
         WPgY+OsjK8vKvHJwWWlnrP/30+idAMX/+21ar6BGXVi8us1+R8f0eAomEYjb+Znnd3+3
         T7Wd8559/XGiN35YfIypkGvFycxZSLqSnKBEXYgrn+WvELmniTu/EjI8CONn9GtpENF/
         tPmPtP5T4xhpMxSUdzfF+r80OsTey/UdetOKDsX2MvYEeG+X7Agf2Jr3M3bxyCr6bSYH
         I7TRYpx63VtX1i332GW3X7F5cCIWxPdgjtQadroOMTdcLIdQp5OGKVA8mWFtXL2TSLhr
         cOzQ==
X-Gm-Message-State: AOAM531iRoAgYZZOWHMfpw5Oz+piPFBap8AkxNJJdVFQCMq2XqhwSKju
        cVmQE8J0h0hpELqx0enuyxr7FVAVrgZJVxUrLo+MCwpQlr8kyOTqVkeZt4zmbVZU1G6wSejM6kU
        RgyXv4BPDGHgp
X-Received: by 2002:a5d:5512:0:b0:1ef:5f08:29fb with SMTP id b18-20020a5d5512000000b001ef5f0829fbmr23412282wrv.653.1646312842498;
        Thu, 03 Mar 2022 05:07:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBprWCBbiaeng1f6eFEkBly6o9vzAc3MArh79lj54xDzLKMIA0Xs/dF3R5oQGH8dSoCNnPBA==
X-Received: by 2002:a5d:5512:0:b0:1ef:5f08:29fb with SMTP id b18-20020a5d5512000000b001ef5f0829fbmr23412254wrv.653.1646312842242;
        Thu, 03 Mar 2022 05:07:22 -0800 (PST)
Received: from redhat.com ([2.55.143.133])
        by smtp.gmail.com with ESMTPSA id f1-20020a5d4dc1000000b001eeadc98c0csm1908052wru.101.2022.03.03.05.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 05:07:20 -0800 (PST)
Date:   Thu, 3 Mar 2022 08:07:16 -0500
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
Message-ID: <20220303075426-mutt-send-email-mst@kernel.org>
References: <20220302031738-mutt-send-email-mst@kernel.org>
 <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
 <20220302074503-mutt-send-email-mst@kernel.org>
 <Yh93UZMQSYCe2LQ7@zx2c4.com>
 <20220302092149-mutt-send-email-mst@kernel.org>
 <CAHmME9rf7hQP78kReP2diWNeX=obPem=f8R-dC7Wkpic2xmffg@mail.gmail.com>
 <20220302101602-mutt-send-email-mst@kernel.org>
 <Yh+PET49oHNpxn+H@zx2c4.com>
 <20220302111737-mutt-send-email-mst@kernel.org>
 <Yh+cB5bWarl8CFN1@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh+cB5bWarl8CFN1@zx2c4.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 05:32:07PM +0100, Jason A. Donenfeld wrote:
> Hi Michael,
> 
> On Wed, Mar 02, 2022 at 11:22:46AM -0500, Michael S. Tsirkin wrote:
> > > Because that 16 byte read of vmgenid is not atomic. Let's say you read
> > > the first 8 bytes, and then the VM is forked.
> > 
> > But at this point when VM was forked plaintext key and nonce are all in
> > buffer, and you previously indicated a fork at this point is harmless.
> > You wrote "If it changes _after_ that point of check ... it doesn't
> > matter:"
> 
> Ahhh, fair point. I think you're right.
> 
> Alright, so all we're talking about here is an ordinary 16-byte read,
> and 16 bytes of storage per keypair, and a 16-byte comparison.
> 
> Still seems much worse than just having a single word...
> 
> Jason

Oh I forgot about __int128.



#include <stdio.h>
#include <assert.h>
#include <limits.h>
#include <string.h>

struct lng {
	__int128 l;
};

struct shrt {
	unsigned long s;
};


struct lng l = { 1 };
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
	if (lp->l != l.l) {
		printf("long mismatch!\n");
		l.l = lp->l;
	}
}

int main(int argc, char **argv)
{
	volatile struct shrt sv = { 4 };
	volatile struct lng lv = { 5 };

	if (argc > 1) {
		printf("test 1\n");
		for (int i = 0; i < 100000000; ++i) 
			test1(&sv);
	} else {
		printf("test 2\n");
		for (int i = 0; i < 100000000; ++i)
			test2(&lv);
	}
	return 0;
}


with that the compiler has an easier time to produce optimal
code, so the difference is smaller.
Note: compiled with
gcc -O2 -mno-sse -mno-sse2 -ggdb bench3.c 

since with sse there's no difference at all.


[mst@tuck ~]$ perf stat -r 100 ./a.out 1 > /dev/null 


 Performance counter stats for './a.out 1' (100 runs):

             94.55 msec task-clock:u              #    0.996 CPUs utilized            ( +-  0.09% )
                 0      context-switches:u        #    0.000 /sec                   
                 0      cpu-migrations:u          #    0.000 /sec                   
                52      page-faults:u             #  548.914 /sec                     ( +-  0.21% )
       400,459,851      cycles:u                  #    4.227 GHz                      ( +-  0.03% )
       500,147,935      instructions:u            #    1.25  insn per cycle           ( +-  0.00% )
       200,032,462      branches:u                #    2.112 G/sec                    ( +-  0.00% )
             1,810      branch-misses:u           #    0.00% of all branches          ( +-  0.73% )

         0.0949732 +- 0.0000875 seconds time elapsed  ( +-  0.09% )

[mst@tuck ~]$ 
[mst@tuck ~]$ perf stat -r 100 ./a.out > /dev/null 

 Performance counter stats for './a.out' (100 runs):

            110.19 msec task-clock:u              #    1.136 CPUs utilized            ( +-  0.18% )
                 0      context-switches:u        #    0.000 /sec                   
                 0      cpu-migrations:u          #    0.000 /sec                   
                52      page-faults:u             #  537.743 /sec                     ( +-  0.22% )
       428,518,442      cycles:u                  #    4.431 GHz                      ( +-  0.07% )
       900,147,986      instructions:u            #    2.24  insn per cycle           ( +-  0.00% )
       200,032,505      branches:u                #    2.069 G/sec                    ( +-  0.00% )
             2,139      branch-misses:u           #    0.00% of all branches          ( +-  0.77% )

          0.096956 +- 0.000203 seconds time elapsed  ( +-  0.21% )

-- 
MST

