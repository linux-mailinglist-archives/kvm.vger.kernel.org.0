Return-Path: <kvm+bounces-45214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 584F5AA713F
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 14:08:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD62F7AAE58
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 12:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3C724C083;
	Fri,  2 May 2025 12:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GSnBGksC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E3C20C488
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 12:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746187713; cv=none; b=SnJ5Sj7RUWJZACMA2fiaXhF+9OSZ/ZjWC/GkMjG444iFEWZd/cUhJ8UYYljmGqPpSqItPGPD+foNTgWj1/uIaWKZyamJwPIz9dcF6qog1vKVj4PmmDhhrto6P3iVsLvJMs/tToucxm/P8I3fptXhgyyq7KSx5tfeFqLuavQaLWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746187713; c=relaxed/simple;
	bh=QOYAWpKobYqIjKphpV8Z/XKHUtk5wosLnvilAePfXLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kqbujf5HWjoDAzMjh1tdJggn8gRfAQ8Q73mADnSQXtU6k8UuldzmYwYkfoJXKLXuIRdflSIYLXd/xSgbbNOOItvo9poawhY1EmCGCtzE2NVevIwCHlD4jPhaPzrZiyLqr8CbjPU/fuFvhIrOYKO4yMaOHEoVNz4v8JqzIRSOB8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GSnBGksC; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-47666573242so276241cf.0
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 05:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746187710; x=1746792510; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QOYAWpKobYqIjKphpV8Z/XKHUtk5wosLnvilAePfXLE=;
        b=GSnBGksChFEouPySf6ys9/HEZS7t/eR4bbS/j9IbvKkvC8IWykxDrys5sA4Sf8B1ww
         ShklWetyejpVkyGTBYNvFDtudKarmbPfEvu7vQkldjtN3Ar+V83Zp+62s//E6Uzm2xe2
         G0pTH7fV8ZNgh1Y40D8oS8I3fUexAOlG1XXVkHwbO/GER4Gmq+d7NoQUhn+FIJqcH+nM
         7DLZ5cKzt/0t9qO7ObFdbi4t3LXKEeZmDVq12tutmqzTn6ld5KBvIcrxpFIMtjpRRcGK
         FglYljHIIHdIUL2PTuES8watsGzHnNdaiCgsXEf8NioNlWBNMp09TlnnUTEhEicfi+nE
         fI0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746187710; x=1746792510;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QOYAWpKobYqIjKphpV8Z/XKHUtk5wosLnvilAePfXLE=;
        b=QjRY39Zc56lXTDxkUH+Nk/CTU38cB632oAGt+XP8GB3rWHbLE8IDcrczs293VAfzlP
         SNFSyH5sxpe4DboEsVVy4vxKnxTEwAUvOOg+3Xh++mTI4RgLbiPFn2/4I/4F9SJO/K71
         A0CQBAeZddC7FgaA0mvd0Dh5NpfU5hcf1tYa80/Riw230F8kNcbmeIfR6RJnQS469jy9
         QGT4O7ZgKljGuut5II6t2rIWwRehG79rkBznV1czelE8mM7JN2RhDFnId+0A6t33pDhy
         tkErMSvQrDXr2p1ArUTRgak8LDUWpcEbif0DSYaiNgbmVkcdA63ZWqKf7RyoAHB5eIzX
         te4g==
X-Gm-Message-State: AOJu0YykhYLngnpIs5ElnWFyjZyw8EtYT+0pDjavlKvSapG2bSAP/JAo
	rO9/z245/3IvP0TXcWq7Dzd1rxCtoGcDshVXcXcNTYQiwgmByJyEoeJO2cidic64tiqXiZgpgnn
	LgTkZd5CqltcVK/M01OqfPbGtuKI2DGTbZ9+t
X-Gm-Gg: ASbGncsNOlhhGYkHscougegm9uu4XOqxBujWatxcYL1rfFOIwWHwa+A0n+0pUAkBQFd
	D0jGxY0uesWSIfaM3sL/Q7BntKM5AZGxqwSk7g0pULGEqAF4PPmid8UEGrONMjh3NFacXmW1Ouk
	7c3zB5dn8uzkow54rHFtgy0Aw=
X-Google-Smtp-Source: AGHT+IFD/MsTgc6vAXhalHp3lSHY/zI6yBsMV+4pwk8VJYi3tcrdAsdF1VYpeQlCegmMmQLptp5frPe2rF3QY8nkeMQ=
X-Received: by 2002:ac8:5f50:0:b0:466:8887:6751 with SMTP id
 d75a77b69052e-48b0dfdf479mr7304751cf.23.1746187710146; Fri, 02 May 2025
 05:08:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com> <20250430165655.605595-8-tabba@google.com>
 <6813eb1d4a3c7_2751462949f@iweiny-mobl.notmuch>
In-Reply-To: <6813eb1d4a3c7_2751462949f@iweiny-mobl.notmuch>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 2 May 2025 13:07:53 +0100
X-Gm-Features: ATxdqUEyPJsH6qCjTcFpIIVKvFZgDnFG5sJ_CyENlF3D_EvMdzHrMzHO_DPv0oc
Message-ID: <CA+EHjTwmC=+tzKHvkH5t_mgg0irOwwZyD0N8BiCSYkyre+=JCw@mail.gmail.com>
Subject: Re: [PATCH v8 07/13] KVM: Fix comments that refer to slots_lock
To: Ira Weiny <ira.weiny@intel.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 May 2025 at 22:43, Ira Weiny <ira.weiny@intel.com> wrote:
>
> Fuad Tabba wrote:
> > Fix comments so that they refer to slots_lock instead of slots_locks
> > (remove trailing s).
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Thank you for the reviews!
/fuad

> [snip]

