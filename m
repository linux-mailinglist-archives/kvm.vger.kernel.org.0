Return-Path: <kvm+bounces-22223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD7F93BFFC
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 12:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A04C11C20DA5
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 10:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599D1198E7F;
	Thu, 25 Jul 2024 10:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KuOYSb62"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA9D16A95E
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 10:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721903750; cv=none; b=FuWuWzMkHvcuxyZnX6IaIXLRscD9yAL9J/yoAF0ymXh42KHmLBkfrPIP303GPktNDrKdKoT5p5OyHuaI0mZN2E1hvLYKmjtAl1X8Em/3BCesSv89THWu7vp12ixlX+6HR6Wb/33+DdQpG/FlgggYyT7SXdBb/ImnyfakTOB1BIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721903750; c=relaxed/simple;
	bh=Q3aWSAGnKal1WwPhFaGfCOmEfyyw9IqE6iZV7Okxsg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=edwnNLeVq95HCYRNyb7PHI+wN4l5TLfv0v5t1LM4s+jhKEyqnFM3LtRReJ6KNgxlZSc/MGVKh2zrjUr5tUXSh92nzGamacwx83Jz960lUbc0kzZRTXHwXwICmY0BnB2eNGbtn0PPIE6vZvMylEWjPeFkqlfaec10r5Vgy/uCCUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KuOYSb62; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5a10835487fso989419a12.1
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 03:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721903747; x=1722508547; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w5KerTRvkuy9w4kv3vS5mRyABQJuA2uQKXsWkiI4WfA=;
        b=KuOYSb62XqcwD8yMElV4+V0d/hEdkF7h1d+iQhIrFs8PjYTf6LgjtBkcRlA7o54KHK
         telBKxmPLhtPvpt78EF9gZ2IbKPHuV2SqrrrbBZrX19MFwU/8zEG/RdehBThH3nBQnme
         yfsjc1Sr/EeGrDMWfqIkmyG5FzssACne4xq3zZf/8hlMZjvp6Lih7aYK1695GoURXdgw
         t4pVfT6/zwe2yXnoPUuDxoYR2MHW9QUN73KMpBaIjQ3ijdgSW+rglen0L7EvK7lsiWnX
         JV5Cp+Zkaj7nnxgya6GJfRMAigcQCCDMnlBps83sT1vZhseXNrld4RGP6QRT0RvwYGSs
         l8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721903747; x=1722508547;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w5KerTRvkuy9w4kv3vS5mRyABQJuA2uQKXsWkiI4WfA=;
        b=vbHEBF35sxZGtz4Dh/p1smREABMyWHHOKB/TmYCxKFip0J2snA/rJB3/T5i0Ly4AnP
         txGBHzubwGlyyEqcD9+z0v2zyZ3p7yU919XPv4LQnnrNL76U3uq1csMhX564csWD0R+B
         9+sPmUk3hNPrgg2sJ8Y74ibkikVXTXEMR5zC/UedqypYAgzMiDOGWQ7IYUBMWLO+wsom
         KkWchRCnYEr6yxbOnYq+rAsnFOmxPh2oBoHMU39+lzEYEB8eD0ty5WZ/f5W30YWDAC4L
         y0s3GYmI6B/ZMyFwmAv7IZ/4QUOy71/L16VsxuNRg0quiiQCljxj5pkeWTmSL+pwtKc1
         uLxg==
X-Forwarded-Encrypted: i=1; AJvYcCX9OcIUsfdQ2SF4HOcHVSclLgRRwAYnL8JodLF7vQZuyXyFN+411dWCDXLCUSTkFszprKYNWt8hzJxU6++mqIYgOqyz
X-Gm-Message-State: AOJu0Ywrb1DxYg3R+F06wyq7GSTIzzxtdh6XCkUk0B2zsT/2aMM6QGrm
	X7gUpsDN9MXdEw1jO+Ci+C9uZrMVtneXDQrEyqOSbcD/ZJcWfucbtl8qUVzZzaxjtNNsf5wz67V
	dTpccfQTYyFntvxkjvc67eo32C7uj39ptE7lA2g==
X-Google-Smtp-Source: AGHT+IEcBYBM3u3BO1medaOE4ZDBSfard0UumxmemZPpsEyAGf4fpl2NSLGhyrGGWvZ67s6IQvdgbkFzTWZsaNzJM4c=
X-Received: by 2002:a05:6402:26ce:b0:5a0:c709:aa0b with SMTP id
 4fb4d7f45d1cf-5ac2c1c441bmr1896028a12.24.1721903747061; Thu, 25 Jul 2024
 03:35:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1721731723.git.mst@redhat.com> <08c328682231b64878fc052a11091bea39577a6f.1721731723.git.mst@redhat.com>
In-Reply-To: <08c328682231b64878fc052a11091bea39577a6f.1721731723.git.mst@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 25 Jul 2024 11:35:35 +0100
Message-ID: <CAFEAcA-3_d1c7XSXWkFubD-LsW5c5i95e6xxV09r2C9yGtzcdA@mail.gmail.com>
Subject: Re: [PULL v2 37/61] accel/kvm: Extract common KVM vCPU
 {creation,parking} code
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, Salil Mehta <salil.mehta@huawei.com>, 
	Gavin Shan <gshan@redhat.com>, Vishnu Pajjuri <vishnu@os.amperecomputing.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Xianglai Li <lixianglai@loongson.cn>, 
	Miguel Luis <miguel.luis@oracle.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Harsh Prateek Bora <harshpb@linux.ibm.com>, Igor Mammedov <imammedo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Jul 2024 at 11:58, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> From: Salil Mehta <salil.mehta@huawei.com>
>
> KVM vCPU creation is done once during the vCPU realization when Qemu vCPU thread
> is spawned. This is common to all the architectures as of now.
>
> Hot-unplug of vCPU results in destruction of the vCPU object in QOM but the
> corresponding KVM vCPU object in the Host KVM is not destroyed as KVM doesn't
> support vCPU removal. Therefore, its representative KVM vCPU object/context in
> Qemu is parked.
>
> Refactor architecture common logic so that some APIs could be reused by vCPU
> Hotplug code of some architectures likes ARM, Loongson etc. Update new/old APIs
> with trace events. New APIs qemu_{create,park,unpark}_vcpu() can be externally
> called. No functional change is intended here.

Hi; Coverity points out an issue with this code (CID 1558552):

> +int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
> +{
> +    struct KVMParkedVcpu *cpu;
> +    int kvm_fd = -ENOENT;
> +
> +    QLIST_FOREACH(cpu, &s->kvm_parked_vcpus, node) {
> +        if (cpu->vcpu_id == vcpu_id) {
> +            QLIST_REMOVE(cpu, node);
> +            kvm_fd = cpu->kvm_fd;
> +            g_free(cpu);
> +        }
> +    }

If you are going to remove an entry from a list as you
iterate over it, you can't use QLIST_FOREACH(), because
QLIST_FOREACH will look at the next pointer of the
iteration variable at the end of the loop when it
wants to advance to the next node. In this case we've
already freed 'cpu', so it would be reading freed memory.

Should we break out of the loop when we find the entry?

If we do need to continue iteration after removing the
list node, you need to use QLIST_FOREACH_SAFE() to do
the list iteration.

> -static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
> -{
> -    struct KVMParkedVcpu *cpu;
> -
> -    QLIST_FOREACH(cpu, &s->kvm_parked_vcpus, node) {
> -        if (cpu->vcpu_id == vcpu_id) {
> -            int kvm_fd;
> -
> -            QLIST_REMOVE(cpu, node);
> -            kvm_fd = cpu->kvm_fd;
> -            g_free(cpu);
> -            return kvm_fd;

In this old piece of code we were OK using QLIST_FOREACH
because we returned immediately we took the node off
the list and didn't continue the iteration.

> -        }
> -    }
> -
> -    return kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id);
> -}

thanks
-- PMM

