Return-Path: <kvm+bounces-73238-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2OaoKXpfrWkf2AEAu9opvQ
	(envelope-from <kvm+bounces-73238-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 12:37:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 18ECB22F6FE
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 12:37:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3CDE3300F18E
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 11:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C307C314D08;
	Sun,  8 Mar 2026 11:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RTCRgCDa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kek4VTyK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827FB2BAF7
	for <kvm@vger.kernel.org>; Sun,  8 Mar 2026 11:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772969843; cv=pass; b=nokzgtRqZhkiza2M/0gHkPtpzDcUtXX3DKOJ9LK73in+LtmumsskrICzJyMNNaNJ1mn1x/7MLGI60xHbP8TVd8yxuLUWS68Ez8CNq9Xk5l2mBCfEPiVxugUVmUfWqYbc2UYl3Ue3FN7xCnj0zRhdRZsW8nP2f66dkfL98cKS0Lw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772969843; c=relaxed/simple;
	bh=Hg/m/L7X/2wFGDLmS+K66JhSEuDhU5LK5I5zXEx3pr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J+Zp6+ieHrW8WTN9r8ykRgu9pxHfNViPgsHguZ/pRWj7R0Im8cI4b2Wf0ph+Ncb5Pe40nxathGag5KAr6Ldq8o9Ei41+EDUWuXMBcO8fkqxjtGXqP3Dbb1oyCmoJwLKEwUNb6s8NRpTC4LLdgn/kz3uBWiKl0B+I/jRw0ZBGA54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RTCRgCDa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kek4VTyK; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772969840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RQxvjiWaZpfq136BgtJUGLwuAiTet43kLgxTqa3sdJ8=;
	b=RTCRgCDa1msknR7CN/Kp9z075TLwHvb9JZut688BZ1NEKYsneAxzpmVZuLJW2QkWODFXHE
	BYXSRPGvenSaI9cseDYbXO17hkzhi4IYqq6yKZaAIrv38+xN41tMlMjSmaxAv4gggDovfV
	AgytMhziD4sO07ZJEDori1JY1nHfmCw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-oFmharfLMB6KX-x8I6TVXw-1; Sun, 08 Mar 2026 07:37:18 -0400
X-MC-Unique: oFmharfLMB6KX-x8I6TVXw-1
X-Mimecast-MFC-AGG-ID: oFmharfLMB6KX-x8I6TVXw_1772969838
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-439cbfcfc21so4549921f8f.2
        for <kvm@vger.kernel.org>; Sun, 08 Mar 2026 04:37:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1772969837; cv=none;
        d=google.com; s=arc-20240605;
        b=TyUb2ANbDViJ28jnascYuvDGdsgu9/g19w/f+ZUK7M0IfgzkodgbWLXVzQ8RPeMxTz
         97ZDw0OzOI+NW0PJfDGu2tT2OJTQfmeXjEl8zbyJTe9R8TwW+f5QgKTr62FJCz+LR0xH
         Yyp+XHxunqkEuL9CpL7lSO4It34jawrMjHE4pCdm5ZE+53XYOWaa0lZYwqNuCIrfnh4W
         6HcszEco+mRZz0NWDyPFU2HP8j0qRuurkuHSezpy2hR9VynC40Yk2yKr84ugfUN5sPzi
         4tFIsMmWwqTuxmNwZ43VxHtQHXAz/6FvIXPG+va3LTW9o8pDi3EA4XTasjIk/Nf5AEQR
         scvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RQxvjiWaZpfq136BgtJUGLwuAiTet43kLgxTqa3sdJ8=;
        fh=6wlYl167uWjbfLK6ON1HXXx9+3Xm9uJhwzs/sv/nlGg=;
        b=RS8vmT08rXTYbme0vyvV14R7SbrL4H4EfID1x+Shyr7/rS18oin1WPzIXRSWNH01KF
         Q62gF47JTpjGurKLc02J3Isz8a2Z6PD3S12nnqwpLxibjtmMzD6pbgA7lehj7vwSebiu
         SFiVRJBf5iowSk/T0QOuY+nsaLkLAfjwLsiSqcrG6iefvo+bAePvcvlxvF7rCLcmL6nX
         2BfP+LirBRFDfMtRQrNGKTsYXth02s0SFjOTjg96n/zEpAAWDVqRAZQKDYPTsBcsB6o0
         vGgxdGFsFbzVY50dGNRLNz3N7i/Iw/RsiqzxoeFS7oZYYKaHY8+LpaSrYT4rgyF3Hoe6
         D/9Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772969837; x=1773574637; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RQxvjiWaZpfq136BgtJUGLwuAiTet43kLgxTqa3sdJ8=;
        b=Kek4VTyKUcDLfTd3m6hKmvJItfzmmwxM1H/5/lvm7OCzDUX7E8DmVfv9GVxKq2ZYZ7
         uiyLehZHIT7TJzXokAakBxKHvAB7YkBNaD0/efrOSEGbAu2793woz7xJbr8EBhrvu70/
         7VBKj2a/eIsNXUNizKiy2wU1Hsuy4bDYJSMpSl8Ua601cJChO10aTnSMBHrvwecO+ESs
         2IRM0vJjElaSWdOs9g4G1NiuhG44iP4+1ZM5IoyKLYsVWchpgM71sDVEpRPlIXVVzWKJ
         Ivx4geUX3UDd/OqmNWJ1thOopB4FCyHvCeAGkkRY2+snvPtWWTgzFpoz3u8KOJg6jRXz
         E8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772969837; x=1773574637;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQxvjiWaZpfq136BgtJUGLwuAiTet43kLgxTqa3sdJ8=;
        b=tz7K9TIY0MU6ykkmT/yTYggnq0SH3/GI5qAm/eMnvQd2V61NT5BCE5jhfOxYwEogeh
         mo7Yzov7zNuS6NwnVrMohHeusiTiaDPZPgZwJD1N3p8AdFFANCW4NO0xzsirWiWKZKGE
         Y5HXRmeHEcCcCnXznx0XUqNlBeujVxBJsxo8xTqjD6wasvTk1N3oQKYwvjF9FuSOuw40
         pyzjpwz43mHOdzU1zHw4KC2gKGa+hSyZvfy5DPR57E3K4zkm1dSj2QR32d6A9AFvqif6
         pFTmjGUPD5xR8jBZjGt8+ct178RNouUoUMcPzOWp5JkbWMs520EsaSD9quLpvmg0dYkQ
         XHsg==
X-Forwarded-Encrypted: i=1; AJvYcCUNKRt3qE/JQE07IqHXUQ9g6VHJ/riYM28rbveLvJ725MpEn+V1M4qDrpnPHK/JKnYSIR8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9yHDOJXQCQKtV4g2VH1RCvyjZCMh3se2vSwTK3N90Dpo4bQx4
	J5P9LigbzTYHzfmZb1af+sxa03pFpI8S6vKc1N+pN9weY4Mat2ONxTBiKDcuLjg2ZP5HLufncxf
	nK9MggDo6/prcAcuV4j0IZOBYYQGi7k659x86bDtR5Yh6TIEPWJI0W9NyozWciZpLbNFiFkBnvc
	jRvW66jnR1wZjGXYF2lTK32E6q7Ieu/tS2vkjl
X-Gm-Gg: ATEYQzxcrSRkBa4yOpbe9BPc4AMQySPGPYpxGJx9hwPWcNIjUF1INQNbCXgzGY+QCUF
	5DZoUX8lvDTHf52mndjnZHludXqz/GmlzFe/6m7RPGbYrVfa6y0pNlczaYaLaAf2kmHcBQvOMDD
	V6+c0q/rb+VGmOV9lm36BICRAAdfiARH/bwkU0p6XekEoqODXh4gOQNJGv4OtMP2cYcqga3S7Qj
	pUymmXd7g5fAUVIZ0dFAfzS9sDthMA/kkf5Amdd3i0+GUGkKWQGi+rQcPXbWwrvlZ/1EC8FdgAZ
	YfPmhn0=
X-Received: by 2002:a05:6000:2010:b0:439:d6ea:7cff with SMTP id ffacd0b85a97d-439da354a83mr15465649f8f.4.1772969837036;
        Sun, 08 Mar 2026 04:37:17 -0700 (PDT)
X-Received: by 2002:a05:6000:2010:b0:439:d6ea:7cff with SMTP id
 ffacd0b85a97d-439da354a83mr15465628f8f.4.1772969836567; Sun, 08 Mar 2026
 04:37:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHj+bcNm8nZdod6VxW_dQkXm1iqyNnQNyh4VONAT6npBGvv+Pw@mail.gmail.com>
In-Reply-To: <CAHj+bcNm8nZdod6VxW_dQkXm1iqyNnQNyh4VONAT6npBGvv+Pw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 8 Mar 2026 12:37:04 +0100
X-Gm-Features: AaiRm53YqKCNcoTNpdkjWzrwJudS39DT-imbLgb65H3q8b6CyFBjXr4yq3Ah-nA
Message-ID: <CABgObfZYaysmpwwAmJP7yOZ6T8OSFdw9VwpUczr9bTAw0tu7fA@mail.gmail.com>
Subject: Re: [SECURITY] KVM: nSVM: TOCTOU on uncached VMCB12 save-area fields
 in nested_vmcb02_prepare_save()
To: Natarajan KV <natarajankv91@gmail.com>
Cc: Security Officers <security@kernel.org>, kvm <kvm@vger.kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 18ECB22F6FE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-73238-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.954];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Il dom 8 mar 2026, 07:06 Natarajan KV <natarajankv91@gmail.com> ha scritto:
>
> Hi,
>
> Please find the details on the subject issue below.
> ---
>
> ## Summary
>
> The VMCB12 save-area caching introduced to mitigate CVE-2021-29657 is
> incomplete. `vmcb_save_area_cached` (svm.h:117-122) caches only 6 fields
> (efer, cr0, cr3, cr4, dr6, dr7), yet `nested_vmcb02_prepare_save()`
> (nested.c:539-631) reads at least 14 additional security-critical fields
> directly from the guest-mapped VMCB12 page. Since `kvm_vcpu_map()` pins the
> guest physical page but does not revoke write access, a concurrent L1 vCPU
> can modify these fields between validation and use, constituting a
> time-of-check to time-of-use (TOCTOU) vulnerability.
>
> This is a residual from the incomplete fix for CVE-2021-29657, which
> addressed only the control-area double-fetch. The save-area TOCTOU has no
> assigned CVE.

Leaving aside that the email was obviously created by AI, there is no
check on the save area fields so there's no TOC in the TOCTOU. The
code can be cleaned up (and Yosry's pending patches do that) but
that's it.

So this report is bogus, but I will leave a few notes below
nevertheless for everyone else that's reading.

> ### Double-Read on RIP/RSP/RAX (Lines 580-587)
>
> RAX, RSP, and RIP are each read twice from guest memory:
>
> ```c
> kvm_rax_write(vcpu, vmcb12->save.rax);    // L580: read #1
> kvm_rsp_write(vcpu, vmcb12->save.rsp);    // L581: read #1
> kvm_rip_write(vcpu, vmcb12->save.rip);    // L582: read #1
> vmcb02->save.rax = vmcb12->save.rax;      // L585: read #2
> vmcb02->save.rsp = vmcb12->save.rsp;      // L586: read #2
> vmcb02->save.rip = vmcb12->save.rip;      // L587: read #2
> ```
>
> If the racing vCPU modifies these between reads, `vcpu->arch.regs[]` and
> `vmcb02->save` will hold different values for the same register. When KVM's
> instruction emulator uses `kvm_rip_read()` (from `vcpu->arch.regs`), it
> will operate on a different instruction stream than what the hardware
> actually executes from `vmcb02->save.rip`.

This is the only part that can barely resemble a bug, but even then
it's just unclean code. The value in vcpu->arch.regs is refreshed from
the VMCB well within the GIF=0 area that holds the core guest switch
code, and the value is never read in the meantime.

> ### CPL Confusion
>
> The most impactful scenario. The attacker:
> 1. Prepares VMCB12 with valid CPL=3 and consistent ring-3 segments
> 2. vCPU-0 executes VMRUN; KVM caches the 6 save fields and validates
> 3. vCPU-1 writes `vmcb12->save.cpl = 0` during the race window
> 4. At nested.c:561, KVM copies the modified CPL=0 into vmcb02
>
> With forged CPL=0, `svm_get_cpl()` (svm.c:1804) returns 0 for L2.

This (and everything else) makes no sense. It's the same as if the
write happened before the VMRUN.

Paolo


