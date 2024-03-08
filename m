Return-Path: <kvm+bounces-11368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C91876253
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 11:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 305EB1C2149E
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 10:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC6D5577F;
	Fri,  8 Mar 2024 10:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OTU2Dv/v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813FB54FB0
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 10:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709894670; cv=none; b=nj1xSLEW+MCFwoIhViQvd0B2vsI49+cdPFFsqBhD4VsPMGpq30/QXLdYbLC1bLXETE223zZuJMvIcMenN/gD1nRGrtN5B2h6Q9NyPwVCjJqZlOd1TL6r3p3b+u5krPVDhx6FAwnR1gKhfHJzPDl77U7HRCV12A8tjUCesLAI0gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709894670; c=relaxed/simple;
	bh=2q+QCW5HvvcJeCeirvDXQ0Rp4AEuyCTVjiF1DkHGmL8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qFZPu1UvBf/qnRVcmwpYdNtAZDjmLAmBsh8wxrYAPz8Vusnidb40bcGFZqyNYKxtbmk6xqh0a0J3x77srb74BU2rbXDkDaAGKpXLLHU14E5fZgX3Q63YwBrB72mJl+ZVG5EdALuwqkhi2vopiDGV336etMbXJ/aSS6O4nKQXUMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OTU2Dv/v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709894667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2B8S6vEInG2XvsiNtvqjWYEzrG1YbZ9wSDWIeXEAcpY=;
	b=OTU2Dv/v0jyih0omd+N1RXn/yjZpnKvTOs/gmAH9ludT09ZOHJ7yuegpVgtp39dbRKsO9r
	hke9skOylMvU9Jv/sBBnY9BG1Z8ng+umfVuemjEroRaBlb+87+h4D5irwY/y/BeVJYZ2cZ
	2+y7LMUvzFwmlBVlU5JV33kPqe43wL0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-anqM6sozPuute9uyoYvocw-1; Fri, 08 Mar 2024 05:44:25 -0500
X-MC-Unique: anqM6sozPuute9uyoYvocw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33e79d3f462so98178f8f.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 02:44:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709894664; x=1710499464;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2B8S6vEInG2XvsiNtvqjWYEzrG1YbZ9wSDWIeXEAcpY=;
        b=mCzrliHTz/5xNf3RuOJy+t6LpJ2YLED7kX2EgoFdC0V6LxXn2bFxo9fN1F5ncLr0Ez
         hqVJTpWK+1rzLfc7p1Cru9PSJSaHQABHXAejOwDfFt+8wytnldQHMXGlHkn80Jn0tLQ4
         NyEcRCmmibKcxZQPyh28SqpeoBmenLCE9hpX1a935Jobh/g0AgxzDiLNV7E8lahXybi/
         hD1vbhY5pHNNI98TOYxXp0kDqO+wo6I6RBpTneqQ3if+syrsMRJ1jjHKFAW7V8fUGix1
         L80CQ+lClz1+ozC31aJGKju+o1PM4YoBoDKqhu4b0vQB9tiO5C/0pBIKwWJACchemNMl
         Maxg==
X-Forwarded-Encrypted: i=1; AJvYcCXu9VG4HNWjwHtE3ahvajYuselNkCydehfYf/njxWGAEFYB7zqkI9cro3SObC29uF5fH6q8fZJbYvj5f7WkmDNMAKvR
X-Gm-Message-State: AOJu0YxP6hmuE3I0b+yF9GrGRTjBdpTuZEsFf7mpSo/7SWcKgQJt96yk
	S6zVJQdvNE3aIjbvsDGeTeUmR5MEGidlnAedjFpbvb73qlODcmNRw/KUo05n4Y7v6JDgMYbUbBA
	JffPNX89nyMaTD8b1Q1xOKCExUIp3/kKws1Mmda6C0TTLjk/3toEaIpvlpA==
X-Received: by 2002:a5d:4587:0:b0:33e:7380:df37 with SMTP id p7-20020a5d4587000000b0033e7380df37mr1786332wrq.58.1709894664593;
        Fri, 08 Mar 2024 02:44:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFDoidnEFnBtmTI6W6Naq/q7YTfz7qnJ8M943W9JMuTziVDbw3Bo1T/K0PGBUVj6ZkPFZGPQw==
X-Received: by 2002:a5d:4587:0:b0:33e:7380:df37 with SMTP id p7-20020a5d4587000000b0033e7380df37mr1786317wrq.58.1709894664230;
        Fri, 08 Mar 2024 02:44:24 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id c14-20020a056000104e00b0033e72e104c5sm2324018wrx.34.2024.03.08.02.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 02:44:23 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Li RongQing <lirongqing@baidu.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] KVM: x86: Fix KVM_FEATURE_PV_UNHALT update logic
In-Reply-To: <170987090131.1157339.1162545682759176638.b4-ty@google.com>
References: <20240228101837.93642-1-vkuznets@redhat.com>
 <170987090131.1157339.1162545682759176638.b4-ty@google.com>
Date: Fri, 08 Mar 2024 11:44:22 +0100
Message-ID: <87plw5knp5.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Wed, 28 Feb 2024 11:18:34 +0100, Vitaly Kuznetsov wrote:
>> Guest hangs in specific configurations (KVM_X86_DISABLE_EXITS_HLT) are
>> reported and the issue was bisected to commit ee3a5f9e3d9b ("KVM: x86: Do
>> runtime CPUID update before updating vcpu->arch.cpuid_entries") which, of
>> course, carries "No functional change intended" blurb. Turns out, moving
>> __kvm_update_cpuid_runtime() earlier in kvm_set_cpuid() to tweak the
>> incoming CPUID data before checking it wasn't innocent as
>> KVM_FEATURE_PV_UNHALT reset logic relies on cached KVM CPUID base which
>> gets updated later.
>> 
>> [...]
>
> Applied to kvm-x86 hyperv.  I won't send a pull request for this until next week,
> but I do plan on landing it in 6.9.  Holler if the selftests tweaks look wrong
> (or you just don't like them).

Looks great, thanks :-)

I was also considering introducing 'vcpu_cpuid_has()' first but then I
succumbed to my laziness and decided to postpone it until we have a
*second* user in the tree).

-- 
Vitaly


