Return-Path: <kvm+bounces-20586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37727919E2F
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 06:33:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1B5D285D55
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 04:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE381BC58;
	Thu, 27 Jun 2024 04:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MUmvprrI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98C51BF24;
	Thu, 27 Jun 2024 04:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719462784; cv=none; b=b8FMREU9/yHdL9AmbocrAPua4h1LZDm8c6pBqKR7JkS5UuOS/NKpPRHAAvaMtTZUDsJV9UU6zDKFt9kQ2HRwzQNqJep94xfWY4mpJmhaRGIX2xdVo59aJ+KDB2L5T6X52tXErZIOIvJSIk9KgbGena4qzPXwrTurxtT8jy2cyQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719462784; c=relaxed/simple;
	bh=WD7ygdR68fxGerBxzAyZ9F2yuKfXe8eASuhKeQ3vInM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhQrN47CpsCP70uUCU3AR7TdS48oaeJq9lLAyZLkuekMcfzUBuy8ZE2Em0QtaPtMFeT1tYPos0jl7QqSzjfaFA8wpTQKuVvVmoJB/vDvtDuSYzpwnTt3Ej7QZ6qPC85s/0eZsimdVzg6TpKS1jtHXZcqj4JjSvYp7hsRQBYBzWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MUmvprrI; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6fa11ac8695so4436038a34.3;
        Wed, 26 Jun 2024 21:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719462782; x=1720067582; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jlc5LgsXr7L99X3k84Y8N6qLtAVEf7V0a7Hh7lgRJ00=;
        b=MUmvprrIfp0qA4vs0vHoJT0QAyd9Vd9d3ujfXTlhUevmI1gLrUaPDq28DsYaBQI+YB
         ugA4X3FjU8eTKMJFpaWWgheeFzfLkpqTPtRGsG3qGqskTzENBjGvBvmozQYyxWL2wQrl
         fM4++VheDiMZ9thvaKpRq+8bwRb9zeFuwGUAe1mmuaIPvjatm5VIIIqRw7BFUWCYB+xQ
         66KdxMuivluwddYw01W8mLCm2kBysY003MgV7TDKQADKl30RgfAcax7xhPajer752Hg2
         JIMa1qiba75meYhBoQOS4zHq0ovbebk5R/jeBQtbvLFMC08+ExZxAGy9m8cqTTpD3l6t
         lodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719462782; x=1720067582;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jlc5LgsXr7L99X3k84Y8N6qLtAVEf7V0a7Hh7lgRJ00=;
        b=nuPp/1SGqCrGFfexTPaxuIPH11NzVvEHdPIjWUpjFC+o0DJ03g+QrCAuVROuEvES0m
         r0Bu3TLUZfxKgvEWOxaasEjpbhUJzQCtBR3a0RnYZcrQbMqRqHcfhgAdpk+EFyK9fEAK
         AtfbZdHwLCHaHmwyzpSnnFvi7gki+Cc2+s4t/AVVE+rjVIAM7r7LLnp/1wYDBg4NB6Ii
         8md4fKn9z4YSavd7xz2+Eex17+61kLgFZxj1xMx9P54pr+mBcxrXQc/JzZAi7MN61Gft
         YvEGXgrnhNZCw8VExWmG6sStIZ79S5INv9ysr8hwoCpbeeGSaUK5f0lrMVyYHeLci/gv
         zJtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPTVbmiCYtpxgARrCRikUbM7OnJ7NJE70vQSmneTsyWyobxkNN6YSi7uORnupYf3O9XiYJQsvNvp4J17XDOI8AIhCmX9eCt2yz2q1nCnEhDcYPztyAymJuxeAGeR/H4ORG
X-Gm-Message-State: AOJu0YzOus7Lm6MFJZ0zjK+zyGN33ylnn5xxEVbJRNyMgvx79xwXFMBM
	0/kX62YeKKzvd7hBxwi4Socu42ZD2Yk2vBoxHALYl6ulXyzq9F3l
X-Google-Smtp-Source: AGHT+IH+fV5+BoybY7N3LWHXzO46q6X8FmrZYM08XafaolZE1UQamSNMo9xYPVyx0z78L6CPS1aW7w==
X-Received: by 2002:a05:6830:1449:b0:6f9:9540:76a8 with SMTP id 46e09a7af769-700b11f0eedmr14010345a34.13.1719462781861;
        Wed, 26 Jun 2024 21:33:01 -0700 (PDT)
Received: from ubuntu-linux-22-04-02-desktop (107-197-105-120.lightspeed.sntcca.sbcglobal.net. [107.197.105.120])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-701efc09e51sm157847a34.18.2024.06.26.21.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 21:33:01 -0700 (PDT)
Date: Wed, 26 Jun 2024 21:32:58 -0700
From: Pei Li <peili.dev@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linuxfoundation.org,
	syzkaller-bugs@googlegroups.com, llvm@lists.linux.dev,
	syzbot+fd555292a1da3180fc82@syzkaller.appspotmail.com
Subject: Re: [PATCH] kvm: Fix warning in__kvm_gpc_refresh
Message-ID: <ZnzrekGQc24r0Gny@ubuntu-linux-22-04-02-desktop>
References: <20240625-bug5-v1-1-e072ed5fce85@gmail.com>
 <Znx1T_hHNA_uThf2@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Znx1T_hHNA_uThf2@google.com>

On Wed, Jun 26, 2024 at 01:08:47PM -0700, Sean Christopherson wrote:
> On Tue, Jun 25, 2024, Pei Li wrote:
> > Check for invalid hva address stored in data before calling
> > kvm_gpc_activate_hva() instead of only compare with 0.
> > 
> > Reported-by: syzbot+fd555292a1da3180fc82@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=fd555292a1da3180fc82
> > Tested-by: syzbot+fd555292a1da3180fc82@syzkaller.appspotmail.com
> > Signed-off-by: Pei Li <peili.dev@gmail.com>
> > ---
> > Syzbot reports a warning message in __kvm_gpc_refresh(). This warning
> > requires at least one of gpa and uhva to be valid.
> > WARNING: CPU: 0 PID: 5090 at arch/x86/kvm/../../../virt/kvm/pfncache.c:259 __kvm_gpc_refresh+0xf17/0x1090 arch/x86/kvm/../../../virt/kvm/pfncache.c:259
> > 
> > We are calling it from kvm_gpc_activate_hva(). This function always calls
> > __kvm_gpc_activate() with INVALID_GPA. Thus, uhva must be valid to
> > disable this warning.
> > 
> > This patch checks for invalid hva address as well instead of only
> > comparing hva with 0 before calling kvm_gpc_activate_hva()
> > 
> > syzbot has tested the proposed patch and the reproducer did not trigger
> > any issue.
> > 
> > Tested on:
> > 
> > commit:         55027e68 Merge tag 'input-for-v6.10-rc5' of git://git...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16ea803a980000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=e40800950091403a
> > dashboard link: https://syzkaller.appspot.com/bug?extid=fd555292a1da3180fc82
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > patch:          https://syzkaller.appspot.com/x/patch.diff?x=16eeb53e980000
> > 
> > Note: testing is done by a robot and is best-effort only.
> > ---
> >  arch/x86/kvm/xen.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > index f65b35a05d91..de5f34492405 100644
> > --- a/arch/x86/kvm/xen.c
> > +++ b/arch/x86/kvm/xen.c
> > @@ -881,7 +881,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
> >  			r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_info_cache,
> >  					     data->u.gpa, sizeof(struct vcpu_info));
> >  		} else {
> > -			if (data->u.hva == 0) {
> > +			if (data->u.hva == 0 || kvm_is_error_hva(data->u.hva)) {
> >  				kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_info_cache);
> >  				r = 0;
> >  				break;
> 
> Hmm, I think what we want is to return -EINVAL in this case, not deactivate the
> region.   I could have sworn KVM does that.  Gah, I caught
> KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA during review, but missed this one.  So to fix
> this immediate bug, and avoid similar issues in the future, this?
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 93814d3850eb..622fe24da910 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -741,7 +741,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>                 } else {
>                         void __user * hva = u64_to_user_ptr(data->u.shared_info.hva);
>  
> -                       if (!PAGE_ALIGNED(hva) || !access_ok(hva, PAGE_SIZE)) {
> +                       if (!PAGE_ALIGNED(hva)) {
>                                 r = -EINVAL;
>                         } else if (!hva) {
>                                 kvm_gpc_deactivate(&kvm->arch.xen.shinfo_cache);
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 0ab90f45db37..728d2c1b488a 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -438,6 +438,9 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
>  
>  int kvm_gpc_activate_hva(struct gfn_to_pfn_cache *gpc, unsigned long uhva, unsigned long len)
>  {
> +       if (!access_ok((void __user *)uhva, len))
> +               return -EINVAL;
> +
>         return __kvm_gpc_activate(gpc, INVALID_GPA, uhva, len);
>  }
> 
Thanks Sean. I’ll test and work on v2 based on your suggestions.

Best regards,

Pei


