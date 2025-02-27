Return-Path: <kvm+bounces-39629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF6BA4893A
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 20:51:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E333918881D3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 19:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB0E26F450;
	Thu, 27 Feb 2025 19:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HJjr0WjZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5799226B2D1
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 19:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740685877; cv=none; b=dB7Aj8YEC7t8Zzxc9Obq04Q5wI/zGiysOE2WSw89Kvsb7q6j9Fec24qoN2YGMuQROYFyTvh2cXfcsPBHAYeEvd4xketi4Yhru0L6aONAp+hdusDCF9BwVmKvjl9aV7/y8J3WrCyQE3yULAYj/sBwOdifBMFbE6B8lXT834EurOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740685877; c=relaxed/simple;
	bh=BirTm64MjOA2cmJHC1SBCSVIJHdY1tfvoF7jA3DNzA8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CObPuUfSw8YjEs87aNA9ywxvn8PFNoYJCUI9CzYkwrow5ubq6zILgB8u19erAFD+4XEAfP3jL+w52WmhHhlK7MLe35z/CvafRqg46DOeagDiukpeZA/tUCcVY0YV/SREPnTxaXbuH+FywwRHVKXpfMMGZRN+dmqJDTQK3kNLTAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HJjr0WjZ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-223477ba158so43183865ad.0
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 11:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740685875; x=1741290675; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U7s37NdRt1FlX34JnKymJUCC/VGv/nCbV/kg9VWxXOk=;
        b=HJjr0WjZPX/JnRxFWcJ3OoI5O8ebJhBgUwX+gYYhIBGegSMhGCDhXsDGnxXWqMKPqN
         iF++Ttc/rD24qU/225k2v0LeV2leN1ks8yTXfP1qw1IGXWJT8LD+d7kgdwAefL4ZBfUX
         RLz2UtAtt9XzIWAJVT2lhiErDOe4Zi1v4pYk9m5+qgI6qcdHzBDiuPNHqLJrhIb+dgxD
         PnrUeay7SmZPqFJggjlpij52jsQPX9NjceKrR0Qtl8JDk8YcpP+M2I6rInLbp/IeI6jR
         uRZOY3GgJduRT9ajiih4r3+Mo9xO9JI7Z1vFqytt/UVkk9GlQmMn6Hb0UVUnghD312H0
         CwQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740685875; x=1741290675;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U7s37NdRt1FlX34JnKymJUCC/VGv/nCbV/kg9VWxXOk=;
        b=lxoqnKr6YlbbuCSNlFnz+q0bV6fMlKIXgbwX/Awo/3l9MchkT91S4H3EGl2tkmd4SZ
         dX8EQLdS445rl5M2JVUtya/RkMDuVt+0mR17u4MX2wP4q1NMD5H1NL2wkfoJ+TNrmlim
         HupyFfSbo5OPxNdFU3d9x2/aLk6RwQHcdHqFtySqKdXZvguPWmKhD/qxAnUyqsebV7WU
         FVepEuAA60+f5sFs68ahSxrH4E9Djr+8kxvV7UfSYQHzPB5jsCM+tJedtZFRn8D6HNKl
         DrI2eKV+og1jCky0GmGdeiCtcqURbzFJmzN6rsBPlG5ncWSDAIes2JqB1IaZcKB8xlug
         lG6A==
X-Forwarded-Encrypted: i=1; AJvYcCVTl+Pynrze/OlsjIPNfoTQqp47eYMEQkEMiyNfopflOJuAquIcT8W/ihKvvUEJBS9abD4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzX66ZEHX9IPCBLt6ocf/pAh5bhI0IlzNj6NSOcHkGD8G742m4A
	Cx2NwfIbcF25dCtYqtmBFSJHYuZgknzL301MZpcTMQHs4+N8T1Z+kMCvJ5oQA2UE5P1vMufelYd
	Oww==
X-Google-Smtp-Source: AGHT+IGHfEwLM3h8sPwwS0B40IkejWBgy8pAbzqEOfOdhpqf7pOnl/QM4A57CBOa53+9j7ZReRb6zN9cbkw=
X-Received: from pfbfv10.prod.google.com ([2002:a05:6a00:618a:b0:734:a25c:8951])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:99c:b0:732:6480:2bed
 with SMTP id d2e1a72fcca58-734ac36feccmr960157b3a.13.1740685875558; Thu, 27
 Feb 2025 11:51:15 -0800 (PST)
Date: Thu, 27 Feb 2025 19:51:14 +0000
In-Reply-To: <4A1B24BB-E351-4F98-8A55-F2FB9F45BBF8@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227000705.3199706-1-seanjc@google.com> <20250227000705.3199706-3-seanjc@google.com>
 <73f00589-7d6d-489a-ae40-fefdf674ea42@suse.com> <88E181D6-323E-4352-8E4C-7B7191707611@nutanix.com>
 <Z8C-PRStaoikVlGx@google.com> <4A1B24BB-E351-4F98-8A55-F2FB9F45BBF8@nutanix.com>
Message-ID: <Z8DCMpSD8kNzNPky@google.com>
Subject: Re: [PATCH v2 2/2] KVM: nVMX: Decouple EPT RWX bits from EPT
 Violation protection bits
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2025, Jon Kohler wrote:
> > On Feb 27, 2025, at 2:34=E2=80=AFPM, Sean Christopherson <seanjc@google=
.com> wrote:
> >> LGTM, but any chance we could hold this until I get the MBEC RFC out?
> >=20
> > No?  It's definitely landing before the MBEC support, and IOM it works =
quite nicely
> > with the MBEC support (my diff at the bottom).  I don't see any reason =
to delay
> > or change this cleanup.
>=20
> Ok no problem at all, happy to rebase on top of this when it lands.

FWIW, you don't have to wait for this to land to send your RFC.  You could =
send
your RFC as-is; obviously I'd point out the conflict, but (a) it's an RFC a=
nd
(b) generally it's not your responsibility to anticipate conflicts.

Alternatively, and probably better in this case, would be include these pat=
ches
in your RFC, with a short message in the cover letter explaining their exis=
tence.

That said, I'm guessing I'll beat you to the punch and get this landed in
kvm-x86 next before you send the RFC :-)

