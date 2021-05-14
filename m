Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E5A38064F
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 11:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbhENJfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 05:35:48 -0400
Received: from mail.skyhub.de ([5.9.137.197]:49390 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230440AbhENJfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 05:35:48 -0400
Received: from zn.tnic (p200300ec2f0b2c00e3a8a74f5e6ed04b.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:2c00:e3a8:a74f:5e6e:d04b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BE0F01EC03A0;
        Fri, 14 May 2021 11:34:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620984875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ovqv0SJJOBb0VgUZg/gbbY4+17dZV172VEEnq0LQFcM=;
        b=pd9xbMq5COhgZIIfyQYqKznYeYiV614DPbDYvQsPTvnatKNXq8NVVGe9jQ3pEkKj23+xGF
        PVMo7LVYAzeu8McWVh9KC3UhsrUbDEAFGiTT/dyKTvBcWqGuNll0Uxy7bmde2uSD3ixelL
        QU0YmuFA9KlBWxTT0DiomlC1VHMuJrU=
Date:   Fri, 14 May 2021 11:34:32 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <YJ5EKPLA9WluUdFG@zn.tnic>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
 <20210513043441.GA28019@ashkalra_ubuntu_server>
 <YJ4n2Ypmq/7U1znM@zn.tnic>
 <7ac12a36-5886-cb07-cc77-a96daa76b854@redhat.com>
 <20210514090523.GA21627@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210514090523.GA21627@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 09:05:23AM +0000, Ashish Kalra wrote:
> Ideally we should fail/stop migration even if a single guest page
> encryption status cannot be notified and that should be the way to
> proceed in this case, the guest kernel should notify the source
> userspace VMM to block/stop migration in this case.

Yap, and what I'm trying to point out here is that if the low level
machinery fails for whatever reason and it cannot recover, we should
propagate that error up the chain so that the user is aware as to why it
failed.

WARN is a good first start but in some configurations those splats don't
even get shown as people don't look at dmesg, etc.

And I think it is very important to propagate those errors properly
because there's a *lot* of moving parts involved in a guest migration
and you have encrypted memory which makes debugging this probably even
harder, etc, etc.

I hope this makes more sense.

> From a practical side, i do see Qemu's migrate_add_blocker() interface
> but that looks to be a static interface and also i don't think it will
> force stop an ongoing migration, is there an existing mechanism
> to inform userspace VMM from kernel about blocking/stopping migration ?

Hmm, so __set_memory_enc_dec() which calls
notify_addr_enc_status_changed() is called by the guest, right, when it
starts migrating.

Can an error value from it be propagated up the callchain so it can be
turned into an error messsage for the guest owner to see?

(I might be way off base here as I have no clue how the whole migration
 machinery is kicked into gear...)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
