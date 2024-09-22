Return-Path: <kvm+bounces-27280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C02F497E3C2
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 23:56:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 804682811D3
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 21:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54EEF78C92;
	Sun, 22 Sep 2024 21:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UkLT+ASC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3929AEEC5;
	Sun, 22 Sep 2024 21:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727042176; cv=none; b=NqopTgebIwLABlv/MB+xC90FUEi2lhx/pVaD9Zz8G+K/LC1OA3G69UDhwqyj6fP+J2Ihosb9SvESYj9rdPm+X+YHHKXOIETkBnIrxBi5YuEKvi/ma1mNuU0Tj7Bsiir5px21ZnjDTALrL9ux6Rwb2ljViuHI/GCEqiqZM2v1ZC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727042176; c=relaxed/simple;
	bh=cQEVJe5wKc/H1uPJbmNRQ3mRF2oroLk4dx/qhTmt9D8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H1qvFUL9tXFRN31FhkhfGlDAajRbX8n+n5GOhZgk9s/CcGDbc3Rzv3ICDjZLyzC8H3/fu9mw/btCWdSN8L20gnDpea1UFxRmhwgdBU19RR9826u0Ml14Ct6EXIYmQOihlqUH9CUVT7i17t3JMlwfwyesBtQzhY1Q3ShaP5/ygDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UkLT+ASC; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2d8b68bddeaso3008621a91.1;
        Sun, 22 Sep 2024 14:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727042174; x=1727646974; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qbJc/gfv08Z4qC6f9BB5HrMpKImqmh+zMYmWJSOrZ10=;
        b=UkLT+ASC1rU/msMzKYm4VVvGzKm0EwovGME9AURTL6uhXl6XR+YjU2huQP1cDYdnFQ
         GtFfrDwrxdBk0a6jVjR/9LMEk9rerxyUIOJ5EdiQkCBqsKx0ELRanl60oirLlMUdlOY5
         eBEmFFQTLcG6nEP1q6eqC+CTxvRSwQ8goPKvJLZqZAnGExrELonZiv1lTpaC15CPgQEG
         phW+J662ukFG47/17hmgglRYgR+CP91mhjArbeDa13TR4Tvn3BY9X0MXHtesblTNir+B
         koUKL1d74ixIOkroFR4aEDQ+L84kV2BbL5be3FDOOp5Od5TVQMPwIs6hRdCEWRgW7ftX
         P5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727042174; x=1727646974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qbJc/gfv08Z4qC6f9BB5HrMpKImqmh+zMYmWJSOrZ10=;
        b=CdigNy5+xA63qdIxz/BYESgeKyfhP7kTeOmHHQpl7Xu2apN/OaXcZBmjBbsvXX1sFx
         DyTwjyTeS5s/cOW4vgENxNPLDZbYTfCtP3mpSBlCDRUC7EbuI4okE2vgm+nqd3AMEMJb
         3xkxH+/6NwnQyCzU9uLGPZrbqbUtm0W9NUqPgdgZ01YOzEDMQiv8nnkJFFz+mt4TC9si
         qmgtm34rgFfuztc1uygy8nS6jxgwleOSDyoqPUv8H++HVhaKHKzW2ATHvwf+bfHFIfaI
         zE6nCqrII9bMm0kCg+KTN1wkIovw5f2qOeKckT6EsHo5RciERN4VuPCCiC9178sJKDR7
         Yayw==
X-Forwarded-Encrypted: i=1; AJvYcCWvto0fafiEqKEOgmEWzUk4ml7PNZaCkR35i19h4ypl3f09MD4zCfMUkBFlzBOqcWLDwu+/QECtrMFdl0M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5A9jWQBcpOvMSNOA1YsEW+Asn5EQnsEUiRNBK6XsuyZWpCOEU
	r+qb8dC1xL4zW8IvEW/urTG1gKCSJ/VCfpDlXz5fHkD+eJ5QdCPC9wyx77CLp+DfKrhhsvU4J9I
	ipEixvg20MaA89L0+Htut5NseR28nAw3hnv/gSg==
X-Google-Smtp-Source: AGHT+IGEi8EmdSzs+NhtpFJMynBJeEVdPE3stZKsCTW8hgiWbFgpCMyU86P0ik2QyTWRb3kWNRLt5BICJA4N8FVsRDo=
X-Received: by 2002:a17:90b:4d07:b0:2d3:c8e5:e548 with SMTP id
 98e67ed59e1d1-2dd7f40ad4cmr13255583a91.13.1727042174333; Sun, 22 Sep 2024
 14:56:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725945912.git.huibo.wang@amd.com> <f521f21d1e4386024593b3f69b82f5c32d7b78fd.1725945912.git.huibo.wang@amd.com>
In-Reply-To: <f521f21d1e4386024593b3f69b82f5c32d7b78fd.1725945912.git.huibo.wang@amd.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Mon, 23 Sep 2024 05:56:02 +0800
Message-ID: <CAJhGHyBBnhaVRNHdot9j9o8QN_GJ2G0jjiPtpqd=Gmdm=OTf4g@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] KVM: SVM: Inject #HV when restricted injection is active
To: Melody Wang <huibo.wang@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello

On Tue, Sep 10, 2024 at 2:05=E2=80=AFPM Melody Wang <huibo.wang@amd.com> wr=
ote:

> +static bool __sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcp=
u)
> +{
> +       struct vcpu_svm *svm =3D to_svm(vcpu);
> +       struct kvm_host_map hvdb_map;
> +       struct hvdb *hvdb;
> +
> +       hvdb =3D map_hvdb(vcpu, &hvdb_map);
> +       if (!hvdb)
> +               return false;

          old_vector =3D hvdb->events.vector;

> +
> +       hvdb->events.vector =3D vcpu->arch.interrupt.nr;
> +
> +       prepare_hv_injection(svm, hvdb);

The specification recommends saving an HV injection on the following condit=
ion:

    if (!(type =3D=3D INJECT_IRQ && old_vector))
         prepare_hv_injection(svm, hvdb)

If PendingEvent.Vector was previously non-zero, because the guest has
not yet chosen to acknowledge the interrupt, the previous vector
number can be overwritten by the new vector number without sending
another #HV (regardless of the value of PendingEvent.NoFurtherSignal),
because the guest should already have been informed that a vector was
pending.


> +
> +       unmap_hvdb(vcpu, &hvdb_map);
> +
> +       return true;
> +}
> +

