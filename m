Return-Path: <kvm+bounces-17967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1318D8CC457
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 17:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 447C01C210E8
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 15:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD28C141995;
	Wed, 22 May 2024 15:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKv/4yVe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999DF13FD8B
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716392757; cv=none; b=L3aGnOs1UyRvDM0Zsq4olNhWxBods7+JSAGZbxixRQ/Eqm+eZqNsSGfdmcIQnldNmT7Fj5Zywl/ItMmEWIfidEGOc9CoYY2skll/5iiBvYQqYzbS4D3AN6wQjYIzNgdg8Wd3jKR6uhjmQG755zYJi7tiTXAQeOMqQ5NR+b6NkpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716392757; c=relaxed/simple;
	bh=Mdb4OhrS+xxduGqCQenQjyZiiOEqWnw5Chesp52+Cyw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e3xtIIcYFbmw2zggrAWuGpqOm9f8+Zo1hS3JG1dVcguP8VF3sERdL9xxhE9gsbnPWRyfYpdtK9xoGkAr32U4+BkdiZEm7zh8X6l2D+l6ibDJV/l0UEkDHJ3rHkjHB8bg24yROGsvJwWXAKPhyatb/EFfIPSSOCw4AtYSIc3K4SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QKv/4yVe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716392754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mdb4OhrS+xxduGqCQenQjyZiiOEqWnw5Chesp52+Cyw=;
	b=QKv/4yVeeS8PbxfQ7qHbchV7KGewnrGu3vbxOKuriyvFi+p9I1mlIBjblY/0dFlXhkEC8S
	/uYMvUlGNeRrImIeyHFDG9luTpTFLq9lh+0kv7JVYPLco7HMCsL2x0tcGOqHhRTF0aRxI7
	uuhE3eJXfXZyTpJ72JbCD4904oISyZE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-yg2_UYO7MJ2v0-dtvzJuaQ-1; Wed, 22 May 2024 11:45:53 -0400
X-MC-Unique: yg2_UYO7MJ2v0-dtvzJuaQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-354c7c04325so588487f8f.0
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 08:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716392752; x=1716997552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mdb4OhrS+xxduGqCQenQjyZiiOEqWnw5Chesp52+Cyw=;
        b=RruEznl7GvkjlSP4Q0v738IGCBuzTzelixdIKwYeO7WKmVMv5vFYRI1LDgTFjKtqR/
         +o5h1mxbUYq+jEX7Ki7tn4DUa0WvXyzPwYfYUw8dgynzQHLqGHja8ecm1kkKICc2JsYl
         kxVByloIGZvYpG5tG+iS+4hM1daNGGUem98tBD6/21htD7Uv8rhotv8lEtyymQm2Jeyc
         eyyz7aw/GVew3BYs7KwY10Duw0oGcztrC1jIKnsU9WTJXlVLhitySaLCX6n6MvsH7GM5
         rx38fGZH3bt0V7AXne2mFY8Ut0apN0Vn12SRzbLqWB1crfYNtlfMIl5j878UgLYDdfpa
         4vRw==
X-Forwarded-Encrypted: i=1; AJvYcCXPawQrASC0T1FBPiyMRm53gMgsmIOHV0SXo12F+QrFRj/0ayKiopclw/77PlSzW5a1eQqdCuNVSzmUesd9YxNdE7dQ
X-Gm-Message-State: AOJu0YwCV4WpFxHPuXZ/lVW/7Ed9SSNdyGXa2KbqTD9NelOU490+WFqY
	9FuAd1jlnLjKmqGz9U16ZDvsfLEInufg7l2NsyvoIORXbczhGNNQBur0AtlszsKE/dvDZTPUOXu
	0Eg36MNf6o1m3sELCeMzM+aZmmsZy9W0oBxxdPjVbxql/ZA+gdGhm270QpI9yqtH68Tr70nUHhI
	1SrhUOM1c2iStPYoLSENg31eEi
X-Received: by 2002:adf:eccd:0:b0:354:f452:c99a with SMTP id ffacd0b85a97d-354f452cc09mr512933f8f.25.1716392751884;
        Wed, 22 May 2024 08:45:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFu6jDF0/N1JzMpNdLFgCRDbMRMnB/WJd7oq/LlNSDUtsAaagfukeItFC0VsQV7unOBGexMVYUOFO7FNwpI4uE=
X-Received: by 2002:adf:eccd:0:b0:354:f452:c99a with SMTP id
 ffacd0b85a97d-354f452cc09mr512909f8f.25.1716392751401; Wed, 22 May 2024
 08:45:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZkUIMKxhhYbrvS8I@google.com> <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
 <ZkUVcjYhgVpVcGAV@google.com> <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
 <ZkU7dl3BDXpwYwza@google.com> <175989e7-2275-4775-9ad8-65c4134184dd@intel.com>
 <ZkVDIkgj3lWKymfR@google.com> <7df9032d-83e4-46a1-ab29-6c7973a2ab0b@redhat.com>
 <Zk1KZDStu/+CR0i4@yzhao56-desk.sh.intel.com> <Zk1ZA-u9yYq0i15-@google.com> <Zk2VPoIpm9E6CCTm@yzhao56-desk.sh.intel.com>
In-Reply-To: <Zk2VPoIpm9E6CCTm@yzhao56-desk.sh.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 22 May 2024 17:45:39 +0200
Message-ID: <CABgObfaq4oHC9C_iA2OudmFN-7E9RDiw-WiDu9skmpsW39j0nQ@mail.gmail.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024 at 8:49=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
> > Disabling the quirk would allow KVM to choose between a slow/precise/pa=
rtial zap,
> > and full/fast zap.
> TDX needs to disable the quirk for slow/precise/partial zap, right?

Yes - and since TDX is a separate VM type it might even start with the
quirk disabled. For sure, the memslot flag is the worst option and I'd
really prefer to avoid it.

> > I have the same feeling that the bug is probably not reproducible with =
latest
> > KVM code

Or with the latest QEMU code, if it was related somehow to non-atomic
changes to the memory map.

Paolo


