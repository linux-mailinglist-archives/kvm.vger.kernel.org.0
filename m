Return-Path: <kvm+bounces-70535-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4N7UOTK7hmkEQgQAu9opvQ
	(envelope-from <kvm+bounces-70535-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:10:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BDBD104D35
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:10:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6AAC5303388E
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 04:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ADD42D5410;
	Sat,  7 Feb 2026 04:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ivZmofTG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C5C2BE7BA
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 04:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770437413; cv=none; b=Gay8/dRDgFPUTZ5x7m0K1X3BxJWx+sTswlTgf+QL//lVXpQdunFNLRY/TfGWMeUeQZQwPYwgsHRnlh/cJq6wFJ7I/tbOdK0EDC4/hESb4T2AZnLoCODebAjVlk0wSWmPQ0+2ELcPDptOdg0b96NCIY5rhjxQJjRVXrXW4RjgI6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770437413; c=relaxed/simple;
	bh=fSFzt38dXY+Z/qZjzgHR6tTM00WDVeyu1C4eIOX26Kg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DtLetI78OK1SW5UlaL801ZavOW1NthvT98AO33pSGVLXRXP48apiCEspNXgqOKTXu/Ve5PWhI+Remc3WejKsUXXjPJntjgA20CBJdckvuzJBaMeGClSgCeH1z9f9o5t9DJDMMdcg/ZtxHXg0fbVC93PDwLFYtaAVsOt3pU8+wFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ivZmofTG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352c7924ebcso1360736a91.3
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 20:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770437413; x=1771042213; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aI358xutY4h10C5E+x9L96wqWeotiSmpx+a8envX0WE=;
        b=ivZmofTG55D1LgJnHO2RdqIFREP1VtihvhQIHTh7zgHZo1VS/PpMzRc4dLG0GWwFv4
         Rh1WzDvnT1jh3UAe3yQQlhDv0ShBX3vEjIkNm5TxTmamTS7mQHMN8WF7KCGvwNn9nl41
         5RiWs/3NHHq+Y7qk7v+S6j0xKl+wxCYfhBgAmcFm6ore0vMVgXlN1Rnddn6hs6eVT29a
         HHok8jw1VAI0S1547F6/9Ep8Q5kdZi+kyIf55cwBKkrYRUmgv2C/KtmntA8qjyf0sGHo
         pf0lpAM11sDNtsXEL38dR/Ra20j+L4tIHvWcS5TxP7f3zPQPtsrZwkQ8BKokJlN/y0o+
         H8wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770437413; x=1771042213;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aI358xutY4h10C5E+x9L96wqWeotiSmpx+a8envX0WE=;
        b=es5kwtVo2gzmNfK26KolPHdfDYZ+JZij0EP7bMUVRHGD9COtYlnylcqUd8l6xak6n3
         LpSCY0fJ+0uZe99EaromWWngiDwmlfrTztcTsIIwRinDo4yvyNf1nnSJNZ23Gya/z++K
         CW0GlVwiTGN9kHetncK6L5LQuTXm6iKsN321lZaX//2VBVvnRzuYYAilzpvXJbRlrHl6
         6D2TxjcJU5FBZCDJWVX9B/O2sldTvaTDME7KXfv04jOzT0NApAmkZQ38m/LVJtUyaa7E
         fsHYmfNG7TuTH1nuWhokvfJWLxaBLPIR7PBYM6edIiMsvQQhjky96u7qyPDU0Cfkzfl8
         tFeA==
X-Gm-Message-State: AOJu0Yx+NlO7zeSAynm7zS3y2kmDm7s93vH0jXSMEdX0V8s7UmJUV7Jp
	ehp+TEmSR/AbVAvMXivMTpzpkPWVrE4ffqcoOVgN6IiCqwVRLSs3u6/heVYgZR/NhtmvFWiMxW2
	0kiaunA==
X-Received: from pjtl24.prod.google.com ([2002:a17:90a:c598:b0:354:c16d:17b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c86:b0:340:ecad:414
 with SMTP id 98e67ed59e1d1-354b3e4b5bcmr4085440a91.27.1770437412960; Fri, 06
 Feb 2026 20:10:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  6 Feb 2026 20:10:02 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207041011.913471-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86 pull requests for 6.20
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70535-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCPT_COUNT_THREE(0.00)[4];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 4BDBD104D35
X-Rspamd-Action: no action

Unless I'm forgetting something, there's only one conflict, between "selftests"
and the kvm-riscv tree[*] (Anup also mentioned this in his pull request).

There are two ABI changes, both of which I'm confident won't break userspace:

 - When populating guest_memfd, require the source to be 4KiB aligned.
 - Disallow changing the virtual CPU model when L2 is active (basically an
   extension of the existing rule that the model can't be changed after KVM_RUN.

Oh, and except for the PMU pull request, these are all against 6.19-rc4.

[*] https://lore.kernel.org/all/aXt2F2jIm5YK8LB1@sirena.org.uk

