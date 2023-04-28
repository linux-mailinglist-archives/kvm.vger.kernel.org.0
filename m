Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F6D6F1DA2
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 19:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346235AbjD1RvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 13:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346201AbjD1RvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 13:51:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A1846B8
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 10:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682704215;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=dFy8RI3865X52CBDIP3RqFy8Zpprq4rs5liYXkWuaDw=;
        b=fPJZaYjoCyttJwI1qzXoH7b3PUUpiyaoWvmSo9/xau5Xekd/4fYGbVjrNzxIpLT4TDZQtZ
        4iU26BmS7B20IU/0DTzlXTk3YNrKSHRpmlMb3bBevxhyeuwhKOBIf0N6XwZINJ6ax8Osxm
        4MFXzis/8EidAeVKWO0AuRGKh572vE8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-q8neaZr4M1iTzEmoEjLgsA-1; Fri, 28 Apr 2023 13:50:13 -0400
X-MC-Unique: q8neaZr4M1iTzEmoEjLgsA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-2f2981b8364so10761f8f.1
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 10:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682704211; x=1685296211;
        h=mime-version:message-id:date:reply-to:user-agent:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dFy8RI3865X52CBDIP3RqFy8Zpprq4rs5liYXkWuaDw=;
        b=KqlPEDBtvvvuj5sWb9rp1kT3S7rnJZcLNQFAgGMzBzBC5qgECJkFn9TJW5QrEsXs0u
         773lBM860X+MMHobkXUHy9yNVkFLSPJA2AQdOurKX1sy4EGxGudiMk7sK5X6yZx6kIcP
         Fcjew8i8LPJmlY18SxV5nPxjYa9jo3/WBAbTHKwYlP5Zn3j+cEafKmJJ5KXmrOxcRoXA
         TP6j7EPYQD5JYps/M2q1p3OA+Y2zMFwctl8/l1ONHsOPmdSTtbAorgJfGmnJpuVQXdNJ
         LuUxzY0hmR0McYIy6OFFsQRiFtNXurYoNRBzSc8QXdnLXkv7koz8f3x9gS34w77vgkJG
         i4OA==
X-Gm-Message-State: AC+VfDwJmpVliTUDpz9hPQpww3FI+TXsbndyFHV9UYsTbAI/CF39Io6Z
        lf9jWrewD2BzHLQMtAfHfIRleXAXyUruJhFusp94LEEHgm2dyon/fMXqSmHPQL4MWp37HLE7+B7
        ncYoDSQ0IUsH2
X-Received: by 2002:adf:f4cd:0:b0:2f5:b1aa:679c with SMTP id h13-20020adff4cd000000b002f5b1aa679cmr4615534wrp.39.1682704206683;
        Fri, 28 Apr 2023 10:50:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ72eYhHFo8pqocqwiP4gKwEIq5wnV7fJc+hh5FrBhyijJLt+bN4pH9GAu/TG54zthIX+gg4RQ==
X-Received: by 2002:adf:f4cd:0:b0:2f5:b1aa:679c with SMTP id h13-20020adff4cd000000b002f5b1aa679cmr4615516wrp.39.1682704206287;
        Fri, 28 Apr 2023 10:50:06 -0700 (PDT)
Received: from redhat.com (static-213-163-6-89.ipcom.comunitel.net. [89.6.163.213])
        by smtp.gmail.com with ESMTPSA id p1-20020a05600c204100b003f3270ddbd8sm2503636wmg.37.2023.04.28.10.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 10:50:05 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Andrea Bolognani <abologna@redhat.com>
Subject: Re: [PATCH v7 1/1] arm/kvm: add support for MTE
In-Reply-To: <20230428095533.21747-2-cohuck@redhat.com> (Cornelia Huck's
        message of "Fri, 28 Apr 2023 11:55:33 +0200")
References: <20230428095533.21747-1-cohuck@redhat.com>
        <20230428095533.21747-2-cohuck@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Fri, 28 Apr 2023 19:50:04 +0200
Message-ID: <87sfcj99rn.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cornelia Huck <cohuck@redhat.com> wrote:
> Extend the 'mte' property for the virt machine to cover KVM as
> well. For KVM, we don't allocate tag memory, but instead enable the
> capability.
>
> If MTE has been enabled, we need to disable migration,

And I was wondering why I was cc'd in a patch that talks about arm, cpus
and architectures O:-)

> as we do not
> yet have a way to migrate the tags as well. Therefore, MTE will stay
> off with KVM unless requested explicitly.
>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  hw/arm/virt.c        | 69 +++++++++++++++++++++++++-------------------
>  target/arm/cpu.c     |  9 +++---
>  target/arm/cpu.h     |  4 +++
>  target/arm/kvm.c     | 35 ++++++++++++++++++++++
>  target/arm/kvm64.c   |  5 ++++
>  target/arm/kvm_arm.h | 19 ++++++++++++
>  6 files changed, 107 insertions(+), 34 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index a89d699f0b76..544a6c5bec8f 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2146,7 +2146,7 @@ static void machvirt_init(MachineState *machine)
>          exit(1);
>      }
>  
> -    if (vms->mte && (kvm_enabled() || hvf_enabled())) {
> +    if (vms->mte && hvf_enabled()) {
>          error_report("mach-virt: %s does not support providing "
>                       "MTE to the guest CPU",
>                       current_accel_name());
> @@ -2216,39 +2216,48 @@ static void machvirt_init(MachineState *machine)
>          }
>  
>          if (vms->mte) {
> -            /* Create the memory region only once, but link to all cpus. */
> -            if (!tag_sysmem) {
> -                /*
> -                 * The property exists only if MemTag is supported.
> -                 * If it is, we must allocate the ram to back that up.
> -                 */
> -                if (!object_property_find(cpuobj, "tag-memory")) {
> -                    error_report("MTE requested, but not supported "
> -                                 "by the guest CPU");
> -                    exit(1);
> +            if (tcg_enabled()) {
> +                /* Create the memory region only once, but link to all cpus. */
> +                if (!tag_sysmem) {
> +                    /*
> +                     * The property exists only if MemTag is supported.
> +                     * If it is, we must allocate the ram to back that up.
> +                     */
> +                    if (!object_property_find(cpuobj, "tag-memory")) {
> +                        error_report("MTE requested, but not supported "
> +                                     "by the guest CPU");
> +                        exit(1);
> +                    }
> +
> +                    tag_sysmem = g_new(MemoryRegion, 1);
> +                    memory_region_init(tag_sysmem, OBJECT(machine),
> +                                       "tag-memory", UINT64_MAX / 32);
> +
> +                    if (vms->secure) {
> +                        secure_tag_sysmem = g_new(MemoryRegion, 1);
> +                        memory_region_init(secure_tag_sysmem, OBJECT(machine),
> +                                           "secure-tag-memory",
> +                                           UINT64_MAX / 32);
> +
> +                        /* As with ram, secure-tag takes precedence over tag. */
> +                        memory_region_add_subregion_overlap(secure_tag_sysmem,
> +                                                            0, tag_sysmem, -1);
> +                    }
>                  }

Pardon my ignorance here, but to try to help with migration.  How is
this mte tag stored?
- 1 array of 8bits per page of memory
- 1 array of 64bits per page of memory
- whatever

Lets asume that it is 1 byte per page. For the explanation it don't
matter, only matters that it is an array of things that are one for each
page.

What I arrived for migration the 1st time that I looked at this problem
is that you can "abuse" multifd and call it a day.

In multifd propper you just send in each page:

- 1 array of page addresses
- 1 array of pages that correspond to the previous addresses

So my suggestion is just to send another array:

- 1 array of page addresses
- 1 array of page tags that correspond to the previous one
- 1 array of pages that correspond to the previous addresses

You put compatiblity marks here and there checking that you are using
mte (and the same version) in both sides and you call that a day.

Notice that this requires the series (still not upstream but already on
the list) that move the zero page detection to the multifd thread,
because I am assuming that zero pages also have tags (yes, it was not a
very impressive guess).

What do you think?  Does this work for you?
What I would need for kvm/tcg would be some way of doing:

- get_the_mte_tag_of_page(page_id)
- set_the_mte_tag_of_page(page_id)

Now you need to tell me if I should do this for each page, or use some
kind of scatter-gather function that allows me to receive the mte tags
from an array of pages.

You could pass this information when we are searching for dirty pages,
but it is going to be complicated doing that (basically we only pass the
dirty page id, nothing else).

Doing this in normal precopy can also be done, but it would be an
exercise in masochism.

Another question, if you are using MTE, all pages have MTE, right?
Or there are other exceptions?

Sorry for my ignorance on this matter.

Later, Juan.

