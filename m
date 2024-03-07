Return-Path: <kvm+bounces-11307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 352BF8751E2
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 15:31:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8F15B2790B
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 14:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F761EA7C;
	Thu,  7 Mar 2024 14:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tksqbjoX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15591E89A
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 14:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709821835; cv=none; b=RcBl3TzeYXuI16F6ytKj3p9JrDNuT6/DeuYW4FwRkIdMzhoXHvdwUcMC2Cs6L++xduZk0TtdJeSKVTb1vQZhMkoBqZnVpe78Rq9iYiM7FpOCni9T4g0Myh77gYY34S/o7zgQJqNDdbJgJcYr95xuv9IZaEAGp/SQpi4q5YO2gH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709821835; c=relaxed/simple;
	bh=Q53ulGj/OUW0Xpudx9yI+PrPeWdV0r48TtFHRKuObNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ukNK5IJQ5fmKzB6y/sr2RsxLj64JXPydh29mv3mkdYAme1iQ4jqxiZBI4XMQ/ncLT4Jfk8vpFQHOT+vha/bS0glpE/7Dwxvjdwp9W0giXwPnzKSY07Yx3nw+x0kow/xd19ur9ccRZUhyyqJ0ToQyZ/tzDXLvfcHyi4s4GojdRuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tksqbjoX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5ce632b2adfso750712a12.0
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 06:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709821833; x=1710426633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YYYsNxYdvDYSBDgwXknTihQ30Mu1y1yczIPGPd3QlPU=;
        b=tksqbjoXbMxkurLleINBDfXskvDqPMKIHQcjn2IYV0l1kS9BSrJNS9KcX5+rrlY2Pz
         y2KB+EJQD+ZXSAAJ53YNtY+G0EDLBdXukWLn3aDMzevt0gRxS8J5T5KEDshOey1EaNFu
         KgwawF6DD89T5GY+cCezJjAiCpg93Mc+B3QYmXTYsjJNveFn0TC7VILscIZXEhRfkCom
         xfxv8f/UKfarrQTsRfbCSwR4dF5rbl+HoHd3/A3171tCw/3+xHekKHXwlX+0w4GiaMDY
         P08hMI/kgI5m10G7/VnxxEkgBj7R7mp5qTsoDfvOhaAvb4zlrPBde6CheuLQqrj+9knf
         yyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709821833; x=1710426633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YYYsNxYdvDYSBDgwXknTihQ30Mu1y1yczIPGPd3QlPU=;
        b=h0wVKzwy4njRDIvylK++mK1FBCumNK1E8Z3NvytyN7c8lFaYR1spVXZq+zYLYAUY5d
         RNO/jgo4BK/EE2ehFNVV2e2k+GMMOmq0wycF7Q2uNmPJne0FOQXsCvnUQAxf7tE/EW6N
         ltA/DVSGIqRt6/PujMkfvxsyN6Iyhswg1l36mpS9mipmQLt38Qxg9y4KAHLJNXTzy6AQ
         ehja8VMvQnpwwl2PJEUkEImB1hEDKYpgCM0ug+GFRsj/2vhL/k5Zfebm/FWd3uqzcsAL
         uo8L5j0ZFeiFxwSwBP5xW7R3VYiqVbl9WAaHoplZaBE/iQsiCuJktlXSaj6zTPbFf70X
         HERw==
X-Gm-Message-State: AOJu0YxLhosQcpuGXjqd/tV9qBNdujQpkrPbl4AE0tFD6IHkIJrwbjvg
	8uVo3k083ocG9Z98DZkwVw4w3OvAqmoYaZbis/fv/83wnnNQS2B4LmG9BUfcBv81Ade448BcMz0
	whQ==
X-Google-Smtp-Source: AGHT+IG0qG/KaO4E6qlW73/iuTzrET6wxm+Z8LhNEG1/J3bSokT2NsFKqyxCzCAJthjUGrQk4dcuioHv6MQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1c63:0:b0:5dc:af76:660 with SMTP id
 c35-20020a631c63000000b005dcaf760660mr48005pgm.10.1709821833133; Thu, 07 Mar
 2024 06:30:33 -0800 (PST)
Date: Thu, 7 Mar 2024 06:30:31 -0800
In-Reply-To: <20240307054623.13632-4-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307054623.13632-1-manali.shukla@amd.com> <20240307054623.13632-4-manali.shukla@amd.com>
Message-ID: <ZenPdRGYkf-Y-MgD@google.com>
Subject: Re: [PATCH v1 3/5] tools: Add KVM exit reason for the Idle HLT
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, nikunj@amd.com, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, bp@alien8.de
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 07, 2024, Manali Shukla wrote:
> From: Manali Shukla <Manali.Shukla@amd.com>
> 
> The Idle HLT intercept feature allows for the HLT instruction execution
> by a vCPU to be intercepted by hypervisor only if there are no pending
> V_INR and V_NMI events for the vCPU. The Idle HLT intercept will not be
> triggerred when vCPU is expected to service pending events (V_INTR and
> V_NMI).
> 
> The new SVM_EXIT_IDLE_HLT is introduced as part of the Idle HLT
> intercept feature. Add it to SVM_EXIT_REASONS, so that the
> SVM_EXIT_IDLE_HLT type of VMEXIT is recognized by tools like perf etc.
> 
> Signed-off-by: Manali Shukla <Manali.Shukla@amd.com>
> ---
>  tools/arch/x86/include/uapi/asm/svm.h | 2 ++

Please drop the tools/ uapi headers update.  Nothing KVM-related in tools/
actually relies on the headers being copied into tools/, e.g. KVM selftests
pulls KVM's headers from the .../usr/include/ directory that's populated by
`make headers_install`.

Perf's tooling is what actually "needs" the headers to be copied into tools/;
let the tools/perf maintainers deal with the headache of keeping everything up-to-date.

