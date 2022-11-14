Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFE0628BB3
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 22:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbiKNV7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 16:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbiKNV7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 16:59:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11428192A6
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 13:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668463097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kZzW4AgZbMmxrsBOBTOhV6/gULQ2dQ1fNvnQET4mXFA=;
        b=I27TqvSUjfUgnOUtQovHqrcIu7MI2qi80eBIwlzifjMczVivIG3HrHqPpZ8FD4P3y3mUsF
        mNa/edtd3kWmukVXqyrHtNT8O8gyZ8T/IcGEvey5BGVJ0wkyQLMPmM/rp3opzz3KoOMRyM
        N63GzhxzBOzarbuQRnNoMDtrQ8zlwq4=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-s5DAmuYuP8iCWpBFdfkrxA-1; Mon, 14 Nov 2022 16:58:15 -0500
X-MC-Unique: s5DAmuYuP8iCWpBFdfkrxA-1
Received: by mail-io1-f71.google.com with SMTP id x23-20020a6b6a17000000b006d9ca4e35edso6409433iog.9
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 13:58:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kZzW4AgZbMmxrsBOBTOhV6/gULQ2dQ1fNvnQET4mXFA=;
        b=zxk/fENk7eFJwQxXQYa1LlYI1704b5/E2xRJHn7+s66jqP71V35SCHSNfLO1eeZwKd
         2U4fzwg6jtaWDPVOpdfIzLfB1Y654VU3tDUcMdqyurW7c+GLs2NdCh/kVvOCXbq9s1ur
         x9HHl8EXfu4hJ1eM6GJ5er8jUy/ZuoZbKEx62AnJh9KgSUYbXGjb6lRXp5iNYWlSlv3a
         Ssl8P6SSm0VhgVYHSprmm9EzEPfPJoheOcBm3wYWbpCjoj7alJvXpwFwnF75DuM1/p/C
         08SHh0wdTN5RKMlpjMKqnDS3tIlHwLrKNbK/CqLGiRfYtTiVzstAIYxc3seaNhoZEIna
         TgoQ==
X-Gm-Message-State: ANoB5plSFw2cnjQQJ1PON3+cWFSKv568q75cfwR30Xq5sU0GX89TIGHf
        w4YkODnOPNBgQs06OpsCSzTwm9VWJLVkDmvSI94aFRZhtIwhl6vYOLW/NpsB21NpubT8eQG6WOe
        4GhC4JVoboMGd
X-Received: by 2002:a05:6638:3cc3:b0:363:cdfd:3b94 with SMTP id bc3-20020a0566383cc300b00363cdfd3b94mr6584128jab.254.1668463095013;
        Mon, 14 Nov 2022 13:58:15 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5ipJfUVcJn0WCqLOtKomK2JTy4DYOo2InkQIoTXzwGcxxThlBV//EiKeE4zN6kMSaQr8b7xQ==
X-Received: by 2002:a05:6638:3cc3:b0:363:cdfd:3b94 with SMTP id bc3-20020a0566383cc300b00363cdfd3b94mr6584119jab.254.1668463094740;
        Mon, 14 Nov 2022 13:58:14 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w11-20020a056602034b00b006d276f4e01csm4512639iou.20.2022.11.14.13.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 13:58:14 -0800 (PST)
Date:   Mon, 14 Nov 2022 14:58:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     quintela@redhat.com
Cc:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: KVM call for 2022-11-15
Message-ID: <20221114145812.1740308b.alex.williamson@redhat.com>
In-Reply-To: <87o7t969lv.fsf@secure.mitica>
References: <87o7t969lv.fsf@secure.mitica>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Nov 2022 12:47:40 +0100
quintela@redhat.com wrote:

> Hi
> 
> Please, send any topic that you are interested in covering.
> 
> We already have some topics:
> Re agenda, see below topics our team would like to discuss:
> 
>    - QEMU support for kernel/vfio V2 live migration patches
>    - acceptance of changes required for Grace/Hopper passthrough and vGPU
>    support
>       - the migration support is now looking like it will converge on the
>       6.2 kernel
>    - tuning GPU migration performance on QEMU/vfio, beyond what the V2 work
>    delivers
> 
> 
>  Call details:
> 
> By popular demand, a google calendar public entry with it
> 
>   https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ
> 
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).

This url doesn't work for me, but the one embedded in your previous
call for agenda[1] does.  Thanks,

Alex

[1]https://lore.kernel.org/all/87tu3nvrzo.fsf@secure.mitica/

