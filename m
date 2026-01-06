Return-Path: <kvm+bounces-67190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F2642CFB625
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 00:49:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8EEA1302D2AC
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 23:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8754431B11E;
	Tue,  6 Jan 2026 23:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LYL0KA7C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5832DA775
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 23:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767743320; cv=none; b=cJREzKHuP+Kw7fTMBY1Xtfx2sO/wLV+3Non/26uznLQEB5ri4h9xIg6PHa7bEzBZrY6WZaePTx6mXa7Tfn0fDUSDjPs+zG/fUrF4QCxQq/cVdzAY+msLxMLdQ+QYK86nlsq7XVSJ79QaBkQXTzsuOCxUu8kv5eW2mX4boYd7RkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767743320; c=relaxed/simple;
	bh=LZ05UVyGXS3uaEnykz4vyYA6HOE4UeTPNaiHJEkTyp8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A45n2hPSeWk/2IKlD7nnoqJrpXfFLi5ViyDFw4BStCiUsHdk5YsSpjKy0VR820Jg5JTkixaJ4HB0B1he5deMabz0R07XVUlApGfwQqh52fAdmyXMOot49YDFvL0pmO8fOD8EGKBXbXptizwmunziCrOUq4Bll9YAApLSpmt1qTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LYL0KA7C; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a090819ed1so11298025ad.2
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 15:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767743319; x=1768348119; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WZSvW5wtvITu4SJXRjRAbmEfEMA88gTQfQ+s3BSwlg4=;
        b=LYL0KA7C72jnqkxSabQdx7Ghiy2e8erO8xf3mXeiAO00NNBIhFC+BX4Zq7QBBh7IH1
         PDB33xmBwdZra548P9DR+bsgVOUwfHaDzHLN3cmNPV1A4azx2tWiKMiT5zzMqP0kMaOD
         3nRjVsQLNS1mmjSOBsELpbZCWnYTw88PMGUMbLRJHE9nL0kZDaJCFferD47sr3skcwjf
         g7FznvlBsVyGU9sojFqh64MZepATDAuw6XDcqgbPVbN8/wxyTV+WwTqxTC8ALmULOK9r
         VkVYLP+XD2IGDwMVU/rrOQro4+aYytIg9SpX6DQi7t4FFIgUolllURYiA09OWj4QRwe4
         GCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767743319; x=1768348119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WZSvW5wtvITu4SJXRjRAbmEfEMA88gTQfQ+s3BSwlg4=;
        b=q7w8X/tDLSU7cqBM1dXm4nveS31TWOJDWg8yNxFo/m2827NGKGJv2Wl5zAgJ+aqtfX
         u/dtW0I0WjpRCrsdv1qgR15onuuop6QQFHRs8xQ3s215d2WTIPTPbg5K3wAKMFlKlaAS
         gqw8riOyhIxNf5hP5TZkIoF6la9MzXULAnV04NbF0I5YwR/o+45NRN39KyJHiewofJhD
         6AELsg3YFefh3gJ9h5bq+Vl7KFVBpXszFUYBC6FQ4hKvtvzI+fqZ2eXMwHyUdcMoaaRx
         hgALvDXJeVL5sDWvkm83l3cjNstT/cVdI88kAPMS5PsJSrXX7L0TWXZi0xr9algD2Lv4
         O54g==
X-Forwarded-Encrypted: i=1; AJvYcCWrL4tjvbi7LC5M2qZnysNFY5T6wmmItgRKrwhFUi/YA9A1YWgazzwk7ClZKYHOjoSHw6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4YJMx0adzLOkq80yugApMSGb3zrYM2Jvf4C6xLk3jdqSA4/jk
	FxSJhuLB8WbiDtrQj/dx2auvc6zUz/RzTqbSQnsJkY8VZ36oM2AlMtW62xmEw1H3dIDPdkmmDDY
	eP3zQNw==
X-Google-Smtp-Source: AGHT+IEE7vYXak7r+HwQYDu/g5AOkfcndSHO1z6vcKAqtHXXobcOLVQzjsohmyEW9urtWhgG1ubEcOLjj7g=
X-Received: from pldd12.prod.google.com ([2002:a17:902:c18c:b0:29e:fd13:927b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce08:b0:2a0:34ee:3725
 with SMTP id d9443c01a7336-2a3ee4456c1mr5326115ad.14.1767743318591; Tue, 06
 Jan 2026 15:48:38 -0800 (PST)
Date: Tue, 6 Jan 2026 15:48:37 -0800
In-Reply-To: <5uwzlb3jvmebvienef5tw7cd6r4wgvtb5m5gu3wcaxh5sery3o@crh6m6cpuaqy>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106041250.2125920-1-chengkev@google.com> <20260106041250.2125920-2-chengkev@google.com>
 <aV1StCzKWxAQ-B93@google.com> <5uwzlb3jvmebvienef5tw7cd6r4wgvtb5m5gu3wcaxh5sery3o@crh6m6cpuaqy>
Message-ID: <aV2fVaLBrtUsccHJ@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Generate #UD for certain instructions when
 SVME.EFER is disabled
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 06, 2026, Yosry Ahmed wrote:
> On Tue, Jan 06, 2026 at 10:21:40AM -0800, Sean Christopherson wrote:
> > So rather than manually handle the intercepts in svm_set_efer() and fight recalcs,
> > trigger KVM_REQ_RECALC_INTERCEPTS and teach svm_recalc_instruction_intercepts()
> > about EFER.SVME handling.
> > 
> > After the dust settles, it might make sense to move the #GP intercept logic into
> > svm_recalc_intercepts() as well, but that's not a priority.
> 
> Unrelated question about the #GP intercept logic, it seems like if
> enable_vmware_backdoor is set, the #GP intercept will be set, even for
> SEV guests, which goes against the in svm_set_efer():
> 
> 	/*
> 	 * Never intercept #GP for SEV guests, KVM can't
> 	 * decrypt guest memory to workaround the erratum.
> 	 */
> 	if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
> 		set_exception_intercept(svm, GP_VECTOR);
> 
> I initially thought if userspace sets enable_vmware_backdoor and runs
> SEV guests it's shooting itself in the foot, but given that
> enable_vmware_backdoor is a module parameter (i.e. global), isn't it
> possible that the host runs some SEV and some non-SEV VMs, where the
> non-SEV VMs require the vmware backdoor?

Commit 29de732cc95c ("KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV")
moved the override to sev_init_vmcb():

	/*
	 * Don't intercept #GP for SEV guests, e.g. for the VMware backdoor, as
	 * KVM can't decrypt guest memory to decode the faulting instruction.
	 */
	clr_exception_intercept(svm, GP_VECTOR);

I.e. init_vmcb() will set the #GP intercept, then sev_init_vmcb() will immediately
clear it.

