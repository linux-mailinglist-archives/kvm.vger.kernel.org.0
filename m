Return-Path: <kvm+bounces-20675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65B2991C0CD
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 16:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 195F91F21B4B
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 14:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718AB1C004A;
	Fri, 28 Jun 2024 14:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="awk/kFsL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DDB1E517;
	Fri, 28 Jun 2024 14:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719584721; cv=none; b=I8DN+QH+Ctn18qg081l5O3AgJygCIdR5Jln4JhUyFLo9bpwtdzWWq5AAFDOivMCjpmMgKsLJzcRAZFqHwWFoBHiNJun9QO23owbof07osQVoTt8a3DGIdTIhWVpRvgCMO0CsKphbujcFu6IwbGFCD0ncfK4pHSB1D9XF5cXKbYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719584721; c=relaxed/simple;
	bh=Zo4QNEftC90ngAD8RC20T2f2OvX59Lz7ga6iZJ6sNfw=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=EtSX2IvLRL9+ZboaHTD2upVSTX2aw1hOlGkhGwJUFUYt5ujmZu0q2N9b7vysjYS0ZrSsPe02e2j0LUkCEYhVyMOtF4ENqiz+f24eFmyuszoCGvvoZSHwX1C0zSE8n47w1wqfqL6kI15d1Ot8b5R4SymPopUOO0ksVM0mMTbmjyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=awk/kFsL; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3658197cdbbso376302f8f.3;
        Fri, 28 Jun 2024 07:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719584718; x=1720189518; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VeAwXuF7+pmymrZyPiqRkGCZGiMSVwcLFpTO8NXP0nk=;
        b=awk/kFsLrOSJVUBDtOgzLw0qJbtYnItfQxbteZe1VFEFpFMBv26+vdaISis2q5ZMhU
         f/b5uvyvOMcA1+KX8YIglrL0TSfkuGc+ugPzer3ALo/7lh7I2YW49Z8eHALjpTkroob0
         paG5OGOS9AK0xeEfAfxw0nEOiHDTUAXE/0eBDcF+I3G7auf4tQx5XIgf/10sAyrEkThv
         cIptU7x/mJmOF03EN7vLdDrr5f1C4BwzWuxR+9ldtZbr9K63rq50OA/b4pIqXmUhMAVg
         9Yv595G4dsF2lozWtKEj8FyKDBb1m1Sddu6vHOOYRHRdjeD4+/Q2E3D4RE2SBt7dKA9I
         nxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719584718; x=1720189518;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VeAwXuF7+pmymrZyPiqRkGCZGiMSVwcLFpTO8NXP0nk=;
        b=qHUYQ7kqEa/PmW81WNZAzitBzicNrMY/ftSLFCKSF4RE3FhKYa0A3wX1VXb0/R5LFO
         XUGnsyzInJ9lVLqEHzdpUJs0P6ht1BfS0oGg5TcTMDTmr83MF5+TMMn4RtT283Vjm5v/
         U+Pvs56J0wePkQxiXTg6176d7LsIU+5OXJTwt5vKIHEjyp8U8U5iUUNbRC8RxMUzP9HH
         7yHp3iZO1D8N7CuHOBSpWUNHw18izXSk29b5prpl6EHdqKoiggbYXFLj59rCJ9XfZI3N
         SLGANjNoMkN1vXgcPg42o+gO4SMdlqLsY/9Sp6o6F3n4D1mSw4why2W3tiC2TjgKLx8C
         5rJA==
X-Forwarded-Encrypted: i=1; AJvYcCXH40/hmMZIJR1stl8cGEWK4iEml6c8aaZ8fDDa6xzGT0zX8H4RJu7fddfJ2JpSq7Xqkak1emg5/G3joZ/96aij9REq3RVtM71TfLS0
X-Gm-Message-State: AOJu0Yyr00kFylvdrT2ckfbZv+UeT197vMWW6pvtdaeSwbl95l2GIuM7
	DFTIkqhSqEbjRH8YcsueiYCIMcq9EXN+wfoH94vqs/CkICmvbznf
X-Google-Smtp-Source: AGHT+IFTYNRmuabn1FZnyKG4Uik1w/ofEuzazYAzcKR3V8UFSfbfjagdPNoyM0oNWquKxkwJrJckjg==
X-Received: by 2002:adf:f782:0:b0:35f:2725:7ae2 with SMTP id ffacd0b85a97d-366e9628e80mr11865862f8f.57.1719584718199;
        Fri, 28 Jun 2024 07:25:18 -0700 (PDT)
Received: from [10.95.168.202] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3675a0d8d9fsm2458985f8f.26.2024.06.28.07.25.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jun 2024 07:25:17 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <4e25df0e-000c-4af7-a34f-ba831623aab8@xen.org>
Date: Fri, 28 Jun 2024 15:25:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2] kvm: Fix warning in__kvm_gpc_refresh
To: Pei Li <peili.dev@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org,
 syzkaller-bugs@googlegroups.com, llvm@lists.linux.dev,
 syzbot+fd555292a1da3180fc82@syzkaller.appspotmail.com
References: <20240627-bug5-v2-1-2c63f7ee6739@gmail.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240627-bug5-v2-1-2c63f7ee6739@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/06/2024 16:03, Pei Li wrote:
> Check for invalid hva address stored in data and return -EINVAL before
> calling into __kvm_gpc_activate().
> 
> Reported-by: syzbot+fd555292a1da3180fc82@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=fd555292a1da3180fc82
> Tested-by: syzbot+fd555292a1da3180fc82@syzkaller.appspotmail.com
> Signed-off-by: Pei Li <peili.dev@gmail.com>
> ---
> Syzbot reports a warning message in __kvm_gpc_refresh(). This warning
> requires at least one of gpa and uhva to be valid.
> WARNING: CPU: 0 PID: 5090 at arch/x86/kvm/../../../virt/kvm/pfncache.c:259 __kvm_gpc_refresh+0xf17/0x1090 arch/x86/kvm/../../../virt/kvm/pfncache.c:259
> 
> We are calling it from kvm_gpc_activate_hva(). This function always calls
> __kvm_gpc_activate() with INVALID_GPA. Thus, uhva must be valid to
> disable this warning.
> 
> This patch checks for invalid hva address and return -EINVAL before
> calling __kvm_gpc_activate().
> 
> syzbot has tested the proposed patch and the reproducer did not trigger
> any issue.
> 
> Tested on:
> 
> commit:         afcd4813 Merge tag 'mm-hotfixes-stable-2024-06-26-17-2..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1427e301980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e40800950091403a
> dashboard link: https://syzkaller.appspot.com/bug?extid=fd555292a1da3180fc82
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=13838f3e980000
> 
> Note: testing is done by a robot and is best-effort only.
> ---
> Changes in v2:
> - Adapted Sean's suggestion to check for valid address before calling
>    into __kvm_gpc_activate().
> - Link to v1: https://lore.kernel.org/r/20240625-bug5-v1-1-e072ed5fce85@gmail.com
> ---
>   arch/x86/kvm/xen.c  | 2 +-
>   virt/kvm/pfncache.c | 3 +++
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

