Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC9E4C429C
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 11:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239602AbiBYKlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 05:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239755AbiBYKlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 05:41:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D103C1ACA16
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 02:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645785630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRwx65i57jRl4bCHTSkVyWCFjWZQA8Tr5rcxePhpjvg=;
        b=Ley5VrTImoinUCiieYCuf+v48RdQj1gjzaqzl5tJTGzufT1IDseeN1jDaigmYW/aBhGkZY
        j6RmcxkE8p1xypXbBsqUgi8D0bXUhZMzVARxDsWRDYtC79zhfwiNPBthHakggeTfx78nUX
        +PhIr0NLC1JVb9cBhV6Dxy0NhP4hQ64=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-9UJtmOF7N5C06Nzw305Gqg-1; Fri, 25 Feb 2022 05:40:28 -0500
X-MC-Unique: 9UJtmOF7N5C06Nzw305Gqg-1
Received: by mail-wr1-f70.google.com with SMTP id v24-20020adf8b58000000b001eda5c5cf95so720955wra.18
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 02:40:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lRwx65i57jRl4bCHTSkVyWCFjWZQA8Tr5rcxePhpjvg=;
        b=43/UukDl0b6d+fU/HLdQ9nlJeu+B5eUjZmmJ+ZUiPQ2N7jhoM1GqVh/ROZIlFYeHLJ
         4mohiRSagQOmALim+LeN3cB2Jo4RGl4P23W1WiBmIqo/5L/ZOCM3mNKnBXy5j+LjprrK
         I5v177qiCkgW1Wkd26JbFH1XUKePE9OdJt/5+BT4LDQrU4a3nj6pqdAfz19U9myWrL2W
         ye86+gkT6MCYp6pPSdO2DDLPU+yoqjvQ/aznovYgfafDBGuNPNkNp5sbIUgaAufSwV4D
         od2V98+EftP9YDZjslsiHxHatvC8RIeMtpOzon8DzIRx2yKG/y+Vh2JHQO42Mx49Nb3u
         pPLw==
X-Gm-Message-State: AOAM531k9rHMMK5+KOdWM2qVARWGgvXYrG0Gp0r8pQA3twEl/XAveF8e
        svkQ+V9O3ddFb6q1E61nJrmQDhGCik0ZXle2Xt5HttGmaiEUlt/v20c3PgS1AXWYs6WTqz7xXm+
        tbTKk3QErSybi
X-Received: by 2002:a5d:5584:0:b0:1ed:e423:18f4 with SMTP id i4-20020a5d5584000000b001ede42318f4mr5268144wrv.509.1645785627489;
        Fri, 25 Feb 2022 02:40:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+suvh52UL+yxQwZMYSZGg0of8oD756hKzab+wp95qXtMVPTn7Je7xnvr6hZRVfR9ly8TmQg==
X-Received: by 2002:a5d:5584:0:b0:1ed:e423:18f4 with SMTP id i4-20020a5d5584000000b001ede42318f4mr5268127wrv.509.1645785627288;
        Fri, 25 Feb 2022 02:40:27 -0800 (PST)
Received: from redhat.com ([2.55.145.157])
        by smtp.gmail.com with ESMTPSA id p30-20020a1c545e000000b003811f9102c0sm3167339wmi.32.2022.02.25.02.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 02:40:26 -0800 (PST)
Date:   Fri, 25 Feb 2022 05:40:21 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>, linux-s390@vger.kernel.org,
        adrian@parity.io, "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>, graf@amazon.com,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Igor Mammedov <imammedo@redhat.com>, ehabkost@redhat.com,
        ben@skyportsystems.com, "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH RFC v1 0/2] VM fork detection for RNG
Message-ID: <20220225053937-mutt-send-email-mst@kernel.org>
References: <20220223131231.403386-1-Jason@zx2c4.com>
 <CAHmME9ogH_mx724n_deFfva7-xPCmma1-=2Mv0JdnZ-fC4JCjg@mail.gmail.com>
 <2653b6c7-a851-7a48-f1f8-3bde742a0c9f@redhat.com>
 <YhdkD4S7Erzl98So@redhat.com>
 <CAHmME9qRrLHwOjD+_xkGC7-BMVdzO95=DzhCo8KvDNa0JXVybA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHmME9qRrLHwOjD+_xkGC7-BMVdzO95=DzhCo8KvDNa0JXVybA@mail.gmail.com>
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

On Thu, Feb 24, 2022 at 11:57:34AM +0100, Jason A. Donenfeld wrote:
> On Thu, Feb 24, 2022 at 11:56 AM Daniel P. Berrangé <berrange@redhat.com> wrote:
> > IIRC this part of the QEMU doc was making an implicit assumption
> > about the way QEMU is to be used by mgmt apps doing snapshots.
> >
> > Instead of using the 'loadvm' command on the existing running QEMU
> > process, the doc seems to tacitly expect the management app will
> > throwaway the existing QEMU process and spawn a brand new QEMU
> > process to load the snapshot into, thus getting the new GUID on
> > the QEMU command line.
> 
> Right, exactly. The "there are no known use cases" bit I think just
> forgot about one very common use case that perhaps just wasn't in use
> by the original author. So I'm pretty sure this remains a QEMU bug.
> 
> Jason

Quite possibly yes.

-- 
MST

