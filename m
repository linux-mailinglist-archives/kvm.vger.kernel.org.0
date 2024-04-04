Return-Path: <kvm+bounces-13537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6208898686
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 13:53:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21FFC1C20F93
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 11:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAEB384D35;
	Thu,  4 Apr 2024 11:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQ4Al3Kt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4AB59B7F
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 11:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712231620; cv=none; b=nkYloxVGad3BFGL2rGtjmqKTXPcPqAeczXlPAIwx31iT2P+P2siKwK+BYhbFdiHlLEWPtg3+GU9SiMp6GY/OsDgPHjcL8KnvafMnilCP3Xvn0jbFs222cT0NXONDK5+fu2lrQVCtvNIjJubt/hLiFWA7eBaROSYZ1mm6s0kRmt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712231620; c=relaxed/simple;
	bh=g6Px9tlSXBxUzorbMkQXJNo3nNSoY0owCkx1nBqEoj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ikvPqX1zLVVAOrAoV+ZK8UNt7ud3AGw27FBjYpxr91vzj512M1NRVyf81ORyvnc/iYspqlMGNrQ/p8pUfPfKxNTyoiq6COYQ14fmSa51cEhsFaL72ah9HGgA/oh42Jvh4e/thMQWH/jrXoANFwoxHfVFNHaR3fMjTES9tPMiJio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cQ4Al3Kt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712231617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g6Px9tlSXBxUzorbMkQXJNo3nNSoY0owCkx1nBqEoj4=;
	b=cQ4Al3Kt8a7aPkLz6SyedDEEHlHXUsoxOQfjIFAwYLysAqUITHdXyEO4HWZ+OLdT+oHQxu
	9owMmp6mvXXl73A6jxZlUfLdlRYcrYbNOyFe8Fq3bsQSPNkascWU15VDO6bG1mmnf9fEvK
	yCaFfIqsK5p3Jvp3ZzxsTp3mCqqcX+4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-LM9rCY_uMkGnN0wZpdeYJg-1; Thu, 04 Apr 2024 07:53:35 -0400
X-MC-Unique: LM9rCY_uMkGnN0wZpdeYJg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-41552c04845so4183935e9.2
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 04:53:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712231613; x=1712836413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g6Px9tlSXBxUzorbMkQXJNo3nNSoY0owCkx1nBqEoj4=;
        b=URidA+tOv7hyLnP4Hxx+3SiHpDDaqJswIkzmTiI7hbwMhSrowGnuFPlxBTSfYL9Ow2
         Uu6dVfT62OrrfrWAhovUn8ipHPBJWziETwa2PI8RFPUCV4bOH78r/nFYS4tS4anI4bza
         ImcN64OJqKS3XUtuxRyKx0qGqAvMeer5bTIquvR06z60w8AZ63h1Xpxb0foqNSA1RjUj
         sbsy9jUceZecx9xTd9x5AOM/J/wyZ6c0awmFR2xfELIxolYF/apJzOeDcgDBwajUoLuA
         28pNxdntQ7o1aB9dKEr1A7MpQa0KUzVAhUGWRDlChcON6NbR26mM4yhsmrFYAMID9Lx9
         I44A==
X-Forwarded-Encrypted: i=1; AJvYcCVMmbBCkWLDTbBGpzje2v+gltetKZOL9VqoF4Aj398CH7kEmwyGRg0BZ1RluMa349Xs9SwpzqcGeiE0y2KuPkVZ3Ia+
X-Gm-Message-State: AOJu0YwdZSsC536qMTnQu+2B5WcKfaXIPaFkkutmqOvBesCDG2ob5HAb
	7d+cWr43F3m/0T93s751VFCg6wX2w+gQFRlcsTnd4ULCzsoezplPLDtXr+rSfbb33MqBJ0rr9bk
	4ZKmlZFXByCZWbnZM9LqNiCOCfMSkPMKo6TB+b4b9/v7O9evB9Z9wsGwtcnTfUG/0UyTnX+syXq
	vtVXKA0BrUp0NETWHRtzDv5+BYQkiG1W2G
X-Received: by 2002:a05:600c:3586:b0:415:54d2:155a with SMTP id p6-20020a05600c358600b0041554d2155amr1787068wmq.10.1712231613727;
        Thu, 04 Apr 2024 04:53:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESEgkpGiuslXRhwuv9Ia0bzlGOZuvK1wVw34I8Lmio84RtnHXGCk7Boo8hw/o3eDIB5LCNP1M5YAVa/U3N3eg=
X-Received: by 2002:a05:600c:3586:b0:415:54d2:155a with SMTP id
 p6-20020a05600c358600b0041554d2155amr1787056wmq.10.1712231613436; Thu, 04 Apr
 2024 04:53:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240318233352.2728327-1-pbonzini@redhat.com> <20240318233352.2728327-10-pbonzini@redhat.com>
 <20240324233918.25tsnexp3rlnhtaa@amd.com>
In-Reply-To: <20240324233918.25tsnexp3rlnhtaa@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 4 Apr 2024 13:53:22 +0200
Message-ID: <CABgObfa3UQd7LqWh0SYgFjxCtKiq64yHycw7LEu1h_1F0=Q4Xw@mail.gmail.com>
Subject: Re: [PATCH v4 09/15] KVM: SEV: sync FPU and AVX state at
 LAUNCH_UPDATE_VMSA time
To: Michael Roth <michael.roth@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, seanjc@google.com, 
	Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2024 at 12:43=E2=80=AFAM Michael Roth <michael.roth@amd.com=
> wrote:
> There may have be userspaces that previously relied on KVM_SET_XSAVE
> being silently ignored when calculating the expected VMSA measurement.
> Granted, that's sort of buggy behavior on the part of userspace, but QEMU
> for instance does this. In that case, it just so happens that QEMU's rese=
t
> values don't appear to affect the VMSA measurement/contents, but there ma=
y
> be userspaces where it would.
>
> To avoid this, and have parity with the other interfaces where the new
> behavior is gated on the new vm_type/KVM_SEV_INIT2 stuff (via
> has_protected_state), maybe should limited XSAVE/FPU sync'ing to
> has_protected_state as well?

Yes, in particular I am kinda surprised that MXCSR (whose default
value after reset is 0x1F80) does not affect the measurement.

Paolo


