Return-Path: <kvm+bounces-25195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC126961747
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 20:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2DAF283C97
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 18:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A3E1D2F59;
	Tue, 27 Aug 2024 18:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z+gtvOJ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8906E1C4623
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 18:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784768; cv=none; b=BSNZUL7nGc12H+IpM29xm7wDO3wA3Ne82V8QKPiHKveqUqlQIkOf/8GSGrYdORjpjgrilT/AvsJyYdq1+bIKmiE1swkSpg4fkcDHqtZpHAr66Km3fmB0PGRhJZtdPzDTgu2K8ZjRKvtlnHgnZpyOoMwOlfPauQHw7fN/hV1AC+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784768; c=relaxed/simple;
	bh=xVV9GYhTkMlzHWpiC/bq4VAS7CWyf8PnusQxbzgds7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aB7ApEgwBu4DNvRLihgpsNISNUn+h525aGm9rKOi79GIg4iXzORS1BgvihlJc6Od8wFsd1eyxjlEzjgrR3vVsCQEX6wZj6/ZdoRCFFZsplouQiifwflu9QFCy9f/jlmWasIo+hHY+c+aUUS/ZpvYye8GSD271/wV5nQUHrzIRzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z+gtvOJ0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ad26d5b061so104322687b3.2
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 11:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724784765; x=1725389565; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0qOq6giNTthe/vHgL7jh4v/W5dWk9cHPxYF82wHoE5I=;
        b=z+gtvOJ0p2ZKoZISR8IR+D9mkRjaO6lM7dudT33pg1V303QOeRmvT/Xv4eHkbdLbAh
         crMDIwttZ+K1U5pOwGx5a9KwqQepL7GyamIOnsUiN+95NY6LmB5Jb3keZeV+rMJKuWv+
         NNRsH0Gsq75kJpycmS6RRFyMW130Y5iBa3RuCj2V6lw0vGcPTHRf42Y9yu3IHmUlCATS
         XGZrN6bEYBzEMcASjiOuq0Un4NeWIEt5nNahvVHb6Qy+Cs8LMlOMStnggmicQ7AQmhU0
         qGoSI8Bwj449ZPNwHdKK2pE/Pu6iDtpK4/21BMZ0302LopeTljRAtjaLSG4K8bTDcGBo
         7Zvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724784765; x=1725389565;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0qOq6giNTthe/vHgL7jh4v/W5dWk9cHPxYF82wHoE5I=;
        b=pLAHgt3Lr59ocNB30hgQV9lrcRNldlGaOTOnwRWs+q9ZI2fdsQEG+AFfK3vtAW82G0
         0FYaIIaksvDDYuUI304hNhdopbijvqBeyI3dDfvRFn6pfbxtbt7HjuhsHIWWvToVPpPG
         Xn1g48rc62xvzFQlLiReYCCtqk4bHFRF1Gq3I7fvOOs+wp8W/ejrDnxIaCBkzeUtewnR
         0869kOkW/xUpuaJeGVIZLxuxehdUbNcjg2/46nB8ymq96IAhyLFfEZvUsErf/zo/rRaK
         8bNtuX4S3jBO1boc11KkhoGqgQYrE5zV4S4GEGW90nJ6g9kKsoV1WBxgCCLK1GJOBpvH
         w7fQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL6iVKo5KW5E1F+fZiUlDHm3KPoreYovWWD3gmichFINYRivJHCRiUpfvsbGEKWqW/Ssw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaUgX7pZo/7rirR8hz2N3ENNro2etgDPYlfIPazrdWlfnox5RE
	XjjEpef/QDR0mEdeTbAXZ+o1D+7LFuoM/8i5VQxRPjk7QwmJ/13SkOa9FuRcwxegJzkBBy+QtkN
	jwg==
X-Google-Smtp-Source: AGHT+IHNrLc33ieWWd9lzB1MKJLDyAAk3DCw6aLfcazPx/Bis1ZADTxM0+P1k3xYxg9qRJbX1JBtXUP4GyI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:86cd:0:b0:e0b:ab63:b9c8 with SMTP id
 3f1490d57ef6-e17a865a104mr26901276.11.1724784765414; Tue, 27 Aug 2024
 11:52:45 -0700 (PDT)
Date: Tue, 27 Aug 2024 11:52:43 -0700
In-Reply-To: <2024082759-theatrics-sulk-85f2@gregkh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZsSiQkQVSz0DarYC@google.com> <20240826221336.14023-1-david.hunter.linux@gmail.com>
 <20240826221336.14023-3-david.hunter.linux@gmail.com> <2024082759-theatrics-sulk-85f2@gregkh>
Message-ID: <Zs4ge62HmNkF4TGG@google.com>
Subject: Re: [PATCH 6.1.y 2/2 V2] KVM: x86: Fix lapic timer interrupt lost
 after loading a snapshot.
From: Sean Christopherson <seanjc@google.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Hunter <david.hunter.linux@gmail.com>, dave.hansen@linux.intel.com, 
	hpa@zytor.com, javier.carrasco.cruz@gmail.com, jmattson@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lirongqing@baidu.com, 
	pbonzini@redhat.com, pshier@google.com, shuah@kernel.org, 
	stable@vger.kernel.org, x86@kernel.org, Haitao Shan <hshan@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 27, 2024, Greg KH wrote:
> On Mon, Aug 26, 2024 at 06:13:36PM -0400, David Hunter wrote:
> > 
> > [ Upstream Commit 9cfec6d097c607e36199cf0cfbb8cf5acbd8e9b2]
> 
> This is already in the 6.1.66 release, so do you want it applied again?
> 
> > From: Haitao Shan <hshan@google.com>
> > Date:   Tue Sep 12 16:55:45 2023 -0700 
> > 
> > When running android emulator (which is based on QEMU 2.12) on
> > certain Intel hosts with kernel version 6.3-rc1 or above, guest
> > will freeze after loading a snapshot. This is almost 100%
> > reproducible. By default, the android emulator will use snapshot
> > to speed up the next launching of the same android guest. So
> > this breaks the android emulator badly.
> > 
> > I tested QEMU 8.0.4 from Debian 12 with an Ubuntu 22.04 guest by
> > running command "loadvm" after "savevm". The same issue is
> > observed. At the same time, none of our AMD platforms is impacted.
> > More experiments show that loading the KVM module with
> > "enable_apicv=false" can workaround it.
> > 
> > The issue started to show up after commit 8e6ed96cdd50 ("KVM: x86:
> > fire timer when it is migrated and expired, and in oneshot mode").
> > However, as is pointed out by Sean Christopherson, it is introduced
> > by commit 967235d32032 ("KVM: vmx: clear pending interrupts on
> > KVM_SET_LAPIC"). commit 8e6ed96cdd50 ("KVM: x86: fire timer when
> > it is migrated and expired, and in oneshot mode") just makes it
> > easier to hit the issue.
> > 
> > Having both commits, the oneshot lapic timer gets fired immediately
> > inside the KVM_SET_LAPIC call when loading the snapshot. On Intel
> > platforms with APIC virtualization and posted interrupt processing,
> > this eventually leads to setting the corresponding PIR bit. However,
> > the whole PIR bits get cleared later in the same KVM_SET_LAPIC call
> > by apicv_post_state_restore. This leads to timer interrupt lost.
> > 
> > The fix is to move vmx_apicv_post_state_restore to the beginning of
> > the KVM_SET_LAPIC call and rename to vmx_apicv_pre_state_restore.
> > What vmx_apicv_post_state_restore does is actually clearing any
> > former apicv state and this behavior is more suitable to carry out
> > in the beginning.
> > 
> > Fixes: 967235d32032 ("KVM: vmx: clear pending interrupts on KVM_SET_LAPIC")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Haitao Shan <hshan@google.com>
> > Link: https://lore.kernel.org/r/20230913000215.478387-1-hshan@google.com
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> > (Cherry-Picked from commit 9cfec6d097c607e36199cf0cfbb8cf5acbd8e9b2)
> > Signed-off-by: David Hunter <david.hunter.linux@gmail.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 87abf4eebf8a..4040075bbd5a 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -8203,6 +8203,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
> >  	.load_eoi_exitmap = vmx_load_eoi_exitmap,
> >  	.apicv_pre_state_restore = vmx_apicv_pre_state_restore,
> >  	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
> > +	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
> >  	.hwapic_irr_update = vmx_hwapic_irr_update,
> >  	.hwapic_isr_update = vmx_hwapic_isr_update,
> >  	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
> 
> Wait, this is just one hunk?  This feels wrong, you didn't say why you
> modfied this from the original commit, or backport, what was wrong with
> that?

Gah, my bad.  I told David[*] that this needed to be paired with patch 1 to avoid
creating a regression in 6.1.y, without realizing this commit had already landed
in 6.1.y.

So yeah, please ignore this patch.

[*] https://lore.kernel.org/all/ZsSiQkQVSz0DarYC@google.com

