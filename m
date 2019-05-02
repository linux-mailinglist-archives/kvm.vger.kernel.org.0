Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5EA212185
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 19:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfEBR73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 13:59:29 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:37390 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfEBR73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 13:59:29 -0400
Received: by mail-it1-f194.google.com with SMTP id r85so4946874itc.2
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 10:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QkE7Z8bp1yVWCQLgP7vT+++alIktlYTSVetu12Bh/2U=;
        b=Mpu/2WIMz1jQGp5nl581dfpk6jIrzzuJ4mXqpIgMBbFSNg887XJbSRwbVLLp8dQaOa
         U1oqkfjw7HaQkVvs3djpT1cIF74w6ZRSmpvhNOZCANQETm7V8maG5szensTOBoObX9YL
         /y1leuCG0PLjf8qt/n9OoX6+0Cbh6rmNQFeJzlSVgSIRW5kp/qA559tQ1Amc7hVY9VOV
         GClXTQtJ7kX8PpVEH56E5pnOmP+yOZqapJk9j8RDsU5/9+cegCb2/N+hrg9nTNEo1NSD
         aFhTHDSicIxktbcZHzleQiVnVUJtjbsQhzEqdH99KqruYq9i372qSTCgRQS/FCpTlKjg
         EQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QkE7Z8bp1yVWCQLgP7vT+++alIktlYTSVetu12Bh/2U=;
        b=cMk/qmXJhU3mKTDXCy3b3TQs2maya3nnuvy7xjQwLofIcF8nJDifFEQx+LX6rje8H1
         Dj1oJU+qoViB8hte0/2mXOl3I6Qvi51+RlVdN2W65b2qcHkaZkvVCS9fo2GmfOq0Ko2T
         HDGMRPNv5LkOxxSwSsD1sEghsiDqZrR7McoExiGcjrV2BHi/HOrw6C26z+HS95Yg7Wt8
         PvFUxhUSzzD2P8GtGSc8ajzctiCDpYL33lWPs/zpW7HSXfVwTPvBvs5JWEohXL+Txr2R
         CVjbbQd1sl51ZP8ALQ1J0WnbpPR+Z1K4PgxGJGoAGvpY823HGrIkfCeJ1iD5y/neB3i6
         lonw==
X-Gm-Message-State: APjAAAVlMD9dnQOko1wo6zcqBBgYqRkV4OQIeZ+nJIHSD+nm4wA3Sz6W
        kFCi14BQs1oMfZxHZHikM4OG2GBQqmV+HD2eWZyzrA==
X-Google-Smtp-Source: APXvYqzoRCMnFrYGuMUfxJx957vy51w+IrehKeZzG9/4u6cMlbOw4XIyOMgs2j+PjmvtrJg78ziLhHdi5YKVCBN2JKs=
X-Received: by 2002:a24:7f93:: with SMTP id r141mr3252045itc.132.1556819967942;
 Thu, 02 May 2019 10:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <1556762959-31705-1-git-send-email-jintack@cs.columbia.edu> <20190502150315.GB26138@linux.intel.com>
In-Reply-To: <20190502150315.GB26138@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 2 May 2019 10:59:16 -0700
Message-ID: <CALMp9eQot5jqiN4ncLDCPt_ZiVvtmEb_zeMp=1gkOChTrgL+dg@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Set msr bitmap correctly for MSR_FS_BASE in vmcs02
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jintack Lim <jintack@cs.columbia.edu>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 2, 2019 at 8:03 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:

> That being said, I think there are other reasons why KVM doesn't pass
> through MSRs to L2.  Unfortunately, I'm struggling to recall what those
> reasons are.
>
> Jim, I'm pretty sure you've looked at this code a lot, do you happen to
> know off hand?  Is it purely a performance thing to avoid merging bitmaps
> on every nested entry, is there a subtle bug/security hole, or is it
> simply that no one has ever gotten around to writing the code?

I'm not aware of any subtle bugs or security holes. If L1 changes the
VMCS12 MSR permission bitmaps while L2 is running, behavior is
unlikely to match hardware, but this is clearly in "undefined
behavior" territory anyway. IIRC, the posted interrupt structures are
the only thing hanging off of the VMCS that can legally be modified
while a logical processor with that VMCS active is in VMX non-root
operation.

I agree that FS_BASE, GS_BASE, and KERNEL_GS_BASE, at the very least,
are worthy of special treatment. Fortunately, their permission bits
are all in the same quadword. Some of the others, like the SYSENTER
and SYSCALL MSRs are rarely modified by a typical (non-hypervisor) OS.
For nested performance at levels deeper than L2, they might still
prove interesting.

Basically, I think no one has gotten around to writing the code.
