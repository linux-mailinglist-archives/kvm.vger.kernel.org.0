Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316F39B89B
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2019 00:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfHWWqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 18:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbfHWWqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 18:46:35 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55CF5233FD
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 22:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566600394;
        bh=5AtlJ8cym2kVMj3VKczQ/Xr2AFA5SHmNJu+9Zb0ZS8I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZY8C3/B7eZSRy5ebXhQPvij2EefFFDcbMwxZDWtqCfrP/cBNiP9RF8ww/isge35Ua
         zFxjNcx10rXYutEyJmLe+95iYLCIYPZGdAKheA2SHe/bxpBwNqYTP4IkIoF2YbClqM
         eZNIfK6+Uxl9//ymGHg3lB/X7m82VSY57qMbE2U4=
Received: by mail-wm1-f43.google.com with SMTP id f72so10197398wmf.5
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 15:46:34 -0700 (PDT)
X-Gm-Message-State: APjAAAVjBp7ok9OXUx/35IcrfQPNDMgCAvHZxoAU1fbPDsXWmVSjhgSx
        3dVfKj/147txHUp+X9CCfNziz8fRjW4F2C8nIIT5rA==
X-Google-Smtp-Source: APXvYqwTdt6tHwJgQgfuQY2j6MTIhPY5i33QMVfj1jsY5dz0nP10DPqA6QTn2BjMkcIJfrNxuRltErSdubOhX7NWEAo=
X-Received: by 2002:a1c:f910:: with SMTP id x16mr7225160wmh.173.1566600392711;
 Fri, 23 Aug 2019 15:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190823205544.24052-1-sean.j.christopherson@intel.com>
In-Reply-To: <20190823205544.24052-1-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 23 Aug 2019 15:46:20 -0700
X-Gmail-Original-Message-ID: <CALCETrXFRAmgqyxtsknpnQaMtVU-hqMRPYR=4Q5JtBgNGxuSGQ@mail.gmail.com>
Message-ID: <CALCETrXFRAmgqyxtsknpnQaMtVU-hqMRPYR=4Q5JtBgNGxuSGQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Don't update RIP or do single-step on faulting emulation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 23, 2019 at 1:55 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Don't advance RIP or inject a single-step #DB if emulation signals a
> fault.  This logic applies to all state updates that are conditional on
> clean retirement of the emulation instruction, e.g. updating RFLAGS was
> previously handled by commit 38827dbd3fb85 ("KVM: x86: Do not update
> EFLAGS on faulting emulation").
>
> Not advancing RIP is likely a nop, i.e. ctxt->eip isn't updated with
> ctxt->_eip until emulation "retires" anyways.  Skipping #DB injection
> fixes a bug reported by Andy Lutomirski where a #UD on SYSCALL due to
> invalid state with RFLAGS.RF=1 would loop indefinitely due to emulation

EFLAGS.TF=1
