Return-Path: <kvm+bounces-31179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 239F89C100F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:48:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC8BF28339C
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265ED21858A;
	Thu,  7 Nov 2024 20:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BJzsrIto"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B855E188CC6
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 20:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731012498; cv=none; b=Vb5pLI7JZp5Li8hFnCf0uF7bq1KHhr56oKo6HD1Bag7Hv03UhT6gZ3ggkDSjZQ7I1Dv1HmkfpLL3UYE9Gs31qhXAtKr/BBxa8aDDq0NuO1TSu/loidHzVZvl0tDqMbOXgJNTDJgNzmPkNu6pbxtylWClADIk1JKLxIHFscPhrbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731012498; c=relaxed/simple;
	bh=L2JnZy+FpJjZq2hoDPKEQjvM+JNDSZhn7qTteDh5tWc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sJ13yhO0oLm5x/lpTqTTN8mu6+tlxTfvIGn/Ydz73bFDvaMhK4kQhyZx2ebEor86RutemHJUYiShKATeTdYsXRehCL647aKsKZCxW0r6wKjcnG8V6yILnpxLpMFsnauwhCFXgac8S+iR4hUCcBeo3IlQ3rDf9tG2vr0XiOM/A2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BJzsrIto; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e32ff6f578eso3286273276.1
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 12:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731012496; x=1731617296; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9tgFF/vf8m24mqzX/IMYi9zJNPzKWJ3qSX08ShIAreE=;
        b=BJzsrIto3s5ikwCRMHSF8x3wyY327ru3E/5+3rP7pPPY3Qu69rNhp0bAvaIUr0/aBf
         pMZN490nMoRb6qq73qtxtTczc4XHYSzx0cIyMpJtGW25ekytIO7EmpT24V8ewbg9i0kU
         QpmBCNnsyspc0IuuPqOVPtFzZJTWlLnaGaAeLU2vQ2wF2R/Sg3wVkhb4A0+FezLnP6C+
         95OmlPULcl5O1CcwId2+KHThlxmrBVwNSwwA6wGFjxDUlJSwTC//WUfCk/cZjyWJP0j6
         JeENibGLeGcNcVvCpQw6WFrzF4yqTx1U0jfLqULw3fK4JgI9KAz8uquW3IufVw44aWdD
         QmNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731012496; x=1731617296;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9tgFF/vf8m24mqzX/IMYi9zJNPzKWJ3qSX08ShIAreE=;
        b=RdaCyeNM9UXw3fBmWVPM6ovBFR4gXcWgGQyUC6LjDXxamq/Yz3NFnkSH5kOOOcCrN2
         1Ae0VYt5yDXW8vM12cFoHWYWw6jVhEoTnZUJx7VAS2KYtr9tLHSfKa5zaUJG08Ifu6pl
         UwAv6CvLFdgrt2A2qTB/HHucNdYh593e87ruk+dJ8orDbrjG95YGs2eI2XyWgbxgww2+
         POdkPGPWR7+azxRPPqSUhg4eAs8p5QdVnxMEwAb01ur3AflFzfBJvrt9lcufkgAQIU7T
         o95BSg1/yzzrSdiBW6Y8T+o4UiWWu7REn4vBbrPTCBi2puouQ3xtoF442A/zSIhKNHTu
         MTtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOfRJjl5rgavT4hB/NIVboIha1lSIvCngUvxmPcNwXy++nEFPl0gkgLY1XRgB8aIWvuDY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzizb/dGZqQsTIKB8bayL3VasSj52qf7Jq0azXQtLTk28HuV8G3
	7lZCGzl5a5TmGGkSGTdzhZF1oS3tc3FvyUrj9InQh6GTVXyj1PAO3dYyi35sOYVY6wVQjwuytDt
	e+w==
X-Google-Smtp-Source: AGHT+IGS34K7Djy3aJITzLWueG1h/SQAZjPBoQvYGi8UH9Cq6cPlMxmMBI4tn55IpfbmvQ570TOXglQxxzg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:c584:0:b0:e0b:f6aa:8088 with SMTP id
 3f1490d57ef6-e337fd8c39bmr619276.1.1731012495813; Thu, 07 Nov 2024 12:48:15
 -0800 (PST)
Date: Thu, 7 Nov 2024 12:48:14 -0800
In-Reply-To: <Zy0M9yv7xIiKB_Xi@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZyAnSAw34jwWicJl@slm.duckdns.org> <nlcen6mwyduof423wzfyf3gmvt77uqywzikby2gionpu4mz6za@635i633henks>
 <Zy0M9yv7xIiKB_Xi@slm.duckdns.org>
Message-ID: <Zy0njoaJGS9310eR@google.com>
Subject: Re: cgroup2 freezer and kvm_vm_worker_thread()
From: Sean Christopherson <seanjc@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Michal =?utf-8?Q?Koutn=C3=BD?=" <mkoutny@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Luca Boccassi <bluca@debian.org>, Roman Gushchin <roman.gushchin@linux.dev>, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2024, Tejun Heo wrote:
> Hello,
>=20
> On Thu, Nov 07, 2024 at 07:05:46PM +0100, Michal Koutn=C3=BD wrote:
> ...
> > I'd first ask why the kvm_vm_worker_thread needs to be in the KVM task'=
s
> > cgroup (and copy its priority at creation time but no later adjustments=
)?
> >=20
> > If it can remain inside root cgroup (like any other good kthread) its
> > job may be even chunked into periodic/deferred workqueue pieces with no
> > kthread per KVM at all.
>=20
> That'd be better but I suppose kvm wants them in the same cgroup for a
> reason.

Yes.  The one and only user of kvm_vm_create_worker_thread() does non-trivi=
al
work on behalf of the VM, and so we want all of the CPU time consumed by th=
at
work to be charged to the VM's container, e.g. so that a VM that is generat=
ing
a lot of work doesn't negatively impact other VMs on the same host (the amo=
unt
of work done is directly affected by how the guest is accessing its memory)=
.

