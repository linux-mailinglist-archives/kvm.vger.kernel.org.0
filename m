Return-Path: <kvm+bounces-67791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C20BED1445D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:13:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C2BA3300AB0C
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F16C37419C;
	Mon, 12 Jan 2026 17:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a6P4skvY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PZ7QVE9x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E488236E462
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237900; cv=none; b=M+b3j55bQZKoscoHWb+9DVTaHRIfopoeBLmGUvb53dIk6RUtYPDOl4MhGlnnB4nFOSMrOfoSztf09aqIMfBnSCrQn/BOpR+mdsVrTcSla9Ah1OFG0IhfL/3VRfE51HM7Lk2UXzlMOVqOJzFiNDCuXMHfBJA8lpHfzI6cDtJLX0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237900; c=relaxed/simple;
	bh=EyrTa1GG/Km+sqDbaCTA8T8eIlsNKHYrHd8+rTZ/LMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OUHLEUDjWXFnv2eCh2pMYO3Yg2uOtVmbJsAYMg9ydeEYbWUUhVMx/msCbnsDzc7pzOGbZl5VNIrWt0aB+gMj68mubRHh9aT2o19R/sN1GNWEwoHwmez0nFZg9W8Ind8L1E+KQsDaiHbysFahld9KUNnTuRdkibBxfWShKLQbv9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a6P4skvY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PZ7QVE9x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768237897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jeffuZkEBfflLSw4ZjTzFu7MFv/30yg8h/xlp/3ODDI=;
	b=a6P4skvYxLKvB3iFDTnB+y7f4wWBXbme1nz4i77DG9Xi+q0cpE5jYLJfj3prvmoZZeIf7F
	Elyz1p7NLMzzF76OPrniT97sz2Ws4FUjb+3t+YSLA9hAHa5EHnKSCB91AgvnAzYHtsCDOR
	Kef5ebpp01SKiAfuHYenHuJGi8w5Wyo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-F6GN958bN96mvIr8AIb1DA-1; Mon, 12 Jan 2026 12:11:36 -0500
X-MC-Unique: F6GN958bN96mvIr8AIb1DA-1
X-Mimecast-MFC-AGG-ID: F6GN958bN96mvIr8AIb1DA_1768237894
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43065ad16a8so3748003f8f.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768237894; x=1768842694; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jeffuZkEBfflLSw4ZjTzFu7MFv/30yg8h/xlp/3ODDI=;
        b=PZ7QVE9xvW8iZP55Bqf/38ctGPVIv2rz7kHW+0voTaZOPTn94fmf+ueQ4ylMuj3Rh+
         ncW+qHtDV0daFF1tPuz9Slz3pwrD8xbcfd/uS2dftS1Zzow6YH4TeDySHZZ6/0I0zTaA
         r7QBMj2TWNXOBpSQhdGDaeO+Za+WvITLsV8jRFA1XGLV21Jcg349t4DkjXwhR3Aa4WFY
         m1cB4DLeCoS5KccDDpHEH3ds2R1XIARch6PB/n2uAp8lS1k63dWsZEZf+/kJ8SbL9ZeU
         0KTnJAw3brJWJBZLqFhbbiAo+omF701qYZeQcPCsyY52evDZUqRukPu0MQGcxTpsk4rv
         GaXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768237894; x=1768842694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jeffuZkEBfflLSw4ZjTzFu7MFv/30yg8h/xlp/3ODDI=;
        b=c/avuGdGycH84N4kuvRPguH+luoGoNzkeVxEtnGWP/75Q2A72KYyskwZm3SrNC/IiB
         S7Z9mdVqIS5o+BNAKSdGvxhoznsIb8ICu4FBlwfCDqj0wOFNdnHIYhgMY9rvbkMXlLJ0
         CMRU8Ocut3GfJ1/aKmBnpojcD6eXfQAJFK8N6JyYspCmXx0QkFtOTBKxfCdOT9CSCICg
         Slb506ItHJWRvkqZdqIJqkQH3tlnSma6R2lJGfoSgb1dTBH0+o3aVJFkN8RmLBdGxwoY
         D/5emDwnUteWc9nSXuGex/7AAwdvYEXBJkHLyt/fjBcMCrEx0CZWm4OuftE0/821HB3/
         tX/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUpSZgvk31veBKLGjwKhgriP23H/qwff2v6Ht2EaBpKjwGwoiFRjy2UbaWq0Ed6ZRu+7Ng=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1dOiRGmTMkUWcL5/bheSTOumbcJoYsvxghpOYe9fpXbU7DXAU
	bNuK94nGyJNrpiWSPumoie6y/RJX2ibVPHpVxZW3PFR55+MM32RwukRsgPkrjAxeOoqmEByF8NX
	7v3M2DhkT7Hy8JegH5qt5GBPrVlnvQI5Qwzl6dy7OyPF/mRgQrtZMSTs3JG0osS71SYB3BYnytZ
	KHUkXoiDT6xsQnAQFKNvDZQsWehBeW
X-Gm-Gg: AY/fxX7CycCgUfspXAKXcWG93UVEcOWZ5y1gOaTHOlPcazcxn9Txaa6rMPrtMX+Euly
	1wKBCHGS7IoEw8cttCnb2Emg5xbTmIYZVoui/hOCMtb0Qh5jX9EXgxy5MnJP2gczvcg0BngIcV0
	45ciNqsJhiD8xYXUOOQyHuWjnMA4E/k4OTBi/9/jkBKC+GwG+5E//eiT50tQsbs7d60ipmqIzmH
	IBaA1u9aL2O9E4Mz+gxgPoG/eGRaeKEEfRdaaezc6uuBhI88imI2w1pxLHW47L2ut371g==
X-Received: by 2002:a05:600c:4447:b0:477:3e0b:c0e3 with SMTP id 5b1f17b1804b1-47d84b3b8b9mr198369515e9.32.1768237894405;
        Mon, 12 Jan 2026 09:11:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbj4ph0kqZXQYG+6hVJBWnZOnbRQ5gOzRPnLbag3DhtIZbvTfxen4++f86lHcI3uy+ybhCs5jQjvzZk2f2Yv8=
X-Received: by 2002:a05:600c:4447:b0:477:3e0b:c0e3 with SMTP id
 5b1f17b1804b1-47d84b3b8b9mr198369255e9.32.1768237894056; Mon, 12 Jan 2026
 09:11:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112132259.76855-1-anisinha@redhat.com> <20260112132259.76855-25-anisinha@redhat.com>
In-Reply-To: <20260112132259.76855-25-anisinha@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Jan 2026 18:11:21 +0100
X-Gm-Features: AZwV_QgoeN4vU_XnIQnrItPwiaLkf6qjTWDTE0Y07V15XachaTAf23ut68EpYsY
Message-ID: <CABgObfYWjQ2FwZZ5Evwdfh4aCdK2cJxO71U+KBgpzB6Jh18zyA@mail.gmail.com>
Subject: Re: [PATCH v2 24/32] accel/kvm: add a per-confidential class callback
 to unlock guest state
To: Ani Sinha <anisinha@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 2:24=E2=80=AFPM Ani Sinha <anisinha@redhat.com> wro=
te:
> diff --git a/system/runstate.c b/system/runstate.c
> index b0ce0410fa..710f5882d9 100644
> --- a/system/runstate.c
> +++ b/system/runstate.c
> @@ -58,6 +58,7 @@
>  #include "system/reset.h"
>  #include "system/runstate.h"
>  #include "system/runstate-action.h"
> +#include "system/confidential-guest-support.h"
>  #include "system/system.h"
>  #include "system/tpm.h"
>  #include "trace.h"
> @@ -564,7 +565,12 @@ void qemu_system_reset(ShutdownCause reason)
>      if (cpus_are_resettable()) {
>          cpu_synchronize_all_post_reset();
>      } else {
> -        assert(runstate_check(RUN_STATE_PRELAUNCH));
> +        /*
> +         * for confidential guests, cpus are not resettable but their
> +         * state can be rebuilt under some conditions.
> +         */
> +        assert(runstate_check(RUN_STATE_PRELAUNCH) ||
> +               (current_machine->cgs && runstate_is_running()));

You can remove the assertion altogether.

> +static bool tdx_can_rebuild_guest_state(ConfidentialGuestSupport *cgs)
> +{
> +    return true;
> +}
> +
>  static void tdx_guest_class_init(ObjectClass *oc, const void *data)
>  {
>      ConfidentialGuestSupportClass *klass =3D CONFIDENTIAL_GUEST_SUPPORT_=
CLASS(oc);
> @@ -1596,6 +1601,7 @@ static void tdx_guest_class_init(ObjectClass *oc, c=
onst void *data)
>      ResettableClass *rc =3D RESETTABLE_CLASS(oc);
>
>      klass->kvm_init =3D tdx_kvm_init;
> +    klass->can_rebuild_guest_state =3D tdx_can_rebuild_guest_state;
>      x86_klass->kvm_type =3D tdx_kvm_type;
>      x86_klass->cpu_instance_init =3D tdx_cpu_instance_init;
>      x86_klass->adjust_cpuid_features =3D tdx_adjust_cpuid_features;
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index d45356843c..c52027c935 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -2632,6 +2632,14 @@ static int cgs_set_guest_state(hwaddr gpa, uint8_t=
 *ptr, uint64_t len,
>      return -1;
>  }
>
> +static bool sev_can_rebuild_guest_state(ConfidentialGuestSupport *cgs)
> +{
> +    if (!sev_snp_enabled() && !sev_es_enabled()) {
> +        return false;
> +    }
> +    return true;

This is always true, because if both are false then CPUs *are* resettable.

So I think .can_rebuild_guest_state can become a bool member of the
ConfidentialGuestSupportClass, instead of a function.

Paolo


