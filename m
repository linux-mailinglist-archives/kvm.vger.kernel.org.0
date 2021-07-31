Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424003DC460
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 09:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhGaHRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Jul 2021 03:17:47 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45546 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhGaHRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Jul 2021 03:17:47 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DCE38221E7;
        Sat, 31 Jul 2021 07:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627715859; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kyM9js2aRHyfGQiZvaRI/san3KM6xq/gaboX810m66s=;
        b=lAxg8F6VD+4AnPsG/mMhP3TjLl40VG23Kmwg7lgnscQBVXujxipnB1sRvy5Fwphgzm4MTl
        QqLgOnsZRhK9HeWuIQ56QyuwQZemhPbKhqTsuyhMYUqkwt8qCMn0O9ZG91clmhv3fuJxJ0
        LJjlecCWVAS8I36UubMgskseBux/bCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627715859;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kyM9js2aRHyfGQiZvaRI/san3KM6xq/gaboX810m66s=;
        b=Hynwo4vVVOPM1dP9PH0k9MPz4dgRUYk0yb4mOQgcejQs4gUNDFuPN/RU9Xx9dWthWdCdVJ
        dBCyAXx0G9H401CA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0EF0D1368F;
        Sat, 31 Jul 2021 07:17:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id jptYARP5BGF3OQAAGKfGzw
        (envelope-from <jroedel@suse.de>); Sat, 31 Jul 2021 07:17:39 +0000
Date:   Sat, 31 Jul 2021 09:17:37 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 11/12] x86/sev: Handle CLFLUSH MMIO events
Message-ID: <YQT5Ec5M6maZdFoO@suse.de>
References: <20210721142015.1401-1-joro@8bytes.org>
 <20210721142015.1401-12-joro@8bytes.org>
 <YQSAVo0CXUKHXdLF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQSAVo0CXUKHXdLF@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Fri, Jul 30, 2021 at 10:42:30PM +0000, Sean Christopherson wrote:
> On Wed, Jul 21, 2021, Joerg Roedel wrote:
> This wording can be misread as "the hypervisor is responsible for _all_ cache
> management".  Maybe just:
> 
> 		/*
> 		 * Ignore CLFLUSHes - the hyperivsor is responsible for cache
> 		 * management of emulated MMIO.
> 		 */

Right, will update the comment, thanks.

> Side topic, out of curisoity, what's mapping/accessing emulated MMIO as non-UC?

The CLFLUSHes happen when the kexec'ed kernel maps the VGA framebuffer
as unencrypted. Initially it is mapped encrypted and before re-mapping
the kernel flushes the range from the caches.

I have not investigated why this doesn't happen on the first boot,
though.

Regards,

	Joerg
