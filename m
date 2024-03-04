Return-Path: <kvm+bounces-10827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D57870B5A
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 21:17:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E7181C2226F
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 20:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C6EB7BAED;
	Mon,  4 Mar 2024 20:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="by2EyQaH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01687B3F9
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 20:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709583438; cv=none; b=tkeK1RzgMD/nxqt+4VZz71x/fkD+XDKzKhRodwP/xlm0qWNoDuD/LJx3NX942X0Whb0/PEtv5+jOhUqH7Dbdf/9LJFlg89Dwfb/XuI88Q+ln8NIseIu6qRb6uwcjeV6wlVYVYBMSGR7x4hyta4qmKyu7fqg23Kk9XTvydC/r82Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709583438; c=relaxed/simple;
	bh=kCxdGUblvKvmrHONTMdMca6j8MkXm6abJWjQTd229yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCqy5/9kDaZsdik8RnDXVq7FX/W2OvA+21hrn7WrbGtwH5dqI5WEzOx8YV1KnNXLpnvNiMRNDQJPjd47RLqj5VsM64QKAzPw/sl62M5GpBMamhAHOjqOARJj1hfkpAITo3RjOb0zW96toN+PY6NHWbUJ7tYIHzhqpO0FeGPc2dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=by2EyQaH; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dba177c596so30338685ad.0
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 12:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709583428; x=1710188228; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D/7HbYGpfhKc4R/AKhfixpmLppzl+6hWOAPaqaIiEWg=;
        b=by2EyQaHVwydyFEQCEoHVfjcgI0mF3hZe2jZxg6WiuzmtEvNc8wniDcqGcQwE3bQ91
         x24NuJOYcGnaX6HM9nVs+UQg6A+7mG+g3jU/s+deaEiPCTvjBEq+9nlzt6FqCVZXf/zR
         zZ0/MnFYGlGVF2oTWoE/f5PdolfOnBeODcnXT3FxNcQ+srDsBVXX5a1X+n3UGYCEAoDM
         e0u1xoyCGSyOYBU7K/58kQoKSbTWReHKx7CH7XzWbFCpSWoH0t/YTSh89aYHaeh9VHw5
         bl52ySUgLVUaA0Ekn+o+ZwP928cnIYkKuzF8hwpugZ7jiKXU2J4B9O1Rz2qYFsbpZNiw
         W2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709583428; x=1710188228;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D/7HbYGpfhKc4R/AKhfixpmLppzl+6hWOAPaqaIiEWg=;
        b=DinY/YKDSrsuGpbiezIqbuAnZJJga2KwV9fBHPS8Q7/ORH9HbSE1Y4aUncV+pjO+p4
         OFBD85qiovBLZ1I5ykkBtZJ/AarFLoUMNos7vzWL1tKmbQr+wYdg3PriTkG5Aj36czws
         LPX1yq+J6RF8s1n1aS87x3rs3+uWmzLrf1CgVZCU9SpkGV1LwLDTZtPzuGpuOpe5R4cq
         qvyUdDbfDKWmUjKFFhYEdbViM0BiSmKCVhNoxlRcmaKFINeLtOUhuL+tzYnb6E9FD5Ye
         q/IUP7Gh4JeKP+dx4W1+60FrdYKOf2oo5pgMQeDVjuothsjiYoXBXknqyQFtcgxe4igd
         MZkw==
X-Forwarded-Encrypted: i=1; AJvYcCXOykCPzX5sS8tSjjNnCR0XUxTQq1Hp/skPYXEm9/tKXJMqDK+dl3yovLd23WEKMt4hIR7t8BJuJTWbVTIkEeE78osc
X-Gm-Message-State: AOJu0YyBVAEFNSaX2sqX5lRGYvZ/i6Vej6ghvaa/7+KOlzvBokmoSeq8
	XHLom8n/SqMHMOoDWxf+jIRPNR445teCVUqUBt2s54L1HVGdD0azmtUb8RuHIQ==
X-Google-Smtp-Source: AGHT+IHr6gdKYnTTswAQcy1CWFm8BVVjO2yoUp9XyOgEfaWpHToZmKZh3vQrFcLvHQBQK3CC0t0v8Q==
X-Received: by 2002:a17:902:dac2:b0:1dc:a28a:52b9 with SMTP id q2-20020a170902dac200b001dca28a52b9mr772318plx.8.1709583428036;
        Mon, 04 Mar 2024 12:17:08 -0800 (PST)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902d48500b001db9cb62f7bsm8985870plg.153.2024.03.04.12.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 12:17:07 -0800 (PST)
Date: Mon, 4 Mar 2024 20:17:04 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Like Xu <like.xu.linux@gmail.com>, pbonzini@redhat.com,
	jmattson@google.com, ravi.bangoria@amd.com, nikunj.dadhania@amd.com,
	santosh.shukla@amd.com, manali.shukla@amd.com, babu.moger@amd.com,
	kvm list <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits
 correctly
Message-ID: <ZeYsQLs-_urXpdml@google.com>
References: <20240301075007.644152-1-sandipan.das@amd.com>
 <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
 <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com>
 <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
 <ZeYlEGORqeTPLK2_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZeYlEGORqeTPLK2_@google.com>

On Mon, Mar 04, 2024, Sean Christopherson wrote:
> On Mon, Mar 04, 2024, Dapeng Mi wrote:
> > 
> > On 3/1/2024 5:00 PM, Sandipan Das wrote:
> > > On 3/1/2024 2:07 PM, Like Xu wrote:
> > > > On 1/3/2024 3:50 pm, Sandipan Das wrote:
> > > > > With PerfMonV2, a performance monitoring counter will start operating
> > > > > only when both the PERF_CTLx enable bit as well as the corresponding
> > > > > PerfCntrGlobalCtl enable bit are set.
> > > > > 
> > > > > When the PerfMonV2 CPUID feature bit (leaf 0x80000022 EAX bit 0) is set
> > > > > for a guest but the guest kernel does not support PerfMonV2 (such as
> > > > > kernels older than v5.19), the guest counters do not count since the
> > > > > PerfCntrGlobalCtl MSR is initialized to zero and the guest kernel never
> > > > > writes to it.
> > > > If the vcpu has the PerfMonV2 feature, it should not work the way legacy
> > > > PMU does. Users need to use the new driver to operate the new hardware,
> > > > don't they ? One practical approach is that the hypervisor should not set
> > > > the PerfMonV2 bit for this unpatched 'v5.19' guest.
> > > > 
> > > My understanding is that the legacy method of managing the counters should
> > > still work because the enable bits in PerfCntrGlobalCtl are expected to be
> > > set. The AMD PPR does mention that the PerfCntrEn bitfield of PerfCntrGlobalCtl
> > > is set to 0x3f after a system reset. That way, the guest kernel can use either
> > 
> > If so, please add the PPR description here as comments.
> 
> Or even better, make that architectural behavior that's documented in the APM.
> 
> > > > > ---
> > > > >    arch/x86/kvm/svm/pmu.c | 1 +
> > > > >    1 file changed, 1 insertion(+)
> > > > > 
> > > > > diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> > > > > index b6a7ad4d6914..14709c564d6a 100644
> > > > > --- a/arch/x86/kvm/svm/pmu.c
> > > > > +++ b/arch/x86/kvm/svm/pmu.c
> > > > > @@ -205,6 +205,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
> > > > >        if (pmu->version > 1) {
> > > > >            pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
> > > > >            pmu->global_status_mask = pmu->global_ctrl_mask;
> > > > > +        pmu->global_ctrl = ~pmu->global_ctrl_mask;
> > 
> > It seems to be more easily understand to calculate global_ctrl firstly and
> > then derive the globol_ctrl_mask (negative logic).
> 
> Hrm, I'm torn.  On one hand, awful name aside (global_ctrl_mask should really be
> something like global_ctrl_rsvd_bits), the computation of the reserved bits should
> come from the capabilities of the PMU, not from the RESET value.
> 
+1

> On the other hand, setting _all_ non-reserved bits will likely do the wrong thing
> if AMD ever adds bits in PerfCntGlobalCtl that aren't tied to general purpose
> counters.  But, that's a future theoretical problem, so I'm inclined to vote for
> Sandipan's approach.
> 

right. I am ok with either approach.

Thanks.
-Mingwei
> > diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> > index e886300f0f97..7ac9b080aba6 100644
> > --- a/arch/x86/kvm/svm/pmu.c
> > +++ b/arch/x86/kvm/svm/pmu.c
> > @@ -199,7 +199,8 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
> > kvm_pmu_cap.num_counters_gp);
> > 
> >         if (pmu->version > 1) {
> > -               pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters)
> > - 1);
> > +               pmu->global_ctrl = (1ull << pmu->nr_arch_gp_counters) - 1;
> > +               pmu->global_ctrl_mask = ~pmu->global_ctrl;
> >                 pmu->global_status_mask = pmu->global_ctrl_mask;
> >         }
> > 
> > > > >        }
> > > > >          pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
> > > 

