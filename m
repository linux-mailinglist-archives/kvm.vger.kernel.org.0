Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C8659C7A7
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 20:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237348AbiHVS45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 14:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238367AbiHVS4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 14:56:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34651D0C7
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 11:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661194559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Sc/GFE/h4auZJmdG2OSNqDhNL2VL4Oyu1Hp2vRC3HE=;
        b=CRcm4GsfLCBHKUPdSDrEfBAeQlfQN2ItFZ/K1DsR59GTRt0AwT5zOfSF5rQpdPHAYp5b3z
        lzmZ+1ryQpm0HMu/mV78I7y3e4T6cEcdsmzr1hMBNDwYsStqpgZ/vPlHoxGioZ7V2KirSc
        o9G1CTv49eEVUR8IeB7ZoIm5w5lL/Io=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-630-rxh1N4tEPPuz_cWH9jKYZA-1; Mon, 22 Aug 2022 14:55:58 -0400
X-MC-Unique: rxh1N4tEPPuz_cWH9jKYZA-1
Received: by mail-qt1-f198.google.com with SMTP id d20-20020a05622a05d400b00344997f0537so7915560qtb.0
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 11:55:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=6Sc/GFE/h4auZJmdG2OSNqDhNL2VL4Oyu1Hp2vRC3HE=;
        b=V05oACv4+LwDuiX4AuUJewO7ErPLdBiny5fPSwZEZJcSy6Pui2ZqacHw0cERoU5idi
         C1vjvvyeT9nsQ+uE7VGwND8gogB6c0j5EB6ebDlZuRDVnAPNUGBdUaaFv66Xv7VAmeMt
         9BAZjbTFpP2+40wxSr3knPIjfS+ajVd0K5HMlhn+2Nu9y7J/v8xqQpIaynywiinDDmLC
         X0ErR0HvCWjvLNZv/e2ILUfX6jG8w1OLEx5N9GgDBSW/tlqsM4o4b5R7YrQm4jE/3b4I
         Ae76kLLr0qAq9Q1RHg/IanjcFghXumDJv3QcrSPik3pHLc7F5N/IvEsACmWtN6UOmsyb
         m/Sw==
X-Gm-Message-State: ACgBeo0A9lb1HxMZuT16d5pNMvHvpsRnIaW63Z4Zen7FjiC50zeqyLrB
        EfBW2jMFc+rXEz+8bVY5UrUTtFo10qmWFWMbKDrZeGDJH6xRI7+z/HyOmLqlACDZymAAlDAHkue
        A+pjk7PiQ21lk
X-Received: by 2002:a05:622a:451:b0:344:ad2f:692c with SMTP id o17-20020a05622a045100b00344ad2f692cmr9157269qtx.604.1661194558418;
        Mon, 22 Aug 2022 11:55:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4SPwSXVCYhU6Mx1Y/ng2/oG6o7hMCWS3u5m4ddUxyWRbRC8YCvqK2IPkivSnUKC63Wynm2Tg==
X-Received: by 2002:a05:622a:451:b0:344:ad2f:692c with SMTP id o17-20020a05622a045100b00344ad2f692cmr9157248qtx.604.1661194558179;
        Mon, 22 Aug 2022 11:55:58 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id n1-20020ac86741000000b0031eebfcb369sm9093468qtp.97.2022.08.22.11.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 11:55:57 -0700 (PDT)
Date:   Mon, 22 Aug 2022 14:55:55 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        corbet@lwn.net, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
        seanjc@google.com, drjones@redhat.com, dmatlack@google.com,
        bgardon@google.com, ricarkol@google.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory
 tracking
Message-ID: <YwPRO0r2sfzcbgyz@xz-m1.local>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com>
 <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Gavin,

On Mon, Aug 22, 2022 at 11:58:20AM +1000, Gavin Shan wrote:
> > For context, the documentation says:
> > 
> > <quote>
> > - if KVM_CAP_DIRTY_LOG_RING is available, a number of pages at
> >    KVM_DIRTY_LOG_PAGE_OFFSET * PAGE_SIZE. [...]
> > </quote>
> > 
> > What is the reason for picking this particular value?
> > 
> 
> It's inherited from x86. I don't think it has to be this particular value.
> The value is used to distinguish the region's owners like kvm_run, KVM_PIO_PAGE_OFFSET,
> KVM_COALESCED_MMIO_PAGE_OFFSET, and KVM_DIRTY_LOG_PAGE_OFFSET.
> 
> How about to have 2 for KVM_DIRTY_LOG_PAGE_OFFSET in next revision?
> The virtual area is cheap, I guess it's also nice to use x86's
> pattern to have 64 for KVM_DIRTY_LOG_PAGE_OFFSET.
> 
>     #define KVM_COALESCED_MMIO_PAGE_OFFSET   1
>     #define KVM_DIRTY_LOG_PAGE_OFFSET        2

It was chosen not to be continuous of previous used offset because it'll be
the 1st vcpu region that can cover multiple & dynamic number of pages.  I
wanted to leave the 3-63 (x86 used offset 2 already) for small fields so
they can be continuous, which looks a little bit cleaner.

Currently how many pages it'll use depends on the size set by the user,
though there's a max size limited by KVM_DIRTY_RING_MAX_ENTRIES, which is a
maximum of 1MB memory.

So I think setting it to 2 is okay, as long as we keep the rest 1MB address
space for the per-vcpu ring structure, so any new vcpu fields (even if only
1 page will be needed) need to be after that maximum size of the ring.

Thanks,

-- 
Peter Xu

