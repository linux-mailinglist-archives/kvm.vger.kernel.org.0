Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A53316B9E
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 17:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhBJQrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 11:47:51 -0500
Received: from 8bytes.org ([81.169.241.247]:55448 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232552AbhBJQr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 11:47:26 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 6B01C3C2; Wed, 10 Feb 2021 17:46:44 +0100 (CET)
Date:   Wed, 10 Feb 2021 17:46:42 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 6/7] x86/boot/compressed/64: Check SEV encryption in
 32-bit boot-path
Message-ID: <20210210164642.GE7302@8bytes.org>
References: <20210210102135.30667-1-joro@8bytes.org>
 <20210210102135.30667-7-joro@8bytes.org>
 <0526b64e-8ef0-2e3c-06a7-e07835be160c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0526b64e-8ef0-2e3c-06a7-e07835be160c@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 08:25:11AM -0800, Dave Hansen wrote:
> This is all very cute.  But, if this fails, it means that the .data
> section is now garbage, right?.  I guess failing here is less
> entertaining than trying to run the kernel with random garbage in .data,
> but it doesn't make it very far either way, right?

Yes, if this fails the .data section is garbage, and more importantly,
the .text section of the decompressed kernel image would be garbage too.
The kernel won't get very far, but could possibly be tricked into
releasing secrets to the hypervisor.

> Why bother with rdrand, though?  Couldn't you just pick any old piece of
> .data and compare before and after?

It is important that the Hypervisor can't predict what data will be
written. It is written with paging off, so it will implicitly be
encrypted. If the Hypervisor knows the data, it could use the small time
window until it is read again to remap the gpa to a page with the
expected data.

Regards,

	Joerg
