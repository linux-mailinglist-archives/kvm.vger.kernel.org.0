Return-Path: <kvm+bounces-29857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 517889B3370
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 15:26:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 747561C21617
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 14:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBBC1DD9AD;
	Mon, 28 Oct 2024 14:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPe03b+8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C7D1DD54E
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 14:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730125564; cv=none; b=oAAfZ6NEA0q7UTZJ8E4CSLL09V3SPJYGYKGiFcJe/TsXym7kW5aM0z7SjQ4WF6Ni94sRjky/9F+sD1dPbHW9266luoiKhLqSo51Gi6ztLG+joKEBFMrrKaWOafF3m+GxoInfswOKFr9m/l2V5ReotAeCfR9liS9WoDKcX9T+ClE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730125564; c=relaxed/simple;
	bh=T9WHVXqcD8FBI7uOXsdOUl7kdFCFioum7VzGN66BvBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=grAlIgMQHF7/L78LcczOfDw6I+nMn0q+COgAI2YyKTpS25/oTKX+Cw7emN+3/eDs2FHZmWa+7Y/B0KjefKGFkLcxFmHVAGwFRRiVQYV72zfgDdj2qSPPXo+bQv7ba2wdI7M6H5iHIt9qYo/00RDUSqNs3UfJ+CKeDi+0IO+jCnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NPe03b+8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730125561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KryVam8B1QeiyXDX/LEC5cXrGo7Bp2ehnvaqDurb+ic=;
	b=NPe03b+8ruPisIRQB7lrMpOOmOzHyrkUavKG4kt5fbFtqbC7/XHbhUiP12NWWQHsdoADoo
	rwZt8XED+dzx4SIPyt8CExAEgHqY9S+ksr7Dcllu4lvR1LtVm/zKvfEvrdAgS1+HqA8nyR
	O26UR2IMIqU1Yv2NuXQZfRI054X8Lxg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-W5NRP4GXPjii90MrWdXeEA-1; Mon, 28 Oct 2024 10:25:59 -0400
X-MC-Unique: W5NRP4GXPjii90MrWdXeEA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4315ad4938fso31713755e9.0
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 07:25:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730125557; x=1730730357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KryVam8B1QeiyXDX/LEC5cXrGo7Bp2ehnvaqDurb+ic=;
        b=jle4yusH8G2RWglA5FbGVZ+3wlz/GVRdGDRddFVtzxg+106ujMzpw+J4G9Es3Kx/e9
         0Z0aWIE/ciBYJHoGFOFXf+tiuZHmEPAeME+qW7+NxKXOorAxyTn6uYFrqO9vNlbIxA2l
         rXjzsUM17JMEC6hdYaOG4GO8wq2lACnFgzQ8v4sZ5azvw14a/b1gKLf6UvpPWQxW2ig3
         n6gSW6ZCCO5NsnBT8vOcsTbKmA5LbJY+Z8tMuSnFOhi0LnqWnwZy2SnfBJXwVK8KdeGV
         dOLuu/TxwsZjXY210SC8uOqRyjv/VquXiiHc6dGowZjR+ZZAl9116RkmHNfJW9/F2R2Z
         wV+A==
X-Forwarded-Encrypted: i=1; AJvYcCUM04PblBw9zoLRmr5QmV1Av78CuPVajWkWIkiR5DOCZC0E8QsdHb2Lc0XKiCpHw0FZXs0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQjmm3CAwCBE9NxQskBuTXc4oryaCXn8tzAPo+j923mUfhBpMU
	4b3AT/FYzXsriSkEfoH9DjSMuYnjw8t7rgZ9OrlUj51jrpQ9zGnzHQukbqIDc9arSD6bkpzzyz5
	tJMbDvckzcm/bvH+opWgLWwqLb2Wh4PyoD0bARB4h26NJ04FA1AH4bZiCVEbeGm0ZM6MKPuI0qm
	CZloVVzum1THyZicaMfa7xPW+HgYuEW42tKRM=
X-Received: by 2002:a05:600c:500a:b0:431:561b:b32a with SMTP id 5b1f17b1804b1-4319acb8ce7mr74501655e9.19.1730125557603;
        Mon, 28 Oct 2024 07:25:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFIEWhdP7PMNUIadkfCXOK0l0J4+U99CZs9JgcZC+dmcafgti+xaB2/XQDAvxlMXyox/zSuPc8jMnBF+v7Bxc=
X-Received: by 2002:a05:600c:500a:b0:431:561b:b32a with SMTP id
 5b1f17b1804b1-4319acb8ce7mr74501485e9.19.1730125557274; Mon, 28 Oct 2024
 07:25:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1729807947.git.babu.moger@amd.com> <b4b7abae-669a-4a86-81d3-d1f677a82929@redhat.com>
 <24ea79dc-1a15-4e54-a741-e88332476646@amd.com>
In-Reply-To: <24ea79dc-1a15-4e54-a741-e88332476646@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 28 Oct 2024 15:25:44 +0100
Message-ID: <CABgObfZ6hCjs35Z8JDLonsRB=7RAdxhBK5a+pr0qja=6LpEdFg@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] target/i386: Add support for perfmon-v2, RAS bits
 and EPYC-Turin CPU model
To: babu.moger@amd.com
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 28, 2024 at 3:23=E2=80=AFPM Moger, Babu <babu.moger@amd.com> wr=
ote:
>
> Hi Paolo,
>
> On 10/28/24 03:37, Paolo Bonzini wrote:
> > On 10/25/24 00:18, Babu Moger wrote:
> >>
> >> This series adds the support for following features in qemu.
> >> 1. RAS feature bits (SUCCOR, McaOverflowRecov)
> >> 2. perfmon-v2
> >> 3. Update EPYC-Genoa to support perfmon-v2 and RAS bits
> >> 4. Support for bits related to SRSO (sbpb, ibpb-brtype,
> >> srso-user-kernel-no)
> >> 5. Added support for feature bits CPUID_Fn80000021_EAX/CPUID_Fn8000002=
1_EBX
> >>     to address CPUID enforcement requirement in Turin platforms.
> >> 6. Add support for EPYC-Turin.
> >
> > Queued, thanks.  I looked at
>
> Thanks.
>
> > https://gitlab.com/qemu-project/qemu/-/issues/2571 and I think it's cau=
sed
> > by the ignore_msrs=3D1 parameter on the KVM kernel module.
>
> Thanks again.
>
> >
> > However, can you look into adding new CPUID_SVM_* bits?
>
> I normally pickup bits when it is added in kernel/kvm. Are you thinking o=
f
> any specific bits here?

Yes, KVM already supports vGIF, virtual VMLOAD/VMSAVE, virtual TSC
rate MSR, vNMI, virtual LBR, virtual pause filter and virtual pause
filter threshold.

Paolo


