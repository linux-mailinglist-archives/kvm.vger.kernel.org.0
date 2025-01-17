Return-Path: <kvm+bounces-35726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E34A1497F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 07:08:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B04B6169E40
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 06:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5734F1F755E;
	Fri, 17 Jan 2025 06:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W+xVmqMR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C1F17555
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 06:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737094106; cv=none; b=tN5ngIggZdYrtmFDmUcy3+dUL6oMbm6mu27OhqJQXBGv3ESn1D5jIGL18F5+EM5+C7NdIx9mbDqrOae02kXPvtkau1qtUJTVhg5JxMpM/z+8n/BWxFXgnvqOHPcu1PEE1kTHMwvQ3YqjhlI1So0tSltM0C4/G2Qlui6t1fEAd30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737094106; c=relaxed/simple;
	bh=PNvRMbQPrrBLwGJDaselvxGTVeDkoQI0Q8dF5EGKg8g=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fF6xKhyepK2vZVAtNMWFcFI4O2dyTFfju1Ir5ZVImqzxXjI1aN0Uo4tCp5hsTRgXpaPf5EJOWvz/rdD0cgRyBSOBup/jxVhD22jmGWo01btSVhT0aU9bGH7VtjWOef1lHgH19cd+213Ihj+Wo/HHhzSJYARrjpFrZKtQjG23Wq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W+xVmqMR; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3863494591bso873674f8f.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 22:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737094102; x=1737698902; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QN4XC9J8hK3tzOAAeQL1MGpxGbLMHQa1ErXTDELLp/A=;
        b=W+xVmqMRwe0rynN/1vR4nLVjCCWKiLESxwBkJSEP2WPCVGBxhFdeLW6e3gAPTpnUi4
         eZRXafgEnLvJD+I0ey06blqoOow+krsP5EOEjIO6ct5okTNwgzRLhH7qbpQL+Z//YT1e
         P1dbhqcDsIy8E2OIByfeZnC3Rszuj0vXehmMViZ4OAen4gw2ussNJJquINgwifhZv8Tg
         5f4xZOkelkGTHpsQQTCVJ2Ia+ck4MlT8YworahZGq2c9uBXWQTnIksAdTfIT8NUqXcEg
         M+wZXH/JZJzpuTNQGlH0pR45PyghSmjJyrruL4RFps6e4vg5CM+fyoLxRraMB3Jc84a6
         5+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737094102; x=1737698902;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QN4XC9J8hK3tzOAAeQL1MGpxGbLMHQa1ErXTDELLp/A=;
        b=kNEzJNKfe3Etv0MucXLPcJVVoWzdj+ja2kzn013SMrHU4RQeRTvUd39VJ/hCHmY+Dn
         X3+ODsvxHafYGqg/nIaVrcwLiai5vy7n5/N0lQHIc2XblyN58sIGJdNW41dBCzoZPFzI
         Y/G6Vr7YGhr3Vklhr8TVtylNShEyUhK0fI/zwsAfKBXxEjSqtXBQNhzPRKh7CQQ84pUa
         xaix/26MB5PZLwCgWRgB4E6ovKcPYdGPcZgSQqisksATwr0vSG4HAQ3CYVN/9kZFsRJp
         UNb1GyHnln4CSS+IFwiSscpYOYl/vA3u6mCndmxlZ1832kzmRsGE0jllrUigReYDy6lV
         Tidw==
X-Gm-Message-State: AOJu0YwcPyckLPpupc16NCdn+v9xuzwQX/TwyFyk3jiodj0yaexIKWf2
	2TsJBfi4r9HYqwLUzq7aOyWCCY8mMge56Qycv9Z8jbJF6D3e6qtUOtznw48Rk3xSMahcbx3h4fD
	J
X-Gm-Gg: ASbGncveSM5YS6LuWK0UU3qfpNB7RMW6EtIoq5UNxz4FyFLgPijdMFo/KA1lNTXfYh1
	7odmjf0h8pYsXWzQacy5lN0kgtX5UU76fmpC0RIU/HpyJ2en/74W//QYnzM1GDSPyvc7CleHTxL
	535PP4OOJUqhNUUcnvkyOih8DEAE3wPTZ38YmbZ84w/6Sra6B6nWgx/7VNUUD5oNF9P7sk+jX6j
	rBd0uxiWnGIhDfZ/spOfjvuKdu1HrJ8uH+bAw3ri+xacGPsBa0WOevBLYydvQ==
X-Google-Smtp-Source: AGHT+IF7j2NJFyFXzInIblyLJRwRMIGo1AEucUSXuiknt3Y5748m8+7ylyGiloE+5Uch13qNbsW7YA==
X-Received: by 2002:a05:6000:1a8c:b0:386:5b2:a9d9 with SMTP id ffacd0b85a97d-38bf59f263bmr847763f8f.53.1737094102195;
        Thu, 16 Jan 2025 22:08:22 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3221c30sm1620638f8f.32.2025.01.16.22.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 22:08:21 -0800 (PST)
Date: Fri, 17 Jan 2025 09:08:18 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: kvm@vger.kernel.org
Subject: [bug report] KVM: x86: Unify TSC logic (sleeping in atomic?)
Message-ID: <37a79ba3-9ce0-479c-a5b0-2bd75d573ed3@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I don't know why I'm seeing this static checker warning only now.  All
this code looks to be about 15 years old...

Commit e48672fa25e8 ("KVM: x86: Unify TSC logic") from Aug 19, 2010
(linux-next), leads to the following Smatch static checker warning:

	arch/x86/kernel/tsc.c:1214 mark_tsc_unstable()
	warn: sleeping in atomic context

The code path is:

vcpu_load() <- disables preempt
-> kvm_arch_vcpu_load()
   -> mark_tsc_unstable() <- sleeps

virt/kvm/kvm_main.c
   166  void vcpu_load(struct kvm_vcpu *vcpu)
   167  {
   168          int cpu = get_cpu();
                          ^^^^^^^^^^
This get_cpu() disables preemption.

   169  
   170          __this_cpu_write(kvm_running_vcpu, vcpu);
   171          preempt_notifier_register(&vcpu->preempt_notifier);
   172          kvm_arch_vcpu_load(vcpu, cpu);
   173          put_cpu();
   174  }

arch/x86/kvm/x86.c
  4979          if (unlikely(vcpu->cpu != cpu) || kvm_check_tsc_unstable()) {
  4980                  s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
  4981                                  rdtsc() - vcpu->arch.last_host_tsc;
  4982                  if (tsc_delta < 0)
  4983                          mark_tsc_unstable("KVM discovered backwards TSC");
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
It seems pretty unlikely that we'll get a backwards tsc.  I remember
dealing with some of these seeing this 20 years ago.

  4984  

arch/x86/kernel/tsc.c
    1206 void mark_tsc_unstable(char *reason)
    1207 {
    1208         if (tsc_unstable)
    1209                 return;
    1210 
    1211         tsc_unstable = 1;
    1212         if (using_native_sched_clock())
    1213                 clear_sched_clock_stable();
--> 1214         disable_sched_clock_irqtime();
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
I'm on an allmodconfig on x86_64 so this expands to the
function below...

    1215         pr_info("Marking TSC unstable due to %s\n", reason);
    1216 
    1217         clocksource_mark_unstable(&clocksource_tsc_early);
    1218         clocksource_mark_unstable(&clocksource_tsc);
    1219 }

kernel/jump_label.c
   245  void static_key_disable(struct static_key *key)
   246  {
   247          cpus_read_lock();
                ^^^^^^^^^^^^^^^^
This lock has a might_sleep() in it which triggers the static checker
warning.

   248          static_key_disable_cpuslocked(key);
   249          cpus_read_unlock();
   250  }

regards,
dan carpenter

