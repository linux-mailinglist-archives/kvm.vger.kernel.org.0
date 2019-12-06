Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3138B115805
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 20:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfLFTzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 14:55:55 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:37027 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfLFTzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 14:55:55 -0500
Received: by mail-vs1-f65.google.com with SMTP id x18so5921701vsq.4
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 11:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/Z29mZblhao4OKhaXfAMsgfFNTJQzmAxsp62b99KrM=;
        b=KpNfi2vpudS8k1BofgP1u+Sw7UgUV1gKHYXAfLM+pb4BQnedFBeS7OKkYCCycJSoG+
         xOAXNN19cQrRtr+AoMMXcWd3Z1nfvQ1lJx626eMA+0KoDp2gEwbc/qP6G6Xj9RWERJ6+
         dhhcrhx5ngptFOtDVgxD7sSsTEPoyihu97fArE/yAWTg3/fufNjBdUCDQaqIIj341XeY
         mtrJmdvy5W+6nwC7TcpTK2c2/Vuxogj4edXY6BjsNV7wkUmVhK4KOlWHyM+jgbkuNGZ0
         ctwx/NLJjh0HcWxEm2mm42dqZD0eU+RLACUo9CdWUtlAGT7AalgryjhcOUjpAvVO5UGo
         PHTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/Z29mZblhao4OKhaXfAMsgfFNTJQzmAxsp62b99KrM=;
        b=ATw2g7hRhqn52JdYrxE8LgTeH4HaiYYh1jViJCX2q3S8Kw8oHNvzxjLiyscKr0ki+t
         7SxcaK4RulkHvK8XkB9r0QtuzL1OcqGj2oZZXDXGApk/3x5Q64UBWeI2Zl7GdKfC5LaB
         TUkpleWHAMN2BjTX04LhpPXmp1tmdOxvjjVy9SVl7KNOds8ax8ld33x7zf0nuSqf6uRV
         tJFeQCOxqzhP8EgSO1GTqDVyXRVxcFXA6AgkK3Kjvf7HMrUR6t1ahDP6eiAqc0G6IlS1
         nL+L0N3HgQ1znuYdHE/uFBSklXmjm9giPxA4h8hQxDXksJBSLlNFfGdz6KgL7vtcO5Gy
         KKHg==
X-Gm-Message-State: APjAAAUo+NzN0QrjaHUWlbpG9wg5dyivGp0c57NSP2dMatL3NvNbgrTN
        mLoOAq7LiuYUzb7UItrR+Nk7M1EeI3c3JWRiWwzAfQ==
X-Google-Smtp-Source: APXvYqz4ctErYqr8ovFQ4LYDuo1lt2DMbswbj9wvvX9cDpDd/10zooIczllttOpKJ5GmWo6TNLbys36WEl7es2xnV14=
X-Received: by 2002:a67:c592:: with SMTP id h18mr1118342vsk.235.1575662154029;
 Fri, 06 Dec 2019 11:55:54 -0800 (PST)
MIME-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com> <20191127190922.GH22227@linux.intel.com>
In-Reply-To: <20191127190922.GH22227@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Fri, 6 Dec 2019 11:55:42 -0800
Message-ID: <CANgfPd-XR0ZpbTtV21KrM_Ud1d0ntHxE6M4JzcFVZ4M0zG8XYQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/28] kvm: mmu: Rework the x86 TDP direct mapped case
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm finally back in the office. Sorry for not getting back to you sooner.
I don't think it would be easy to send the synchronization changes
first. The reason they seem so small is that they're all handled by
the iterator. If we tried to put the synchronization changes in
without the iterator we'd have to 1.) deal with struct kvm_mmu_pages,
2.) deal with the rmap, and 3.) change a huge amount of code to insert
the synchronization changes into the existing framework. The changes
wouldn't be mechanical or easy to insert either since a lot of
bookkeeping is currently done before PTEs are updated, with no
facility for rolling back the bookkeeping on PTE cmpxchg failure. We
could start with the iterator changes and then do the synchronization
changes, but the other way around would be very difficult.


On Wed, Nov 27, 2019 at 11:09 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Sep 26, 2019 at 04:17:56PM -0700, Ben Gardon wrote:
> > The goal of this  RFC is to demonstrate and gather feedback on the
> > iterator pattern, the memory savings it enables for the "direct case"
> > and the changes to the synchronization model. Though they are interwoven
> > in this series, I will separate the iterator from the synchronization
> > changes in a future series. I recognize that some feature work will be
> > needed to make this patch set ready for merging. That work is detailed
> > at the end of this cover letter.
>
> How difficult would it be to send the synchronization changes as a separate
> series in the not-too-distant future?  At a brief glance, those changes
> appear to be tiny relative to the direct iterator changes.  From a stability
> perspective, it would be nice if the locking changes can get upstreamed and
> tested in the wild for a few kernel versions before the iterator code is
> introduced.
