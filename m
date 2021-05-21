Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5E638C945
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 16:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhEUOgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 10:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbhEUOgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 10:36:06 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401F5C061574;
        Fri, 21 May 2021 07:34:43 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ea400b1711cbbd717391b.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:a400:b171:1cbb:d717:391b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 394031EC061D;
        Fri, 21 May 2021 16:34:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621607681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+eiP6mVRfierNZHVHWE39OmfVBD4FccBazbJrnrFRg0=;
        b=ROd1grQ3afwj6jw9TXiBn8Gd9qql4j0xLcF+A4Lqj4zbmGPwP2BmwMNSG9cy7VgQRH6Y1i
        q7L03gy8DOnoLw9UiHZ6w+3+1IRtJ3DdPWKaZRMMCu9EkiRcmi3F0YGbVRbTLJm25OqlWG
        Wz3z6tI68a+fpsHb7fn5HUCNVbQJv6Y=
Date:   Fri, 21 May 2021 16:34:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>,
        Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
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
Subject: Re: [PATCH v2 7/8] x86/insn: Extend error reporting from
 insn_fetch_from_user[_inatomic]()
Message-ID: <YKfE+gfK5AdE9ckm@zn.tnic>
References: <20210519135251.30093-1-joro@8bytes.org>
 <20210519135251.30093-8-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210519135251.30093-8-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 03:52:50PM +0200, Joerg Roedel wrote:
> diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
> index 4eecb9c7c6a0..d8a057ba0895 100644
> --- a/arch/x86/lib/insn-eval.c
> +++ b/arch/x86/lib/insn-eval.c
> @@ -1442,27 +1442,36 @@ static int insn_get_effective_ip(struct pt_regs *regs, unsigned long *ip)
>   * insn_fetch_from_user() - Copy instruction bytes from user-space memory
>   * @regs:	Structure with register values as seen when entering kernel mode
>   * @buf:	Array to store the fetched instruction
> + * @copied:	Pointer to an int where the number of copied instruction bytes
> + *		is stored. Can be NULL.
>   *
>   * Gets the linear address of the instruction and copies the instruction bytes
>   * to the buf.
>   *
>   * Returns:
>   *
> - * Number of instruction bytes copied.
> + * -EINVAL if the linear address of the instruction could not be calculated
> + * -EFAULT if nothing was copied
> + *       0 on success
>   *
> - * 0 if nothing was copied.
>   */
> -int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
> +int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE],
> +			 int *copied)
>  {
>  	unsigned long ip;
>  	int not_copied;
> +	int bytes;
>  
>  	if (insn_get_effective_ip(regs, &ip))
> -		return 0;
> +		return -EINVAL;
>  
>  	not_copied = copy_from_user(buf, (void __user *)ip, MAX_INSN_SIZE);
>  
> -	return MAX_INSN_SIZE - not_copied;
> +	bytes = MAX_INSN_SIZE - not_copied;
> +	if (copied)
> +		*copied = bytes;
> +
> +	return bytes ? 0 : -EFAULT;

Why not simpler?

return value >= 0 says how many bytes were copied
return value < 0 means some kind of error

And then you don't need @copied...

Ditto for the other one.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
