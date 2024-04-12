Return-Path: <kvm+bounces-14385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2D158A25C6
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 07:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CC68B245E1
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 05:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0CAC1BC4C;
	Fri, 12 Apr 2024 05:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Eq9dsrct"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B53C1B96E
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 05:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712900100; cv=none; b=ubhh98AFGAIku3mP2UZcJUhhBFdLawVMIMMJBh6apQecpdCLE19r3Vkwq4ytWiT3VmGTYkHwrmtvTsKd/VK8gxp5+oDvc59UNbIUAdkO39xnShs0A9HQdQ4jKDzNFnJMQQpZl//TZwCNeSOqqOHEfTZuGc/HWOi1NXtgY29gfNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712900100; c=relaxed/simple;
	bh=mekwCTMyUIHf0Fvc6QFOxa55PFHUFQeuRMLlo60az0o=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=EEUCyrtAB5JxLRZw8xlstX0auLXNLKgAdwzltvt1Z1NaZ9/WFbB7GB9uP5N/mYCQ6GpQlgi2RQca8numkXms8nt3To6Eo4Vo+6ovSqcSB8+0IBf+8t+5Cx4ZwcYQguXIX1yWDchoH2+YhN/7OGdnjKHp/TvettoydSaWH2kAf1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Eq9dsrct; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc746178515so965842276.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 22:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712900099; x=1713504899; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=40CL73wib6boENITVkOBpqP4qrDROFAeF098K7rCEZo=;
        b=Eq9dsrctp+oeiCMUetYY+mx5187uUTmAAILjPVRkuM/efzVXCL+moLjt3HW46gaFJF
         mIt1K4bqnJPZhfCkbxP3YGzx7H1oDfr24z4inSkNYaHBlT7OVEHLv6KSuC1iG1EP5SE9
         b5ugjNlYD/Bl/gK9y1OUKfxr2rdXutn23ND5+yJbT5D8O1VlhzU2moboODm70h0NZKvi
         tAJvW+8Gc1saTFTD5qk2xFjCdsQQOkndgHKfMllBOjsfK8DYWOa8fSXpuHNLC1Rmitiy
         tF1Hfk3aMKdL2dYncCWa2wItjV4ueOypd5+kyXR0xi5ESg0Jdw04f2QST0Lm1iOQEhSc
         2kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712900099; x=1713504899;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=40CL73wib6boENITVkOBpqP4qrDROFAeF098K7rCEZo=;
        b=kSpbXdd/Qn/PgxGyk68F5tmEHexHFiCUFxIZOBGOqdRbfV9GKF1qoUDq167w7uwLXD
         MqP09wAtYi1wWpV6kRpSwHvispmlYuk5U+O5nBAugj3G4C/5X2g3Ar63d6p49GtUXgFm
         gXHRm3OfXSY4RkD8cbl6KDX7L4uY67bj14us5qWisuTuGr6KBt+FsYD6MOaYU2doinoY
         F6Xgm6sHdXifJ1cPPVF5ZmPMdwjTNrSy2LMxbnI0fWr5l1TRgxkrrZaRcOBBX80Btb1K
         Ybse8/Tp6R9hNhfGRSs7OsFGgTwp3axLD2l4mQGzIyES7i1urIPduwe1MWXsO5L54OOl
         cTNA==
X-Forwarded-Encrypted: i=1; AJvYcCVHv2fGXn/mQxRF1Kz9IUs4hGbE1bBCHDuF3S8XYpj0DsTtoXfUAyAy6SX6YMIoiWk/3t5mOf+EVm0+hH4tve1hAJaS
X-Gm-Message-State: AOJu0YwMeQOV9E/cYRP7gpE7qLNCBkdWOC5S5/Y7RwyvHpviAOFqU8L2
	2gecQxXRZ9QMRCnD47U9LNaP+abYz5mBmK9QYj3jFBR/ZaWFig3+bIWdjXtL0DoKiT9VwvMNVZc
	sfUELjtU8czdn7H/ZfW3JhA==
X-Google-Smtp-Source: AGHT+IHBQ7oYt8rwDGfoTH5mMc+eE3PwbtEkoZpDVDKUDzWTMm/e3olIUnsS49ugB3YTyrfsMlcwC9w28DOEHyF/JA==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:1002:b0:dc6:e5d3:5f03 with
 SMTP id w2-20020a056902100200b00dc6e5d35f03mr510040ybt.4.1712900098616; Thu,
 11 Apr 2024 22:34:58 -0700 (PDT)
Date: Fri, 12 Apr 2024 05:34:54 +0000
In-Reply-To: <3d69b44a-8542-4a11-b233-16487e980d54@intel.com> (dongsheng.x.zhang@intel.com)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzttk7jg8x.fsf@ctop-sg.c.googlers.com>
Subject: Re: [RFC PATCH v5 05/29] KVM: selftests: Add helper functions to
 create TDX VMs
From: Ackerley Tng <ackerleytng@google.com>
To: dongsheng.x.zhang@intel.com
Cc: sagis@google.com, linux-kselftest@vger.kernel.org, afranji@google.com, 
	erdemaktas@google.com, isaku.yamahata@intel.com, seanjc@google.com, 
	pbonzini@redhat.com, shuah@kernel.org, pgonda@google.com, haibo1.xu@intel.com, 
	chao.p.peng@linux.intel.com, vannapurve@google.com, runanwang@google.com, 
	vipinsh@google.com, jmattson@google.com, dmatlack@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"


Thank you for your other comments!

>> <snip>

>> +static void load_td_per_vcpu_parameters(struct td_boot_parameters *params,
>> +					struct kvm_sregs *sregs,
>> +					struct kvm_vcpu *vcpu,
>> +					void *guest_code)
>> +{
>> +	/* Store vcpu_index to match what the TDX module would store internally */
>> +	static uint32_t vcpu_index;
>> +
>> +	struct td_per_vcpu_parameters *vcpu_params = &params->per_vcpu[vcpu_index];
>
> I think we can use vcpu->id in place of vcpu_index in this function, thus removing vcpu_index
>

td_per_vcpu_parameters is used in the selftest setup code (see
tools/testing/selftests/kvm/lib/x86_64/tdx/td_boot.S), (read via ESI) to
access the set of parameters belonging to the vcpu running the selftest
code, based on vcpu_index.

ESI is used because according to the TDX base spec, RSI contains the
vcpu index, which starts "from 0 and allocated sequentially on each
successful TDH.VP.INIT".

Hence, vcpu_index is set up to be static and is incremented once every
time load_td_per_vcpu_parameters() is called, which is once every time
td_vcpu_add() is called, which is aligned with the TDX base spec.

vcpu->id can be specified by the user when vm_vcpu_add() is called, but
that may not be the same as vcpu_index.

>> +
>> +	TEST_ASSERT(vcpu->initial_stack_addr != 0,
>> +		"initial stack address should not be 0");
>> +	TEST_ASSERT(vcpu->initial_stack_addr <= 0xffffffff,
>> +		"initial stack address must fit in 32 bits");
>> +	TEST_ASSERT((uint64_t)guest_code <= 0xffffffff,
>> +		"guest_code must fit in 32 bits");
>> +	TEST_ASSERT(sregs->cs.selector != 0, "cs.selector should not be 0");
>> +
>> +	vcpu_params->esp_gva = (uint32_t)(uint64_t)vcpu->initial_stack_addr;
>> +	vcpu_params->ljmp_target.eip_gva = (uint32_t)(uint64_t)guest_code;
>> +	vcpu_params->ljmp_target.code64_sel = sregs->cs.selector;
>> +
>> +	vcpu_index++;
>> +}

>> <snip>

