Return-Path: <kvm+bounces-38204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D8BA3680C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 23:08:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61E8616361C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 22:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1411FC0E3;
	Fri, 14 Feb 2025 22:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ao34ykpr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0D91DC198
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 22:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739570902; cv=none; b=tUYnSky1HTC/v3rg2Rw4ZxCZlTcZnW54WgcqxNJT5hCegdSriXq7/5En3+3DhLjQa2PNJV3RZo0+rQLaoiDTKeKAiaF1iEc8ZZUOo/jaZDJ2k4dcjIDRq4aszWwC2K6WJQtVVFNE1nactwv5oM6bdlFNGS/M8jl+jCj0ilYn3qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739570902; c=relaxed/simple;
	bh=+S0feFX4+O2b8w5KKspjSVYkfUrOBdXi9ncupiffcxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k03PD+xxVddCeNsyfrsdQrDFjiRStvPrVAmy6Ak1XyFPWMlpv3UvGmbI2FnLDYaV4h5VJO408EHDp/CQjmcs7xxdUZuplOdLWT0vkfQvM7dnptYPxElHVij8DKjkaGDkg8GKpvS3Lu+kb5qjVPo7ARvi1mrbpbPuDzCqSMkaEIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ao34ykpr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso8187412a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 14:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739570900; x=1740175700; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=scQo1Z0BvfXqqSWbdbwx1gMTHkxeVBHV9U8/vVYZKLY=;
        b=Ao34ykprHf1RZ7SzReUBmPi+FZSZzr0QWNolql0tYTlPU23kiWxd/cp/5cR0Mxk1rw
         6ncDNh2v1RLfXznJHusEIA3KqJG3FU31zaDObd0lAc0ME3Me0hJWHkvYTggRemaOHAqy
         GYazNgBSKngBzvJM/v/EwtAXrp/62QO9BqFHOlRAkbsMeTRHia7j6RLhKk5hB3gEmkoF
         hMi+tDXNK9xBTbXkZBa4ZlYRNSYbzMvT9u+5B+iV+VF1WCaFKXMPcb9ar/kkEqUj9tYq
         GTCsUWQ6Agiut8x0kc4J1Urfupp0QAPYosSdiO4/NvXRifVFm5lqu5uQHoh+vrnJiWu3
         1cZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739570900; x=1740175700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=scQo1Z0BvfXqqSWbdbwx1gMTHkxeVBHV9U8/vVYZKLY=;
        b=qO3QZzwl9bFP65nu9e1nd+0f+de236F5Ki/e+2dbVyFhyqAxnMvaCUp4m4vgw8wB17
         OiWGZsJvdLZcAnBNZ/qP+UuKP+RK+tlsMYOn+N/bV2TDfVHT8g79i8Ao08Lo8YT4c1lr
         FV+52c/tEpAczlCpeymKyn3IxbSifZePeLiI8AEvXcdDomw9eOYmEX76YjkLZgSMIlhD
         xIcr2+98FMLKk1OQfliBDXZE4/hGSK3u+DcQivlqKLmc9fZs/Fe108vNOy1erTGRd5S5
         4n8rcZg87j+v4AZ6kwHx1bdDgUsyirFDv71JKbkigv7afQoUpfkn6J4Q/HX7Wu4wlkHU
         H72g==
X-Gm-Message-State: AOJu0YyMkB7/biIHIGStj+72GF90f1g+I8902elYwSvjLu+j4N8uiH7h
	I67y8ymtnBeRUwgQVcxLtjQfMTppn+J7eTWy8HcCk2vt1sSLDrAbi7VrzUEWHfD8Yzwk2+t977r
	LtQ==
X-Google-Smtp-Source: AGHT+IGVqDdcAcTjVZzPtQ8Y1I6QFgr9RPAX7/QuaMvy8EAMqscsjXrLCh0ytyf0sehLhKkYsP4+rwT5sKw=
X-Received: from pjbpq11.prod.google.com ([2002:a17:90b:3d8b:b0:2ea:5469:76c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35c6:b0:2ee:c291:765a
 with SMTP id 98e67ed59e1d1-2fc40f105bamr1055188a91.8.1739570899863; Fri, 14
 Feb 2025 14:08:19 -0800 (PST)
Date: Fri, 14 Feb 2025 14:08:18 -0800
In-Reply-To: <20240907005440.500075-6-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240907005440.500075-1-mlevitsk@redhat.com> <20240907005440.500075-6-mlevitsk@redhat.com>
Message-ID: <Z6--0nKVbsxfm9ao@google.com>
Subject: Re: [kvm-unit-tests PATCH 5/5] nVMX: add a test for canonical checks
 of various host state vmcs12 fields.
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 06, 2024, Maxim Levitsky wrote:
> +#define TEST_VALUE1  0xff45454545000000
> +#define TEST_VALUE2  0xff55555555000000
> +
> +static void vmx_canonical_test_guest(void)
> +{
> +	while (true)
> +		vmcall();
> +}

...

> +static void test_host_value_natively(const char *field_name, u64 vmcs_field, u64 value)

The error messages say "directly", wheras this says "natively".  I don't have a
strong preference, but they should use the same terminology.  I'll go with
"direct", because "native" has paravirt connotations that could confuse things.

> +{
> +	int vector;
> +	u64 actual_value;
> +
> +	/*
> +	 * Set the register via host native interface (e.g lgdt) and check
> +	 * that we got no exception
> +	 */
> +	vector = set_host_value(vmcs_field, value);
> +	if (vector) {
> +		report(false,

report_fail()

> +		       "Exception %d when setting %s to 0x%lx via host",
> +		       vector, field_name, value);
> +		return;
> +	}
> +
> +	/*
> +	 * Now check that the host value matches what we expect for fields
> +	 * that can be read back (these that we can't we assume that are correct)
> +	 */
> +
> +	if (get_host_value(vmcs_field, &actual_value))
> +		actual_value = value;
> +
> +	report(actual_value == value,

Rather than clobber actual_value, incorporate the get() in the report, e.g.

	report(get_host_value(vmcs_field, &actual_value) || actual_value == value

> +	       "%s: HOST value is set to test value 0x%lx directly",
> +	       field_name, value);

Print the actual value as well, otherwise debugging is painful (well, more painful).

> +}
> +
> +static void test_host_value_via_guest(const char *field_name, u64 vmcs_field, u64 value)

It's not via "guest", it's via the HOST_xxx fields in the VMCS.  test_host_value_vmcs()?

> +{
> +	u64 actual_value;
> +
> +	/* Set host state field in the vmcs and do the VM entry
> +	 * Success of VM entry already shows that L0 accepted the value
> +	 */
> +	vmcs_write(vmcs_field, TEST_VALUE2);

This should be value, not TEST_VALUE2.  Ditto below.  The whole @value idea is
rather pointless though.  There's one caller, and it passes one value.  The only
requirement is that the "direct" vs. "vmcs" settings use different values, e.g.
to avoid false passes.  To handle that, just use more descriptive names for the
#defines.

> +	enter_guest();
> +	skip_exit_vmcall();
> +
> +	/*
> +	 * Now check that the host value matches what we expect for fields
> +	 * that can be read back (these that we can't we assume that are correct)
> +	 */
> +
> +	if (get_host_value(vmcs_field, &actual_value))
> +		actual_value = value;
> +
> +	/* Check that now the msr value is the same as the field value */
> +	report(actual_value == TEST_VALUE2,
> +	       "%s: HOST value is set to test value 0x%lx via VMLAUNCH/VMRESUME",
> +	       field_name, value);
> +}

