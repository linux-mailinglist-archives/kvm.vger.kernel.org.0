Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CC36A6D78
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 14:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCANxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 08:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjCANwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 08:52:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A007D9E
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 05:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677678719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mftfQEi9wdaH6McKuPClmRUmMChN2OhoG+1UjGPOpjw=;
        b=AIXUY9apdKrVPNzPQ9jpLaG/2Mi1Pw3tcexix89ipHBAYuIABqpcaYGP2D3KonbWDr9Gfw
        ncP5ZsALiGDTjWrGbKcD6qYCZfCM41dG2da61/HZ4EirRhsfbdacCZ4mW+UFpSGznUSQAp
        3i6nmynfCkbpl+z7pZaR/9+3BoISo5Y=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-479-0RSRVlXsOy6rCSkmUVbdqw-1; Wed, 01 Mar 2023 08:51:58 -0500
X-MC-Unique: 0RSRVlXsOy6rCSkmUVbdqw-1
Received: by mail-pl1-f199.google.com with SMTP id ki15-20020a170903068f00b0019ce282dc68so6923706plb.6
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 05:51:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mftfQEi9wdaH6McKuPClmRUmMChN2OhoG+1UjGPOpjw=;
        b=GDjbnmvkEq0JUn5sx6MWgTTXzYv2fPicSc+54W2kpuMnaE07XkqxG20PwVMn9MHQhN
         nXwgv7W3BzEnB6+ye7xQDutsDEsYBRMl6uOWQHditGGSS6uDPA66982fKeqXfUYXKyVb
         dTzUNPrjw1tVfPLPUZmsgPO9mY8jUMCzzKK5VeYcfdKslourYzdA8j49eLjynBbq71jD
         oz+sHhQUSFPgiB9cmGxE56CKzU/JMFLmpo9gKYeUXW1EwcjED9R6wHJirAYXx5+LMEXq
         to59whVswrjEg3+dO8xfbJIp8lV0IDCdYRwHvYuiOPHBsSDvpURQmZJjKbGNPF5BiSxe
         rkLg==
X-Gm-Message-State: AO0yUKX7g93GQg8JsHlMhEY1uM10WKdsGNyAGAD8uONjOnjY2IwoWhpf
        YRY+mi+uYlvB512Z6SogvvpD5c17NUaKRsDw8ZYHo2L3P4wNZaucJEHXMYdKi4hZVvHaUX7URqS
        ZBKW0qkDrRzxicX2prtP5FuxOhNxs
X-Received: by 2002:a17:902:a3cd:b0:19c:be03:ce10 with SMTP id q13-20020a170902a3cd00b0019cbe03ce10mr2318748plb.9.1677678717058;
        Wed, 01 Mar 2023 05:51:57 -0800 (PST)
X-Google-Smtp-Source: AK7set+VwIMpkQPmtqSDdknUDIutD4sizupNM19vKv5zm2iK/1JA7xp0lu/ds3MQ/WbVn6ZY+NHdJ+zI4iECpRjydb4=
X-Received: by 2002:a17:902:a3cd:b0:19c:be03:ce10 with SMTP id
 q13-20020a170902a3cd00b0019cbe03ce10mr2318736plb.9.1677678716764; Wed, 01 Mar
 2023 05:51:56 -0800 (PST)
Received: from 744723338238 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Mar 2023 05:51:56 -0800
From:   Andrea Bolognani <abologna@redhat.com>
References: <20230228150216.77912-1-cohuck@redhat.com> <20230228150216.77912-2-cohuck@redhat.com>
 <CABJz62OHjrq_V1QD4g4azzLm812EJapPEja81optr8o7jpnaHQ@mail.gmail.com> <874jr4dbcr.fsf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <874jr4dbcr.fsf@redhat.com>
Date:   Wed, 1 Mar 2023 05:51:56 -0800
Message-ID: <CABJz62MQH2U1QM26PcC3F1cy7t=53_mxkgViLKjcUMVmi29w+Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] arm/kvm: add support for MTE
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 11:17:40AM +0100, Cornelia Huck wrote:
> On Tue, Feb 28 2023, Andrea Bolognani <abologna@redhat.com> wrote:
> > On Tue, Feb 28, 2023 at 04:02:15PM +0100, Cornelia Huck wrote:
> >> +MTE CPU Property
> >> +================
> >> +
> >> +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
> >> +presence of tag memory (which can be turned on for the ``virt`` machine via
> >> +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
> >> +proper migration support is implemented, enabling MTE will install a migration
> >> +blocker.
> >
> > Is it okay to use -machine virt,mte=on unconditionally for both KVM
> > and TCG guests when MTE support is requested, or will that not work
> > for the former?
>
> QEMU will error out if you try this with KVM (basically, same behaviour
> as before.) Is that a problem for libvirt, or merely a bit inconvinient?

I'm actually a bit confused. The documentation for the mte property
of the virt machine type says

  mte
    Set on/off to enable/disable emulating a guest CPU which implements
    the Arm Memory Tagging Extensions. The default is off.

So why is there a need to have a CPU property in addition to the
existing machine type property?

From the libvirt integration point of view, setting the machine type
property only for TCG is not a problem.

-- 
Andrea Bolognani / Red Hat / Virtualization

