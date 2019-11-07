Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3645CF30AB
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 14:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbfKGNzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 08:55:42 -0500
Received: from foss.arm.com ([217.140.110.172]:56714 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730980AbfKGNzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 08:55:41 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AB9131B;
        Thu,  7 Nov 2019 05:55:41 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7699E3F71A;
        Thu,  7 Nov 2019 05:55:40 -0800 (PST)
Date:   Thu, 7 Nov 2019 13:55:37 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        Julien Grall <julien.grall.oss@gmail.com>
Subject: Re: [PATCH kvmtool 10/16] kvmtool: Allow standard size specifiers
 for memory
Message-ID: <20191107135537.5786f77c@donnerap.cambridge.arm.com>
In-Reply-To: <1569245722-23375-11-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
        <1569245722-23375-11-git-send-email-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Sep 2019 14:35:16 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Allow standard suffixes, K, M, G, T & P suffixes (lowercase and uppercase)
> for sizes and addresses for memory bank parameters. By default, the size is
> specified in MB.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  builtin-run.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 49 insertions(+), 6 deletions(-)
> 
> diff --git a/builtin-run.c b/builtin-run.c
> index df255cc44078..757ede4ac0d1 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -49,9 +49,11 @@
>  #include <ctype.h>
>  #include <stdio.h>
>  
> -#define MB_SHIFT		(20)
>  #define KB_SHIFT		(10)
> +#define MB_SHIFT		(20)
>  #define GB_SHIFT		(30)
> +#define TB_SHIFT		(40)
> +#define PB_SHIFT		(50)
>  
>  __thread struct kvm_cpu *current_kvm_cpu;
>  
> @@ -87,6 +89,48 @@ void kvm_run_set_wrapper_sandbox(void)
>  	kvm_run_wrapper = KVM_RUN_SANDBOX;
>  }
>  
> +static int parse_unit(char **next)
> +{
> +	int shift = 0;
> +
> +	switch(**next) {
> +	case 'K': case 'k': shift = KB_SHIFT; break;
> +	case 'M': case 'm': shift = MB_SHIFT; break;
> +	case 'G': case 'g': shift = GB_SHIFT; break;
> +	case 'T': case 't': shift = TB_SHIFT; break;
> +	case 'P': case 'p': shift = PB_SHIFT; break;
> +	}
> +
> +	if (shift)
> +		(*next)++;
> +
> +	return shift;
> +}
> +
> +static u64 parse_size(char **next)
> +{
> +	int shift = parse_unit(next);
> +
> +	/* By default the size is in MB, if none is specified. */
> +	if (!shift)
> +		shift = 20;
> +
> +	while (**next != '\0' && **next != '@')
> +		(*next)++;

Mmh, doesn't that skip over invalid characters, which should be reported as an error? Like "12Three"? Why do we need to skip something here anyway?

> +
> +	return ((u64)1) << shift;

Is there any reason we don't just return the shift value back? Seems more efficient to me.

> +}
> +
> +static u64 parse_addr(char **next)
> +{
> +	int shift = parse_unit(next);
> +
> +	while (**next != '\0')
> +		(*next)++;

Same here, why do we skip characters? Especially since we check for \0 in the caller below.

Cheers,
Andre

> +
> +	return ((u64)1) << shift;
> +}
> +
>  static int mem_parser(const struct option *opt, const char *arg, int unset)
>  {
>  	struct kvm_config *cfg = opt->value;
> @@ -99,15 +143,12 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
>  	if (next == p)
>  		die("Invalid memory size");
>  
> -	/* The user specifies the memory in MB, we use bytes. */
> -	size <<= MB_SHIFT;
> +	size *= parse_size(&next);
>  
>  	if (*next == '\0')
>  		goto out;
> -	else if (*next == '@')
> -		p = next + 1;
>  	else
> -		die("Unexpected character after memory size: %c", *next);
> +		p = next + 1;
>  
>  	addr = strtoll(p, &next, 0);
>  	if (next == p)
> @@ -118,6 +159,8 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
>  		die("Specifying the memory address not supported by the architecture");
>  #endif
>  
> +	addr *= parse_addr(&next);
> +
>  out:
>  	cfg->ram_base = addr;
>  	cfg->ram_size = size;

