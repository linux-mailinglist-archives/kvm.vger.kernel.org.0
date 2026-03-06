Return-Path: <kvm+bounces-73161-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAr+HZJAq2mdbgEAu9opvQ
	(envelope-from <kvm+bounces-73161-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:01:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D68FE227AFE
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:01:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 899A2305D2FF
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 21:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45887481A8A;
	Fri,  6 Mar 2026 21:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3hqXGjWX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256E8481674
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 21:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772830831; cv=pass; b=qnsSj2w+Rve42F131gGuxaG0RzlWEdN9aBooF02o9YuaI8dzTZ58ybKaWi0zo9Fv8xLoDh9OEx01nlTVFmmbtpmVF3Es7YY+yJA3HU5UVMkCb5kFifpPAlcYS1SJy19pTDh84WfyY4kGo9D6ZfImkkNs27DdA6cn6BVTjF13NDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772830831; c=relaxed/simple;
	bh=7KA/xHnzS+kVZKtJB1zuQtwcA721rID+FGCZ2MoytoU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W7+G0hU8MgPYswiR/YCDrjTjVpyI52nZDlI5rSiiXYWF05W01BW+nHN2CexEsP6Z9GnPXh3Cunb1fQpTaQfNmB5WE/ExYmcpzi5QYAuEOSrDRsNgTIVTMrhqaD808BWTuS1rJP0LfcyfjWmb6MvTMzW/SeGjZzvEWjwOtqYDPRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3hqXGjWX; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-661ce258878so2697a12.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 13:00:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772830828; cv=none;
        d=google.com; s=arc-20240605;
        b=kqccZ4ehdlD9Z+a4SHZLrlTcFkK2iKLzVmdH6fs//jG1RA+YFrwsDu0QneKv8PvJ29
         x9ibNR/XCt+A5kZB9UtjT+V8pDNUALeWc/95l9hjg46y8y03LGUuj1IiIZCyigwIdF2W
         LQirmIHeSc6gaIlZVT2Bg6fEPpFfGh+w81YpBcfrfUe3MpdAru0clGeCP6BPE4eRvp4G
         dVnUXJRTwJGVsQiNN213TgvwGpuhaZZxD01NjNssRNMs14MZrqx3UksYebXXg8fp+fS0
         U7/xtGWtrGx4bszjKb63+EJxLB7Mn4qK01QQgyicDks1xJ1BpZAbxY0lcClhCOdJrr5Z
         MY6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7KA/xHnzS+kVZKtJB1zuQtwcA721rID+FGCZ2MoytoU=;
        fh=qjDtWvs37lXTcDlt1HlZVHFKphT6qo9Y08tbHBuXwO4=;
        b=PlJbyrBwAhVIuNFXQVbl27V4qNWU65fnxjPD2pTDJwq/tyiPdMnN075HCAP/8y3Tz1
         yoN90tLnITvHQ1SGrCK15k7Zs7I4yE2RWbkubVrfYC6Hj2mCNpjUtratjnVavzBBQXGj
         TuQOjCb0pb/CS0F8c4je20EEFIaDn8qF3mrKE0V64Q25x8AhDeaHeZNXuDhmeFBLWCk3
         Huh7+aw3dAH+BUbwsZgTN6tJRnuTuxAHgya0kqNanIz1xNHa4GnwXdSQRHtHahnXf9iX
         lIao5kBwwUPuu1YTwhZmQMtJGayPrr224VWV9YE+kQ+sft/jDy262HJO0ak4dyDTzVWu
         R9nA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772830828; x=1773435628; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KA/xHnzS+kVZKtJB1zuQtwcA721rID+FGCZ2MoytoU=;
        b=3hqXGjWXKxAth/0D6Rc8u36rTh2Bs0x4AsSNk2I8L0oiqx5aymUTRU2kipQPA8eyg3
         KwNY4ge/TJ8R3/cJCYVkxzl81mBt2H9kwcm8OK7y+qw+DgThv22X9ACM+18hCqPCnzeG
         ka6XNKwzBTLfDox/LrWqPUXfdPtXGdsmhCB9YnlvZXFRHhTYls2/BgQnbgedmjB3m63s
         RNETG7iQXONyfjJRNRYkI62l9QZjRYOhD8QEvpsEultz4CmY10Wc9uvYl4mahLI4ng27
         cl1TkZN57YXDFICcfZ5g6lymR+n8A4Ty/jynt7otm8dRVI9rvcYE3YXL4gk7Ylu6wu/s
         WNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772830828; x=1773435628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7KA/xHnzS+kVZKtJB1zuQtwcA721rID+FGCZ2MoytoU=;
        b=NSvjagYIhyD5baHv4MVeu/LE0jkFHexh/8nqy1dOlZ1Ue08p/u/wiM8q9/glh/MS2V
         i6/EF07KkmKHAhMbEWlPkijkdyUrA5DY+h3pNonQX88ueI7pQsaAidxrZNe9CBpDpI8c
         zNBfgzUq9pkJqtctQUETeixJ8H3dSh82+yrcczf5vANBXzFBRL+5coixoOPM+nVJ7e8+
         eZPAEv10XuTZlRMJ4kjhoFIhbBzczBD3hpMSyhOlAaZ5TV7nOuzf+E+4AKkS1UKh+zUU
         6ZpWCo1X4yCPhKlAxtBvi2OFS9WZ8peYT7X/NJhoGQFklomBkUHaw9lHksCQDqvEf9Ar
         C4Fg==
X-Forwarded-Encrypted: i=1; AJvYcCVHkL6sKlyydyNVqoSXJCgmvBT+QDY+/yizSNvCq/K/Ok8a5Ae1aGg+tBRjUQOW9TG+TeE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3FJaCJ+TdcC0U0QDN4wjHSn8JLN7x1VtPG6Rj/sooTUmsWlVM
	2DAVuqTk16lFLbkZI7Cbu5Ha4FWarJnQtmlasGuXkOf1mN1pZgDt+GMEUAUCKBK2M7HMKhfNTIN
	xmZ5JBTlJqUxmgv/hVGXyB9Jmh0FmafkluO2jmzWA
X-Gm-Gg: ATEYQzwoJTv+KcGLjkO8d+YrBi9knx3dVjnJLTe0dm8h+CQGUkaqqCGUPbPFdvRVj50
	pHyMa3d3ADzSWsP8UJGUrTuRanM3KWATIGXFHh5l/UucXjzbQkOSAUezGjMPxx/PQVRt6BzoU24
	nLyXCpDOtLoy+zgcV1KHzkD7ArSa+hUFYQHwN6NzoK6W26cTGM8yI2mNtFVILFA/CmUzm3Rd2Ao
	dTNAgxWV+bBiJQptaf2NuMb302kpSd9bSwFoZ06KRBbXKTAXCr4hUS3BY5vEYjPf0EePgXJHyvb
	RtPgn51+DoUgBTutfA==
X-Received: by 2002:a05:6402:1502:b0:660:efc9:900a with SMTP id
 4fb4d7f45d1cf-661e7ca8271mr7725a12.10.1772830827968; Fri, 06 Mar 2026
 13:00:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com> <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
In-Reply-To: <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Mar 2026 13:00:15 -0800
X-Gm-Features: AaiRm50X5gOzgcDvayPLjHDWT1TMJ4n1I7H0vktThU6DCZRu7abi_xGqqOYEqiY
Message-ID: <CALMp9eQNBZsJNdfCVwbJ4v1DgCNqRV3DVcEeCPFt=dd29+qy-A@mail.gmail.com>
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>, 
	Nikolay Borisov <nik.borisov@suse.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>, 
	Tao Zhang <tao1.zhang@intel.com>, David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D68FE227AFE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73161-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.942];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Wed, Nov 19, 2025 at 10:19=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> As a mitigation for BHI, clear_bhb_loop() executes branches that overwrit=
es
> the Branch History Buffer (BHB). On Alder Lake and newer parts this
> sequence is not sufficient because it doesn't clear enough entries. This
> was not an issue because these CPUs have a hardware control (BHI_DIS_S)
> that mitigates BHI in kernel.
>
> BHI variant of VMSCAPE requires isolating branch history between guests a=
nd
> userspace. Note that there is no equivalent hardware control for userspac=
e.
> To effectively isolate branch history on newer CPUs, clear_bhb_loop()
> should execute sufficient number of branches to clear a larger BHB.
>
> Dynamically set the loop count of clear_bhb_loop() such that it is
> effective on newer CPUs too. Use the hardware control enumeration
> X86_FEATURE_BHI_CTRL to select the appropriate loop count.

I didn't speak up earlier, because I have always considered the change
in MAXPHYADDR from ICX to SPR a hard barrier for virtual machines
masquerading as a different platform. Sadly, I am now losing that
battle. :(

If a heterogeneous migration pool includes hosts with and without
BHI_CTRL, then BHI_CTRL cannot be advertised to a guest, because it is
not possible to emulate BHI_DIS_S on a host that doesn't have it.
Hence, one cannot derive the size of the BHB from the existence of
this feature bit.

I think we need an explicit CPUID bit that a hypervisor can set to
indicate that the underlying hardware might be SPR or later.

