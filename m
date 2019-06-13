Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516C24446C
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392620AbfFMQhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:37:01 -0400
Received: from mail.skyhub.de ([5.9.137.197]:51304 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730665AbfFMHUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 03:20:25 -0400
Received: from zn.tnic (p4FED33E6.dip0.t-ipconnect.de [79.237.51.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 565C61EC0AB5;
        Thu, 13 Jun 2019 09:20:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1560410423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=tKFI3RchuZbj7w3LjtEwG4S62EiV690jJjYj5RY6/LA=;
        b=Wf4ZGM6wOcNOStraWYddmu1A+eOW/Nu5+HkTPUWpH/kJo5ivcVLl6xyavtlzTo8NsilRzP
        rkO+Rrkd6/66fFnIbKUF0L4vgC5f8EXXa+iVnv1sZLb+z6xyhJjicIgB/5DDe8+ZOLl1cA
        koRuPRE4tF3yIvtNdyEV/8VJcrF/g4s=
Date:   Thu, 13 Jun 2019 09:18:05 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        George Kennedy <george.kennedy@oracle.com>
Cc:     joro@8bytes.org, pbonzini@redhat.com, mingo@redhat.com,
        hpa@zytor.com, kvm@vger.kernel.org, syzkaller@googlegroups.com
Subject: Re: kernel BUG at arch/x86/kvm/x86.c:361! on AMD CPU
Message-ID: <20190613071805.GA11598@zn.tnic>
References: <37952f51-7687-672c-45d9-92ba418c9133@oracle.com>
 <20190612161255.GN32652@zn.tnic>
 <af0054d1-1fc8-c106-b503-ca91da5a6fee@oracle.com>
 <20190612195152.GQ32652@zn.tnic>
 <20190612205430.GA26320@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190612205430.GA26320@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 12, 2019 at 01:54:30PM -0700, Sean Christopherson wrote:
> The reboot thing is a red-herring.   The ____kvm_handle_fault_on_reboot()
> macro suppresses faults that occur on VMX and SVM instructions while the
> kernel is rebooting (CPUs need to leave VMX/SVM mode to recognize INIT),
> i.e. kvm_spurious_fault() is reached when a VMX or SVM instruction faults
> and we're *not* rebooting.
> 
> TL;DR: an SVM instruction is faulting unexpectedly.

Aha, thx!

And there are a couple of places in svm_vcpu_run() which can cause that:

[  135.498208] Call Trace:
[  135.498594]  svm_vcpu_run+0xa83/0x20e0

George, can you objdump the area around offset 0xa83 within svm_vcpu_run
of the guest kernel?

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
