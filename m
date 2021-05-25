Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F361738F72E
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 02:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhEYA7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 20:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhEYA7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 20:59:09 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FA5C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 17:57:40 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so12265275pjb.2
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 17:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7tuqKTglpJW525ZsMGnz4XtJGD4FdhFwkTMNsXzTdys=;
        b=geu/XqLVheEmFDeQqYOpW+xgqLzwLmXBDSOIBMqPbpcwuSNDSpbkYk+ll9iso4i0nz
         5MjxYjQ420khRilg6wzB7RGquSgfRtY9L8pjiquMTenMapn7SlRGwVm5d60jc5Sb9A4z
         hQ7oACQsh8u8Cb81CEkca+sh4SbKTjBUleh+9aXncR7PpIoeYXAraTnOHSZugmp8WCPd
         wP4hzuMF8N91g9OZRo5biU6IIvCowUM5Nqq7TlK+A1XfVQhNtHDrzTXwpu/I9QHEnL7C
         6T2dcSKclrsSE6685yclHeUsXK/SitnKYx6bfZe8xWKrAHAHMZcprFOc5FGOabogRP2g
         +ToQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7tuqKTglpJW525ZsMGnz4XtJGD4FdhFwkTMNsXzTdys=;
        b=eOyEqBIFY3w8pKWsmWHwtM8sdBgfUQ706f4ErM18pugJSkIZtaoUGIiycL4Fooaabh
         k9cUcf9p2GHF46P4AMGqmMqVs9/wPDT54iAgQR8m0Fb7xjNktj4H4sj/yJqlq94C/E7n
         aQ4KFDLc3LKKkQlTPeo4xQsqUxGHCg6WPbHTQp9jQutEJSTptY7DI1tHNkXvKTio6+EA
         4OlW9RCT81UXXONrWYi4+uAecLltPqTafMgBgXoYtxtewmUvYjThBmypHwilYwGqa/so
         HO25/Gi3if6YYCTzxHnJjJmGdYgqWSQgp28JFxrUfZMfmEge89cSkfq/Beu8qpRuGPl+
         OeCw==
X-Gm-Message-State: AOAM531mpCdYcB3bHnj0YFGkHi5OiBVBuyYzqWNN50zLBAYMbIkm0/XS
        LRBfN7v9zDbwPT1o65WkR4V3Vg==
X-Google-Smtp-Source: ABdhPJz+t2BoYNFau7gIvZdzt/zauBCl5AABVX6lSemcj7PJJZlsCcmCCWMfqy56uRugwmLXUtpdxQ==
X-Received: by 2002:a17:902:bd42:b029:ee:2ada:b6fc with SMTP id b2-20020a170902bd42b02900ee2adab6fcmr28119729plx.59.1621904260028;
        Mon, 24 May 2021 17:57:40 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v18sm12446765pff.90.2021.05.24.17.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 17:57:39 -0700 (PDT)
Date:   Tue, 25 May 2021 00:57:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/12] KVM: nVMX: Disable vmcs02 posted interrupts if
 vmcs12 PID isn't mappable
Message-ID: <YKxLf8546GQ6ZEQd@google.com>
References: <20210520230339.267445-1-jmattson@google.com>
 <20210520230339.267445-8-jmattson@google.com>
 <YKw1FGuq5YzSiael@google.com>
 <CALMp9eQikiZRzX+UtdTW4rHO+jT2uo5xmrtGGs1V96kEZAHh_A@mail.gmail.com>
 <YKw6mpWe3UFY2Gnp@google.com>
 <CALMp9eQy=JhQDzk_LYwrOpbv3hhhi_BT=5rwjHpfTuTQShzkww@mail.gmail.com>
 <YKxAsZzO1uQx7sf8@google.com>
 <CALMp9eSae040kCsHApTdTgh0wKYiB9kRzgsyQVU7p_FaqwXwGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSae040kCsHApTdTgh0wKYiB9kRzgsyQVU7p_FaqwXwGg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Jim Mattson wrote:
> On Mon, May 24, 2021 at 5:11 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Can we instead word it along the lines of:
> >
> >   Defer the KVM_INTERNAL_EXIT until KVM actually attempts to consume the posted
> >   interrupt descriptor on behalf of the vCPU.  Note, KVM may process posted
> >   interrupts when it architecturally should not.  Bugs aside, userspace can at
> >   least rely on KVM to not process posted interrupts if there is no (posted?)
> >   interrupt activity whatsoever.
> 
> How about:
> 
> Defer the KVM_INTERNAL_EXIT until KVM tries to access the contents of
> the VMCS12 posted interrupt descriptor. (Note that KVM may do this
> when it should not, per the architectural specification.)

Works for me!
