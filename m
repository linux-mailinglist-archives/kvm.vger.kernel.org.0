Return-Path: <kvm+bounces-63621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7BDC6C037
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:32:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 4670F2CE91
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2383326D75;
	Tue, 18 Nov 2025 23:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rrs2+v4i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A7931ED86
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508517; cv=none; b=RzWP9AkFNv0iKvtZJfgyG/X8WAmUTDk9TrmvpuvfrD4Rqb3NymAIbRdkoVavzV29YDSGjEtdpVAFUp5FdVwmP3ZQaSe0Y3YErT+eL3tZvke+bb2jG5Grvndmn5q2UtTm/26jlpAtnSLsYq3UndZ6CG62KU4nMJORIq35LD3DGU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508517; c=relaxed/simple;
	bh=5gCxM2Y0gj+MPF/RXaCyHLj5HN8gnnfSCAyarkw4HNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nMO/Q8qHrl15Dka0dunpqPh0Sc9iZjT+p6F8eIK+UNvtXdQ+zS6syFV4aOT6a/T1Gy7Ik3yEmJwq6V/23GPkgZLt+rlOdegqtHIuEbvaxvA6IxI0ZJ696YWgPrbYUXoNWFFov22EusW75SQYX3nc46HTK60L3UgonedpU4RvcJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rrs2+v4i; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2982dec5ccbso107491455ad.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763508515; x=1764113315; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=olNNTUm+BTLFO+ZiwDAf9pAOve+v0FNRwAZ4CxSj/MA=;
        b=rrs2+v4iHeP2xHBtR58eTEXSobBYZtMPWnI3ZO2be726mFM2AFY/s8YxXiYhpIIYEp
         Ii/QpgYhbmTcm4Zmd1d3Q62X456eIAnWKho59Ju0M3p5oJ3XR+a8wbe/6+hONC27UoKc
         WFi6w1iBLbKInG4bic49/xMr59Sa5Vk79HjNNvE0bhDV25QKz7UBsB7TTXNKE9Lr9eIf
         nIgUQ6gezovx+dhJOFRdo9GSGd4zCUI1tcnrXTHzEMeMgD/MNB20oXsyDPQrLIvF2h5K
         L1RHc6Hjv7wbbiXlGw3m1lXe5hbB4jLHx4CGJ1UqwNK7CyOHfQW+I46FKzwkV+892QTk
         PQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508515; x=1764113315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=olNNTUm+BTLFO+ZiwDAf9pAOve+v0FNRwAZ4CxSj/MA=;
        b=O8zT3f2dUieSpEY+io1ppTAAhf9BJWR+ZBHZkMMJWlq6Pt1yrfcHq8CZWXJSd24eq6
         GBzttY+w1apNW61DCW7TzAJ/pNHNTHaSohSM41NVwwRFJ9YOT+s9gL6rx7wRny+HCnok
         8zo609sFGYLT8RIT9Q1dYQ/xQnNiZ4892pk3CpkSuh75oniojeEqVtdLqSv1TfoVYeRw
         DnyalRu9MGxIwLQxJnG80uT91+czofVJVTGJw862p5EBUcUtMPkkLyQeI5b2lqNDlruM
         vYyfpHB0acSB2btIX2aOEuHzkgI81Yf96iLp9I4BC1uW12y6vvVmvVRZrwvd+W0mu9bD
         IFNw==
X-Gm-Message-State: AOJu0Yyh8qeFiY57cnKEeKx/TrRZsEmiCh/kOhMMleEW03ttOZzUCnM7
	HzEZYhhMSs4dn/hVkdsFiFQKll4SKX7C4CZ4xM/czcPlJ/3GgX2U2I0dNhpSUw9inLTIrhoEa2q
	wdA7UZw==
X-Google-Smtp-Source: AGHT+IGUP80RGTxVgmXIYbcLfL0s45FJBuzEh/YWaWtgI7M8kNRpd89qY03WQLaYk4SlG45sxcRSai97W0o=
X-Received: from plbkk6.prod.google.com ([2002:a17:903:706:b0:261:3bf9:662a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d501:b0:295:1e50:e7cb
 with SMTP id d9443c01a7336-2986a6e9524mr207276585ad.23.1763508515484; Tue, 18
 Nov 2025 15:28:35 -0800 (PST)
Date: Tue, 18 Nov 2025 15:27:54 -0800
In-Reply-To: <20251017213914.167301-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017213914.167301-1-thorsten.blum@linux.dev>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176350821965.2285420.6497416938072757840.b4-ty@google.com>
Subject: Re: [PATCH] KVM: TDX: Use struct_size and simplify tdx_get_capabilities
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thorsten Blum <thorsten.blum@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Fri, 17 Oct 2025 23:39:14 +0200, Thorsten Blum wrote:
> Retrieve the number of user entries with get_user() first and return
> -E2BIG early if 'user_caps' is too small to fit 'caps'.
> 
> Allocate memory for 'caps' only after checking the user buffer's number
> of entries, thus removing two gotos and the need for premature freeing.
> 
> Use struct_size() instead of manually calculating the number of bytes to
> allocate for 'caps', including the nested flexible array.
> 
> [...]

Applied to kvm-x86 tdx, with Rick's tags and suggested fixups from the RESEND[*]
(I had already applied the original patches, and now that these have been in
linux-next for a while, I don't want to modify the hashes just to change the
patch Link).

[*] https://lore.kernel.org/all/20251112171630.3375-1-thorsten.blum@linux.dev

[1/2] KVM: TDX: Check size of user's kvm_tdx_capabilities array before allocating
      https://github.com/kvm-x86/linux/commit/11b79f8318ae
[2/2] KVM: TDX: Use struct_size to simplify tdx_get_capabilities()
      https://github.com/kvm-x86/linux/commit/398180f93cf3

--
https://github.com/kvm-x86/linux/tree/next

