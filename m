Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D81A4857E1
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 19:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242723AbiAESEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 13:04:33 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:34122 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242712AbiAESEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 13:04:24 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DEABD1F37F;
        Wed,  5 Jan 2022 18:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641405861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I285agTL7MMNPRyO3Wp0TqKsq8WVrLiSnho8jMPnTkc=;
        b=aFsCA1NnRlrdQX1xT7reIq3L0VKqZSlIvdXLA7XJhLNT/q89yCOFr5XON4VbVZ7G7cvBpm
        HgZpjo44U4Co78g3KMsxUq5JYI6+JPe1N4QKevGPjRmwEcGI5lvuZgdw/k0sbscvbcnc04
        U5AyWHBn19jEbSdt+moEurjPuqZKS3o=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BCC0113C03;
        Wed,  5 Jan 2022 18:04:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SnV9LaXd1WFaNAAAMHmgww
        (envelope-from <mkoutny@suse.com>); Wed, 05 Jan 2022 18:04:21 +0000
Date:   Wed, 5 Jan 2022 19:04:20 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, tj@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com,
        jiangshanlai@gmail.com, kvm@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Message-ID: <20220105180420.GC6464@blackbody.suse.cz>
References: <20211222225350.1912249-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222225350.1912249-1-vipinsh@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vipin.

On Wed, Dec 22, 2021 at 10:53:50PM +0000, Vipin Sharma <vipinsh@google.com> wrote:
> VM worker kthreads can linger in the VM process's cgroup for sometime
> after KVM terminates the VM process.

Why is it a problem? And how long are we talking about?

> A VM process can terminate between the time window of exit_mm() to
> cgroup_exit(), leaving only worker kthreads in the cgroup.

Even kthreads should eventually have PF_EXITING set, they shouldd be
treated as "user-space" zombies by cgroups, i.e. mostly invisible (e.g.
it doesn't prevent rmdir'ing the cgroup).

(And after the last task_struct reference is gone, the cgroup structs
can be released too. Maybe the cause is holding the reference to the KVM
worker thread somewhere for too long.)

> Moving worker kthreads back to the original cgroup (kthreadd_task's
> cgroup) makes sure that cgroup is empty as soon as the main VM process
> is terminated.

BTW this used to be done for "user-space" tasks too (migrate to root
cgroup) but it was replaced with the less transactional "ignore zombies"
approach. So this change seems inconsistent.


Regards,
Michal
