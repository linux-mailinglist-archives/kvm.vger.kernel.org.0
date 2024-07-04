Return-Path: <kvm+bounces-20960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D14BD927757
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 15:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8782528337D
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 13:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE16C1AED32;
	Thu,  4 Jul 2024 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DvndZgSV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5341F28373
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 13:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720100456; cv=none; b=PCKswkMFGtt1aORP75z2xiQ5wVuHfRjoX08svVcIcVLKNWNuo5ophaOlhW9rqc+dOx/oiqMVEHR9mM+YEFXIwqERkHT8A+mZXJtnEjiGTBBTa8AZfNSp1miXGGfXu21TDSlaDvhdq191hjQ/1ddSSFSRZUkdycSavsrImavyvzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720100456; c=relaxed/simple;
	bh=3d6yrHJBiliKokDEzJk4V9k10z4fp7B/0LKtQ81REWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XZm3+xM0kl1r3jzghUAIwt5FtO8uqIaouEInko56vTS2yPo5cZ63poGxg8t0uCBGCvY0cdqX/fO3ahGEIlzlDWz8vOYI50413A9ADUfADuY/gyhX4bl5t+M7LULhcMFWJ2Zf8ZrMCMUcKddNrTtkSXFPYgMNRKJbnJeTAqI2vSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=DvndZgSV; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6b5e0d881a1so13597936d6.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 06:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1720100453; x=1720705253; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g7DfNCd8CcawUOZB42unLcDoIgrVN1sKM5xeSfoo08Q=;
        b=DvndZgSVu3PQiNmjvhm0x2+gb08ZpetVytMaZQmLbxKRgprjxbOSkYiNEU1vLlVeHj
         y9sG3ifJIq5nRX/D9mXu808bt1sME/dwZeZ7Y/mqDwYqFU8nWmaqGPrfU8WxFiNZuogB
         nW4TkddNoTfiBQKo0b/ZcppNflWEpGou8rnUgT8oxhRAveMjHDmqFPSfvGcuECiCDCj8
         nCIxrTKqtshahLTnwSyQHF9LMb14bg9+JFwsWprfPq8kPK0U3nKlSFc2GcqGsQt+V/6V
         26BxC6gVCgtKKoad1KQkEbfKkfPdNK8sL2kJIkM1V4gf4abmooDQKOQjs47WX4Q+D/9z
         6N8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720100453; x=1720705253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7DfNCd8CcawUOZB42unLcDoIgrVN1sKM5xeSfoo08Q=;
        b=vaZKjJ5M06oosga6s+YA8ao7gTqMX4Vv0QyUOU65vfq+6aKlyQfRpeBsmVOCYkvDoD
         SQTQgh9EPzVtuXRsT5ZR4PkjckcyXUlI+6YAOxey29maSKd53UvwEKoVv1Q0Tjw4oZ3X
         /WyyVn3x9tTyKsDD8qVMti+Zi1FXhmqeapZis8/O3VhIBpI6EnIUrekDa7v6iOd0GDHZ
         J39uvjRWu62HEuSDAAX3JMcOe5HGRwcKoXgd0LhBDN3aL6grAzxXNAZlpqkOwNi0c9eY
         x/vBf3V95c9NIVjwyI884ta0sUiyZh/cbHXjmzuE9AUVKGeqrTidez4OwmuSP0VGL3uA
         4wSg==
X-Gm-Message-State: AOJu0Yzx34BIWt/q2akzZEzyFfQxvy3KMWjy98msBZeEYXvfMWBb3l4V
	biGSs/s25/bSg0NL1GHvIiKiaCrKnvJ6/o3odjuCNmQYWfvG3ZziG9mbCEUGaFc=
X-Google-Smtp-Source: AGHT+IG/FBqkLdQi7cbNZDbgMWxCIgnVTrVXY24PW0hmLgHzfD79iXnVDRZNJVwWp10Sbf5XDbsUjA==
X-Received: by 2002:ad4:5c85:0:b0:6b2:a333:2a9f with SMTP id 6a1803df08f44-6b5ee62b902mr27535696d6.23.1720100453087;
        Thu, 04 Jul 2024 06:40:53 -0700 (PDT)
Received: from localhost ([207.237.245.58])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b5ac0752bfsm57598726d6.124.2024.07.04.06.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 06:40:52 -0700 (PDT)
Date: Thu, 4 Jul 2024 08:40:52 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	andrew.jones@linux.dev, atishp@rivosinc.com, cade.richard@berkeley.edu, 
	jamestiotio@gmail.com
Subject: Re: [PATCH kvm-unit-tests] This patch adds a unit test for the debug
 console write() and write_byte() functions. It also fixes the virt_to_phys()
 function to return the offset address, not the PTE aligned address.
Message-ID: <20240704-86beeeb5968c9f23cc100963@orel>
References: <20240703-sbi-dbcn-write-v1-1-13f08380d768@berkeley.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703-sbi-dbcn-write-v1-1-13f08380d768@berkeley.edu>

Hi Cade,

The patch summary (the part that becomes the email subject line) should
be a concise phrase and not be longer than 75 characters. The rest of the
patch description goes in the commit message (line wrapping at 75). It
looks like you have all the text in the patch summary right now. Also,
the commit message should point out the motivation, approach, remaining
work etc., and it's a red flag when a patch has an "and also..." in its
commit message, as that implies it needs to be split. A single patch
should do a single thing. In this case I see an "and also virt_to_phys"
type of thing, but I don't see that change. The virt_to_phys() change
should be a separate patch and come before this patch, as this patch
needs the fixed virt_to_phys().

On Wed, Jul 03, 2024 at 08:43:44PM GMT, Cade Richard wrote:
> 
> 
> ---
> Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
> ---
>  riscv/run           |  1 +
>  lib/riscv/asm/sbi.h |  5 ++++
>  riscv/sbi.c         | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 77 insertions(+)
> 
> diff --git a/riscv/run b/riscv/run
> index 73f2bf54..e4e39d74 100755
> --- a/riscv/run
> +++ b/riscv/run
> @@ -30,6 +30,7 @@ fi
>  mach='-machine virt'
>  
>  command="$qemu -nodefaults -nographic -serial mon:stdio"
> +

Stray, unnecessary change. Please be sure your tree only contains the
changes you want to make before you commit and generate patches.

>  command+=" $mach $acc $firmware -cpu $processor "
>  command="$(migration_cmd) $(timeout_cmd) $command"
>  
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index d82a384d..4ae15879 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -12,6 +12,11 @@
>  #define SBI_ERR_ALREADY_STARTED		-7
>  #define SBI_ERR_ALREADY_STOPPED		-8
>  
> +#define DBCN_WRITE_TEST_STRING "DBCN_WRITE_TEST_STRING\n"
> +#define DBCN_READ_TEST_STRING "DBCN_READ_TEST_STRING\n"

This patch is only adding write tests so we don't need a read test string.

> +#define DBCN_WRITE_BYTE_TEST_BYTE 'a'
> +#define DBCN_WRITE_TEST_BYTE_FLAG "DBCN_WRITE_TEST_CHAR: "

"DBCN_WRITE_TEST_CHAR:" isn't a flag it's a prefix, so the define should
be named DBCN_WRITE_TEST_BYTE_PREFIX, but we don't need a define at all,
as it's only used in one place, so just puts() the string itself.

Also tab out the values of these symbols to line them up, i.e.

#define FOO	"FOO"
#define BAR	"BAR"

And the defines don't belong in asm/sbi.h. That header is for common sbi
support, not unit test stuff. Test strings are just for tests so the
defines should go directly into the test source (riscv/sbi.c).

> +
>  #ifndef __ASSEMBLY__
>  
>  enum sbi_ext_id {
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 762e9711..0fb7a300 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -7,6 +7,11 @@
>  #include <libcflat.h>
>  #include <stdlib.h>
>  #include <asm/sbi.h>
> +#include <asm/csr.h>
> +#include <asm/io.h>
> +#include <asm/sbi.h>
> +
> +#define INVALID_RW_ADDR 0x0000000002000000;

No need for the leading 0's. We can't be sure this will be invalid on all
platforms. The platform needs to be able to configure stuff like this.
We use environment variables for that. We can provide a QEMU value as a
default though.

>  
>  static void help(void)
>  {
> @@ -112,6 +117,72 @@ static void check_base(void)
>  	report_prefix_pop();
>  }
>  
> +static void check_dbcn(void)
> +{
> +	
> +	struct sbiret ret;
> +	unsigned long num_bytes, base_addr_lo, base_addr_hi;
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
> +	report_prefix_pop();

We don't want to pop 'dbcn' here. We're still in the dbcn tests.

> +
> +	report_prefix_push("write");
> +	
> +	num_bytes = strlen(DBCN_WRITE_TEST_STRING);
> +	base_addr_hi = 0x0;
> +	base_addr_lo = virt_to_phys((void *) &DBCN_WRITE_TEST_STRING);
                                            ^ remove the space here
> +
> +	do {
> +		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);

The pointer and number of bytes should be changing by the amount written
when we need additional writes in order to finish the string.

> +	} while (ret.value != num_bytes || ret.error != SBI_SUCCESS) ;

If ret.error isn't success than we should break from the loop, otherwise 
we could loop forever on a failing write and the report() check below
would be useless.

> +	report(SBI_SUCCESS == ret.error, "write success");
> +    report(ret.value == num_bytes, "correct number of bytes written");

This line isn't using a tab. Please run the kernel's checkpatch script on
the patch before posting. Also this test is wrong because the last
ret.value may be less than num_bytes and we know we wrote a total of
num_bytes since we looped until we did.

> +
> +	base_addr_lo = INVALID_RW_ADDR;
> +	ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
> +    report(SBI_ERR_INVALID_PARAM == ret.error, "invalid parameter: address");

spaces instead of tab and I prefer variable first in conditions.

> +
> +	report_prefix_pop();
> +	
> +	report_prefix_push("read");
> +
> +/*	num_bytes = strlen(DBCN_READ_TEST_STRING);
> +	char *actual = malloc(num_bytes);
> +	base_addr_hi = 0x0;
> +	base_addr_lo = virt_to_phys(( void *) actual);
> +
> +	do {
> +		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_READ, num_bytes, base_addr_lo, base_addr_hi);
> +	} while (ret.value != num_bytes || ret.error != SBI_SUCCESS) ;
> +	report(SBI_SUCCESS == ret.error, "read success");
> +    report(ret.value == num_bytes, "correct number of bytes read");
> +	report(strcmp(actual,DBCN_READ_TEST_STRING) == 0, "correct bytes read");
> +*/

All this commented out stuff above should not be in the patch. A TODO
comment with a plan for a test is fine, but a bunch of commented out
untested code is just clutter. Also, the commit message says its adding
write and write_byte, nothing about read, so read shouldn't be here at
all.

> +	base_addr_lo = INVALID_RW_ADDR;
> +    ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_READ, num_bytes, base_addr_lo, base_addr_hi);
> +    report(SBI_ERR_INVALID_PARAM == ret.error, "invalid parameter: address");

need to use tabs and variable first in conditions

> +
> +	report_prefix_pop();
> +	
> +	report_prefix_push("write_byte");
> +
> +	puts(DBCN_WRITE_TEST_BYTE_FLAG);
> +	ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, (u8) DBCN_WRITE_BYTE_TEST_BYTE, 0, 0);
                                                                    ^ no
					space and we can put the cast on
					the define instead of here

> +	puts("\n");
> +    report(SBI_SUCCESS == ret.error, "write success");
> +    report(0 == ret.value, "expected ret.value");

need to use tabs and variable first in conditions

> +
> +	report_prefix_pop();
> +}
> +
>  int main(int argc, char **argv)
>  {
>

As this test isn't actually confirming that the writes were actually
written then the commit message should explain that it's expected the
output of the test be inspected to ensure the test strings and bytes
are written.

Thanks,
drew

