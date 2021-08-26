Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09C43F8544
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241446AbhHZKY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:24:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241403AbhHZKY5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 06:24:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629973450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BOy94jtHdM+WsIgWm9uXDpgZeKpyFjwm3X/elfW497Q=;
        b=SM9fdiYOZaS1ZBdagdlHhWdo35GiJyQLMPkuEsE8JGHneEMhdqFFIrCjkM7/8CfexlLTSr
        ZuqLkYGKDjvVqfOCr46YlXTab7AppYOrNe2HsFAPiUVc9gjwncEaisKk8EVoq9HbnPL0ux
        9ysLvRtdYExI6R8+oBUYjdeeHW2AfUg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-LjRBGp9nOl69WUp2YPtVNw-1; Thu, 26 Aug 2021 06:24:09 -0400
X-MC-Unique: LjRBGp9nOl69WUp2YPtVNw-1
Received: by mail-wr1-f70.google.com with SMTP id r17-20020adfda510000b02901526f76d738so701966wrl.0
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 03:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BOy94jtHdM+WsIgWm9uXDpgZeKpyFjwm3X/elfW497Q=;
        b=fWFXxdg7Nvrmr1NZJgviKG6VivG0Wx0v6iYkRGT4N8aLxGkrsxcLhv/Q0nM2CCoVj+
         hm1KSFoYp7jX6OByTE7V4OP4gfzJtoiMRllbsDZItzLOx1b0XO7qLox4EnLVtm06Ujez
         N0IVyARRbM3fyTpAc/ytybjxtAV7uyNozehE3NyOv4M+mRqvG6jEP088TEFdu1+YfoIC
         UGFpxGf7j1LWq5L/rGnygqSnFXRa5mPUJTPN+f9DI712rn6hh2b5G3MM5/V9rB3Y1wxi
         GfrszTt9+3h/XONoEcStQVW5qpjHEJII8/JyhPFT5Q73GVMTpUOxka4/nYbNYvM3gUlg
         wtSQ==
X-Gm-Message-State: AOAM531uy6OWNvD8J4E+5ldFnbTrMsAVZp8VTg6crHliyDqCZmMjBhMa
        XCQxgUrx/Lrm6rwS2PHHxg1MZ0iQirtV5/WLcmXCEutFL89M9L8fO7G1TU03LygWvNPOtwMbJf0
        2yzh7EQLXQca1
X-Received: by 2002:a05:600c:3b98:: with SMTP id n24mr13330805wms.11.1629973447857;
        Thu, 26 Aug 2021 03:24:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQappUQgXxVoQGN5Z3dHEEwlNg/3FtUE++2Kejy7gQkngqtKxQ8s3i2YsypuYKfiZtrZSh4Q==
X-Received: by 2002:a05:600c:3b98:: with SMTP id n24mr13330793wms.11.1629973447680;
        Thu, 26 Aug 2021 03:24:07 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d4sm2648498wrz.35.2021.08.26.03.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 03:24:07 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Subject: Re: [PATCH 2/2] KVM: Guard cpusmask NULL check with
 CONFIG_CPUMASK_OFFSTACK
In-Reply-To: <YSa8z5vQKbFuLtew@google.com>
References: <20210821000501.375978-1-seanjc@google.com>
 <20210821000501.375978-3-seanjc@google.com>
 <CAJhGHyB1RjBLRLtaS80XQSTb0g35smxnBQPjEp-BwieKu1cwXw@mail.gmail.com>
 <YSa8z5vQKbFuLtew@google.com>
Date:   Thu, 26 Aug 2021 12:24:06 +0200
Message-ID: <878s0ojygp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Aug 25, 2021, Lai Jiangshan wrote:
>> On Sat, Aug 21, 2021 at 8:09 AM Sean Christopherson <seanjc@google.com> wrote:
>> > @@ -277,6 +277,14 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>> >                 if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
>> >                         continue;
>> >
>> > +               /*
>> > +                * tmp can be NULL if cpumasks are allocated off stack, as
>> > +                * allocation of the mask is deliberately not fatal and is
>> > +                * handled by falling back to kicking all online CPUs.
>> > +                */
>> > +               if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && !tmp)
>> > +                       continue;
>> > +
>> 
>> Hello, Sean
>> 
>> I don't think it is a good idea to reinvent the cpumask_available().
>
> Using cpumask_available() is waaaay better, thanks!
>
> Vitaly / Paolo, take this one instead?
>

Sure, putting this to my v3, thanks!

-- 
Vitaly

