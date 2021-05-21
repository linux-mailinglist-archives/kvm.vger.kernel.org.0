Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D664B38C989
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 16:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237117AbhEUOwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 10:52:32 -0400
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:32824 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232057AbhEUOwc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 10:52:32 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2021 10:52:32 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id CDFDB18005A65;
        Fri, 21 May 2021 14:45:44 +0000 (UTC)
Received: from omf03.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id BE128D218;
        Fri, 21 May 2021 14:45:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf03.hostedemail.com (Postfix) with ESMTPA id 74ED713D95;
        Fri, 21 May 2021 14:45:25 +0000 (UTC)
Message-ID: <9d8659fc8bc0729dd255c20234fb1a4210847ce9.camel@perches.com>
Subject: Re: [PATCH v2 7/7] checkpatch: suggest _BITULL() and _BITUL() for
 UAPI headers
From:   Joe Perches <joe@perches.com>
To:     Joe Richey <joerichey94@gmail.com>, trivial@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Andy Whitcroft <apw@canonical.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Peter Xu <peterx@redhat.com>,
        Lei Cao <lei.cao@stratus.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Date:   Fri, 21 May 2021 07:45:23 -0700
In-Reply-To: <20210521085849.37676-8-joerichey94@gmail.com>
References: <20210520104343.317119-1-joerichey94@gmail.com>
         <20210521085849.37676-1-joerichey94@gmail.com>
         <20210521085849.37676-8-joerichey94@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.40
X-Stat-Signature: qn5g8k3jtqoj4kuui4tsua91y1s1o8zk
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 74ED713D95
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/+/DrG8NEx+1xztaZeFya67FR2cEwvbqU=
X-HE-Tag: 1621608325-902736
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-05-21 at 01:58 -0700, Joe Richey wrote:
> From: Joe Richey <joerichey@google.com>
> 
> Instead of just ignoring UAPI headers, reccomend the UAPI compatible
> macros if a user adds something that looks like (1 << n). Normal kernel
> code will continue to get BIT_ULL() and BIT() reccomended.
> 
> This change also modifies the $realfile regex to match headers that have
> "include/uapi" anywhere in their path so paths like:
>     tools/include/uapi/linux/kvm.h
>     arch/x86/include/uapi/asm/hwcap2.h
> get recognized as UAPI headers.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -7020,15 +7020,17 @@ sub process {
>  			}
>  		}
>  
> 
> -# check for #defines like: 1 << <digit> that could be BIT(digit), it is not exported to uapi
> -		if ($realfile !~ m@^include/uapi/@ &&
> -		    $line =~ /#\s*define\s+\w+\s+\(?\s*1\s*([ulUL]*)\s*\<\<\s*(?:\d+|$Ident)\s*\)?/) {
> -			my $ull = "";
> -			$ull = "_ULL" if (defined($1) && $1 =~ /ll/i);
> +# check for #defines like: 1 << <digit> that could be BIT(digit) or similar
> +		if ($line =~ /#\s*define\s+\w+\s+\(?\s*1\s*([ulUL]*)\s*\<\<\s*(?:\d+|$Ident)\s*\)?/) {
> +			my $ull = (defined($1) && $1 =~ /ll/i);
> +			my $macroname = $ull ? "BIT_ULL" : "BIT";
> +			if ($realfile =~ m@include/uapi/@) {

Likely better with \b
			if ($realfile =~ m@\binclude/uapi/@) {

> +				$macroname = $ull ? "_BITULL" : "_BITUL";
> +			}
>  			if (CHK("BIT_MACRO",
> -				"Prefer using the BIT$ull macro\n" . $herecurr) &&
> +				"Prefer using the $macroname macro\n" . $herecurr) &&
>  			    $fix) {
> -				$fixed[$fixlinenr] =~ s/\(?\s*1\s*[ulUL]*\s*<<\s*(\d+|$Ident)\s*\)?/BIT${ull}($1)/;
> +				$fixed[$fixlinenr] =~ s/\(?\s*1\s*[ulUL]*\s*<<\s*(\d+|$Ident)\s*\)?/${macroname}($1)/;

Doesn't need braces
				$fixed[$fixlinenr] =~ s/\(?\s*1\s*[ulUL]*\s*<<\s*(\d+|$Ident)\s*\)?/$macroname($1)/;

Otherwise, fine by me.

