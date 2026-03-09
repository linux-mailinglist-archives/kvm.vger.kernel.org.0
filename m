Return-Path: <kvm+bounces-73304-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kATtMpvYrmmKJQIAu9opvQ
	(envelope-from <kvm+bounces-73304-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:26:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DAB123A7D4
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0DC44305309D
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 14:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8B93D1CC5;
	Mon,  9 Mar 2026 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="udrhlORg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F4338BF90
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 14:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773066208; cv=none; b=giviOFUUi40VmmsVgb/XC9r9xu4ydUCcf43WlAjJ7DV+B/tCLN/x8ku+cYT8Gufd5HkRXfeZHtL3W8X0XYxVp9T/lZJBRIrstuSN+bxLV9fReZQ4pVHj/7SZJsgjtDObRCdF3LLRU/gXmM1spHF7YKuP+tUTggv2nHqcGigk2Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773066208; c=relaxed/simple;
	bh=DHJovIUifZmiMrcpaD1G/lVcb5G1OJKfRHhgdocQjWU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XQ/LgS1KsudPjR8KghR9Sr3C5QpePDMcY+7FckeUTuczf4qz7QBqAYLWmU99Lq9fmrlsM8h9r2SWlW/twDytb1CQu5JeMAmYq3ZjZPnK/WO9MO3OO5lGvO099Jx0ov9bjHOBTGNcgd8+UFxHwo+XAQUz5oborifTyy3pT+ZGpbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=udrhlORg; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c73b0c33e72so794257a12.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 07:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773066207; x=1773671007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OwZyNSCbcWMk32tFzPVIR/xIQcy7BRbkN45i85aUQNo=;
        b=udrhlORgKkEcmMF4XuC5+J+wbRtiqGCzWT2l2C2jiA3JpS145WJDwIyG5TMdb7sBzs
         NefDKV/FlTUHtYD/imzGdrQlbEIFaBzdvXWYhlvLFI1AivmI5HLaLvpNXsVDO2aZb4Im
         DacaFkoJJKZM9EZVRlLHVstBF+BM2y9Ghfv0QJtKBae+FutTrEU7qu4ylChg5oV1npEq
         giilKKJSkrZEEzmX4KGHEpb8MxHQE6Yotq4J7gUKLvOLdCBiagVbCf/YJVq3kJf7NgOs
         gZADGf77UhqVxFom2QoZphY1x5ycUfGfjcPGobY7TscHdEYH+0S3W4sqiTJOoOnn4VUZ
         Uorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773066207; x=1773671007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OwZyNSCbcWMk32tFzPVIR/xIQcy7BRbkN45i85aUQNo=;
        b=vke97deUySN5twT3wYEwL1QUNlEsmgJP4tI1Z3rZskc8X+cmoY1RgrfZYYboDLmBSe
         /9NWC8kP1BfsYIThohpRd+d25X7XooygXGlZwO47CofQXtMMJBwzA9Qw7DL8L2fZ9ovJ
         n+dBGXINFWkVbuik+yZF4pGxzjp18NB4+JBr8nNtjWu5iM4Ax8jnG15anhk1edo9cY0G
         kPiEP3+Gn43SyZsvQTHeYVoHHhSJidlATLmEPcOxn1EWNZxkrSvOmMh+qo13x8W/PuJB
         ZXm8fPzDdy13S8BS2k7Adkd+VfC6KdgrF+taojgjlk1aPpDtKtgYTg8q1u4KcnSFzBn4
         Z/vQ==
X-Gm-Message-State: AOJu0Yy4cAd01320R69+rCiwniE9xUMii1kXv/MxP0qsRXzl1VqRzRSZ
	4BezxtAi4kaNXmEOZ0iKrz9VOBC+or0AVPUUI6qZgKamdhEe1q3wXmSGcbjWR3bQn9ks0ChPFAZ
	wwue8Rw==
X-Received: from pgbfm10.prod.google.com ([2002:a05:6a02:498a:b0:c73:8d3b:5c87])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:6697:b0:398:840d:39aa
 with SMTP id adf61e73a8af0-398840d517fmr4912733637.29.1773066206999; Mon, 09
 Mar 2026 07:23:26 -0700 (PDT)
Date: Mon, 9 Mar 2026 07:23:25 -0700
In-Reply-To: <20260309083844.217215-1-pcj3195161583@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260309083844.217215-1-pcj3195161583@163.com>
Message-ID: <aa7X3YNbQ9Zuq6cJ@google.com>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Fix base gfn check when zapping private
 huge SPTE
From: Sean Christopherson <seanjc@google.com>
To: pcjer <pcj3195161583@163.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 6DAB123A7D4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73304-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[163.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.944];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026, pcjer wrote:
> Signed-off-by: pcjer <pcj3195161583@163.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1266d5452..8482a85d6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1025,8 +1025,8 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>  
>  			slot = gfn_to_memslot(kvm, gfn);
>  			if (kvm_hugepage_test_mixed(slot, gfn, iter.level) ||
> -			    (gfn & mask) < start ||
> -			    end < (gfn & mask) + KVM_PAGES_PER_HPAGE(iter.level)) {
> +			    (gfn & ~mask) < start ||
> +			    end < (gfn & ~mask) + KVM_PAGES_PER_HPAGE(iter.level)) {

Somewhat to my surprise, this does indeed look like a legitimate fix, ignoring
that the code in question was never merged and was lasted posted 2+ years ago[*]
(and has long since been replaced).

The bug likely went unnoticed during development because "(gfn & mask) < start"
would almost always be true (mask == 511 for a 2MiB page).  Though mask should
really just be inverted from the get go in this code

+		if (is_private && kvm_gfn_shared_mask(kvm) &&
+		    is_large_pte(iter.old_spte)) {
+			gfn_t gfn = iter.gfn & ~kvm_gfn_shared_mask(kvm);
+			gfn_t mask = KVM_PAGES_PER_HPAGE(iter.level) - 1;
+
+			struct kvm_memory_slot *slot;
+			struct kvm_mmu_page *sp;
+

[*] https://lore.kernel.org/all/c656573ccc68e212416d323d35f884bff25e6e2d.1708933624.git.isaku.yamahata@intel.com

