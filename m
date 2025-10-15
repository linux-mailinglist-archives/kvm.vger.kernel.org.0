Return-Path: <kvm+bounces-60094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6873FBE001F
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 20:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 238AC4E5024
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 18:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30DD3301472;
	Wed, 15 Oct 2025 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zhjw+6l1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A5734BA42
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760551793; cv=none; b=q/wR0TyQevzME5i0GmncX+ASQH0BbCkqr+9EFvcuQsG+1q4cVgj1LG3simZYbQiEwec1zEc7CrtUDTY7p0FbvPp7mZ1yQYZf+q+wi9hu4yBzzv2FxMQHLjsGTJesjWoI/KueyJL/6zS5+joi8G9hW/dsLSY50DiMonpopXwMZYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760551793; c=relaxed/simple;
	bh=5G6xDAhFH1AxSP7lDNMOG9A1FxSEBhHl8BnZzEQDZEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e9XLu90LaoA/wkvYMRj9OMbv4KP3hfWWBdnBNPrbUP/EhNGfjJVD0b/Bbo23OBSrE8Q0XegtmWQcoovlSLfbbSbMlOuk+AuHyxemN5+8uIgKBaF8G1s50+9iHtCN4YLJeftXiZt76k1X6imQYl4dXTt9WvAn2syjqbG8QXLx0+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zhjw+6l1; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7811e063dceso9808716b3a.2
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 11:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760551791; x=1761156591; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/BBZAV7j+GFJDsPwRiVv1D95p+t7S8aVLW4yZ4s5Ojg=;
        b=Zhjw+6l1CtWKV630hmmKg/UIty8EvHHv2tc5HsaMcSlf6ah2CXnkGa9wsn/H+wK4Id
         JMdtRwOnf0KJGHUlo/QEB6XA7u633yMHhMOj2AZaiw76v6SUghiUIap376PIZ+imgHJf
         1ciPOn1eAPkTeJSUcN85jcEblfNVBAZiNhe0hH0ERtkd6mYyax/GVhWOBxImepkg68Jm
         sCgFmdTLBWLHXFpZgnXzR6Fz9kzmSWS9L0X/GjUWeUg3hKlizVaArK3X86k9mLTAxS0H
         1TegSeoAyc5qFQSXF0xAv/Z9YZ/LFtXTMkpQeRGEy8BP0fp54ZSElMCWcuuNgQ75Nh78
         XQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760551791; x=1761156591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/BBZAV7j+GFJDsPwRiVv1D95p+t7S8aVLW4yZ4s5Ojg=;
        b=PZccQ/WzQDqLSsT9BCNnKg8UhPNGAUycAlDnh/7dYOz3h4R08KdnCIGZTVhEtTgKw+
         4H3b0QxCADDRcYdh6rCV+mem3cCoy240v6VMiZy7omtpNHL0HNShVJaMnqdUuIc+f5yW
         Q3ZyfpOVAApasrXJjJdT6sduj0Xu0a39fuH+UtOAdclya76/EJdx6D261lZkBEyWAiKc
         FIUXYasVoRwvCO3IhwRFA/4AEfcGE28Ogj8fWQRzui0gmJ5TR2yqh8q+HC1aAXTp54kZ
         pHK4UVjGMm9wkdqJwOsApumjELbj6zYot+dnYBT94A1lf/UHM8koM23nav/1UsxIsyOv
         GWoA==
X-Gm-Message-State: AOJu0YwSdmJhUzNtWnm3tLW5RoeAcoBe6Y0/pWRZN163gWs2MTOqZ5wq
	cygZ7zFWhouk1Z8naTfaVt8bGz/nfakyxn07f+Vk8BXgmQa3eO/NlHxm5/BU3I2FmAM58URYMZN
	QNrSGsA==
X-Google-Smtp-Source: AGHT+IEVBqMd8BR36sPa9T+x8P6NqfIxNzMog2AuHoV3bAHdWnsbVuEcYRmkXJ9aUZJpynYhCzcjtMqxO3k=
X-Received: from pjbbr8.prod.google.com ([2002:a17:90b:f08:b0:33b:51fe:1a92])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a29:b0:304:4f7c:df90
 with SMTP id adf61e73a8af0-32da845fb34mr38836942637.50.1760551791139; Wed, 15
 Oct 2025 11:09:51 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:02:56 -0700
In-Reply-To: <20250916213129.2535597-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250916213129.2535597-2-thorsten.blum@linux.dev>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <176055123341.1529540.17733052766097672792.b4-ty@google.com>
Subject: Re: [PATCH] KVM: TDX: Replace kmalloc + copy_from_user with
 memdup_user in tdx_td_init
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thorsten Blum <thorsten.blum@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Tue, 16 Sep 2025 23:31:29 +0200, Thorsten Blum wrote:
> Use get_user() to retrieve the number of entries instead of allocating
> memory for 'init_vm' with the maximum size, copying 'cmd->data' to it,
> only to then read the actual entry count 'cpuid.nent' from the copy.
> 
> Return -E2BIG early if 'nr_user_entries' exceeds KVM_MAX_CPUID_ENTRIES.
> 
> Use memdup_user() to allocate just enough memory to fit all entries and
> to copy 'cmd->data' from userspace. Use struct_size() instead of
> manually calculating the number of bytes to allocate and copy.
> 
> [...]

Applied to kvm-x86 vmx, with the aforementioned tweaks.  Thanks!

[1/1] KVM: TDX: Replace kmalloc + copy_from_user with memdup_user in tdx_td_init
      https://github.com/kvm-x86/linux/commit/0bd0a4a1428b

--
https://github.com/kvm-x86/linux/tree/next

