Return-Path: <kvm+bounces-52743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DBA7B09038
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E6E43A7C44
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 15:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC51A2F85FE;
	Thu, 17 Jul 2025 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRji+yni"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D572F8C26
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752764978; cv=none; b=X4Fsp/KVE1LA70P4CxG0QQsRKKTNAaoXDcDjaaPLfqZTbY+UXD9ns1WZXund06YOjC/kvYpG2O/zvpI0N8PusG/l1s56SVnNZumyN0nxaPwQ590PDEpGPq1k/+B4Fikxvx4WfeYZ3zbLzNXayd4t4fIYcikQiMC5u8fKAi6m4fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752764978; c=relaxed/simple;
	bh=IA6hJ8fgk1AyBaXpasI0OEb+zaqxzjcAhTHfmZbn060=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kf1NhYWaKSn2OHBvWUePIGdMqWm31ReRUhyiVF7P4YAGOP7xJlssZbJGH8Ea9NCc8BB3Mv5/x9nahGqV9vY6u9RJCRDsyUH4/l6Z/OqmRUVNWdmOQi8ObiEIqeiiujXUCGv48OqMbKVjWUFIHqiP1l8a3UF0hdi5cp2QfWih6hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CRji+yni; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752764975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Fn7xRL6bLlxNhOzMEOLtOPne0YN9nCk/GsGQrXpg2I=;
	b=CRji+yniMjE44KE8PV/hv+QRu+lpru743V1MLhRLFu8ThH3xO+lqQlGfP6IBsEMeBt63iK
	rGijiZJmSlx9aiH2Qfk2i+skXu5T6rG9uI8CBX4S3VSHM/BDIz7qUwkoqtKwgcO2ppXMPE
	RpaFRJ3lSvy5mAX6m5mf5POG50LbzY0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-rZ3aRYhUPMKPam7HXMoV7A-1; Thu, 17 Jul 2025 11:09:32 -0400
X-MC-Unique: rZ3aRYhUPMKPam7HXMoV7A-1
X-Mimecast-MFC-AGG-ID: rZ3aRYhUPMKPam7HXMoV7A_1752764971
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4560b81ff9eso6501005e9.1
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 08:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752764971; x=1753369771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Fn7xRL6bLlxNhOzMEOLtOPne0YN9nCk/GsGQrXpg2I=;
        b=vBLpYE2CetkJGJnClBk10JEuZdDkTFUmtB4C1WGOLdlicseMNvQ5yVi5ye2vNgg1D8
         gmTa6COcuKx8+CMQE2vAPEGQ4GfA5HOSp34GxloQ4Qce4+uRqS3VwAOED8OfqQehBVbf
         ecTKrhvKIYWSRAb97aUrA6TgGoq+Mk7QBuiDPCQ42YvtZsl/SvfD9rIUMUyupxQioWAA
         tFtr53bindXa8TOjP//YBXIhEVKWSBiH2ZQcSpN2qZdFxAvEaXVtwz/QVgcneMIXEHL5
         uJqMPvtrRiWQV21TPMcft5MXiqmeE79v+4r+1+6JgO0yRAuNlyLm9jSLgwAcRnskDZfj
         oPhQ==
X-Gm-Message-State: AOJu0YyCx8eoHkKJk/VaP0u7/+Bwteg39KpoPG1ySZnk79oaUQ6qpBRF
	71NOTlmivbWFlno8Mnj6pHM6jIEor81caHDxDSGlT0g5p4BLE/WTQWe0/lR+tKP5q7ueAeXAOJk
	3BxasYAN+txW1QvbWcExLoeFFgNYSGmRCJlQIDUTufnIMOlMI9QIYosIzsJB/pEdGzcQSegTVWW
	lg8TaRHoxDXlEEVWQzMnJ91mNNJdnL
X-Gm-Gg: ASbGncsaoGjofFCFhTVi/TFynq9V4zBv1/kHTlTQ/crx7CU1GKiL1RxvtvQlWiLc/zS
	PlWrNfk3OlbDGkaMemSYiyIijtmF4Mm+eknvLhNQ7Xyr+rlyV8C2NNbo5cKdlcnJr7xzUz6tg01
	Aj4Umhpsg4r+J+6u+zmPwb
X-Received: by 2002:a05:600c:c0d6:b0:441:d4e8:76c6 with SMTP id 5b1f17b1804b1-4563555411amr25411765e9.30.1752764970193;
        Thu, 17 Jul 2025 08:09:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/eDCYFZ31kfW66xBYa23IRr7lnoMRdbHvAeO+KWjHezuj1xUaatTtuMMBTxbexFZiFdmY/UfsgRxVZ3wmS+I=
X-Received: by 2002:a05:600c:c0d6:b0:441:d4e8:76c6 with SMTP id
 5b1f17b1804b1-4563555411amr25410695e9.30.1752764968623; Thu, 17 Jul 2025
 08:09:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717145216.85338-1-seanjc@google.com>
In-Reply-To: <20250717145216.85338-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 17 Jul 2025 17:09:16 +0200
X-Gm-Features: Ac12FXxfMGmUyfYf47rUsqzffL2EJJRz6ZT1rNUJcFMZJsGXn4IB4FR2Bs823Rc
Message-ID: <CABgObfZ2eDbHC53nQ=OpCtr1=U1wtJn1qsBUTBBoBq0442xc7w@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: TDX fixes for 6.16-rc7
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2025 at 4:52=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please pull three TDX fixes for 6.16, two of which have potential to caus=
e ABI
> problems.
>
> The following changes since commit 4578a747f3c7950be3feb93c2db32eb597a3e5=
5b:
>
>   KVM: x86: avoid underflow when scaling TSC frequency (2025-07-09 13:52:=
50 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.16-rc7
>
> for you to fetch changes up to b8be70ec2b47ca62ccb54dc3c2ab9a9c93653e00:
>
>   KVM: VMX: Ensure unused kvm_tdx_capabilities fields are zeroed out (202=
5-07-15 14:04:39 -0700)

Pulled, thanks!

Paolo


