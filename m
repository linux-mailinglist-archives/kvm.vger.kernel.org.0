Return-Path: <kvm+bounces-72861-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WF1xFdy6qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72861-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:18:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56F28216091
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:18:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 983E33032051
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473893E5EEE;
	Thu,  5 Mar 2026 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JVPoUq4o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AEE3E556D
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730728; cv=none; b=eHYh0P0QtLKhUopxvWf00Sxm0ivkqXRrdIuRfiKV7okBK5eNkZHUUX7LwMv1GSs/BWmoN06sISld5tQ9X2WRuI8kcpE/Umo+kqcz7ZDg3j9pEjimCB44/tSe1FHU902MVp2SnkPA7yR2Lu/fOuMwMXilHScs8yJeiFe+v64KIGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730728; c=relaxed/simple;
	bh=DQALez4MLr945LcYQ8fyswEmDQ/Z0o2QRMzEo9N7YL8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aBf81MxwovP/CnQfu7ngT7D609+yqa3tv5wL4GQx/XcNGGCDtkpzTHZSinbbj6mQSEb6GnUGbxXgH4xNEsWEBI0uOhPunYxmsB0P3NPmWIqP+8k1NGRw1yx4viHnFS5eJ85EOfx1tsyFHQiMb1iLEr4q3DxXNKvGNEEZZVpb2cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JVPoUq4o; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82739095656so3238291b3a.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730727; x=1773335527; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TCrpRlU/XeRZ925i+ZfLbozazMp60dNJT37Z2w0wPxU=;
        b=JVPoUq4oIANiwc5GSED6DNQhmilic8cKbUmD1w7dPUVB5G2hX1Bw1rsC60ldLlFMXJ
         cIOK39P+lWQzFAmQkUNm9XxUeuQBfpQ8tvMgh0oHC5yj5FChK9JW7m4jtgOFGCNOMmZO
         yG2jzNr20pK2BXe6cr/0NilzTP5S8KXRRwgIoiAOde3Uupz0eFiItxwaPKgabCgpt9Z5
         TYqR/6azphCS1lfbQ6aueG9PKLCkJGsHsRFHO5/XE6XXEih5FwHBeB2SFSQS/48tpd3x
         NzSkQ1R6AM6zEeVioSqkfjuDMar2OvPXf3yQsXVbtcPf9NnidRnDM5ucTwtAFL7Nba1T
         eeFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730727; x=1773335527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TCrpRlU/XeRZ925i+ZfLbozazMp60dNJT37Z2w0wPxU=;
        b=K0Wqa3rzWXctLa1wzar7reBcoJauNp+C8CjnAgWemxn1gyIkZm+EUZaJTKimmggjVO
         3bwZJ33efbG37l12hTioR1tH53GLZ5QKvN08rqUFy3zH2nJVsFG2sSWJKh5G8NjlBWuV
         P505qV7BwWwrNQyKcpx7T79TOfq+kBUT7YPu5A50Xk84077Y0lonM2fsGSDZ1UeGXnKv
         2G2oeD3tFSGJ92Atzb+u2zzHqNAbpoPBuIrXsaAshj5K4e72zWBXdi86/et0V7JJbzog
         FNNkZs4FN5iy66xVcLwD6nUT4gqTwGnfnYmrbInMTl7SDGKRoeM/73WKa2Y3cnITPvLd
         l3Eg==
X-Gm-Message-State: AOJu0YyEhCXO7wEU9MSkr827U4HnNKizKxuYcoXI1Q8NNFLalMRXZfVI
	MRU5oc63yAIo7x/v2gBjB8uG2P8ApI4WH8IpoLgi144tzQLNBkkBpcebjM4hhmCICfNNViM6gpZ
	ZnhUZCQ==
X-Received: from pfbeg26.prod.google.com ([2002:a05:6a00:801a:b0:827:1746:d143])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:852:b0:7e8:4471:8db
 with SMTP id d2e1a72fcca58-82972d5ef85mr6770912b3a.60.1772730726480; Thu, 05
 Mar 2026 09:12:06 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:11 -0800
In-Reply-To: <20260304003010.1108257-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260304003010.1108257-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272513577.1531500.190596074876743542.b4-ty@google.com>
Subject: Re: [PATCH v5 0/2] KVM: nSVM: Intercept STGI/CLGI as needed to inject #UD
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 56F28216091
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72861-lists,kvm=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, 03 Mar 2026 16:30:08 -0800, Sean Christopherson wrote:
> The STGI/CLGI fixes from Kevin's broader "Align SVM with APM defined behaviors"
> series.
> 
> v5:
>  - Separate the STGI/CLGI fixes from everything else.
>  - Apply the Intel compatibiliy weirdness only to VMLOAD/VMSAVE (to fixup
>    SYSENTER MSRs).
>  - Re-remove STGI/CLGI intercept clearing in init_vmcb().
> 
> [...]

Applied to kvm-x86 nested, thanks!

[1/2] KVM: SVM: Move STGI and CLGI intercept handling
      https://github.com/kvm-x86/linux/commit/69f779f79e0d
[2/2] KVM: SVM: Recalc instructions intercepts when EFER.SVME is toggled
      https://github.com/kvm-x86/linux/commit/460c7eb2e759

--
https://github.com/kvm-x86/linux/tree/next

