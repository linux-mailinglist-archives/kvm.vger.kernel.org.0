Return-Path: <kvm+bounces-14264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F148A17C6
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 16:47:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B94F284C91
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 14:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7A912E5D;
	Thu, 11 Apr 2024 14:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1RYuzBV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23810F9DE
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712846810; cv=none; b=mc2acZ0HQTMR4IpLO+6/McgrcRYcqTwS6wboqviZu5Wt10TeNvyDo4gJHHaewsgZ7PD5KUOldK0IvrhCqd9H5yT8aBoadVWxRL7lHssN4rw14B0pJ5IkPAbN0HdJBmHlA2GJBGAAhtDjJfaTnr9mpEuJZqTbuWFzTghGUgj3bj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712846810; c=relaxed/simple;
	bh=IEu8ao+7xqBgR+dzOKjYnc1P5DiKwj2piPwPTj9Zj+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KfvwZz7UTcuRb/pvHHpKmHAngh+6YwRtEwFWkRLTt+nkjir456z6mcwydGm1E1U+1OCSYI/UKmAfKkeIg5fALL0Drxq4rlczy1xcuEZIWxc3KCbai1kgMVEH4asnHLPjOATpi0cwNLRNHKPSIqIC7lf8cAcXV9IJ+Xo5pkgTx3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a1RYuzBV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712846808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wPChIqhlz2fj/t/mALU/XDAB+oCXF1Eufwk1f12pr9E=;
	b=a1RYuzBV50g6S5NzOQ/WeEjUAbO9JDqP+18iZ9UiUElrMip1Oav4N4zE74+XJoIQaBdoWZ
	VXBt0fz4H1tJ9yYG/l49aOB0K2zB2VdyVFLPxu6bNZNBkGAcpK3INqqdJY8B0Ug7hBzXDe
	nf0n85qwl1VRKHS1bVH+HK/L+1YRA0Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-dj96v9uDNBG7sBs7ohaFBA-1; Thu, 11 Apr 2024 10:46:46 -0400
X-MC-Unique: dj96v9uDNBG7sBs7ohaFBA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4147faf154cso36561265e9.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 07:46:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712846805; x=1713451605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wPChIqhlz2fj/t/mALU/XDAB+oCXF1Eufwk1f12pr9E=;
        b=Hw7PMj0VhCLZTWjwMlpyAOiPNdO4LiLw6qMA+ib+4vHmOCBsM6wfRYSuaPr46FZyKl
         XYaXz92GD6zbobCxQjejcMczV7FnGllTMtmNOA19B8SwxEJdv0XILQtp98+D10hB254H
         YiR/mnPK0sECpCDoFS2XI3AlVCe8ydqAR0fCz8VqwyZ3fE8hqqmML1CB9exeV/nBd9po
         /xDjCt7DK78Ogapq2pfUDg3DregCf5AHN4udsu2fktvu7BEdrIHF4Qy7KCRs1ErZR9EJ
         rpaZw3k5uy+uZ9NJqBhSOWvQnORKWvhL7HFmKAav1YkfnSq1kCCyR/Y8nfOtvJDLgs1K
         If+A==
X-Forwarded-Encrypted: i=1; AJvYcCWwZfjrCW2vRyF96odrAl/al2Nazv0h07gRbcGmW/rGG40JQCeEAmEot5RGuFVVFxR7oYYHK2IACatby8gNRvr20iRa
X-Gm-Message-State: AOJu0YyR6TCu+CPWxCQ2kKPgUjWbm/3xGm3BTFNjafsbIIxt8AwCRF+N
	DJy+LYI9fjPOGmo4TT84H/9Gk7mWJnrwnLA3xbx/80OZrJRfUeZL3K6SKO9Pi8trE+JXFMV32dv
	+cIO4HbkaJBEDpKc0D59n/VcPZWDYxSL0SS1PQF0tEOphI3rFVbPXcGdncgpaXbaYhim8gJYUbt
	BZkAeIsxN3J+E1QBriszfxrB/Z
X-Received: by 2002:a05:600c:1e09:b0:416:b5e6:d31e with SMTP id ay9-20020a05600c1e0900b00416b5e6d31emr18532wmb.4.1712846805556;
        Thu, 11 Apr 2024 07:46:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJ8IV6Wo/e+q6/I78C/41UvyqwTYiXcoZu/SgrWAXoRy0LwP1GCBmoob9JAuIdFAghUrppwRYtDXjrlI79QRA=
X-Received: by 2002:a05:600c:1e09:b0:416:b5e6:d31e with SMTP id
 ay9-20020a05600c1e0900b00416b5e6d31emr18508wmb.4.1712846805186; Thu, 11 Apr
 2024 07:46:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com> <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
 <abbaeb7c-a0d3-4b2d-8632-d32025b165d7@oracle.com> <2afb20af-d42e-4535-a660-0194de1d0099@citrix.com>
 <ff3cf105-ef2a-426c-ba9b-00fb5c2559c7@oracle.com>
In-Reply-To: <ff3cf105-ef2a-426c-ba9b-00fb5c2559c7@oracle.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 11 Apr 2024 16:46:32 +0200
Message-ID: <CABgObfZU_uLAPzDV--n67H3Hq6OKxUO=FQa2MH3CjdgTQR8pJg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
To: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com, 
	pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de, konrad.wilk@oracle.com, 
	peterz@infradead.org, gregkh@linuxfoundation.org, seanjc@google.com, 
	dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org, 
	longman@redhat.com, bp@alien8.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 4:34=E2=80=AFPM Alexandre Chartre
<alexandre.chartre@oracle.com> wrote:
> Still, we could enumerate CPUs which don't have eIBRS independently of NO=
_BHI
> (if we have a list of such CPUs) and set X86_BUG_BHI for cpus with eIBRS.
>
> So in arch/x86/kernel/cpu/common.c, replace:
>
>         /* When virtualized, eIBRS could be hidden, assume vulnerable */
>         if (!(ia32_cap & ARCH_CAP_BHI_NO) &&
>             !cpu_matches(cpu_vuln_whitelist, NO_BHI) &&
>             (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
>              boot_cpu_has(X86_FEATURE_HYPERVISOR)))
>                 setup_force_cpu_bug(X86_BUG_BHI);
>
> with something like:
>
>         if (!(ia32_cap & ARCH_CAP_BHI_NO) &&
>             !cpu_matches(cpu_vuln_whitelist, NO_BHI) &&
>             (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
>             !cpu_matches(cpu_vuln_whitelist, NO_EIBRS)))
>                 setup_force_cpu_bug(X86_BUG_BHI);

No, that you cannot do because the hypervisor can and will fake the
family/model/stepping.

However, looking again at the original patch you submitted, I think
the review was confusing host and guest sides. If the host is "not
affected", i.e. the host *genuinely* does not have eIBRS, it can set
BHI_NO and that will bypass the "always mitigate in a guest" bit.

I think that's robust and boot_cpu_has_bug(X86_BUG_BHI) is the right
way to do it.

If a VM migration pool has both !eIBRS and eIBRS machines, it will
combine the two; on one hand it will not set the eIBRS bit (bit 1), on
the other hand it will not set BHI_NO either, and it will set the
hypervisor bit. The result is that the guest *will* use mitigations.

To double check, from the point of view of a nested hypervisor, you
could set BHI_NO in a nested guest:
* if the nested hypervisor has BHI_NO passed from the outer level
* or if its CPUID passes cpu_matches(cpu_vuln_whitelist, NO_BHI)
* but it won't matter whether the nested hypervisor lacks eIBRS,
because that bit is not reliable in a VM

The logic you'd use in KVM therefore is:

   (ia32_cap & ARCH_CAP_BHI_NO) ||
   cpu_matches(cpu_vuln_whitelist, NO_BHI) ||
   (!boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) &&
    !boot_cpu_has(X86_FEATURE_HYPERVISOR)))

but that is exactly !boot_cpu_has_bug(X86_BUG_BHI) and is therefore
what Alexandre's patch does.

So I'll wait for further comments but I think the patch is correct.

Paolo


