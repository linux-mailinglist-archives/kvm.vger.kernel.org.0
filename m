Return-Path: <kvm+bounces-44128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68515A9AD20
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93C661B65A3A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F3B22B595;
	Thu, 24 Apr 2025 12:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dfhtZ/7m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EB61FAA
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 12:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745497173; cv=none; b=KOPMK8uiMK7LgW2EY5GeHDkfJ7/dn3ILtOwl8W6I6rPK05LQUTdjRCjbFGBOfACIGZR5HCG30l689gGTtN3H37z3gKMs04hfXIDwDCzytDLhEsC2HZovoQFqhbi6NDr6Mgk3RKYLPO/7VcD5XZZ6GFVFEyFu5qu4ivL56J8xe8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745497173; c=relaxed/simple;
	bh=yQrbEvDasTInCORmM4M6a+zjKHh3betcGFdhUCrHiSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r+BsrImylg55PITM1lkaXO+ffPVxyw34FtU5SR7URvDL7iSlgaRIrt1IV9V7mLb3U7ev6gL21bxhHKPDrPMBFG7w4s7qdDGfHZlIok/M6BhirjSaDOYglwQnVpDW6LF47AQXfoXzAWY34v6Y3J5+MJeDfZlwiBWs9g8lmQPmW3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dfhtZ/7m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745497170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQrbEvDasTInCORmM4M6a+zjKHh3betcGFdhUCrHiSg=;
	b=dfhtZ/7mG+p5ja+Z7nCqdN1jTLzbUroGq5/ktvQhE7p5SgM849A0cYMcXu6BaTVLTFgcfR
	F8oNzTEjS14Yf1qBclBFUBokr/tTMjn9cd7KfBb6h2HQ4kcEPdhsYdYal/4ox2JrafbwF6
	u4lx97ONVW3uA6eYCyDbx33KrnInTsc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-9cQhdi9VPWS4aDC9jDmb8g-1; Thu, 24 Apr 2025 08:19:28 -0400
X-MC-Unique: 9cQhdi9VPWS4aDC9jDmb8g-1
X-Mimecast-MFC-AGG-ID: 9cQhdi9VPWS4aDC9jDmb8g_1745497168
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3912b54611dso470424f8f.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 05:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745497167; x=1746101967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQrbEvDasTInCORmM4M6a+zjKHh3betcGFdhUCrHiSg=;
        b=X8lL6kiGLIDsz131HtNGQ8OpNlPRgniRiJRuFqz3K2xbWXHc3BlWkIkFjzh/tD5u+c
         tK/Yf21BueVRV7lB2L83X/M4crd6/GUsBdKblsX5o29dIO0n89/eOZhVtuiilonFOILo
         Bv0WUnf4YBJhLgLOtLYxabBP4xsKbX9EYVvj+vXY1UdvT2ZVWasSH8QJizxDSfrCDBKA
         44P2l4zPVn34tjkREvF28UAhMLUwP69ooZ4TChFtulMpZxkGnZpHxM+Ek55HmXQQ4XsU
         jtTdhphkMJuCkyZ46VQiv0y13TZLbCwJBFsoA4TJjP38oog4E6Ov3BuY56odDEuuzEs5
         JKgw==
X-Forwarded-Encrypted: i=1; AJvYcCURYTFQZIZ5Dl+CX31opMTvgI1+e9qRP/yCiGpLv4UGfG01CIxxkexqgZeudBUIair4ufQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFQNYB4NLCAclmACv/T72W8OB+Xi6Qv1eitd6uvWHvwD7RLIij
	R8AWLHe/PULmKX/DQIsB0jMRODtZQ5fF0ELKtwi5AoBmfceCRQgw3zLLG0V4PKzA69y7HlMtgLW
	TPbOE8dvdFreZEvHcurECR7fQ2WNghL2TodFKBZWaNxM0mrtOCV58X4Ovy9GhFHdi7QOjPmRiP8
	fjKFuew3j3DM54tfZHk3at626q
X-Gm-Gg: ASbGncsjzIvykOSYcOxANTAxIYYhn2+7NZUpofogkakElYiR5oGhiF/g7vNCA8h+QxP
	s77+hZHzlWqmJcXEdhdGvteeKC0E08oCeVvSwchf8g3Dje0sHe3tmWBxwi8AlMMSK2b4=
X-Received: by 2002:a05:6000:2211:b0:39c:13f5:dba0 with SMTP id ffacd0b85a97d-3a06cf5326fmr1961295f8f.13.1745497167666;
        Thu, 24 Apr 2025 05:19:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHE0zyoJHnMltomstSOMKlkNbhy6VhOM1CDJrC0CGs/vN+CPBkbENcRZnbL+cpxaQaTDNrh/DcgIawstZHTrJY=
X-Received: by 2002:a05:6000:2211:b0:39c:13f5:dba0 with SMTP id
 ffacd0b85a97d-3a06cf5326fmr1961269f8f.13.1745497167294; Thu, 24 Apr 2025
 05:19:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <da3e2f6bdc67b1b02d99a6b57ffc9df48a0f4743.camel@intel.com>
 <5e7e8cb7-27b2-416d-9262-e585034327be@redhat.com> <86730ddd2e0cd8d3a901ffbb8117d897211a9cd4.camel@intel.com>
 <CABgObfaMRjeyhnP+QvTcZ+jKb6q-opCQ_a_MBFbj3AYF0ZDewg@mail.gmail.com> <ej63wuy64m2ysxzeficvcorvrsmyyy375s4nn34xsizwwbuejn@joaj4hrmdb4d>
In-Reply-To: <ej63wuy64m2ysxzeficvcorvrsmyyy375s4nn34xsizwwbuejn@joaj4hrmdb4d>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 24 Apr 2025 14:19:15 +0200
X-Gm-Features: ATxdqUGphE_zkEIsbyjGEdAIuydto3vCBGgUKvz7xR5aQ7AOYjekQ0cnNxilovM
Message-ID: <CABgObfZr64iG4wxyZi8+LsnNPzsMyLAEW+Zar08aKLLGn6R0CA@mail.gmail.com>
Subject: Re: Drop "KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall"
To: "Shutemov, Kirill" <kirill.shutemov@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Wu, Binbin" <binbin.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2025 at 8:52=E2=80=AFAM Shutemov, Kirill
<kirill.shutemov@intel.com> wrote:
>
> On Wed, Apr 23, 2025 at 04:09:50PM +0200, Paolo Bonzini wrote:
> > On Sat, Apr 19, 2025 at 12:16=E2=80=AFAM Edgecombe, Rick P
> > <rick.p.edgecombe@intel.com> wrote:
> > > TDG.VP.VMCALL<INSTRUCTION.WBINVD> - Missing
> > > TDG.VP.VMCALL<INSTRUCTION.PCONFIG> - Missing
> >
> > WBINVD and PCONFIG need to be implemented (PCONFIG can be a stub).
>
> On the guest side I actively avoided using WBINVD as the only way for VMM
> to implement it is to do WBINVD on the host side which is too disruptive
> for the system. It is possible way to DoS the host.
>
> Do we really want to implement it on KVM side? It is good incentive for
> guests to avoid WBINVD.

KVM does not do anything for WBINVD unless you have assigned devices
with non-coherent DMA, so in practice WBINVD would basically be a nop.

Paolo


