Return-Path: <kvm+bounces-59473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11436BB8265
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 22:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B91294C225C
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 20:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148F625785B;
	Fri,  3 Oct 2025 20:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WLYwy6Aa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37930253951
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 20:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759524891; cv=none; b=j6h5ndbfCkiuIgvg2jONGj9QW9DfkpHzcKp6IDvtRRuknPUWDUbHoqcwup9CFcxfHCmOY47FQShdC4zi2/HYThKZ3orpU1EjSqxY98pPBy+BJY6m6zd8UxMelUwOkLGhwqcj70hcH7V8xsrapa0eQyHFcTjwBA1hSR9xEtCtxzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759524891; c=relaxed/simple;
	bh=2oQTIzpDvpDKeSyu0rBqYOcftLmozL7ynYQaXbg5yfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tH68cjI6c28LetmScT+qTBARq7X0SAOC3tntp0pQTW+hZxI/hgxPtCTSI+GZ2HGCzVP/d1YB++BipBlY9Qjt/92k1JJv5aRvE1fG5zQ9Zuj8KuEJbE2YPTR3Q/2SwoNRoi0DtbQXLn45Hw2Z53zR25dmhRvd2XEn0nP0+NxA9Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WLYwy6Aa; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ee1381b835so2315635f8f.1
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 13:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759524887; x=1760129687; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B3ldZEG5ScHR939V5D30GdFiXHB1AdjnHpqkcb2Cno8=;
        b=WLYwy6AaXSoMYEh8CLdqAggQiVuFKt5i/Lf7981IYFsgC9rBeEUKIInmTLxv/4qlQ1
         8mUsKfIodDyNWj9ejJoUHixJAFsoWvMnJIoCvvtfKB5rNfkfN3ARGCakLeXPlLFtHVrU
         GRRh7xaPZHv5f+NxkyJQsNdhYv5IKLXAq7749s/WQPpijq/TI6BGNgpA0HdhAAvCC7/F
         ou7Uh+aM4fWm3ZSEsL80UQhANvTRHxIXjKfjJVdkmJVnDNYu6uAgaRCSLrVrFtGyJT5q
         poZgtSU+5FqcjiHU+vjxqrNzbdIzpg/suATtdyV0YTj3SGezDp5ovdu+aBpvTNUG4VDT
         tmgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759524887; x=1760129687;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B3ldZEG5ScHR939V5D30GdFiXHB1AdjnHpqkcb2Cno8=;
        b=XnMdp82/afxS1RHEkJLHjUgPr7a6vef3ch+4OQOzT5mY96d/hc/SsbAxtUAT9TV1y2
         zZhpycutADSGX/Rqdi1JVdLh902WfQX2E15ut/iYnMzLiCvy3gMzn7hSNNeFEb4srhrP
         rcddGdjQSe6lQqxfqp8hhEV09LWX2dUxfwrc7iRmc5h587xBmFq9r3gDCxaPTiM8T8La
         JdEjzHbRY2oXsjRZdgL2F22TzzUWpe8TNvfIWndOFwjNcSRwzceCBmoGMqjxioYuuDSI
         vrgLbvGTTOAfjEzst3Fa5r8WTNNKFH4HkPzD/1TGh9b7JEBySuccACjwG76RFE7lrAAj
         suyw==
X-Forwarded-Encrypted: i=1; AJvYcCVmXttECKcawjvlNSRrzFaD6qj3o0JDn/jHI3DhBKyBqOBB1cbMfxRqDtshSVkLdFm3ma0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk/RWKMYNkE1xZJWNEpz0vs5iUVzqyf3dNZbxMQ77Kq7QrLFvm
	5RlxGRCobXBfz7kaWl97VF73LrqKzHBQ6Ukt5eAEinq+p/qRQI0Q712HDHidyNmcpEw=
X-Gm-Gg: ASbGncswdONHM4SbcKWoOaYnNNGl8X0CDuEYAZXKhzVKOCQWVL8C5xw5T3X8B5fcXV/
	DNgb5AqCTAE/mov2IF7RvSvhsWMzFbRiOKu8BGmL6B+MODjfDUs0HC4lx8HgMoPYmNhf8ocRk1Q
	bu+hv0mAHgLE2xzWPxWWXSllP+8fNl8mRM4d1PACdxEXhmZFpJ8790LBN+2iyR4wes6SiYdzQOW
	y3mAvfRUkSq8NUObg3nXhRLH3CUfwbdk5Ocg7hyVE7HQJJvLYyc7yhSA2kPk7/hoSPZlsSAUKUb
	oVox2jvHSoAV0EbVzk6BmOOdrkRF2dn5WQlp9nhUtqbuSV7iIjb1X32PlgeIAtK/phNn6ApmaJ5
	D2AE1KR3EqbY6XvW9I+utZrrIBG9DJMlupkXU1UHcO3Pm1hxoKIOCLCUwNLuWB8RBzUT2WbdUKC
	guRAxAI3qEE2BcTc2CMa1KpuvzFQah
X-Google-Smtp-Source: AGHT+IF+YPiwwY9HDDgxpirJo38iH44mnenhG9cCLyC/enTPjWl/okcrtohvYzGU+mmB/W8I/zANPw==
X-Received: by 2002:a5d:64e7:0:b0:3eb:c276:a347 with SMTP id ffacd0b85a97d-42566dff020mr2934384f8f.0.1759524887386;
        Fri, 03 Oct 2025 13:54:47 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a0204fsm146130205e9.14.2025.10.03.13.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 13:54:46 -0700 (PDT)
Message-ID: <bacd25d5-fef8-46ca-9f8a-8edcd48e85d2@linaro.org>
Date: Fri, 3 Oct 2025 22:54:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/18] system/physmem: Extract API out of
 'system/ram_addr.h' header
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Jagannathan Raman <jag.raman@oracle.com>, qemu-ppc@nongnu.org,
 Ilya Leoshkevich <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Jason Herne <jjherne@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Fabiano Rosas <farosas@suse.de>,
 Eric Farman <farman@linux.ibm.com>, qemu-arm@nongnu.org,
 qemu-s390x@nongnu.org, David Hildenbrand <david@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>
References: <20251001175448.18933-1-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251001175448.18933-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/10/25 19:54, Philippe Mathieu-Daudé wrote:

> Philippe Mathieu-Daudé (18):
>    system/ram_addr: Remove unnecessary 'exec/cpu-common.h' header
>    accel/kvm: Include missing 'exec/target_page.h' header
>    hw/s390x/s390-stattrib: Include missing 'exec/target_page.h' header
>    hw/vfio/listener: Include missing 'exec/target_page.h' header
>    target/arm/tcg/mte: Include missing 'exec/target_page.h' header
>    hw: Remove unnecessary 'system/ram_addr.h' header
>    system/physmem: Un-inline cpu_physical_memory_get_dirty_flag()
>    system/physmem: Un-inline cpu_physical_memory_is_clean()
>    system/physmem: Un-inline cpu_physical_memory_range_includes_clean()
>    system/physmem: Un-inline cpu_physical_memory_set_dirty_flag()
>    system/physmem: Un-inline cpu_physical_memory_set_dirty_range()
>    system/physmem: Remove _WIN32 #ifdef'ry
>    system/physmem: Un-inline cpu_physical_memory_set_dirty_lebitmap()
>    system/physmem: Un-inline cpu_physical_memory_dirty_bits_cleared()
>    system/physmem: Reduce cpu_physical_memory_clear_dirty_range() scope
>    system/physmem: Reduce cpu_physical_memory_sync_dirty_bitmap() scope
>    system/physmem: Drop 'cpu_' prefix in Physical Memory API
>    system/physmem: Extract API out of 'system/ram_addr.h' header

Series queued, thanks.

