Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88DFE11583D
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 21:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfLFUmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 15:42:33 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:36813 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfLFUmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 15:42:33 -0500
Received: by mail-ua1-f65.google.com with SMTP id x15so3403273uar.3
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 12:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VgNBmIEkqOzbW7BddSWBmGZVBOHpa9jxMiBiWOzppUc=;
        b=rWLNMtG+eIXjlnh6hH+4OEuh8m57ay/czd3Ef1L+OBYkKURPUA8RI88I1Ba0uvwd5i
         DCnTB+YKJ17iU6jhoVe9cm8heI2lEfzwS/iH09ZOM4o2SCV+7DU10fVoc3bNdhGLZX2w
         xwk6XaQjXabWELnwTawzQzvDby0DonuwmUiBLbsbB2nUB8GfApOsTBbs8sl+2H7R5Ano
         rrJdUhfEEfWAPs6h6zt/pHwLP0TZXYtqrTLEFNlGpW2ZqI7GLP9HDEvghsdmx7eIYfpC
         xAI7Z6p8NW+ls+rQ17QC5k/tLkCpCEJKImr5XQQAckChTTjg32dqOx2pEcDy1sxjDQMm
         Y0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VgNBmIEkqOzbW7BddSWBmGZVBOHpa9jxMiBiWOzppUc=;
        b=Ul6psbxoM3N66Q8a8cCj8q/SUQpQtwczV4SJPVAPDlNDLYEMjDKScPC/liXNO9Dwae
         lCen2JUk96YsaK/HLLsfsM1zDA9+oiylrQHj0VDZCU6UuN2VQuZmAskpe8d2Bu1t2hyu
         /hwnk0gALXPN6ngw2YSSSLP7pWnKMCY4iY2G01tIayJEM2mTNzRShRVjb4L3IGHTepW5
         a7mtsDRsycA0kcRo139POxkR2FGjYp7GQMAFD7QNG6njMRcWK+ZwnKN+InmV8gmZztvr
         W6RHGke0VHcoVCkABafNPwuo/kVujraWnUVmLpVNfA3UrJD7p2Jdo9KNpJffCm3ej6rl
         9lQQ==
X-Gm-Message-State: APjAAAUl1eLLL9sgefqazKPLvdzhtiTF8EDpRVjaaVuh+wLgj0vkoQ9N
        skbR+AAhKdgfgC6JoJjKs9jUzeXdL6BU07y1copTLA==
X-Google-Smtp-Source: APXvYqx4KdI5tJAHrD4yOgGu+xdGxRsq0GPbxUtMN3PL4pgatNtoUhHknSd8EAOBn7KMQHLJnUX40owRuia+wrQ43yA=
X-Received: by 2002:ab0:74c8:: with SMTP id f8mr13364974uaq.114.1575664951658;
 Fri, 06 Dec 2019 12:42:31 -0800 (PST)
MIME-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com> <20191127190922.GH22227@linux.intel.com>
 <CANgfPd-XR0ZpbTtV21KrM_Ud1d0ntHxE6M4JzcFVZ4M0zG8XYQ@mail.gmail.com> <20191206195742.GC5433@linux.intel.com>
In-Reply-To: <20191206195742.GC5433@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Fri, 6 Dec 2019 12:42:20 -0800
Message-ID: <CANgfPd_VXpM5OfJVHO3EwL2h5_cGD-hb4rzLRD9nGnkMHJi_9Q@mail.gmail.com>
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

Switching to a RW lock is easy, but nothing would be able to use the
read lock because it's not safe to make most kinds of changes to PTEs
in parallel in the existing code. If we sharded the spinlock based on
GFN it might be easier, but that would also take a lot of
re-engineering.

On Fri, Dec 6, 2019 at 11:57 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Dec 06, 2019 at 11:55:42AM -0800, Ben Gardon wrote:
> > I'm finally back in the office. Sorry for not getting back to you sooner.
> > I don't think it would be easy to send the synchronization changes
> > first. The reason they seem so small is that they're all handled by
> > the iterator. If we tried to put the synchronization changes in
> > without the iterator we'd have to 1.) deal with struct kvm_mmu_pages,
> > 2.) deal with the rmap, and 3.) change a huge amount of code to insert
> > the synchronization changes into the existing framework. The changes
> > wouldn't be mechanical or easy to insert either since a lot of
> > bookkeeping is currently done before PTEs are updated, with no
> > facility for rolling back the bookkeeping on PTE cmpxchg failure. We
> > could start with the iterator changes and then do the synchronization
> > changes, but the other way around would be very difficult.
>
> By synchronization changes, I meant switching to a r/w lock instead of a
> straight spinlock.  Is that doable in a smallish series?
