Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353F94439B1
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 00:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhKBXaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 19:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbhKBXaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 19:30:03 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EB2C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 16:27:28 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id oa4so22024pjb.2
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 16:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W5DJlOh3hc+L8UjfPHNMx8D9ADIs8nP6bivHGdFJhmQ=;
        b=OLtXu6A73oWqce3ybzNuXpwiLk/iDks0iFv04fDgsj40qPWxwaYDxOfX5UV36TMYKA
         t/kRcBCd3aMnD0Kv9uq/l453YlsEpKwCIp27LjqPz5G39ubGXe7HZt4KGzfPjYGmWIiA
         Wud8YPkf2fLaJROp5qXY7mY/1GAFz1e28OqKnvp8VZJsuoXw/W7AGzxseA0zeJXWh7mQ
         yrnqSOIbDwaYNi9QJ6DMjj6Xl5M7FsTcPxCN7etYXqFGlyZooQs+zXm8AVkTo+9gh9hV
         qfRa+JtF3VGBCqlle5U5wWaO+JCMSZjF+XLmqzNgL5h30+LhSQyTWWChuA15khCIHjzM
         MRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W5DJlOh3hc+L8UjfPHNMx8D9ADIs8nP6bivHGdFJhmQ=;
        b=p5hOilI3rjBwPnQDAOaoBYeo+UdRz2+rA66Do7u4P51YIEUPzr+xTm5frB+HrbUL6f
         CiWGaGah+MurfURzqXRBcoVlGaVuqAC6RNDMygc97jEvpm1UuhRt6eY84INnQ8qwtPHJ
         KgGpmadbJd/XI3LjrZURTYsMMOK913E9UF311ztGp4I5xiKA/kvriem85gGnYxnaHOfq
         f0eokwTOkLsx97a1zqzjsk1v0FDipFpCCT2OxMwZrtPet3t8jeBnuo+CJaYB7cWtecze
         BcsYw/2631vCfuhi97uQuA82nB4suE9eR7j7FpfnemR2cUepxqppEmIG6ZoQu9lGQUTx
         /tHw==
X-Gm-Message-State: AOAM532ZNV8AgPoh74Ou3TYTcJcjOuS6ITn9s3bCeW72jVBYnRCK+5yt
        krmUct1zzCgON8Ane62rCrrA1w==
X-Google-Smtp-Source: ABdhPJxJ0u+5qjuTDRbt7W7Gi1WSmYimwJOgsAUpXwrl9xRmgHuTximZeUjOV+f3QmnCpf6OyycfAQ==
X-Received: by 2002:a17:902:8690:b0:13f:ffd6:6c63 with SMTP id g16-20020a170902869000b0013fffd66c63mr34791324plo.23.1635895647396;
        Tue, 02 Nov 2021 16:27:27 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id f2sm248924pfj.99.2021.11.02.16.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 16:27:26 -0700 (PDT)
Date:   Tue, 2 Nov 2021 16:27:22 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 6/6] selftests: KVM: Test OS lock behavior
Message-ID: <YYHJWmQ+RmNZ51dM@google.com>
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-7-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102094651.2071532-7-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021 at 09:46:51AM +0000, Oliver Upton wrote:
> KVM now correctly handles the OS Lock for its guests. When set, KVM
> blocks all debug exceptions originating from the guest. Add test cases
> to the debug-exceptions test to assert that software breakpoint,
> hardware breakpoint, watchpoint, and single-step exceptions are in fact
> blocked.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++++++-
>  1 file changed, 56 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index e5e6c92b60da..6b6ff81cdd23 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -23,7 +23,7 @@
>  #define SPSR_D		(1 << 9)
>  #define SPSR_SS		(1 << 21)
>  
> -extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
> +extern unsigned char sw_bp, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
>  static volatile uint64_t sw_bp_addr, hw_bp_addr;
>  static volatile uint64_t wp_addr, wp_data_addr;
>  static volatile uint64_t svc_addr;
> @@ -47,6 +47,14 @@ static void reset_debug_state(void)
>  	isb();
>  }
>  
> +static void enable_os_lock(void)
> +{
> +	write_sysreg(oslar_el1, 1);

should be: write_sysreg(val, reg);

> +	isb();
> +
> +	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
> +}
> +
>  static void install_wp(uint64_t addr)
>  {
>  	uint32_t wcr;
> @@ -99,6 +107,7 @@ static void guest_code(void)
>  	GUEST_SYNC(0);
>  
>  	/* Software-breakpoint */
> +	reset_debug_state();
>  	asm volatile("sw_bp: brk #0");
>  	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp));
>  
> @@ -152,6 +161,51 @@ static void guest_code(void)
>  	GUEST_ASSERT_EQ(ss_addr[1], PC(ss_start) + 4);
>  	GUEST_ASSERT_EQ(ss_addr[2], PC(ss_start) + 8);
>  
> +	GUEST_SYNC(6);
> +
> +	/* OS Lock blocking software-breakpoint */
> +	reset_debug_state();
> +	enable_os_lock();
> +	sw_bp_addr = 0;
> +	asm volatile("brk #0");
> +	GUEST_ASSERT_EQ(sw_bp_addr, 0);
> +
> +	GUEST_SYNC(7);
> +
> +	/* OS Lock blocking hardware-breakpoint */
> +	reset_debug_state();
> +	enable_os_lock();
> +	install_hw_bp(PC(hw_bp2));
> +	hw_bp_addr = 0;
> +	asm volatile("hw_bp2: nop");
> +	GUEST_ASSERT_EQ(hw_bp_addr, 0);
> +
> +	GUEST_SYNC(8);
> +
> +	/* OS Lock blocking watchpoint */
> +	reset_debug_state();
> +	enable_os_lock();
> +	write_data = '\0';
> +	wp_data_addr = 0;
> +	install_wp(PC(write_data));
> +	write_data = 'x';
> +	GUEST_ASSERT_EQ(write_data, 'x');
> +	GUEST_ASSERT_EQ(wp_data_addr, 0);
> +
> +	GUEST_SYNC(9);
> +
> +	/* OS Lock blocking single-step */
> +	reset_debug_state();
> +	enable_os_lock();
> +	ss_addr[0] = 0;
> +	install_ss();
> +	ss_idx = 0;
> +	asm volatile("mrs x0, esr_el1\n\t"
> +		     "add x0, x0, #1\n\t"
> +		     "msr daifset, #8\n\t"
> +		     : : : "x0");
> +	GUEST_ASSERT_EQ(ss_addr[0], 0);
> +
>  	GUEST_DONE();
>  }
>  
> @@ -223,7 +277,7 @@ int main(int argc, char *argv[])
>  	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
>  				ESR_EC_SVC64, guest_svc_handler);
>  
> -	for (stage = 0; stage < 7; stage++) {
> +	for (stage = 0; stage < 11; stage++) {
>  		vcpu_run(vm, VCPU_ID);
>  
>  		switch (get_ucall(vm, VCPU_ID, &uc)) {
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
