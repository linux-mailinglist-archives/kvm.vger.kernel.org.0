Return-Path: <kvm+bounces-19483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1B1905845
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 18:15:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1394CB296D9
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F576181305;
	Wed, 12 Jun 2024 16:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NAO536JX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AEB16EC13
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 16:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718208386; cv=none; b=FMbXJAFvQaanjPnI+j186F4rKzePa+dnn8cWh6oeVM+6Tqs+BZ6h4UBUaLNz26L+MEO54Fayg2Ev6/0KAoEFu9QoY39WlX5ViusvpPuyYkSCX0+G9RV4oJKoBSX49r0eJd3qBYemAoIbsYkG1N91ICQTN6JlT70Qt4PSE3LNGhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718208386; c=relaxed/simple;
	bh=NHtYjSmTMtNed9N2wRZmQj/KeFSv++nlwQX6y2LLOZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JdssbEBVczmp9VNsVuCChZda+jMyCgcMpBG+6y74EVsaE3TYnFn4jEWbyo0AuBmefJGlSN28RcKxhBJKV+11ayCLEgc+oxga9Nxk/hMlEBLf6vYzy5wLATC0HMjE0dP+G1olzQwwX/hQXiR9qfj7tTHMBrQTVbyYQR23R1Z3SoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NAO536JX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718208383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NHtYjSmTMtNed9N2wRZmQj/KeFSv++nlwQX6y2LLOZw=;
	b=NAO536JX6m7kQxR6sMqYiW+wtVB/lOrAOD1oo117qSFcXOtOaCy4/0Eui0oKu3Q1Uv/ouh
	pJ8QJn/RRDfuXJOX84sRosCyjAUBL8vooFU/jb3Hmwyq0q6SeLA+qecUjwmO9FWrAZ6Uf4
	GmA1Mf1z60hqYaKBRPSWgZ3b8CUymUY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-XmkBRuPUOC6UMh8qRdoQHA-1; Wed, 12 Jun 2024 12:06:22 -0400
X-MC-Unique: XmkBRuPUOC6UMh8qRdoQHA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35f142464b9so32928f8f.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 09:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718208380; x=1718813180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NHtYjSmTMtNed9N2wRZmQj/KeFSv++nlwQX6y2LLOZw=;
        b=p5450MblBbOObu/ICRwGowE6RlILzcBF9is1SlKngxGMw0iOWf7Uz850ev4Uc2KmW6
         n736SSjah/KE6XpaFiW8qPeavgbhMZiqZIc1dLzFoIgK4q3lUE97am2W2XkJlgJcPrQq
         w1AkqE6V0jDB3AvpYUYXG+/oomtcDAyZ1AvYbhw3Nt0OkK771kL9MVD3Y65Uu4914eTF
         GinFwFYCvVuaSL8dBNw2G7hASheMF8afocoWkfzitT4A616M4l3RxTuupNYVaMsgfdc+
         FNRxUx6YsWjSTq+Tsn+zXKeVMX4xIHEMOwEGNird8uL8fGJexnygvz4dO4FrzD+VbTLo
         aJrg==
X-Forwarded-Encrypted: i=1; AJvYcCWeJgt9h57CVZsmHIidjHZ9JwWLLK59MsPKeSftBbpqB5ntMELHJ6+7C46VdUZrqRPmP2qrwmNk5cw8pUeohbOp4wxT
X-Gm-Message-State: AOJu0YxKXE5s2g0IGk07XY4nWcdTHxtU5SaBaGmiwuK8bi2PGZ3SDgLb
	f8iWdEllBMw7ebMzsEWbSHs98HZr7T7sfJJMiMoljw0bTz7SP6zbvBfTQ4IjdCld5GY78Dm//Rn
	/dotDAYLN3lUWPEPRdcUT7eTbBnhZe20fz523tq4MYoYHxVhZJzeMaNmr2/dQhzbUvSiZeZ8rrk
	9b7b6vZyEshPVDf5tS6yjT/00tMYc/QhoyD+g=
X-Received: by 2002:a05:6000:bd0:b0:35f:1522:10b1 with SMTP id ffacd0b85a97d-35fe8910281mr1694731f8f.52.1718208380030;
        Wed, 12 Jun 2024 09:06:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkRfD7FvnoG5vFiDBFq1+esQSuEl5w50A3ZLaNfGGB3jdeoZnUnL8EYolRcw3lA91SzLS5T7kDSZg7qE2+M94=
X-Received: by 2002:a05:6000:bd0:b0:35f:1522:10b1 with SMTP id
 ffacd0b85a97d-35fe8910281mr1694710f8f.52.1718208379663; Wed, 12 Jun 2024
 09:06:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9c4547ea234a2ba09ebe05219f180f08ac6fc2e3.1708933498.git.isaku.yamahata@intel.com>
 <ZiJ3Krs_HoqdfyWN@google.com> <aefee0c0-6931-4677-932e-e61db73b63a2@linux.intel.com>
 <CABgObfb9DC744cQeaDeP5hbKhgVisCvxBew=pCP5JB6U1=oz-A@mail.gmail.com> <f4029895-01c2-453a-9104-71475cd821ab@linux.intel.com>
In-Reply-To: <f4029895-01c2-453a-9104-71475cd821ab@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 12 Jun 2024 18:06:08 +0200
Message-ID: <CABgObfZ+Xvh1+ewJiCB4uqzPSYo2JvTz0aEUzT-CNruf35_D+A@mail.gmail.com>
Subject: Re: [PATCH v19 116/130] KVM: TDX: Silently discard SMI request
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2024 at 3:06=E2=80=AFPM Binbin Wu <binbin.wu@linux.intel.co=
m> wrote:
> On 6/11/2024 10:11 PM, Paolo Bonzini wrote:
> > On Tue, Jun 11, 2024 at 3:18=E2=80=AFPM Binbin Wu <binbin.wu@linux.inte=
l.com> wrote:
> > > is_td_vcpu() is defined in tdx.h.
> > > Do you mind using open code to check whether the VM is TD in vmx.c?
> > > "vcpu->kvm->arch.vm_type =3D=3D KVM_X86_TDX_VM"
> > I'd move it to some place that main.c can see.
>
> is_td_vcpu() can be seen in main.c

Ok.

> > Or vmx.c as Sean says
> > below, but I am not sure I like the idea too much.
>
> Which you may not like? Remove the vt_* wrapper or use KVM_BUG_ON()?

Removing the vt_* wrapper.

Paolo


