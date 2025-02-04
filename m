Return-Path: <kvm+bounces-37248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 625D2A277BB
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 18:02:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0EF41654FB
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1846921578B;
	Tue,  4 Feb 2025 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NmxTTSbT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513D0175A5
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 17:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738688518; cv=none; b=SD1BFkMBnuDQcrqlPXV+qqzyFeEO3Y0MdyIAcaKZJB4TR2/+Ku4oWughJZN4brwpp7H+DUjjMVeVC/ZeDgriHAckbzI2QHT/8WEEY8HO3+h8kCMNjkadOa/gmoKF43SuXe2idxSKlng1dv1N5aJ0HRCVPxzZag9kC2c/DVC2f+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738688518; c=relaxed/simple;
	bh=uEmvTAlqty3Uxcb4pQ7abVmu+CxoETQTo6aCX4n10vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MmwIVRoxlAWYH9FHFtpKn1agodXcUeBIP4MYJYSxi1ShL/fkQWm0mRJ6vpSyhjRZLwtqgI23DQhb80o2dHfLwway5lDPfgRjcCrR+9U9AW1m5AHve2ecSynIy0pm3MIOnHT/fKjUny4sMqmofWe2s6dYYdCtvrHlVaZ42cDY2jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NmxTTSbT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738688515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmpuwmtNIyVuancbMXxzBE7rmXZl8E7krQ5h0kLqhxc=;
	b=NmxTTSbTljV7ht+iU2yRNGcYxIwhy5yaDaNgvSzssJUtV/fNuHIG06YhC9pi8ZXX2C/7+Z
	sLRfT4xfiBq1pYEfA767aZbbHNsnZD7FWshyS8tGxpX89XXYQpgZFL/mvrCkNEIdfquiCu
	bE3s/YJX9te+LX6tQUlnCz/lraDl7zs=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-W3b_zWI6NlyL1Su___lw7g-1; Tue, 04 Feb 2025 12:01:54 -0500
X-MC-Unique: W3b_zWI6NlyL1Su___lw7g-1
X-Mimecast-MFC-AGG-ID: W3b_zWI6NlyL1Su___lw7g
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-467bb8aad28so62119931cf.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 09:01:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738688513; x=1739293313;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jmpuwmtNIyVuancbMXxzBE7rmXZl8E7krQ5h0kLqhxc=;
        b=n1giVEkfN0qq9GlTB/4G6jh4oexXwH8Cf1OZO0rvSVrw2ZkrgpzdVulV9HYim712f9
         5COOdl5mrgsztARW0PmXzh3Z16SkpD1slXnFoXT959bzI5+dHRCVj1eZ+6yiqx3Cnfd7
         MxOSCQBrYYM6KXdkWlJhSBg05xM9nJccyHNPg/8F+afAohPhiQn+6mWzwKcvCtDpSkx8
         cjmeQys/gFxR8I+Los2jTi/WM0vei5HPPpxwYBY+ky1jLM5N2YsTNXAFx6H/bVNk0L0H
         jTEO+gdERjruWEOlQ0zsmbg4WncBz7eYvfqGlyFxYMH3Y+5/hcNWCCZibp2I+Th/+0il
         TByA==
X-Forwarded-Encrypted: i=1; AJvYcCUyFyOl0Sc9+XXzWWFWvd94IMhXKa+UsdWRmkulG1zV6lEmwcHsfkAF+SfoHG8HWUEXP+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoyRV34cGY94ST2fU3+1lGW5V+qjHIKwHRHL1P2zlFYtl54N2g
	yPbP3gf4ChLwFr7nGXery23IjM64zoKm7E0IoAkoZmUA61s9QLC4Is+fax6YyEEyJPFWIYEaG4a
	rRodetn8Wi+cSdUCkrxjQhidj/pkEorXTPtydvA3kZBtVWl4VQQ==
X-Gm-Gg: ASbGncuoug2LtotuMrrrrEAdK3FXSbbPP8LzMAY3ZsLbf1NJ4uNT0begdKmOTrigRV9
	UZrJnIOcuoytU19s5CsTrh6wPUbtP/GwSF4UmnTgl+VDDPx+SaSpqL6MPglu5jtG72EaYenBnub
	XWmm99N7uRA2qjoh5T0zjIBl5kTXcYq9ashZWHJtDqhlFnXeuD9zjvyGU/SZQNZCL4nuQyvLwQn
	nd8ytV2p+z/saCV7c3NNiIeCZRejdg0AfqGeDpU3LiumY3wkZmTFEEZaUoI27/3q9YeBGWJABrg
	XuBUevbHExW0yoTyoaSU5VKRunAIcYC1c38t1hPmEfTEPgzZ
X-Received: by 2002:ac8:5745:0:b0:467:75fa:8c8 with SMTP id d75a77b69052e-46fd0ad89femr403610821cf.31.1738688512396;
        Tue, 04 Feb 2025 09:01:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEmiCvI702XSjcGZ8IPiSidjwXwYfVjctXrd6dOhCMaN+Q6fbpH5jw2AZ0XrnixI4d7e81EDw==
X-Received: by 2002:ac8:5745:0:b0:467:75fa:8c8 with SMTP id d75a77b69052e-46fd0ad89femr403606451cf.31.1738688511250;
        Tue, 04 Feb 2025 09:01:51 -0800 (PST)
Received: from x1.local (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46fdf172372sm60828601cf.60.2025.02.04.09.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 09:01:50 -0800 (PST)
Date: Tue, 4 Feb 2025 12:01:48 -0500
From: Peter Xu <peterx@redhat.com>
To: =?utf-8?Q?=E2=80=9CWilliam?= Roche <william.roche@oracle.com>
Cc: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, pbonzini@redhat.com,
	richard.henderson@linaro.org, philmd@linaro.org,
	peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
	eduardo@habkost.net, marcel.apfelbaum@gmail.com,
	wangyanan55@huawei.com, zhao1.liu@intel.com,
	joao.m.martins@oracle.com
Subject: Re: [PATCH v7 3/6] accel/kvm: Report the loss of a large memory page
Message-ID: <Z6JH_OyppIA7WFjk@x1.local>
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-4-william.roche@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250201095726.3768796-4-william.roche@oracle.com>

On Sat, Feb 01, 2025 at 09:57:23AM +0000, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> In case of a large page impacted by a memory error, provide an
> information about the impacted large page before the memory
> error injection message.
> 
> This message would also appear on ras enabled ARM platforms, with
> the introduction of an x86 similar error injection message.
> 
> In the case of a large page impacted, we now report:
> Memory Error on large page from <backend>:<address>+<fd_offset> +<page_size>
> 
> The +<fd_offset> information is only provided with a file backend.
> 
> Signed-off-by: William Roche <william.roche@oracle.com>

This is still pretty kvm / arch relevant patch that needs some reviews.

I wonder do we really need this - we could fetch ramblock mapping
(e.g. hwaddr -> HVA) via HMP "info ramblock", and also dmesg shows process
ID + VA.  IIUC we have all below info already as long as we do some math
based on above.  Would that work too?

> ---
>  accel/kvm/kvm-all.c       | 18 ++++++++++++++++++
>  include/exec/cpu-common.h | 10 ++++++++++
>  system/physmem.c          | 22 ++++++++++++++++++++++
>  target/arm/kvm.c          |  3 +++
>  4 files changed, 53 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index f89568bfa3..9a0d970ce1 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1296,6 +1296,24 @@ static void kvm_unpoison_all(void *param)
>  void kvm_hwpoison_page_add(ram_addr_t ram_addr)
>  {
>      HWPoisonPage *page;
> +    struct RAMBlockInfo rb_info;
> +
> +    if (qemu_ram_block_info_from_addr(ram_addr, &rb_info)) {
> +        size_t ps = rb_info.page_size;
> +
> +        if (ps > TARGET_PAGE_SIZE) {
> +            uint64_t offset = QEMU_ALIGN_DOWN(ram_addr - rb_info.offset, ps);
> +
> +            if (rb_info.fd >= 0) {
> +                error_report("Memory Error on large page from %s:%" PRIx64
> +                             "+%" PRIx64 " +%zx", rb_info.idstr, offset,
> +                             rb_info.fd_offset, ps);
> +            } else {
> +                error_report("Memory Error on large page from %s:%" PRIx64
> +                            " +%zx", rb_info.idstr, offset, ps);
> +            }
> +        }
> +    }
>  
>      QLIST_FOREACH(page, &hwpoison_page_list, list) {
>          if (page->ram_addr == ram_addr) {
> diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
> index 3771b2130c..190bd4f34a 100644
> --- a/include/exec/cpu-common.h
> +++ b/include/exec/cpu-common.h
> @@ -110,6 +110,16 @@ int qemu_ram_get_fd(RAMBlock *rb);
>  size_t qemu_ram_pagesize(RAMBlock *block);
>  size_t qemu_ram_pagesize_largest(void);
>  
> +struct RAMBlockInfo {
> +    char idstr[256];
> +    ram_addr_t offset;
> +    int fd;
> +    uint64_t fd_offset;
> +    size_t page_size;
> +};
> +bool qemu_ram_block_info_from_addr(ram_addr_t ram_addr,
> +                                   struct RAMBlockInfo *block);
> +
>  /**
>   * cpu_address_space_init:
>   * @cpu: CPU to add this address space to
> diff --git a/system/physmem.c b/system/physmem.c
> index e8ff930bc9..686f569270 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -1678,6 +1678,28 @@ size_t qemu_ram_pagesize_largest(void)
>      return largest;
>  }
>  
> +/* Copy RAMBlock information associated to the given ram_addr location */
> +bool qemu_ram_block_info_from_addr(ram_addr_t ram_addr,
> +                                   struct RAMBlockInfo *b_info)
> +{
> +    RAMBlock *rb;
> +
> +    assert(b_info);
> +
> +    RCU_READ_LOCK_GUARD();
> +    rb =  qemu_get_ram_block(ram_addr);
> +    if (!rb) {
> +        return false;
> +    }
> +
> +    pstrcat(b_info->idstr, sizeof(b_info->idstr), rb->idstr);
> +    b_info->offset = rb->offset;
> +    b_info->fd = rb->fd;
> +    b_info->fd_offset = rb->fd_offset;
> +    b_info->page_size = rb->page_size;
> +    return true;
> +}
> +
>  static int memory_try_enable_merging(void *addr, size_t len)
>  {
>      if (!machine_mem_merge(current_machine)) {
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index da30bdbb23..d9dedc6d74 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -2389,6 +2389,9 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>                  kvm_cpu_synchronize_state(c);
>                  if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
>                      kvm_inject_arm_sea(c);
> +                    error_report("Guest Memory Error at QEMU addr %p and "
> +                        "GUEST addr 0x%" HWADDR_PRIx " of type %s injected",
> +                        addr, paddr, "BUS_MCEERR_AR");
>                  } else {
>                      error_report("failed to record the error");
>                      abort();
> -- 
> 2.43.5
> 

-- 
Peter Xu


