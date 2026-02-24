Return-Path: <kvm+bounces-71709-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WBjNEvgpnmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71709-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:45:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D8A8418D9CF
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C6B0B31BEBB0
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC5535BDBB;
	Tue, 24 Feb 2026 22:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZ7ZMYwg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB82356A08
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 22:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972690; cv=none; b=ifJyhokNIh3AmBQiGj4vP12Bny13h1S3V0zsXFgQyytEjVRuszZrnh4/eoleCIQqxVuyq38XNjiIojHUX06H/6zyIwxCWxbRqrZwXB4VoGWxv2nBHy9p1/HTehuvbCYPJeR1qzAp3Ons4OCXuO/pNzpebsCe9NXha7cxa5bf06g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972690; c=relaxed/simple;
	bh=Vho5fv6IaPARBujXx6sog2AYriOFbR5FY92+OxD4a04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NR5uXbcM+qQDKnbQXHnonPPrnwYaxY93lnAHhnjkXW79+d6yUYZ28iUxGaMdbvOf//yLhxqvQumvPS3mnUpQDiDQiE0Db3PZ7NN85fQAZKNJYlKXvEWFqSpIFRnAXi969yTC3g9vsGGJ+uJO/Tmwe1gLU93iP/tGxJQcRdp/bVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZ7ZMYwg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8D2C2BC86
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 22:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972690;
	bh=Vho5fv6IaPARBujXx6sog2AYriOFbR5FY92+OxD4a04=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DZ7ZMYwgMBPFH9lVSB6WtsfdYc1sewJxmp0WHNzIh8GOTwWPR2+BjacNRhu1CtFhC
	 hGFBkkNX4c0JhXcu59cP52Rb5DfL1FsGq1iON3dpV8dFAv9yZooluw4Mt7zRx1uCej
	 xLUdc8h5CgWn+yVTYTXpubvCcELg2LbxujfpT12GAYjTqkd7JKYV38Iq//I20ugsUx
	 rm4LKa8bHkWcTo0WZAELJ5WHGSyizHGPhK1tnLR2Nc5nFYx3PjI62kBmhVhnTZYNFJ
	 fqh9eHqhmO8EUh495C1f3q+h/ivPJL7LKdfxcK/qj41bl9iGM81mjera1+N5UNADdn
	 HhZn3iphfobmA==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6580dbdb41eso8019947a12.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 14:38:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWDbyQQk4dIMInh+BxpinSfbAeO3trH6b0AXVf60eMyw+MKvEXWnW0qvvEcJKspTNF+J8w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnFHQPlSLzoaYHNjmleq39l8Pl7f/5DCsQoi0yrDh56kQm9cZq
	8RXcxsDmDnCj9OYWLr4I/GMTJ/7EE4nDu3oVjSBUx/x+sVale1RDFTS+xuh5w7dLGSRXk91K+1+
	0elUumIcwnCuHioODV9PaETaOE49AhLs=
X-Received: by 2002:a17:907:944d:b0:b8f:b8e:4ad9 with SMTP id
 a640c23a62f3a-b9081953593mr964268566b.10.1771972688993; Tue, 24 Feb 2026
 14:38:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224223405.3270433-1-yosry@kernel.org>
In-Reply-To: <20260224223405.3270433-1-yosry@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 24 Feb 2026 14:37:57 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPN47j=Km+by8J+Ug4j8vs76tWW=G84bbEPp6spf3F+SQ@mail.gmail.com>
X-Gm-Features: AaiRm52lpspM-R2On4NW8Ew9UDmy0cb4Y1cmGU0oRa_fvhyHGbK66TshUfv_TGQ
Message-ID: <CAO9r8zPN47j=Km+by8J+Ug4j8vs76tWW=G84bbEPp6spf3F+SQ@mail.gmail.com>
Subject: Re: [PATCH 00/31] Nested SVM fixes, cleanups, and hardening
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-71709-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D8A8418D9CF
X-Rspamd-Action: no action

Apparently I messed up the version in the subject of the cover letter
(but not the patches). This is v6.

