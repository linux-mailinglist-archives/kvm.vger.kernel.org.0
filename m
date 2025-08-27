Return-Path: <kvm+bounces-55880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78028B3836E
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 15:11:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97B8D1BA6A56
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 13:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F584352085;
	Wed, 27 Aug 2025 13:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KsgBNfjf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF8934AB17
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756300302; cv=none; b=ct/+7To8VO7kmBnx5VE/rNtsd0VC9G9/S8Yw/qmohX3DiyhTxU1hhuAFNbDDJiFka7+DzYwjA6Hbb0YTxWHOviSMwqeuXs170gac3tdnh2yjK6YqPJ4krc4J8INY7HAQoBVOvE023N5JsP4k88h7RNwayKHCTTSdPxEp+2aYCNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756300302; c=relaxed/simple;
	bh=YdlTsQZNNrmq7u3Z5M5rk595Ss//u8ZKePXJNnxhb1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uLNEUO/6nGXV3HpXH5pm5/Pmrr7740jJ0V9bSzAny+hus/E88/Y8zYlp2CQrhosM3AvVpLU4+pslsLBKceE1hp2o4sKT1MlPOUKQQ1gTtPydd0qfB2OTtQwZJXrPfJLgjTQW1cwTTZRf2DzkW6fJVCFofF7NL92zm5Zvis64ab8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KsgBNfjf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756300299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdlTsQZNNrmq7u3Z5M5rk595Ss//u8ZKePXJNnxhb1o=;
	b=KsgBNfjf/C56wKrrAjdzI5LbfhlMU38iWjWx6KYJORwj0yBnRxCOE0jvg8f+rcn27VTf/A
	W/svys0LiBziZxYu7G8/kmoOGvjhUq38x6PF6ha8rCyQpTq9Lr727w95QjhmARW0LXR9oo
	RCTe3og5vBfajyT6VycaACforChRojU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-LB17raQtPz6sX-oLvM75YQ-1; Wed, 27 Aug 2025 09:11:37 -0400
X-MC-Unique: LB17raQtPz6sX-oLvM75YQ-1
X-Mimecast-MFC-AGG-ID: LB17raQtPz6sX-oLvM75YQ_1756300297
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9dc5c2ba0so2574516f8f.1
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 06:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756300296; x=1756905096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YdlTsQZNNrmq7u3Z5M5rk595Ss//u8ZKePXJNnxhb1o=;
        b=GR0zDEsPy364oU/C545dfWy49BtOzlKWMJyTLyEgW58SGk02ZJ58I3+ftPTEnNHZb5
         7ROKLjA75OKrGrOlF5EJuubKZaqMfL83wzQsLvV3AWJXgPRXKFrGqwX9hA4Gos/msmLr
         GO/Pe0KW3Z4nHETgirFDclLEul2d3XuX/eJSKJZjOJ0AB9dooMLGQp7GLQ4qjvKC49By
         26n+q188D5idX2JPXtiull0CoqSzhyIg8mdp5TTNN8nOYkdOFceZIF0lpbNl3k9yvXkK
         i03IPHkmG/5sEBnf/2AF3dmh3TPBv/r+Qm9bwT/DcqXQtXr6ViAxGJ5b40bOzWMm8EnM
         8fYA==
X-Forwarded-Encrypted: i=1; AJvYcCVZJQ8O7+liELNGgGH+tWkRMZX41vaYDYmYnsEZ243aXQaHK1zRbfFVkjH5SlH+oVUqYV8=@vger.kernel.org
X-Gm-Message-State: AOJu0YygpzA7kgSS8xLVxIt1I0ZIfoghBQnh1c833nL07UJs6wQcaIqd
	J3MkvNZCU7uasUl90Wtjhaa2Q2C1wT0JkAays/7mxIfCOR3iof7WI8P6hgpnn9M34RGDLsQ0Sd7
	qRjvXIDpQYZ80MfaHpq7jtmGMyzaMdZovgKRVNH4uTCy6IhsmzPySQN+ftuxEBkDcnGrCIFp5SB
	P3+deyYPpuk4z80RGPUVbJgZpvocWx
X-Gm-Gg: ASbGncsDn4pMZu0wbWaoSjhSs5of8QGQSXtTzT7SGczNZ6Y5oZKml4I3QA60biaZZo6
	eZMhmQKwhxDiycT0X8wfq1Y+nUKAhsZ4ZE3iKjDTiicIaSyWvxeUIaAE4JnXEUm6+Ra9lrC8PS8
	QrZT4RDhS6OOrvb96TAUU6Q5vV91pwe2Jph9d5Q3tw5D6RdxuYy4vMs/In35PDPaSdVdEEkDym5
	UGP/GD5aLLc754eRq2Cl4Iw
X-Received: by 2002:a05:6000:144f:b0:3c8:6b76:2ee9 with SMTP id ffacd0b85a97d-3c86b7633cbmr9046549f8f.19.1756300296514;
        Wed, 27 Aug 2025 06:11:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIu95W78Kd2FcqoAMBmRWc50Pfjv6n3rRZIWnWs3jErMyKSztWJGNEOWQHM3H1SLdXfBJS+ZjUc6qHuPBUxAQ=
X-Received: by 2002:a05:6000:144f:b0:3c8:6b76:2ee9 with SMTP id
 ffacd0b85a97d-3c86b7633cbmr9046516f8f.19.1756300295999; Wed, 27 Aug 2025
 06:11:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <87b10d94-dca2-4ecb-a86f-b38c5c90e0cf@redhat.com>
 <86frdcewue.wl-maz@kernel.org>
In-Reply-To: <86frdcewue.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 27 Aug 2025 15:11:22 +0200
X-Gm-Features: Ac12FXyek3cfAXJUDvWryX-P1WU7M6mjVSZlZC6o5IXedOpceLYmHnNxWJaWG74
Message-ID: <CABgObfb21UEZf4aQVv_-v3uFCp08G3SWhoTbpmSFz7qL0Xm63w@mail.gmail.com>
Subject: Re: [PATCH v17 00/24] KVM: Enable mmap() for guest_memfd
To: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yo can

On Wed, Aug 27, 2025 at 3:08=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Wed, 27 Aug 2025 09:43:54 +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> > Applied to kvm/next, thanks!
>
> Can you please create a stable branch for these patches? It is quite
> likely that whatever I queue for 6.18 will conflict with that, and I'd
> like to be able to resolve the conflicts myself.

You can just base kvm-arm/next on kvm/next, but if you prefer I pushed
guest-memfd-mmap at https://git.kernel.org/pub/scm/virt/kvm/kvm.git/.

Paolo


