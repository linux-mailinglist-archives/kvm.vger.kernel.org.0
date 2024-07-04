Return-Path: <kvm+bounces-20936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAAF1926EDB
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 07:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E50D281F32
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 05:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74EB0181BAE;
	Thu,  4 Jul 2024 05:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KU05wEWz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDADF200A3
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 05:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720071089; cv=none; b=OIzBF79z4lYugD3lYJvfp+OrLjBhII+xWXviX0M5HGYaMQ08e+8FaPOTjEvwfEIu4zYTSVHnY5VGdEc3CbrOiTbZFrW8oCn0sNtCYVtx2ZJqrL1U4WYo8oytWAeGK9LMTR4kMc2kXx7rDduWAm0u6zfBgXK0VhrgdZt38Ohg/VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720071089; c=relaxed/simple;
	bh=NJs5D/YEQU/uOIEPQnbJW0N706P0dOcexPyILktT0zY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DKiSWBhXcjEcFSnHQ8tVDgOg01pL4YOuwnAfpuyzXmwPyBayhf20xpstAD+oOgX+GvxkQuUge2d3GGYA8stziOpbjicQFRSrrb3Le2lLRJmPlTyHn1nefhis3QMXaNUouU5yl7Sw5lmiK1c6wHiZXyfnGLbQy7ZAdpKhOdTmTcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KU05wEWz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720071086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NJs5D/YEQU/uOIEPQnbJW0N706P0dOcexPyILktT0zY=;
	b=KU05wEWz8oNtx/dXmWoP1A1s0NWIZWPVJRi9zrnMZPyTPKi+fTGtOo2iEr6COoIYk0uSim
	f1IiSEG9oD1uIk3Bd/vOlBpyjbemMYc6H/W37t1JiPs695DeajWL0cnJzcpdmFYoR/1ds2
	QgKkQ4dfeT77DMn+HAbYWSbPPowJvfU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-qeNk2xcsMrSAq0Zyy75OzQ-1; Thu, 04 Jul 2024 01:31:24 -0400
X-MC-Unique: qeNk2xcsMrSAq0Zyy75OzQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4258675a6easo1905045e9.3
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2024 22:31:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720071083; x=1720675883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NJs5D/YEQU/uOIEPQnbJW0N706P0dOcexPyILktT0zY=;
        b=TEIFtMhS735ri2GrZdNDEsxEzpoMpgHP+53e0RLFL3lwokKm7lGFaPe4ECgLuZD0z4
         PrCdc6UnXsb16m9ovRVh5TQLhJNEPSRpjC/zjrLBAowWTRD0HlkE2unR/GCZlEESfPPE
         tOC5UfI4jRpDvdDFgijKfGdFyX4Lsm0FajDUvg3xa3OEPyGTO2CdA8I5hZ6MB+CiPTRq
         2mwxF6AM0Atm/1CVR7JvQWgNyZdfSbjUzssMyl5I0VsaNTWzoHl80pkIiHUU8BN0mpoH
         eijP1nHVTSmZcXoHUCCFCFcyuKpuQhdvkGS5gbzjdJaJFK0ICJdzZbnZ+Tq8/Xmml/tB
         KWug==
X-Forwarded-Encrypted: i=1; AJvYcCV6hgVJ67pGh4wUImg0wr1tZUF99cDMnsRukSHEFA8iaCHOUprwiLTPlwxF/coOSvRh2G0o6R+j2PKHpd1ycVrsLaBi
X-Gm-Message-State: AOJu0YyukvhTEy/WxsO+UZSrbIUe4plFrEJz1D25m8kwGQ88RiXKpQoc
	35XQhBo5FIPs2duCsrt01lLL4q0gJKyrZ6COn2bgVkeffpDlrso5scBuYhnKAy/psWc9NNVlnU4
	w+gJlyKE0mp/AtBZNyxnovA2zpl3nfSYuK0oJWx/TWEWDJz7LKns+7Qr0Uc+X0JeQrSbBthTBRu
	m9DKcsarh70P/BYT767+l6U6L3
X-Received: by 2002:adf:fe09:0:b0:367:938c:29cf with SMTP id ffacd0b85a97d-3679dd7bb2amr388189f8f.71.1720071083646;
        Wed, 03 Jul 2024 22:31:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHN4qOO4AVJX2ozxtZrxzLOJCfNwh8Tfcnyl4JAnING0I6YDodUrCDRYotHu9FIOMH4U6gp+LyKJQAIqfi1wwI=
X-Received: by 2002:adf:fe09:0:b0:367:938c:29cf with SMTP id
 ffacd0b85a97d-3679dd7bb2amr388175f8f.71.1720071083285; Wed, 03 Jul 2024
 22:31:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-21-pankaj.gupta@amd.com> <ce80850a-fbd1-4e14-8107-47c7423fa204@intel.com>
 <20240704003406.6tduun5n25kgtojf@amd.com> <213b9762-205e-4d48-b7f7-1948d0f3b0d9@intel.com>
In-Reply-To: <213b9762-205e-4d48-b7f7-1948d0f3b0d9@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 4 Jul 2024 07:31:08 +0200
Message-ID: <CABgObfaBa854ugUOHA0GUsfS7M=_XqkaPkAoYHVtwRY-0A0pPw@mail.gmail.com>
Subject: Re: [PATCH v4 20/31] i386/sev: Add support for SNP CPUID validation
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Michael Roth <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, qemu-devel@nongnu.org, 
	brijesh.singh@amd.com, dovmurik@linux.ibm.com, armbru@redhat.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 6:10=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com> wr=
ote:
> > So there are specific ranges that are checked, mainly ones where there
> > is potential for guests to misbehave if they are being lied to. But
> > hypervisor-ranges are paravirtual in a sense so there's no assumptions
> > being made about what the underlying hardware is doing, so the checks
> > are needed as much in those cases.
>
> I'm a little confused. Per your reference above, hypervisor-ranges is
> unchecked because it's not in the standard range nor the extended range.
>
> And your last sentence said "so the checks are needed as much in those
> cases". So how does hypervisor-ranges get checked?

I think "not" is missing in the sentence.

Paolo


