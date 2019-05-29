Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFB22D62B
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 09:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfE2HVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 03:21:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbfE2HVu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 May 2019 03:21:50 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4T7JGph046882
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 03:21:49 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ssmbdu1b9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 03:21:49 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <rppt@linux.ibm.com>;
        Wed, 29 May 2019 08:21:46 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 29 May 2019 08:21:41 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4T7LeBG14745774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 07:21:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05A7111C05E;
        Wed, 29 May 2019 07:21:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E86011C04C;
        Wed, 29 May 2019 07:21:38 +0000 (GMT)
Received: from rapoport-lnx (unknown [9.148.8.53])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 29 May 2019 07:21:38 +0000 (GMT)
Date:   Wed, 29 May 2019 10:21:37 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 43/62] syscall/x86: Wire up a system call for MKTME
 encryption keys
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-44-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-44-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-GCONF: 00
x-cbid: 19052907-0012-0000-0000-000003207EE0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052907-0013-0000-0000-0000215948FF
Message-Id: <20190529072136.GD3656@rapoport-lnx>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290049
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:44:03PM +0300, Kirill A. Shutemov wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> encrypt_mprotect() is a new system call to support memory encryption.
> 
> It takes the same parameters as legacy mprotect, plus an additional
> key serial number that is mapped to an encryption keyid.

Shouldn't this patch be after the encrypt_mprotect() is added?
 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/entry/syscalls/syscall_32.tbl | 1 +
>  arch/x86/entry/syscalls/syscall_64.tbl | 1 +
>  include/linux/syscalls.h               | 2 ++
>  include/uapi/asm-generic/unistd.h      | 4 +++-
>  kernel/sys_ni.c                        | 2 ++
>  5 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
> index 1f9607ed087c..dbcd4c28d743 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> @@ -433,3 +433,4 @@
>  425	i386	io_uring_setup		sys_io_uring_setup		__ia32_sys_io_uring_setup
>  426	i386	io_uring_enter		sys_io_uring_enter		__ia32_sys_io_uring_enter
>  427	i386	io_uring_register	sys_io_uring_register		__ia32_sys_io_uring_register
> +428	i386	encrypt_mprotect	sys_encrypt_mprotect		__ia32_sys_encrypt_mprotect
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
> index 92ee0b4378d4..d01bd132e9ee 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -349,6 +349,7 @@
>  425	common	io_uring_setup		__x64_sys_io_uring_setup
>  426	common	io_uring_enter		__x64_sys_io_uring_enter
>  427	common	io_uring_register	__x64_sys_io_uring_register
> +428	common	encrypt_mprotect	__x64_sys_encrypt_mprotect
> 
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index e446806a561f..38a2d7b95397 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -988,6 +988,8 @@ asmlinkage long sys_rseq(struct rseq __user *rseq, uint32_t rseq_len,
>  asmlinkage long sys_pidfd_send_signal(int pidfd, int sig,
>  				       siginfo_t __user *info,
>  				       unsigned int flags);
> +asmlinkage long sys_encrypt_mprotect(unsigned long start, size_t len,
> +				     unsigned long prot, key_serial_t serial);
> 
>  /*
>   * Architecture-specific system calls
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index dee7292e1df6..86f942f54b1b 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -832,9 +832,11 @@ __SYSCALL(__NR_io_uring_setup, sys_io_uring_setup)
>  __SYSCALL(__NR_io_uring_enter, sys_io_uring_enter)
>  #define __NR_io_uring_register 427
>  __SYSCALL(__NR_io_uring_register, sys_io_uring_register)
> +#define __NR_encrypt_mprotect 428
> +__SYSCALL(__NR_encrypt_mprotect, sys_encrypt_mprotect)
> 
>  #undef __NR_syscalls
> -#define __NR_syscalls 428
> +#define __NR_syscalls 429
> 
>  /*
>   * 32 bit systems traditionally used different
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index d21f4befaea4..80da8d9ac8b1 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -350,6 +350,8 @@ COND_SYSCALL(pkey_mprotect);
>  COND_SYSCALL(pkey_alloc);
>  COND_SYSCALL(pkey_free);
> 
> +/* multi-key total memory encryption keys */
> +COND_SYSCALL(encrypt_mprotect);
> 
>  /*
>   * Architecture specific weak syscall entries.
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

