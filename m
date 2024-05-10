Return-Path: <kvm+bounces-17188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AAC08C2723
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 16:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDEB71F2572A
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 14:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB95A171088;
	Fri, 10 May 2024 14:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XHMYKaIs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917F0171086
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 14:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715352642; cv=none; b=ThE/7u3T6pXD862yCsfq2KcYlY0GNAG6Hf/yodKEPlcJWUBs9ziXwwYOPz51VBlXlD6NN1s0Qiu1A+7ceB/8PoA1dZX5mApri+L1YwBbPsa9xz2vlaAlGSU5dURtIi6myC5yyxqhP/RHhIqefZaj6+G+ghdOFvNZ/q6Rbbue8U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715352642; c=relaxed/simple;
	bh=6UpJsf7UyarweIVesoXQ1oPyfYbgvJZxUcn5M1EZCWw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RLbvOp0M5WKeF6031Rd6bB9U9DZiZWvZfaBnC/IRP3knx0TORhMXcfXZc08utEbOCB9OueJesTez/XX4jCz0GQ3bzUrIijxhbLqvGWxx1TlWYSG+FZcOLU8AQcHroEvk7hsb6Tg2RVV4DlzNWUGyLNdpUDTXjGgzF9UivX+eRK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XHMYKaIs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715352639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1J0ZSCx1DHXXQYVs6q7rCMNMDZdThCHrefX2O/j3bYQ=;
	b=XHMYKaIsEUcYykOKAiiepbut2ou2JvjcCu96QmQN4W2xXE6UY7qbBh6F6Weq5exEUXqEmU
	reTmsqe9S2fXMBtYJGpUR+HcVdv7BDO/huqdc19lAhgwHxDnAs6u3bcO+Q83sY+iMhqpZ5
	FGydOVoyC4MVdQmwftXw79vGqdiQZSE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-yDAg9V3TNciRy4GqWqBv6Q-1; Fri, 10 May 2024 10:50:38 -0400
X-MC-Unique: yDAg9V3TNciRy4GqWqBv6Q-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42000e6e9ebso3520625e9.0
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 07:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715352637; x=1715957437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1J0ZSCx1DHXXQYVs6q7rCMNMDZdThCHrefX2O/j3bYQ=;
        b=eHe1Q7PmtDDfnILdrrRAqO8TQqLuu26czgwkdiQaxLYRrd3aDd9fPsHeIBuAImR3cP
         CMEh1JqtjQtJ7CnUfgBmywwdwNZ++3Y3rg/dvrf7Zby6xFPDg2UECpYW122B/Kwoi46X
         MO8DHkt1ycs5Z3VCobp+AR+BGmdqe7waWjo4YII6r+Q9Z0JdwmcqDm1OvJhuPdpiLKCl
         f94u1ClIDrktBzsncFlKu8XAcmpsezqqmQVQkP1F6o4HWEV8QkNpKrnXWDsRD7Fgr5BQ
         4v/ZTTlN+X1vSwEhuPwvSB5EbUmO5YsE1ru62J6RHCy8JuRpcHBebs5wVpve4IglHsSR
         8QRw==
X-Gm-Message-State: AOJu0YybaRUo0cSo20t5BqMHZtymw8gDpMcUCsuGARlJq2KilFNFs+7W
	YOmsdqfUCW7gyA+O4uTDOjqb4mbD5qg9OTbm98FAcR3LQIgVjWLaFCNE91ALV50JAI10Q16Yi9B
	FQaBFgVvDCmkH92uH/h6dUrN51wVfStKcUMFlW/Hcq9DW9v+Jq5hg1I7b4wAxKtY3rh9d2cWCzs
	p4CE8fhxjWq420aLxIjeAaQjuK
X-Received: by 2002:a5d:4112:0:b0:34c:4d98:d6f7 with SMTP id ffacd0b85a97d-3504a73780fmr2559552f8f.26.1715352637043;
        Fri, 10 May 2024 07:50:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSIQotEMtylPZf743WE/QOLPBLsjbYAnMkg65qQbs7/jDa5Eg3h+x7J/bK/Rbl+YVAyOJn6KccrUXtbyh67pQ=
X-Received: by 2002:a5d:4112:0:b0:34c:4d98:d6f7 with SMTP id
 ffacd0b85a97d-3504a73780fmr2559538f8f.26.1715352636706; Fri, 10 May 2024
 07:50:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240423165328.2853870-1-seanjc@google.com>
In-Reply-To: <20240423165328.2853870-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 10 May 2024 16:50:24 +0200
Message-ID: <CABgObfYYm_xwEFjNx0jzaVg2R6s1D5EWC2T6Fx-d++8=6nvm1g@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: x86: Fix supported VM_TYPES caps
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024 at 6:53=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Fix a goof where KVM fails to re-initialize the set of supported VM types=
,
> resulting in KVM overreporting the set of supported types when a vendor
> module is reloaded with incompatible settings.  E.g. unload kvm-intel.ko,
> reload with ept=3D0, and KVM will incorrectly treat SW_PROTECTED_VM as
> supported.
>
> Fix a similar long-standing bug with supported_mce_cap that is much less
> benign, and then harden against us making the same mistake in the future.
>
> Sean Christopherson (3):
>   KVM: x86: Fully re-initialize supported_vm_types on vendor module load
>   KVM: x86: Fully re-initialize supported_mce_cap on vendor module load
>   KVM: x86: Explicitly zero kvm_caps during vendor module load

Applied, thanks.

Paolo


