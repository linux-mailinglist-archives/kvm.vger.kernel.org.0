Return-Path: <kvm+bounces-73269-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SMUTOXuFrmnKFgIAu9opvQ
	(envelope-from <kvm+bounces-73269-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:31:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FDD6235817
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:31:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62B31300D465
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 08:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44EF7248F62;
	Mon,  9 Mar 2026 08:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hd5JbyWD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="I1th1pyl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002E626290
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 08:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773045101; cv=pass; b=NYgaeWbCd8//InlnUTXAQ+MIKp1GcdlsN/nizNGm4LHRmbVVdmj+MjbAsIzj5hrEsTq20O6ECQp+BGAsbbrafb7VlKflO29ZqakKze1QkKlHxa5/w4UySgJdX+/gWmtRslyLUAIJQUKbR3YX0ReEdWzQi0zrUOJ0+qTyCVoNsoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773045101; c=relaxed/simple;
	bh=RcG32SLAjVWv9hJhMYMddM//SBjh0iXF7S5z5FCbshE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A9oFRYDfhbddP7odQK0LV2785wsj6YcI2gVDqC9UfIavpoUzkgkCVssdZz6xVHG6dmnIbyIL92NefRvCRy8mmHPds1cEgd3qLOgV2zJrGHk9iNcaCjGdvsi/Ju9OGDo0f6qP8b8rZ1rk+Ok6yKalT4E1v0JapI4NwLOuCTPbkAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hd5JbyWD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=I1th1pyl; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773045098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RcG32SLAjVWv9hJhMYMddM//SBjh0iXF7S5z5FCbshE=;
	b=hd5JbyWDIdfA8Zg04obaMzXx5FWrfVcIOmhrcu8P9IRk76zlmp1f4GZQpI+5RrozhoWJiv
	zhr4BNzB2EZakpNjM32s5yfqwjfiJ3eLekwIIluGEHtZt3Bb3QYzfxFoRcnKoWGAeA/T3X
	zfXBdR5OgX9ndN/dXP+xSzvzNo6//kM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-AYwKoAeIMeSH8BWzqA9mXg-1; Mon, 09 Mar 2026 04:31:37 -0400
X-MC-Unique: AYwKoAeIMeSH8BWzqA9mXg-1
X-Mimecast-MFC-AGG-ID: AYwKoAeIMeSH8BWzqA9mXg_1773045096
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4853ac455b2so8617715e9.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 01:31:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773045096; cv=none;
        d=google.com; s=arc-20240605;
        b=bU4TNQowth92AXiw1OZwvlq72d9FXWo0swaBXky07aFViHg9Q01DQ/EpFzvCHg8/3y
         sOviKMLL9asP21iHsojFMnaXFBpguY1MkbQx1pLu7wHpLdrdvNYmcFRM12pAv1ETGn8S
         omFxksmbPCKyvq4y6kmFgZ195doABbln11GMVEN+tWblilXuy0pvrOWFm65ZaIik44vn
         B+dh3vPm1VZX2xbYgOlxKuhzqQq6hit57vYKbNQ/7eqRpCKpe8FOrLN2ZBJfVIcGfkra
         1ifHH1bglynazX65o0fR5gKliffZMJ1WkeLnDnU9BGmB0AtBqK89Ws8ysXOEil/89fk8
         5f4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RcG32SLAjVWv9hJhMYMddM//SBjh0iXF7S5z5FCbshE=;
        fh=Yj9uB2aMheIV9zE9UhO5erjn7UabIVqf2OnizZyC8tc=;
        b=lkZRotpUolZO+O9UEm/eo3Nhv/Hgc9Wl0OlT/qfIy07OrPFuyOtqOc4JMWQGwQOSOt
         feKNcyHwJ8qdolWU4YdMcH1vipeSLh7MrTfNhacd2srzztLA9PC7cM0gbXV2It8PE4jx
         /GtMIsGYAK5KmK/6qLbnOFh+48tX5I2QwDMF4kWGU/VMFOWbJHi3dJLI82IXU49DC5C6
         0X2NnH3E94+Vvf0n4Mt7PFB0bwTe0bjphLgjevvXObP3/2VYngZu356xKO7Ctzu0ATJf
         ZkzbTBngMLA9Uwv3aYYi1hXamZpoj3nfw/laqpqONjaW/HcVHPmoB06j94mh7ZS+VLDt
         jU8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773045096; x=1773649896; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RcG32SLAjVWv9hJhMYMddM//SBjh0iXF7S5z5FCbshE=;
        b=I1th1pylOMjggxNESfRipCDGLj4Z0oJMdr90aka72rfhbcmbq5Mu5MLb8ZU15rSvZ7
         rCytKZELntLto1DdvAZg2t9m1GCXWnU46V/cbedQZ5Y7Swsd8SxY0ln/le5/RU/dQ5cv
         RFilcsMp4Muxcrj/fJQdhucfV+kEzp3I48HN+2xUCvA4w8ysvdGKnQiyFtLTLcgHiKF1
         n8L168Ri/HrBD3ugfRD8/aBtnrCPZKDn7qWsNQtGyaDg8oxAFUMNT75mw6IuaK0+QWEj
         tO2LdpVx9fdI5u7LSDGt/j+Y8k3Nnd2HGD8xBDTJxKpv0KIda3mlHh6TQMlyqAx2knQE
         2XQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773045096; x=1773649896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RcG32SLAjVWv9hJhMYMddM//SBjh0iXF7S5z5FCbshE=;
        b=NGJfRtfDLz7ZrvsgoyfgWZu7kClm9Af25FrwjVftFe4wd/agYN+hFs/43oL4NEAezi
         vBdyf/PLV9emGRQfm+J+s7v2zR0aMOCt6WdGLOe6drH5eVC4u9OJ54GZOBPeCvBv0IGk
         S485xsiP5vHBDZTezy1yhpsXfYVcgdfHe3ncopfRxPFIVCsmuoB0iyAOWAXIMFo53chp
         X2SLDtXjg9etqVdZoTGNFJgOd9FWwHj4FoBIveF2lgAUWu+Z1ky5rwDsUXIvE4LSexyH
         O/p51tH5BCO67OdYdYTSui/DJtZwmc/VXge+dkJrfddJBjKBpsHe9yZR8GP3Ndkq4/iG
         0LDg==
X-Forwarded-Encrypted: i=1; AJvYcCUkPVpVlB6wLaWuGVGMdKX1I+70JWBipUCPHuOn03K4Y5QH8kuB23i+3B04yOKCzrbE2HQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/mZmVjIoRp1JbuzmZXN2wHNRnpKQ+4+fCWrMAJ09RcR6vDvOI
	Di9wNmxcPpVze2fx74hm8VECsycWgMZws8Djhn/4omRLB9oavrulj9jSF1LxyO1+5UGs0fOviS8
	5xSOyPr+RMhnV1sA5qPovoBAlkPDYrQFRkbN9lpuX6fPJK5NoMkatMdqIkcIp0g5DS2XH1aV8XB
	nsPj9DQLxkY/nvEOrAuOHaUL8x9ExO
X-Gm-Gg: ATEYQzyY7wBDZ5LOppVQfIhlApv+yiSJ7p3SdjL/8rNIeyoX+0z0qeVh32I4MZbn6qs
	zrM46tVL8oLVVSvIVvQApJfweFrpMtX2pi5FyqdzE5I0tTZLCAsRohA0y9MEo5LTFCV99w69EiU
	xXv9SgeLQOswTRlqwIDhCTl8BQZgAf664eibK1zv29Sm9MNrRbth4rIh/NF4kbkr1kA7MGFxz/s
	3QU3yjiJqkSLnW1GNscRaIVA+hVl1HnF9lMuSLhNRmC29OBuHir3x03BnyKCxC+RHtWgnfMQTsh
	LiLI75o=
X-Received: by 2002:a05:600c:34d3:b0:483:bf23:1915 with SMTP id 5b1f17b1804b1-4852690f5afmr174648865e9.2.1773045096254;
        Mon, 09 Mar 2026 01:31:36 -0700 (PDT)
X-Received: by 2002:a05:600c:34d3:b0:483:bf23:1915 with SMTP id
 5b1f17b1804b1-4852690f5afmr174648425e9.2.1773045095786; Mon, 09 Mar 2026
 01:31:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306041125.45643-1-anshuman.khandual@arm.com>
 <aasZ5NNo7q9MRgzD@google.com> <abc4ed51-2129-4bed-a156-e0e9ec4e81c4@arm.com>
 <CABgObfbK1AdWLLCmTpD56BFCM0j_ckUTta_DpaPYe3mmOf88wg@mail.gmail.com> <32bdf8bf-f363-4a3f-95a3-26ac552a1592@arm.com>
In-Reply-To: <32bdf8bf-f363-4a3f-95a3-26ac552a1592@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 9 Mar 2026 09:31:22 +0100
X-Gm-Features: AaiRm509RfCgvfjS7bA8nSrkQWlisyfZthIeEf1aJIxO9PoZgs4LdILtCL3BoFg
Message-ID: <CABgObfZfMhXQh2P2qTXWM9ZeEnDLGCaZ65046o2irJXTVq8Afw@mail.gmail.com>
Subject: Re: [PATCH] KVM: Change [g|h]va_t as u64
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8FDD6235817
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-73269-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.964];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,arm.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 9, 2026 at 9:29=E2=80=AFAM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
> On 09/03/26 1:50 PM, Paolo Bonzini wrote:
> > Il dom 8 mar 2026, 13:58 Anshuman Khandual <anshuman.khandual@arm.com>
> > ha scritto:
> >>
> >> On 06/03/26 11:46 PM, Sean Christopherson wrote:
> >>> On Fri, Mar 06, 2026, Anshuman Khandual wrote:
> >>>> Change both [g|h]va_t as u64 to be consistent with other address typ=
es.
> >>>
> >>> That's hilariously, blatantly wrong.
> >>
> >> Sorry did not understand how this is wrong. Both guest and host
> >> virtual address types should be be contained in u64 rather than
> >> 'unsigned long'. Did I miss something else here.
> >
> > Virtual addresses are pointers and the pointer-sized integer type in
> > Linux is long.
>
> Agreed but would not u64 work as well ? OR will it be over provisioning
> causing memory wastage for all those unused higher 32 bits on platforms
> where long is just 32 bits.

Maybe, but you'd have to add casts which makes the code harder to
follow and more brittle. So that's not a good idea.

Also, even on 64-bit systems any %l printk format have to be changed to %ll=
.

Paolo


