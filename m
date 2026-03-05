Return-Path: <kvm+bounces-72783-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gOM5JmsGqWlW0QAAu9opvQ
	(envelope-from <kvm+bounces-72783-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:28:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 35E6320AC76
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:28:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88A2930574BB
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 04:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 809A227510B;
	Thu,  5 Mar 2026 04:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AQlcclL3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91D111713
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 04:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772684889; cv=none; b=TIo7MKu6311h9dYFb0j2xEu8nAqDWqbAoK90FM598OoxpHS/eCeBYvWROzrGpvq6eMndwm7y6mKzGh/FlrGYr91/STkmUBrC8I9dwYbJsTRzljjKP2EO/7FT1aoCym98CCKr6pBcH9GP+IdZivdcNPf4ZGw15Yuwr6K80CATSQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772684889; c=relaxed/simple;
	bh=o5fKDhy74cdzgL9PNph7IkA920FfByjOquD6Ft0H/zY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CWxEIhz0TuxoRjUOlIZBdh8dKojuaVnDHF54W71qg4Tz0+3PmTPE69oSxQthoUykGUnzBB8CTBs0yUTFHjsbtB1iKy73pxbAJigM/e5+ffroypnv1S5RJWartR5ytLZPuVY8TkUohlUKzDTcs45pl8co8sf2C/FQqoufAR5UdMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AQlcclL3; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae4b96c259so45145165ad.1
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 20:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772684888; x=1773289688; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Iz3l6YwXaDjdGRQXPgHOcgcLShfAqlVagFuNQ/atjtw=;
        b=AQlcclL3ABbG8q3uHhWZuUhD9djiZNrVkMhQuTITwONOvQEEaZ3RdMvoD8rEGI8R7R
         IcJJ5Gd74rBD7hmVExSJioTR+JTJVvSHGWCekVvoCmUb5h7/pSJwpFns+en3Hh1K/6yb
         4bueRjr0bFvvxuCIUB2pH1Kbegiv6QqXjDmZGi4+BJpQFjwmukJJeR+1TnPnjcoGJqJz
         TLcHenQOlilU4av5N3mkmLAaL922ls7G9x83Bi0BNHKlY5gNJLdwziC3rzPors5mtnep
         Ne7WjpsZiMixS5MpM9sRh3mtRg5mzRBRp0LlVuR5aSmsEBLCNE0IMk5066P22pMunIH1
         MTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772684888; x=1773289688;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iz3l6YwXaDjdGRQXPgHOcgcLShfAqlVagFuNQ/atjtw=;
        b=C4ZeP8SxZsmasKG5eNhHYYd/ePXgrfz/30IieocFWy/jS19ibaLwTAfP+IBlGmYjkv
         nx0UVoUT3M2EZN5jpdAtM+S2b3W0wdxH0CywYjjxJiKY4z4sqanEcPBcdbZ6IkcEVPHb
         bm0v8fsyMArtJ1j9S84zNyInRT2Tl3lvplQ5ab4qhWq46tY9JblLG9uDCmT0BAHVHrNr
         t14PklEKGcRRyczu6dFmKmmpRy74njnHjMMz+UpcEpOydcXNjQITwd3goVwtR+9fLAcP
         DpseoLILrxE6ZbtSkbrN8qyDsmNrl4O/5yn728dh6VchE5PHzKZRVagWznCii73NYQ0A
         ic2Q==
X-Forwarded-Encrypted: i=1; AJvYcCV0I1KjNiBoTEZXe74iFx9GudH7p/PtV9HDq1e+I9dUsIKdOX3rptxiKH4BYz6/IL4WrN0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu5EiQ9brmFEYy5FwaVS1W4IFu5qQnDb1qJzhYZdVLjgYwzLa3
	xWeP9ov27YOW1clG8fCLM4r+DLzzjAUKb8maL31rhx13YOz1Y1AIv6PWABzZ2cpbYWMMILEjLYW
	kzIvHmg==
X-Received: from plbjx13.prod.google.com ([2002:a17:903:138d:b0:2ae:3cee:978a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f548:b0:2ad:a96c:e40c
 with SMTP id d9443c01a7336-2ae75bb4d0bmr10245955ad.16.1772684887659; Wed, 04
 Mar 2026 20:28:07 -0800 (PST)
Date: Wed, 4 Mar 2026 20:28:06 -0800
In-Reply-To: <20260112235408.168200-17-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112235408.168200-1-chang.seok.bae@intel.com> <20260112235408.168200-17-chang.seok.bae@intel.com>
Message-ID: <aakGVnGI4jZ8yCUM@google.com>
Subject: Re: [PATCH v2 16/16] KVM: x86: selftests: Add APX state handling and
 XCR0 sanity checks
From: Sean Christopherson <seanjc@google.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 35E6320AC76
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72783-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Jan 12, 2026, Chang S. Bae wrote:
> Now that KVM exposes the APX feature to guests on APX-capable systems,
> extend the selftests to validate XCR0 configuration and state management.
> 
> Since APX repurposes the XSAVE area previously used by MPX in the
> non-compacted format, add a check to ensure that MPX states are not set
> when APX is enabled.
> 
> Also, load non-init APX state data in the guest so that XSTATE_BV[APX] is
> set, allowing validation of APX state testing.

I assume/hope there a more tests coming in future versions...

KVM-Unit-Tests' x86/xsave.c would be a good fit, or at least a good reference
for what we should be testing as far as EGPR accesses are concerned.

