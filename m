Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DD9354DFF
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhDFHkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbhDFHku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 03:40:50 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E378C06174A;
        Tue,  6 Apr 2021 00:40:39 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0a0d00ba768637d7a9c90c.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:d00:ba76:8637:d7a9:c90c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D774D1EC01B5;
        Tue,  6 Apr 2021 09:40:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617694837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LKTE8PF9XH92NUe0ULUEFYJxn+bHhX2DcinJ7vfHwRE=;
        b=RkbZUK0yp5udJRGhRSacLkmdpftlSe8pwJAn7EUK3d5j5PYCqIvLkK19Ic9tVy8rpIU/TK
        wOmnaQGve3xzUabKQG1MYN3p8UDrwZKGnCdae9mjBxbXlm8pouxAG7VBJ4fpBdekXBzSiu
        0pQkdtEIoLIqvqq01zVHxdNtoDKCcu4=
Date:   Tue, 6 Apr 2021 09:40:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 13/25] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <20210406073917.GA17806@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <20e09daf559aa5e9e680a0b4b5fba940f1bad86e.1616136308.git.kai.huang@intel.com>
 <20210405090759.GB19485@zn.tnic>
 <20210406094421.4fdfbb6c4c11e7ee64c3b0a3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210406094421.4fdfbb6c4c11e7ee64c3b0a3@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 09:44:21AM +1200, Kai Huang wrote:
> The intention was to catch KVM bug, since KVM is the only caller, and in current
> implementation KVM won't call this function if @secs is not a valid userspace
> pointer. But yes we can also return here, but in this case an exception number
> must also be specified to *trapnr so that KVM can inject to guest. It's not that
> straightforward to decide which exception should we inject, but I think #GP
> should be OK. Please see below.

Why should you inject anything in that case?

AFAICT, you can handle the return value in __handle_encls_ecreate() and
inject only when the return value is EFAULT. If it is another negative
error value, you pass it back up to its caller, handle_encls_ecreate()
which returns other error values like -ENOMEM too. Which means, its
callchain can stomach negative values just fine.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
