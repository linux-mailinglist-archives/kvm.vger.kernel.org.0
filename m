Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902F2431A33
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhJRNAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 09:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbhJRNAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 09:00:44 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA26C06161C;
        Mon, 18 Oct 2021 05:58:33 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0857009e2a46238f1e0c2c.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5700:9e2a:4623:8f1e:c2c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E09091EC0531;
        Mon, 18 Oct 2021 14:58:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634561910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0KOtknF3ECN+V02QJJCZtd163YJECd5/PzvzH7uNuBY=;
        b=Rcn+bfDdgiSuxAqClaywRmmRqID5Zh4+mpFnNnG6va7xq1517HOLQ5wm7MSf671lXwaE33
        VcDw5IZY4D8LP9Zd8nO7HbD7g9apjlBMe/meJdh4US/rZ6hDBIauzVOO/rHJXA8Uk28HYf
        53JYN6P6xF4nPGWHXuuQMMRdYVuDFME=
Date:   Mon, 18 Oct 2021 14:58:29 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     seanjc@google.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dave.hansen@linux.intel.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org
Subject: Re: [PATCH v3 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
Message-ID: <YW1vdbfzv7xlBCQF@zn.tnic>
References: <20211016071434.167591-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211016071434.167591-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 16, 2021 at 03:14:32AM -0400, Paolo Bonzini wrote:
> Add to /dev/sgx_vepc a ioctl that brings vEPC pages back to uninitialized
> state with EREMOVE.  This is useful in order to match the expectations
> of guests after reboot, and to match the behavior of real hardware.
> 
> The ioctl is a cleaner alternative to closing and reopening the
> /dev/sgx_vepc device; reopening /dev/sgx_vepc could be problematic in
> case userspace has sandboxed itself since the time it first opened the
> device, and has thus lost permissions to do so.
> 
> If possible, I would like these patches to be included in 5.15 through
> either the x86 or the KVM tree.
> 
> Thanks,
> 
> Paolo
> 
> Changes from RFC:
> - improved commit messages, added documentation
> - renamed ioctl from SGX_IOC_VEPC_REMOVE to SGX_IOC_VEPC_REMOVE_ALL
> 
> Change from v1:
> - fixed documentation and code to cover SGX_ENCLAVE_ACT errors
> - removed Tested-by since the code is quite different now
> 
> Changes from v2:
> - return EBUSY also if EREMOVE causes a general protection fault
> 
> Paolo Bonzini (2):
>   x86: sgx_vepc: extract sgx_vepc_remove_page
>   x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE_ALL ioctl
> 
>  Documentation/x86/sgx.rst       | 35 +++++++++++++++++++++
>  arch/x86/include/uapi/asm/sgx.h |  2 ++
>  arch/x86/kernel/cpu/sgx/virt.c  | 63 ++++++++++++++++++++++++++++++---
>  3 files changed, 95 insertions(+), 5 deletions(-)

Sean,

are you happy with that version now?

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
