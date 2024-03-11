Return-Path: <kvm+bounces-11599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F13FB878B69
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 00:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9245E1F221FC
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 23:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF60758AB9;
	Mon, 11 Mar 2024 23:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FQE5yLaX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA8B4AECF
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 23:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710198789; cv=none; b=lQaaSK5jAIxi9XNmGrX2DqHrL22VogO7mw5+6JtV1anN8UG2VJhKuf3S7KkrZmqm0mK4LmTADCHGeYXcfiybNjupOpYPM5Y8/1XItehTY1LS3MchpzNvVi6DSqLIkzTkS3tujm06kjfBYHI5feR8JV30/mlcQF/l8M7YJBxp4eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710198789; c=relaxed/simple;
	bh=2CTVSxAsmWMuh8mYb07wWQWLHE/gE9x7gqWfnD5CSBc=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=BEnvls4DMgd7NWHtKVwE8hILXqoOwgmOWcLblMYLqa/4yT18BEXSp063sKioWSnwaUgmfJoB5KTOI/3PR28hL/Wtrgo9BKPFD8g1HxImyiZMxmGBx794/2kXR9bsGA1yGnbksTmbuKMFKBM1FGlUQPn3TjAG/LTNAJarnNwGe+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FQE5yLaX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710198786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Plxvgeg1D/7QhJBxDovMLG3RcVFqJi1aZNlgcAwVkss=;
	b=FQE5yLaXp2Hnrqh2aM+3gKKSZvvRMj3DBdojpETSdyCdL0n4ldQP02oFm7u9t+nu/bEkEb
	GBO5dY0NcurFjhrM7f5sp7a1ev6PFu5Er6Ka5XkxO8rTJqn9Nq4uYbYlh+beIo4X/Kt24P
	ltksMuyCQiHO+8Fwmt6LPutECi1cg1g=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-7R7pB_ptPmuHx5f1h21a6g-1; Mon, 11 Mar 2024 19:13:05 -0400
X-MC-Unique: 7R7pB_ptPmuHx5f1h21a6g-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-42f144e7c55so52637051cf.2
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 16:13:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710198784; x=1710803584;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Plxvgeg1D/7QhJBxDovMLG3RcVFqJi1aZNlgcAwVkss=;
        b=LquzCUjijS99uA6r4WSK7JSrurYKo2Ah/t/ntvc7aDQSNX54uv1HRJ2HYtDzI/fBPm
         3x0ylND3x/UNbXIB0RF/npRFFgY2SyZKdEvMlNa+97WHDjsLuBThTWx3/As9Mtfsn8BY
         GY5okxIQU6k6ALgm41//37n9hALdIOrCMYS+zudxGPf5u/hOEpbAcA7/OYWtZ6Me0kM6
         k1NHL9/cWGUwe2w/w25k21jxT03JGvIvnkRlep93PsqHPbunjCHLcMQRaQQg2KTeM7+i
         IvEhu7zl+WZBHmnChWzp/IadtEhE0T83Cu9lNqXEhzvDAJASg+e2wvuJ7t/TasemyoS/
         Vi6A==
X-Gm-Message-State: AOJu0Ywy8gnnP6wpjgadctksoi9/vAqqpJi9RfVoO9Cwj0ND1151laVF
	ubO8dXvsizQ0/uogejD8B9QhyKJRUVmJgUpUbtoPwOLJ8vd4GI4d/FBzlrAq1zMBrq/gFL5YEwZ
	RwGq9/hV4soK6xnG1QuWKD26ZClI3MfK49+T6Jn9EfCrylFeC0zwfJo/Tyaf7kwe044eDcY2VCO
	/CtwPfiw6LdSwZidUnbhpYZjkFi+++qJFxxQ==
X-Received: by 2002:a05:622a:103:b0:42e:7eac:a4b0 with SMTP id u3-20020a05622a010300b0042e7eaca4b0mr275659qtw.17.1710198784081;
        Mon, 11 Mar 2024 16:13:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlcJehw+ytj164rcCcOwwW6nMScf+lCgvlsRlul5LuFf/LxT5MuN4DWat/jBKA23GW4IiIvw==
X-Received: by 2002:a05:622a:103:b0:42e:7eac:a4b0 with SMTP id u3-20020a05622a010300b0042e7eaca4b0mr275645qtw.17.1710198783771;
        Mon, 11 Mar 2024 16:13:03 -0700 (PDT)
Received: from [192.168.8.125] (cpef85e42f68882-cmf85e42f68880.cpe.net.cable.rogers.com. [173.34.154.202])
        by smtp.gmail.com with ESMTPSA id x9-20020ac84d49000000b0042f55d894f2sm155957qtv.69.2024.03.11.16.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 16:13:03 -0700 (PDT)
Message-ID: <f39788063fc3e63edb8ba0490ff17ed8cb6598da.camel@redhat.com>
Subject: kernel selftest max_guest_memory_test fails when using more that
 256 vCPUs
From: mlevitsk@redhat.com
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Date: Mon, 11 Mar 2024 19:13:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,

Recently I debugged a failure of this selftest and this is what is happenin=
g:

For each vCPU this test runs the guest till it does the ucall, then it rese=
ts
all the vCPU registers to their initial values (including RIP) and runs the=
 guest again.
I don't know if this is needed.

What happens however is that ucall code allocates the ucall struct prior to=
 calling the host,
and then expects the host to resume the guest, at which point the guest fre=
es the struct.

However since the host manually resets the guest registers, the code that f=
rees the ucall struct
is never reached and thus the ucall struct is leaked.

Currently ucall code has a pool of KVM_MAX_VCPUS (512) objects, thus if the=
 test is run with more
than 256 vCPUs, the pool is exhausted and the test fails.

So either we need to:
  - add a way to manually free the ucall struct for such tests from the hos=
t side.
  - remove the manual reset of the vCPUs register state from this test and =
instead put the guest code
    in while(1) {} loop.

  - refactor the ucall code to not rely on a fixed pool of structs, making =
it possible to tolerate
    small memory leaks like that (I don't like this to be honest).


What do you suggest to do? (I will send a patch after I hear your opinion).

Best regards,
	Maxim Levitsky



