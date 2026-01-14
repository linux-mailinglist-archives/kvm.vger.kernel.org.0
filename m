Return-Path: <kvm+bounces-67996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B684D1BCFB
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 01:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 11C0A302D383
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 00:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9FC2222A0;
	Wed, 14 Jan 2026 00:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pRgcmhdN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C1E184
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 00:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768350725; cv=pass; b=KTj6rsuZboEIDHQQ6h1/ZXsXcEuajUegA/aZHcziSgmDz+cTwirPN7d8aTmkvUrUCmvIZqYd8mstrW23Ll5TceA6UMu2BiR0d6q0YCk6ThMZ+y43gYoavGCkvUMHxPwNo/8yWIzu09Ey2JOGEuzKSdoNw4ikNBQ7EHZ2X3hH2QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768350725; c=relaxed/simple;
	bh=a6wUaDtICNxo6H184CHsvJN3aC8Z20MkNZw3ko+zU/g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=QbndEfBIWJsLnkOA//CQPHjAaJ0tMrFpUVY8E8qaG4Mjc1NnXx87ltC/NxMnafqgTO1K8meb0pLbnHvmww5x7jimVTOFQzy4vU3H56MXezeAIzGPW8pjZoukpqrrV8+pnoHbFHHngN5m78u03WKkCjqnX+Kr/RnJ0f1lUy3l18Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pRgcmhdN; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso2168a12.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 16:32:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768350723; cv=none;
        d=google.com; s=arc-20240605;
        b=FNw61KJT/ATjb9cUqEt9cZJW8h58H/iyskMW+md3TXKD3WJHf8Aq3JVznvSD3QBc1Y
         TtJobMVwOLWpCSzdpzdIQ55L8YQ/btwfLwaGKG4VgNTJdh9Bw9I3I1XaerwfmBhfrHos
         2zcxaE1Pi8IZsNoO9ot2B76QJJ8lopG9W3aSVRGPQeL8jChIvfVot8GYOXcmtKxb7Eup
         om1BPd7gl8g9mW/Aqe5zDQJTOFEEO448eH4OcE8qcZtx7Ex+jnySYmjmp283kRtHYAR2
         lKdQXxHsKOYX5HrGINzJ0wb9jm5lMFNGIdwyt+3BEKy+42+6xitMkpIEmux4EYi/DdoA
         BItQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a6wUaDtICNxo6H184CHsvJN3aC8Z20MkNZw3ko+zU/g=;
        fh=zkWGsomQqVCOIjRnPtUI3nY2pJuEhen1SDSQagxRcuM=;
        b=B4W2AClrGfTtnVOAeM370FA00QxUqg6bCN54Gsc1ULts9Qgd3YwbZnej0VtxMi5XLg
         T9s1xYHtlNclm7Jecua1y5toK5nlJGiN/R7ppKCenvrDZqo8t1vYmqpvOmNh8j6tiEI4
         A0/U6Ui+WV5lvp8F0M+TikplG/4oaH0qxiHyeticicHwc6X50/NzN6QpkUCNhurT6lrF
         oqKNwf4qF2iw3Ed4NTWC0Tm+YI6tuDtDKIOk8LyTSYqfPSxwDBLJwX/1EONjoyAo//e5
         o4fg/AndMuawp1HHJjLjZr+kZChQwqXPjUYBxaGkCjyG+Qn7b7cke8utMfi0xFiXT4f6
         mHrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768350723; x=1768955523; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a6wUaDtICNxo6H184CHsvJN3aC8Z20MkNZw3ko+zU/g=;
        b=pRgcmhdNUPbOibNcTKb9+S6YJQ+JT0Wi8eT/qOihKLblaBSZa0CvQ1J+nS5rwVXLBf
         A+K+yLvG4bOr8OxwQ844Q0uv0efk+K8sG/nzIbWwWco1yQjAzsfx8t+MvSHgwzJLn+gq
         LBMlyEV+e342uFRvv4CsOQDHni2LXnRwzncnL/xjFlJL3UvAjw12dKG+n7eYMnkmNt/F
         /V+A8eBoYJnHA+4UlXa9RTgAKozxqsNtL7jsUDXkX2ViLSeNnjwiCXLGjYoMK5RujEx0
         6Rpx0TttJBmiCsp5SwoMLVxyF+6CJiJcQufYnUwUqwFufIafD+QEoynmEY2WP7KzxxQH
         B8EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768350723; x=1768955523;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a6wUaDtICNxo6H184CHsvJN3aC8Z20MkNZw3ko+zU/g=;
        b=hL7t0OEGKzXS8cHp1txYLPJikT5XHU2vJ8Pg5Yhw1rWQ9svphx3l9qHLMCvJgReWU1
         YBkU3Qn0z+dE8l3V5izunvzKdXffVXjeRcV37Mit8u8/m+ITCIc18AhUi5Zm+FlyUfB8
         9N7D12CIlgGZcSMQ3ECesd/hduP7kFCUWwXka6ezJTByvYWntLkH54QLvmV8Xhe3R7GJ
         7lvX+VpRM8aITMuqE6vC2Gbn3kGu0ol0f7r86D7D0drBVJtfm5LHxUXc3d0QpCA1+vbh
         +t+IEnDH/TAANMt+kCY1MjU93+lWh7vbSjjMlKH7uMwH2+Io5CRRuvoFiSI1SyzsDGpZ
         RG9A==
X-Forwarded-Encrypted: i=1; AJvYcCWGvdKKGYZAAihjtkQ/kgBHl1GQrMFb25AA9GlytW4uIYSUNfol+8XIBBBS5IBm+rtR1Vw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6nPLplferGzgx5U4mgfFs593idU0ZhZdkuH4L5eXRvZyr8cGj
	fFHrPS61+6ha1nGVd0h3edLqMvtbotLa6D59cgHQteO14inKSG862ioW1FIhHlOYBauaDjUtchJ
	ESTH359NMDRbprynYtOF4eXyM8AyZpF6Qa9fYffbu
X-Gm-Gg: AY/fxX5A1rwqEKIJr79oCw09Jsd6OltGJjVJzHcwZxtMNEoasKo0LuWbmAXKJ2Zd+Ib
	oc6xqbnk1aiaignQG5wL2lbuSfZyk2GWWEro8aWdQdfJTnW/u4XOfGkZPKYDEIyKbbkQKlXVQLa
	fJupEkolXkY+yDYNwfEtXRY8TVXVYmkfZSJnGhQKqBq/Kl3wlKRwlbpjWPS1HTtqIMeRwzMIMrF
	25hCd2FPF4tfxwB2jP5O2aPeuWmpLJr2YyvOkxy347fgjQG2xKKvg8UtMkjjOaL1kcq6NM=
X-Received: by 2002:aa7:d399:0:b0:640:4aeb:b4d3 with SMTP id
 4fb4d7f45d1cf-653eb8b91e0mr16246a12.2.1768350722680; Tue, 13 Jan 2026
 16:32:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113003016.3511895-1-jmattson@google.com>
In-Reply-To: <20260113003016.3511895-1-jmattson@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 13 Jan 2026 16:31:50 -0800
X-Gm-Features: AZwV_Qj48k15LymrU0ga_vbUw3bTYYBlGdp6Pdii9Imxn230GNLk5A_U70QLjgs
Message-ID: <CALMp9eTLS6_HhWTkf-baga77=0zNq6KUBYtvY0WNuGs3ts2Ptw@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: x86: nSVM: Improve PAT virtualization
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Cathy Avery <cavery@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 4:30=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> KVM's implementation of nested SVM treats PAT the same way whether or
> not nested NPT is enabled: L1 and L2 share a PAT.
>
> This is correct when nested NPT is disabled, but incorrect when nested
> NPT is enabled. When nested NPT is enabled, L1 and L2 have independent
> PATs.

Yosry points out that this series does not correctly handle saving a
checkpoint on a new kernel and restoring it on an old kernel. In that
scenario, KVM_SET_MSRS will restore the L2 PAT, and the old kernel
will not restore L1's PAT on emulated #VMEXIT.

I have also discovered that not all userspace VMMs restore MSRs before
nested state.

Ironically, I think the way to correctly deal with compatibility in
both directions is to go back to the architected separation of hPAT
and gPAT. Accesses to IA32_PAT from userspace will always have to
reference hPAT to properly restore a new checkpoint on an old kernel.

Cooking up v2...

