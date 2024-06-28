Return-Path: <kvm+bounces-20711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF87491C96C
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:59:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 898901F22F13
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3154614B96E;
	Fri, 28 Jun 2024 22:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="smZVfRNO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAB312F5BE
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 22:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719615460; cv=none; b=YzAe9TzIw8FaueT6pk6B36sh3BToGPG/INlX1+O7+9qYSqrUgA+iYQJl4v7iFDv79GspQFRY/066QNIkmQoa42GXyWoYuMfOJ0aYe+KVoSbICZwD+Yp6A9dbvogw8Nw4r1GkTwbK8AwYhEFdqRoP+D1jTF+juXHjuH0Bp3piqCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719615460; c=relaxed/simple;
	bh=WjMKn5uEj1LIJ6AN+A/19mDRCFsJrX/XyLiyQ/Yfku0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fEMFW1WXqVCOcn26JtInQsQ2HA3J73EuagD3twqHt1GbjMfSc/lEaTenYxxz+RF+jAgMFZSKGrzKdj5HkGaCiPlUc+0hnkOGKBCNIAIBj04aA5VTOvqTkyXQUrID353mBzCgwprjVnFBsmwrAhisOFFruFEcwnNd9KQgUC8tgwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=smZVfRNO; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62d054b1ceeso19801717b3.2
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 15:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719615458; x=1720220258; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KrpP6qQrU8fwGfbAxZj1kCfHoKM3rWUQ2GVR+L6ptXo=;
        b=smZVfRNOOs9HquLsHhV1k27hlpI6F9hhMWsBhp8b+9OkK58tbDGCikRDa4oa5Aijwj
         C7e21sRWLagF396Dwc5nJnm1JZFvHfbSMXu+Qg/bQHfLpP0dPIWrHBbUkhhtnD2Fcw0K
         d2Mg734YuCvy4q0EhrNWceThBarBHYlaFNpIBLlWdKcIzGeJzUSKLHPQqfXjk2NPRiDS
         371cbUTL41gsgInH/PV+PNn6BpuMJah87+CTqsqexqSKToTy/q/H9IVwCxI9PR/Y5wp7
         QFkBMZlSdG0gQODztvdwVZitx8jpym6YHXDxbTx6a3nZW2Vsu3RIovq417wPjg8xeiox
         mkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719615458; x=1720220258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KrpP6qQrU8fwGfbAxZj1kCfHoKM3rWUQ2GVR+L6ptXo=;
        b=DtXsnz1/sshhaHPG1+hPAw3sN28aKZcnCJ15XV3w43TuRHNjWMsAxjX9Ox/zjUeSnO
         +wG0Q3a+5ViuxKLq4xcq1dfO3OXec+syGTun07DHqHzQodUdtkVsEfEjB+fN+BvctVAk
         wkEXFe3xEyKJKSqkUT9zmKGdqOsnSgVi5pvG+chRKZ/q5Qhq3Q4DXdqTSDvo4jRpxIO6
         EZkYZxL0eWu4Lwdx/5EG+IysC786bvAPvUdexZ4FpACoEH74XBL7pERDLq2FHTlg4UxT
         rC+YC1qxqiL+GoRX9HrD+BnCQZrkn16HlMKl7NA1Ek8TzDwkFnOp0QklaOudjkNG1q1I
         J9Qg==
X-Gm-Message-State: AOJu0Yx+jdbFWiZ4xMnxwXitD1Mn8WVKE/tuymDW4Xj2lCyYQPg35Zdf
	aIf/NW0Mei4ZFdOeRpvKI/FGgoyX09Cw1JTcgbIwgG1aNLvZuiwd41GemolFb6ieNjKGDNmwnZ3
	1GQ==
X-Google-Smtp-Source: AGHT+IHvwxb6nltTExSjWzmALM+jHFJlhzr072YZUjLtHoeSx4tpz0rVThAhdOzrZa8ViSzkBFZ3bBs2iu4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6401:b0:62f:22cd:7082 with SMTP id
 00721157ae682-643adb9489emr3645307b3.5.1719615458156; Fri, 28 Jun 2024
 15:57:38 -0700 (PDT)
Date: Fri, 28 Jun 2024 15:55:42 -0700
In-Reply-To: <20240608001003.3296640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608001003.3296640-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <171961446147.237951.4273132233545629028.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Remove unnecessary INVEPT[GLOBAL] from hardware
 enable path
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 07 Jun 2024 17:10:03 -0700, Sean Christopherson wrote:
> Remove the completely pointess global INVEPT, i.e. EPT TLB flush, from
> KVM's VMX enablement path.  KVM always does a targeted TLB flush when
> using a "new" EPT root, in quotes because "new" simply means a root that
> isn't currently being used by the vCPU.
> 
> KVM also _deliberately_ runs with stale TLB entries for defunct roots,
> i.e. doesn't do a TLB flush when vCPUs stop using roots, precisely because
> KVM does the flush on first use.  As called out by the comment in
> kvm_mmu_load(), the reason KVM flushes on first use is because KVM can't
> guarantee the correctness of past hypervisors.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Remove unnecessary INVEPT[GLOBAL] from hardware enable path
      https://github.com/kvm-x86/linux/commit/23b2c5088d01

--
https://github.com/kvm-x86/linux/tree/next

