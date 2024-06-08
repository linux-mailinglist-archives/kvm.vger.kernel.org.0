Return-Path: <kvm+bounces-19118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D34A901113
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 11:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E1ED282313
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 09:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4590E167DBD;
	Sat,  8 Jun 2024 09:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="emHLXgwA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BCB18EA8
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 09:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717838247; cv=none; b=j9G1kV5+GATDEUQYUJKMjDSWT5Ie203fUJABTchyLsqokpHWzygEbMcQvV0Zo2GMOskd4BsK3AZnS17tJo1YYKLSJIDOlW1o+33R6Yp5bEN+aaKxhLQkaBn7tjnW4DS8K/y4UcPT5SmVSmPg1QEDmAVitCdmFCCCESR/QTSvHTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717838247; c=relaxed/simple;
	bh=yn+5Ni0OD+DEhhZFp+UeHCOaFS+lfeDdpvC3bDCDk4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sF6eSpxBphJwtoVn6nbr35bUb1xf5GpxA99UfwfCeCPNYF9RDEGqEaKH2l0e3SCC4wYvRUIsklPCaa+3t1vXFdKsLVM6gCWJVEMiPFwWK4GGgGRdj9v04tUkwbLyjPkdXf4on7XVdgZ2xJQMLbVOOjRbz7Z0stOY5Vf2+wH8PCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=emHLXgwA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717838245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yn+5Ni0OD+DEhhZFp+UeHCOaFS+lfeDdpvC3bDCDk4M=;
	b=emHLXgwA/IDdOddyPbclB/cRtEYoAgpxXFUiDP/4uTDMSK0lXbjLY3BSYYX5LtSjqE2hcL
	Ex8gHa6RsQR5MCH4JnGnqCLy9DJA+IEi9H1KjTrSgkYsKUP1r0y32qmKnkuXST9Cu3n7ul
	9zEAhCRzVyYTLpWX59/0tgzrXFYzmmc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-e9MxxqhDMlC-AH2CrRMgKQ-1; Sat, 08 Jun 2024 05:17:23 -0400
X-MC-Unique: e9MxxqhDMlC-AH2CrRMgKQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2c2d2534c52so938688a91.3
        for <kvm@vger.kernel.org>; Sat, 08 Jun 2024 02:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717838242; x=1718443042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yn+5Ni0OD+DEhhZFp+UeHCOaFS+lfeDdpvC3bDCDk4M=;
        b=WCmnic0TFHeguOfKoKYEvJOUFeTzuoVBX91tbQDYt1MWnD6WyAj9/cRrSYf1wZmUFV
         xZTlM/awMlbgYvApRypdSPJHIae2x/K30sj8XaTwN/QXuuHrOQtScl60Nb4h84R/DMqE
         xK5yr6YoK/RXZ5Y3ltEWb6F1dzRLxadOkpF46H4hwaO1qpR7EX2htcNvAxDOWzqhFIYw
         v9CJH8EFfexwXytsiZ565UqfjnDP6WenWo7fc+J/S8EocuFIE/+IEEs9TazWSsdB5WM7
         wJZZoWbFQGqaD+GH9HJbZmh/ByPMQd02T4goPvZ54FPtZt55dc4wiI2UKNhVNObvofHu
         XlwA==
X-Forwarded-Encrypted: i=1; AJvYcCWbm4XQcUhmVtYqgMZFd4wM6+Z5EdgqVVSR6oJ5DG2LeScP3ZqLa5aFXUPxeze/RUGkckFDqfwrBVbWOvFh41N/v9hW
X-Gm-Message-State: AOJu0YxtsUqKbRtYkGz7RsGyql3kweyUCszcsgbEXjGTXhXARIz+Vu9e
	EyxoDhm0Eo4M94mWUKhlCpW8ddSZq3Hf0mFnavZbMJlgYqqxZBB6kmQCJWl7STPV0Cs2Ml3Y5Qm
	+70IRTBEaCr6Z3Zw5ONYjIVej8keCG0J3AT3deHzG2a/pk/4rpET3I3+r7YUTkyGNR0DVaJ0MEN
	jnXBpRJwr91gLv06h4vtWdNaBi
X-Received: by 2002:a17:90a:742:b0:2c2:3b32:a1b8 with SMTP id 98e67ed59e1d1-2c2bcac9f74mr4642513a91.17.1717838242010;
        Sat, 08 Jun 2024 02:17:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvyEuqeUH7Yq3Z7xIB+QPWu94/YeFGsuuW997gf83B/fNXG/k+oroA1mfbvwrCDmVT2Gmd1wZ+PAVo4g+sKX8=
X-Received: by 2002:a17:90a:742:b0:2c2:3b32:a1b8 with SMTP id
 98e67ed59e1d1-2c2bcac9f74mr4642502a91.17.1717838241712; Sat, 08 Jun 2024
 02:17:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
 <20240530210714.364118-16-rick.p.edgecombe@intel.com> <CABgObfbpNN842noAe77WYvgi5MzK2SAA_FYw-=fGa+PcT_Z22w@mail.gmail.com>
 <af69a8359cd5edf892d68764789de7f357c58d5e.camel@intel.com>
In-Reply-To: <af69a8359cd5edf892d68764789de7f357c58d5e.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 8 Jun 2024 11:17:08 +0200
Message-ID: <CABgObfb7mqQhPnm+vE4zdnFdBCYgnYR930=P5x0VsbuarrESUA@mail.gmail.com>
Subject: Re: [PATCH v2 15/15] KVM: x86/tdp_mmu: Add a helper function to walk
 down the TDP MMU
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 8, 2024 at 1:39=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> We were discussing starting to do some early public work on the rest of t=
he MMU
> series (that includes this patch) and the user API around VM and vCPU cre=
ation.
> As in, not have the patches fully ready, but to just work on it in public=
. This
> would probably follow finishing this series up.
>
> It's all tentative, but just to give some idea of where we're at with the=
 rest
> of the series.

Yes, I think we're at the point where we can start pipelining.

Paolo


