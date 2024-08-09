Return-Path: <kvm+bounces-23680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7089B94CBAE
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 09:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 952861C21EA6
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 07:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AB6818B479;
	Fri,  9 Aug 2024 07:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="jl1wFEPO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8401552EB
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 07:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723189975; cv=none; b=PbAyM8fVERz+IkO0Bwtjfc70FR5G0Ihxx153YG+QhHyYZsZIaKuX2sBDDIJf/PjpfVq96Jjdcrx13d4Piql2qgJpHYMHuM782CsK8URbTMNlCJKGh0sYRFkVfo+m9cMqtsfUlGQ/FSsujrzeNAfWHzEVwEi5g4Y1bOOg448H/JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723189975; c=relaxed/simple;
	bh=eOsOzYkMzDHNyFIkIb7tpMCodecllNjAcxSfi04df18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=etZKPW9GfZE3FOYu40lSn2mQ8CVbqr4MsyTwDicKJfItV1KEaPz6s/XTQNNOiWOsfZfp3up0Zs0TGNtjPtbJZ3O/P0TTLE8oAuQKe3bbQSclVMilnS91kewisjNXIXmzEKDqwMM1I3ghoFOoifCTdFV9VowXB7+j6zMVSPirTdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=jl1wFEPO; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a7aada2358fso442933866b.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 00:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1723189972; x=1723794772; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jgfKoY2UqFWOlheqZAovddH83lyUDKhWnFVDfEfsqp8=;
        b=jl1wFEPOUFMulgutA7etrICDiHvLOPndTIblfSZr3C/zBzRu8XHJYsdohWirmZFcZp
         WJPq6eqmH3z9/ee4ki/drHq+s2rb2/YBYWdRa0txVBDbXx9Yvx11LKdjLSmtYIJHfekC
         cTAadva/J9lrmvOcwBvFdclYzcWrVTPpoDIaxz63YxckIYD6+HatIpRSDCFX3FO8VnhO
         tnWJpWskepWMEnKF59bQaytOlX2b/bgw/QJsjMFYxt6sO36qN9ZFcEPTfzimkCrWHOhj
         nBC60j+0tkf8IwbAtDfD8E4NqhU/zDyYXJ9OItfmh9ip29D+HtP0BVqHIbQOgSpkNYS9
         s2vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723189972; x=1723794772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgfKoY2UqFWOlheqZAovddH83lyUDKhWnFVDfEfsqp8=;
        b=pFISrDS+pIJz5PB0+T7CKYV3d+OYzkx3rQM1WPAfb/J4XG6icAsWsp6Pvd09tVv11E
         7P7E3nIFl5YFkVJPlok9TqmtMrdph6C6GZxLPg7vmpbgFE0c1Dmzhd1J02kYKcMGN1yl
         KFu0LvVc6uTePpU8s3A3LKWf39IlkVwga6QXv2QaBYY0dZ9bDHlT38E1/5QVT3Wd0hSs
         iy8yiEaaxfvtiLEL0q08nGSKOhtj/4c7pcqTPs3tcr65hqs2PLnScaHrlROr1hvCEr3W
         RRNWs11oICkTOYRd1m7EGHIByXn7WHbte10DcbLTL/wG13gS38eMiE0TVdf/B5NmL+wv
         kjRg==
X-Gm-Message-State: AOJu0YzIOpRkrM5mXehIYGBvLti+a67obbld/mKjGFH0xl50vnPQSfb0
	VNvM3PdLz7WcRjYY/n4bGJaHskkuJUSy9dfCUtO8VWeRD9fyOAYi4qdmarDivYY=
X-Google-Smtp-Source: AGHT+IGoYy0uJm1GeB9AcyrDRnx2z8UHFskwO25q0bff8FiN+qfqGnH8D0U7cgDyf6a3ACzN/teIzQ==
X-Received: by 2002:a17:907:6d05:b0:a7a:952b:95cf with SMTP id a640c23a62f3a-a809207da83mr328190266b.32.1723189971102;
        Fri, 09 Aug 2024 00:52:51 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9c0c9f5sm816536666b.50.2024.08.09.00.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 00:52:50 -0700 (PDT)
Date: Fri, 9 Aug 2024 09:52:49 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	andrew.jones@linux.dev, atishp@rivosinc.com, cade.richard@berkeley.edu, 
	jamestiotio@gmail.com
Subject: Re: [PATCH kvm-unit-tests] riscv: sbi: add dbcn write test
Message-ID: <20240809-c1d22e0da4f7741c1c3a43aa@orel>
References: <20240806-sbi-dbcn-write-test-v1-1-7f198bb55525@berkeley.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806-sbi-dbcn-write-test-v1-1-7f198bb55525@berkeley.edu>


Yet another comment on this patch is that the subject is missing the 'v4'
prefix. Anyway, no need to send a v5. I had 10 free minutes so I just went
a head and made all the simple changes myself and queued it.

drew

On Tue, Aug 06, 2024 at 10:51:54PM GMT, Cade Richard wrote:
> 
> 
> ---
> Added a unit test for the RISC-V SBI debug console write() and write_byte() functions. The output of the tests must be inspected manually to verify that the correct bytes are written. For write(), the expected output is 'DBCN_WRITE_TEST_STRING'. For write_byte(), the expected output is 'a'.
> 
> Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
> ---
>  lib/riscv/asm/sbi.h |  7 ++++++
>  riscv/sbi.c         | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 73ab5438..47e91025 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -19,6 +19,7 @@ enum sbi_ext_id {
>  	SBI_EXT_TIME = 0x54494d45,
>  	SBI_EXT_HSM = 0x48534d,
>  	SBI_EXT_SRST = 0x53525354,
> +	SBI_EXT_DBCN = 0x4442434E,
>  };
>  
>  enum sbi_ext_base_fid {
> @@ -42,6 +43,12 @@ enum sbi_ext_time_fid {
>  	SBI_EXT_TIME_SET_TIMER = 0,
>  };
>  
> +enum sbi_ext_dbcn_fid {
> +	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
> +	SBI_EXT_DBCN_CONSOLE_READ,
> +	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
> +};
> +
>  struct sbiret {
>  	long error;
>  	long value;
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 2438c497..61993f08 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -15,6 +15,10 @@
>  #include <asm/sbi.h>
>  #include <asm/smp.h>
>  #include <asm/timer.h>
> +#include <asm/io.h>
> +
> +#define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
> +#define DBCN_WRITE_BYTE_TEST_BYTE	(u8)'a'
>  
>  static void help(void)
>  {
> @@ -32,6 +36,11 @@ static struct sbiret __time_sbi_ecall(unsigned long stime_value)
>  	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
>  }
>  
> +static struct sbiret __dbcn_sbi_ecall(int fid, unsigned long arg0, unsigned long arg1, unsigned long arg2)
> +{
> +	return sbi_ecall(SBI_EXT_DBCN, fid, arg0, arg1, arg2, 0, 0, 0);
> +}
> +
>  static bool env_or_skip(const char *env)
>  {
>  	if (!getenv(env)) {
> @@ -248,6 +257,62 @@ static void check_time(void)
>  	report_prefix_pop();
>  }
>  
> +static void check_dbcn(void)
> +{
> +	
> +	struct sbiret ret;
> +	unsigned long num_bytes, base_addr_lo, base_addr_hi;
> +	int num_calls = 0;
> +	
> +	num_bytes = strlen(DBCN_WRITE_TEST_STRING);
> +	phys_addr_t p = virt_to_phys((void *)&DBCN_WRITE_TEST_STRING);
> +	base_addr_lo = (unsigned long)p;
> +	base_addr_hi = (unsigned long)(p >> __riscv_xlen);
> +
> +	report_prefix_push("dbcn");
> +	
> +	ret = __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_DBCN);
> +	if (!ret.value) {
> +		report_skip("DBCN extension unavailable");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	report_prefix_push("write");
> +
> +	do {
> +		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
> +		num_bytes -= ret.value;
> +		base_addr_lo += ret.value;
> +		num_calls++;
> +	} while (num_bytes != 0 && ret.error == SBI_SUCCESS) ;
> +	report(ret.error == SBI_SUCCESS, "write success");
> +	report_info("%d sbi calls made", num_calls);
> +	
> +	/*
> +		Bytes are read from memory and written to the console
> +	*/
> +	if (env_or_skip("INVALID_READ_ADDR")) {
> +		phys_addr_t p = strtoull(getenv("INVALID_READ_ADDR"), NULL, 0);
> +		base_addr_lo = (unsigned long)p;
> +		base_addr_hi = (unsigned long)(p >> __riscv_xlen);
> +		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, 1, base_addr_lo, base_addr_hi);
> +		report(ret.error == SBI_ERR_INVALID_PARAM, "invalid parameter: address");
> +	};
> +
> +	report_prefix_pop();
> +	
> +	report_prefix_push("write_byte");
> +
> +	puts("DBCN_WRITE TEST CHAR: ");
> +	ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, (u8)DBCN_WRITE_BYTE_TEST_BYTE, 0, 0);
> +	puts("\n");
> +	report(ret.error == SBI_SUCCESS, "write success");
> +	report(ret.value == 0, "expected ret.value");
> +
> +	report_prefix_pop();
> +}
> +
>  int main(int argc, char **argv)
>  {
>  
> @@ -259,6 +324,7 @@ int main(int argc, char **argv)
>  	report_prefix_push("sbi");
>  	check_base();
>  	check_time();
> +	check_dbcn();
>  
>  	return report_summary();
>  }
> 
> ---
> base-commit: 1878b4b663fd50b87de7ba2b1c90614e2703542f
> change-id: 20240806-sbi-dbcn-write-test-70d305d511cf
> 
> Best regards,
> -- 
> Cade Richard <cade.richard@berkeley.edu>
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

