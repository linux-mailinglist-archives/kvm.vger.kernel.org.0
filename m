Return-Path: <kvm+bounces-7686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1506A845423
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 10:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4539F1C20D06
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD15D15DBDF;
	Thu,  1 Feb 2024 09:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GkZoVhPV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA1415DBC9
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 09:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706780071; cv=none; b=BT1MMAgM6QZH34OFthunTmp6NH/3ndWEDHCozxkzwbDmckqb7KPQ7eSSnu/E+HDsnciCPdJmCQYVA6zpJyAwvsGO68fm9ecmiExc3sUtyqasUtGbOv7UVwajUXkauPnrjKyi750ridkY8QqlP4PUPbelAxKf17e/3Ueuj01tMhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706780071; c=relaxed/simple;
	bh=jbCMGhadY8+aTcrS8iELZ3H62oZgYB3Aqj3D9xUwvsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I9kOh57UQA01Ja8bYdqrUyc+zzSKzOnFY/jKBgmYXs4pafkpbWE3zi9X/xd3e068E/nFoAHkUdf2maFUcIZHmlK1u5WwbxW73lQgztSTXhhhoDcoYVhj9uV0pniBqdAshBtoEec9IUE+WuqZUFTrvWHnv8c0xELCz6loKNSEOLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GkZoVhPV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706780069;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QbKXlj2qJmYcwwoAL264/SJMr9ivxzGCitMWNoXprno=;
	b=GkZoVhPVMsfF/vCBemrY899nIFe3FAkP+Vo55ztbaQJ9MbgG6wDvKljFurI2nkWJEkcpA/
	hk04Ki6MAzXGuvnMnoqRY69Dnn7sW8k6HEo5GqG1aORekiZjaKlvLGV3lX1+cUM4/7xz6x
	PbpB/aU+gZly5UJ/mjp6XdWro3VqsRw=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-vpbPSfLgMUGnON2C_464ZA-1; Thu, 01 Feb 2024 04:34:27 -0500
X-MC-Unique: vpbPSfLgMUGnON2C_464ZA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-50e55470b49so695631e87.0
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 01:34:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706780066; x=1707384866;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QbKXlj2qJmYcwwoAL264/SJMr9ivxzGCitMWNoXprno=;
        b=WWd72uy7W4ECXEZucCRjPdlFpu+bqN1eZGXwkf5PlcwDVpRhTUQ46pO0zl3WPNrKTK
         wKpIUYgkhTkU/1+Qk0MlrO85ssSpk2nrv+sZSM9qe7fOXyxUKEfh0XfWTnwqAiZmELMe
         gRCTKEWXZ5ms1VVUI14RLAZxcUv3TklmIlTGdPIZ8MEfG3QdeK3NXwPxM4AvLpaL8RPx
         qbWGXee1/XJHYSnVl+0ONvVOkpG4ZKAPo1ucteMrVotj6VohhOkQhTBNp5u3mFJ65Y6Y
         pOkwb+jbnieigfF5bVNQMy2WyQpaN2Bp16ob0bYvBEn5lt1jFbx/eajoTZ5xCIGYIVqu
         fxHg==
X-Gm-Message-State: AOJu0YwIwElPsFko19ko4PUVlK0amaa8wcevJO71g7TEmzh5oP0sBIPK
	vOM8NzyMVpFD411bHYSaGtKiOuGxoQjYiEi1+bOZrXAJROLKCK/N1cSjQWSs5migm7v1fEM3Sbc
	w91DMuSlhOlgffXXy5G3BJ1mG1BVKDOytW1PAH37Iz1bKelWhUg==
X-Received: by 2002:ac2:42c2:0:b0:511:2da1:d34f with SMTP id n2-20020ac242c2000000b005112da1d34fmr946656lfl.68.1706780066375;
        Thu, 01 Feb 2024 01:34:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGvccMcskijAMysxvD7yYFYGNPus6UL4rYmCZTFAmOefTGXD1uzbrcKE/pB3OC9GGXxacmo0A==
X-Received: by 2002:ac2:42c2:0:b0:511:2da1:d34f with SMTP id n2-20020ac242c2000000b005112da1d34fmr946637lfl.68.1706780066004;
        Thu, 01 Feb 2024 01:34:26 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW3PpPY/C3y3Z+XF8gr1uRDBGy7Qg283nXZee1wNMd3gy39QCZOZf10LIBFH6YXs0b+50OaE8RjhdGD8VFB2FnUdNmL8b5NBXWBnJS1OK7z3QxnABKWgjyouvVzC5OaL6OYnz5vZvOXEOi86j5RF8bCpryXqotjRcZTMKvg7G9PARh+rqSOtT3XHqrhlYMJHAVYvMil7gFnUeMVO2y0dQzplbsqppc/UWjyNjj16Ni9izNUJJq98HhfTo+1dwN0Kka34iMyySTdVulFR/XmNnoEYkGJf1jUa3qt2qM2hRqG+s/wnowbWFE=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id s15-20020a05600c45cf00b0040e3635ca65sm3890448wmo.2.2024.02.01.01.34.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 01:34:25 -0800 (PST)
Message-ID: <f2c558f7-4ba6-4ea5-966a-7b820ee3a2b8@redhat.com>
Date: Thu, 1 Feb 2024 10:34:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 12/24] arm/arm64: Remove spinlocks from
 on_cpu_async
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-38-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-38-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/26/24 15:23, Andrew Jones wrote:
> Remove spinlocks from on_cpu_async() by pulling some of their
> use into a new function and also by narrowing the locking to a
> single on_cpu_info structure by introducing yet another cpumask.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/arm/asm/smp.h |  4 +++-
>  lib/arm/smp.c     | 37 ++++++++++++++++++++++++++++---------
>  2 files changed, 31 insertions(+), 10 deletions(-)
>
> diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> index 9f6d839ab568..f0c0f97a19f8 100644
> --- a/lib/arm/asm/smp.h
> +++ b/lib/arm/asm/smp.h
> @@ -27,9 +27,11 @@ extern bool cpu0_calls_idle;
>  extern void halt(void);
>  extern void do_idle(void);
>  
> -extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
>  extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
>  extern void on_cpu(int cpu, void (*func)(void *data), void *data);
>  extern void on_cpus(void (*func)(void *data), void *data);
>  
> +extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
> +extern void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry);
> +
>  #endif /* _ASMARM_SMP_H_ */
> diff --git a/lib/arm/smp.c b/lib/arm/smp.c
> index c00fda2efb03..e0872a1a72c2 100644
> --- a/lib/arm/smp.c
> +++ b/lib/arm/smp.c
> @@ -76,12 +76,32 @@ void smp_boot_secondary(int cpu, secondary_entry_fn entry)
>  	spin_unlock(&lock);
>  }
>  
> +void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry)
> +{
> +	spin_lock(&lock);
> +	if (!cpu_online(cpu))
> +		__smp_boot_secondary(cpu, entry);
> +	spin_unlock(&lock);
> +}
> +
>  struct on_cpu_info {
>  	void (*func)(void *data);
>  	void *data;
>  	cpumask_t waiters;
>  };
>  static struct on_cpu_info on_cpu_info[NR_CPUS];
> +static cpumask_t on_cpu_info_lock;
> +
> +static bool get_on_cpu_info(int cpu)
> +{
> +	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
> +}
> +
> +static void put_on_cpu_info(int cpu)
> +{
> +	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
> +	assert(ret);
> +}
>  
>  static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
>  {
> @@ -158,22 +178,21 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
>  	assert_msg(cpu != 0 || cpu0_calls_idle, "Waiting on CPU0, which is unlikely to idle. "
>  						"If this is intended set cpu0_calls_idle=1");
>  
> -	spin_lock(&lock);
> -	if (!cpu_online(cpu))
> -		__smp_boot_secondary(cpu, do_idle);
> -	spin_unlock(&lock);
> +	smp_boot_secondary_nofail(cpu, do_idle);
>  
>  	for (;;) {
>  		cpu_wait(cpu);
> -		spin_lock(&lock);
> -		if ((volatile void *)on_cpu_info[cpu].func == NULL)
> -			break;
> -		spin_unlock(&lock);
> +		if (get_on_cpu_info(cpu)) {
> +			if ((volatile void *)on_cpu_info[cpu].func == NULL)
> +				break;
> +			put_on_cpu_info(cpu);
> +		}
>  	}
> +
>  	on_cpu_info[cpu].func = func;
>  	on_cpu_info[cpu].data = data;
> -	spin_unlock(&lock);
>  	set_cpu_idle(cpu, false);
> +	put_on_cpu_info(cpu);
>  	smp_send_event();
>  }
>  


