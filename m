Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01751B6602
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 23:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgDWVMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 17:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgDWVMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 17:12:06 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166B0C09B042
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 14:12:06 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id u189so7407787ilc.4
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 14:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IMva2iizseBROtmrvACtD73oRPSFrvp2Ix5wVZGMskE=;
        b=Ewe/pm7jS4mEqI28YF3gdrn1HY43HH+mrdLqwzsQzs6BFoIn1TYg2LWMrLIFNmQj9w
         MQsv1OdROOo2V7fN5VOBn7Oqe//AwhsbJn7vGs2rEKFQq2dghtd2OwXNwHpg+tfbGM2T
         Sr4qWYMUudGRmHFrnsOCOacg2ZXe6/pybwHMfEWUaM5na/vizhU0WLjxXF9TBBWxiAr7
         ETRGVNsggybW3/xGGtsl1hhYoXHwTG8ZwLVnLmxycZXdf6QFwoOj2RsjekmqRuNh8pI6
         VdqK7TCQ8GNY9cKiQT3R8+chFi/usNnydpx8zJScCsMCACiIyoPtEFeFSiheOSzf6qhG
         UsfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IMva2iizseBROtmrvACtD73oRPSFrvp2Ix5wVZGMskE=;
        b=mgr8srqXqLM98zt4ZoXHndlxY11oEGR80h4A4Uj6EK+gN3zTafm0GoPH6K9gU4WvTW
         JObWKrHPdYs6w3L7DWEsGhj74JVXoQq5AOJvxOfBpz1LCzs493aNoeI1Ldb5x0sWuJSL
         OyjvNa3/hS3dMj7IiIhClvLOJEn760YPbOGm+cE+EHb3NgSlYgUunMWnuSyuGvzodYPj
         UoU9xmPheFmgJpwMySLWyXgIgdRvAZDC1zGgyIroaGm9/+Z/evb+i6U7QELCydEK0cIS
         KaTPe218Yii/aJu84udJQxc9B5adD9MQWVJQiSF6aLD2wXYvShCIo0v+mqrnVu4JruVP
         CXdQ==
X-Gm-Message-State: AGi0PuaHCotPR55azbRppq+E5kqOZ7XJYTOalZFKSqv09bnv6hyzPts1
        cEftvzXGIOQ51MWgWNwOunLKe6Ll1wG8ItpqLl0DWw==
X-Google-Smtp-Source: APiQypL6GrYHYQOeO/IMder8Gd5/UYKzeZginsv5apeEwpKSEO4JQIHTuJYE+9Btd0BGgwuIx7CCuDWtEOnnN2UJAXo=
X-Received: by 2002:a92:d8ca:: with SMTP id l10mr5462995ilo.118.1587676325227;
 Thu, 23 Apr 2020 14:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200417183452.115762-1-makarandsonare@google.com>
 <20200417183452.115762-3-makarandsonare@google.com> <20200422015759.GE17836@linux.intel.com>
 <20200422020216.GF17836@linux.intel.com> <CALMp9eRUE7hRNUohhAuz8UoX0Zu1LtoXum7inuqW5ROy=m1hyQ@mail.gmail.com>
 <d1910ba0-13b0-1e82-06d1-b349632149e4@redhat.com>
In-Reply-To: <d1910ba0-13b0-1e82-06d1-b349632149e4@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 23 Apr 2020 14:11:53 -0700
Message-ID: <CALMp9eQuMEmFFpsF97O+CjF9EcBBTZHx86eyTXZvz-HD93kKPg@mail.gmail.com>
Subject: Re: [kvm PATCH 2/2] KVM: nVMX: Don't clobber preemption timer in the
 VMCS12 before L2 ran
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Makarand Sonare <makarandsonare@google.com>,
        kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 7:58 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/04/20 19:05, Jim Mattson wrote:
> > I don't have a strong objection to this patch. It just seems to add
> > gratuitous complexity. If the consensus is to take it, the two parts
> > should be squashed together.
>
> The complexity is not much if you just count lines of code, but I agree
> with you that it's both allowed and more accurate.

It sounds like we're in agreement that this patch can be dropped?
