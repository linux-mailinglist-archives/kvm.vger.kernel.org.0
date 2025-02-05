Return-Path: <kvm+bounces-37390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 797AEA2995E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06A7E16904C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216881FECBF;
	Wed,  5 Feb 2025 18:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KKKc3wuo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C8C1885BE
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738781122; cv=none; b=HqlHph/v2qmjiqI2HM3y1pFOAvvb9xLcGnY1XIBBPHHO8yP5i6GFl/U68nPBtudwnHfZrQ7Ckmtof+X3rSEgEgr8y3VY318Po84+jQZoGfXeBuyNIIJHN1kFD8lGkNLQ4iA2GckNtS95i7q8pMVFkhut09Rs7Qxtor/9BpPV3is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738781122; c=relaxed/simple;
	bh=vH6VASVfSCJNTEKUEXfzEvUv2LHvkwSnu2Rht1IUPNE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=NhdWCKzSwnL1zsrTGCDR1SEupB73FzKqrtuVJF5+LLzZNJO7xet2AEVXDpcdxUBdvtZled406UCnCFhV1V169QfIYr7NbgNjhd1gBkCP/y2WjvPFbKCb/m5Ez6mDHi2IZbcIV0Vbo4eYPDzRct/Ny4Vbgzmj4ocF+dMX33z8VpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KKKc3wuo; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d04b70fe79so9205ab.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 10:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738781120; x=1739385920; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ob6s9tYF5ZtJYStyioBs6l9IVGqgO/LxopNKg4U7Oo0=;
        b=KKKc3wuoNk724z+5Ma/y64Cr550nFgZ04I6dn8bif8NxdBZRzYQSYGSlfCegfhXi9k
         reCjJn++fhAS5YXXS/u4VninmC01n6CumowMNR0qGocGUt7qbbw/ahXSGXKQTRlRYrin
         z4jmS3wIYYxljk8tjpXp+glUoG2SySKP7SjVFZtzQdIINWIykblmHkO4Ww31C9Xf8Z7m
         fISsmNQvWJrY4yVlvctKth8gkx0RzWyv1i/TjtEdJiqO8W+0lCYE89ZdmeZaHWuKVMmm
         4HTtFzIp7Jq6Jtyonp4j6rx8Y8KJ+3iDZXtJJ+5FEPKi2YF+ZAD2EClql22big8h5/XB
         ZP8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738781120; x=1739385920;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ob6s9tYF5ZtJYStyioBs6l9IVGqgO/LxopNKg4U7Oo0=;
        b=ng95A/46qxq5Kt6sD4HWC4zaFlubptV86QeVaMWua4SpyWXJmig2Thsfivctvq2Ydi
         EUQpTnPT27pcAP5kmwH+YDxvrdHQP0sB+0QHPXVadRwzEinp6BOKmTS1k7KNIYn/1+Lq
         J0wL/GK+Il0hgWmCmemiGZ6FdLraoKLinoC1W0tsXWkFL9MowW/7rYGXJm4dLfkpfvyO
         aKoBIL/RX0SEKAyqnLFqHBsKRNYwGtNCXmG+WdvDePDohIclx2ood6sFJauTYkVETBhH
         Aqi2ERPWTk3MZWfKVskyj1I0qg0uC2YKzFdG/hkPKqPdaDsHNRfbPUSVNDaXOrRwKhJO
         oJEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZij2KXp8+997AfIt/mybJUqXRatWCgxAx1MTbcDQ1vf2CxBzFILjFo9zH1s66FELahC4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6Q5DDfhuo2RK5V1W6yYaWCbSbl414256BVR1RwEaSFhF1efHO
	A50L14tR8xZnumjoi8Pq1L0brjdUcdKVMUQ+rAS6eqN8yalK8byTdqH30AJuPQzsK/nBV9vYFnE
	1RFPC7A+xVA3x1mFutlUE7Xm7ks35hWXLu32P
X-Gm-Gg: ASbGnctGD3kP3UVOo71lDvQ3AAuSjeItq/oPAWEPeot5mgSF6xV1OjZ+LBeypjRHJR4
	SAOAhh2XWF+pwdrqYnbxbFuvIopst/NbRcKtkEg3Wo3d9jG4LZ4l2RYlg4OAk+16wQNe+qt3t
X-Google-Smtp-Source: AGHT+IFGpBOvrq1mRFdL0+0b01B1BX5tMj/B4aJQMRqMHgjy9jiSXOeNNy8t6oCuvWF+uUYONn9I+T1DWRHyFyYMxPM=
X-Received: by 2002:a05:6e02:1a46:b0:3a7:dea7:87a6 with SMTP id
 e9e14a558f8ab-3d040f616a3mr8075435ab.29.1738781119660; Wed, 05 Feb 2025
 10:45:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250113200150.487409-1-jmattson@google.com> <20250113200150.487409-3-jmattson@google.com>
In-Reply-To: <20250113200150.487409-3-jmattson@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 5 Feb 2025 10:45:08 -0800
X-Gm-Features: AWEUYZmFwc9ferdftM2xHra8Onm6SJC_VwfB7SPT8T1VswTmC5UG5t4j9AxCNWw
Message-ID: <CALMp9eRB025OAi2fpdweKr+fOAovmOKfF7XPwvf8HJKbJSvmhg@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Clear pv_unhalted on all transitions to KVM_MP_STATE_RUNNABLE
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
	Gleb Natapov <gleb@redhat.com>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, 
	Suzuki Poulose <suzuki@in.ibm.com>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2025 at 12:02=E2=80=AFPM Jim Mattson <jmattson@google.com> =
wrote:
>
> In kvm_set_mp_state(), ensure that vcpu->arch.pv.pv_unhalted is always
> cleared on a transition to KVM_MP_STATE_RUNNABLE, so that the next HLT
> instruction will be respected.
>
> The "fixes" list may be incomplete.

The only commit I'm not sure of is commit 1a65105a5aba ("KVM: x86/xen:
handle PV spinlocks slowpath"). That commit introduces an mp_state
transition to KVM_MP_STATE_RUNNABLE  without clearing pv_unhalted, so
perhaps it should be in the "fixes" list. OTOH, this seems to be an
independent implementation of PV spinlocks, so maybe it's not a
problem.

> Fixes: 6aef266c6e17 ("kvm hypervisor : Add a hypercall to KVM hypervisor =
to support pv-ticketlocks")
> Fixes: b6b8a1451fc4 ("KVM: nVMX: Rework interception of IRQs and NMIs")
> Fixes: 38c0b192bd6d ("KVM: SVM: leave halted state on vmexit")
> Signed-off-by: Jim Mattson <jmattson@google.com>

