Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD2349D784
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 02:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiA0Bg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 20:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbiA0Bg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 20:36:58 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A15C06173B
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 17:36:58 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z5so1158159plg.8
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 17:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=TdbcAW8Wcsbhbg+STcZ6rCmSH6CygPXwwlC04FLl3Fk=;
        b=qbIR8ggpmVwwdHq60/YeZ10maSd+yjnxnuOFwpuV7+i5epS3/uhkgm4YedelnprmUc
         YQiOdj/oYSh44GzfhLk0x17DEwQ2jWzqLlt1kH2e7Z9FHbBW/YWizX3spo8Ei9dMmugF
         tCtNc4H1d+86hxejIsI8GwaEJm3v4vagbx+h0QVOI1qbb0xSu9jW+aL2TAADWaPxf/bz
         Wn/KCOgrEEVMSGcrVvsmmvmYq2yarnk4JsH2kTUeUa1MUYTGe2ZMZouAUqRtf2I5SakR
         fFwcstjiPL3MkdAnpajNxnxS96l1N3qvJlj+k6m1RAjQ4tNWvaSU8tHqu5V3IOG4lYEa
         hVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TdbcAW8Wcsbhbg+STcZ6rCmSH6CygPXwwlC04FLl3Fk=;
        b=OEAEZTxii4kq0QLt51p6OmSx0eE+ufDBzWjtQhmi52xkU4FYmgiZVw4meEAm6m7m+P
         N1Vn9YvpIQMG9+bcEuxlQxsY5YET3Sa7LbpPnHi4whTh1bb+7jWzvp0BHGILbTpScCPi
         EDEJg9qfxrTfEVxNsiOIYLoCQER0pygSHEDh2xE+TycP9ksZcZNVODaPIU0vDETXHVvm
         EJ4X1n9qXziR4mQmYtcbofxRIhnrAGHx0BLoM8sr9mXn4vW0ljH1sCD3yOt7dhIAD9h3
         iewT+6INkOcrmqfi2cPHvlE518Vnoco4o9/+u4ixeTEcR+bWB6+dk1HQGXa2Q9qiY6jx
         zfnQ==
X-Gm-Message-State: AOAM533RjU1/mwCJVjhT83sztjmJNA6SeKXzI10Vm998vCBLmnpxDZSw
        EXbqVH6NgHnCQGEB+anX0SSbow==
X-Google-Smtp-Source: ABdhPJwyv9IYD8tAHriwPMy+UM17hPFPXQd1hQvtQq4xlXy8l+CGsqikmNk43pNMZncp1y6I8ifS/w==
X-Received: by 2002:a17:902:e545:: with SMTP id n5mr1099208plf.160.1643247417591;
        Wed, 26 Jan 2022 17:36:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ha11sm5476388pjb.3.2022.01.26.17.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 17:36:57 -0800 (PST)
Date:   Thu, 27 Jan 2022 01:36:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chris Mason <clm@fb.com>
Cc:     Boris Burkov <boris@bur.io>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH] KVM: use set_page_dirty rather than SetPageDirty
Message-ID: <YfH3NR+g0uRIruCc@google.com>
References: <08b5b2c516b81788ca411dc031d403de4594755e.1643226777.git.boris@bur.io>
 <YfHEJpP+1c9QZxA0@google.com>
 <YfHVB5RmLZn2ku5M@zen>
 <3876CE62-6E66-4CCE-ADED-69010EA72394@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3876CE62-6E66-4CCE-ADED-69010EA72394@fb.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 27, 2022, Chris Mason wrote:
> 
> 
> > On Jan 26, 2022, at 6:11 PM, Boris Burkov <boris@bur.io> wrote:
> > 
> > On Wed, Jan 26, 2022 at 09:59:02PM +0000, Sean Christopherson wrote:
> >> On Wed, Jan 26, 2022, Boris Burkov wrote:
> >>> I tested this fix on the workload and it did prevent the hangs. However,
> >>> I am unsure if the fix is appropriate from a locking perspective, so I
> >>> hope to draw some extra attention to that aspect. set_page_dirty_lock in
> >>> mm/page-writeback.c has a comment about locking that says set_page_dirty
> >>> should be called with the page locked or while definitely holding a
> >>> reference to the mapping's host inode. I believe that the mmap should
> >>> have that reference, so for fear of hurting KVM performance or
> >>> introducing a deadlock, I opted for the unlocked variant.
> >> 
> >> KVM doesn't hold a reference per se, but it does subscribe to mmu_notifier events
> >> and will not mark the page dirty after KVM has been instructed to unmap the page
> >> (barring bugs, which we've had a slew of).  So yeah, the unlocked variant should
> >> be safe.
> >> 
> >> Is it feasible to trigger this behavior in a selftest?  KVM has had, and probably
> >> still has, many bugs that all boil down to KVM assuming guest memory is backed by
> >> either anonymous memory or something like shmem/HugeTLBFS/memfd that isn't typically
> >> truncated by the host.
> > 
> > I haven't been able to isolate a reproducer, yet. I am a bit stumped
> > because there isn't a lot for me to go off from that stack I shared--the
> > best I have so far is that I need to trick KVM into emulating
> > instructions at some point to get to this 'complete_userspace_io'
> > codepath? I will keep trying, since I think it would be valuable to know
> > what exactly happened. Open to try any suggestions you might have as
> > well.
> 
> From the btrfs side, bare calls to set_page_dirty() are suboptimal, since it
> doesn’t go through the ->page_mkwrite() dance that we use to properly COW
> things.  It’s still much better than SetPageDirty(), but I’d love to
> understand why kvm needs to dirty the page so we can figure out how to go
> through the normal mmap file io paths.

Ah, is the issue that writeback gets stuck because KVM perpetually marks the
page as dirty?  The page in question should have already gone through ->page_mkwrite().
Outside of one or two internal mmaps that KVM fully controls and are anonymous memory,
KVM doesn't modify VMAs.  KVM is calling SetPageDirty() to mark that it has written
to the page; KVM either when it unmaps the page from the guest, or in this case, when
it kunmap()'s a page KVM itself accessed.

Based on the call stack, my best guest is that KVM is udpating steal_time info.
That's triggered when the vCPU is (re)loaded, which would explain the correlation
to complete_userspace_io() as KVM unloads=>reloads the vCPU before/after exiting
to userspace to handle emulate I/O.

Oh!  I assume that the page is either unmapped or made read-only before writeback?
v5.6 (and many kernels since) had a bug where KVM would "miss" mmu_notifier events
for the steal_time cache.  It's basically a use-after-free issue at that point.  Commit
7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status").
