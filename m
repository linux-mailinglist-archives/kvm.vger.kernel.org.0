Return-Path: <kvm+bounces-13899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E621D89C5EB
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 16:02:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15CF51C22D49
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 14:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C93C7F7C7;
	Mon,  8 Apr 2024 14:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="dhpGhW4A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418D57F46E
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 14:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584908; cv=none; b=PxP8UQTFsgzfcZNQD0CcZUnSor3qmEEEY8qeSwcj6LWLU6YFP4lVKAHQmxtDf3kYHGWeo3QOmNf5m3YmZrrnjjCrTStdJzNkcXbtJ9JqPqtYAVD/+aIn3Qe0rWjlspA1fBTeUriuwRNDUDy9/Dk5VnM4Kk/bggfwlQMNomIUpPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584908; c=relaxed/simple;
	bh=UzqjiQxC9DO10jx1lYBKM8CUcdUiln6e7HY1avvUJQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c0RMdPjxnRDOiuv5939Wt7HurOmfiXgPCBj3+jfzGQNlxNgCVO/tGCP9hmNUznuR7j9cwNpXtl/o7arVdoQzxIE5nrHANjbuTL+gxS733ZPTNnuvBURg/AS8WrRi9BbNVeb1W0ukjrFfui4aE9F0t3exBh4ggpR8RWH/DO4W1lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=dhpGhW4A; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-61587aa9f4cso45269057b3.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 07:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1712584905; x=1713189705; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZIVt49hrGpaSXZb3Y7BwY7k2PHPt4HOP+2QhXBFS9k=;
        b=dhpGhW4Afe1sitMlNJzYN9HpbCi/K6lx1zANG/rnVLm0neuJ4MqYxF+E69VHK+eEzQ
         pyh2ZwSwoRNtNZY+sU2viY4M4UDtiH0lGhNWf89YEO6eVss22zKelf5AHG7tH1Yekjkz
         pvYIRGyoxCHAc0YVj11iy7wRjdZMBrT5Da8FDFsdD0e5LL3Iyly6ux1kOqhWRTwoNSlN
         FZczqrjnMhnCSaQsRa34SWki+RIUnfYtxj1dEuUrpWJYsk5RscCbMyxpHKYgrSCtThsF
         duxxpwqSIHy9ym5F832KMhHIbK175cZ6MN04HMBggwFcXsFJ/bk4A/+/6kRsW/yddeTg
         Ys9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712584905; x=1713189705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZIVt49hrGpaSXZb3Y7BwY7k2PHPt4HOP+2QhXBFS9k=;
        b=F/mj7/vJ8mA9M8LJQfb7OPfiIa05+3maVein/GPKHQoi6dzewI5iJo+LN6hgzBvcOp
         sM+YSSvzqIKSjZVMpKNVwbbRL+RDwZKnvzgfluUsls5T+3IyMv3a5Z80WBizEpnwzDsD
         F852taFOJ46MyPiePQdH5GxBdZasrLhofPsJBZNx4yyUgJxeBAP5h+TIy9l22MqMjsfa
         Gmqb+mM99hf5ljaYeoZdgbyo5Qc0NWeBz4XLxiwfu/WKJqyZAkHuAlkFyZJa1unQGSKW
         3OwG5mxPhr1+OFupnjvoS0BaZEGkIUS7q3RaKywMQg32owNhyKdEk49vjNcJTPxD0LHh
         JL0w==
X-Forwarded-Encrypted: i=1; AJvYcCUMh0RkUAlm3sI6TuQS+0iNdmhbZPSvrM1CmGA98ZTlvELISlzEIV3ZTP9Bfeti2ahSExFUMLw+4zLE3zWzlF98MAX7
X-Gm-Message-State: AOJu0YybCPDT7aPMwIjOtVn2ugRxtp/nnhpar6o7rK0Frc2f7H4W/kWn
	3Dsqg4N0hHnGrKMidi4cPLaA7P9booiTtKYyYIal+HRweL6Rr7QyHF/U7aFp5KyNjdVWVIJ99cr
	zDO1KPM/pGyAIXjp5N3jKwLpmieNi4Tl8vDkkyw==
X-Google-Smtp-Source: AGHT+IGE6HrRmYX7o9hiPGxuhVfSDqTpIN+FVF3dbND3l8qGamKfkvccfJGt2PpEhpPV8Ksj0onzetgE4GoC1C/LZr8=
X-Received: by 2002:a05:6902:1005:b0:dcb:ce4a:bc2b with SMTP id
 w5-20020a056902100500b00dcbce4abc2bmr8201909ybt.51.1712584905211; Mon, 08 Apr
 2024 07:01:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org> <20240403140116.3002809-6-vineeth@bitbyteword.org>
In-Reply-To: <20240403140116.3002809-6-vineeth@bitbyteword.org>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Mon, 8 Apr 2024 10:01:34 -0400
Message-ID: <CAO7JXPh=g2psw_ziw2vAZH8e_Hd_bOtBTsKW1uaBANo7RoQSXQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/5] selftests/bpf: sample implementation of a bpf
 pvsched driver.
To: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Joel Fernandes <joel@joelfernandes.org>, 
	Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>, 
	David Vernet <dvernet@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Adding sched_ext folks

On Wed, Apr 3, 2024 at 10:01=E2=80=AFAM Vineeth Pillai (Google)
<vineeth@bitbyteword.org> wrote:
>
> A dummy skeleton of a bpf pvsched driver. This is just for demonstration
> purpose and would need more work to be included as a test for this
> feature.
>
> Not-Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> ---
>  .../testing/selftests/bpf/progs/bpf_pvsched.c | 37 +++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_pvsched.c
>
> diff --git a/tools/testing/selftests/bpf/progs/bpf_pvsched.c b/tools/test=
ing/selftests/bpf/progs/bpf_pvsched.c
> new file mode 100644
> index 000000000000..a653baa3034b
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_pvsched.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019 Facebook */
> +
> +#include "vmlinux.h"
> +#include "bpf_tracing_net.h"
> +#include <bpf/bpf_tracing.h>
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") =3D "GPL";
> +
> +SEC("struct_ops/pvsched_vcpu_reg")
> +int BPF_PROG(pvsched_vcpu_reg, struct pid *pid)
> +{
> +       bpf_printk("pvsched_vcpu_reg: pid: %p", pid);
> +       return 0;
> +}
> +
> +SEC("struct_ops/pvsched_vcpu_unreg")
> +void BPF_PROG(pvsched_vcpu_unreg, struct pid *pid)
> +{
> +       bpf_printk("pvsched_vcpu_unreg: pid: %p", pid);
> +}
> +
> +SEC("struct_ops/pvsched_vcpu_notify_event")
> +void BPF_PROG(pvsched_vcpu_notify_event, void *addr, struct pid *pid, __=
u32 event)
> +{
> +       bpf_printk("pvsched_vcpu_notify: pid: %p, event:%u", pid, event);
> +}
> +
> +SEC(".struct_ops")
> +struct pvsched_vcpu_ops pvsched_ops =3D {
> +       .pvsched_vcpu_register          =3D (void *)pvsched_vcpu_reg,
> +       .pvsched_vcpu_unregister        =3D (void *)pvsched_vcpu_unreg,
> +       .pvsched_vcpu_notify_event      =3D (void *)pvsched_vcpu_notify_e=
vent,
> +       .events                         =3D 0x6,
> +       .name                           =3D "bpf_pvsched_ops",
> +};
> --
> 2.40.1
>

