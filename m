Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20510D1C75
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 01:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732220AbfJIXJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 19:09:03 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:47070 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732216AbfJIXJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 19:09:03 -0400
Received: by mail-io1-f67.google.com with SMTP id c6so9193404ioo.13
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 16:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=04I6JvLL73sHkqFukHW/pBgcgyWl40dzjRVRv0SLA4s=;
        b=a4E+QR58E+fjhLkriMSlZuXXpTfzmig7l3yf2uah/stPOVL7ue7vaSFlPBFjDU4y2Y
         4lsxIcxZBActXz7U1lippdfv2lkM3Si9dLMwsonQvK3iZUk58K4droJV2UpoIzrxw6Ko
         XuLoNIEO+fz6QeGLe6xr9sZWL6zswm9j7uI5fVkfrepIr82iaBY0voVGIHkTYVwhpJWJ
         uxH73aLiqPuPe8iE33rzG1rgCBPDcy9cvMH65cNDFTXpbScmAt9YfDQurWDWL+MtEeJn
         4vBTwJeWs7Zvmuc9aO9X/8SK9RqVv8CVvGnYlsNkAHyLHuG2xshQv83viWZbO7X3Loe8
         g/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=04I6JvLL73sHkqFukHW/pBgcgyWl40dzjRVRv0SLA4s=;
        b=p/9sK8EZ8ZmV1NLMLiDCoR1bbJXLivRvnnQW9IG/AjqkmMg3Ir8Ode5zL9dYjyPGeD
         APd6F62t003GGaxibHHWZQiWvjG9I17kxwuWoTq3jKMtEFhZELEDc4R2XsPJCdhgZIP8
         4oJtZnrIyeuS+wDSf7cv8Dr7L7Z+OehZHh3okfwhS78h05UWPZPW75jtysnpKyamwGss
         /zH+eBqe9i1MG5A9+RWU4AYmykFrcCE2QOBn8qmkKeObBE8a06zkVWH/CoCSvfkJXWem
         fyJ05Y2nVeFJr1n9FGygj1c0ZeoEKC5u2jiiGQpwCPyVXx3O/E3FA5qq6m0bQ7lskaUY
         KWfg==
X-Gm-Message-State: APjAAAV4pQqsH4lyd3P2gXTmp2+SM94YQpzFeD6VwwrlenOgzYmiuP50
        KceN47Qg91B2uAuNB9443KU/n+z2f0MfjNhaRS4Asw==
X-Google-Smtp-Source: APXvYqxW2vcvVvgD7G2Iin7gSbdBs9UYvswVuxNBZHwfiUqfZY5Oo4tnhqjqG03EuGfUnOanbcOy2ZxXm7iKWKiCVyw=
X-Received: by 2002:a6b:d210:: with SMTP id q16mr6918314iob.108.1570662541892;
 Wed, 09 Oct 2019 16:09:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-5-weijiang.yang@intel.com> <CALMp9eS1V2fRcwogcEkHonvVAgfc9dU=7A4V-D0Rcoc=v82VAw@mail.gmail.com>
 <20191009064339.GC27851@local-michael-cet-test>
In-Reply-To: <20191009064339.GC27851@local-michael-cet-test>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Oct 2019 16:08:50 -0700
Message-ID: <CALMp9eS+_riWYK=Zvk330YST4G_q_GfN2LfGXWz85aVnyXmsOg@mail.gmail.com>
Subject: Re: [PATCH v7 4/7] KVM: VMX: Load Guest CET via VMCS when CET is
 enabled in Guest
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 8, 2019 at 11:41 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> On Wed, Oct 02, 2019 at 11:54:26AM -0700, Jim Mattson wrote:
> > On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > > +       if (cet_on)
> > > +               vmcs_set_bits(VM_ENTRY_CONTROLS,
> > > +                             VM_ENTRY_LOAD_GUEST_CET_STATE);
> >
> > Have we ensured that this VM-entry control is supported on the platform?
> >
> If all the checks pass, is it enought to ensure the control bit supported?

I don't think so. The only way to check to see if a VM-entry control
is supported is to check the relevant VMX capability MSR.

BTW, what about the corresponding VM-exit control?
