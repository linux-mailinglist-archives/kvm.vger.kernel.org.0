Return-Path: <kvm+bounces-70614-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yNXDFnwOimlrGAAAu9opvQ
	(envelope-from <kvm+bounces-70614-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:42:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F02551129B7
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:42:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5DA133024A72
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 16:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1684A381717;
	Mon,  9 Feb 2026 16:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UH70CD5i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F06B37E302
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 16:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770655109; cv=none; b=DsvnY4xejInPzi3FjlTJvDk63kG9hI1GhqiUxU5rgmUjyL21wlALKdcK+qsA4VY+bSnB/VNC7AO2ty+3MRI89v3smb/ewTXEgxye3A7+Q/aocWU/kbx5HnLXJ+iJaGapMJbOLQfAJV7pC81RP4wzX5A39bxspYXap1amYMhJUu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770655109; c=relaxed/simple;
	bh=B48DaaCO7+LfyvOi9x6gHsybR+8CdIPj7Qki/6Pp50o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lIt0r8/3XfeqXGawWn44JFAkg1pzzx1OJFDQqnAk2C82LjDPftprlFGRCkFW/RJn4OuwMBhH+6jsTvzLgQTakn8i+ojMF9U+ORdmiZ9+JrIRdwgQwdap4ZFlUKjvpvG6RfA+b7HEvC8hjTSuY9Wo8v9ri8iFqRApttvl4tRVrKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UH70CD5i; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c6e05af6fso3074980a91.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 08:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770655108; x=1771259908; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rx/VGrvTgLfTgDjWu+ZXokFymSwiySde0F3Aiwt+HCA=;
        b=UH70CD5iV6opvI53VDp5ROl/OAPU8hmPAUIZL8xBEDR0yskOSmm3UBmyYx7Mrtxol9
         tRqW6rdiJH++gi0lzFVq210EbRFy94B0sBDXtW+UyXy7KZBZGlWEZr/hAXhRPEerGIY2
         yXitXIDZmENR4S5il9x3FG74+m++yEN+NFF5c2WP+MbRVibjCCOMWLSjv5KQsThnR2OE
         JV3TUCcySV4/IPivgG1dtvzZ4H7pdDGTesCVB02RG3rI8X7i+gFDUNugYvaLuZ6DmPYb
         GfsvZtuEZxQmD+q2w17xYqz6agvKRomFB4zPEWEnPn7MJc4pI6fkEBO2zuhBoO9ZVk3p
         txcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770655108; x=1771259908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rx/VGrvTgLfTgDjWu+ZXokFymSwiySde0F3Aiwt+HCA=;
        b=QORHUoSv9SiZ9yHFjS4/odA2107pLVQBTUj26MwIFzPy40HYuYb7C8ZuEAq9Q9GMZX
         yvaitcfuHKEaXwTd1dkBfhpvcKuRZb6gMpuVOxJ8PYNsCUwZfewBY6PFNVY/F4THubsS
         1b0q0CffiJCN9d+BTZVsOyfdwQPXWacQsUJx/DcoVMJgaHbBMGqVwU7w1U97VjdFZxb+
         Gm7CfJ3QPTpEgeqgVQKeuE7kzIJZ0N+fqVEpW6Z2//ygeWsLYxeD0W0D0TkTFJg8/JPD
         im5NZZzb1uup0AZwxGwyaK0s+/QxBU5eo4kYe1q8jySfT+OLIUgMaQQs712TPFuJlAmO
         O/dw==
X-Forwarded-Encrypted: i=1; AJvYcCXy659x58esixndtg0EuTcLx5UdFDm5dWLf+pZxHkKdQOJbQum+Z1r5qZxdx/Ts80YHIdk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVlWGA7zS2WZC08v+Upj16dEFtsauAVxbX/szqOSlJpFoA5nG9
	U3ew8B31ZtokcvBCP73M3p1JnzoM7hE27wSQBmuq0qA2HORiDM5FfhD+fINCDdbRWjGt687fkdz
	vNiHHvQ==
X-Received: from pjbei15.prod.google.com ([2002:a17:90a:e54f:b0:356:2800:2a52])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fc6:b0:356:1dad:1b07
 with SMTP id 98e67ed59e1d1-3561dad1e0fmr6194504a91.23.1770655108544; Mon, 09
 Feb 2026 08:38:28 -0800 (PST)
Date: Mon, 9 Feb 2026 08:38:27 -0800
In-Reply-To: <20260209041305.64906-5-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209041305.64906-1-zhiquan_li@163.com> <20260209041305.64906-5-zhiquan_li@163.com>
Message-ID: <aYoNg4dUNluaQgVJ@google.com>
Subject: Re: [PATCH RESEND 4/5] KVM: x86: selftests: Allow the PMU event
 filter test for Hygon
From: Sean Christopherson <seanjc@google.com>
To: Zhiquan Li <zhiquan_li@163.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70614-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[163.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F02551129B7
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Zhiquan Li wrote:
> At present, the PMU event filter test is only available for Intel and
> AMD architecture conditionally, but it is applicable for Hygon
> architecture as well.
> 
> Since all known Hygon processors can re-use the test cases, so it isn't
> necessary to create a wrapper like other architectures, using the
> "host_cpu_is_hygon" variable should be enough.
> 
> Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
> ---
>  tools/testing/selftests/kvm/x86/pmu_event_filter_test.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> index 1c5b7611db24..e6badd9a2a2a 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> @@ -842,14 +842,14 @@ int main(int argc, char *argv[])
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
>  
> -	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu());
> +	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu() || host_cpu_is_hygon);

Manually handling every check is rather silly, just do:

diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
index 1c5b7611db24..93b61c077991 100644
--- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
@@ -361,7 +361,8 @@ static bool use_intel_pmu(void)
  */
 static bool use_amd_pmu(void)
 {
-       return host_cpu_is_amd && kvm_cpu_family() >= 0x17;
+       return (host_cpu_is_amd && kvm_cpu_family() >= 0x17) ||
+              host_cpu_is_hygon;
 }
 
 /*

