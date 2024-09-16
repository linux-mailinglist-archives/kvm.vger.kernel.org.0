Return-Path: <kvm+bounces-27015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF9B097A780
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 20:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2CDF1C22666
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 18:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8380C15B97B;
	Mon, 16 Sep 2024 18:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WIp59orc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CD35337F
	for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 18:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726512906; cv=none; b=UkwoGBDgy99+KJiVy17Y5Sx5EOKoew1W6SHUSbbnAeISLwUG078L9ZZCRSR7ABiB6VhB9ntW+zG1o3ItdaCnXhsOSNuqP0vzl2k33gBFoH3hJN+pHW2XMmkU6PV0zV2oIi/qd8PKuwgSU+O1E/rNp+nUB4V1Wp/H+vZzVpo3xsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726512906; c=relaxed/simple;
	bh=Yzmnrq8M8rsSSfvUx5r3D5WPD6XM6bZJijJyFHqXuOE=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=nvRxCqzYcbuYv6dVLV8yeq1O96suPRGFYwS5uhhkF+IpY/k1bDqkd3XoIDm04kyLK4Pv2p8uyJ8SNvpRGYP6UVMTCM9NXEHpq7Q5UHRTI0F0A4twt0CeYU1YIb612BWcp8Icwg5Gan17jEUzxMUw9D4EX2eef7ZENZwCARVOTIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WIp59orc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726512903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2KKfzMhXsEKpItIAddj1d1dXMFqyODjm2oiNjjp6v9I=;
	b=WIp59orcriZXbZC6EM/CrumF5Lx7bopEtmBSc6ewA2em55zog8qrkz0q+9Tl0ZJ+Sh2a0M
	uaeojpM/D12saVrU/iUlqHj59DRShtZQIA5HXJCS0q0ZU7i7Jl80MpqAkhgz4nlInIsvio
	ypWedN6AkVMLqskNTqieR/u1eDISNPI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-KhIiysVJP8qEWxOnxONIeQ-1; Mon, 16 Sep 2024 14:55:02 -0400
X-MC-Unique: KhIiysVJP8qEWxOnxONIeQ-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-45849120283so63501241cf.2
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 11:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726512901; x=1727117701;
        h=content-transfer-encoding:mime-version:user-agent:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2KKfzMhXsEKpItIAddj1d1dXMFqyODjm2oiNjjp6v9I=;
        b=aFNMpr8YI23tL39vdXj0mUAR7Dp+akiZZ1J8/QlZc5GxDrcSFPopf8SmuXVa3+LlFW
         2jaQE3TNi7TPZI8VduhS++dfoJNTGgtB/Aem3Xst/JOejPxb8i0II20IyRhjRqJTVdjY
         eWA8JAQ69Q/wSzowuXm9YO/s/YOK7ipJN5ueayZH1m+IstpNvnhAQvejrZUM7/qYXAUg
         D7vNrbpcskB7gXicSYXEXn/BrfCaQcMNC77kcO9IncdR0skvK/IJ43OoHR6W2Xi4Z7yD
         iwqSpCAe/PZ4eZ6UMW5CP1r0bpefT3DRH//QknPCJXDNzpUGK9HRVO7sCZ/yNC2pLAEk
         dBww==
X-Forwarded-Encrypted: i=1; AJvYcCVorYpdKdfnqhCLA6HmVyqBAwTdaF8bdWgwFFGFiZxqdeGYAIm2g5kNK9+RvaxJXe2z4UM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaafKQmDrIvGO8grblsQ9+3MDnobggeNjnWvV939d8HRWB8N8Z
	9D9WmdoiGXQrtFp0GSWlN3CdR0+UENJeieGsQv+5AP0qWOJfv9ZX9jdmJ5Htlr07n/CcpbxpnX8
	1ob5/4dPX8EOfII4OA9kefznxrMQ6CcCM9but2f5skfnePywf3A==
X-Received: by 2002:a05:622a:1a9d:b0:458:4bf1:1f42 with SMTP id d75a77b69052e-4599d29ddcdmr217289681cf.45.1726512901371;
        Mon, 16 Sep 2024 11:55:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMezJIJg67zwskPLKJXaEJ3701UxX1gubyA5pdrrIU/GH9Mk1PMFfPU1Cq1RjJUZElTh9LDg==
X-Received: by 2002:a05:622a:1a9d:b0:458:4bf1:1f42 with SMTP id d75a77b69052e-4599d29ddcdmr217289431cf.45.1726512900936;
        Mon, 16 Sep 2024 11:55:00 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-459aaca55absm30301131cf.54.2024.09.16.11.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2024 11:54:59 -0700 (PDT)
Message-ID: <5ddfb6576d751aa948069edc905626ca27e175ae.camel@redhat.com>
Subject: Small question about reserved bits in
 MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sandipan Das <sandipan.das@amd.com>
Cc: linux-perf-users@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Date: Mon, 16 Sep 2024 14:54:58 -0400
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

We recently saw a failure in one of the aws VM instances that causes the following error during the guest boot:

 0.480051] unchecked MSR access error: WRMSR to 0xc0000302 (tried to write 0x040000000000001f) at rIP: 0xffffffff96c093e2 (amd_pmu_cpu_reset.constprop.0+0x42/0x80)


I investigated the issue and I see that the hypervisor does expose PerfmonV2, but not the LBRv2 support:

#  cpuid -1 -l 0x80000022 
CPU:
   Extended Performance Monitoring and Debugging (0x80000022):
      AMD performance monitoring V2         = true
      AMD LBR V2                            = false
      AMD LBR stack & PMC freezing          = false
      number of core perf ctrs              = 0x5 (5)
      number of LBR stack entries           = 0x0 (0)
      number of avail Northbridge perf ctrs = 0x0 (0)
      number of available UMC PMCs          = 0x0 (0)
      active UMCs bitmask                   = 0x0

I also verified that I can write 0x1f to 0xc0000302 but not 0x040000000000001f:

# wrmsr 0xc0000302 0x1f
# wrmsr 0xc0000302 0x040000000000001f
wrmsr: CPU 0 cannot set MSR 0xc0000302 to 0x040000000000001f
#

The AMD's APM is not clear on what should happen if unsupported bits are attempted to be cleared
using this MSR.

Also I noticed that amd_pmu_v2_handle_irq writes 0xffffffffffffffff to this msrs.
It has the following code:


	WARN_ON(status > 0);

	/* Clear overflow and freeze bits */
	amd_pmu_ack_global_status(~status);


This implies that it is OK to set all bits in this MSR.


Can you please take a look?


Thanks in advance,
   Best regards,
	Maxim Levitsky


