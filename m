Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374E9665619
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 09:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjAKIb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 03:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjAKIbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 03:31:25 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE16FCE
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 00:31:23 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7394916F67;
        Wed, 11 Jan 2023 08:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673425882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oub3vFhESlSmnZ3siI+/gjjg/Dwj1NqJPNyjl/9KfIQ=;
        b=cmuaLl7/52pfKxXUc/CBXEiqKnPqLpQWCowccOGASSIbzhEdDU1PcadMlGNfelOEeS253n
        ieQeV/pM1Hoiy2NrnFHJWhXDGxSQSohTJtBMOF6FbkZpu4vJMh4i2+Kn9jgKphqnyao8NA
        Al0ZewKR17ODODZJfuuTf6aiYiT5Oag=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5215113591;
        Wed, 11 Jan 2023 08:31:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9cEiEdpzvmOURgAAMHmgww
        (envelope-from <mhocko@suse.com>); Wed, 11 Jan 2023 08:31:22 +0000
Date:   Wed, 11 Jan 2023 09:31:21 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>, yuzhao@google.com,
        Vlastimil Babka <vbabka@suse.cz>, shy828301@gmail.com
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
Message-ID: <Y75z2Ran1+Iw+L6+@dhcp22.suse.cz>
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed 11-01-23 09:00:04, Jiri Slaby wrote:
> Hi,
> 
> after I updated the host from 6.0 to 6.1 (being at 6.1.4 ATM), my qemu VMs
> started stalling (and the host at the same point too). It doesn't happen
> right after boot, maybe a suspend-resume cycle is needed (or longer uptime,
> or a couple of qemu VM starts, or ...). But when it happens, it happens all
> the time till the next reboot.
> 
> Older guest's kernels/distros are affected as well as Win10.
> 
> In guests, I see for example stalls in memset_orig or
> smp_call_function_many_cond -- traces below.
> 
> qemu-kvm-7.1.0-13.34.x86_64 from openSUSE.
> 
> It's quite interesting that:
>   $ cat /proc/<PID_OF_QEMU>/cmdline
> is stuck at read:
> 
> openat(AT_FDCWD, "/proc/12239/cmdline", O_RDONLY) = 3
> newfstatat(3, "", {st_mode=S_IFREG|0444, st_size=0, ...}, AT_EMPTY_PATH) = 0
> fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
> mmap(NULL, 139264, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
> 0x7f22f0487000
> read(3, ^C^C^C^\^C

This will require mmap_lock for read as well. And that is blocked
because there is a pending writer as well.
[...]
 
> Is this known? Any idea how to debug this?

I would recommend taking a crashdump when the host is in that state and
examine the state of the blocked lock. Dump will hopefully give you more
information about potential holder of the lock. If it is blocked on
writer then you should get the owner task. If it is in read mode then
this can get more tricky because the exact owner might be different from
the recorded one. Anyway the full list of tasks and their backtraces
could tell more.

HTH

-- 
Michal Hocko
SUSE Labs
