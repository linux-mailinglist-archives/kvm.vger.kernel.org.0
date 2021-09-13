Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F40040987F
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 18:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345736AbhIMQPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 12:15:34 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52940 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbhIMQPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 12:15:33 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 85FAC1FD99;
        Mon, 13 Sep 2021 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631549656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=am3WMc1q9XARynRDUM7E3FUGoxi9LsITJzf3oeQ+Lww=;
        b=P/4IFY9RCf3aKGlNrhp4PnGQUQUBpMMsHj0KqsHTSXt5OdpCfML/CO9aOsYMSrM2X9fQuN
        +uG8yEn3iOcJ4wLeht3ztrh5E3yCcwpzPJm7JFM92jmUw918wl5ZBG27ouscyAT4J34f1T
        N3cV0Ud03Kmk8mK9YOC4/ANyQFbWLa0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631549656;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=am3WMc1q9XARynRDUM7E3FUGoxi9LsITJzf3oeQ+Lww=;
        b=Q7q10t86FU0aIasjf0FzLIFUI+diQ5WAToTZOr1nw6kx/bpWHfTpn4UjvYcHbt8+s2poj8
        UAtG7spSEyhbPVAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A329613AAB;
        Mon, 13 Sep 2021 16:14:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 62cXJtd4P2F6IQAAMHmgww
        (envelope-from <jroedel@suse.de>); Mon, 13 Sep 2021 16:14:15 +0000
Date:   Mon, 13 Sep 2021 18:14:14 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Dave Hansen <dave.hansen@intel.com>
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 00/12] x86/sev: KEXEC/KDUMP support for SEV-ES guests
Message-ID: <YT941raolZvGTVR/@suse.de>
References: <20210913155603.28383-1-joro@8bytes.org>
 <4e033293-b81d-1e21-6fd6-f507b6821d3c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e033293-b81d-1e21-6fd6-f507b6821d3c@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 09:02:38AM -0700, Dave Hansen wrote:
> On 9/13/21 8:55 AM, Joerg Roedel wrote:
> > This does not work under SEV-ES, because the hypervisor has no access
> > to the vCPU registers and can't make modifications to them. So an
> > SEV-ES guest needs to reset the vCPU itself and park it using the
> > AP-reset-hold protocol. Upon wakeup the guest needs to jump to
> > real-mode and to the reset-vector configured in the AP-Jump-Table.
> 
> How does this end up looking to an end user that tries to kexec() from a
> an SEV-ES kernel?  Does it just hang?

Yes, the kexec will just hang. This patch-set contains code to disable
the kexec syscalls in situations where it would not work for that
reason.

Actually with the changes to the decompressor in this patch-set the
kexec'ed kernel could boot, but would fail to bring up all the APs.

Regards,

	Joerg
