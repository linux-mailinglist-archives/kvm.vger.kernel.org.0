Return-Path: <kvm+bounces-45216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85A67AA72D6
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30A531B640E4
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5203325485F;
	Fri,  2 May 2025 13:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rzFEKhZh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD157171A1
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 13:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191189; cv=none; b=NK0Kxki0KGiPtC7tAH63c6xRq2td1K8EFLycBFJZERdqogntNYgE9Tcki3eu+Dk+vneWIPFClRp8rfwHuK2FzpDIluRvRNrfNwOKzg/d4O+7MBqDbeje6IjUraJ2a8V4d0KBfNeSd/UVHl4Ut9fLxQs+/jhPj2RVIx/KO2GduzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191189; c=relaxed/simple;
	bh=hUDOGwUUr4LzZTAWlNMtzYLXNC7sn5YIqincEQJ/8cs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gwduAY0bgxjZ4I5imwddyeVH9beE5N62PELLBKxJ89PcikGd7VKs6iK11GXdoWfR9eZX5g5KLTJnKHNQg2Mk9eihatu1NK579lBT632nG+9FZNMj5DvMwVFXNjIPx9OCzzViyvjIQazcXfdCkkgxtr1eeYewvsCQ9Jq1L2OaqS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rzFEKhZh; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39c1ef4acf2so1459205f8f.0
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 06:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746191186; x=1746795986; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Ff86yxpyjCtbuw5ktn/4A+UjWLwafnYrh9q/h3mTCQ=;
        b=rzFEKhZh0rf0q9a67oaxIenHOA4I1eGsAW/3rOezfz3W8dc5NFVGxM/7P1gFy5780L
         E3RgawlhKqmjfqA2efBbBEpSaRQF9R6YHHym1vy/C3QYhUJjWMfYEkiUFDpmfowtvSZR
         SSw4jfhfek2qo3fdLQmxARm+GgC076LOvLwAcyZWJKc2BQ+KgOE7jEnfRCZd2N3dEXHG
         69n7U3Dkd8thO/i7C/TStatUktH/leyl8D+eXFXofw4JczBoDJjdMWNnFKpUbcHc6XF1
         +8XBOVXKvV6tvyceMT4qAr+SR3OG2J+vs0tkXMsOyv/dcGtwtxaYXQYzdcwyoprt3Mf/
         oS9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746191186; x=1746795986;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Ff86yxpyjCtbuw5ktn/4A+UjWLwafnYrh9q/h3mTCQ=;
        b=h5PllJoHS4Stk8GztIMxOq3J5KKHlSriD2ZiI9cJ+mntNnKfZvq2/EvKcRl6crOFyq
         Q1vsdjUkC3n/tkPU7k7uvko2MdoA7Kluhrlr9I3RBBUsZggYWiP4D4mkWmfJzYXjNs97
         nu0+YhxpRVFrzpowoacjnGb+Fc+5p4F6KVdW3b+BdQNAu6Soev8wyWSmOhqRADZswBax
         ggQPkvZHjmdVXyNLc+O/+s3VR0WIcigwGEIjxMr6UhUMv8PHQhfTmI+uRWSMAa40hfhT
         5NcfAIfvJo0sVs8XGU52SL3Ae7piuvJB00PmH2dcD1rEqfevQuUvOoepgfiWcxgsAJpr
         r4og==
X-Gm-Message-State: AOJu0Yy5KDFrNn6FhTsVZ7Lu/U0o1Rs83D+EUcnzwFHIl1rbl+SCZ8/6
	myvmrtj3IkyBltgpVp2jKFt1IkUUlOegQImDfe528jAxK/6buL/6dv+XuRU4yDdpsPAX+vOrwBi
	r
X-Gm-Gg: ASbGncu9PhOqzoMgmi0/kMCxVyKv/OA5vGoEZEtACQhTSXVJYJBNr19h9rod8YVGukw
	iBifWhpJUSA9OreYCfjsrWGFk4fYHQ5Q2UQlQaFxv2rBnQq9k2xcRuqON6PqHaD4HejR63ZmKPx
	k7u7L329DgitZSs048WXJdTr/kxx1ehgujIRlgYTEpEF48LQwaXfM10n+pSMq391XFqICxwiEmV
	yzE/h064oSnur8rWTP+dOhRWnp1909PLm5aVZHdJSzcRiH/yA4JZzyzFblvGXTjGybRBpkYa9KZ
	qKShAtDE2cWqguQ+AclzYnrra1pNjkfEaS4k3K4UlFfQdg==
X-Google-Smtp-Source: AGHT+IE9Bzp007HRKZCbQAzjlJu3D8mWw6dSJ597fP1DhRpLSLEkgjfG7ipWJqSApZNRWbHlsqZymw==
X-Received: by 2002:a05:6000:2485:b0:3a0:8a42:e9dc with SMTP id ffacd0b85a97d-3a099addad3mr2248434f8f.26.1746191185898;
        Fri, 02 May 2025 06:06:25 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a099ae0b9fsm2089299f8f.4.2025.05.02.06.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 06:06:25 -0700 (PDT)
Date: Fri, 2 May 2025 16:06:21 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc: kvm@vger.kernel.org
Subject: [bug report] nVMX: Test Host Segment Registers and Descriptor Tables
 on vmentry of nested guests
Message-ID: <aBTDTdGrZbWDW-Ui@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Krish Sadhukhan,

Commit 95d6d2c32288 ("nVMX: Test Host Segment Registers and
Descriptor Tables on vmentry of nested guests") from Jun 28, 2019
(linux-next), leads to the following Smatch static checker warning:

	x86/vmx_tests.c:7583 test_vmcs_field()
	warn: maybe use && instead of &

x86/vmx_tests.c
    7561 static void test_vmcs_field(u64 field, const char *field_name, u32 bit_start,
    7562                             u32 bit_end, u64 val, bool valid_val, u32 error)
    7563 {
    7564         u64 field_saved = vmcs_read(field);
    7565         u32 i;
    7566         u64 tmp;
    7567         u32 bit_on;
    7568         u64 mask = ~0ull;
    7569 
    7570         mask = (mask >> bit_end) << bit_end;
    7571         mask = mask | ((1 << bit_start) - 1);
    7572         tmp = (field_saved & mask) | (val << bit_start);
    7573 
    7574         vmcs_write(field, tmp);
    7575         report_prefix_pushf("%s %lx", field_name, tmp);
    7576         if (valid_val)
    7577                 test_vmx_vmlaunch(0);
    7578         else
    7579                 test_vmx_vmlaunch(error);
    7580         report_prefix_pop();
    7581 
    7582         for (i = bit_start; i <= bit_end; i = i + 2) {
--> 7583                 bit_on = ((1ull < i) & (val << bit_start)) ? 0 : 1;
                                         ^
This quite looks like it's supposed to be << instead of <.

    7584                 if (bit_on)
    7585                         tmp = field_saved | (1ull << i);
    7586                 else
    7587                         tmp = field_saved & ~(1ull << i);
    7588                 vmcs_write(field, tmp);
    7589                 report_prefix_pushf("%s %lx", field_name, tmp);
    7590                 if (valid_val)
    7591                         test_vmx_vmlaunch(error);
    7592                 else
    7593                         test_vmx_vmlaunch(0);
    7594                 report_prefix_pop();
    7595         }
    7596 
    7597         vmcs_write(field, field_saved);
    7598 }

regards,
dan carpenter

