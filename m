Return-Path: <kvm+bounces-17914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E9D8CB8FB
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 04:31:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4EDB5B236FF
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6242657CB4;
	Wed, 22 May 2024 02:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dqVtVC50"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C9015C0
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 02:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716345095; cv=none; b=arHgkPgrKyBxSPrsKg+k47UuRxkx6OSM1/JAFtL5BpppBxNuN4ptINxdu80acN7aCGSkYnHWW1ZjiBoLsOpptKBf815AcGRmOdXKiElcucRk7afIGrMDi+KAD8fNQ85tcdFS9I/z3+EGCBFDuGFUlloUMUzB0/TZyttC1T8MYag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716345095; c=relaxed/simple;
	bh=tak0JNHXgiWiJt06m1Iot07uFQvw2SbXkoQiZzW0bo0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WDkvFleUUYfUTeGvqI1+4WNcIU/MfuCvlGJ5s5064gxiYshq0RwTwxdjgWsJph0eKce0UV+bKttxUIhaUhwbClskIUSe+2bT0KLkLsW2DFRP832f1p4WX4Bh+elIWx2QtsUEsNYIOu6flvTRn0DKQO1sKKUJunLyaUfQSBKoCtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dqVtVC50; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64f63d768so23470953276.2
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 19:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716345093; x=1716949893; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gOYDdieEO0SMEqqI4rHYaS0F69dZml7a9rO/mRwE3Yc=;
        b=dqVtVC50iSxq4VQELbM6nAHkP/Wh8cRQb2jyNF5baHhYXcyIol18qtJr7X8aYGHl7O
         VtsY3Fz72yDBUgukYlkgglcCPLa2DuwtWisjGZh7Cxbu+094x6Q0PCe+ar/V4A49RizW
         RpwpuHccV2+ly66d8lYDk1tL4jD2qQT5kplPwhdL/cR1aD01ibv7kbuUMAFe3+fmkkh+
         na7MwqH4PGi4F8kgvBMsUHoGdYkXXJONBLvYEOWjnICF33dBlfCjtskp3sWVZEawBpYb
         7ca3xx9JRt+SGrYBYOgoPWPoHe0R8pb8OFy9apmgI6umWH3pozocHkN60i2hzv3ailpu
         fnNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716345093; x=1716949893;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gOYDdieEO0SMEqqI4rHYaS0F69dZml7a9rO/mRwE3Yc=;
        b=CprU7hblzXw79rsqf0usmItMl5FPJkCbj+883U1mfwWs6cK8b7k3R0/4zCiwJhRAHe
         1RFuAvVuImC69FPenzDmm05+rurQeSZhK1KlhQ22tudXOV4bVmdRXcS5bqWoL9JhN3Q5
         DGqkGmHyd6oSDXRzRM+eV3eeUTMyqjQrcLCO4Z+5pogYOsEO4/CfRKIJIH1BZtsRSZfU
         mL9ZiIQJNft5bI+OKWNqWTzF/0nY9YVuqTu/2z5Qycl8t4TxNtJzGFdJK+NLWRuotGHU
         RtYCV2Ll526tVOVq2r3L4yQxVMx8WNYfC8n+Jd0msXv2E32xEh6AgyJ/BdE4RoSgDvjn
         HrfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgUNgaoFIN8NrQZhPW6KeA1mUJmlYWeNTju7/T43r/WxsGOgXvpuXgIaNhJdyqtBWZvtcluOHCQuMjdY06HLRxKGkh
X-Gm-Message-State: AOJu0Yz02FRMq5bz9wrBAT2ExoXKAj/jtePQ2oNVH8fxgc4HRexxmJzy
	3+epBp9rF36KmdImtO6vD8IRqXNtMewoEP4RGqnjNSfeK+3OEJEvaMfNkcVLMjLoC0V8ZU9n1GU
	q7Q==
X-Google-Smtp-Source: AGHT+IGmJ0SvbLnKDHz/DAYY+qVuk91HRc2JW9lRvffWDQUBufCfe/OdwsfiVcHXEKW1MXdrv4UbappAeDQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aad4:0:b0:de5:8427:d66e with SMTP id
 3f1490d57ef6-df4e0dbb481mr238843276.11.1716345093234; Tue, 21 May 2024
 19:31:33 -0700 (PDT)
Date: Tue, 21 May 2024 19:31:31 -0700
In-Reply-To: <Zk1KZDStu/+CR0i4@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
 <ZkUIMKxhhYbrvS8I@google.com> <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
 <ZkUVcjYhgVpVcGAV@google.com> <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
 <ZkU7dl3BDXpwYwza@google.com> <175989e7-2275-4775-9ad8-65c4134184dd@intel.com>
 <ZkVDIkgj3lWKymfR@google.com> <7df9032d-83e4-46a1-ab29-6c7973a2ab0b@redhat.com>
 <Zk1KZDStu/+CR0i4@yzhao56-desk.sh.intel.com>
Message-ID: <Zk1ZA-u9yYq0i15-@google.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kai Huang <kai.huang@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024, Yan Zhao wrote:
> On Fri, May 17, 2024 at 05:30:50PM +0200, Paolo Bonzini wrote:
> > On 5/16/24 01:20, Sean Christopherson wrote:
> > > Hmm, a quirk isn't a bad idea.  It suffers the same problems as a mem=
slot flag,
> > > i.e. who knows when it's safe to disable the quirk, but I would hope =
userspace
> > > would be much, much cautious about disabling a quirk that comes with =
a massive
> > > disclaimer.
> > >=20
> > > Though I suspect Paolo will shoot this down too =F0=9F=98=89
> >=20
> > Not really, it's probably the least bad option.  Not as safe as keying =
it
> > off the new machine types, but less ugly.
> A concern about the quirk is that before identifying the root cause of th=
e
> issue, we don't know which one is a quirk, fast zapping all TDPs or slow =
zapping
> within memslot range.

The quirk is specifically that KVM zaps SPTEs that aren't related to the me=
mslot
being deleted/moved.  E.g. the issue went away if KVM zapped a rather arbit=
rary
set of SPTEs.  IIRC, there was a specific gfn range that was "problematic",=
 but
we never figured out the correlation between the problematic range and the =
memslot
being deleted.

Disabling the quirk would allow KVM to choose between a slow/precise/partia=
l zap,
and full/fast zap.

