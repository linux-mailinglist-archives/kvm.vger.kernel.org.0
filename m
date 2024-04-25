Return-Path: <kvm+bounces-15999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA048B2D94
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 01:29:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4A52B22E40
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 23:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46020156871;
	Thu, 25 Apr 2024 23:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yLIgSVy2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCA05A0F5
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 23:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714087740; cv=none; b=lbeT9oxqdU+5JAqsRZx9qQMS4nOfdr9KDKRn/na45OJRUKjmJPTeyKJa70HXbfESlDQsFCC+cnleUOjwj+E4bjRodWCOq4juqmF3B+BLLRYwXsDQAhKxAVLgGdUett9HBKeJ+BQqQyc0lYhJVPe2RHYr1PrS7f4UP2Cxi0cR1WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714087740; c=relaxed/simple;
	bh=qVN/VNREwvgbs11Q9tv3Xv7+xBA5MXA9CBcvN6LO9sc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kv67qAeXdHUzqr/KizH/xuL75abJv9sYiwgtzusIcKuaKPb3rpZk/Ncu74az5NwkwOrHKQH7bCsr1lxZV2OYc41b8aoqodY22MDvMVMiX7FQKb13/i60V2F27WLSqZRM+KWXnqzyOxEmNt7TH3ahaaKZCb//lS+mWPsKTS5emwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yLIgSVy2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2acf6bce4cfso1434465a91.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 16:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714087738; x=1714692538; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uYQgEao9ITFOrKnJhQqOwtjbcWn4eGjHbdywhQxCMmg=;
        b=yLIgSVy2Ct3KySAT/Ahk1nhr4PmGGPuY1md7r1iUwsXuOowtoP2n6zrO2OejYlQn8N
         R93IFXxdiJbX4xIW6XbtOD6JH3Mn3YypoCHudyKXJRU6Gccu1cOQJLjIUaIKfriCReeF
         aIKxQZNlKNz7nHHv1Jfnao9Hs7RIgSvUpIRO2FkkJtGshtBW1qOvyPPGyWVZsCCu3XLj
         hPSDxxsmmWjnwqiY5BES/PH9rhdfLtilQOyH93WQcLBXZWxyAwyoYeN6rwAPy2ncSGRD
         jOsG64rKTfoDeaejWI35HE2MWBeeiICyo7zqP7lrzNS3rzNSiGOcag+qmklSnTdaZKLE
         5Mqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714087738; x=1714692538;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uYQgEao9ITFOrKnJhQqOwtjbcWn4eGjHbdywhQxCMmg=;
        b=bxBQ2p7JS6oCJZc0Q5Pi//HwCXIGVMW6mgbglGv+MArKciIdvoi3Xkapkqizj8+a02
         GioUa5mCkARUlCF+L482RFea4VMcNk7zaj1oaRTu1wC/5f95fxdlcns7BIrpPjXhNFyQ
         +e0w0IMBUkBqgxxvHi9E2ZGNglN85kL+AJujAJX1bcMI6ZhMFz6NaIJqrFu3j/i+MVtR
         AYeZngd6BpXQnd3u3eKQxIhPfvSyHR5DHPQDsOlw9eMYLbmLltS4O/o5rvAq2rUNCLkB
         5A830C+WlNLp1NKcdAYW6bTrtE2K0K9TVMhus/QRn2+XBLPTW68NTxfTVsXJlfmywbQt
         CV7g==
X-Forwarded-Encrypted: i=1; AJvYcCWGmxc6RQug+cenoVUgmbUXbTKUwIi643CB7v+jO1xROaG8BDFvOV1rRyKHc3HA/GiLEs3KFvdaai2UcTCXmLk3cXHv
X-Gm-Message-State: AOJu0YyVyOpOuvPMAfB4JpHQfSGVt89PCTkTjSIxFj1dNI72NX3FGdXq
	qplqKze3cl3y3ofUBKb4r981gdlcyD5qBLARefgP+bGlvh7kj1iK19FevSSWPNmERiGhUg9utKN
	UWg==
X-Google-Smtp-Source: AGHT+IFeaLqtvIv0XVFsbGhiPMBmIWd0L6Si/p9KKWGvz8cy2W4vrRvGF2LdEOSFuirJx/ee0kscthkIakg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c68e:b0:2ac:39d9:dd2e with SMTP id
 n14-20020a17090ac68e00b002ac39d9dd2emr38436pjt.0.1714087738377; Thu, 25 Apr
 2024 16:28:58 -0700 (PDT)
Date: Thu, 25 Apr 2024 16:28:57 -0700
In-Reply-To: <f01c6dc3087161353331538732edc4c5715b49ed.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
 <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com> <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
 <ZiqL4G-d8fk0Rb-c@google.com> <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
 <ZirNfel6-9RcusQC@google.com> <5bde4c96c26c6af1699f1922ea176daac61ab279.camel@intel.com>
 <Zire2UuF9lR2cmnQ@google.com> <f01c6dc3087161353331538732edc4c5715b49ed.camel@intel.com>
Message-ID: <ZirnOf10fJh3vWJ-@google.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024, Rick P Edgecombe wrote:
> On Thu, 2024-04-25 at 15:53 -0700, Sean Christopherson wrote:
> > > Hmm. I'll mention this, but I don't see why KVM needs the TDX module =
to
> > > filter
> > > it. It seems in the range of userspace being allowed to create nonsen=
se
> > > configurations that only hurt its own guest.
> >=20
> > Because the whole point of TDX is to protect the guest from the bad, na=
ughty
> > host?
>=20
> DOS naughtiness by the host is allowed though.
>=20
> >=20
> > > If we think the TDX module should do it, then maybe we should have KV=
M
> > > sanity filter these out today in preparation.
> >=20
> > Nope.=C2=A0 KVM isn't in the guest's TCB, TDX is.  =C2=A0 KVM's stance =
is that
> > userspace is responsible for providing a sane vCPU model, because defin=
ing
> > what is "sane" is extremely difficult unless the definition is super
> > prescriptive, a la TDX.=20
> >=20
> > E.g. letting the host map something that TDX's spec says will cause #VE=
 would
> > create a novel attack surface.
>=20
> I thought that the shared half could be mapped in that range unless KVM g=
ets
> involved. But, no, as long as we tie GPAW, 23:16, ept-level all together,=
 then
> mapping something above it won't even make sense.
>=20
> I don't see attack surface risk immediately. I expect this will get more
> internal scrutiny in that regard though.

Oooh, I thought you were talking about KVM mapping a private GPA address in=
 S-EPT
above the reported GPAW.  In hindsight, I don't know _why_ I thought that.

Yeah, trying to sanity check the shared EPT in the TDX module would be comi=
cally
pointless.

