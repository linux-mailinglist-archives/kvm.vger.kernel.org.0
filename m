Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD5B1F6D4D
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 20:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgFKSQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 14:16:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:57744 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgFKSQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 14:16:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 12C16B158;
        Thu, 11 Jun 2020 18:16:48 +0000 (UTC)
Date:   Thu, 11 Jun 2020 20:16:41 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 47/75] x86/sev-es: Add Runtime #VC Exception Handler
Message-ID: <20200611181641.GD12636@suse.de>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-48-joro@8bytes.org>
 <20200523075924.GB27431@zn.tnic>
 <20200611114831.GA11924@8bytes.org>
 <20200611173848.GK29918@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611173848.GK29918@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 10:38:48AM -0700, Sean Christopherson wrote:
> Isn't it possible for the #VC handler to hit a #PF, e.g. on copy_from_user()
> in insn_fetch_from_user()?  If that happens, what prevents the #PF handler
> from hitting a #VC?  AIUI, do_vmm_communication() panics if the backup GHCB
> is already in use, e.g. #VC->#PF->#VC->NMI->#VC would be fatal.

This would be possible, if the #PF handler is able to trigger a #VC. But
I am not sure how it could, except when it has to call printk.

If #PF can trigger a #VC, then a fix is to further limit the time the
GHCB is active, and make sure there are not faults of any kind when it
actually is active. Then the only vector to care about is NMI. I will
look into that.

Regards,

	Joerg
