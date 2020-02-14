Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD2315F63A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 19:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387552AbgBNS5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 13:57:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728859AbgBNS5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 13:57:08 -0500
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F03E24670
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581706626;
        bh=YlbFqP4MOujySUgnVR9wtKNwv0GjLZbM5SbUJK0O0gQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LFxgD4D+vmep4eAzrKNlFmVFdKVoEdLCpcb8r6lf3Y7K8zRscdcjqr7NFiohrVA85
         HzvaAZxHtIPji4PzbrjMDpMUOw9EiuIwJGLQ2/v7mzoIFjvifDnzJgHub58d+I9LIM
         8U/QNff+0x9O+PPZqDCBUvpj8SGZ5n3iEL5Alnrw=
Received: by mail-wm1-f54.google.com with SMTP id t14so11785997wmi.5
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 10:57:06 -0800 (PST)
X-Gm-Message-State: APjAAAVcFv50+jh44AD2SoJ0Pq+rAPTiyhnFLwc4LB/Q8xejU/HAqSGE
        zwSpRCUSeqfHHop1JMW0VkOmsoorpaHBWInvHcI9xw==
X-Google-Smtp-Source: APXvYqxxTQ3SaP1YdoafrYMVaIYSQJJTGOsfi5VrDKZoEp9ouh4TF+uABwFX1kDAEk06lgdpKqTVZcp7FLgcnYYfkKY=
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr6008857wmi.21.1581706625011;
 Fri, 14 Feb 2020 10:57:05 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581555616.git.ashish.kalra@amd.com> <a22c5b534fa035b23e549669fd5ac617b6031158.1581555616.git.ashish.kalra@amd.com>
 <CALCETrX6Oo00NXn2QfR=eOKD9wvWiov_=WBRwb7V266=hJ2Duw@mail.gmail.com> <20200213222825.GA8784@ashkalra_ubuntu_server>
In-Reply-To: <20200213222825.GA8784@ashkalra_ubuntu_server>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 14 Feb 2020 10:56:53 -0800
X-Gmail-Original-Message-ID: <CALCETrX=ycjSuf_N_ff-VQtqq2_RoawuAqdkM+bCPn_2_swkjg@mail.gmail.com>
Message-ID: <CALCETrX=ycjSuf_N_ff-VQtqq2_RoawuAqdkM+bCPn_2_swkjg@mail.gmail.com>
Subject: Re: [PATCH 10/12] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 13, 2020 at 2:28 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> On Wed, Feb 12, 2020 at 09:42:02PM -0800, Andy Lutomirski wrote:
> >> On Wed, Feb 12, 2020 at 5:18 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >> >
> >> > From: Brijesh Singh <brijesh.singh@amd.com>
> > >
> > > Invoke a hypercall when a memory region is changed from encrypted ->
> > > decrypted and vice versa. Hypervisor need to know the page encryption
> > > status during the guest migration.
> >>
> >> What happens if the guest memory status doesn't match what the
> >> hypervisor thinks it is?  What happens if the guest gets migrated
> >> between the hypercall and the associated flushes?
>
> This is basically same as the dirty page tracking and logging being done
> during Live Migration. As with dirty page tracking and logging we
> maintain a page encryption bitmap in the kernel which keeps tracks of
> guest's page encrypted/decrypted state changes and this bitmap is
> sync'ed regularly from kernel to qemu and also during the live migration
> process, therefore any dirty pages whose encryption status will change
> during migration, should also have their page status updated when the
> page encryption bitmap is sync'ed.
>
> Also i think that when the amount of dirty pages reach a low threshold,
> QEMU stops the source VM and then transfers all the remaining dirty
> pages, so at that point, there will also be a final sync of the page
> encryption bitmap, there won't be any hypercalls after this as the
> source VM has been stopped and the remaining VM state gets transferred.

And have you ensured that, in the inevitable race when a guest gets
migrated part way through an encryption state change, that no data
corruption occurs?
