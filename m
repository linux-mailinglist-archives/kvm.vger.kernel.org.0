Return-Path: <kvm+bounces-54339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C36FB1F12A
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 00:59:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C934E1889BF0
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 22:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56FA2246771;
	Fri,  8 Aug 2025 22:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0bMROWCY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43015221DBD
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 22:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754693972; cv=none; b=P4/tv6XMgQw+HUSzrznF3VHzNBJR8zHR7nSFGk7OoyjwVmnU4dWiCAYZIFrNxi/GmhMaJfMAsBwT7/Ib8lqF22RcViyVlYjdKTWMH+U+KuWDa8mwWhSc3GRnB5u1IM9as8wJBA2A70l4+2kflYZF+DZcgWv4WnV1ZRi0I14FM+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754693972; c=relaxed/simple;
	bh=fNFpdQ+jg6cStsERoB7GG94pOCw3WR3BzUnZR/FRaQk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KP7wkLl3vC4Zf7Vc0CZ430ERbD1YdI0qlf5/6706vQ+nyaQsT1g4RgPOyvjAmPo40x0TS5UGqepm7GK3VArw4eLbp9URZIufps80HdNk2yuzuQ2Z6SzQAicMCgDqENRmI8EilWVBTg578idWBezXTmdigWz6qSgJJWtIHEPKRiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0bMROWCY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-240607653f4so22625465ad.3
        for <kvm@vger.kernel.org>; Fri, 08 Aug 2025 15:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754693970; x=1755298770; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DiLmZgWhRF1Ot9ulosGMfLSlI9WhewVMmUcNccmagMw=;
        b=0bMROWCYbKW4b+jfFxQO30FGcMm7NogKxfe7ukUYVDDZopnURkI0C73LgSWSq9kg3H
         WkTupgwpQ1mvbwNw1IpX6e9EPnxuBaSUne/qRGng29jBf70zklhRLF38lARM5W3pQ4j9
         ogyi35SroULqrzzeld6FHbIx7F9WwBCW716nLL5EfkDgoiEPHaUcNnv7AXFL6ilUZa3H
         Oc7RVET5MPY+daGGU7XI05N/nBHdIveJiFDwVmXj+iUKXm4FgAkPq9/c8NUs0dhosKdx
         U7rqHXL6Tw9nHm0KqMF16DMuO2/m6NehlrDKlSmWQLnqrNMV0GXgU0aH5GvYPw/D8s1i
         GUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754693970; x=1755298770;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DiLmZgWhRF1Ot9ulosGMfLSlI9WhewVMmUcNccmagMw=;
        b=V/y9r/BzdCX/HTLPEgbAJUFzM2+v1FN5u6jGjOLeYIoaTyAXxmt+WVcrIPhGTzRvMX
         IRjPzOGQV3hz67XYpxTZEM6adp7JkuZxDKXAQWqp3G6AV02aYjDlBUFKWQo3WyyaRQ8Z
         NWiPb2NeXlaOFHzd/SYkfN5Npfr6B4Zj9qYiT+ADr1wx582FVFT1DH63wiLyxQuDKwzh
         U4tec2kqf9uqzwToun0rBs4W9TworZaXzz0SD7J8ROHKHjy40i6N6O3bxHEsoU0doFsS
         NV6vx97ho7znahZnoDkR1r1SbyDNzP8YUsFSsBYV840UjPK7N1C/u+umTspFkdssEpFU
         v+zA==
X-Gm-Message-State: AOJu0Yys40BlD4GWLBPfPox/ShDa0VM/qpaahNOk966n8YBp6j1gNJ/S
	PnW0mPClpgSc0b/GTXo4rGAW9TSSEd13ZK/EaHOewoOs/G3yCISpWhcfiEqdLltj0YMyCcPprkC
	tQoLP+A==
X-Google-Smtp-Source: AGHT+IFyppIVS+5+frYoRbNM7fhmMKbIK7z1xCvI1f1zBWOIlSbk4GaQIf+8f7BA8u60irOnBKaXSLB8OYs=
X-Received: from plbld13.prod.google.com ([2002:a17:902:facd:b0:240:3c28:33c0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a28:b0:234:98eb:8eda
 with SMTP id d9443c01a7336-242c21dda5fmr57355365ad.28.1754693970550; Fri, 08
 Aug 2025 15:59:30 -0700 (PDT)
Date: Fri, 8 Aug 2025 15:59:28 -0700
In-Reply-To: <bug-218792-28872-bVH0MHGv7j@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218792-28872@https.bugzilla.kernel.org/> <bug-218792-28872-bVH0MHGv7j@https.bugzilla.kernel.org/>
Message-ID: <aJaBUEjIFai02SxP@google.com>
Subject: Re: [Bug 218792] Guest call trace with mwait enabled
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 08, 2025, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218792
> 
> Len Brown (lenb@kernel.org) changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |lenb@kernel.org
> 
> --- Comment #6 from Len Brown (lenb@kernel.org) ---
> Re: intel_idle
> 
> I agree that the SDM doesn't guarantee this MSR exists
> based on the presence of PC10.
> 
> I'm not opposed to _safe().
> 
> but...
> 
> Why is this "platform" advertising PC10 (or any MWAIT C-states) to intel_idle
> in the first place?

Because letting the guest execute MONITOR/MWAIT natively, and thus get into deeper
sleep states, is advantageous for all the same reasons bare metal CPUs want to
get into deep sleep states, e.g. to let active cores hit higher turbo bins.

