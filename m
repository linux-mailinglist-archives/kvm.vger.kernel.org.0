Return-Path: <kvm+bounces-24586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E640F958185
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3161283A07
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 08:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57CF18B46B;
	Tue, 20 Aug 2024 08:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J0xEEnAt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C3818A928
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 08:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724144276; cv=none; b=kHOk7qbCAj1KMNOBWMiFU6cUO1VSMGcJresV6oRaqWzX6bIT6pVNr07JkpOF/9ZfS5zmBKQT0/zG/wqFCQf2Y7Zo9HHHZ8euQkO1m2fGvP3mv/E7roedjAgFhAmeHS67yxp1oyPuu8qO/gFXo6mn46X+Fm0jSp9EqrPRd/RsKy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724144276; c=relaxed/simple;
	bh=xjkK7iK5CvjdhuUb97GVoGF/BjUcoUNxCzEB6tB3sNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p7kfwaxaioPxOuwIqRTRjd0OceFCMjivpDNTIYni+JITKzSEEaAisZ7VXDeiCLkBLSWDHo6brWNQTu5v7lnVJWIDGQgf1mssBKlvz84glkJO9Vne5UV8Z7Buq4zwufeftmE75xykY9207rzwd+Akjp3oX7haz/yYLP8zZxs8uj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J0xEEnAt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724144272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjkK7iK5CvjdhuUb97GVoGF/BjUcoUNxCzEB6tB3sNQ=;
	b=J0xEEnAtIG2TSxHzQSfAYtk8PqlFocqLbBdr+enn2dhmW0On2FgJZf6Bhy0mfq/D3hfRbi
	yppd3uJJLEwZ0cqgGulC1Ez1RDZl2SLlhYvzOfufbIl2IX8hb7OlCb/b+D6CBDZb7TPTB9
	iRyLQ8+/XX0Ph3uNukMJxniYNbR+yxs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-Quk-Qr19M2KxEyhGYYD1QQ-1; Tue, 20 Aug 2024 04:57:50 -0400
X-MC-Unique: Quk-Qr19M2KxEyhGYYD1QQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42808efc688so44580475e9.0
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 01:57:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724144270; x=1724749070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xjkK7iK5CvjdhuUb97GVoGF/BjUcoUNxCzEB6tB3sNQ=;
        b=mqpASMF5Tg4yZ73HBN+iFRnMRLAkk2aybHkdyd7Ckfrm6l34Seo2htDbXd7uooZMC6
         ekUvmTpZ8RQYT5d4mjJUyRUqCLBudPl2Tjmaw7lE92SiNv5cTqTNZjxqVfUg+ciPep8B
         g93bYrp90/jOSkKERyLhgH5rMKMwVKQ/NIBal7LVKwXNRqcloyArZv5qbnF014XAcSjG
         Xn8/FHGPvG+kOE3THUrUjUi37hU1uTUNYlSj483HIWDUr6u7DKdvZx213/jlesI4gKNj
         GWnW9nLY2AkHFsR4VpeMfsR+MORLpbVs5C0fkI8KgyUm6GSnVsNx7siGPOLCNbfPuGWK
         OOQA==
X-Gm-Message-State: AOJu0YzZTO7sv/C/oeSXco75d68oRvYL6temTdZWeoB3iWbrWJxKzYr7
	GNYv4S333x7PzgW/wlVyMjUTDfN2HfVguv8zrav9T9gsSUfkbj7aZzeNt/tQcXwROb4HO0L/6AH
	Cou+thNZANlBVSGBICyaUXQEiFBM3eTlFqbxjt3go5ctA8qm7qwekbuzpqLSCDQaLgJanIIWx9M
	xFBVTHR/2j6MDEZ3SgZ6zmPh7D
X-Received: by 2002:a5d:6784:0:b0:371:7c71:9ab2 with SMTP id ffacd0b85a97d-371946bf3f5mr7728109f8f.52.1724144269567;
        Tue, 20 Aug 2024 01:57:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfN1DEa323emO5ciFDRq0ln5Ny7asNboij5b1hAStv+/CqQ8O7DlNLw/FVnkCMNUHeYkReZHjR71EMG+jD0E4=
X-Received: by 2002:a5d:6784:0:b0:371:7c71:9ab2 with SMTP id
 ffacd0b85a97d-371946bf3f5mr7728092f8f.52.1724144269036; Tue, 20 Aug 2024
 01:57:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com>
In-Reply-To: <20240608000639.3295768-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 20 Aug 2024 10:57:35 +0200
Message-ID: <CABgObfYNtyVnOYcpDVLNF-vuN0Caqump7dkgg9P6xQkMmzMc9Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] KVM: Register cpuhp/syscore callbacks when
 enabling virt
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"Chen, Farrah" <farrah.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 8, 2024 at 2:06=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
> The suspend/resume and cphup paths still need to be fully tested, as do
> non-x86 architectures.

You can add

Tested-by: Farrah Chen <farrah.chen@intel.com>

> For CPU hotplug we tested this:
>
> 1) offline some CPUs;
> 2) load kvm-intel.ko;
> 3) run a VM;
> 4) online those offlined CPUs;
> 5) offline those CPUs again;
> 6) online those CPUs again;
>
> All steps can be done successfully, and the VM run as expected during
> step 4) to 6).
>
> For suspend/resume we tested:
>
> 1) load kvm-intel.ko and run a VM;
> 2) suspend host
> 3) resume the host back (using the IPMI KVM console)
>
> All steps worked successfully, and the VM still run fine after resume.

Thanks Kai and Farrah :)

Paolo


