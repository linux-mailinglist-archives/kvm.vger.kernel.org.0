Return-Path: <kvm+bounces-63537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E80C68DEC
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 11:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5E83F349966
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8F9343D8A;
	Tue, 18 Nov 2025 10:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YUxm9IPS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dgbFkAoy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5E12571A0
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 10:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462038; cv=none; b=eIaprqJWM0EgSf51sRDkcYFW06FKHgh69sx4yltccaHb4qcfm23Wrgxe+szZ0ExAgqY/d5QuvjREDZVxBr5azmpfmAms9SZZ3zOpDwssRCurSwj2WYqgv6ntjDJHtpeG8J2N6+2vPEoHQglt6ueamoX+cGn1kafP64ZUJaDQz8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462038; c=relaxed/simple;
	bh=68Tc7UPjTBlxAu85I4d0PwtV/zsIELiLNDKA0Uhh0so=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GTE3yZvnlE31Gb8KPa31x5zj2fSVPoaApXCyP44tOatc9VwnXIL9lLSKODNB1Kd66m1vH/2FLGhxFWcQveZh6aty73MBzykKIRHIwTpnTaS4dfg1x8OeXENONwILn2oxWs9FVXddFZVp6u9Jy886E4cZyNU+BlzjkE4MVhQIKZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YUxm9IPS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dgbFkAoy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763462035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLfcKj93UvW8wQFZLPKFulahqzWmIOY5Gt20N4P/5u4=;
	b=YUxm9IPSj10qR6vEcTSDflMRjFlsIKkoGnxRTKxdszvowV0Eh5LkexD6gFFMY3wfUSYMYe
	BMl9N1sjL4CEoYsJv3KvZwVfhPTBi7EulSFlPwuV15eNjsNJYSGoJbAtpsBhupnrjvs3Rv
	nJwuGuIbqlxeo+1lcBjSLlNsHqmT1IM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-y-TVVPPAMU-vXM_BLKdcPw-1; Tue, 18 Nov 2025 05:33:54 -0500
X-MC-Unique: y-TVVPPAMU-vXM_BLKdcPw-1
X-Mimecast-MFC-AGG-ID: y-TVVPPAMU-vXM_BLKdcPw_1763462033
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-429cce847c4so2320208f8f.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 02:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763462033; x=1764066833; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLfcKj93UvW8wQFZLPKFulahqzWmIOY5Gt20N4P/5u4=;
        b=dgbFkAoyLUiu8bU+sZ83dtDfujQbGGUfw4PPC8CJGhrHNPC5bnUtJjRmEJUPciKGva
         N8+qp5unrKML+6tS/tf9/ESEOQMg5cj6ctfJ2j28WCaPHAjsmFu53cp3QqKRA16P/UgP
         QP0ZsKDJfG3FrqNaJIdzJIu592o2raEazzLQyUP8rprAvogivwipaWbJw4cBsaogLjxd
         1+G4yp7cMm3xVwmLak4ALHuobZGoSfw8g40vnM8FEdizyVxJJx1aIhwLIsG77Q5XqjbU
         ezBgDRv28/5yaXJ7/vG4wBO3kbVfhykNdqjN702SpNvsYjZuKs6xCz0aVubHT4rpdGR0
         O1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462033; x=1764066833;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sLfcKj93UvW8wQFZLPKFulahqzWmIOY5Gt20N4P/5u4=;
        b=ERbgdIOQMZ4FjWj0c4s/D/8gXxd5BK/H5+5C3z+6aQvyKaeLloZb/y3tWXAQ7rz9Os
         FgyEwGYli2vy2eNAbtgbY1Fu23xzVZKXosrhgXfSxohuexm9kb1EI7U7OuRv5YdG1oWu
         YJzU+QQDhJLlN2fIw1PnoMv2HblKPAlySLVCx1hMHyedhNRcXkIgcBbGzau8Nk4qvR37
         E43YiBfBDbCIFZqBM2L761bu7a5dMuJvQxLZGbGww4ynXT1iQVZ0CVx1LsZ9p5WCukwk
         YtnPMiZU6nnemdzMAvvk3TzDEa1vf+sFsjqKjiNCkqsza2+w7NuPEIixyfYjrUBQrt+Z
         axzg==
X-Forwarded-Encrypted: i=1; AJvYcCUDi/oAcOpnybOC3Q4qP56YrtJRIvOWY8hJy9zsLfjJMG2cOn3IR/bx4/vbCXDbOxHXANc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywtboc79QB5JVQr5i1HBRlXDp3QeexSUbzFew5TPoilnPBwlTJp
	tIDOM2RqDEbe/dP0+dUqKKY1rpKYvF0yhLiY7cEMmgKhrVIldCUvXoeyATIPsp3MSxaya7xNuTh
	1vg+lb1ZbrASO0VOoHqLSd9tFW4yey0tNSyMvcVY2cGTSUU6vYWqGMI4iAM6uPW1lvZgwOYvB6t
	Je5ycDcEAllCBrogJuZG5ulcLJfaXy
X-Gm-Gg: ASbGnct5tGZlvE7dYi6hgcshhAqf1SCIZVwtftuakPcylMYgFl57mYkxgQyrTcL4GN8
	wXxeaep9N+xYV+1cd8iYXV6A5CtQW6K+jfPpmbuRxJEfBvgt+M4RdEUjmAuQpEAxOd0K5WDsoy6
	qAF66g+6lg51FgVXAff+PI2x8MB8+o0WJCsG+wQrQ30MEq9VzoS2C7PxUvzsV9OfWq3C8J88ys/
	84AEZdfx8Idxr2jirjMDT4VEXJbYF18Ry4ZA3qjTCh2s/8nC7H29m+ErMGO/fmOqeIX7EI=
X-Received: by 2002:a05:6000:2c0c:b0:42b:3806:2bb4 with SMTP id ffacd0b85a97d-42b59342e50mr15470842f8f.27.1763462032838;
        Tue, 18 Nov 2025 02:33:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxs/NEm9CAXsuIkkgc6RzkOy3jDOr/9ZhjLOu8uafI2iz2e5grXvGz9h/5Zbz3kkJwr0kozVVq2uvUePlgOAI=
X-Received: by 2002:a05:6000:2c0c:b0:42b:3806:2bb4 with SMTP id
 ffacd0b85a97d-42b59342e50mr15470822f8f.27.1763462032501; Tue, 18 Nov 2025
 02:33:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-8-chang.seok.bae@intel.com> <ebda0c03-b21e-48df-a885-8543882a3f3b@redhat.com>
 <aRPo2oxGGEG5LEWv@intel.com> <CABgObfaF4YO0Zd5PKJ3u7kRB0engmsSywnzztV8BKm5yUyQdmQ@mail.gmail.com>
 <aRvOSnaUt1E+/pkC@intel.com>
In-Reply-To: <aRvOSnaUt1E+/pkC@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 18 Nov 2025 11:33:39 +0100
X-Gm-Features: AWmQ_bkubVB234uA0C3PnOiG8MVgbvdvJyWgyb5DUR3T-8ExWKOSjypuoZhdMDQ
Message-ID: <CABgObfa-vqWCenVvvTAoB773AQ+9a1OOT9n5hjqT=zZBDQbb+Q@mail.gmail.com>
Subject: Re: [PATCH RFC v1 07/20] KVM: nVMX: Support the extended instruction
 info field
To: Chao Gao <chao.gao@intel.com>
Cc: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm <kvm@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 2:39=E2=80=AFAM Chao Gao <chao.gao@intel.com> wrote=
:
>
> On Tue, Nov 18, 2025 at 12:29:19AM +0100, Paolo Bonzini wrote:
> >Il mer 12 nov 2025, 02:54 Chao Gao <chao.gao@intel.com> ha scritto:
> >>
> >> Shouldn't we check guest's capabilities rather than host's,
> >>
> >> i.e., guest_cpu_cap_has(X86_FEATURE_APX)?
> >
> >As the manual says, you're free to use the extended field if
> >available, and it's faster.
>
> The point is, from the guest's perspective, the field is available iff th=
e vCPU
> supports APX. KVM (L0) doesn't need to virtualize VMCS12's EII field if t=
he vCPU
> doesn't have APX.

Well, it would be faster to just do it. But you're right, checking the
guest CPUID is consistent with other code, for example

        if (nested_cpu_has_vid(vmcs12))
                vmcs12->guest_intr_status =3D vmcs_read16(GUEST_INTR_STATUS=
);

Paolo


