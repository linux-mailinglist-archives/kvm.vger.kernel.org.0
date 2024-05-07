Return-Path: <kvm+bounces-16843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CCE8BE6FB
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E158B2832D2
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB28D16132B;
	Tue,  7 May 2024 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rvvu9Tvd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC26B15F414
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715094510; cv=none; b=CZPlMWg6dv3EtHZFJDOh1VzSL8GCScxX/m9POtHatvXc7l0U8rTUy7nW/jzFE9B8jhnGGC/tggr16e0QXy15sefg4RJMqShPMq0RTTgI/HICmt1Jci1mFbPZOhwVBrZSmZqeD5Wa7JDjTua2HoVEZWLti6oBN6D/v9few88xB2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715094510; c=relaxed/simple;
	bh=etFllyEupyaknEFf+lcPrCQd6nzzutaeEMKfMlLm/30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=egbLLcCV8Hyg2WZrL4wRPaLpt/wPfqv77lHqniAym81+7c4tIVc61UOEqKnKjLAweSDo5lCItQmBJlXs7JSvW6hgkmIVEWSiFSBm+wrrgGlDnzwlg/mT8WNotYAJYO2iK+k8QVUo7v17l9/xfSOUsVa2FwGKF3bBbvv4EVy6vjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rvvu9Tvd; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64f63d768so5861891276.2
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 08:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715094508; x=1715699308; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XIQy57nw8js2S4anIYd24L9R1IqwqfbqyoiYCyYOBxY=;
        b=rvvu9Tvd3egW8lGyezAGdrLE+g/wU/xLOQeoQKoncJiHbIx0X+UN2+TnnXPyY+kZub
         WDVLX4JHmVDndQT/+aXGwNQDdsHU9EUmFwxSeINpGCmQVQNROYzyzuiCcJSKaKHEfSSP
         KP/u6iTwYSapylbkufHpm8BhO+CnKYq6nEMX/Cio+cQt4dvR+stmMj94Y0VViywuX+tl
         N2jiQWyetwtLL8zZulJAt9lnV7ksFAN33kt5WfyS6wPfryLpKBnT56Ed2tEFaKU3PRPp
         bH7uPuZ9Tz3g8xOqLRbGFe1GTTMOWKXQb2ybDZLOAfKiVj3ZmPK+i31JhIZiutj4rfxX
         YsIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715094508; x=1715699308;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XIQy57nw8js2S4anIYd24L9R1IqwqfbqyoiYCyYOBxY=;
        b=c3zQt65oq6F7MePRiteWrZ2o7eVxWG+42ikaNxfoACP5OAJS5vnU1SffXWrjbtinAE
         yjkeiA/cSBwEgtEpQHA7CnPZgWw75xmv/ozvGZsyap/Zxz1MkWb+jkaQ+eXQZqkrXE8t
         VN5esUS+cIcv2QLntwIIavjbg4JOrorfhnUUI0kbGibu+VLoTBwjlZHqdjjigQD/AG6y
         iXhGIqW4ddjOdokO0a/t2cQXruLnO012praBfPQYVg0nf261NIRn4TH7SGwAFaQnHPdK
         w28VxNEwktaL4HXDvW4pWL1wo2PxuHcW5LttrHCMRthPmZXYk0kdWK7TMt02xfKJ1q6U
         9q3A==
X-Forwarded-Encrypted: i=1; AJvYcCXfawNC9HpfHLyLtpOO2CxpRsgclK/iikhC3b7Mp1EuGS7f4+xeFvWhQmOzZVHDTNu51BCKgPXYl203N0Gbih+WGmrc
X-Gm-Message-State: AOJu0YzMS2D+GJ4J7KnvGYmUNjWUGls2VqFMh/G/uX+uVVuS+vaBL0Rz
	Tg1GT3k14TS1Nm5LesdScay2UHQf2UWHH3AHWTA7wEuxO1xbHBRDegcak1kXOq8WCH0MqnBwTIE
	9Iw==
X-Google-Smtp-Source: AGHT+IGAAglNqpXyaYJUaI2uBs8e7jY1OuLq1VqZRy2zy+xyQcXN8cDWnwsKdrBjSbkcmiU1ZDRoZGIH/Ac=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1245:b0:deb:8bc5:eb5b with SMTP id
 t5-20020a056902124500b00deb8bc5eb5bmr1772807ybu.5.1715094507868; Tue, 07 May
 2024 08:08:27 -0700 (PDT)
Date: Tue, 7 May 2024 08:08:26 -0700
In-Reply-To: <994d42e4c4fb74899474a87766d7583507f13a73.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com> <ZjLNEPwXwPFJ5HJ3@google.com>
 <e39f609f-314b-43c7-b297-5c01e90c023a@intel.com> <038379acaf26dd942a744290bde0fc772084dbe9.camel@intel.com>
 <ZjlovaBlLicFb6Z_@google.com> <8a6c88c7457f9677449b0be3835c7844b34b4e8a.camel@intel.com>
 <Zjo46HkBg2eKYMc7@google.com> <994d42e4c4fb74899474a87766d7583507f13a73.camel@intel.com>
Message-ID: <ZjpD2BaO5SXPUEj0@google.com>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, 
	"john.allen@amd.com" <john.allen@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 07, 2024, Rick P Edgecombe wrote:
> On Tue, 2024-05-07 at 07:21 -0700, Sean Christopherson wrote:
> >=20
> > Keeping X86_FEATURE_IBT set will result in "ibt" being reported in
> > /proc/cpuinfo,
> > i.e. will mislead userspace into thinking IBT is supported and fully en=
abled
> > by
> > the kernel.=C2=A0 For a security feature, that's a pretty big issue.
>=20
> Since the beginning, if you don't configure kernel IBT in Kconfig but the=
 HW
> supports it, "ibt" will appear in /proc/cpuinfo. It never was a reliable
> indicator of kernel IBT enforcement.

Ah, good to know.

> It is just an indicator of if the IBT feature is usable.

Does ibt=3Doff make IBT unusable for userspace?  Huh.  Looking at the #CP h=
andler,
I take it userspace support for IBT hasn't landed yet?

> I think tying kernel IBT enforcement to the CPU feature is wrong. But if =
you
> disable the HW feature, it makes sense that the enforcement would be
> disabled.
>=20
> CET is something that requires a fair amount of SW enablement. SW needs t=
o do
> things in special ways or things will go wrong. So whether IBT is in use =
and
> whether it is supported by the HW are useful to maintain as separate conc=
epts.
>=20
> >=20
> > To fudge around that, we could add a synthetic feature flag to let the
> > kernel tell KVM whether or not it's safe to virtualize IBT, but I don't=
 see
> > what value that adds over KVM checking raw host CPUID.
>=20
> A synthetic feature flag for kernel IBT seems reasonable to me. It's what=
 I
> suggested on that thread I linked earlier. But Peterz was advocating for =
a bool.
> How enforcement would be exposed, would just be dmesg I guess. Having a n=
ew
> feature flag still makes sense to me. Maybe he could be convinced.

If there's a need for IBT and KERNEL_IBT, I agree a synthetic flag makes se=
nse.
But as above, it's not clear to me why both are needed, at least for KVM's =
sake.
Is the need more apparent when userspace IBT support comes along?

