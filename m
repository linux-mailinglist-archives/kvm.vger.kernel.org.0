Return-Path: <kvm+bounces-24379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E619C954756
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 13:01:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66FF0B238BB
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF861990BD;
	Fri, 16 Aug 2024 10:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qm/z6DrQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A87419D094
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 10:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723805963; cv=none; b=K/PuXTUsK4KkDKdZ/5TnrTkilr/Cg6kJmWGeYcsmXw94qekjDxUwpKl2UNY08iuN+QeGZH9EOxMxA87UJOsDZe5GIJIhEZcXAbSNiDamfKlcVRW6ug7QTxibXznw8HYfGi/KLqlZxh72dhKXtslkydVHjXKpkg9pCCsuklCOnnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723805963; c=relaxed/simple;
	bh=bgb9/+EMLOD9zk157Ud3ZWk1P0CjUIpEtGJbIsPK2q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hFKhX8cdmqzuJkmN/YFTHDI7AcznT1gH+/x/KU1RMOjnZa5WOPtOWgyWTgg/AVOt6zBq+fL6v60LgLX+rg1mYJ2Bq0GTrPhDMBRam3TOfsNPOW0BYSOK1NXQKODLm0m8bFrD0uP2DaduDJnElugoeMCxZM9XTcO1ptwyprGerZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qm/z6DrQ; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52f01993090so2368571e87.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 03:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723805960; x=1724410760; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hU/uVaWgfZQJOk/mUvG+iaJnTI1WKVHF9Mzt6iOFQ24=;
        b=qm/z6DrQj9JsDewmVCXcMgfvCuxuAF+cBayPh4glAShB4327wzeK7Z7J9PA29iCidP
         PhbzpjENToCtpQvSVCdc3zZ+5gyP3tZCwhVQ8mnHHuDqWlxFgcyqzGvjoBWckzQ8ZHCv
         1gPAFOQtDffhYlugE0nnglLax09Fc7t3fSxw4u3XIYi0ahB/PjA4+DS6EZteoI0ZxIDi
         GNBo0F5hwi/mPcx5RixAV6VT/FxqFZmYFOMZgPWKM0xvlHO3+wzQbrzVdSPLLn7+R+nv
         K1xYE+ZsbsPyVrW7HeYQiE5xQMRO1dZlOWgu8dpVlDndfqID5Q3JEgAP+ka5c1V3dQEW
         bh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723805960; x=1724410760;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hU/uVaWgfZQJOk/mUvG+iaJnTI1WKVHF9Mzt6iOFQ24=;
        b=TyzpwRprgLqsHgd5T+PANXTSL/Pa8VU7v18OUrmieuQvahN/dL3k7KsQE4ssV5maCX
         uUZT5fH1cvvpUlhJdKNNigMPI8jhtJZskmpmRD8+Eq5kmKY51ryM++IMg9+rj155Dzgv
         VlyLSclQCa5oZKphPbte1JcuopLTqNQOJ0Hl6Va/9kGSm+qGqOOr/TA/bUUzw+ZOzukN
         tIIWgyaB0DJB2sfzRIvCZeeca62U0gdcUMm4IdegJWvWidBqyEC5wzTuyZ8W1X0sDMJm
         KAkFuBajXR1l6b139o82p+Zbs4rXp4m1x3jnriVtnuPVVoxAysuSddRMLDc9ssDBVpFH
         dtOg==
X-Forwarded-Encrypted: i=1; AJvYcCU+N5Uz8gA+lN2oMgcVvmhPWhHDw//+p/nZ5dwT47TtTatHmydcZYrLNLHgN4jhDjtKmEMYVkEBbhC9xfkwkvkoqFeN
X-Gm-Message-State: AOJu0YzVRjH1mPwD6JZAvKk2ySGR/FlAaMFwn24zDI+c8KcvJrz+Q8ZD
	cBRKOHCuhnwJGfqOChdOZH/Z6qtgk5BMsXMhghPQbxU0Yqa8faFNcX+xVVjhCo0=
X-Google-Smtp-Source: AGHT+IEOS3kFHiJPiY8IzuR/J2sByj96dr+W2TC3I0FEUQoT3zZgEqy/VPQW52LwCFIROr24jqAVhA==
X-Received: by 2002:a05:6512:3087:b0:52e:a7a6:ed7f with SMTP id 2adb3069b0e04-5331c6f0099mr1216029e87.60.1723805959938;
        Fri, 16 Aug 2024 03:59:19 -0700 (PDT)
Received: from [192.168.220.175] (143.red-88-28-5.dynamicip.rima-tde.net. [88.28.5.143])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429d780ec58sm71958615e9.0.2024.08.16.03.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 03:59:19 -0700 (PDT)
Message-ID: <54bb02a6-1b12-460a-97f6-3f478ef766c6@linaro.org>
Date: Fri, 16 Aug 2024 12:59:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] target/i386: fix build warning (gcc-12
 -fsanitize=thread)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>, David Hildenbrand <david@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-s390x@nongnu.org,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
 <20240814224132.897098-3-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240814224132.897098-3-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/8/24 00:41, Pierrick Bouvier wrote:
> Found on debian stable.
> 
> ../target/i386/kvm/kvm.c: In function ‘kvm_handle_rdmsr’:
> ../target/i386/kvm/kvm.c:5345:1: error: control reaches end of non-void function [-Werror=return-type]
>   5345 | }
>        | ^
> ../target/i386/kvm/kvm.c: In function ‘kvm_handle_wrmsr’:
> ../target/i386/kvm/kvm.c:5364:1: error: control reaches end of non-void function [-Werror=return-type]
>   5364 | }
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/i386/kvm/kvm.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

But what about the other cases?

$ git grep 'assert(false)'
block/qcow2.c:5302:        assert(false);
hw/hyperv/hyperv_testdev.c:91:    assert(false);
hw/hyperv/hyperv_testdev.c:190:    assert(false);
hw/hyperv/hyperv_testdev.c:240:    assert(false);
hw/hyperv/vmbus.c:1877:    assert(false);
hw/hyperv/vmbus.c:1892:    assert(false);
hw/hyperv/vmbus.c:1934:    assert(false);
hw/hyperv/vmbus.c:1949:    assert(false);
hw/hyperv/vmbus.c:1999:    assert(false);
hw/hyperv/vmbus.c:2023:    assert(false);
hw/net/e1000e_core.c:564:        assert(false);
hw/net/igb_core.c:400:        assert(false);
hw/net/net_rx_pkt.c:378:        assert(false);
hw/nvme/ctrl.c:1819:        assert(false);
hw/nvme/ctrl.c:1873:        assert(false);
hw/nvme/ctrl.c:4657:        assert(false);
hw/nvme/ctrl.c:7208:        assert(false);
hw/pci/pci-stub.c:49:    g_assert(false);
hw/pci/pci-stub.c:55:    g_assert(false);
hw/ppc/spapr_events.c:648:        g_assert(false);
include/hw/s390x/cpu-topology.h:60:    assert(false);
include/qemu/osdep.h:240: * assert(false) as unused.  We rely on this 
within the code base to delete
migration/dirtyrate.c:231:        assert(false); /* unreachable */
target/i386/kvm/kvm.c:5773:    assert(false);
target/i386/kvm/kvm.c:5792:    assert(false);


