Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E3E15A946
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgBLMjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 07:39:13 -0500
Received: from 8bytes.org ([81.169.241.247]:53812 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgBLMjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 07:39:13 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 783E820E; Wed, 12 Feb 2020 13:39:11 +0100 (CET)
Date:   Wed, 12 Feb 2020 13:39:02 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 30/62] x86/head/64: Move early exception dispatch to C
 code
Message-ID: <20200212123902.GG20066@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211135256.24617-31-joro@8bytes.org>
 <CALCETrVLhTkZ2MMUD+WMWXnhmSvwVhinUtMJey2M6sx_iUREcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVLhTkZ2MMUD+WMWXnhmSvwVhinUtMJey2M6sx_iUREcg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:44:45PM -0800, Andy Lutomirski wrote:
> How about int (or bool) handled;  Or just if (!early_make_pgtable)
> return;  This would also be nicer if you inverted the return value so
> that true means "I handled it".

Okay, makes sense. Changed the return value of early_make_pgtable() to bool and
this function to:

	void __init early_exception(struct pt_regs *regs, int trapnr)
	{
		if (trapnr == X86_TRAP_PF &&
		    early_make_pgtable(native_read_cr2()))
				return;

		early_fixup_exception(regs, trapnr);
	}

Regards,

	Joerg
