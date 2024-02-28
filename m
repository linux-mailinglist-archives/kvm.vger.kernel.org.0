Return-Path: <kvm+bounces-10179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FEC86A645
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A51C71F2F165
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 066231CF99;
	Wed, 28 Feb 2024 02:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1frM7TW2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4A94C90
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709085655; cv=none; b=ji6BhobrZVWhObR+QPG7lsRuWbr3+SEHQ8Z3J7TypUiqfJt3csi9iAUskDjPVNgfLekvjtKO+2wP4IUUaQmUvrsBwbKeuUdZ0HnAOTLqLvQ7bcdTao7+ImkwpmJyIFMYYV69K/qZbY5LipJ3GwVojzmIokaXS2vSmBq7uk4WRX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709085655; c=relaxed/simple;
	bh=AeGqh4r9dOP1kwfVwX/m+p2YxJI1dCpAzCe7eQkbPOY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ketshLUwY3gOweqVrUH7t2p/Y2a6VVR5JZbKNlQ7ha9aKdNY77AImnhFjK13fT57rlVIX2T9UElsG+qoDQotYN2L6gQ+YsI0dblH+TiKstuR+46BUKTK8FS9tplDxgtbG+wM6FSC1elNAOV1bRjkFsU+IAmrt8qhOoDtwvScKlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1frM7TW2; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60938c2dbbaso7875157b3.0
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709085653; x=1709690453; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6bH08g0YXsvdxlNeOpXzubbkmdDGzJ3RB+XxBRnvGmk=;
        b=1frM7TW2ehsm+Qnlni4Dt2AAzwZc4T4GvSzHzJsI/VN8OL0omLS5WmzAt6mt3OLsIh
         WL8XNIZNmTcq2LTboX+6HNKYdrL196rsWZ5GJbZnm6AcYaX2+GOyIpAxsoac5DvL4G0S
         QZknUrOIvAZGvyfA2Z5p44K2cnKoPqQ2JE0hw53xho3bQUJyeyGHm9GOTLl6LI29YsAA
         TGuyekphR3UQ4DNokdBOMQNC9Kkj1Fd7XISo4K3EEUG8q4vCC0NPNpMOKLxmNlc8DKyg
         TF+hOoe9EJe6BXrXB5efJp96f4wzqnEy3vzNPuJy+z9HUaIptp6NFm62RN3B26lBQeT8
         waNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709085653; x=1709690453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6bH08g0YXsvdxlNeOpXzubbkmdDGzJ3RB+XxBRnvGmk=;
        b=RnT+9/w74S/NFer8YaMvFfhupx7ehOakvWLYo8PZqkvjTrJAVsxejtqlAwygSzfXyo
         6MVe65Zmu9vsaJNUiU5khPLhfe+VLWyjmavdpdtwTYp42AC+kzLkC5jji9ppomdbK7BT
         CXhYlaiIzvHXAZT/sKsBjPa312QXpU2LAYgEPoxiBGUXpYfMtoCK9Y4BlGK8GZyn/nZd
         +1HQS2CjpYlcwvqU1v7EMjevDM5fQBDU5v5iTMohRUAO+Niua4N5fw6RtPc0SpApn0F7
         EyXZg16rJDnrG8P9SLfAHTIZ2w6kf9o+mb3tyfu6/qr4lT0FuyGrlLYtpNEUo4fv4s0d
         hJYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPhQLlpJvvUB7FZNGKaczXfb5u0ReXgWt3t0hRp9V1/I4KQaHcDqGnvcNMi2/z1StTt05P4zYeM7Ttlx/4zP4374Ol
X-Gm-Message-State: AOJu0Yxq3iW3DGnO7GfSTiFuoepibURn601OwFHwlSclfHjuVE1Wdr1u
	HVSbcZIeI6Fw7mN7aVuzwVKpuPGzuqMVWlUQqBnq69LvqGWIM1aFSdhSAq5OdaanbPR6il7lu0C
	d1g==
X-Google-Smtp-Source: AGHT+IFgN7TYk0XlfuOYPZslMedGVow73Hppqg/OG9s/zwcwi0yZpG4A0sRX4Fk0DaV1/c/nMc+rIkohxu4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:92d7:0:b0:609:3901:f2b4 with SMTP id
 j206-20020a8192d7000000b006093901f2b4mr253754ywg.4.1709085652718; Tue, 27 Feb
 2024 18:00:52 -0800 (PST)
Date: Tue, 27 Feb 2024 18:00:51 -0800
In-Reply-To: <20240227232100.478238-11-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-11-pbonzini@redhat.com>
Message-ID: <Zd6T06Qghvutp8Qw@google.com>
Subject: Re: [PATCH 10/21] KVM: SEV: Use a VMSA physical address variable for
 populating VMCB
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com, thomas.lendacky@amd.com, 
	Ashish Kalra <ashish.kalra@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, Paolo Bonzini wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> In preparation to support SEV-SNP AP Creation, use a variable that holds
> the VMSA physical address rather than converting the virtual address.
> This will allow SEV-SNP AP Creation to set the new physical address that
> will be used should the vCPU reset path be taken.

No, this patch belongs in the SNP series.  The hanlding of vmsa_pa is broken
(KVM leaks the page set by the guest; I need to follow-up in the SNP series).
On top of that, I detest duplicat variables, and I don't like that KVM keeps its
original VMSA (kernel allocation) after the guest creates its own.

I can't possibly imagine why this needs to be pulled in early.  There's no way
TDX needs this, and while this patch is _small_, the functional change it leads
to is not.

