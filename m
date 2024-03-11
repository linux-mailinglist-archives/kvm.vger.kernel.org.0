Return-Path: <kvm+bounces-11569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F42878557
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:27:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBDF01C219CF
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 16:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F60256B71;
	Mon, 11 Mar 2024 16:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LZ4HJP/H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011A756B64
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 16:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710174078; cv=none; b=YnOD4RYx0H/wWSAKUGe22e3s9PN+ipkZgiX2yuDraF6Ca++siziFDYhtO0H9uRvuiE6TTbeDoDu0tRFIoSzoouNtk2Qp1kKl9HLKkIo4ZoANXUN5Y9n2MLALVRWEM3yHbJLAzDhgkcp1+/CKRwZPqid7r4RQ/WujtwtNupZCdJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710174078; c=relaxed/simple;
	bh=qfW/kGk94of4yalWU1PdrhO6UqJZB7rHcs/wXkg7FPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XMWaSwNvaOqpAULHyRHs9uqhlzLEsucMH4D+OSxUXpPlxYDFnLWVWuPlkzAwFRDVvRxP/YdTaK3fKRTSrlci5sc1iMg8BL+4eaXeql/P6rERp9ml2boZ7Xo1Sk3QQWreW9vMmTredenkL15BZRvI14RmPLDsv/96/WCgwKrOnfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LZ4HJP/H; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-33e92b3b5c9so1601009f8f.2
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710174075; x=1710778875; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GRHbM8iISI0NpUPhNykIpu2WvmXC88NjtQH+HPjZyOE=;
        b=LZ4HJP/HRGUdLR2STDuvY3TAuLQqpaHKq1qZ3cFrQA2vO5Gu0pueDCy3NXZlzXILR8
         qnV5tT6B/Nk1EPRrqkbfh6Gh0UyoclpVZVPkjW80lOvLLt9PdVCofE8sTzUxe0Ik0GEy
         WvahT75LavGPvJvxrXS9IbcvK7OrVO7G3gmRmOkDyy/l14prO2amR4Aky27KahdEA8PI
         RFVU1xcZO7ZMMTt2X/LmZynFAtPV7dVXNDlaP02mT7dYbEbQfOi3sd8UW5QPfv/i8qrr
         Jr33ZiMX+byFoPwEacJv6mKtmJFZQVW/Vu+oownA229tgAMNE6tabzzMQXZO4o794xbz
         f3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710174075; x=1710778875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GRHbM8iISI0NpUPhNykIpu2WvmXC88NjtQH+HPjZyOE=;
        b=mMNCi0mhpT/fQG9KzUMCxVO3sIHsg8dgaJf1i01snl2i/1IshnV2kIJ/LPONtu8EF+
         cfhOeDIich50la+4ayVoE0aFvhxfAZ6c+py6j1cUqwKNWbgS4e7t2EWXpc2x3ya5svmT
         Py9zkVTS6tYkhn6dHPpw+Pv4UQVvr9iGkdqWGNQafOdwfDrP/AqZ976ERdszRQ6qkW4p
         WNmP0Yn0KOo5SViC7xv/itP2qaqZB0TU95hyai/EAGD9Ou+ESYgTy6Nkt7dYqlDUftQY
         CYsEU0HyY/RbyMmbj0UfJa125HWtr7lbA3EsUG+ZCqQlGlwuJPgh1GMu8nicnkwN774h
         zfpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGjWXY/TlpFa4lCUQi5Ml/WKOa1G2TH21/RlFPy/v32i1WWk7apUpY0xFMoEXO6RjMTx8Z2RJ51LcKqn4WKckO2SWb
X-Gm-Message-State: AOJu0YxiHAZ563MenQCZUunNJ8hMRLSJWfbJhCj7OQ8SUjafmL6IGXA9
	CbtCHKvcqydM3RrtiwWyU/DIpDA10CyYtAFCvU4vMvh3NscYOzUWZmrV95r9YClqkTEjodbSNxT
	MbZ+x0e73zxKbgu0y9kwqBIO2HcbtOUM/LKZL
X-Google-Smtp-Source: AGHT+IF56DFAkN6EElW+sbMpfmisqZTBEkWDtxHyybNyRdtF973BKWpFHFSULcS7yyvYlMJ74IiC8WSzDEoEJJADSJA=
X-Received: by 2002:adf:dd8a:0:b0:33e:69a5:68f9 with SMTP id
 x10-20020adfdd8a000000b0033e69a568f9mr5462424wrl.17.1710174075303; Mon, 11
 Mar 2024 09:21:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-7-amoorthy@google.com>
 <ZeuMEdQTFADDSFkX@google.com> <ZeuxaHlZzI4qnnFq@google.com> <Ze6Md/RF8Lbg38Rf@thinky-boi>
In-Reply-To: <Ze6Md/RF8Lbg38Rf@thinky-boi>
From: David Matlack <dmatlack@google.com>
Date: Mon, 11 Mar 2024 09:20:48 -0700
Message-ID: <CALzav=cMrt8jhCKZSJL+76L=PUZLBH7D=Uo-5Cd1vBOoEja0Nw@mail.gmail.com>
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Anish Moorthy <amoorthy@google.com>, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 10, 2024 at 9:46=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
> > >
> > >   2. What is your best guess as to when KVM userfault patches will be=
 available,
> > >      even if only in RFC form?
> >
> > We're aiming for the end of April for RFC with KVM/ARM support.
>
> Just to make sure everyone is read in on what this entails -- is this
> the implementation that only worries about vCPUs touching non-present
> memory, leaving the question of other UAPIs that consume guest memory
> (e.g. GIC/ITS table save/restore) up for further discussion?

Yes. The initial version will only support returning to userspace on
invalid vCPU accesses with KVM_EXIT_MEMORY_FAULT. Non-vCPU accesses to
invalid pages (e.g. GIC/ITS table save/restore) will trigger an error
return from __gfn_to_hva_many() (which will cause the corresponding
ioctl to fail). It will be userspace's responsibility to clear the
invalid attribute before invoking those ioctls.

For x86 we may need an blocking kernel-to-userspace notification
mechanism for code paths in the emulator, but we'd like to investigate
and discuss if there are any other cleaner alternatives before going
too far down that route.

