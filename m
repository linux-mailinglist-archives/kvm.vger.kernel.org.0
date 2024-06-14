Return-Path: <kvm+bounces-19652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23380908254
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 05:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C130B2387A
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 03:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0F871836E1;
	Fri, 14 Jun 2024 03:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H4Yr4z1u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7516D157E7D
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 03:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718334606; cv=none; b=IH7mZe2YbD6AOllPQVlc3n2J6Nffoyd49jdildzwcLxvnapmyi1ueFyB5C9/ru8GqYLnb6Pw+hCIzHgCFTSpDNcz7akue/PB7rvn0Rl6+SFBm7LuWVWOncV/IzdWjlaF+50AqhrK+pOqiA6JJp0dQjWEw+GfBaJXMlsvtEXtlWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718334606; c=relaxed/simple;
	bh=LyBxCMircokcDHU4idnC4n56+LwmqWq8TJC6W85EVYQ=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=DhnSTdIACl6Xj/PxdM0vCiyMN9B1XF/Bkk/lm3PLgQqUxyG17wXcbOehguSD3f0oMDM1clOjbEYas5/+1xpC1g4R4hKb05797oDytBDK2QkV4GkexgncXYJY6V8BQ/Aa9j8wxUVCSJjnSdea/SxYu18L1nG0UrGRL32reon2nmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H4Yr4z1u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718334603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Yk6EyGnaPcearZ4LMXgS8jkfUau2xtx0QwaUz09Y2n0=;
	b=H4Yr4z1uWwLikz0Aef5xOewpoJ4PeuD2hXxjJCFQWB95LM1DFOJIT4ux2SWM4261QPwhRq
	hqJqrzgCt8gm7dBYIaKZC7ozlyGy+9FxCZLjJJqbZA+2LVjGKvBy+WzB3yVTP+C4xwQ8Xe
	eFkwiKxUkvqRku4Smb8juCO6eDzHNbc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-GOumfiA0MMq8ilxwnduHig-1; Thu, 13 Jun 2024 23:10:01 -0400
X-MC-Unique: GOumfiA0MMq8ilxwnduHig-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7954f774295so182082685a.2
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718334601; x=1718939401;
        h=content-transfer-encoding:mime-version:user-agent:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yk6EyGnaPcearZ4LMXgS8jkfUau2xtx0QwaUz09Y2n0=;
        b=XWraor1h1LAlWAnU6eFdF62VjG/W7+GoVeGUIkYNbOyoDhGUamEBBLiTyHKXjDKLPy
         Y7Vz3FuCY9V+4BQmaH8wKllhg6XRnm7nHuqK6eIwDAmJrLweVeomUZD/6CC+e8H9SOt9
         1ofw1NKpEL/mePttNEuwD8QvYNuaxcvJqc++owQzvdH2vBwrNcuKkJW2+vLhsfRUe+gi
         cWKSPMUSV5AYPQW6fITpj6U8lGHDxCc5rNOlFCOHgj2HiQ4x9Hp+wTm0au1sNPlOK0+r
         xmbcVB1Qm4sUa+2u8nas/HN8a03cXczW4ewrrv2vknpZzjdvoIEbn7r0QBskqlhSD1KN
         Tg5A==
X-Gm-Message-State: AOJu0YzQVtjLAUSSbvlrCpCJWTj9In7HKkOku+5Kr6/mrR8DTfBnxGkz
	L1eVym48gTFzrI9ZuUZOa/ZMp6HdhPj8nf6btYmkeBT0vNiSrgLtctwXsakzZWkl1MstVDG6bI1
	VEBH6O8DqKjC6V519qvM9iFdHTV8xFuWDT7RLM19nAVR5JjwMQLrTEMPfPA==
X-Received: by 2002:a05:620a:254e:b0:795:5ee3:f147 with SMTP id af79cd13be357-798d258e4b2mr125550085a.62.1718334600790;
        Thu, 13 Jun 2024 20:10:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAh0VXcQf97mzDE3WbTP4ZYZVftr8+A7hIvvdvQTh88gOy8dU6gaLfK5M4cx8mG0xttpEWBw==
X-Received: by 2002:a05:620a:254e:b0:795:5ee3:f147 with SMTP id af79cd13be357-798d258e4b2mr125549085a.62.1718334600450;
        Thu, 13 Jun 2024 20:10:00 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-798abe4f35dsm105669985a.122.2024.06.13.20.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 20:10:00 -0700 (PDT)
Message-ID: <f6bca5b0f9fc1584ef73d8ef71ac25e2c656b81e.camel@redhat.com>
Subject: kvm selftest 'msr' fails on some skylake cpus
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Date: Thu, 13 Jun 2024 23:09:59 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Hi!

This kvm unit test tests that all reserved bits of the MSR_IA32_FLUSH_CMD #GP, but apparently
on some systems this test fails.

For example I reproduced this on:

model name	: Intel(R) Xeon(R) CPU E3-1260L v5 @ 2.90GHz
stepping	: 3
microcode	: 0xf0


As I see in the 'vmx_vcpu_after_set_cpuid', we passthough this msr to the guest AS IS,
thus the unit test tests the microcode.

So I suspect that the test actually caught a harmless microcode bug.

What do you think we should do to workaround this? Maybe disable this check on
affected cpus or turn it into a warning because MSR_IA32_FLUSH_CMD reserved bits
test doesn't test KVM?

Best regards,
	Maxim Levitsky


