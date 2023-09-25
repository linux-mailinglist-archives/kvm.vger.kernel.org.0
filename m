Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5C67ADCBF
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 18:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbjIYQJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 12:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbjIYQJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 12:09:07 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EA6FB;
        Mon, 25 Sep 2023 09:09:00 -0700 (PDT)
Received: from [127.0.0.1] ([99.8.153.148])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 38PG7vwg1512316
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 25 Sep 2023 09:07:58 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 38PG7vwg1512316
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023091101; t=1695658079;
        bh=D4dkY7ib239sJgAi09Fyq922U7t4CmCadoRO6xTmuuw=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=m+YYgtMYbvG0oSi6qazn8+RQFHlQXxy4UY2F0Rjs+LlWVTXbJbLPUJNxUdaSMUJq+
         b7/To74zymNcjg+EeY5RtIp7nST07IEQfhIeHothUwS4zDyLxItkTUc7ZPCdMuN6BB
         QRaFihbHEYpIbAfr/55Q5ZC5HWI0PCGLeubKxlwLdb8R4e9SC2t4rY7hPGQxGO8Nii
         qQxaxc6FPDuDh2d7sdIIUuXNsw+noU3Xhr4VJg/M8+Fd03my+G3N4jdPz6q+N1Fzm2
         kZF9LFH7Je5OllJOyYS8lR7SKuvShm49bOICGyBzUkB+iYLoG0co28aUJ0lbcNNhc1
         sdrrP/d4qsEWQ==
Date:   Mon, 25 Sep 2023 09:07:47 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
CC:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, luto@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, peterz@infradead.org,
        jgross@suse.com, ravi.v.shankar@intel.com, mhiramat@kernel.org,
        andrew.cooper3@citrix.com, jiangshanlai@gmail.com,
        nik.borisov@suse.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v11_35/37=5D_x86/syscall=3A_Split_ID?= =?US-ASCII?Q?T_syscall_setup_code_into_idt=5Fsyscall=5Finit=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20230923094212.26520-36-xin3.li@intel.com>
References: <20230923094212.26520-1-xin3.li@intel.com> <20230923094212.26520-36-xin3.li@intel.com>
Message-ID: <D4167CD5-B619-448D-B660-24ABC0786E0A@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On September 23, 2023 2:42:10 AM PDT, Xin Li <xin3=2Eli@intel=2Ecom> wrote:
>Because FRED uses the ring 3 FRED entrypoint for SYSCALL and SYSENTER and
>ERETU is the only legit instruction to return to ring 3, there is NO need
>to setup SYSCALL and SYSENTER MSRs for FRED, except the IA32_STAR MSR=2E
>
>Split IDT syscall setup code into idt_syscall_init() to make it easy to
>skip syscall setup code when FRED is enabled=2E
>
>Suggested-by: Thomas Gleixner <tglx@linutronix=2Ede>
>Tested-by: Shan Kang <shan=2Ekang@intel=2Ecom>
>Signed-off-by: Xin Li <xin3=2Eli@intel=2Ecom>
>---
> arch/x86/kernel/cpu/common=2Ec | 13 ++++++++++---
> 1 file changed, 10 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kernel/cpu/common=2Ec b/arch/x86/kernel/cpu/common=
=2Ec
>index 20bbedbf6dcb=2E=2E2ee4e7b597a3 100644
>--- a/arch/x86/kernel/cpu/common=2Ec
>+++ b/arch/x86/kernel/cpu/common=2Ec
>@@ -2071,10 +2071,8 @@ static void wrmsrl_cstar(unsigned long val)
> 		wrmsrl(MSR_CSTAR, val);
> }
>=20
>-/* May not be marked __init: used by software suspend */
>-void syscall_init(void)
>+static inline void idt_syscall_init(void)
> {
>-	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
> 	wrmsrl(MSR_LSTAR, (unsigned long)entry_SYSCALL_64);
>=20
> 	if (ia32_enabled()) {
>@@ -2108,6 +2106,15 @@ void syscall_init(void)
> 	       X86_EFLAGS_AC|X86_EFLAGS_ID);
> }
>=20
>+/* May not be marked __init: used by software suspend */
>+void syscall_init(void)
>+{
>+	/* The default user and kernel segments */
>+	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
>+
>+	idt_syscall_init();
>+}
>+
> #else	/* CONFIG_X86_64 */
>=20
> #ifdef CONFIG_STACKPROTECTOR

Am I missing something, or is this patch a noop?
