Return-Path: <kvm+bounces-72856-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNuPGFK6qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72856-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:16:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB8E215FEC
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 66CC63049C9A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C813E5584;
	Thu,  5 Mar 2026 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nhQddzZE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752D63CE4A0
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730683; cv=none; b=NDXjdYypb/T8gC3yBufnFTMdH6XEZ7CTbYfsYCU0r5fpqqWq+aAhB+VKSsj/Sy8HmhX/L49jogrIg/CjQHFviGBBxn8V/ConxDSHmp9SMqIALcOk0/Y+IOSl79A0zwAizrdBg5MUqC0hWGpaa/f5+Ms7roOx9up/a1RKPizJKE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730683; c=relaxed/simple;
	bh=M6xS7uv8XLl6ow6Mq/vFaLfTTYw09DnpYQM4bWPADxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EuOXj5HY/ggq5CexhWNJPDdTgVU5bhkEG/SyLDuTYHLCujzVC+qqJUHMoewhUHeogGzq3MgafY5IVTkRfXupTXf+fHAh58Zm3l61MaLyX4JLkMH873RTAHXdQA1cvsu26mHUBgmjYtDmqvT4uXTooFXSl4nNV1zYOkV1vPgGxG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nhQddzZE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35986cc87a6so4657725a91.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730681; x=1773335481; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pXjlf1y9STNTHvdugTdOBfF75TrY+hbzHcgvNvEAiqg=;
        b=nhQddzZEzf8c7ZblhrDJ0VRfJWZL762377Vq7IF4atlb53X4LZFx4vxceQgvQstAmn
         xn5iAwg4HcjXqXzkHFijXgIkKhhaw9j07PVDHrXqlEzUdk9QUT4SKsuUGskhs2Ix02ZE
         8Fa8KDguB3Wc04h0CPnTH5BAI6SK5iJXYYJxuAbqGkPEZtVgZ9HYTm7hdKPQR8o1cUIC
         wd2TO0jCE7rOL3dtHAvImr1LB7ahPCn4Es8JjEIOXRAvaE41kjThP4ng3yqaayUeHyJh
         aEj6A4uoHkhW9QtQw9qgTvdg8g/OAqmqTgp93uIu1On9WfIFqRVVFw7WxzLOU9aFYFSw
         lwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730681; x=1773335481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pXjlf1y9STNTHvdugTdOBfF75TrY+hbzHcgvNvEAiqg=;
        b=DoYVFdPlpL3E2w8r1D7AVBezYSckLSS8AxNCTRhj7VnrJaIPg7gFg8uzf0jMpDXHqk
         ij7mXMGKMaxmPg7NdcmE78o0OnfUIAUrD2OOUVZ29YBSXihfQgbrMwgubmsfIoiQi/C7
         ApSq3h75PqKZuBXJShBMM2eVGhHaCG1r+OQjNexTdyIVn/5Y0cDyi49WxUzf1OIBFUZD
         ZYwkWr9Ua0pm3hRrIBlyDyRhcw5i6476mhFB2O+IYXp3FltJxwDuHir4NZ8i10lAHp/1
         Lg7cWlkXLvqghkczJYOVccsmwBgyj61U2RCZSb2xcrt0jzRcDItJ2VsTl7mVPUtJmyTm
         jv0g==
X-Gm-Message-State: AOJu0YzGAbzdULftuKzw5gC8DcK9sdXJR+WERPqTyUPi8Ma5cqgt5ReO
	F7fNTVMcY/MA9vKS30tgIY7gw27SRBUWUTjpUYile6BBUMVgzJbPR+amy+Glo0e95EQqt5xomSs
	jmYpuaQ==
X-Received: from pjbmz4.prod.google.com ([2002:a17:90b:3784:b0:358:fc29:4815])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:278d:b0:356:24f0:af08
 with SMTP id 98e67ed59e1d1-359a69a288bmr5045472a91.1.1772730680711; Thu, 05
 Mar 2026 09:11:20 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:01 -0800
In-Reply-To: <20260228033328.2285047-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272731456.1548301.13671258246375091994.b4-ty@google.com>
Subject: Re: [PATCH V4 0/4] Align SVM with APM defined behaviors
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	Kevin Cheng <chengkev@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 5CB8E215FEC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72856-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Sat, 28 Feb 2026 03:33:24 +0000, Kevin Cheng wrote:
> The APM lists the following behaviors
>   - The VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and INVLPGA instructions
>     can be used when the EFER.SVME is set to 1; otherwise, these
>     instructions generate a #UD exception.
>   - If VMMCALL instruction is not intercepted, the instruction raises a
>     #UD exception.
> 
> [...]

Applied patch 2 to kvm-x86 nested (the rest are coming separately).  Thanks!

[2/4] KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
      https://github.com/kvm-x86/linux/commit/d99df02ff427

--
https://github.com/kvm-x86/linux/tree/next

