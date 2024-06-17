Return-Path: <kvm+bounces-19809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A858F90B919
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 20:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF71B1C24134
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 18:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462B21991DD;
	Mon, 17 Jun 2024 18:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B2k/maH8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2541E198E93
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 18:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718647564; cv=none; b=Fzeo19ns13pWk31jPctRQa42/Nb8CcxdCFmFuUhmrtuSnrpmn/wmx6W/lc8uil3tqoy6KFcz3D0m5ClioUapgQNaibgRVDEdsTwcScIpD2buoFDdnAXsMYPPhtaZj5ZB352vl30Dq3AfnQ7z57jxfREZYblP679AXejOmyAives=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718647564; c=relaxed/simple;
	bh=GCsyCEAtq0S2fXfpjSwEoTgdaY4LC17GLpWBlZu9t7s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hgv8YA7ebqKQV8t7g0TLx0+mfvdVUE5eNxau03/3Sy6VW89kUoW806cORBWEYmhjatW+w+WUNER0xQha0I9HtSVM34M2gBce8W8dXnyyKwXEvMnCw0lrtVStpmMbHzlRNPbQ9kqPlnCtEYwu32wCz4IWLl7+meLUOv71elhv5RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B2k/maH8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718647562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=07aY0cV81G77WiSVPnvvS2t0ODcF10OXzIJ4/BbUQ6Y=;
	b=B2k/maH8Yww1d3PFEi6CryaVGnttJTHFzxmAKwJnFFwUrN3Y/kHwhOmtnI8GNOJr7c2WPX
	6Ubhu/Jpv6L9IbUCP02A8AjDRDLY/43UsvLZwX6P28ff34dnWj4Q3fl1mbUhl5UcpV9mzy
	qjRiBDRTJ/qsDs+c5xmfQuZodxfcN7Y=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-IDZkqG1FPw6lII8FOLUYUw-1; Mon, 17 Jun 2024 14:05:58 -0400
X-MC-Unique: IDZkqG1FPw6lII8FOLUYUw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-797f76a5479so684027385a.2
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 11:05:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718647558; x=1719252358;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=07aY0cV81G77WiSVPnvvS2t0ODcF10OXzIJ4/BbUQ6Y=;
        b=HYfEHNZ9P1taAzsMcluyy98VCfp/wi9WzPelLzxxP9KGaxHQG/FkROcL3zcrsGwQJZ
         wiJPbhZ5gQ9Pd9DvWvpQ9flgXDXfkle2bato1g4kAbXioOlMMlkaCPYqDXoJH5gXG04/
         +EHCOG/DRXqzw3pdQLiK0+IIHUt4c750t0BXrhlLiL60g4viVEFbhz5zX4T+FS9hYkPA
         VbwVLuAyByK/GoEzM4XbAVS6erRYL0JeYaqm0HTOBa2lXsU+Mf+QhA9rNDMf4TWldEpt
         gOUwVjcHhNU8kxbbH8ZqEp2fcGkmE7A85/8oGngALVRYY7W77lhObIT/J985daGgq/7Y
         lLYA==
X-Gm-Message-State: AOJu0YzZk9uP3DhZLJow3YiPY7xQe1qyicMDXX/NwURBr8LNELIyWkr2
	ZkMsuEzRYVqaXbD+enrzFNNPy2VpiNJyPDU6jgmi4kxFAfzij26ldXINSkdaO4KTT9uCNo3I6Yc
	kqEVqnm9eNMfhX+KyoXP+XDB1056ilNMBZTQhWvbxD/0iuWxHgAyTtgswTg==
X-Received: by 2002:a05:620a:4405:b0:798:d3fb:bdb7 with SMTP id af79cd13be357-798d3fbbe16mr1277348985a.46.1718647558134;
        Mon, 17 Jun 2024 11:05:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqoYkX3rNR5sAJRrkU3tlJlCRglFbQ3UK1kW5A9491cm3iM4mU1Q3VM/zsvd8p0JHGlJornQ==
X-Received: by 2002:a05:620a:4405:b0:798:d3fb:bdb7 with SMTP id af79cd13be357-798d3fbbe16mr1277345185a.46.1718647557518;
        Mon, 17 Jun 2024 11:05:57 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-798ab6ad3a0sm447742985a.56.2024.06.17.11.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 11:05:57 -0700 (PDT)
Message-ID: <3a3e1514fb48b415b46045c76969cc211198b114.camel@redhat.com>
Subject: Re: kvm selftest 'msr' fails on some skylake cpus
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Date: Mon, 17 Jun 2024 14:05:56 -0400
In-Reply-To: <ZmxTFFt1FdkJb6wK@google.com>
References: <f6bca5b0f9fc1584ef73d8ef71ac25e2c656b81e.camel@redhat.com>
	 <ZmxTFFt1FdkJb6wK@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-06-14 at 07:26 -0700, Sean Christopherson wrote:
> On Thu, Jun 13, 2024, Maxim Levitsky wrote:
> > Hi!
> > 
> > This kvm unit test tests that all reserved bits of the MSR_IA32_FLUSH_CMD #GP, but apparently
> > on some systems this test fails.
> > 
> > For example I reproduced this on:
> > 
> > model name	: Intel(R) Xeon(R) CPU E3-1260L v5 @ 2.90GHz
> > stepping	: 3
> > microcode	: 0xf0
> > 
> > 
> > As I see in the 'vmx_vcpu_after_set_cpuid', we passthough this msr to the guest AS IS,
> > thus the unit test tests the microcode.
> > 
> > So I suspect that the test actually caught a harmless microcode bug.
> 
> Yeah, we encountered the same thing and came to the same conclusion.
> 
> > What do you think we should do to workaround this? Maybe disable this check on
> > affected cpus or turn it into a warning because MSR_IA32_FLUSH_CMD reserved bits
> > test doesn't test KVM?
> 
> Ya, Mingwei posted a patch[*] to force KVM to emulate the faulting accesses, which
> more or less does exactly that, but preserves a bit of KVM coverage.  I'll get a
> KUT pull request sent to Paolo today, I've got a sizeable number of changes ready.
> 
> [*] https://lore.kernel.org/all/20240417232906.3057638-3-mizhang@google.com
> 

This works for me.
Thanks,

Best regards,
	Maxim Levitsky


