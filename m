Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F24353ED8
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 12:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238331AbhDEJIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 05:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238508AbhDEJIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 05:08:12 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88EAC061756;
        Mon,  5 Apr 2021 02:07:57 -0700 (PDT)
Received: from zn.tnic (p200300ec2f079d00575c2839e9904d54.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:9d00:575c:2839:e990:4d54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 01DF91EC027A;
        Mon,  5 Apr 2021 11:07:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617613675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9FaM+pTn0a/StM07L4FU8W/nBEr5sFaDbMBmixEPXlk=;
        b=q6Azoplnt+A0z6GRSxhCHD5Pi2ycykwNnzqfyxUcujSaPb8+5skzGxcKIgCkfdKpdyc9ZG
        PjHb6QfQ6/afk4Y3xpdOdxoSbcmP9Rcrdnw62nXBvz1DCucvmSDlqEV+cRGKPzBoR5OCxV
        2KSNIsad7fDx3EdVBvMNNKSl8be0LzI=
Date:   Mon, 5 Apr 2021 11:07:59 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 13/25] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <20210405090759.GB19485@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <20e09daf559aa5e9e680a0b4b5fba940f1bad86e.1616136308.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20e09daf559aa5e9e680a0b4b5fba940f1bad86e.1616136308.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 08:23:08PM +1300, Kai Huang wrote:
> +	/*
> +	 * @secs is an untrusted, userspace-provided address.  It comes from
> +	 * KVM and is assumed to be a valid pointer which points somewhere in
> +	 * userspace.  This can fault and call SGX or other fault handlers when
> +	 * userspace mapping @secs doesn't exist.
> +	 *
> +	 * Add a WARN() to make sure @secs is already valid userspace pointer
> +	 * from caller (KVM), who should already have handled invalid pointer
> +	 * case (for instance, made by malicious guest).  All other checks,
> +	 * such as alignment of @secs, are deferred to ENCLS itself.
> +	 */
> +	WARN_ON_ONCE(!access_ok(secs, PAGE_SIZE));

So why do we continue here then? IOW:

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index fdfc21263a95..497b06fc6f7f 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -270,7 +270,7 @@ int __init sgx_vepc_init(void)
  *
  * Return:
  * - 0:		ECREATE was successful.
- * - -EFAULT:	ECREATE returned error.
+ * - <0:	ECREATE returned error.
  */
 int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
 		     int *trapnr)
@@ -288,7 +288,9 @@ int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
 	 * case (for instance, made by malicious guest).  All other checks,
 	 * such as alignment of @secs, are deferred to ENCLS itself.
 	 */
-	WARN_ON_ONCE(!access_ok(secs, PAGE_SIZE));
+	if (WARN_ON_ONCE(!access_ok(secs, PAGE_SIZE)))
+		return -EINVAL;
+
 	__uaccess_begin();
 	ret = __ecreate(pageinfo, (void *)secs);
 	__uaccess_end();

> +	__uaccess_begin();
> +	ret = __ecreate(pageinfo, (void *)secs);
> +	__uaccess_end();
> +
> +	if (encls_faulted(ret)) {
> +		*trapnr = ENCLS_TRAPNR(ret);
> +		return -EFAULT;
> +	}
> +
> +	/* ECREATE doesn't return an error code, it faults or succeeds. */
> +	WARN_ON_ONCE(ret);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(sgx_virt_ecreate);
> +
> +static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
> +			    void __user *secs)
> +{
> +	int ret;
> +
> +	/*
> +	 * Make sure all userspace pointers from caller (KVM) are valid.
> +	 * All other checks deferred to ENCLS itself.  Also see comment
> +	 * for @secs in sgx_virt_ecreate().
> +	 */
> +#define SGX_EINITTOKEN_SIZE	304
> +	WARN_ON_ONCE(!access_ok(sigstruct, sizeof(struct sgx_sigstruct)) ||
> +		     !access_ok(token, SGX_EINITTOKEN_SIZE) ||
> +		     !access_ok(secs, PAGE_SIZE));

Ditto.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
