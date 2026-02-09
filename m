Return-Path: <kvm+bounces-70647-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDfyOH9PimmUJQAAu9opvQ
	(envelope-from <kvm+bounces-70647-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 22:19:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 75F7A114B92
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 22:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 68038300DF7E
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 21:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31CAB30EF83;
	Mon,  9 Feb 2026 21:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pAY/Dpn3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C5C30E844
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 21:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770671983; cv=none; b=Sc0cI5KVVKSQBtzf3VXv8aw9MPRHQFVrcxAhUDGkKU6Y+Zncg98LQv2QUXuMD2+Vxm00ldxPGjnj7Z3dp2xkepuq5p0G0qIPevJZ2psGoNwNJ6i8qAhidStpi5lGAQ6xVAbx75qn0CXxKU05FQlvmru5mXxgI8PlrivD1EOoEMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770671983; c=relaxed/simple;
	bh=Y4LgqKz4HV88xl/cRgqz4S3s9scHVfLf5Jfxz1PMyI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dep4ax9JZohZ2h4G4ieHLqTerhpY9R1nob2kxUIHaQYhifMhrsTjrD+8lkYfbkSVcsv7vMAQeaR1bh5wlTsvk1dvsZNARTtNS61ut08nBTHVvGcd6OGr22yiw2WH9aq1nYwCPYHdwrImFLafbSx89sDkLqJDa5S5n0R2Gg+x9Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pAY/Dpn3; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso1930147a12.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 13:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770671981; x=1771276781; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0tmTg43Su2XIUd3mvKAV1dcrfYudwS1bYBY0CWZrNEo=;
        b=pAY/Dpn3sSg+MgA5b94gWuob5ZFfYpoFjVL8/Uy0IFEKlGb+o+g+1ZmnAClLrc64t5
         6h3ch+0oKuVGMUI0Q4ZzmhzQBYEJnlBhFLMGR/ZAwvU5XxZQ33OSFM0jFWOEsdQyL/n8
         Q3LoKMTMxAvXC/qXVC3kXz26eujzSdcNnHTP3XUQk8oIIM+ahzvBdtJx4vy0aGGjJcZo
         keao3CH5IWxQjmUzQDTZW+zJ7RupFT3Jjh8M6YfC+KSdl77AJw3p8RTcL9GWAInn5RJg
         djlu0L3b5OxQR5drlsYrjIPQhPcnP4yz7oUn3dyXyC4SFulLGWfC8FcMUwYXhzKnVLHx
         lTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770671981; x=1771276781;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0tmTg43Su2XIUd3mvKAV1dcrfYudwS1bYBY0CWZrNEo=;
        b=L+AeGJTnNNA/KSztaa3LtjNf+eowXD6zdYiHZvbz+YrHL29bKpGRMiuZZd3pHw6ZY7
         0yjLbdUcvYWNcT2CLLaiEmxG2TQAVg5vLmEei07DuSImCO4UWix2hC3PnfLG5HW0oRQG
         mUYApdCYdPWrYwRAofHIlmUO84OOZ2k/VHWmayi76Ol5sU1VrQwhQjvZ0wyhp7RUXvlb
         zjdzu4o1CAV1kLJ/rjn6oweS11uej1g9gdG2KAe/+7X69XfaoKUqwgDrTgCO37014vIa
         nQf3tx/Apd9+vwCl2BONtgEouh8OeoIr1GRLHAPMh1XFCiK8yiqEqk0i5dubOIM3Ipst
         5jmA==
X-Gm-Message-State: AOJu0YzKjhsBWNCCaPaUuhD5pypjBcgm7byOoqKn/BQ01eq5emND5bCp
	Kx7hcllwRI7dgFF3AXNBgeT4xoZ15jHaX8qj6fgM6vOPGoHaaxWNTub7Ug5AB+vpHZNQ1xcStYO
	B0cM+eg==
X-Received: from pgbfm15.prod.google.com ([2002:a05:6a02:498f:b0:c63:58d6:3345])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:2e18:b0:38d:f08d:b349
 with SMTP id adf61e73a8af0-393ad33a4c4mr12100704637.43.1770671981490; Mon, 09
 Feb 2026 13:19:41 -0800 (PST)
Date: Mon, 9 Feb 2026 13:19:39 -0800
In-Reply-To: <CABgObfatae4rtioViKGueFG9=Qm=qEmvXQp=8LWhZnUMML7_9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com> <20260207041011.913471-5-seanjc@google.com>
 <CABgObfatae4rtioViKGueFG9=Qm=qEmvXQp=8LWhZnUMML7_9w@mail.gmail.com>
Message-ID: <aYpPay9AuD3KkYfr@google.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.20
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70647-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 75F7A114B92
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Paolo Bonzini wrote:
> On Sat, Feb 7, 2026 at 5:10=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >  - Add WARNs to guard against modifying KVM's CPU caps outside of the i=
ntended
> >    setup flow, as nested VMX in particular is sensitive to unexpected c=
hanges
> >    in KVM's golden configuration.
>=20
> Possible follow-up: does it make sense to sync kvm_caps.supported_xss
> by calling kvm_setup_xss_caps() from kvm_finalize_cpu_caps()?

Ha!  I did that in v1[*], but Xiaoyao didn't like that it hid the XSS setup=
, which
very technically aren't part of kvm_cpu_caps.  For the current code base, t=
he pros
and cons of each approach seem to largely cancel each other out, so I think=
 my vote
is to keep things as-is for now, and revisit things if/when we end up with =
more
common code that needs to run right before kvm_finalize_cpu_caps().

[*] https://lore.kernel.org/all/20260123221542.2498217-2-seanjc@google.com

